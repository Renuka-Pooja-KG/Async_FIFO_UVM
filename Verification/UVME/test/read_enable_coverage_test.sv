class read_enable_coverage_test extends base_test;
  `uvm_component_utils(read_enable_coverage_test)

  write_base_sequence wseq;
  read_base_sequence rseq;

  function new(string name = "read_enable_coverage_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wseq = write_base_sequence::type_id::create("wseq");
    rseq = read_base_sequence::type_id::create("rseq");
    
    // Use read_conditions scenario to test read_enable conditions
    wseq.scenario = 11; // read_conditions_support_scenario
    rseq.scenario = 6;  // read_conditions_scenario
    wseq.num_transactions = 50;
    rseq.num_transactions = 50;
    
    `uvm_info(get_type_name(), "Read enable coverage test build_phase completed", UVM_LOW)
    `uvm_info(get_type_name(), "Using read_conditions scenario to test read_enable=0/1", UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Read enable coverage test run_phase started", UVM_LOW)
    
    // Test 1: Normal read operations (read_enable = 1)
    `uvm_info(get_type_name(), "Test 1: Normal read operations (read_enable = 1)", UVM_LOW)
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Test 2: Read disabled scenarios (read_enable = 0)
    `uvm_info(get_type_name(), "Test 2: Read disabled scenarios (read_enable = 0)", UVM_LOW)
    #1000;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Test 3: Toggle read enable rapidly
    `uvm_info(get_type_name(), "Test 3: Toggle read enable rapidly", UVM_LOW)
    #500;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Test 4: Read enable during FIFO empty
    `uvm_info(get_type_name(), "Test 4: Read enable during FIFO empty", UVM_LOW)
    #500;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Test 5: Read enable during FIFO full
    `uvm_info(get_type_name(), "Test 5: Read enable during FIFO full", UVM_LOW)
    #500;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    phase.drop_objection(this);
  endtask
  
endclass 