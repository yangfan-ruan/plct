#!/usr/bin/env bash

# The script is created for starting a riscv64 qemu virtual machine with specific parameters.

RESTORE=$(echo -en '\001\033[0m\002')
YELLOW=$(echo -en '\001\033[00;33m\002')

## Configuration
vcpu=8
memory=8
memory_append=`expr $memory \* 1024`
drive="$(ls *.qcow2)"
fw="fw_payload_oe_uboot_2304.bin"
ssh_port=12056

# cmd="qemu-system-riscv64 \
#   -nographic -machine virt \
#   -smp "$vcpu" -m "$memory"G \
#   -bios "$fw" \
#   -drive file="$drive",format=qcow2,id=hd0 \
#   -object rng-random,filename=/dev/urandom,id=rng0 \
#   -device virtio-vga \
#   -device virtio-rng-device,rng=rng0 \
#   -device virtio-blk-device,drive=hd0 \
#   -device virtio-net-device,netdev=usernet \
#   -netdev user,id=usernet,hostfwd=tcp::"$ssh_port"-:22 \
#   -device qemu-xhci -usb -device usb-kbd -device usb-tablet"

cmd="qemu-system-riscv64 \
-nographic -machine virt \
-smp "$vcpu" -m "$memory"G \
-bios "$fw" \
-drive file="$drive",format=qcow2,id=hd0 \
-object rng-random,filename=/dev/urandom,id=rng0 \
-device virtio-vga \
-device virtio-rng-device,rng=rng0 \
-device virtio-blk-device,drive=hd0 \
-netdev bridge,id=nd0,br=br0 \
-device virtio-net-pci,netdev=nd0 \
-device qemu-xhci -usb -device usb-kbd -device usb-tablet"


echo ${YELLOW}:: Starting VM...${RESTORE}
echo ${YELLOW}:: Using following configuration${RESTORE}
echo ""
echo ${YELLOW}vCPU Cores: "$vcpu"${RESTORE}
echo ${YELLOW}Memory: "$memory"G${RESTORE}
echo ${YELLOW}Disk: "$drive"${RESTORE}
echo ${YELLOW}SSH Port: "$ssh_port"${RESTORE}
echo ""
echo ${YELLOW}:: NOTE: Make sure ONLY ONE .qcow2 file is${RESTORE}
echo ${YELLOW}in the current directory${RESTORE}
echo ""
echo ${YELLOW}:: Tip: Try setting DNS manually if QEMU user network doesn\'t work well. ${RESTORE}
echo ${YELLOW}:: HOWTO -\> https://serverfault.com/a/810639 ${RESTORE}
echo ""
echo ${YELLOW}:: Tip: If \'ping\' reports permission error, try reinstalling \'iputils\'. ${RESTORE}
echo ${YELLOW}:: HOWTO -\> \'sudo dnf reinstall iputils\' ${RESTORE}
echo ""

sleep 2

eval $cmd