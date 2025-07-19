@echo off

:: Set the base directory for the project
:: Update this path. Ensure it is an abosolute file path to your project directory(pmp-sv32)
set BASE_DIR=C:\Users\hp\Downloads\pmp-sv32

:: Clean previous files
echo Cleaning old files...
if exist work rmdir /s /q work
del transcript *.vcd *.wlf 2>nul

:: Create work library
echo Creating work library...
vlib work

:: Compile all files with correct paths
echo Compiling Verilog files...
vlog -sv ^
+incdir+%BASE_DIR%/defines ^
%BASE_DIR%/defines/cep_define.sv ^
pmp_tb.sv ^
%BASE_DIR%/rtl/tor.sv ^
%BASE_DIR%/rtl/addr_check_n.sv ^
%BASE_DIR%/rtl/na4.sv ^
%BASE_DIR%/rtl/napot.sv ^
%BASE_DIR%/rtl/pmp.sv ^
%BASE_DIR%/rtl/pmp_check.sv ^
%BASE_DIR%/rtl/pmp_registers.sv


:: Run simulation
echo Starting simulation...
vsim -c -voptargs="+acc" -do "run -all; quit" pmp_tb

echo Simulation complete!
pause