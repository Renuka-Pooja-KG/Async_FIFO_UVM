class write_until_wfull_seq extends write_base_sequence;
  `uvm_object_utils(write_until_wfull_seq)

  function new(string name = "write_until_wfull_seq");
    super.new(name);
  endfunction

  virtual task body();
    write_sequence_item req;
    bit fifo_full = 0;
    int overflow_attempts = 3;
    `uvm_info(get_type_name(), "Starting write_until_wfull_seq", UVM_LOW)
    // --- Reset testing before normal operation ---
    // Assert both resets (hw_rst_n=0, mem_rst=1)
    req = write_sequence_item::type_id::create("req");
    req.hw_rst_n = 0;
    req.mem_rst = 1;
    req.write_enable = 0;
    start_item(req);
    finish_item(req);
    `uvm_info(get_type_name(), "Asserting resets: hw_rst_n=0, mem_rst=1", UVM_LOW)
    // Deassert both resets (hw_rst_n=1, mem_rst=0)
    req = write_sequence_item::type_id::create("req");
    req.hw_rst_n = 1;
    req.mem_rst = 0;
    req.write_enable = 0;
    start_item(req);
    finish_item(req);
    `uvm_info(get_type_name(), "Deasserting resets: hw_rst_n=1, mem_rst=0", UVM_LOW)
    // --- End reset testing ---
    // Write until FIFO is full
    do begin
      req = write_sequence_item::type_id::create("req");
      start_item(req);
      `uvm_do_with(req, { req.write_enable == 1; });
      `uvm_info(get_type_name(), $sformatf("req.wdata = 0x%0d", req.wdata), UVM_LOW)
      finish_item(req);
      // Wait for the response (assuming req.wfull is updated by the driver/monitor)
      if (req.wfull === 1) begin
        fifo_full = 1;
        `uvm_info(get_type_name(), "FIFO is full (wfull asserted)", UVM_LOW)
      end
    end while (!fifo_full);
    // Attempt a few more writes to trigger overflow
    repeat (overflow_attempts) begin
      req = write_sequence_item::type_id::create("req");
      start_item(req);
      req.write_enable = 1;
      finish_item(req);
      `uvm_info(get_type_name(), "Attempted write to full FIFO (should trigger overflow)", UVM_LOW)
    end
    `uvm_info(get_type_name(), "Completed write_until_wfull_seq", UVM_LOW)
  endtask
endclass 