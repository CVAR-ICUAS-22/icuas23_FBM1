FROM metricscascade/ubuntu20-rami-cascade-campaign:latest

USER root

# Free up space
RUN rm -rf FBM2

# Deps
RUN apt-get update && apt-get install -q -y \
    ros-noetic-rtabmap-ros \
    ros-noetic-robot-localization \
    ros-noetic-imu-filter-madgwick

USER metrics

RUN mkdir -p FBM1/cvar_ws


CMD ["bash"]