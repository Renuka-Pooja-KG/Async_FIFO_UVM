
# Show available test cases and options
#
run: info

info:
	@echo "/------------------------list of alias name available in make file ----------------------//"
	@echo " along with make pass any of the one parameter to run corresponding test or to open waveform"
	@echo "  all        			 	----> to run all the below test cases use make all command"
	@echo "  base_test  				----> to run the base_test.sv"
	@echo "  reset_test  				----> to run the reset_test.sv"
	@echo "  write_test  				----> to run the write_test.sv"
	@echo "  read_test  				----> to run the read_test.sv"
	@echo "  simultaneous_test  		----> to run the simultaneous_test.sv"
	@echo "  random_test  				----> to run the random_test.sv"
	@echo "  reset_write_read_test  	----> to run the reset_write_read_test.sv"
	@echo "  waveform   				----> to open the simvision"
	@echo "  regression 				----> to run the regression & source the cmd and open the imc"
	@echo "  clean      				----> to delete the previous xrun files and cov files"
	@echo "/----------------------------------------------------------------------------------------//"

# Default target that runs all tests
all: base_test reset_test write_test read_test simultaneous_test random_test  reset_write_read_test waveform

# Base test case
base_test:
	@echo "[makefile]  base test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=base_test -uvmhome CDNS-1.1d
	@echo "[makefile]  base test case run is completed successfully"

reset_test:
	@echo "[makefile]  reset test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=reset_test -uvmhome CDNS-1.1d
	@echo "[makefile]  reset test case run is completed successfully"

write_test:
	@echo "[makefile]  write test case is running"
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=write_only_test -uvmhome CDNS-1.1d
	@echo "[makefile]  write test case run is completed successfully"

read_test:
	@echo "[makefile]  read test case is running"	
	xrun -access +rwc -f compile_list.f +UVM_TESTNAME=read_only_test -uvmhome CDNS-1.1d
	@echo "[makefile]  read test case run is completed successfully"

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