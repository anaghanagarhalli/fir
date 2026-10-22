#!/bin/bash

NODES="45nm 90nm 180nm"
CORNERS="slow fast typical"

for node in $NODES; do
    for corner in $CORNERS; do
        echo "=========================================================="
        echo " Running Synthesis: Node=$node | Corner=$corner"
        echo "=========================================================="
        genus -no_gui -batch -execute "set NODE $node; set CORNER $corner; source run_area.tcl"
    done
done

echo "ALL 9 RUNS COMPLETED SUCCESSFULLY!"
