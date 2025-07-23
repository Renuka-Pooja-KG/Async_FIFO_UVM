`timescale 1ns/1ps
// `include "../package/verification_pkg.sv"

// Basic read sequence
class read_basic_seq extends uvm_sequence #(read_sequence_item);
  `uvm_object_utils(read_basic_seq)
  function new(string name = "read_basic_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { read_enable == 1; })
  endtask
endclass

// Read enable off sequence
class read_disabled_seq extends uvm_sequence #(read_sequence_item);
  `uvm_object_utils(read_disabled_seq)
  function new(string name = "read_disabled_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { read_enable == 0; })
  endtask
endclass

// Underflow sequence
class read_underflow_seq extends uvm_sequence #(read_sequence_item);
  `uvm_object_utils(read_underflow_seq)
  function new(string name = "read_underflow_seq"); super.new(name); endfunction
  virtual task body();
    repeat (2**`ADDRESS_WIDTH + 2) begin
      `uvm_do_with(req, { read_enable == 1; })
    end
  endtask
endclass 