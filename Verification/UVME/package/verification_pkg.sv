package verification_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

// Include all the files in the package
`include "../top/interface/wr_interface.sv"
`include "../top/interface/rd_interface.sv"

`include "../sequence/write_sequence_item.sv"
`include "../sequence/read_sequence_item.sv"

`include "../write_agent/write_driver.sv"
`include "../read_agent/read_driver.sv"

`include "../write_agent/write_sequencer.sv"
`include "../read_agent/read_sequencer.sv"

`include "../write_agent/write_monitor.sv"
`include "../read_agent/read_monitor.sv"

`include "../env/scoreboard.sv"
`include "../env/write_coverage.sv"
`include "../env/read_coverage.sv"

`include "../env/env.sv"

`include "../sequence/write_base_sequence.sv"
`include "../sequence/read_base_sequence.sv"
`include "../sequence/write_until_wfull_seq.sv"
`include "../sequence/read_until_rdempty_seq.sv"

`include "../test/base_test.sv"
`include "../test/write_until_wfull_test.sv"
`include "../test/read_until_rdempty_test.sv"


endpackage