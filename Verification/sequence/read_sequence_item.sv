`timescale 1ns/1ps
// `include "../package/verification_pkg.sv"

class read_sequence_item extends uvm_sequence_item;

  rand bit read_enable;
  rand bit [`ADDRESS_WIDTH-1:0] aempty_value;
  bit rdempty;
  bit rd_almost_empty;
  bit [`ADDRESS_WIDTH:0] fifo_read_count;
  bit underflow;
  bit [`ADDRESS_WIDTH:0] rd_level;
  bit [`DATA_WIDTH-1:0] read_data;

  `uvm_object_utils_begin(read_sequence_item)
    `uvm_field_int(read_enable, UVM_ALL_ON)
    `uvm_field_int(aempty_value, UVM_ALL_ON)
    `uvm_field_int(rdempty, UVM_ALL_ON)
    `uvm_field_int(rd_almost_empty, UVM_ALL_ON)
    `uvm_field_int(fifo_read_count, UVM_ALL_ON)
    `uvm_field_int(underflow, UVM_ALL_ON)
    `uvm_field_int(rd_level, UVM_ALL_ON)
    `uvm_field_int(read_data, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "read_sequence_item");
    super.new(name);
  endfunction

  function void do_copy(uvm_object rhs);
    read_sequence_item rhs_;
    if (!$cast(rhs_, rhs)) begin
      `uvm_fatal("COPY_FAIL", "Type mismatch in do_copy")
    end
    super.do_copy(rhs);
    read_enable = rhs_.read_enable;
    aempty_value = rhs_.aempty_value;
    rdempty = rhs_.rdempty;
    rd_almost_empty = rhs_.rd_almost_empty;
    fifo_read_count = rhs_.fifo_read_count;
    underflow = rhs_.underflow;
    rd_level = rhs_.rd_level;
    read_data = rhs_.read_data;
  endfunction

  function string convert2string();
    return $sformatf("read_enable=%0b aempty_value=%0h rdempty=%0b rd_almost_empty=%0b fifo_read_count=%0h underflow=%0b rd_level=%0h read_data=%0h",
      read_enable, aempty_value, rdempty, rd_almost_empty, fifo_read_count, underflow, rd_level, read_data);
  endfunction
endclass 