[![Build Status](https://travis-ci.com/oasis-roles/osp_director.svg?branch=master)](https://travis-ci.com/oasis-roles/osp_director)

osp_director
===========

Basic description for osp_director

Requirements
------------

Ansible 2.4 or higher

Red Hat Enterprise Linux 7 or equivalent

Valid Red Hat Subscriptions

Role Variables
--------------

Currently the following variables are supported:

### General

* `osp_director_become` - Default: true. If this role needs administrator
  privileges, then use the Ansible become functionality (based off sudo).
* `osp_director_become_user` - Default: root. If the role uses the become
  functionality for privilege escalation, then this is the name of the target
  user to change to.

Dependencies
------------

None

Example Playbook
----------------

```yaml
- hosts: osp_director-servers
  roles:
    - role: oasis_roles.osp_director
```

License
-------

GPLv3

Author Information
------------------

Author Name <authoremail@domain.net>