class write_base_sequence extends uvm_sequence #(write_sequence_item);
  write_sequence_item req;
  `uvm_object_utils(write_base_sequence)

  function new(string name = "default_write_seq");
    super.new(name);
  endfunction

  virtual task body();
    forever begin
      req = write_sequence_item::type_id::create("req");
      start_item(req);
      req.write_enable = 0; // Always keep write disabled
      finish_item(req);
      // #10; // Optional: add delay to avoid busy loop
    end
  endtask
endclass
