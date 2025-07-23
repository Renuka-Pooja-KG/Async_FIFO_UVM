`timescale 1ns/1ps
// `include "../package/verification_pkg.sv"

class write_coverage extends uvm_subscriber #(write_sequence_item);
  `uvm_component_utils(write_coverage)

  // Covergroup for write-side coverage
  covergroup write_cg with function sample(
    bit [`DATA_WIDTH-1:0] wdata,
    bit write_enable,
    bit [`ADDRESS_WIDTH-1:0] afull_value,
    bit wfull,
    bit wr_almost_ful,
    bit overflow,
    bit sw_rst,
    bit mem_rst,
    bit [`ADDRESS_WIDTH:0] wr_level
  );
    // Data coverage
    wdata_cp: coverpoint wdata {
      bins zeros = {0};
      bins ones = {'1};
      bins alternating = {32'hAAAA_AAAA, 32'h5555_5555};
      bins others = default;
    }
    // Control signal coverage
    write_enable_cp: coverpoint write_enable;
    // Almost full value coverage
    afull_value_cp: coverpoint afull_value {
      bins low = {[1:10]};
      bins medium = {[11:20]};
      bins high = {[21:30]};
    }
    // FIFO state coverage
    wfull_cp: coverpoint wfull {
      bins zero = {0};
      bins one = {1};
    }
    wr_almost_ful_cp: coverpoint wr_almost_ful {
      bins zero = {0};
      bins one = {1};
    }
    // Error condition coverage
    overflow_cp: coverpoint overflow {
      bins zero = {0};
      bins one = {1};
    }
    // FIFO level coverage
    wr_level_cp: coverpoint wr_level {
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
    state_error_cross: cross wfull_cp, overflow_cp;
    level_state_cross: cross wr_level_cp, wfull_cp;
    reset_state_cross: cross reset_cp, wfull_cp;
  endgroup

  write_sequence_item cov_item;

  function new(string name = "write_coverage", uvm_component parent = null);
    super.new(name, parent);
    write_cg = new();
  endfunction

  function void write(write_sequence_item t);
    cov_item = t;
    write_cg.sample(
      t.wdata, t.write_enable, t.afull_value, t.wfull, t.wr_almost_ful, t.overflow, t.sw_rst, t.mem_rst, t.wr_level
    );
  endfunction
endclass 