class read_until_rdempty_seq extends read_base_sequence;
  `uvm_object_utils(read_until_rdempty_seq)

  function new(string name = "read_until_empty_seq");
    super.new(name);
  endfunction

  virtual task body();
    bit fifo_empty = 0;
    int underflow_attempts = 3;
    `uvm_info(get_type_name(), "Starting read_until_empty_seq", UVM_LOW)
    // Read until FIFO is empty
    do begin
      req = read_sequence_item::type_id::create("req");
      start_item(req);
      `uvm_do_with(req, { req.read_enable == 1; });
      finish_item(req);
      // Optionally, check rdempty from the response or monitor (requires scoreboard/monitor feedback)
      // Here, we assume req.rdempty is updated by the driver/monitor after each read
      if (req.rdempty === 1) begin
        fifo_empty = 1;
        `uvm_info(get_type_name(), "FIFO is empty (rdempty asserted)", UVM_LOW)
      end
    end while (!fifo_empty);
    // Attempt a few more reads to trigger underflow
    repeat (underflow_attempts) begin
      req = read_sequence_item::type_id::create("req");
      start_item(req);
      req.read_enable = 1;
      finish_item(req);
      `uvm_info(get_type_name(), "Attempted read from empty FIFO (should trigger underflow)", UVM_LOW)
    end
    `uvm_info(get_type_name(), "Completed read_until_empty_seq", UVM_LOW)
  endtask
endclass 