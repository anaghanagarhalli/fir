set TOP_MODULE "fir_4tap_shared_mult"
set HDL_DIR "/home/vlsi36/24bvd1030/firtask/FIR_LAB/fir_area_optimized"

set TECH_NODES {"45nm" "90nm" "180nm"}
set LIB_CORNERS {"slow" "fast" "typical"}

file mkdir output/netlist
file mkdir output/constrints
file mkdir output/reports

foreach node $TECH_NODES {
    foreach corner $LIB_CORNERS {

        # Properly purge previous designs and loaded libraries
        if {[llength [get_db designs]] > 0} {
            delete_obj [get_db designs *]
        }
        if {[llength [get_db loaded_libraries]] > 0} {
            delete_obj [get_db loaded_libraries *]
        }

        puts "\n=========================================================="
        puts " [RUN] Module: $TOP_MODULE | Tech: $node | Corner: $corner"
        puts "==========================================================\n"

        set_db init_lib_search_path "/home/install/FOUNDRY/digital/${node}/dig/lib"
        set_db init_hdl_search_path $HDL_DIR

        read_libs "${corner}.lib"
        read_hdl "${TOP_MODULE}.v"
        elaborate $TOP_MODULE
        read_sdc "${TOP_MODULE}.sdc"

        set_db syn_generic_effort medium
        set_db syn_map_effort medium
        set_db syn_opt_effort medium

        syn_generic
        write_hdl > "output/netlist/${TOP_MODULE}_${node}_${corner}_generic.v"

        syn_map
        write_hdl > "output/netlist/${TOP_MODULE}_${node}_${corner}_mapped.v"

        syn_opt
        write_hdl > "output/netlist/${TOP_MODULE}_${node}_${corner}_opt.v"

        write_sdc > "output/constrints/${TOP_MODULE}_${node}_${corner}_synth.sdc"

        report_timing > "output/reports/${TOP_MODULE}_${node}_${corner}_timing.rpt"
        report_power  > "output/reports/${TOP_MODULE}_${node}_${corner}_power.rpt"
        report_area   > "output/reports/${TOP_MODULE}_${node}_${corner}_area.rpt"
        report_gates  > "output/reports/${TOP_MODULE}_${node}_${corner}_gates.rpt"
        report_qor    > "output/reports/${TOP_MODULE}_${node}_${corner}_qor.rpt"
    }
}
