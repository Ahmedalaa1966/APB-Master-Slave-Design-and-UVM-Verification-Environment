`ifndef APB_SWEEP_ADDRESS_SEQ_SV
`define APB_SWEEP_ADDRESS_SEQ_SV

class apb_sweep_address_seq extends apb_base_seq;

  `uvm_object_utils(apb_sweep_address_seq)

  int unsigned step = 4;     // 4 = word addresses, 1 = every address

  function new(string name = "apb_sweep_address_seq");
    super.new(name);
  endfunction

  virtual task body();
    bit [7:0]  addr;
    bit [31:0] data;

    // write phase: unique data for every address
    for (int a = 0; a < 256; a += step) begin
      addr = a;
      data = {addr, ~addr, addr, ~addr};
      `uvm_info("SEQ", $sformatf("WRITE addr=0x%0h data=0x%0h", addr, data), UVM_MEDIUM)
      write_data(addr, data);
    end

    // read phase: read every address back
    for (int a = 0; a < 256; a += step) begin
      addr = a;
      `uvm_info("SEQ", $sformatf("READ addr=0x%0h", addr), UVM_MEDIUM)
      read_data(addr);
    end
  endtask

endclass

`endif