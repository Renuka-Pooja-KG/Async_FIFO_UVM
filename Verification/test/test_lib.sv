`timescale 1ns/1ps
// `include "../package/verification_pkg.sv"

// Write sequence tests
class write_basic_test extends base_test;
  `uvm_component_utils(write_basic_test)
  function new(string name = "write_basic_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    write_basic_seq seq = write_basic_seq::type_id::create("seq");
    seq.start(m_env.m_write_agent.m_sequencer);
    phase.drop_objection(this);
  endtask
endclass

class write_sw_rst_test extends base_test;
  `uvm_component_utils(write_sw_rst_test)
  function new(string name = "write_sw_rst_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    write_sw_rst_seq seq = write_sw_rst_seq::type_id::create("seq");
    seq.start(m_env.m_write_agent.m_sequencer);
    phase.drop_objection(this);
  endtask
endclass

class write_overflow_test extends base_test;
  `uvm_component_utils(write_overflow_test)
  function new(string name = "write_overflow_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    write_overflow_seq seq = write_overflow_seq::type_id::create("seq");
    seq.start(m_env.m_write_agent.m_sequencer);
    phase.drop_objection(this);
  endtask
endclass

// Read sequence tests
class read_basic_test extends base_test;
  `uvm_component_utils(read_basic_test)
  function new(string name = "read_basic_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    read_basic_seq seq = read_basic_seq::type_id::create("seq");
    seq.start(m_env.m_read_agent.m_sequencer);
    phase.drop_objection(this);
  endtask
endclass

class read_disabled_test extends base_test;
  `uvm_component_utils(read_disabled_test)
  function new(string name = "read_disabled_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    read_disabled_seq seq = read_disabled_seq::type_id::create("seq");
    seq.start(m_env.m_read_agent.m_sequencer);
    phase.drop_objection(this);
  endtask
endclass

class read_underflow_test extends base_test;
  `uvm_component_utils(read_underflow_test)
  function new(string name = "read_underflow_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    read_underflow_seq seq = read_underflow_seq::type_id::create("seq");
    seq.start(m_env.m_read_agent.m_sequencer);
    phase.drop_objection(this);
  endtask
endclass 