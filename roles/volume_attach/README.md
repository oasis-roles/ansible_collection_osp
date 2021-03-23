volume\_attach
===========

This role will attach a Cinder volume or volumes to an OpenStack VM.
The volumes need to be created elsewhere.

It would be typical to delegate these connections to a separate host, such
as the control host `delegate_to: localhost`, but nothing requires that you
do so.

Requirements
------------

Ansible 2.8 or higher

Role Variables
--------------

Currently the following variables are supported:

### General

* `volume_attach_volumes` - Default: `[]`. The list of volumes to attach to
  the server. Each element must have a `name` attribute which can be either
  the name or ID of the volume to attach. It can also have an optional
  `device` attribute to specify the udev name to attempt to assign to the
  given volume.
* `volume_attach_server` - Default: `inventory_hostname`. The OpenStack VM
  name to attach the volumes to. Defaults to the current hostname.
* `volume_attach_os_client_config` - Default: `~/.config/openstack/clouds.yaml`.
  The name of the OpenStack clouds.yaml formatted file to give OSP auth
  information.
* `volume_attach_os_cloud` - Default: `${OS_CLOUD}`. The OpenStack Cloud entry
  from the clouds.yaml file to use for auth

Dependencies
------------

Collection `openstack.cloud`
`openstacksdk` Python package

Example Playbook
----------------

```yaml
- hosts: volume_attach-servers
  roles:
    - role: oasis_roles.system.volume_attach
      volume_attach_volumes:
        - name: my_volume1
        - name: my_volume2
          device: /dev/sdd
      delegate_to: open_stack_ctrl_host
```

License
-------

GPLv3

Author Information
------------------

Greg Hellings <greg.hellings@gmail.com>
