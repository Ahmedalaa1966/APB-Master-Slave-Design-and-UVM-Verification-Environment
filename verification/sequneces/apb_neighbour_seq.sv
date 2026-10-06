class apb_neighbor_seq extends apb_base_seq;
  `uvm_object_utils(apb_neighbor_seq)

  function new(string name = "apb_neighbor_seq");
    super.new(name);
  endfunction

  virtual task body();
    write_data(8'h20, 32'hDEAD_BEEF);
    write_data(8'h24, 32'hCAFE_F00D);
    write_data(8'h28, 32'h0BAD_C0DE);
    read_data (8'h24);
    write_data(8'h24, 32'h1234_5678);  // change the middle word only
    read_data (8'h20);                 // neighbours must be unchanged
    read_data (8'h24);
    read_data (8'h28);
  endtask
endclass