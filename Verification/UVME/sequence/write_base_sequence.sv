class write_base_sequence extends uvm_sequence #(write_sequence_item);
  write_sequence_item req;
  `uvm_object_utils(write_base_sequence)

  function new(string name = "default_write_seq");
    super.new(name);
  endfunction

  virtual task body();
    req = write_sequence_item::type_id::create("req");
    `uvm_info(get_type_name(), "Inside base write sequence", UVM_LOW)
    start_item(req);
    //req.write_enable = 1;
    finish_item(req);
  endtask
endclass
