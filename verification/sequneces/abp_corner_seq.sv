class apb_corner_seq extends apb_base_seq;
  `uvm_object_utils(apb_corner_seq)

  function new(string name = "apb_corner_seq");
    super.new(name);
  endfunction

  virtual task body();
    bit [7:0]  addrs [8] = '{8'h00, 8'h01, 8'h3F, 8'h40, 8'hBF, 8'hC0, 8'hFE, 8'hFF};
    bit [31:0] datas [4] = '{32'h0000_0000, 32'hFFFF_FFFF, 32'hAAAA_AAAA, 32'h5555_5555};

    foreach (addrs[i])
      foreach (datas[j])
        write_then_read(addrs[i], datas[j]);
  endtask
endclass