class read_base_sequence extends uvm_sequence #(read_sequence_item);
  read_sequence_item req;
  `uvm_object_utils(read_base_sequence)

  function new(string name = "default_read_seq");
    super.new(name);
  endfunction

  virtual task body();
    forever begin
      req = read_sequence_item::type_id::create("req");
      start_item(req);
      req.read_enable = 0; // Always keep read disabled
      finish_item(req);
      // #10; // Optional: add delay to avoid busy loop
    end
  endtask
endclass
