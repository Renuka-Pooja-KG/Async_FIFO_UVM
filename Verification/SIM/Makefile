
# Show available test cases and options
#
run: info

info:
	@echo "/------------------------list of alias name available in make file ----------------------//"
	@echo " along with make pass any of the one parameter to run corresponding test or to open waveform"
	@echo "  all        			 	----> to run all the below test cases use make all command"
	@echo "  base_test  				----> to run the base_test.sv"
	@echo "  write_until_wfull_test  	----> to run the write_until_wfull_test.sv"
	@echo "  read_until_rdempty_test 	----> to run the read_until_rdempty_test.sv"
	@echo "  waveform   				----> to open the simvision"
	@echo "  regression 				----> to run the regression & source the cmd and open the imc"
	@echo "  clean      				----> to delete the previous xrun files and cov files"
	@echo "/----------------------------------------------------------------------------------------//"

# Default target that runs all tests
all: base_test write_until_wfull_test read_until_rdempty_test waveform

# Base test case
base_test:
	@echo "[makefile]  base test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=base_test -uvmhome CDNS-1.1d
	@echo "[makefile]  base test case run is completed successfully"

# write until wfull test case
write_until_wfull_test:
	@echo "[makefile]   write until wfull test case running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=write_until_wfull_test -uvmhome CDNS-1.1d
	@echo "[makefile]  write until wfull test case run was successful"

# read until rdempty test case
read_until_rdempty_test:
	@echo "[makefile]   read until rdempty test case running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=read_until_rdempty_test -uvmhome CDNS-1.1d
	@echo "[makefile]  read until rdempty test case run was successful"

# regression
regression:
	@echo "[makefile]  regression running"
	perl sync_fifo_regression.pl test_list.f 1
	source cmd
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