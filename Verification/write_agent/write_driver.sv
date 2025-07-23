`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../top/define.sv"
`include "../sequence/write_sequence_item.sv"
`include "../top/interface/wr_interface.sv"

class write_driver extends uvm_driver #(write_sequence_item);
  `uvm_component_utils(write_driver)

  virtual wr_interface.write_driver_mp wr_vif;

  function new(string name = "write_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual wr_interface.write_driver_mp)::get(this, "", "wr_vif", wr_vif)) begin
      `uvm_fatal("NOVIF", "Could not get wr_vif from uvm_config_db")
    end
    `UVM_INFO(get_type_name(), "write_driver build_phase completed, interface acquired", UVM_MEDIUM)
  endfunction

  task run_phase(uvm_phase phase);
    write_sequence_item tr;
    `UVM_INFO(get_type_name(), "write_driver run_phase started", UVM_LOW)
    forever begin
      seq_item_port.get_next_item(tr);
      // Drive stimulus to the interface
      wr_vif.write_enable <= tr.write_enable;
      wr_vif.wdata       <= tr.wdata;
      wr_vif.afull_value <= tr.afull_value;
      wr_vif.sw_rst      <= tr.sw_rst;
      wr_vif.mem_rst     <= tr.mem_rst;
      @(posedge wr_vif.wclk);
      seq_item_port.item_done();
    end
  endtask
endclass 