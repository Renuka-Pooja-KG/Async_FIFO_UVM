interface rd_interface (
  input logic rclk,
  input logic hw_rst_n
);
  // Read side signals
  logic [31:0] read_data;
  logic read_enable;
  logic [4:0] aempty_value;
  logic sw_rst;
  //logic mem_rst;
  logic rdempty;
  logic rd_almost_empty;
  logic underflow;
  logic [5:0] fifo_read_count;
  logic [5:0] rd_level;

  // Read domain clocking block (for driver)
  clocking read_driver_cb @(posedge rclk);
    default input #1step output #1step;
    // output hw_rst_n;
    output read_enable, aempty_value, sw_rst;
    input read_data, rdempty, rd_almost_empty, underflow, fifo_read_count, rd_level;
  endclocking

  // Monitor clocking block (all signals as input)
  clocking read_monitor_cb @(posedge rclk);
    default input #1step output #1step;
    // input rclk, hw_rst_n;
    input read_enable, aempty_value, sw_rst;
    input read_data, rdempty, rd_almost_empty, underflow, fifo_read_count, rd_level;
  endclocking

  // Modport for driver
  modport read_driver_mp (clocking read_driver_cb );

  // Modport for monitor
  modport read_monitor_mp (clocking read_monitor_cb );

endinterface 