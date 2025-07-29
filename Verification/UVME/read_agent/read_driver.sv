class read_driver extends uvm_driver #(read_sequence_item);
  `uvm_component_utils(read_driver)

  virtual rd_interface rd_vif;
  read_sequence_item tr;

  function new(string name = "read_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual rd_interface)::get(this, "", "rd_vif", rd_vif)) begin
      `uvm_fatal("NOVIF", "Could not get rd_vif from uvm_config_db")
    end
    tr = read_sequence_item::type_id::create("tr");
    `uvm_info(get_type_name(), "read_driver build_phase completed, interface acquired", UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
  super.run_phase(phase);

   // read_sequence_item tr;
    `uvm_info(get_type_name(), "read_driver run_phase started", UVM_LOW)
    @(posedge rd_vif.rclk);
    forever begin
      seq_item_port.get_next_item(tr);
      // Drive stimulus to the interface
      rd_vif.read_driver_cb.read_enable <= tr.read_enable;
      rd_vif.read_driver_cb.aempty_value <= tr.aempty_value;

      // // Drive asynchronous reset signals
      // rd_vif.hw_rst_n <= tr.hw_rst_n;
      // // rd_vif.read_driver_cb.hw_rst_n <= tr.hw_rst_n; --- IGN

      // // Drive synchronous reset signals
      // rd_vif.read_driver_cb.sw_rst <= tr.sw_rst;

      @(rd_vif.read_driver_cb);
      // Sample the read_data here
      // tr.read_data = rd_vif.read_driver_cb.read_data;
      // tr.rdempty = rd_vif.read_driver_cb.rdempty;
      // tr.rd_almost_empty = rd_vif.read_driver_cb.rd_almost_empty;
      // tr.fifo_read_count = rd_vif.read_driver_cb.fifo_read_count;
      // tr.underflow = rd_vif.read_driver_cb.underflow;
      // tr.rd_level = rd_vif.read_driver_cb.rd_level;
      `uvm_info(get_type_name(), $sformatf("read_driver: tr = %s", tr.sprint), UVM_LOW)
      seq_item_port.item_done();
    end
  endtask
endclass 