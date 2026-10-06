// Simple APB Slave (not full-spec)
// 16 x 32-bit memory, word addressed with paddr[5:2]
// Inserts one wait state per transfer
module apb_slave #(
  parameter ADDR_W = 8,
  parameter DATA_W = 32
)(
  input  logic              pclk,
  input  logic              presetn,
  input  logic [ADDR_W-1:0] paddr,
  input  logic              psel,
  input  logic              penable,
  input  logic              pwrite,
  input  logic [DATA_W-1:0] pwdata,
  output logic              pready,
  output logic [DATA_W-1:0] prdata
);

  logic [DATA_W-1:0] mem [0:15];
  wire  [3:0]        idx = paddr[5:2];

  // One wait state: pready rises one cycle after ACCESS starts,
  // then drops after the transfer completes
  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) pready <= 1'b0;
    else          pready <= psel && penable && !pready;
  end

  // Write on the cycle the transfer completes
  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      for (int i = 0; i < 16; i++) mem[i] <= '0;
    end else if (psel && penable && pready && pwrite) begin
      mem[idx] <= pwdata;
    end
  end

  // Read data (combinational)
  assign prdata = mem[idx];

endmodule