# APB-Master-Slave-Design-and-UVM-Verification-Environment
Designed an APB master (FSM-based, with back-to-back transfers) and a 16×32-bit slave, and verified them with a UVM environment in SystemVerilog. The environment includes a driver, monitor, reference-model scoreboard and functional coverage. It was tested with write-then-read-back, corner-case and random tests, plus SVA protocol checks.
