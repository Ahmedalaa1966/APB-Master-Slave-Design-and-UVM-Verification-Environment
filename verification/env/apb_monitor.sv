`ifndef APB_MONITOR_SV
`define APB_MONITOR_SV

class apb_monitor extends uvm_monitor;

  `uvm_component_utils(apb_monitor)

  uvm_analysis_port #(apb_sequence_item) mon_ap;
  virtual apb_interface vif;

  function new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap = new("mon_ap", this);
    // get the virtual interface from the top through the config db
    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif))
      `uvm_fatal("MONITOR", "virtual interface not received")
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    collect_transaction();
  endtask

  task collect_transaction();
  apb_sequence_item trn;
  bit done_prev = 0;

  forever begin
    @(vif.mon_cb);

    if (vif.mon_cb.presetn && vif.mon_cb.done && !done_prev) begin
      trn = apb_sequence_item::type_id::create("trn");
      trn.wr_en    = vif.mon_cb.wr_en;
      trn.addr_in  = vif.mon_cb.addr_in;
      trn.wdata_in = vif.mon_cb.wdata_in;

      @(vif.mon_cb);                          // rdata_out is valid one clock after done
      trn.rdata_out = vif.mon_cb.rdata_out;

      `uvm_info("MONITOR", $sformatf("%s addr=0x%0h wdata=0x%0h rdata=0x%0h",
                trn.wr_en ? "WRITE" : "READ ",
                trn.addr_in, trn.wdata_in, trn.rdata_out), UVM_LOW)
      mon_ap.write(trn);
    end

    done_prev = vif.mon_cb.done;
  end
endtask

endclass

`endif