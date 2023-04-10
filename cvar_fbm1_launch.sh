#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters. Usage:"
    echo "./cvar_fbm1_launch.sh </path/to/bag> <result_filename>"
    echo "./cvar_fbm1_launch.sh \$PWD/dataset/FBM1_flight1.bag example_fbm1_result.txt"
    exit -1
fi
echo "Evaluation bag path: $1"
echo "Result file name: $2"

result_path="/home/metrics/FBM1/results/"$2
echo "Result file path: $result_path"

source /home/metrics/FBM1/cvar_ws/devel/setup.bash

# Kill any previous session (-t -> target session, -a -> all other sessions )
tmux kill-session -t "SESSION"
tmux kill-session -a

# Create new session  (-2 allows 256 colors in the terminal, -s -> session name, -d -> not attach to the new session)
tmux -2 new-session -d -s "SESSION"

# Create roscore 
# send-keys writes the string into the sesssion (-t -> target session , C-m -> press Enter Button)
tmux rename-window -t $SESSION:0 'roscore'
tmux send-keys -t $SESSION:0 "roscore" C-m
sleep 3

tmux new-window -t $SESSION:1 -n 'image transport'
tmux send-keys -t $SESSION:1 "rosrun image_transport republish compressed in:=/camera/color/image_raw raw out:=/camera/color/image_raw " C-m

tmux new-window -t $SESSION:2 -n 'robot_localization'
tmux send-keys -t $SESSION:2 "roslaunch icuas23_pose_estimation robot_localization.launch" C-m 

tmux new-window -t $SESSION:3 -n 'pose_estimation'
tmux send-keys -t $SESSION:3 "roslaunch icuas23_pose_estimation pose_estimation.launch result_filename:="$result_path"" C-m

sleep 3

tmux new-window -t $SESSION:4 -n 'rosbag play'
tmux send-keys -t $SESSION:4 "sleep 5 ;rosbag play --clock $1 && tmux send-keys -t $SESSION:3 C-c" C-m

tmux attach-session -t $SESSION:3

echo "Done!"