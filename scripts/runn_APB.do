# run_all.do

# ---------------- settings ----------------
set tests {apb_rd_wr_test apb_sweep_address_test apb_corner_test apb_data_pattern_test \
           apb_overwrite_test apb_neighbor_test apb_alias_test apb_back_to_back_test \
           apb_random_test }
# set tests {apb_all_test}      ;# alternative: one test that runs every sequence

set use_gui 1       ;# 1 = the last test stays open in the GUI with its waveform

# ---------------- logs ----------------
file mkdir logs
transcript file logs/transcript.log

# ---------------- work library ----------------
if {[file exists work]} { vdel -lib work -all }
vlib work

# ---------------- compile ----------------
# design with code coverage
vlog -sv -cover bcesft rtl/master.sv rtl/slave.sv rtl/apb_top.sv

# testbench (order matters, no code coverage here)
vlog -sv +incdir+. rtl/apb_interface.sv
vlog -sv +incdir+. verification/env/apb_env_pkg.sv
vlog -sv +incdir+. verification/sequence/apb_sequence_pkg.sv
vlog -sv +incdir+. verification/test/apb_test_pkg.sv
vlog -sv +incdir+. verification/top/apb_tb.sv

# ---------------- run each test ----------------
set ucdb_list {}
set last_test [lindex $tests end]

foreach t $tests {
  if {$use_gui} {
    vsim -coverage -onfinish stop work.tb_top +UVM_TESTNAME=$t +UVM_VERBOSITY=UVM_LOW
    do wave.do
  } else {
    vsim -c -coverage -onfinish stop work.tb_top +UVM_TESTNAME=$t +UVM_VERBOSITY=UVM_LOW
  }

  run -all

  coverage save logs/$t.ucdb
  lappend ucdb_list logs/$t.ucdb

  # close every simulation, except the last one when the GUI is used
  if {!$use_gui || $t ne $last_test} { quit -sim }
}

# ---------------- merge all tests ----------------
exec vcover merge -out logs/merged.ucdb {*}$ucdb_list

# functional coverage (covergroups), merged
exec vcover report -cvg -details -output logs/func_cov_report.txt logs/merged.ucdb

# code coverage (RTL), merged
exec vcover report -code bcesft -details -output logs/code_cov_report.txt logs/merged.ucdb

# total summary on the screen
puts [exec vcover report -summary logs/merged.ucdb]

