`ifndef APB_SCOREBOARD_SV
`define APB_SCOREBOARD_SV

class apb_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(apb_scoreboard)

  uvm_analysis_imp #(apb_sequence_item, apb_scoreboard) sb_imp;

  bit check_unwritten = 0;

  int unsigned read_count, write_count;
  int unsigned pass_count, fail_count;
  int unsigned unchecked_count;

  function new(string name = "apb_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_imp = new("sb_imp", this);
  endfunction

  // this function is called by the monitor
  virtual function void write(apb_sequence_item trn);
    if (trn.wr_en)
      process_write(trn);
    else
      process_read(trn);
  endfunction

  bit [31:0] ref_mem [bit [3:0]];            // 16 words, like the slave

function void process_write(apb_sequence_item trn);
  ref_mem[trn.addr_in[5:2]] = trn.wdata_in;
  write_count++;
  `uvm_info("SCB", $sformatf("WRITE: addr=0x%0h (word %0d) data=0x%0h stored in model",
                             trn.addr_in, trn.addr_in[5:2], trn.wdata_in), UVM_MEDIUM)
endfunction

function void process_read(apb_sequence_item trn);
  bit [31:0] expected;
  read_count++;

  if (ref_mem.exists(trn.addr_in[5:2])) begin
    expected = ref_mem[trn.addr_in[5:2]];
    compare(trn, expected);
  end
  else if (check_unwritten) begin
    compare(trn, '0);
  end
  else begin
    unchecked_count++;
    `uvm_info("SCB", $sformatf("READ of never-written addr=0x%0h (not checked), got 0x%0h",
                               trn.addr_in, trn.rdata_out), UVM_MEDIUM)
  end
endfunction

  function void compare(apb_sequence_item trn, bit [31:0] expected);
    if (trn.rdata_out === expected) begin
      pass_count++;
      `uvm_info("SCB", $sformatf("PASS: addr=0x%0h expected=0x%0h actual=0x%0h",
                                 trn.addr_in, expected, trn.rdata_out), UVM_LOW)
    end
    else begin
      fail_count++;
      `uvm_error("SCB", $sformatf("FAIL: addr=0x%0h expected=0x%0h actual=0x%0h",
                                  trn.addr_in, expected, trn.rdata_out))
    end
  endfunction

  // use after a reset if your slave clears its memory
  function void model_reset();
    ref_mem.delete();
    check_unwritten = 1;
  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCB", "------------ SCOREBOARD SUMMARY ------------", UVM_NONE)
    `uvm_info("SCB", $sformatf("Writes=%0d Reads=%0d Pass=%0d Fail=%0d Unchecked=%0d",
                               write_count, read_count, pass_count, fail_count, unchecked_count), UVM_NONE)
    if (fail_count == 0 && pass_count > 0)
      `uvm_info("SCB", "*** TEST PASSED ***", UVM_NONE)
    else
      `uvm_error("SCB", "*** TEST FAILED ***")
  endfunction

endclass

`endif