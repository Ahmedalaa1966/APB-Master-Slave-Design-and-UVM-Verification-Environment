class apb_data_pattern_seq extends apb_base_seq;
  `uvm_object_utils(apb_data_pattern_seq)

  function new(string name = "apb_data_pattern_seq");
    super.new(name);
  endfunction

  virtual task body();
    bit [31:0] one = 32'h1;

    for (int b = 0; b < 32; b++) write_then_read(8'h10, one << b);     // walking 1
    for (int b = 0; b < 32; b++) write_then_read(8'h10, ~(one << b));  // walking 0

    write_then_read(8'h10, 32'h0000_0000);
    write_then_read(8'h10, 32'hFFFF_FFFF);
    write_then_read(8'h10, 32'hAAAA_AAAA);
    write_then_read(8'h10, 32'h5555_5555);
  endtask
endclass