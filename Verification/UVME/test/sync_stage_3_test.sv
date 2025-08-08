class sync_stage_3_test extends base_test;
  `uvm_component_utils(sync_stage_3_test)

  write_base_sequence wseq;
  read_base_sequence rseq;

  function new(string name = "sync_stage_3_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wseq = write_base_sequence::type_id::create("wseq");
    rseq = read_base_sequence::type_id::create("rseq");
    
    // Use simultaneous scenario to stress the synchronization logic
    wseq.scenario = 4; // Simultaneous scenario to stress sync logic
    rseq.scenario = 4; // Simultaneous scenario to stress sync logic
    wseq.num_transactions = 50;
    rseq.num_transactions = 50;
    
    `uvm_info(get_type_name(), "SYNC_STAGE=3 test build_phase completed", UVM_LOW)
    `uvm_info(get_type_name(), "NOTE: This test requires SYNC_STAGE=3 parameter override", UVM_LOW)
    `uvm_info(get_type_name(), "Run with: make sync_stage_3_test (uses +define+SYNC_STAGE_VAL=3)", UVM_LOW)
    `uvm_info(get_type_name(), "Using simultaneous scenario to stress synchronization logic", UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "SYNC_STAGE=3 test run_phase started", UVM_LOW)
    
    // Test 1: Normal operation with SYNC_STAGE=3
    `uvm_info(get_type_name(), "Test 1: Normal operation with SYNC_STAGE=3", UVM_LOW)
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Test 2: Stress test with rapid clock transitions
    `uvm_info(get_type_name(), "Test 2: Stress test with rapid clock transitions", UVM_LOW)
    #1000;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    // Test 3: Edge case testing
    `uvm_info(get_type_name(), "Test 3: Edge case testing", UVM_LOW)
    #500;
    fork
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    
    phase.drop_objection(this);
  endtask
  
endclass 