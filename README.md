# docker-mocap4ros2-optitrack

Docker wrapper for the [mocap4ros2_optitrack](https://github.com/constructor-robotics/mocap4ros2_optitrack) driver.
A ROS 2 lifecycle node that streams OptiTrack motion capture data via the NatNet SDK. Runs on **ROS 2 Jazzy**.

## Prerequisites

- [Docker](https://docs.docker.com/engine/install/)
- [docker compose](https://docs.docker.com/compose/install/)
- [vcstool](https://github.com/dirk-thomas/vcstool): `sudo apt install vcstool`

## Setup

Clone all source repos and build the Docker image:

```bash
./setup.sh
```

This will:
1. Clone all ROS 2 workspace source repos into `files/src/`
2. Build the Docker image

## Configuration

### Network (`.env`)
Edit `.env` to set the container name, hostname, and ROS version if needed.

### OptiTrack connection (`files/src/mocap4ros2_optitrack/mocap4r2_optitrack_driver/config/`)
An example config files are provided:
- `mocap4r2_optitrack_driver_params.yaml` — default config

Key parameters to update before launching:

| Parameter | Description |
|---|---|
| `server_address` | IP of the OptiTrack Motive PC |
| `local_address` | IP of the local machine running this container |
| `connection_type` | `Unicast` or `Multicast` |
| `publish_tf` | Enable TF publishing for rigid bodies |
| `publish_y_up_tf` | Publish static transform from ROS Z-up to OptiTrack Y-up frame |
| `rigid_bodies` | List of rigid body names (must match names set in Motive) |

## Usage

### Start the container

```bash
# Allow GUI apps (RViz) to connect to the host display
xhost +local:docker

docker compose up -d
docker exec -it ros2-mocap-optitrack bash
```

### Launch the OptiTrack driver

```bash
ros2 launch mocap4r2_optitrack_driver optitrack2.launch.py
```

### Activate the lifecycle node

```bash
ros2 lifecycle set /mocap4r2_optitrack_driver_node activate
```

### Verify data is streaming

```bash
# Rigid body poses
ros2 topic echo /rigid_bodies

# TF transforms (requires publish_tf: true in config)
ros2 topic echo /tf

# Static Y-up transform (requires publish_y_up_tf: true in config)
ros2 topic echo /tf_static
```

## TF Publishing

When `publish_tf: true`, the driver publishes a TF transform for each rigid body listed under `rigid_bodies` in the config. The `name` field must exactly match the rigid body name as configured in Motive.

When `publish_y_up_tf: true`, a one-time static transform is published to bridge ROS's Z-up convention and OptiTrack's Y-up convention:

```
map (Z-up) → optitrack (Y-up) → <rigid_body_name>
```

### Visualize TF (run Rviz)

```bash
ros2 run rviz2 rviz2
```
