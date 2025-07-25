class read_base_sequence extends uvm_sequence #(read_sequence_item);
  read_sequence_item req;
  `uvm_object_utils(read_base_sequence)

  function new(string name = "default_read_seq");
    super.new(name);
  endfunction

  virtual task body();
    req = read_sequence_item::type_id::create("req");
    `uvm_info(get_type_name(), "Inside default read sequence", UVM_LOW)
    start_item(req);
    //req.read_enable = 1;
    finish_item(req);
  endtask
endclass
