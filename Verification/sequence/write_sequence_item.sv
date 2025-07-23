`timescale 1ns/1ps
// `include "../package/verification_pkg.sv"

class write_sequence_item extends uvm_sequence_item;

  rand bit [`DATA_WIDTH-1:0] wdata;
  rand bit write_enable;
  rand bit [`ADDRESS_WIDTH-1:0] afull_value;
  rand bit sw_rst;
  rand bit mem_rst;
  bit wfull;
  bit wr_almost_ful;
  bit [`ADDRESS_WIDTH:0] fifo_write_count;
  bit wr_level;
  bit overflow;

  constraint wdata_zero_when_write_enable_off {
    (write_enable == 0) -> (wdata == 0);
  }

  `uvm_object_utils_begin(write_sequence_item)
    `uvm_field_int(wdata, UVM_ALL_ON)
    `uvm_field_int(write_enable, UVM_ALL_ON)
    `uvm_field_int(afull_value, UVM_ALL_ON)
    `uvm_field_int(sw_rst, UVM_ALL_ON)
    `uvm_field_int(mem_rst, UVM_ALL_ON)
    `uvm_field_int(wfull, UVM_ALL_ON)
    `uvm_field_int(wr_almost_ful, UVM_ALL_ON)
    `uvm_field_int(fifo_write_count, UVM_ALL_ON)
    `uvm_field_int(wr_level, UVM_ALL_ON)
    `uvm_field_int(overflow, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "write_sequence_item");
    super.new(name);
  endfunction

  function void do_copy(uvm_object rhs);
    write_sequence_item rhs_;
    if (!$cast(rhs_, rhs)) begin
      `uvm_fatal("COPY_FAIL", "Type mismatch in do_copy")
    end
    super.do_copy(rhs);
    wdata = rhs_.wdata;
    write_enable = rhs_.write_enable;
    afull_value = rhs_.afull_value;
    sw_rst = rhs_.sw_rst;
    mem_rst = rhs_.mem_rst;
    wfull = rhs_.wfull;
    wr_almost_ful = rhs_.wr_almost_ful;
    fifo_write_count = rhs_.fifo_write_count;
    wr_level = rhs_.wr_level;
    overflow = rhs_.overflow;
  endfunction

  function string convert2string();
    return $sformatf("wdata=%0h write_enable=%0b afull_value=%0h sw_rst=%0b mem_rst=%0b wfull=%0b wr_almost_ful=%0b fifo_write_count=%0h wr_level=%0h overflow=%0b",
      wdata, write_enable, afull_value, sw_rst, mem_rst, wfull, wr_almost_ful, fifo_write_count, wr_level, overflow);
  endfunction
endclass 