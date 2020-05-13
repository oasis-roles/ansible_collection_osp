cli\_tools
===========

Installs and configures some basic userland tools to help with on-box debugging
and configuration needs. Primarily sets up tmux and configures some useful
aliases on the box

Requirements
------------

Ansible 2.8 or higher

Role Variables
--------------

Currently the following variables are supported:

### General

* `osp_cli_tools_user_dirs` - A list of usernames and directories to install
  configuration files to (e.g. .tmux.conf). Deafults to:
```yaml
- user: "{{ ansible_user_id }}"
  dir: "{{ ansibler_user_home }}"
```
* `osp_cli_tools_become` - Default: true. If this role needs administrator
  privileges, then use the Ansible become functionality (based off sudo).
* `osp_cli_tools_become_user` - Default: root. If the role uses the become
  functionality for privilege escalation, then this is the name of the target
  user to change to.

Dependencies
------------

None

Example Playbook
----------------

```yaml
- hosts: osp_cli_tools-servers
  roles:
    - role: oasis_roles.osp.cli_tools
```

License
-------

GPLv3

Author Information
------------------

Greg Hellings <greg.hellings@gmail.com>
