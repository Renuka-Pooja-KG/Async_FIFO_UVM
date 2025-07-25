package verification_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

// Include all the files in the package
//`include "./../UVME/top/interface/wr_interface.sv"
//`include "./../UVME/top/interface/rd_interface.sv"

`include "./../UVME/sequence/write_sequence_item.sv"
`include "./../UVME/sequence/read_sequence_item.sv"

`include "./../UVME/write_agent/write_driver.sv"
`include "./../UVME/read_agent/read_driver.sv"

`include "./../UVME/write_agent/write_sequencer.sv"
`include "./../UVME/read_agent/read_sequencer.sv"

`include "./../UVME/write_agent/write_monitor.sv"
`include "./../UVME/read_agent/read_monitor.sv"

`include "./../UVME/write_agent/write_agent.sv"
`include "./../UVME/read_agent/read_agent.sv"

`include "./../UVME/env/scoreboard.sv"
`include "./../UVME/env/write_coverage.sv"
`include "./../UVME/env/read_coverage.sv"

`include "./../UVME/env/env.sv"

`include "./../UVME/sequence/write_base_sequence.sv"
`include "./../UVME/sequence/read_base_sequence.sv"
`include "./../UVME/sequence/write_until_wfull_seq.sv"
`include "./../UVME/sequence/read_until_rdempty_seq.sv"

`include "./../UVME/test/base_test.sv"
`include "./../UVME/test/write_until_wfull_test.sv"
`include "./../UVME/test/read_until_rdempty_test.sv"


endpackage