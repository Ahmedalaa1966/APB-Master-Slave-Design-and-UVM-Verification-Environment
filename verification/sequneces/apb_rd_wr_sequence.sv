`ifndef APB_RD_WR_SEQUENCE_SV
`define APB_RD_WR_SEQUENCE_SV

class apb_rd_wr_seq extends apb_base_seq;

  `uvm_object_utils(apb_rd_wr_seq)

  int unsigned num_trans = 100;

  function new(string name = "apb_rd_wr_seq");
    super.new(name);
  endfunction

  virtual task body();
    bit [7:0]  addr;
    bit [31:0] data;

    repeat (num_trans) begin
      addr = $urandom();
      data = $urandom();
      `uvm_info("SEQ", $sformatf("write_then_read addr=0x%0h data=0x%0h", addr, data), UVM_MEDIUM)
      write_then_read(addr, data);
    end
  endtask

endclass

`endif