overcloud
===========

Basic description for overcloud

Requirements
------------

Ansible 2.8 or higher

Red Hat Enterprise Linux 7 or equivalent

Valid Red Hat Subscriptions

Role Variables
--------------

Currently the following variables are supported:

### General

* `overcloud_environment_files` - Default: `[]`. A list of the environment
  files within the templates directory to use in the deploy. The list of
  options passed to the deploy command that use the '-e' flag.
* `overcloud_templates` - Default: `~/templates`. Path to the templates
  files to use in deployment.
* `overcloud_network_data` - Default: `network_data.yml`. The option
  passed to the '-n' flag.
* `overcloud_role_data` - Default: `role-data.yml`. The option passed to the
  '-r' flag.
* `overcloud_extra_args` - Default: `''`. Any extra command-line shell
  options
* `overcloud_become` - Default: true. If this role needs administrator
  privileges, then use the Ansible become functionality (based off sudo).
* `overcloud_become_user` - Default: root. If the role uses the become
  functionality for privilege escalation, then this is the name of the target
  user to change to.

Dependencies
------------

None

Example Playbook
----------------

```yaml
- hosts: overcloud-servers
  roles:
    - role: oasis_roles.system.overcloud
```

License
-------

GPLv3

Author Information
------------------

Greg Hellings <greg.hellings@gmail.com>
