#!/bin/bash
set -x
source /home/stack/stackrc
export TMPDIR=/var/imgtmp
export DIB_DEBUG_TRACE=1
export DIB_LOCAL_IMAGE=/home/stack/rhel-server-7.6-update-5-x86_64-kvm.qcow2
export REG_METHOD=satellite
export REG_SAT_URL=http://{{ satellite_host }}
export REG_SERVER_URL={{ satellite_host }}
export REG_ACTIVATION_KEY=Test_OpenStack
export REG_ORG=Cloud
export REG_REPOS="rhel-7-server-rpms rhel-7-server-extras-rpms rhel-ha-for-rhel-7-server-rpms rhel-7-server-optional-rpms rhel-7-server-rhceph-3-tools-rpms rhel-7-server-openstack-13-rpms"
export DIB_BLOCK_DEVICE_CONFIG='''
- local_loop:
    directory: /var/imgtmp/
    name: image0
- partitioning:
    base: image0
    label: mbr
    partitions:
      - name: boot
        flags: [ boot,primary ]
        size: 2G
      - name: root
        flags: [ primary ]
        size: 75G
- lvm:
    name: lvm
    base: [ root ]
    pvs:
        - name: pv
          base: root
          options: [ "--force" ]
    vgs:
        - name: vg
          base: [ "pv" ]
          options: [ "--force" ]
    lvs:
        - name: lv_root
          base: vg
          extents: 23%VG
        - name: lv_tmp
          base: vg
          extents: 4%VG
        - name: lv_var
          base: vg
          extents: 40%VG
        - name: lv_log
          base: vg
          extents: 23%VG
        - name: lv_audit
          base: vg
          extents: 9%VG
        - name: lv_home
          base: vg
          extents: 1%VG
- mkfs:
    name: fs_boot
    base: boot
    type: ext4
    mount:
        mount_point: /boot
        fstab:
            options: "defaults"
            fsck-passno: 2
- mkfs:
    name: fs_root
    base: lv_root
    type: xfs
    label: "img-rootfs"
    mount:
        mount_point: /
        fstab:
            options: "rw,relatime"
            fsck-passno: 1
- mkfs:
    name: fs_tmp
    base: lv_tmp
    type: xfs
    mount:
        mount_point: /tmp
        fstab:
            options: "rw,nosuid,nodev,noexec,relatime"
            fsck-passno: 2
- mkfs:
    name: fs_var
    base: lv_var
    type: xfs
    mount:
        mount_point: /var
        fstab:
            options: "rw,relatime"
            fsck-passno: 2
- mkfs:
    name: fs_log
    base: lv_log
    type: xfs
    mount:
        mount_point: /var/log
        fstab:
            options: "rw,relatime"
            fsck-passno: 3
- mkfs:
    name: fs_audit
    base: lv_audit
    type: xfs
    mount:
        mount_point: /var/log/audit
        fstab:
            options: "rw,relatime"
            fsck-passno: 4
- mkfs:
    name: fs_home
    base: lv_home
    type: xfs
    mount:
        mount_point: /home
        fstab:
            options: "rw,nodev,relatime"
            fsck-passno: 2
'''

openstack overcloud image build \
--image-name overcloud-hardened-full \
--config-file /home/stack/templates-noaci/overcloud-hardened-images.yaml \
--config-file /usr/share/openstack-tripleo-common/image-yaml/overcloud-hardened-images-rhel7.yaml
