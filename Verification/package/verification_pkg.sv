package verification_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // 1. Sequence items
  `include "../sequence/write_sequence_item.sv"
  `include "../sequence/read_sequence_item.sv"

  // 2. Sequencers
  `include "../write_agent/write_sequencer.sv"
  `include "../read_agent/read_sequencer.sv"

  // 3. Drivers
  `include "../write_agent/write_driver.sv"
  `include "../read_agent/read_driver.sv"

  // 4. Monitors
  `include "../write_agent/write_monitor.sv"
  `include "../read_agent/read_monitor.sv"

  // 5. Agents
  `include "../write_agent/write_agent.sv"
  `include "../read_agent/read_agent.sv"

  // 6. Coverage
  `include "../env/write_coverage.sv"
  `include "../env/read_coverage.sv"

  // 7. Scoreboard
  `include "../env/scoreboard.sv"

  // 8. Environment
  `include "../env/env.sv"

  // 9. Sequence libraries
  `include "../sequence/write_sequence_lib.sv"
  `include "../sequence/read_sequence_lib.sv"

  // 10. Base test and test lib
  `include "../test/base_test.sv"
  `include "../test/test_lib.sv"
endpackage 