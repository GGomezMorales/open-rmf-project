# Use the specified base image
FROM ghcr.io/open-rmf/rmf/rmf_demos:latest AS rmf

RUN if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then \
        rosdep init; \
    fi && \
    rosdep update

RUN colcon mixin update default

RUN apt-get update && sudo apt install ros-humble-rmf-dev -y
RUN apt-get update && apt-get install xdg-utils -y 

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source /rmf_demos_ws/install/setup.bash" >> ~/.bashrc

COPY ./autostart /
RUN chmod +x /autostart
ENTRYPOINT /autostart
