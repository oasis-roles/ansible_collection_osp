disable\_vm\_port\_security
===========

Disables OpenStack port security on ports connected to a given list
of hosts

Requirements
------------

Ansible 2.8 or higher

Role Variables
--------------

Currently the following variables are supported:

### General

* `disable_vm_port_security_server_name` - Default: `''`. A shell-style glob of the
  server or server names to be modified. So if you want to modify servers named
  "test1", "test2", and "testother" you can set this value to "test\*".
* `disable_vm_port_security_os_client_config` - Default `~/.config/openstack/clouds.yaml`.
  The OpenStack client config file path.
* `disable_vm_port_security_os_cloud` - Default: `{{ lookup('env', 'OS_CLOUD') }}`.
  The name of the cloud entry in the client config file to use for the connection. If no
  value is set, this is omitted, but that will result in an error from the modules.
* `disable_vm_port_security_become` - Default: true. If this role needs administrator
  privileges, then use the Ansible become functionality (based off sudo).
* `disable_vm_port_security_become_user` - Default: root. If the role uses the become
  functionality for privilege escalation, then this is the name of the target
  user to change to.

Dependencies
------------

Collection `openstack.cloud`
`openstacksdk` Python package

Example Playbook
----------------

```yaml
- hosts: disable_vm_port_security-servers
  roles:
    - role: oasis_roles.system.disable_vm_port_security
      disable_vm_port_security_os_client_config: "{{ lookup('env', 'PWD') }}/environments/clouds.yaml"
  environment:
    OS_CLOUD: mycloud
```

License
-------

GPLv3

Author Information
------------------

Greg Hellings <greg.hellings@gmail.com>
