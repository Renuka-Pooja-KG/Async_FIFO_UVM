`timescale 1ns/1ps
// import uvm_pkg::*;
// `include "uvm_macros.svh"
// `include "read_driver.sv"
// `include "read_monitor.sv"
// `include "read_sequencer.sv"

class read_agent extends uvm_agent;
  `uvm_component_utils(read_agent)

  read_driver    m_driver;
  read_monitor   m_monitor;
  read_sequencer m_sequencer;

  uvm_analysis_port #(read_sequence_item) analysis_port;

  function new(string name = "read_agent", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_monitor = read_monitor::type_id::create("m_monitor", this);
    if (is_active == UVM_ACTIVE) begin
      m_driver    = read_driver::type_id::create("m_driver", this);
      m_sequencer = read_sequencer::type_id::create("m_sequencer", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_monitor.read_analysis_port.connect(analysis_port);
    if (is_active == UVM_ACTIVE) begin
      m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    end
  endfunction
endclass 