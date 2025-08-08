class write_coverage extends uvm_subscriber #(write_sequence_item);

  `uvm_component_utils(write_coverage)
  write_sequence_item cov_item;

  covergroup write_cg ();
    option.per_instance = 1;
    option.name = "write_cg";
    option.comment = "Write coverage group";

    write_enable_cp: coverpoint cov_item.write_enable {
      bins zero = {0};
      bins one = {1};
    }
    wdata_cp: coverpoint cov_item.wdata {
        // Simple, practical bins for 32-bit data - 8 meaningful bins
         // Simple, practical bins for 32-bit data - 8 meaningful bins
       // bins zero = {32'h00000000};           // Zero value
       // bins all_ones = {32'hFFFFFFFF};       // All ones
        bins low_values = {[32'h00000000:32'h000000FF]};     // Low byte values
        bins mid_values = {[32'h00000100:32'h00FFFFFF]};     // Mid range values
        bins high_values = {[32'h01000000:32'hFFFFFFFF]};    // High range values
        //bins alternating = {32'h55555555, 32'hAAAAAAAA};     // Alternating patterns
        bins others = default;                               // Catch any remaining values
    }
    afull_value_cp: coverpoint cov_item.afull_value {
      bins low = {[1:10]};
      bins med = {[11:20]};
      bins high = {[21:31]};
      bins full = {32};
    }
    wr_sw_rst_cp: coverpoint cov_item.sw_rst {
      bins zero = {0};
      bins one = {1};
    }
    wfull_cp: coverpoint cov_item.wfull {
      bins zero = {0};
      bins one = {1};
    }
    wr_almost_ful_cp: coverpoint cov_item.wr_almost_ful {
      bins zero = {0};
      bins one = {1};
    }
    fifo_write_count_cp: coverpoint cov_item.fifo_write_count {
      bins zero = {0};
      bins low = {[1:10]};
      bins med = {[11:20]};
      bins high = {[21:31]};
      bins full = {32};
    }
    wr_level_cp: coverpoint cov_item.wr_level {
      bins empty = {0};
      bins low = {[1:10]};
      bins med = {[11:20]};
      bins high = {[21:31]};
      bins full = {32};
    }
    overflow_cp: coverpoint cov_item.overflow {
      bins zero = {0};
      bins one = {1};
    }
    
    // Enhanced cross coverage for better functional coverage
    cross_write_enable_wdata: cross write_enable_cp, wdata_cp {
      ignore_bins write_enable_zero_wdata = binsof(write_enable_cp.zero) && binsof(wdata_cp);
    }
    
    // New cross coverage for write scenarios
    cross_write_enable_wr_level: cross write_enable_cp, wr_level_cp;
    cross_write_enable_wfull: cross write_enable_cp, wfull_cp;
    cross_wr_level_fifo_write_count: cross wr_level_cp, fifo_write_count_cp;
    cross_wr_sw_rst_wr_level: cross wr_sw_rst_cp, wr_level_cp;
    
    // Coverage for specific scenarios that were missing
    write_enable_wfull_scenario: coverpoint {cov_item.write_enable, cov_item.wfull} {
      bins write_enable_1_wfull_0 = {2'b10};  // Write enabled, FIFO not full
      bins write_enable_1_wfull_1 = {2'b11};  // Write enabled, FIFO full
      bins write_enable_0_wfull_0 = {2'b00};  // Write disabled, FIFO not full
      bins write_enable_0_wfull_1 = {2'b01};  // Write disabled, FIFO full
    }
    
    // Soft reset coverage scenarios
    soft_reset_scenarios: coverpoint {cov_item.sw_rst, cov_item.wr_level} {
      bins soft_rst_0_low = {6'b000000};      // No soft reset, low level
      bins soft_rst_0_med = {6'b000101};      // No soft reset, medium level
      bins soft_rst_0_high = {6'b001010};     // No soft reset, high level
      bins soft_rst_1_low = {6'b100000};      // Soft reset, low level
      bins soft_rst_1_med = {6'b100101};      // Soft reset, medium level
      bins soft_rst_1_high = {6'b101010};     // Soft reset, high level
    }

  endgroup: write_cg

  int count = 0;
  uvm_analysis_imp #(write_sequence_item, write_coverage) wr_analysis_imp;

  function new(string name = "write_coverage", uvm_component parent = null);
    super.new(name, parent);
    write_cg = new();
    wr_analysis_imp = new("wr_analysis_imp", this);
  endfunction

  function void write(write_sequence_item t);
    cov_item = new();
    cov_item.copy(t);
    write_cg.sample();
    count++;
  endfunction

  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(get_type_name(), $sformatf("write_coverage: count = %d", count), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("write_coverage: write_cg = %s", write_cg.get_coverage()), UVM_LOW)
  endfunction

endclass 