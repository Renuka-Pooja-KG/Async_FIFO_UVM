class write_base_sequence extends uvm_sequence #(write_sequence_item);
  `uvm_object_utils(write_base_sequence)

  // Configuration parameters
  int num_transactions = 10;
  int scenario = 0; // 0: random, 1: reset, 2: write_only, 3: read_only, 4: simultaneous, 5: reset-write-read

  function new(string name = "write_base_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), $sformatf("Starting write_base_sequence with %0d transactions, scenario=%0d", num_transactions, scenario), UVM_LOW)
    case (scenario)
      0: random_scenario();
      1: reset_scenario();
      2: write_only_scenario();
      3: read_only_scenario();
      4: simultaneous_scenario();
      5: reset_write_read_scenario();
      default: random_scenario();
    endcase
    `uvm_info(get_type_name(), "write_base_sequence completed", UVM_LOW)
  endtask

  // Random scenario
  task random_scenario();
    write_sequence_item req;
    repeat (num_transactions) begin
      req = write_sequence_item::type_id::create("req");
      if (!req.randomize()) begin
        `uvm_fatal(get_type_name(), "Failed to randomize transaction")
      end
      start_item(req);
      finish_item(req);
      `uvm_info(get_type_name(), $sformatf("Random: %s", req.convert2string()), UVM_HIGH)
    end
  endtask

  // Reset scenario
  task reset_scenario();
    write_sequence_item req;
    // Hardware reset for 3 cycles
    repeat (3) begin
      `uvm_do_with(req, {
        hw_rst_n == 0; // Assert hardware reset
        sw_rst == 0; // Ensure software reset is low
        mem_rst == 0; // Ensure memory reset is low
        write_enable == 0;
        wdata == 0;
        afull_value == 28;
      })
      `uvm_info(get_type_name(), $sformatf("Hardware Reset: %s", req.convert2string()), UVM_HIGH)
    end
    // De-assert hardware reset
    `uvm_do_with(req, {
      hw_rst_n == 1; // De-assert hardware reset
      sw_rst == 0; // Ensure software reset is low
      mem_rst == 0; // Ensure memory reset is low
      write_enable == 0;
      wdata == 0;
      afull_value == 28;
    })
    `uvm_info(get_type_name(), $sformatf("De-assert Hardware Reset: %s", req.convert2string()), UVM_HIGH)
    // Software reset for 2 cycles
    repeat (2) begin
      `uvm_do_with(req, {
        hw_rst_n == 1; // Ensure hardware reset is de-asserted
        sw_rst == 1; // Assert software reset
        mem_rst == 0; // Ensure memory reset is low
        write_enable == 0;
        wdata == 0;
        afull_value == 28;
      })
      `uvm_info(get_type_name(), $sformatf("Software Reset: %s", req.convert2string()), UVM_HIGH)
    end
    // De-assert software reset
    `uvm_do_with(req, {
      hw_rst_n == 1; // Ensure hardware reset is de-asserted
      sw_rst == 0; // De-assert software reset
      mem_rst == 0;
      write_enable == 0;
      wdata == 0;
      afull_value == 28;
    })
    `uvm_info(get_type_name(), $sformatf("Normal Operation: %s", req.convert2string()), UVM_HIGH)
    // Memory reset for 3 cycles
    repeat (3) begin
      `uvm_do_with(req, {
        hw_rst_n == 1; // De-assert hardware reset
        sw_rst == 0; // Ensure software reset is low
        mem_rst == 1; // Memory reset asserted
        write_enable == 0;
        wdata == 0;
        afull_value == 28;
      })
      `uvm_info(get_type_name(), $sformatf("Hardware Reset: %s", req.convert2string()), UVM_HIGH)
    end
    // De-assert hardware reset
    `uvm_do_with(req, {
      hw_rst_n == 1; // De-assert hardware reset
      sw_rst == 0; // Ensure software reset is low
      mem_rst == 0; // Ensure memory reset is low
      write_enable == 0;
      wdata == 0;
      afull_value == 28;
    })
    `uvm_info(get_type_name(), $sformatf("De-assert Hardware Reset: %s", req.convert2string()), UVM_HIGH)
   
  endtask

  // Write-only scenario: write_enable is always high
  task write_only_scenario();
    write_sequence_item req;
    repeat (num_transactions) begin
      req = write_sequence_item::type_id::create("req");
      start_item(req);
      req.write_enable = 1;
      req.sw_rst      = 0;
      req.hw_rst_n    = 1;
      req.mem_rst     = 0;
      req.wdata       = $urandom_range(0, 32'hFFFFFFFF);
      req.afull_value = 28;
      finish_item(req);
      `uvm_info(get_type_name(), $sformatf("Write-only: %s", req.convert2string()), UVM_HIGH)
    end
  endtask

  // Read-only scenario: write_enable is always low
  task read_only_scenario();
    write_sequence_item req;
    repeat (num_transactions) begin
      req = write_sequence_item::type_id::create("req");
      start_item(req);
      req.write_enable = 0; // Ensure write_enable is low
      req.sw_rst      = 0; // Ensure software reset is low
      req.hw_rst_n    = 1; // Ensure hardware reset is de-asserted
      req.mem_rst     = 0; // Ensure memory reset is low
      req.wdata       = 0;
      req.afull_value = 28;
      finish_item(req);
      `uvm_info(get_type_name(), $sformatf("Read-only: %s", req.convert2string()), UVM_HIGH)
    end
  endtask

  // Simultaneous scenario: write_enable is always high
  task simultaneous_scenario();
    write_sequence_item req;
    repeat (num_transactions) begin
      req = write_sequence_item::type_id::create("req");
      start_item(req);
      req.write_enable = 1; // Ensure write_enable is high
      req.sw_rst      = 0; // Ensure software reset is low
      req.hw_rst_n    = 1; // Ensure hardware reset is de-asserted
      req.mem_rst     = 0; // Ensure memory reset is low
      req.wdata       = $urandom_range(0, 32'hFFFFFFFF);
      req.afull_value = 28; // Set afull_value to a valid state
      finish_item(req);
      `uvm_info(get_type_name(), $sformatf("Simultaneous: %s", req.convert2string()), UVM_HIGH)
    end
  endtask

  // Reset - write  - read - write - read
  task reset_write_read_scenario();
    write_sequence_item req;
    // Hardware reset for 3 cycles
    repeat (3) begin
      `uvm_do_with(req, {
        hw_rst_n == 0; // Assert hardware reset
        sw_rst == 0; // Ensure software reset is low
        mem_rst == 0; // Ensure memory reset is low
        write_enable == 0;
        wdata == 0;
        afull_value == 28;
      })
      `uvm_info(get_type_name(), $sformatf("Hardware Reset: %s", req.convert2string()), UVM_HIGH)
    end
    // De-assert hardware reset
    `uvm_do_with(req, {
      hw_rst_n == 1; // De-assert hardware reset
      sw_rst == 0; // Ensure software reset is low
      mem_rst == 0; // Ensure memory reset is low
      write_enable == 0;
      wdata == 0;
      afull_value == 28;
    })
    `uvm_info(get_type_name(), $sformatf("De-assert Hardware Reset: %s", req.convert2string()), UVM_HIGH)
    // Write operation for 10 cycles
    repeat (10) begin
      req = write_sequence_item::type_id::create("req");
      start_item(req);
      req.write_enable = 1;
      req.sw_rst      = 0;
      req.hw_rst_n    = 1;
      req.mem_rst     = 0;
      req.wdata       = $urandom_range(0, 32'hFFFFFFFF);
      req.afull_value = 28;
      finish_item(req);
      `uvm_info(get_type_name(), $sformatf("Write-only: %s", req.convert2string()), UVM_HIGH)
    end
    // Read operation for 5 cycles
    repeat (5) begin    
      `uvm_do_with(req, {
        hw_rst_n == 1; // Ensure hardware reset is de-asserted
        sw_rst == 0; // Ensure software reset is low
        mem_rst == 0; // Ensure memory reset is low
        write_enable == 0; // Disable write operation
        wdata == 0; // No data for read operation
        afull_value == 28; // Set afull_value to a valid state
      })
      `uvm_info(get_type_name(), $sformatf("Read Operation: %s", req.convert2string()), UVM_HIGH)
    end
    // Write operation for 10 cycles
    repeat (10) begin
      req = write_sequence_item::type_id::create("req");
      start_item(req);
      req.write_enable = 1;
      req.sw_rst      = 0;
      req.hw_rst_n    = 1;
      req.mem_rst     = 0;
      req.wdata       = $urandom_range(0, 32'hFFFFFFFF);
      req.afull_value = 28;
      finish_item(req);
      `uvm_info(get_type_name(), $sformatf("Write-only: %s", req.convert2string()), UVM_HIGH)
    end
    // Read operation for 5 cycles
    repeat (5) begin
      `uvm_do_with(req, {
        hw_rst_n == 1; // Ensure hardware reset is de-asserted
        sw_rst == 0; // Ensure software reset is low
        mem_rst == 0; // Ensure memory reset is low
        write_enable == 0; // Disable write operation
        wdata == 0; // No data for read operation
        afull_value == 28; // Set afull_value to a valid state
      })
      `uvm_info(get_type_name(), $sformatf("Read Operation: %s", req.convert2string()), UVM_HIGH)
    end
    endtask
endclass
