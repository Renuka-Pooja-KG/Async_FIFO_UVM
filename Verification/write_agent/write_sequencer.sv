`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../sequence/write_sequence_item.sv"

class write_sequencer extends uvm_sequencer #(write_sequence_item);
  `uvm_component_utils(write_sequencer)

  function new(string name = "write_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass 