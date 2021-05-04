security\_group
===========

Creates and configures OpenStack security groups.

Requirements
------------

Ansible 2.8 or higher

Role Variables
--------------

Currently the following variables are supported:

* `osp_security_group_cloud` - Default: `OS_CLOUD` environment variable.  Name
   of the OpenStack cloud from clouds.yaml.
* `osp_security_group_name` - Required.  Name of the security group to create.
* `osp_security_group_description` - Text description for the security group
* `osp_security_group_rules` - Required.  List of security group rules to
   create.

Dependencies
------------

openstacksdk >= 0.12.0

Example Playbook
----------------

NOTE:  This role runs on the Ansible control machine via `delegate_to:
localhost`, and not remote systems.

```yaml
- hosts: osp_security_group-servers
  roles:
    - role: oasis_roles.osp.security_group
  vars:
    osp_security_group_cloud: mycloud
    osp_security_group_name: mygroup
    osp_security_group_description: mygroup description
    osp_security_group_rules:
      - ethertype: IPv4
      - ethertype: IPv6
```

License
-------

GPLv3

Author Information
------------------

David Roble <droble@redhat.com>
