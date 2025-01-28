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

## ARM image installer

Now we've built our RAW image, we now use the Fedora (or Raspberry Pi) ARM Image Installer to flash the image onto the RPI4 with the following command:
```bash
$ sudo arm-image-installer \
--image=</path/to/RAW_image> \
--target=rpi4 \ # rpi4, rpi3, rpi2
--media=/dev/__<sd_card_device> \ # /dev/sdX or /dev/mmcblkX. The lsblk command should help you identify your micro-SD card.
--resizefs
```

The SD card should now be ready to use with your Raspberry Pi 4. You can check the contents of the SD card by mounting it and checking the /boot/ folder.