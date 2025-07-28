class write_monitor extends uvm_monitor;
  `uvm_component_utils(write_monitor)

  uvm_analysis_port #(write_sequence_item) write_analysis_port;
  virtual wr_interface wr_vif;
  write_sequence_item tr;

  function new(string name = "write_monitor", uvm_component parent = null);
    super.new(name, parent);
    write_analysis_port = new("write_analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual wr_interface)::get(this, "", "wr_vif", wr_vif)) begin
      `uvm_fatal("NOVIF", "Could not get wr_vif from uvm_config_db")
    end
    `uvm_info(get_type_name(), "write_monitor build_phase completed, interface acquired", UVM_MEDIUM)
  endfunction

  task run_phase(uvm_phase phase);
    write_sequence_item tr;
    `uvm_info(get_type_name(), "write_monitor run_phase started", UVM_LOW)
    tr = write_sequence_item::type_id::create("tr", this);

    forever begin
      @(wr_vif.write_monitor_cb);

      // Capture signals from the interface
      // Asynchronous reset signals
      tr.hw_rst_n       = wr_vif.hw_rst_n;
      tr.mem_rst        = wr_vif.mem_rst;
      // Synchronous signals
      tr.sw_rst         = wr_vif.write_monitor_cb.sw_rst;

      tr.write_enable    = wr_vif.write_monitor_cb.write_enable;
      tr.wdata          = wr_vif.write_monitor_cb.wdata;
      tr.afull_value    = wr_vif.write_monitor_cb.afull_value;
      tr.wfull          = wr_vif.write_monitor_cb.wfull;
      tr.wr_almost_ful  = wr_vif.write_monitor_cb.wr_almost_ful;
      tr.fifo_write_count = wr_vif.write_monitor_cb.fifo_write_count;
      tr.wr_level       = wr_vif.write_monitor_cb.wr_level;
      tr.overflow       = wr_vif.write_monitor_cb.overflow;
        // Print all wr_vif signals for debug
      $display("Time=%0t wr_vif: hw_rst_n=%b mem_rst=%b sw_rst=%b write_enable=%b wdata=%h afull_value=%d wfull=%b wr_almost_ful=%b fifo_write_count=%d wr_level=%d overflow=%b",
        $time, wr_vif.hw_rst_n, wr_vif.mem_rst, wr_vif.write_monitor_cb.sw_rst, wr_vif.write_monitor_cb.write_enable,
        wr_vif.write_monitor_cb.wdata, wr_vif.write_monitor_cb.afull_value, wr_vif.write_monitor_cb.wfull,
        wr_vif.write_monitor_cb.wr_almost_ful, wr_vif.write_monitor_cb.fifo_write_count,
        wr_vif.write_monitor_cb.wr_level, wr_vif.write_monitor_cb.overflow);
        
      `uvm_info(get_type_name(), $sformatf("Captured write transaction in write_monitor: %s", tr.convert2string()), UVM_LOW)
      write_analysis_port.write(tr);
    end
  endtask
endclass 