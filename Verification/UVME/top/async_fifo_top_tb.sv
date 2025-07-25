// `timescale 1ns/1ps

// import uvm_pkg::*;
// `include "uvm_macros.svh"
// //`include "define.sv"

// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/wr_interface.sv"
// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/rd_interface.sv"

// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/write_sequence_item.sv"
// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/read_sequence_item.sv"

// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/write_driver.sv"
// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/read_driver.sv"

// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/write_sequencer.sv"
// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/read_sequencer.sv"

// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/write_monitor.sv"
// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/read_monitor.sv"

// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/write_agent.sv"
// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/read_agent.sv"

// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/scoreboard.sv"
// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/write_coverage.sv"
// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/read_coverage.sv"

// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/env.sv"

// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/default_write_sequence.sv"
// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/default_read_sequence.sv"
// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/write_until_full_seq.sv"
// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/read_until_empty_seq.sv"
// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/main_write_seq.sv"
// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/main_read_seq.sv"

// `include "/home/sgeuser100/renuka_dv/Async_FIFO_V_2/Simple_UVM/base_test.sv"


module async_fifo_top_tb;

  import uvm_pkg::*;
  import verification_pkg::*;
  // Clock and reset signals
  logic wclk;
  logic rclk;
  logic hw_rst_n;
  logic mem_rst;

  // Clock generation
  initial wclk = 0;
  always #5 wclk = ~wclk; // 100MHz if WCLK_SPEED=10
  initial rclk = 0;
  always #7 rclk = ~rclk; // ~71.4MHz if RCLK_SPEED=14

  // Reset generation
  initial begin
    // Assert resets
    hw_rst_n = 0; // Asserted (active low)
    mem_rst  = 0; // Deasserted (active high)
    #20;
    hw_rst_n = 1; // Deasserted (inactive)
    mem_rst  = 1; // Asserted (active high)
    #20;
    mem_rst  = 0; // Deasserted (inactive)
  end

  // Interface instantiations
  wr_interface wr_if (
    .wclk(wclk),
    .hw_rst_n(hw_rst_n),
    .mem_rst(mem_rst)
  );

  rd_interface rd_if (
    .rclk(rclk),
    .hw_rst_n(hw_rst_n)
  );

  // DUT instantiation
  async_fifo_int_mem #(
    .DATA_WIDTH(32),
    .ADDRESS_WIDTH(5),
    //.DEPTH(32),
    .SOFT_RESET(0),
    .POWER_SAVE (1),
    .STICKY_ERROR(0),
    .RESET_MEM(0),
    .PIPE_WRITE(0),
    .DEBUG_ENABLE(0),
    .PIPE_READ(0),
    .SYNC_STAGE(0)
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
    $shm_open("wave.shm");
    $shm_probe("AS");
  end

  // Start UVM
  initial begin
    // Initial reset sequence as above...

    // Optionally, pulse resets during simulation
    fork
      begin
        #200;
        pulse_hw_rst_n();
        #200;
        pulse_mem_rst();
      end
    join_none

    // Start UVM
    run_test("base_test");
    //#1000000 $finish;
  end

  task pulse_hw_rst_n();
    $display("Pulsing hw_rst_n (active low) at time %0t", $time);
    hw_rst_n = 0; // Assert
    #20;
    hw_rst_n = 1; // Deassert
  endtask

  task pulse_mem_rst();
    $display("Pulsing mem_rst (active high) at time %0t", $time);
    mem_rst = 1; // Assert
    #20;
    mem_rst = 0; // Deassert
  endtask

endmodule 