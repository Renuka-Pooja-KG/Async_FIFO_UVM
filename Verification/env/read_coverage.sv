`timescale 1ns/1ps
// `include "../package/verification_pkg.sv"

class read_coverage extends uvm_subscriber #(read_sequence_item);
  `uvm_component_utils(read_coverage)

  // Covergroup for read-side coverage
  covergroup read_cg with function sample(
    bit read_enable,
    bit [`ADDRESS_WIDTH-1:0] aempty_value,
    bit rdempty,
    bit rd_almost_empty,
    bit underflow,
    bit sw_rst,
    bit mem_rst,
    bit [`ADDRESS_WIDTH:0] rd_level
  );
    // Control signal coverage
    read_enable_cp: coverpoint read_enable;
    // Almost empty value coverage
    aempty_value_cp: coverpoint aempty_value {
      bins low = {[1:10]};
      bins medium = {[11:20]};
      bins high = {[21:30]};
    }
    // FIFO state coverage
    rdempty_cp: coverpoint rdempty {
      bins zero = {0};
      bins one = {1};
    }
    rd_almost_empty_cp: coverpoint rd_almost_empty {
      bins zero = {0};
      bins one = {1};
    }
    // Error condition coverage
    underflow_cp: coverpoint underflow {
      bins zero = {0};
      bins one = {1};
    }
    // FIFO level coverage
    rd_level_cp: coverpoint rd_level {
      bins empty = {0};
      bins low = {[1:10]};
      bins medium = {[11:20]};
      bins high = {[21:30]};
      bins full = {32};
    }
    // Reset coverage
    reset_cp: coverpoint {sw_rst, mem_rst} {
      bins no_reset = {2'b00};
      bins sw_reset = {2'b10};
      bins mem_reset = {2'b01};
      bins both = {2'b11};
    }
    // Cross coverage
    state_error_cross: cross rdempty_cp, underflow_cp;
    level_state_cross: cross rd_level_cp, rdempty_cp;
    reset_state_cross: cross reset_cp, rdempty_cp;
  endgroup

  read_sequence_item cov_item;

  function new(string name = "read_coverage", uvm_component parent = null);
    super.new(name, parent);
    read_cg = new();
  endfunction

  function void write(read_sequence_item t);
    cov_item = t;
    read_cg.sample(
      t.read_enable, t.aempty_value, t.rdempty, t.rd_almost_empty, t.underflow, t.sw_rst, t.mem_rst, t.rd_level
    );
  endfunction
endclass 