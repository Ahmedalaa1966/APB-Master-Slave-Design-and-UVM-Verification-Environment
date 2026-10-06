// Simple APB Master (not full-spec)
// FSM states: IDLE -> SETUP -> ACCESS -> (SETUP | IDLE)
module apb_master #(
  parameter ADDR_W = 8,
  parameter DATA_W = 32
)(
  // APB interface
  input  logic              pclk,
  input  logic              presetn,
  output logic [ADDR_W-1:0] paddr,
  output logic              psel,
  output logic              penable,
  output logic              pwrite,
  output logic [DATA_W-1:0] pwdata,
  input  logic              pready,
  input  logic [DATA_W-1:0] prdata,

  // User side
  input  logic              transfer,   // request a transfer
  input  logic              wr_en,      // 1 = write, 0 = read
  input  logic [ADDR_W-1:0] addr_in,
  input  logic [DATA_W-1:0] wdata_in,
  output logic [DATA_W-1:0] rdata_out,  // valid when done = 1 (reads)
  output logic              done        // 1-cycle pulse at end of transfer
);

  typedef enum logic [1:0] {IDLE, SETUP, ACCESS} state_t;
  state_t state, next_state;

  // Latched request
  logic [ADDR_W-1:0] addr_q;
  logic [DATA_W-1:0] wdata_q;
  logic              write_q;

  // State register
  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) state <= IDLE;
    else          state <= next_state;
  end

  // Next-state logic
  always_comb begin
    next_state = state;
    case (state)
      IDLE: begin
        if (transfer) next_state = SETUP;
      end
      SETUP: begin
        next_state = ACCESS;
      end
      ACCESS: begin
        if (pready) begin
          if (transfer) next_state = SETUP;  // back-to-back transfer
          else          next_state = IDLE;
        end
      end
      default: next_state = IDLE;
    endcase
  end

  // Latch request when a new transfer begins; capture read data on completion
  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      addr_q    <= '0;
      wdata_q   <= '0;
      write_q   <= 1'b0;
      rdata_out <= '0;
    end else begin
      if ((state == IDLE) || (state == ACCESS && pready)) begin
        if (transfer) begin
          addr_q  <= addr_in;
          wdata_q <= wdata_in;
          write_q <= wr_en;
        end
      end
      if (state == ACCESS && pready && !write_q)
        rdata_out <= prdata;
    end
  end

  // Outputs
  assign paddr   = addr_q;
  assign pwrite  = write_q;
  assign pwdata  = wdata_q;
  assign psel    = (state == SETUP) || (state == ACCESS);
  assign penable = (state == ACCESS);
  assign done    = (state == ACCESS) && pready;

endmodule