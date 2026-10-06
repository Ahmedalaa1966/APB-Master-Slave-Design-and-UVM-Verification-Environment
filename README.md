# APB Master/Slave: Design and UVM Verification Environment

A SystemVerilog design of a simple AMBA APB master and slave, verified with a UVM testbench. The master is driven through a simple user-side interface, and the testbench checks the design by writing data to the slave through the master, reading it back, and comparing it against a reference model.

## Design

| Block | Description |
|-------|-------------|
| **APB master** (`master.sv`) | FSM-based master (IDLE → SETUP → ACCESS). Takes requests on a user-side interface (`transfer`, `wr_en`, `addr_in`, `wdata_in`), returns read data on `rdata_out` and signals completion with a one-cycle `done` pulse. Supports back-to-back transfers without returning to IDLE. |
| **APB slave** (`slave.sv`) | 16 x 32-bit memory, word addressed with `paddr[5:2]`. Inserts one wait state per transfer using `pready`. Reads return data combinationally. |
| **Top wrapper** (`apb_top.sv`) | Connects the master and slave over the internal APB bus and exposes only the user-side interface. |
| **Interface** (`apb_interface.sv`) | Interface used by the testbench to drive and monitor the design. |

## Verification Environment

The UVM environment drives the master's user side and checks every read against a reference memory model.

| Component | Role |
|-----------|------|
| **Sequence item** | One read or write request (direction, address, data). |
| **Sequencer / Driver** | Applies requests to the master's user interface. |
| **Monitor** | Observes completed transfers and sends them to the scoreboard and coverage. |
| **Scoreboard** | Reference model of the slave memory. Every write updates the model and every read is compared against it. |
| **Coverage** | Functional coverage collected on completed transfers. |
| **Agent / Env** | Groups the components above and connects them. |

### Sequences and Tests

| Sequence | What it checks |
|----------|----------------|
| `apb_rd_wr_sequence` | Basic write followed by read-back |
| `apb_sweep_address_sequence` | Writes and reads across all memory locations |
| `apb_overwrite_seq` | Overwriting a location and reading back the latest value |
| `apb_neighbour_seq` | Writes to one location do not disturb its neighbours |
| `apb_back_to_back_seq` | Back-to-back transfers without returning to idle |
| `apb_data_pattern_seq` | Different data patterns |
| `abp_corner_seq` | Corner cases (for example all-zeros and all-ones data) |
| `apb_alias_sequence` | Address aliasing, since only `paddr[5:2]` selects a word |
| `apb_random_seq` | Constrained-random read/write traffic |

Each sequence has a matching test, so each one is run and its coverage database is saved separately (see `logs/`).

## Project Structure

```
APB-Master-Slave-Design-and-UVM-Verification-Environment/
├── README.md
├── rtl/                          # Design
│   ├── apb_interface.sv
│   ├── apb_top.sv
│   ├── master.sv
│   └── slave.sv
├── verification/                 # UVM testbench
│   ├── env/
│   │   ├── apb_agent.sv
│   │   ├── apb_coverage.sv
│   │   ├── apb_driver.sv
│   │   ├── apb_env.sv
│   │   ├── apb_env_pkg.sv
│   │   ├── apb_monitor.sv
│   │   ├── apb_scoreboard.sv
│   │   ├── apb_sequence_item.sv
│   │   └── apb_sequencer.sv
│   ├── sequneces/                # Sequences
│   │   ├── abp_corner_seq.sv
│   │   ├── apb_alias_sequence.sv
│   │   ├── apb_back_to_back_seq.sv
│   │   ├── apb_base_sequence.sv
│   │   ├── apb_data_pattern_seq.sv
│   │   ├── apb_neighbour_seq.sv
│   │   ├── apb_overwrite_seq.sv
│   │   ├── apb_random_seq.sv
│   │   ├── apb_rd_wr_sequence.sv
│   │   ├── apb_sequence_pkg.sv
│   │   └── apb_sweep_address_sequence.sv
│   ├── tests/
│   │   ├── apb_all_tests.sv
│   │   ├── apb_base_test.sv
│   │   ├── apb_rd_wr_test.sv
│   │   ├── apb_sweep_address_test.sv
│   │   └── apb_test_pkg.sv
│   └── top/
│       └── apb_tb.sv             # Testbench top
├── scripts/
│   ├── runn_APB.do               # Compile and run script
│   └── wave.do                   # Waveform setup
└── logs/                         # Coverage databases and reports
    ├── apb_<test_name>.ucdb      # One coverage database per test
    ├── code_cov_report.txt
    ├── cov_report.txt
    └── func_cov_report.txt
```

## How to Run

1. Open your simulator in the project root. The `.ucdb` files indicate QuestaSim.
2. Run the compile and simulation script:

   ```
   do scripts/runn_APB.do
   ```

3. To load the waveform setup:

   ```
   do scripts/wave.do
   ```

4. To pick a single test, pass it with `+UVM_TESTNAME=<test_name>`.

## Results

Coverage databases and reports for each test are in `logs/`:

- `code_cov_report.txt`: code coverage
- `func_cov_report.txt`: functional coverage
- `cov_report.txt`: merged coverage repor

## Tools

SystemVerilog, UVM, QuestaSim
