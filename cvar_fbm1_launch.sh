#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters. Usage:"
    echo "./cvar_fbm1_launch.sh </path/to/bag> <result_filename>"
    echo "./cvar_fbm1_launch.sh dataset/FBM1_flight1.bag flight1_fbm1_result.txt" 
    exit -1
fi
echo "Evaluation bag path: $1"
echo "Result file name: $2"

result_path="/home/metrics/FBM1/results/"$2
echo "Result file path: $result_path"

roslaunch icuas23_pose_estimation icuas23_pose_estimation.launch bag_path:="$1" result_filename:="$result_path"

echo "Done!"