class apb_back_to_back_seq extends apb_base_seq;
  `uvm_object_utils(apb_back_to_back_seq)

  function new(string name = "apb_back_to_back_seq");
    super.new(name);
  endfunction

  virtual task body();
    // write, write, write, read, read, read
    for (int i = 0; i < 4; i++) write_data(i*4, $urandom());
    for (int i = 0; i < 4; i++) read_data (i*4);
    // alternating write and read
    for (int i = 4; i < 8; i++) begin
      write_data(i*4, $urandom());
      read_data (i*4);
    end
  endtask
endclass