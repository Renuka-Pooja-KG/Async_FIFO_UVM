`timescale 1ns/1ps

// `include "../define.sv"

interface rd_interface (
  input logic rclk,
  input logic hw_rst_n
);
  // Read side signals
  logic [`DATA_WIDTH-1:0] read_data;
  logic read_enable;
  logic [`ADDRESS_WIDTH-1:0] aempty_value;
  logic rdempty;
  logic rd_almost_empty;
  logic underflow;
  logic [`ADDRESS_WIDTH:0] fifo_read_count;
  logic [`ADDRESS_WIDTH:0] rd_level;

  // Read domain clocking block (for driver)
  clocking read_driver_cb @(posedge rclk);
    default input #1step output #1step;
    output read_enable, aempty_value;
    input read_data, rdempty, rd_almost_empty, underflow, fifo_read_count, rd_level;
  endclocking

  // Monitor clocking block (all signals as input)
  clocking read_monitor_cb @(posedge rclk);
    default input #1step output #1step;
    input rclk, hw_rst_n;
    input read_enable, aempty_value;
    input read_data, rdempty, rd_almost_empty, underflow, fifo_read_count, rd_level;
  endclocking

  // Modport for driver
  modport read_driver_mp (clocking read_driver_cb );

  // Modport for monitor
  modport read_monitor_mp (clocking read_monitor_cb );

endinterface 