FROM metricscascade/ubuntu20-rami-cascade-campaign:latest

ARG HOME=/home/metrics
ARG CATKIN_WORKSPACE=/FBM1/cvar_ws

USER root

# Free up space
RUN rm -rf FBM2

# Deps
RUN apt-get update && apt-get install -q -y \
    python3-catkin-tools \
    ros-noetic-realsense2-camera \
    ros-noetic-rtabmap-ros \
    ros-noetic-robot-localization \
    ros-noetic-imu-filter-madgwick

USER metrics

RUN mkdir -p FBM1/cvar_ws/src
COPY icuas23_pose_estimation FBM1/cvar_ws/src/icuas23_pose_estimation

# Build the Catkin workspace
WORKDIR $HOME/$CATKIN_WORKSPACE
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; catkin init'
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; catkin build'
# RUN catkin build --limit-status-rate 0.2

COPY cvar_fbm1_launch.sh FBM1/

WORKDIR $HOME/FBM1
CMD ["./FBM1/cvar_fbm1_launch.sh"]