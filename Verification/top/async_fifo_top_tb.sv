`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"
//`include "define.sv"



// Include interface definitions
`include "../interface/wr_interface.sv"
`include "../interface/rd_interface.sv"
`include "../package/verification_pkg.sv"

module async_fifo_top_tb;

  // Clock and reset signals
  logic wclk;
  logic rclk;
  logic hw_rst_n;

  // Clock generation
  initial wclk = 0;
  always #(`WCLK_SPEED/2) wclk = ~wclk; // 100MHz if WCLK_SPEED=10
  initial rclk = 0;
  always #(`RCLK_SPEED/2) rclk = ~rclk; // ~71.4MHz if RCLK_SPEED=14

  // Reset generation
  initial begin
    hw_rst_n = 0;
    #20;
    hw_rst_n = 1;
  end

  // Interface instantiations
  wr_interface wr_if (
    .wclk(wclk),
    .hw_rst_n(hw_rst_n)
  );

  rd_interface rd_if (
    .rclk(rclk),
    .hw_rst_n(hw_rst_n)
  );

  // DUT instantiation
  async_fifo_int_mem #(
    .DATA_WIDTH(`DATA_WIDTH),
    .ADDRESS_WIDTH(`ADDRESS_WIDTH),
    .DEPTH(`DEPTH),
    .SOFT_RESET(`SOFT_RESET),
    .STICKY_ERROR(`STICKY_ERROR),
    .RESET_MEM(`RESET_MEM),
    .PIPE_WRITE(`PIPE_WRITE),
    .PIPE_READ(`PIPE_READ),
    .SYNC_STAGE(`SYNC_STAGE)
  ) dut (
    // Write side
    .wclk(wclk),
    .hw_rst_n(hw_rst_n),
    .wdata(wr_if.wdata),
    .write_enable(wr_if.write_enable),
    .afull_value(wr_if.afull_value),
    .sw_rst(wr_if.sw_rst),
    .mem_rst(wr_if.mem_rst),
    .wfull(wr_if.wfull),
    .wr_almost_ful(wr_if.wr_almost_ful),
    .overflow(wr_if.overflow),
    .fifo_write_count(wr_if.fifo_write_count),
    .wr_level(wr_if.wr_level),
    // Read side
    .rclk(rclk),
    .read_enable(rd_if.read_enable),
    .aempty_value(rd_if.aempty_value),
    .read_data(rd_if.read_data),
    .rdempty(rd_if.rdempty),
    .rd_almost_empty(rd_if.rd_almost_empty),
    .underflow(rd_if.underflow),
    .fifo_read_count(rd_if.fifo_read_count),
    .rd_level(rd_if.rd_level)
  );

  // UVM config_db setup
  initial begin
    uvm_config_db#(virtual wr_interface)::set(null, "*", "wr_vif", wr_if);
    uvm_config_db#(virtual rd_interface)::set(null, "*", "rd_vif", rd_if);
  end

  // Waveform dumping
  initial begin
    $shm_open("waves.shm");
    $shm_probe("AS");
  end

  // Start UVM
  initial begin
    run_test();
  end

endmodule 