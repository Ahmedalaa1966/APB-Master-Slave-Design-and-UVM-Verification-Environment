class apb_overwrite_seq extends apb_base_seq;
  `uvm_object_utils(apb_overwrite_seq)

  function new(string name = "apb_overwrite_seq");
    super.new(name);
  endfunction

  virtual task body();
    write_data(8'h10, 32'h1111_1111);
    write_data(8'h10, 32'h2222_2222);
    write_data(8'h10, 32'h3333_3333);
    read_data (8'h10);                 // expect 3333_3333
    repeat (4) read_data(8'h10);       // repeated reads stay stable
  endtask
endclass