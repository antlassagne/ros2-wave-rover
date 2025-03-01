# ros2-wave-rover

This is a ROS 2 driver for Waveshare Wave Rover.
Should work with other waveshare robots based on JSON / UART communication (Offroad UGV, etc.)

Basically, it's a node that subscribes to `cmd_vel` topic and runs the motors accordingly.

## Requirements
If you don't use docker. Otherwise, just install docker.
```
sudo apt install -y qtcreator qtbase5-dev qt5-qmake cmake libqt5serialport5-dev
```

## Run the ros driver directly with a docker image on the robot
```
docker run --privileged -v /dev/ttyS0:/dev/ttyS0 -v /dev/input:/dev/input -it --rm  braoutch/ros2-wave-rover ros2 launch grospote wave_rover_launch.py enable_joypad:=0 UART_address:="/dev/ttyS0"
```
If you add `--restart=always`, it will start when your robot start, pretty convenient.

The controller can also be ran from a docker image, from the robot itself or from a PC on the same wifi network.
```
docker run --privileged -v /run/udev:/run/udev -v /dev:/dev --name controller --net=host -it --rm  braoutch/ros2-wave-rover:latest ros2 launch grospote control_launch.py
```
It's configured for my controller (a betaflight luxf4 osd) but you can configure it easily with pretty much anything. Open an issue if you need help.

## Docker build - native or raspberry pi

### QEMU if you are cross compiling
```
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

### The actual build
(remove the platform you don't need, or not)
```
docker buildx build \
          --push \
          --tag whatever-you-chose \
          --platform linux/amd64,linux/arm64 . 
```

## Debuging setup

### Create a serial port, for testing purpose
```
socat -v -d -d PTY,raw,echo=0,b115200,cs8 PTY,raw,echo=0,b115200,cs8
```

### For the real one, to test it:
```
stty -F /dev/ttyUSB0 1000000 # set the baud rate
cat /dev/ttyUSB0 # will receive commands that are sent from the robot
echo -ne "{\"T\":-3}" > /dev/ttyUSB0 # will send commands
echo -ne "{\"T\":1, \"L\":120, \"R\":120}" > /dev/ttyUSB0 # will send commands
```

### To create the udev rule
```
sudo cp 99-waverover.rules /etc/udev/rules.d/99-waverover.rules
```

### Give the rights to the serial port
The easy way:

sudoedit /etc/udev/rules.d/50-myusb.rules

Save this text:
```
KERNEL=="ttyUSB[0-9]*",MODE="0666"
KERNEL=="ttyACM[0-9]*",MODE="0666"
```
Then unplug and replug the device.

### Send messages manually
Send a twist message
```
ros2 topic pub /cmd_vel geometry_msgs/msg/Twist "{linear: {x: 0.1, y: 0.0, z: 0.0}, angular: {x: 0.0, y: 0.0, z: 1.0}}"
```

Run the joypad node locally
```
ros2 launch grospote control_launch.py

```