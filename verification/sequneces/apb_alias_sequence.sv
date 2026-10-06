class apb_alias_seq extends apb_base_seq;
  `uvm_object_utils(apb_alias_seq)

  function new(string name = "apb_alias_seq");
    super.new(name);
  endfunction

  virtual task body();
    write_data(8'h04, 32'hA1A1_A1A1);
    read_data (8'h04);
    read_data (8'h05);                 // bits [1:0] ignored
    read_data (8'h07);
    read_data (8'h44);                 // bits [7:6] ignored
    read_data (8'h84);
    read_data (8'hC4);

    write_data(8'h85, 32'hB2B2_B2B2);  // write through an alias
    read_data (8'h04);                 // expect B2B2_B2B2
  endtask
endclass