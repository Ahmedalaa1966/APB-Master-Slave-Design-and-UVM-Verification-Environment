`ifndef APB_ALL_TEST_SV
`define APB_ALL_TEST_SV

class apb_all_test extends apb_base_test;

  `uvm_component_utils(apb_all_test)

  virtual apb_interface vif;

  function new(string name = "apb_all_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif))
      `uvm_fatal("TEST", "virtual interface not received")
  endfunction

  virtual task run_phase(uvm_phase phase);
    apb_rd_wr_seq         s_rd_wr    = apb_rd_wr_seq        ::type_id::create("s_rd_wr");
    apb_sweep_address_seq s_sweep    = apb_sweep_address_seq::type_id::create("s_sweep");
    apb_corner_seq        s_corner   = apb_corner_seq       ::type_id::create("s_corner");
    apb_data_pattern_seq  s_pattern  = apb_data_pattern_seq ::type_id::create("s_pattern");
    apb_overwrite_seq     s_overwr   = apb_overwrite_seq    ::type_id::create("s_overwr");
    apb_neighbor_seq      s_neighbor = apb_neighbor_seq     ::type_id::create("s_neighbor");
    apb_alias_seq         s_alias    = apb_alias_seq        ::type_id::create("s_alias");
    apb_back_to_back_seq  s_b2b      = apb_back_to_back_seq ::type_id::create("s_b2b");
    apb_random_seq        s_random   = apb_random_seq       ::type_id::create("s_random");
    phase.raise_objection(this);

    `uvm_info("TEST", "Running apb_rd_wr_seq", UVM_LOW)
    s_rd_wr.start(env.agent.sqrh);

    `uvm_info("TEST", "Running apb_sweep_address_seq", UVM_LOW)
    s_sweep.start(env.agent.sqrh);

    `uvm_info("TEST", "Running apb_corner_seq", UVM_LOW)
    s_corner.start(env.agent.sqrh);

    `uvm_info("TEST", "Running apb_data_pattern_seq", UVM_LOW)
    s_pattern.start(env.agent.sqrh);

    `uvm_info("TEST", "Running apb_overwrite_seq", UVM_LOW)
    s_overwr.start(env.agent.sqrh);

    `uvm_info("TEST", "Running apb_neighbor_seq", UVM_LOW)
    s_neighbor.start(env.agent.sqrh);

    `uvm_info("TEST", "Running apb_alias_seq", UVM_LOW)
    s_alias.start(env.agent.sqrh);

    `uvm_info("TEST", "Running apb_back_to_back_seq", UVM_LOW)
    s_b2b.start(env.agent.sqrh);

    `uvm_info("TEST", "Running apb_random_seq", UVM_LOW)
    s_random.start(env.agent.sqrh);


    

    #100ns;
    phase.drop_objection(this);
  endtask

endclass

`endif