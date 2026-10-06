`ifndef APB_TEST_PKG_SV
`define APB_TEST_PKG_SV

package apb_test_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import apb_env_pkg::*;
  import apb_seq_pkg::*;

  `include "apb_base_test.sv"
  `include "apb_rd_wr_test.sv"
  `include "apb_sweep_address_test.sv"
  `include "apb_all_tests.sv"

endpackage

`endif