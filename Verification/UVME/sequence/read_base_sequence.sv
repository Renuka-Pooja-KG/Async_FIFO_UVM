class read_base_sequence extends uvm_sequence #(read_sequence_item);
  `uvm_object_utils(read_base_sequence)

  // Configuration parameters
  int num_transactions = 10;
  int scenario = 0; // 0: random, 1: reset, 2: write_only, 3: read_only, 4: simultaneous

  function new(string name = "read_base_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), $sformatf("Starting read_base_sequence with %0d transactions, scenario=%0d", num_transactions, scenario), UVM_LOW)
    case (scenario)
      0: random_scenario();
      1: reset_scenario();
      2: write_only_scenario();
      3: read_only_scenario();
      4: simultaneous_scenario();
      default: random_scenario();
    endcase
    `uvm_info(get_type_name(), "read_base_sequence completed", UVM_LOW)
  endtask

  // Random scenario
  task random_scenario();
    read_sequence_item req;
    repeat (num_transactions) begin
      req = read_sequence_item::type_id::create("req");
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
    read_sequence_item req;
    // Hardware reset for 3 cycles
    repeat (3) begin
      `uvm_do_with(req, {
        // hw_rst_n == 0; // Assert hardware reset
        // sw_rst == 0; // Ensure software reset is low
        read_enable == 0;
        aempty_value == 2;
      })
      `uvm_info(get_type_name(), $sformatf("Hardware Reset: %s", req.convert2string()), UVM_HIGH)
    end
    // De-assert hardware reset
    `uvm_do_with(req, {
      // hw_rst_n == 1; // De-assert hardware reset
      // sw_rst == 0; // Ensure software reset is low
      read_enable == 0;
      aempty_value == 2;
    })
    `uvm_info(get_type_name(), $sformatf("De-assert Hardware Reset: %s", req.convert2string()), UVM_HIGH)
    // Software reset for 2 cycles
    repeat (2) begin
      `uvm_do_with(req, {
        // hw_rst_n == 1; // Ensure hardware reset is de-asserted
        // sw_rst == 1; // Assert software reset
        read_enable == 0;
        aempty_value == 2;
      })
      `uvm_info(get_type_name(), $sformatf("Software Reset: %s", req.convert2string()), UVM_HIGH)
    end
    // De-assert software reset
    `uvm_do_with(req, {
      // hw_rst_n == 1; // Ensure hardware reset is de-asserted
      // sw_rst == 0; // De-assert software reset
      read_enable == 0;
      aempty_value == 2;
    })
    `uvm_info(get_type_name(), $sformatf("Normal Operation: %s", req.convert2string()), UVM_HIGH)
    // Memory reset in write domain for 3 cycles
    repeat (3) begin
      `uvm_do_with(req, {
        // hw_rst_n == 1; // De-assert hardware reset
        // sw_rst == 0; // Ensure software reset is low
        read_enable == 0;
        aempty_value == 2;
      })
      `uvm_info(get_type_name(), $sformatf("Hardware Reset: %s", req.convert2string()), UVM_HIGH)
    end
    // De-assert hardware reset
    `uvm_do_with(req, {
      // hw_rst_n == 1; // De-assert hardware reset
      // sw_rst == 0; // Ensure software reset is low
      read_enable == 0;
      aempty_value == 2;
    })
    `uvm_info(get_type_name(), $sformatf("De-assert Hardware Reset: %s", req.convert2string()), UVM_HIGH)
   
  endtask

  // Write-only scenario: read_enable is always low
  task write_only_scenario();
    read_sequence_item req;
    repeat (num_transactions) begin
      req = read_sequence_item::type_id::create("req");
      start_item(req);
      req.read_enable = 0; // Ensure read_enable is low
      // req.sw_rst      = 0; // Ensure software reset is low
      // req.hw_rst_n    = 1; // Ensure hardware reset is de-asserted
      req.aempty_value = 4;
      finish_item(req);
      `uvm_info(get_type_name(), $sformatf("Write-only: %s", req.convert2string()), UVM_HIGH)
    end
  endtask

  // Read-only scenario: read_enable is always high
  task read_only_scenario();
    read_sequence_item req;
    repeat (num_transactions) begin
      req = read_sequence_item::type_id::create("req");
      start_item(req);
      req.read_enable = 1;
      // req.sw_rst      = 0; // Ensure software reset is low
      // req.hw_rst_n    = 1; // Ensure hardware reset is de-asserted
      req.aempty_value = 4;
      finish_item(req);
      `uvm_info(get_type_name(), $sformatf("Read-only: %s", req.convert2string()), UVM_HIGH)
    end
  endtask

  // Simultaneous scenario: read_enable is always high (for read side)
  task simultaneous_scenario();
    read_sequence_item req;
    repeat (num_transactions) begin
      req = read_sequence_item::type_id::create("req");
      start_item(req);
      req.read_enable = 1; // Ensure read_enable is high
      req.aempty_value = 4; // Set aempty_value to a valid state
      // Simulate simultaneous reset conditions
      // req.hw_rst_n    = 1; // Ensure hardware reset is de-asserted
      // req.sw_rst      = 0; // Ensure software reset is de-asserted
      finish_item(req);
      `uvm_info(get_type_name(), $sformatf("Simultaneous: %s", req.convert2string()), UVM_HIGH)
    end
  endtask
endclass
