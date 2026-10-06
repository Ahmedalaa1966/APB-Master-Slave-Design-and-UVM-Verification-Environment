`timescale 1ns/1ps

module tb_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import apb_env_pkg::*;
  import apb_test_pkg::*;

  parameter ADDR_W     = 8;
  parameter DATA_W     = 32;
  parameter CLK_PERIOD = 10;

  logic pclk = 0;
  always #(CLK_PERIOD/2) pclk = ~pclk;

  apb_interface #(.ADDR_W(ADDR_W), .DATA_W(DATA_W)) vif (pclk);

  apb_top #(.ADDR_W(ADDR_W), .DATA_W(DATA_W)) dut (
    .pclk      (pclk),
    .presetn   (vif.presetn),
    .transfer  (vif.transfer),
    .wr_en     (vif.wr_en),
    .addr_in   (vif.addr_in),
    .wdata_in  (vif.wdata_in),
    .rdata_out (vif.rdata_out),
    .done      (vif.done)
  );

  initial begin
    vif.presetn = 0;
    repeat (2) @(posedge pclk);
    vif.presetn = 1;
  end

  initial begin
    uvm_config_db#(virtual apb_interface #(ADDR_W, DATA_W))::set(null, "*", "vif", vif);
    run_test();
  end

endmodule