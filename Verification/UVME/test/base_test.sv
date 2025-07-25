class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  env m_env;
  write_base_sequence wseq;
  read_base_sequence rseq;

  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_env = env::type_id::create("m_env", this);
    wseq = write_base_sequence::type_id::create("wseq");
    rseq = read_base_sequence::type_id::create("rseq");
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    // Sequence starting should be done in derived tests
    //  wseq.start(m_env.m_write_agent.m_sequencer);
    //  rseq.start(m_env.m_read_agent.m_sequencer);
    phase.drop_objection(this);
  endtask
endclass 