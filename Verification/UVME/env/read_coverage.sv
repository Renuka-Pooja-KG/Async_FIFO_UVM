class read_coverage extends uvm_subscriber #(read_sequence_item);
  `uvm_component_utils(read_coverage)
  read_sequence_item cov_item;
  
  covergroup read_cg ();
    option.per_instance = 1;
    option.name = "read_cg";
    option.comment = "Read coverage group";

    read_enable_cp: coverpoint cov_item.read_enable {
      bins zero = {0};
      bins one = {1};
    }

    read_data_cp: coverpoint cov_item.read_data {
        // Simple, practical bins for 32-bit data - 8 meaningful bins
       // bins zero = {32'h00000000};           // Zero value
       // bins all_ones = {32'hFFFFFFFF};       // All ones
        bins low_values = {[32'h00000000:32'h000000FF]};     // Low byte values
        bins mid_values = {[32'h00000100:32'h00FFFFFF]};     // Mid range values
        bins high_values = {[32'h01000000:32'hFFFFFFFF]};    // High range values
        //bins alternating = {32'h55555555, 32'hAAAAAAAA};     // Alternating patterns
        bins others = default;                               // Catch any remaining values
    }

    aempty_value_cp: coverpoint cov_item.aempty_value {
      bins low = {[1:10]};
      bins med = {[11:20]};
      bins high = {[21:30]};
    }

    rdempty_cp: coverpoint cov_item.rdempty {
      bins zero = {0};
      bins one = {1};
    }
    rd_almost_empty_cp: coverpoint cov_item.rd_almost_empty {
      bins zero = {0};
      bins one = {1};
    }
    underflow_cp: coverpoint cov_item.underflow {
      bins zero = {0};
      bins one = {1};
    }
    rd_fifo_read_count_cp: coverpoint cov_item.fifo_read_count {
      bins zero = {0};
      bins low = {[1:10]};
      bins med = {[11:20]};
      bins high = {[21:31]};
      bins full = {32};
    }
    rd_level_cp: coverpoint cov_item.rd_level {
      bins empty = {0};
      bins low = {[1:10]};
      bins med = {[11:20]};
      bins high = {[21:31]};
      bins full = {32};
    }

    // Enhanced cross coverage for better functional coverage
    cross_read_enable_read_data: cross read_enable_cp, read_data_cp {
      ignore_bins read_enable_zero_read_data_one = binsof(read_enable_cp.zero) && binsof(read_data_cp);
    }
    
    // New cross coverage for FIFO level scenarios
    cross_read_enable_rd_level: cross read_enable_cp, rd_level_cp;
    cross_read_enable_rdempty: cross read_enable_cp, rdempty_cp;
    cross_rd_level_rd_fifo_read_count: cross rd_level_cp, rd_fifo_read_count_cp;
    
    // Coverage for specific scenarios that were missing
    read_enable_rdempty_scenario: coverpoint {cov_item.read_enable, cov_item.rdempty} {
      bins read_enable_1_rdempty_0 = {2'b10};  // Read enabled, FIFO not empty
      bins read_enable_1_rdempty_1 = {2'b11};  // Read enabled, FIFO empty
      bins read_enable_0_rdempty_0 = {2'b00};  // Read disabled, FIFO not empty
      bins read_enable_0_rdempty_1 = {2'b01};  // Read disabled, FIFO empty
    }

  endgroup: read_cg
 
  int count = 0;
  uvm_analysis_imp #(read_sequence_item, read_coverage) rd_analysis_imp;
  
  function new(string name = "read_coverage", uvm_component parent = null);
    super.new(name, parent);
    read_cg = new();
    rd_analysis_imp = new("rd_analysis_imp", this);
  endfunction

  function void write(read_sequence_item t);
    cov_item = new();
    cov_item.copy(t);
    read_cg.sample();
    count++;
  endfunction

  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(get_type_name(), $sformatf("read_coverage: count = %d", count), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("read_coverage: read_cg = %s", read_cg.get_coverage()), UVM_LOW)
  endfunction

endclass 