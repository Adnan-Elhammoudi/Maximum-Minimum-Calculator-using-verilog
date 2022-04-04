
# Max_Min_3.do

vlib work
vlog +acc  "Max_Min_3_Mealy.v"
vlog +acc  "Max_Min_3_Moore.v"
vlog +acc  "Max_Min_3_TB.v"
vsim -vopt -t 1ps -lib work tb_min_max_finder
run 3000 ns
