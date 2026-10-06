`ifndef APB_SEQUENCE_ITEM_SV
`define APB_SEQUENCE_ITEM_SV

class apb_sequence_item extends uvm_sequence_item;

  `uvm_object_utils(apb_sequence_item)

  rand bit        wr_en;
  rand bit [7:0]  addr_in;
  rand bit [31:0] wdata_in;
       bit [31:0] rdata_out;    // was 1 bit

  function new(string name = "apb_sequence_item");
    super.new(name);
  endfunction

endclass

`endif