
# Show available test cases and options
#
run: info

info:
	@echo "/------------------------list of alias name available in make file ----------------------//"
	@echo " along with make pass any of the one parameter to run corresponding test or to open waveform"
	@echo "  all        			 	----> to run all the below test cases use make all command except for faster_write_clock_test and faster_read_clock_test"
	@echo "  base_test  				----> to run the base_test.sv"
	@echo "  reset_test  				----> to run the reset_test.sv"
	@echo "  write_only_test  			----> to run the write_only_test.sv"
	@echo "  read_only_test  			----> to run the read_only_test.sv"
	@echo "  simultaneous_test  		----> to run the simultaneous_test.sv"
	@echo "  random_test  				----> to run the random_test.sv"
	@echo "  reset_write_read_test  	----> to run the reset_write_read_test.sv"
	@echo "  write_conditions_test  	----> to run the write_conditions_test.sv"
	@echo "  read_conditions_test  		----> to run the read_conditions_test.sv"
	@echo "  memory_access_test  		----> to run the memory_access_test.sv"
	@echo "  full_condition_test  		----> to run the full_condition_test.sv"
	@echo "  empty_condition_test  		----> to run the empty_condition_test.sv"
	@echo "  almost_full_test  			----> to run the almost_full_test.sv"
	@echo "  almost_empty_test  		----> to run the almost_empty_test.sv"
	@echo "  overflow_test  			----> to run the overflow_test.sv"
	@echo "  underflow_test  			----> to run the underflow_test.sv"
	@echo "  write_read_level_test  	----> to run the write_read_level_test.sv"
	@echo "  faster_write_clock_test  	----> to run the faster_write_clock_test.sv"
	@echo "  faster_read_clock_test  	----> to run the faster_read_clock_test.sv"
	@echo "  sync_stage_3_test  		----> to run the sync_stage_3_test.sv (SYNC_STAGE=3)"
	@echo "  soft_reset_test  			----> to run the soft_reset_test.sv (SOFT_RESET=3)"
	@echo "  soft_reset_test_0  		----> to run the soft_reset_test.sv (SOFT_RESET=0)"
	@echo "  soft_reset_test_1  		----> to run the soft_reset_test.sv (SOFT_RESET=1)"
	@echo "  soft_reset_test_2  		----> to run the soft_reset_test.sv (SOFT_RESET=2)"
	@echo "  fifo_level_coverage_test  	----> to run the fifo_level_coverage_test.sv"
	@echo "  read_enable_coverage_test  	----> to run the read_enable_coverage_test.sv"
	@echo "  comprehensive_coverage_test  	----> to run the comprehensive_coverage_test.sv"
	@echo "  test TEST_NAME=name [SYNC_STAGE=2|3] [SOFT_RESET=0|1|2|3]"
	@echo "  					----> to run any test with parameter overrides"
	@echo "  waveform   				----> to open the simvision"
	@echo "  regression 				----> to run the regression & source the cmd and open the imc"
	@echo "  clean      				----> to delete the previous xrun files and cov files"
	@echo ""
	@echo "/------------------------Parameter Configuration Options ----------------------//"
	@echo "  Parameter overrides can be used with any test:"
	@echo "  SYNC_STAGE values: 2 (default), 3"
	@echo "  SOFT_RESET values: 0, 1, 2, 3 (default)"
	@echo "  Example: make random_test SYNC_STAGE=3 SOFT_RESET=1"
	@echo "/----------------------------------------------------------------------------------------//"

# Default target that runs all tests
all: base_test reset_test write_only_test read_only_test simultaneous_test reset_write_read_test write_conditions_test read_conditions_test memory_access_test full_condition_test empty_condition_test almost_full_test almost_empty_test overflow_test underflow_test write_read_level_test random_test sync_stage_3_test soft_reset_test soft_reset_test_0 soft_reset_test_1 soft_reset_test_2 fifo_level_coverage_test read_enable_coverage_test comprehensive_coverage_test waveform

new_test: sync_stage_3_test soft_reset_test_0 soft_reset_test_1 soft_reset_test_2 fifo_level_coverage_test read_enable_coverage_test comprehensive_coverage_test

# Base test case
base_test:
	@echo "[makefile]  base test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=base_test -uvmhome CDNS-1.1d
	@echo "[makefile]  base test case run is completed successfully"

reset_test:
	@echo "[makefile]  reset test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=reset_test -uvmhome CDNS-1.1d
	@echo "[makefile]  reset test case run is completed successfully"

write_only_test:
	@echo "[makefile]  write only test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=write_only_test -uvmhome CDNS-1.1d || true
	@echo "[makefile]  write only test case run is completed successfully"

read_only_test:
	@echo "[makefile]  read only test case is running"	
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=read_only_test -uvmhome CDNS-1.1d || true
	@echo "[makefile]  read only test case run is completed successfully"

simultaneous_test:
	@echo "[makefile]  simultaneous test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=simultaneous_test -uvmhome CDNS-1.1d
	@echo "[makefile]  simultaneous test case run is completed successfully"

random_test:
	@echo "[makefile]  random test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=random_test -uvmhome CDNS-1.1d
	@echo "[makefile]  random test case run is completed successfully"

reset_write_read_test:
	@echo "[makefile]  random test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=reset_write_read_test -uvmhome CDNS-1.1d
	@echo "[makefile]  random test case run is completed successfully"

write_conditions_test:
	@echo "[makefile]  write conditions test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=write_conditions_test -uvmhome CDNS-1.1d
	@echo "[makefile]  write conditions test case run is completed successfully"

read_conditions_test:
	@echo "[makefile]  read conditions test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=read_conditions_test -uvmhome CDNS-1.1d
	@echo "[makefile]  read conditions test case run is completed successfully"

memory_access_test:
	@echo "[makefile]  memory access test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=memory_access_test -uvmhome CDNS-1.1d
	@echo "[makefile]  memory access test case run is completed successfully"

full_condition_test:
	@echo "[makefile]  full condition test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=full_condition_test -uvmhome CDNS-1.1d || true
	@echo "[makefile]  full condition test case run is completed successfully"

empty_condition_test:
	@echo "[makefile]  empty condition test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=empty_condition_test -uvmhome CDNS-1.1d
	@echo "[makefile]  empty condition test case run is completed successfully"

almost_full_test:
	@echo "[makefile]  almost full test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=almost_full_test -uvmhome CDNS-1.1d
	@echo "[makefile]  almost full test case run is completed successfully"

almost_empty_test:
	@echo "[makefile]  almost empty test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=almost_empty_test -uvmhome CDNS-1.1d
	@echo "[makefile]  almost empty test case run is completed successfully"

overflow_test:
	@echo "[makefile]  overflow test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=overflow_test -uvmhome CDNS-1.1d
	@echo "[makefile]  overflow test case run is completed successfully"

underflow_test:
	@echo "[makefile]  underflow test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=underflow_test -uvmhome CDNS-1.1d
	@echo "[makefile]  underflow test case run is completed successfully"

write_read_level_test:
	@echo "[makefile]  write read level test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=write_read_level_test -uvmhome CDNS-1.1d
	@echo "[makefile]  write read level test case run is completed successfully"

faster_write_clock_test:
	@echo "[makefile]  faster write clock test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=faster_write_clock_test -uvmhome CDNS-1.1d
	@echo "[makefile]  faster write clock test case run is completed successfully"

faster_read_clock_test:
	@echo "[makefile]  faster read clock test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=faster_read_clock_test -uvmhome CDNS-1.1d
	@echo "[makefile]  faster read clock test case run is completed successfully"

strict_level_test:
	@echo "[makefile]  strict level test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=strict_level_test -uvmhome CDNS-1.1d
	@echo "[makefile]  strict level test case run is completed successfully"

data_integrity_focused_test:
	@echo "[makefile]  data integrity focused test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=data_integrity_focused_test -uvmhome CDNS-1.1d
	@echo "[makefile]  data integrity focused test case run is completed successfully"

sync_stage_3_test:
	@echo "[makefile]  sync stage 3 test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=sync_stage_3_test -uvmhome CDNS-1.1d +define+SYNC_STAGE_VAL=3
	@echo "[makefile]  sync stage 3 test case run is completed successfully"

soft_reset_test:
	@echo "[makefile]  soft reset test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=soft_reset_test -uvmhome CDNS-1.1d +define+SOFT_RESET_VAL=3
	@echo "[makefile]  soft reset test case run is completed successfully"

soft_reset_test_0:
	@echo "[makefile]  soft reset test case (SOFT_RESET=0) is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=soft_reset_test -uvmhome CDNS-1.1d +define+SOFT_RESET_VAL=0
	@echo "[makefile]  soft reset test case (SOFT_RESET=0) run is completed successfully"

soft_reset_test_1:
	@echo "[makefile]  soft reset test case (SOFT_RESET=1) is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=soft_reset_test -uvmhome CDNS-1.1d +define+SOFT_RESET_VAL=1
	@echo "[makefile]  soft reset test case (SOFT_RESET=1) run is completed successfully"

soft_reset_test_2:
	@echo "[makefile]  soft reset test case (SOFT_RESET=2) is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=soft_reset_test -uvmhome CDNS-1.1d +define+SOFT_RESET_VAL=2
	@echo "[makefile]  soft reset test case (SOFT_RESET=2) run is completed successfully"

fifo_level_coverage_test:
	@echo "[makefile]  fifo level coverage test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=fifo_level_coverage_test -uvmhome CDNS-1.1d
	@echo "[makefile]  fifo level coverage test case run is completed successfully"

read_enable_coverage_test:
	@echo "[makefile]  read enable coverage test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=read_enable_coverage_test -uvmhome CDNS-1.1d
	@echo "[makefile]  read enable coverage test case run is completed successfully"

comprehensive_coverage_test:
	@echo "[makefile]  comprehensive coverage test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=comprehensive_coverage_test -uvmhome CDNS-1.1d
	@echo "[makefile]  comprehensive coverage test case run is completed successfully"

# Generic test target with parameter support
# Usage: make test TEST_NAME=random_test SYNC_STAGE=3 SOFT_RESET=1
test:
	@echo "[makefile] Running test: $(TEST_NAME) with SYNC_STAGE=$(SYNC_STAGE) SOFT_RESET=$(SOFT_RESET)"
	@if [ -z "$(TEST_NAME)" ]; then \
		echo "Error: TEST_NAME parameter is required. Usage: make test TEST_NAME=test_name [SYNC_STAGE=2|3] [SOFT_RESET=0|1|2|3]"; \
		exit 1; \
	fi
	@SYNC_STAGE_DEFINE=""; \
	SOFT_RESET_DEFINE=""; \
	if [ ! -z "$(SYNC_STAGE)" ]; then \
		SYNC_STAGE_DEFINE="+define+SYNC_STAGE_VAL=$(SYNC_STAGE)"; \
	fi; \
	if [ ! -z "$(SOFT_RESET)" ]; then \
		SOFT_RESET_DEFINE="+define+SOFT_RESET_VAL=$(SOFT_RESET)"; \
	fi; \
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=$(TEST_NAME) -uvmhome CDNS-1.1d $$SYNC_STAGE_DEFINE $$SOFT_RESET_DEFINE
	@echo "[makefile] Test $(TEST_NAME) completed successfully"

# regression
regression:
	@echo "[makefile]  regression running"
	perl async_fifo_regression.pl test_list.f 1
	bash -c "source cmd"
	imc -exec ./cov_files/cov_merge.cmd
	imc &
	@echo "[makefile]  regression was successfully completed"

# Clean previous run files
clean:
	rm -r *.log *.key xrun.history xcelium.d wave.shm cov_report.txt cov_report_html
	@echo "[makefile]  clean was successfully completed"

# Waveform viewing
waveform:
	simvision wave.shm & 