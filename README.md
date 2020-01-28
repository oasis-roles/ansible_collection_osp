[![Build Status](https://travis-ci.com/oasis-roles/osp_director.svg?branch=master)](https://travis-ci.com/oasis-roles/osp_director)

osp_director
===========

Installs OSP Director and runs installs. This role mimics the steps in the
[OSP 13](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/13/html-single/director_installation_and_usage/)
install document from Red Hat. This particular role covers chapters 4 and 6 in
the above document. Some steps are omitted because they are covered
in other roles within OASIS. For example

* 4.1 - Creating the stack user. See the
[users\_and\_groups](https://github.com/oasis-roles/users_and_groups) role
* 4.3 - Setting the undercloud hostname. See the
[hostname](https://github.com/oasis-roles/hostname) role
* 4.4 - Registering and updating your undercloud. See the
[rhsm](https://github.com/oasis-roles/rhsm) role. Also, be sure to run an update
on all the systems before running this role
* 4.7 - Configuring the director. This step is just uploading the templates, which
is the job of [osp\_templates](https://github.com/oasis-roles/osp_templates).
* A.7 Trust overcloud cert from the undercloud. Handling overcloud certificates
is the work of [update\_ca\_trust](https://github.com/oasis-roles/update_ca_trust).


Requirements
------------

Ansible 2.9 or higher

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
