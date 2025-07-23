`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../top/define.sv"
`include "../sequence/write_sequence_item.sv"
`include "../top/interface/wr_interface.sv"

class write_monitor extends uvm_monitor;
  `uvm_component_utils(write_monitor)

  uvm_analysis_port #(write_sequence_item) write_analysis_port;
  virtual wr_interface.write_monitor_mp wr_vif;

  function new(string name = "write_monitor", uvm_component parent = null);
    super.new(name, parent);
    write_analysis_port = new("write_analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual wr_interface.write_monitor_mp)::get(this, "", "wr_vif", wr_vif)) begin
      `uvm_fatal("NOVIF", "Could not get wr_vif from uvm_config_db")
    end
    `UVM_INFO(get_type_name(), "write_monitor build_phase completed, interface acquired", UVM_MEDIUM)
  endfunction

  task run_phase(uvm_phase phase);
    write_sequence_item tr;
    `UVM_INFO(get_type_name(), "write_monitor run_phase started", UVM_LOW)
    forever begin
      @(posedge wr_vif.wclk);
      tr = write_sequence_item::type_id::create("tr", this);
      tr.write_enable    = wr_vif.write_enable;
      tr.wdata          = wr_vif.wdata;
      tr.afull_value    = wr_vif.afull_value;
      tr.sw_rst         = wr_vif.sw_rst;
      tr.mem_rst        = wr_vif.mem_rst;
      tr.wfull          = wr_vif.wfull;
      tr.wr_almost_ful  = wr_vif.wr_almost_ful;
      tr.fifo_write_count = wr_vif.fifo_write_count;
      tr.wr_level       = wr_vif.wr_level;
      tr.overflow       = wr_vif.overflow;
      write_analysis_port.write(tr);
    end
  endtask
endclass 