class write_agent extends uvm_agent;
  `uvm_component_utils(write_agent)

  write_driver    m_driver;
  write_monitor   m_monitor;
  write_sequencer m_sequencer;

  uvm_analysis_port #(write_sequence_item) analysis_port;

  function new(string name = "write_agent", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_monitor = write_monitor::type_id::create("m_monitor", this);
    if (is_active == UVM_ACTIVE) begin
      m_driver    = write_driver::type_id::create("m_driver", this);
      m_sequencer = write_sequencer::type_id::create("m_sequencer", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_monitor.write_analysis_port.connect(analysis_port);
    if (is_active == UVM_ACTIVE) begin
      m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    end
  endfunction
endclass 