#!/bin/bash
FIRST_DISK=$(lsblk -n -d --output NAME | head -n 1)
DEVICE="/dev/$FIRST_DISK"
PARTITION="/dev/$FIRST_DISK"2
growpart $DEVICE 2
pvresize $PARTITION
lvresize -r -l+100%FREE /dev/vg/lv_var
