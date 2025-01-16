# CentOS-Bootc-RPI4

**Please note: work in progress**

This repository is aiming to provide a CentOS Stream 9 bootc image for Raspberry Pi 4. The repository will provide a aarch64 container image for your RPI4 to leverage once bootstrapped. 

## Bootc Image Builder

We use BiB to generate a .RAW image to then be flashed onto the RPI4 flash using the RPI Imager or Fedora's ARM Image Installer. The aim to keep as much configuration in the Containerfile as possible, therefore we've opted to not use the Kickstart (config.toml) and opted to provision the device using Layers instead.

```bash
sudo podman run \
  --rm \
  -it \
  --privileged \
  --pull=newer \
   --security-opt label=type:unconfined_t \
   -v $(pwd)/output:/output \
   quay.io/centos-bootc/bootc-image-builder:latest \
   --type raw \
   --rootfs xfs \
   ghcr.io/defrostediceman/centos-bootc-rpi4
```