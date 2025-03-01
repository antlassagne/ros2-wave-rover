from launch import LaunchDescription
from launch_ros.actions import Node
def generate_launch_description():
    ld = LaunchDescription()
    joypad_node = Node(
        package="joy",
        executable="joy_node",
    )
    twist_node = Node(
        package="teleop_twist_joy",
        executable="teleop_node",
        parameters = [
            {"require_enable_button": False},
            {"axis_linear.x" : 4},
            {"axis_angular.yaw" : 0},
            {"scale_linear.x" : 1.0},
            {"scale_angular.yaw": 1.0},
            {"qos_overrides./cmd_vel.publisher.reliability": "reliable"},  # Ensure reliability
            {"qos_overrides./cmd_vel.publisher.durability": "volatile"}  # Ensure volatile durability
        ]
    )
    ld.add_action(joypad_node)
    ld.add_action(twist_node)
    return ld