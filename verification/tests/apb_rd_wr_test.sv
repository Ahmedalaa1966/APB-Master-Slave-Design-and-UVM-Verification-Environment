`ifndef APB_RD_WR_TEST_SV
`define APB_RD_WR_TEST_SV

class apb_rd_wr_test extends apb_base_test;

  `uvm_component_utils(apb_rd_wr_test)

  function new(string name = "apb_rd_wr_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    apb_rd_wr_seq seq = apb_rd_wr_seq::type_id::create("seq");
    seq.num_trans = 100;                       // optional: number of write/read pairs

    phase.raise_objection(this);
    `uvm_info("TEST", "Starting apb_rd_wr_seq", UVM_LOW)
    seq.start(env.agent.sqrh);
    #100ns;                                   // let the last transfer finish
    phase.drop_objection(this);
  endtask

endclass

`endif