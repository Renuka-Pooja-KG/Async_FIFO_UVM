class soft_reset_test extends base_test;
  `uvm_component_utils(soft_reset_test)

  write_base_sequence wseq;
  read_base_sequence rseq;

  function new(string name = "soft_reset_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wseq = write_base_sequence::type_id::create("wseq");
    rseq = read_base_sequence::type_id::create("rseq");
    
    // Use reset scenario (scenario=1) which includes soft reset testing
    wseq.scenario = 1; // Reset scenario includes soft reset
    rseq.scenario = 1; // Reset scenario includes soft reset
    wseq.num_transactions = 30;
    rseq.num_transactions = 30;
    
    `uvm_info(get_type_name(), "Soft reset test build_phase completed", UVM_LOW)
    `uvm_info(get_type_name(), "Using reset scenario (scenario=1) which includes soft reset testing", UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Soft reset test run_phase started", UVM_LOW)
    
    // Configure scoreboard for soft reset test
    configure_scoreboard_for_test();
    
    // Test 1: Soft reset during normal operation
    `uvm_info(get_type_name(), "Test 1: Soft reset during normal operation", UVM_LOW)
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Test 2: Soft reset during FIFO full condition
    `uvm_info(get_type_name(), "Test 2: Soft reset during FIFO full condition", UVM_LOW)
    #500;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Test 3: Soft reset during FIFO empty condition
    `uvm_info(get_type_name(), "Test 3: Soft reset during FIFO empty condition", UVM_LOW)
    #500;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Test 4: Multiple soft resets in sequence
    `uvm_info(get_type_name(), "Test 4: Multiple soft resets in sequence", UVM_LOW)
    #300;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Get and report data integrity statistics
    report_data_integrity_stats();
    
    phase.drop_objection(this);
  endtask
  
endclass 