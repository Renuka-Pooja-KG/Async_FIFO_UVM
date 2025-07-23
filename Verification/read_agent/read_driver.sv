`timescale 1ns/1ps
// `include "../package/verification_pkg.sv"

class read_driver extends uvm_driver #(read_sequence_item);
  `uvm_component_utils(read_driver)

  virtual rd_interface.read_driver_mp rd_vif;

  function new(string name = "read_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual rd_interface.read_driver_mp)::get(this, "", "rd_vif", rd_vif)) begin
      `uvm_fatal("NOVIF", "Could not get rd_vif from uvm_config_db")
    end
    `UVM_INFO(get_type_name(), "read_driver build_phase completed, interface acquired", UVM_MEDIUM)
  endfunction

  task run_phase(uvm_phase phase);
    read_sequence_item tr;
    `UVM_INFO(get_type_name(), "read_driver run_phase started", UVM_LOW)
    forever begin
      seq_item_port.get_next_item(tr);
      rd_vif.read_enable <= tr.read_enable;
      rd_vif.aempty_value <= tr.aempty_value;
      @(posedge rd_vif.rclk);
      seq_item_port.item_done();
    end
  endtask
endclass 