set TOP_MODULE "fir_4tap_shared_mult"
set HDL_DIR "/home/vlsi36/24bvd1030/firtask/FIR_LAB/fir_area_optimized"

file mkdir output/netlist
file mkdir output/constrints
file mkdir output/reports

set_db init_lib_search_path "/home/install/FOUNDRY/digital/${NODE}/dig/lib"
set_db init_hdl_search_path $HDL_DIR

read_libs "${CORNER}.lib"
read_hdl "${TOP_MODULE}.v"
elaborate $TOP_MODULE
read_sdc "${TOP_MODULE}.sdc"

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

syn_generic
write_hdl > "output/netlist/${TOP_MODULE}_${NODE}_${CORNER}_generic.v"

syn_map
write_hdl > "output/netlist/${TOP_MODULE}_${NODE}_${CORNER}_mapped.v"

syn_opt
write_hdl > "output/netlist/${TOP_MODULE}_${NODE}_${CORNER}_opt.v"

write_sdc > "output/constrints/${TOP_MODULE}_${NODE}_${CORNER}_synth.sdc"

report_timing > "output/reports/${TOP_MODULE}_${NODE}_${CORNER}_timing.rpt"
report_power  > "output/reports/${TOP_MODULE}_${NODE}_${CORNER}_power.rpt"
report_area   > "output/reports/${TOP_MODULE}_${NODE}_${CORNER}_area.rpt"
report_gates  > "output/reports/${TOP_MODULE}_${NODE}_${CORNER}_gates.rpt"
report_qor    > "output/reports/${TOP_MODULE}_${NODE}_${CORNER}_qor.rpt"

exit
