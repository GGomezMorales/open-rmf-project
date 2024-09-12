from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, SetLaunchConfiguration, SetEnvironmentVariable, IncludeLaunchDescription
from launch.substitutions import LaunchConfiguration, PathJoinSubstitution, TextSubstitution
from launch_ros.actions import Node
from launch.launch_description_sources import PythonLaunchDescriptionSource


def generate_launch_description():
    ros_gz_sim_dir = get_package_share_directory('ros_gz_sim')
    waver_description_dir = get_package_share_directory('waver_description')
    waver_rmf_dir = get_package_share_directory('waver_rmf')

    gz_launch_file = PathJoinSubstitution([ros_gz_sim_dir, 'launch', 'gz_sim.launch.py'])
    gz_models_path = PathJoinSubstitution([waver_description_dir, 'urdf', "waver.xacro"])
    gz_worlds_path = PathJoinSubstitution([waver_rmf_dir, 'worlds', 'coworking.sdf'])

    declare_world_arg = DeclareLaunchArgument(
        'world',
        default_value='coworking',
        description='World to be loaded in the Gazebo simulation (without .world extension)'
    )

    set_gz_model_path = SetEnvironmentVariable(
        'GZ_SIM_RESOURCE_PATH', 
        gz_models_path
    )

    set_world_file_config = SetLaunchConfiguration(
        'world_file',
        [LaunchConfiguration('world'), TextSubstitution(text='.sdf')]
    )

    include_gazebo_launch = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(gz_launch_file),
        launch_arguments={
            'gz_args': gz_worlds_path,
            'on_exit_shutdown': 'True'
        }.items()
    )

    ros_gz_bridge_node = Node(
        package='ros_gz_bridge',
        executable='parameter_bridge',
        output='screen'
    )

    return LaunchDescription([
        declare_world_arg,
        set_gz_model_path,
        set_world_file_config,
        include_gazebo_launch,
        ros_gz_bridge_node
    ])
