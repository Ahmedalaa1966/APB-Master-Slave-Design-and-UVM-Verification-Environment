`ifndef APB_BASE_SEQ_SV
`define APB_BASE_SEQ_SV

class apb_base_seq extends uvm_sequence #(apb_sequence_item);

  `uvm_object_utils(apb_base_seq)

  function new(string name = "apb_base_seq");
    super.new(name);
  endfunction

  // ---------------- helper: one write ----------------
  task write_data(bit [7:0] addr, bit [31:0] data);
    apb_sequence_item trn = apb_sequence_item::type_id::create("trn");
    start_item(trn);
    if (!trn.randomize() with { wr_en    == 1;
                                addr_in  == addr;
                                wdata_in == data; })
      `uvm_fatal("SEQ", "randomize failed (write)")
    finish_item(trn);
  endtask

  // ---------------- helper: one read ----------------
  task read_data(bit [7:0] addr);
    apb_sequence_item trn = apb_sequence_item::type_id::create("trn");
    start_item(trn);
    if (!trn.randomize() with { wr_en   == 0;
                                addr_in == addr; })
      `uvm_fatal("SEQ", "randomize failed (read)")
    finish_item(trn);
  endtask

  // ---------------- helper: write then read back the same address ----------------
  task write_then_read(bit [7:0] addr, bit [31:0] data);
    write_data(addr, data);
    read_data(addr);
  endtask

  // body is left empty: derived sequences override it
  virtual task body();
  endtask

endclass

`endif