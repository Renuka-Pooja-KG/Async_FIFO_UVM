`timescale 1ns/1ps
// `include "../package/verification_pkg.sv"

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  uvm_analysis_export #(write_sequence_item) write_export;
  uvm_analysis_export #(read_sequence_item)  read_export;

  uvm_tlm_analysis_fifo #(write_sequence_item) write_fifo;
  uvm_tlm_analysis_fifo #(read_sequence_item)  read_fifo;

  // Data integrity checking
  bit [`DATA_WIDTH-1:0] expected_data_queue[$];
  int write_count = 0;
  int read_count = 0;
  int error_count = 0;

  // FIFO state tracking
  int expected_wr_level = 0;
  int expected_rd_level = 0;
  bit expected_wfull = 0;
  bit expected_rdempty = 1;
  bit expected_wr_almost_ful = 0;
  bit expected_rdalmost_empty = 1;
  bit expected_overflow = 0;
  bit expected_underflow = 0;

  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
    write_export = new("write_export", this);
    read_export  = new("read_export", this);
    write_fifo = new("write_fifo", this);
    read_fifo  = new("read_fifo", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    expected_wr_level = 0;
    expected_rd_level = (1 << `ADDRESS_WIDTH); // FIFO depth
    expected_wr_almost_ful = 0;
    expected_rdalmost_empty = 1;
    expected_overflow = 0;
    expected_underflow = 0;
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    write_export.connect(write_fifo.analysis_export);
    read_export.connect(read_fifo.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
    fork
      check_write_transactions();
      check_read_transactions();
      check_fifo_behavior();
    join
  endtask

  task check_write_transactions();
    write_sequence_item tr;
    forever begin
      write_fifo.get(tr);
      // Simultaneous write and read: do not update levels or queue
      if (tr.write_enable && tr.read_enable && !tr.wfull && !tr.rdempty) begin
        `uvm_info(get_type_name(), "Simultaneous write and read: pop front, push back (write)", UVM_MEDIUM)
        // Pop the front (read) and push the new write data (write)
        if (expected_data_queue.size() > 0) begin
          expected_data_queue.pop_front();
        end
        expected_data_queue.push_back(tr.wdata);
        // No change to expected_wr_level or expected_rd_level
      end else if (tr.write_enable && !tr.wfull) begin
        expected_data_queue.push_back(tr.wdata);
        write_count++;
        if (expected_wr_level < (1 << `ADDRESS_WIDTH)) begin
          expected_wr_level++;
          expected_rd_level--;
        end
        expected_wfull = (expected_wr_level == (1 << `ADDRESS_WIDTH));
        expected_rdempty = (expected_wr_level == 0);
        expected_wr_almost_ful = (expected_wr_level >= tr.afull_value);
        expected_overflow = (expected_wr_level >= (1 << `ADDRESS_WIDTH));
        `uvm_info(get_type_name(), $sformatf("Write: data=0x%h, wr_level=%d, wfull=%b", tr.wdata, expected_wr_level, expected_wfull), UVM_HIGH)
      end
      // Check for overflow
      if (tr.overflow != expected_overflow) begin
        `uvm_error(get_type_name(), $sformatf("Overflow mismatch: expected=%b, actual=%b", expected_overflow, tr.overflow))
        error_count++;
      end
      // Check FIFO state consistency
      if (tr.wfull != expected_wfull) begin
        `uvm_error(get_type_name(), $sformatf("FIFO full state mismatch: expected=%b, actual=%b", expected_wfull, tr.wfull))
        error_count++;
      end
      // Check almost full
      if (tr.wr_almost_ful != expected_wr_almost_ful) begin
        `uvm_error(get_type_name(), $sformatf("Almost full mismatch: expected=%b, actual=%b", expected_wr_almost_ful, tr.wr_almost_ful))
        error_count++;
      end
    end
  endtask

  task check_read_transactions();
    read_sequence_item tr;
    bit [`DATA_WIDTH-1:0] expected_data;
    forever begin
      read_fifo.get(tr);
      // Simultaneous write and read: do not update levels or queue
      if (tr.write_enable && tr.read_enable && !tr.wfull && !tr.rdempty) begin
        `uvm_info(get_type_name(), "Simultaneous write and read: pop front, push back (read)", UVM_MEDIUM)
        // Pop the front (read) and push the new write data (write)
        if (expected_data_queue.size() > 0) begin
          bit [`DATA_WIDTH-1:0] expected_data = expected_data_queue.pop_front();
          // Data integrity check (if read_data is available in tr)
          if (tr.read_data !== expected_data) begin
            `uvm_error(get_type_name(), $sformatf("Data integrity error: expected=0x%h, actual=0x%h", expected_data, tr.read_data))
            error_count++;
          end
        end
        expected_data_queue.push_back(tr.wdata);
        // No change to expected_wr_level or expected_rd_level
      end else if (tr.read_enable && !tr.rdempty) begin
        if (expected_data_queue.size() > 0) begin
          expected_data = expected_data_queue.pop_front();
          read_count++;
          //Data integrity check (if read_data is available in tr)
          if (tr.read_data !== expected_data) begin
            `uvm_error(get_type_name(), $sformatf("Data integrity error: expected=0x%h, actual=0x%h", expected_data, tr.read_data))
            error_count++;
          end
          `uvm_info(get_type_name(), $sformatf("Read: data=0x%h (correct)", expected_data), UVM_HIGH)
          if (expected_wr_level > 0) begin
            expected_wr_level--;
            expected_rd_level++;
          end
          expected_wfull = (expected_wr_level == (1 << `ADDRESS_WIDTH));
          expected_rdempty = (expected_wr_level == 0);
          expected_rdalmost_empty = (expected_wr_level <= tr.aempty_value);
          expected_underflow = (expected_wr_level == 0);
        end else begin
          `uvm_error(get_type_name(), "Read attempted but no data available")
          error_count++;
        end
      end
      // Check for underflow
      if (tr.underflow != expected_underflow) begin
        `uvm_error(get_type_name(), $sformatf("Underflow mismatch: expected=%b, actual=%b", expected_underflow, tr.underflow))
        error_count++;
      end
      // Check FIFO state consistency
      if (tr.rdempty != expected_rdempty) begin
        `uvm_error(get_type_name(), $sformatf("FIFO empty state mismatch: expected=%b, actual=%b", expected_rdempty, tr.rdempty))
        error_count++;
      end
      // Check almost empty
      if (tr.rd_almost_empty != expected_rdalmost_empty) begin
        `uvm_error(get_type_name(), $sformatf("Almost empty mismatch: expected=%b, actual=%b", expected_rdalmost_empty, tr.rd_almost_empty))
        error_count++;
      end
    end
  endtask

  task check_fifo_behavior();
    forever begin
      @(posedge $time);
      if (expected_wfull && expected_rdempty) begin
        `uvm_error(get_type_name(), "Invalid FIFO state: both full and empty")
        error_count++;
      end
      if (expected_wr_level + expected_rd_level != (1 << `ADDRESS_WIDTH)) begin
        `uvm_error(get_type_name(), $sformatf("FIFO level inconsistency: wr_level=%d, rd_level=%d", expected_wr_level, expected_rd_level))
        error_count++;
      end
    end
  endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Scoreboard Report:"), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("  Write transactions: %d", write_count), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("  Read transactions: %d", read_count), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("  Errors detected: %d", error_count), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("  Remaining data in queue: %d", expected_data_queue.size()), UVM_LOW)
    if (error_count == 0) begin
      `uvm_info(get_type_name(), "Scoreboard: All checks passed!", UVM_LOW)
    end else begin
      `uvm_error(get_type_name(), $sformatf("Scoreboard: %d errors detected", error_count))
    end
  endfunction
endclass 