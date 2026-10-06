`ifndef APB_SWEEP_ADDRESS_TEST_SV
`define APB_SWEEP_ADDRESS_TEST_SV

class apb_sweep_address_test extends apb_base_test;

  `uvm_component_utils(apb_sweep_address_test)

  function new(string name = "apb_sweep_address_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    apb_sweep_address_seq seq = apb_sweep_address_seq::type_id::create("seq");

    phase.raise_objection(this);
    `uvm_info("TEST", "Starting apb_sweep_address_seq", UVM_LOW)
    seq.start(env.agent.sqrh);
    #100ns;
    phase.drop_objection(this);
  endtask

endclass

`endif