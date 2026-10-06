`timescale 1ns/1ps
`ifndef APB_INTERFACE_SV
`define APB_INTERFACE_SV

interface apb_interface #(parameter ADDR_W = 8, parameter DATA_W = 32) (input logic pclk);

  logic              presetn;
  logic              transfer;
  logic              wr_en;
  logic [ADDR_W-1:0] addr_in;
  logic [DATA_W-1:0] wdata_in;
  logic [DATA_W-1:0] rdata_out;
  logic              done;

  // driver clocking block: drives requests, samples results
  clocking drv_cb @(posedge pclk);
    default input #1step output #1;
    output transfer, wr_en, addr_in, wdata_in;
    input  rdata_out, done;
  endclocking

  // monitor clocking block: samples everything, drives nothing
  clocking mon_cb @(posedge pclk);
    default input #1step;
    input presetn,transfer, wr_en, addr_in, wdata_in, rdata_out, done;
  endclocking

endinterface

`endif