`timescale 1ns/1ps
// `include "../package/verification_pkg.sv"

// Basic write sequence
class write_basic_seq extends uvm_sequence #(write_sequence_item);
  `uvm_object_utils(write_basic_seq)
  function new(string name = "write_basic_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { write_enable == 1; })
  endtask
endclass

// Soft reset sequence
class write_sw_rst_seq extends uvm_sequence #(write_sequence_item);
  `uvm_object_utils(write_sw_rst_seq)
  function new(string name = "write_sw_rst_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { write_enable == 0; sw_rst == 1; })
  endtask
endclass

// Overflow sequence
class write_overflow_seq extends uvm_sequence #(write_sequence_item);
  `uvm_object_utils(write_overflow_seq)
  function new(string name = "write_overflow_seq"); super.new(name); endfunction
  virtual task body();
    repeat (2**`ADDRESS_WIDTH + 2) begin
      `uvm_do_with(req, { write_enable == 1; })
    end
  endtask
endclass 