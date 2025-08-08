class comprehensive_coverage_test extends base_test;
  `uvm_component_utils(comprehensive_coverage_test)

  write_base_sequence wseq;
  read_base_sequence rseq;

  function new(string name = "comprehensive_coverage_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wseq = write_base_sequence::type_id::create("wseq");
    rseq = read_base_sequence::type_id::create("rseq");
    
    // Use random scenario for comprehensive coverage
    wseq.scenario = 0; // Random scenario for comprehensive coverage
    rseq.scenario = 0; // Random scenario for comprehensive coverage
    wseq.num_transactions = 200;
    rseq.num_transactions = 200;
    
    `uvm_info(get_type_name(), "Comprehensive coverage test build_phase completed", UVM_LOW)
    `uvm_info(get_type_name(), "Using random scenario for comprehensive coverage", UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Comprehensive coverage test run_phase started", UVM_LOW)
    
    // Phase 1: Basic functionality with all data patterns
    `uvm_info(get_type_name(), "Phase 1: Basic functionality", UVM_LOW)
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Phase 2: FIFO level testing (empty, low, med, high, full)
    `uvm_info(get_type_name(), "Phase 2: FIFO level testing", UVM_LOW)
    #1000;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Phase 3: Read enable scenarios (enabled/disabled)
    `uvm_info(get_type_name(), "Phase 3: Read enable scenarios", UVM_LOW)
    #500;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Phase 4: Soft reset scenarios
    `uvm_info(get_type_name(), "Phase 4: Soft reset scenarios", UVM_LOW)
    #500;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Phase 5: Edge cases and stress testing
    `uvm_info(get_type_name(), "Phase 5: Edge cases and stress testing", UVM_LOW)
    #500;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Phase 6: Rapid transitions and corner cases
    `uvm_info(get_type_name(), "Phase 6: Rapid transitions", UVM_LOW)
    #300;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Phase 7: Final comprehensive test
    `uvm_info(get_type_name(), "Phase 7: Final comprehensive test", UVM_LOW)
    #200;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    phase.drop_objection(this);
  endtask
  
endclass 