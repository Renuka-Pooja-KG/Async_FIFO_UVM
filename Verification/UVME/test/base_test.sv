class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  env m_env;
  write_base_sequence wseq;
  read_base_sequence rseq;
  virtual wr_interface wr_vif;

  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_env = env::type_id::create("m_env", this);
    wseq = write_base_sequence::type_id::create("wseq");
    rseq = read_base_sequence::type_id::create("rseq");
    if (!uvm_config_db#(virtual wr_interface)::get(this, "", "wr_vif", wr_vif))
      `uvm_fatal("NOVIF", "Could not get wr_vif from config_db")
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    // Assert resets
    wr_vif.hw_rst_n = 0;
    wr_vif.mem_rst  = 0;
    #20;
    wr_vif.hw_rst_n = 1;
    wr_vif.mem_rst  = 1;
    #20;
    wr_vif.mem_rst  = 0;

    // Optionally, pulse resets during simulation
    #200;
    wr_vif.hw_rst_n = 0;
    #20;
    wr_vif.hw_rst_n = 1;

    #200;
    wr_vif.mem_rst = 1;
    #20;
    wr_vif.mem_rst = 0;

    fork
      // Sequence starting should be done in derived tests
      wseq.start(m_env.m_write_agent.m_sequencer);
      rseq.start(m_env.m_read_agent.m_sequencer);
    join
    phase.drop_objection(this);
  endtask
endclass 