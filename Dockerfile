# Use the specified base image
FROM ghcr.io/open-rmf/rmf/rmf_demos:latest AS rmf

ENV WS=/rmf_demos_ws
WORKDIR ${WS}

RUN if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then \
        rosdep init; \
    fi && \
    rosdep update

RUN colcon mixin update default

RUN apt-get update && apt-get install -y \
    software-properties-common \
    python3-pip \
    python3-venv \
    xdg-utils \
    ros-dev-tools \
    ros-${ROS_DISTRO}-desktop \
    ros-${ROS_DISTRO}-xacro \
    ros-${ROS_DISTRO}-joint-state-publisher \
    ros-${ROS_DISTRO}-ros-gz-sim \
    ros-${ROS_DISTRO}-rmf-dev

RUN pip3 install pipenv

# I should use a script from gist
COPY /rmf_web /${WS}
RUN chmod +x /${WS}/rmf_web

RUN curl -fsSL https://get.pnpm.io/install.sh | bash -

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
RUN echo "source ${WS}/devel/setup.bash" >> ~/.bashrc
RUN echo "alias sros='source /opt/ros/${ROS_DISTRO}/setup.bash && source ${WS}/install/setup.bash'" >> ~/.bashrc
RUN echo "alias dros='cd ${WS} && rosdep update && rosdep install --from-paths src --ignore-src -r -y'" >> ~/.bashrc
RUN echo "alias bros='cd ${WS} && colcon build'" >> ~/.bashrc
