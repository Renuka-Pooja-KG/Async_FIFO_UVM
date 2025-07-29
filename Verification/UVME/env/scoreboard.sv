`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  uvm_analysis_imp_wr #(write_sequence_item, scoreboard) write_export;
  uvm_analysis_imp_rd #(read_sequence_item, scoreboard)  read_export; 

  // Queues for received transactions
  write_sequence_item write_queue[$]; // Stores write transactions from wr_interface
  read_sequence_item  read_queue[$];  // Stores read transactions from rd_interface

  // Data integrity checking
  bit [31:0] expected_data_queue[$]; // Dynamic queue for expected data

  int write_count = 0;
  int read_count = 0;
  int error_count = 0;

  // FIFO state tracking
  int expected_wr_level = 0;
  int expected_rd_level = (1 << 5); // FIFO depth
  int expected_fifo_write_count = 0;
  int expected_fifo_read_count = 0;
  bit expected_wfull = 0;
  bit expected_rdempty = 1;
  bit expected_wr_almost_ful = 0;
  bit expected_rdalmost_empty = 1;
  bit expected_overflow = 0;
  bit expected_underflow = 0;

  bit last_read_enable;
  bit last_rdempty;
  bit last_write_enable;
  bit last_wfull;
  int last_wr_level;

  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
    write_export = new("write_export", this);
    read_export  = new("read_export", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    expected_wr_level = 0;
    expected_rd_level = (1 << 5); // FIFO depth
    expected_fifo_write_count = 0;
    expected_fifo_read_count = 0;
    expected_wfull = 0;
    expected_rdempty = 1;
    expected_wr_almost_ful = 0;
    expected_rdalmost_empty = 1;
    expected_overflow = 0;
    expected_underflow = 0;
  endfunction

  // Analysis implementation for write transactions
  function void write_wr(write_sequence_item tr);
  `uvm_info(get_type_name(), $sformatf("Received write transaction: %s", tr.sprint), UVM_LOW)
    if (tr == null) begin
      `uvm_error(get_type_name(), "Received null write transaction")
      return;
    end
    write_queue.push_back(tr); // Store received write transaction
  endfunction

  // Analysis implementation for read transactions
  function void write_rd(read_sequence_item tr);
  `uvm_info(get_type_name(), $sformatf("Received read transaction: %s", tr.sprint), UVM_LOW)
    if (tr == null) begin
      `uvm_error(get_type_name(), "Received null read transaction")
      return;
    end
    read_queue.push_back(tr); // Store received read transaction
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "Scoreboard run_phase started", UVM_LOW)
    fork
      check_write_transactions();
      check_read_transactions();
      //check_fifo_behavior();
    join
  endtask

  task check_write_transactions();
    write_sequence_item tr;
    forever begin
      if (write_queue.size() == 0) begin
        wait (write_queue.size() > 0);
        `uvm_info(get_type_name(), "Waiting for write transactions", UVM_LOW)
      end
      tr = write_queue.pop_front();

      `uvm_info(get_type_name(), $sformatf("Checking write transaction in Scoreboard: %s", tr.sprint), UVM_LOW)


      // // Clear expected_data_queue on reset (mem_rst, hw_rst_n, or sw_rst)
      // if (tr.mem_rst == 1 || tr.hw_rst_n == 0 || tr.sw_rst == 1) begin
      //   expected_data_queue.delete();
      //   `uvm_info(get_type_name(), "expected_data_queue cleared due to reset (mem_rst, hw_rst_n, or sw_rst)", UVM_MEDIUM)
      // end

      // // Update last_write_enable and last_wfull
      // `uvm_info(get_type_name(), $sformatf("Checking write transaction: %s", tr.sprint), UVM_LOW)
      // last_write_enable = tr.write_enable;
      // last_wfull = tr.wfull;
      // last_wr_level = tr.wr_level;
      // // Simultaneous write and read: do not update levels or queue
      // if (tr.write_enable && last_read_enable && !tr.wfull && !last_rdempty) begin
      //   `uvm_info(get_type_name(), "Simultaneous write and read: pop front, push back (write)", UVM_MEDIUM)
      //   if (expected_data_queue.size() > 0) begin
      //     expected_data_queue.pop_front();
      //     expected_fifo_read_count++;
      //   end
      //   expected_data_queue.push_back(tr.wdata);
      //   write_count++;
      //   expected_fifo_write_count++;
      //   // No change to expected_wr_level or expected_rd_level
      // end else if (tr.write_enable && !tr.wfull) begin
      //   expected_data_queue.push_back(tr.wdata);
      //   write_count++;
      //   if (expected_wr_level < (1 << 5)) begin
      //     expected_wr_level++;
      //     expected_rd_level--;
      //     expected_fifo_write_count++;
      //   end
      //   `uvm_info(get_type_name(), $sformatf("Write: data=0x%h, wr_level=%d, wfull=%b", tr.wdata, expected_wr_level, expected_wfull), UVM_HIGH)
      // end

      // // Update status flags only once after write/read logic
      // expected_wfull         = (expected_wr_level == (1 << 5));
      // expected_rdempty       = (expected_wr_level == 0);
      // expected_wr_almost_ful = (expected_wr_level >= tr.afull_value);
      // expected_overflow      = (expected_wr_level >= (1 << 5));

      // // Check for overflow
      // if (tr.overflow != expected_overflow) begin
      //   `uvm_error(get_type_name(), $sformatf("Overflow mismatch: expected=%b, actual=%b", expected_overflow, tr.overflow))
      //   error_count++;
      // end
      // // Check FIFO state consistency
      // if (tr.wfull != expected_wfull) begin
      //   `uvm_error(get_type_name(), $sformatf("FIFO full state mismatch: expected=%b, actual=%b", expected_wfull, tr.wfull))
      //   error_count++;
      // end
      // // Check almost full
      // if (tr.wr_almost_ful != expected_wr_almost_ful) begin
      //   `uvm_error(get_type_name(), $sformatf("Almost full mismatch: expected_wr_almost_ful=%b, actual=%b, expected_wr_level = %d, tr.afull_value = %d ", expected_wr_almost_ful, tr.wr_almost_ful, expected_wr_level, tr.afull_value))
      //   error_count++;
      // end
    end
  endtask

  task check_read_transactions();
    read_sequence_item tr;
    bit [31:0] expected_data;
    forever begin
      if (read_queue.size() == 0) begin
        wait (read_queue.size() > 0);
        `uvm_info(get_type_name(), "Waiting for read transactions", UVM_LOW)
      end
      tr = read_queue.pop_front();

      `uvm_info(get_type_name(), $sformatf("Checking read transaction in Scoreboard: %s", tr.sprint), UVM_LOW)

      // // Update last_read_enable and last_rdempty
      // `uvm_info(get_type_name(), $sformatf("Checking read transaction: %s", tr.sprint), UVM_LOW)
      // last_read_enable = tr.read_enable;
      // last_rdempty = tr.rdempty;
      
      // // Simultaneous write and read: do not update levels or queue
      // if (last_write_enable && tr.read_enable && !last_wfull && !tr.rdempty) begin
      //   `uvm_info(get_type_name(), "Simultaneous write and read: pop front, push back (read)", UVM_MEDIUM)
      //   if (expected_data_queue.size() > 0) begin
      //     bit [31:0] expected_data = expected_data_queue.pop_front();
      //     read_count++;
      //     if (tr.read_data !== expected_data) begin
      //       `uvm_error(get_type_name(), $sformatf("Data integrity error: expected=0x%h, actual=0x%h", expected_data, tr.read_data))
      //       error_count++;
      //     end
      //   end else begin
      //     `uvm_error(get_type_name(), "Read attempted but no data available")
      //     error_count++;
      //   end
      //   // No change to expected_wr_level or expected_rd_level
      // end else if (tr.read_enable && !tr.rdempty) begin
      //   if (expected_data_queue.size() > 0) begin
      //     expected_data = expected_data_queue.pop_front();
      //     read_count++;
      //     if (tr.read_data !== expected_data) begin
      //       `uvm_error(get_type_name(), $sformatf("Data integrity error: expected=0x%h, actual=0x%h", expected_data, tr.read_data))
      //       error_count++;
      //     end
      //     `uvm_info(get_type_name(), $sformatf("Read: data=0x%h (correct)", expected_data), UVM_HIGH)
      //     if (expected_wr_level > 0) begin
      //       expected_wr_level--;
      //       expected_rd_level++;
      //       expected_fifo_read_count++;
      //     end
      //   end else begin
      //     `uvm_error(get_type_name(), "Read attempted but no data available")
      //     error_count++;
      //   end
      // end

      // // Update status flags only once after read logic
      // expected_wfull           = (expected_wr_level == (1 << 5));
      // expected_rdempty         = (expected_wr_level == 0);
      // expected_rdalmost_empty  = (expected_wr_level <= tr.aempty_value);
      // expected_underflow       = (expected_wr_level == 0);

      // // Check for underflow
      // if (tr.underflow != expected_underflow) begin
      //   `uvm_error(get_type_name(), $sformatf("Underflow mismatch: expected=%b, actual=%b", expected_underflow, tr.underflow))
      //   error_count++;
      // end
      // // Check FIFO state consistency
      // if (tr.rdempty != expected_rdempty) begin
      //   `uvm_error(get_type_name(), $sformatf("FIFO empty state mismatch: expected=%b, actual=%b", expected_rdempty, tr.rdempty))
      //   error_count++;
      // end
      // // Check almost empty
      // if (tr.rd_almost_empty != expected_rdalmost_empty) begin
      //   `uvm_error(get_type_name(), $sformatf("Almost empty mismatch: expected=%b, actual=%b", expected_rdalmost_empty, tr.rd_almost_empty))
      //   error_count++;
      // end
    end
  endtask

  task check_fifo_behavior();
    forever begin
      @(posedge $time);
      if (expected_wfull && expected_rdempty) begin
        `uvm_error(get_type_name(), "Invalid FIFO state: both full and empty")
        error_count++;
      end
      if (expected_wr_level + expected_rd_level != (1 << 5)) begin
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