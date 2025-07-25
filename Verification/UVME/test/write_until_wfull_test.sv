class write_until_wfull_test extends base_test;
  `uvm_component_utils(write_until_wfull_test)

  write_until_wfull_seq wseq;

  function new(string name = "write_until_wfull_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wseq = write_until_wfull_seq::type_id::create("wseq");
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    wseq.start(m_env.m_write_agent.m_sequencer);
    phase.drop_objection(this);
  endtask
endclass 