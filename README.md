# centos-bootc-rpi4
CentOS Stream 9 bootc image for Raspberry Pi 4 (ARM64).

sudo podman run \
  --rm \
  -it \
  --privileged \
  --pull=newer \
   --security-opt label=type:unconfined_t \
   -v $(pwd)/output:/output \
   -v /var/lib/containers/storage:/var/lib/containers/storage \
   -v $(pwd)/config.toml:/config.toml \
   quay.io/centos-bootc/bootc-image-builder:latest \
   --type qcow2 \
   --local \
   --rootfs xfs \
   localhost/rpi4:0.1