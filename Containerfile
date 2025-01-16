FROM --platform=linux/arm64 quay.io/centos-bootc/centos-bootc:stream9

COPY etc etc

#RUN ln -sr /etc/containers/systemd/*.container /usr/lib/bootc/bound-images.d/

RUN dnf config-manager --set-enabled crb && \
    dnf install -y --nogpgcheck \
        https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
        https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-9.noarch.rpm

RUN dnf remove -y subscription-manager

RUN dnf install -y \
        podman \
        toolbox \
        python3.12 \
        NetworkManager \
        cockpit \
        cockpit-podman \
        firewalld \
        usbguard \
        cloud-utils-growpart \
        xfsprogs \
        && dnf clean all

RUN groupadd -g 1000 iceman && \
    useradd -m -u 1000 -g iceman -G wheel iceman && \
    echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel && \
    chmod 0440 /etc/sudoers.d/wheel

RUN mkdir -p /tmp/efi/boot/efi && \
    dnf install -y --downloadonly --release=$RELEASE --forcearch=aarch64 --destdir=/tmp/efi/ uboot-images-armv8 bcm283x-firmware bcm283x-overlays && \
    for rpm in /tmp/efi/*rpm; do rpm2cpio $rpm | cpio -idv -D /tmp/efi/; done && \
    mv /tmp/efi/usr/share/uboot/rpi_arm64/u-boot.bin /tmp/efi/boot/efi/rpi-u-boot.bin && \
    dnf clean all

RUN systemctl enable fstrim.timer && \
    systemctl enable cockpit.socket && \
    systemctl enable podman.socket && \
    systemctl enable podman-auto-update.timer && \
    systemctl disable auditd.service && \
    systemctl enable grow-fs.service && \
    systemctl enable cleanup-grow-tools.service

RUN ostree container commit && bootc container lint