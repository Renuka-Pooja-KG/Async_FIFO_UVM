`timescale 1ns/1ps

// `include "../define.sv"

interface wr_interface (
  input logic wclk,
  input logic hw_rst_n
);
  // Write side signals
  logic [`DATA_WIDTH-1:0] wdata;
  logic write_enable;
  logic [`ADDRESS_WIDTH-1:0] afull_value;
  logic sw_rst;
  logic mem_rst;
  logic wfull;
  logic wr_almost_ful;
  logic overflow;
  logic [`ADDRESS_WIDTH:0] fifo_write_count;
  logic [`ADDRESS_WIDTH:0] wr_level;

  // Write domain clocking block (for driver)
  clocking write_driver_cb @(posedge wclk);
    default input #1step output #1step;
    output wdata, write_enable, afull_value, sw_rst, mem_rst;
    input wfull, wr_almost_ful, overflow, fifo_write_count, wr_level;
  endclocking

  // Monitor clocking block (all signals as input)
  clocking write_monitor_cb @(posedge wclk);
    default input #1step output #1step;
    input wclk, hw_rst_n;
    input wdata, write_enable, afull_value, sw_rst, mem_rst;
    input wfull, wr_almost_ful, overflow, fifo_write_count, wr_level;
  endclocking

  // Modport for driver
  modport write_driver_mp( clocking write_driver_cb );

  // Modport for monitor
  modport write_monitor_mp( clocking write_monitor_cb );

endinterface 