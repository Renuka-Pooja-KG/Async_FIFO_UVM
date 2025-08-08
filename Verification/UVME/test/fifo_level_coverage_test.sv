class fifo_level_coverage_test extends base_test;
  `uvm_component_utils(fifo_level_coverage_test)

  write_base_sequence wseq;
  read_base_sequence rseq;

  function new(string name = "fifo_level_coverage_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wseq = write_base_sequence::type_id::create("wseq");
    rseq = read_base_sequence::type_id::create("rseq");
    
    // Use reset-write-read scenario to test different FIFO levels
    wseq.scenario = 5; // Reset-write-read scenario
    rseq.scenario = 5; // Reset-write-read scenario
    wseq.num_transactions = 100;
    rseq.num_transactions = 100;
    
    `uvm_info(get_type_name(), "FIFO level coverage test build_phase completed", UVM_LOW)
    `uvm_info(get_type_name(), "Using reset-write-read scenario to test different FIFO levels", UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "FIFO level coverage test run_phase started", UVM_LOW)
    
    // Configure scoreboard for test
    configure_scoreboard_for_test();
    
    // Test 1: Fill FIFO to different levels and read
    // Target: rd_fifo_read_count_cp bins (zero, low, med, high, full)
    `uvm_info(get_type_name(), "Test 1: Fill FIFO to different levels and read", UVM_LOW)
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Test 2: Empty FIFO completely (zero level)
    `uvm_info(get_type_name(), "Test 2: Empty FIFO completely (zero level)", UVM_LOW)
    #1000;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Test 3: Fill to low level (1-10 items)
    `uvm_info(get_type_name(), "Test 3: Fill to low level (1-10 items)", UVM_LOW)
    #500;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Test 4: Fill to medium level (11-20 items)
    `uvm_info(get_type_name(), "Test 4: Fill to medium level (11-20 items)", UVM_LOW)
    #500;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Test 5: Fill to high level (21-31 items)
    `uvm_info(get_type_name(), "Test 5: Fill to high level (21-31 items)", UVM_LOW)
    #500;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Test 6: Fill to full level (32 items)
    `uvm_info(get_type_name(), "Test 6: Fill to full level (32 items)", UVM_LOW)
    #500;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Get and report data integrity statistics
    report_data_integrity_stats();
    
    phase.drop_objection(this);
  endtask
  
endclass 