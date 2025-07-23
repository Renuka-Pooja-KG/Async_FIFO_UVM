`timescale 1ns/1ps
// `include "../package/verification_pkg.sv"

class read_monitor extends uvm_monitor;
  `uvm_component_utils(read_monitor)

  uvm_analysis_port #(read_sequence_item) read_analysis_port;
  virtual rd_interface.read_monitor_mp rd_vif;

  function new(string name = "read_monitor", uvm_component parent = null);
    super.new(name, parent);
    read_analysis_port = new("read_analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual rd_interface.read_monitor_mp)::get(this, "", "rd_vif", rd_vif)) begin
      `uvm_fatal("NOVIF", "Could not get rd_vif from uvm_config_db")
    end
    `UVM_INFO(get_type_name(), "read_monitor build_phase completed, interface acquired", UVM_MEDIUM)
  endfunction

  task run_phase(uvm_phase phase);
    read_sequence_item tr;
    `UVM_INFO(get_type_name(), "read_monitor run_phase started", UVM_LOW)
    forever begin
      @(posedge rd_vif.rclk);
      tr = read_sequence_item::type_id::create("tr", this);
      tr.read_enable      = rd_vif.read_enable;
      tr.aempty_value    = rd_vif.aempty_value;
      tr.rdempty         = rd_vif.rdempty;
      tr.rd_almost_empty = rd_vif.rd_almost_empty;
      tr.fifo_read_count = rd_vif.fifo_read_count;
      tr.underflow       = rd_vif.underflow;
      tr.rd_level        = rd_vif.rd_level;
      tr.read_data       = rd_vif.read_data;
      read_analysis_port.write(tr);
    end
  endtask
endclass 