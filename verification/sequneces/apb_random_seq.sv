class apb_random_seq extends apb_base_seq;
  `uvm_object_utils(apb_random_seq)

  int unsigned num_trans = 200;

  function new(string name = "apb_random_seq");
    super.new(name);
  endfunction

  virtual task body();
    apb_sequence_item trn;

    for (int i = 0; i < 16; i++) write_data(i*4, $urandom());

    repeat (num_trans) begin
      trn = apb_sequence_item::type_id::create("trn");
      start_item(trn);
      if (!trn.randomize() with { addr_in[1:0] == 2'b00;
                                  wr_en dist {1 := 50, 0 := 50}; })
        `uvm_fatal("SEQ", "randomize failed")
      finish_item(trn);
    end
  endtask
endclass