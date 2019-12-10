[![Build Status](https://travis-ci.com/oasis-roles/osp_templates.svg?branch=master)](https://travis-ci.com/oasis-roles/osp_templates)

osp_templates
===========

Basic description for osp_templates

Requirements
------------

Ansible 2.4 or higher

Red Hat Enterprise Linux 7 or equivalent

Valid Red Hat Subscriptions

Role Variables
--------------

Currently the following variables are supported:

### General

* `osp_templates_become` - Default: true. If this role needs administrator
  privileges, then use the Ansible become functionality (based off sudo).
* `osp_templates_become_user` - Default: root. If the role uses the become
  functionality for privilege escalation, then this is the name of the target
  user to change to.

Dependencies
------------

None

Example Playbook
----------------

```yaml
- hosts: osp_templates-servers
  roles:
    - role: oasis_roles.osp_templates
```

License
-------

GPLv3

Author Information
------------------

Author Name <authoremail@domain.net>