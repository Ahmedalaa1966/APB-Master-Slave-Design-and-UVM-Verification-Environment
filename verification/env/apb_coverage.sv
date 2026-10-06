`ifndef APB_COVERAGE_SV
`define APB_COVERAGE_SV

class apb_coverage extends uvm_component;

  `uvm_component_utils(apb_coverage)

  uvm_analysis_imp #(apb_sequence_item, apb_coverage) cov_ap;
  apb_sequence_item trn;

  // ---------------- covergroup ----------------
  covergroup apb_cg;
    option.per_instance = 1;

    cp_op : coverpoint trn.wr_en {
      bins write = {1};
      bins read  = {0};
    }

    cp_addr : coverpoint trn.addr_in {
      bins First_address  = {8'h00};
      bins Low_address    = {[8'h01:8'h3F]};
      bins Medium_address = {[8'h40:8'hBF]};
      bins High_address   = {[8'hC0:8'hFE]};
      bins Last_address   = {8'hFF};
    }

    cp_wdata : coverpoint trn.wdata_in iff (trn.wr_en) {
      bins all_zeros = {32'h0000_0000};
      bins all_ones  = {32'hFFFF_FFFF};
      bins alt_AA    = {32'hAAAA_AAAA};
      bins alt_55    = {32'h5555_5555};
      bins others    = default;
    }

    cp_rdata : coverpoint trn.rdata_out iff (!trn.wr_en) {
      bins all_zeros = {32'h0000_0000};
      bins all_ones  = {32'hFFFF_FFFF};
      bins others    = default;
    }

    cp_order_operation : coverpoint trn.wr_en {
      bins wr_to_rd = (1 => 0);
      bins rd_to_wr = (0 => 1);
      bins wr_to_wr = (1 => 1);
      bins rd_to_rd = (0 => 0);
    }
  endgroup

  // ---------------- constructor ----------------
  function new(string name = "apb_coverage", uvm_component parent = null);
    super.new(name, parent);
    apb_cg = new();
  endfunction

  // ---------------- build ----------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_ap = new("cov_ap", this);
  endfunction

  // ---------------- called for every monitor transaction ----------------
  virtual function void write(apb_sequence_item t);
    trn = t;
    apb_cg.sample();
  endfunction

  // ---------------- report ----------------
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COVERAGE", $sformatf("Functional coverage = %0.2f %%", apb_cg.get_inst_coverage()), UVM_NONE)
  endfunction

endclass

`endif