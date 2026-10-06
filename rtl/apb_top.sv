// APB Top Wrapper
// Connects apb_master to apb_slave. User-side signals are exposed at the top.
module apb_top #(
  parameter ADDR_W = 8,
  parameter DATA_W = 32
)(
  input  logic              pclk,
  input  logic              presetn,

  // User side (drives the master)
  input  logic              transfer,
  input  logic              wr_en,
  input  logic [ADDR_W-1:0] addr_in,
  input  logic [DATA_W-1:0] wdata_in,
  output logic [DATA_W-1:0] rdata_out,
  output logic              done
);

  // Internal APB bus
  logic [ADDR_W-1:0] paddr;
  logic              psel;
  logic              penable;
  logic              pwrite;
  logic [DATA_W-1:0] pwdata;
  logic              pready;
  logic [DATA_W-1:0] prdata;

  apb_master #(
    .ADDR_W (ADDR_W),
    .DATA_W (DATA_W)
  ) u_master (
    .pclk      (pclk),
    .presetn   (presetn),
    .paddr     (paddr),
    .psel      (psel),
    .penable   (penable),
    .pwrite    (pwrite),
    .pwdata    (pwdata),
    .pready    (pready),
    .prdata    (prdata),
    .transfer  (transfer),
    .wr_en     (wr_en),
    .addr_in   (addr_in),
    .wdata_in  (wdata_in),
    .rdata_out (rdata_out),
    .done      (done)
  );

  apb_slave #(
    .ADDR_W (ADDR_W),
    .DATA_W (DATA_W)
  ) u_slave (
    .pclk    (pclk),
    .presetn (presetn),
    .paddr   (paddr),
    .psel    (psel),
    .penable (penable),
    .pwrite  (pwrite),
    .pwdata  (pwdata),
    .pready  (pready),
    .prdata  (prdata)
  );

endmodule