FROM ros:humble
# FROM ros:humble-ros-base
RUN apt update && apt install -y ros-humble-joy ros-humble-teleop-twist-joy git qtbase5-dev qt5-qmake cmake libqt5serialport5-dev nano && apt clean && rm -rf /var/lib/apt/lists/

RUN mkdir ros2-wave-rover
COPY ./src ./ros2-wave-rover/src
COPY ./launch ./ros2-wave-rover/launch
COPY ./package.xml ./ros2-wave-rover/
COPY ./CMakeLists.txt ./ros2-wave-rover/
WORKDIR /ros2-wave-rover

RUN . /opt/ros/humble/setup.sh && colcon build

# Setup environment variables
COPY entrypoint.sh /sbin/entrypoint.sh
RUN sudo chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
# CMD ["bash"]
