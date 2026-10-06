`ifndef APB_SEQ_PKG_SV
`define APB_SEQ_PKG_SV

package apb_seq_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import apb_env_pkg::*;

    `include "apb_base_sequence.sv"
    `include "apb_rd_wr_sequence.sv"
    `include "apb_sweep_address_sequence.sv"
    `include "abp_corner_seq.sv"
    `include "apb_data_pattern_seq.sv"
    `include "apb_overwrite_seq.sv"
    `include "apb_neighbour_seq.sv"
    `include "apb_alias_sequence.sv"
    `include "apb_back_to_back_seq.sv"
    `include "apb_random_seq.sv"


endpackage

`endif