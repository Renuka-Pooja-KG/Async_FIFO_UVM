class read_until_rdempty_test extends base_test;
  `uvm_component_utils(read_until_rdempty_test)

  read_until_rdempty_seq rseq;
  write_base_sequence wseq;

  function new(string name = "read_until_rdempty_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rseq = read_until_rdempty_seq::type_id::create("rseq");
    wseq = write_base_sequence::type_id::create("wseq");
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rseq.start(m_env.m_read_agent.m_sequencer);
    wseq.start(m_env.m_write_agent.m_sequencer);
    phase.drop_objection(this);
  endtask
  
endclass 