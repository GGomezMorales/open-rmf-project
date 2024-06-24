# Use the specified base image
FROM ghcr.io/open-rmf/rmf/rmf_demos:latest AS rmf

RUN if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then \
        rosdep init; \
    fi && \
    rosdep update

RUN colcon mixin update default

RUN apt-get update && apt-get install xdg-utils -y 
RUN apt-get update && apt-get install ros-dev-tools -y
RUN apt-get update && apt-get install ros-${ROS_DISTRO}-xacro -y
RUN apt-get update && apt-get install ros-${ROS_DISTRO}-joint-state-publisher -y

WORKDIR /

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
RUN echo "source /rmf_demos_ws/install/setup.bash" >> ~/.bashrc

COPY ./autostart /
RUN chmod +x /autostart
# ENTRYPOINT /autostart
