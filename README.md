[![Build Status](https://travis-ci.com/oasis-roles/osp_templates.svg?branch=master)](https://travis-ci.com/oasis-roles/osp_templates)

osp_templates
===========

Ansible role to template an entire directory structure efficiently. It can be operated
in different modes to template either the entire structure or to leverage git to only
template files which have changed. Rsync is used to drop the final files into place
once the temlpating step is complete

Requirements
------------

Ansible 2.9 or higher

If running in Quick mode, requires git.

If running in Copy Only mode, requires rsync.

Role Variables
--------------

Currently the following variables are supported:

### General

* `osp_templates_output_dir` - REQUIRED. The target directory into which files
  are going to be generated.
* `osp_templates_input_dir` - Default: `sample/templates`. The sample folder in
  this role contains a default set of templates for configuring an OpenStack
  Director node.
* `osp_templates_quick_mode` - Default: false. Use git in the input directory and
  only template files which are reported as changed in the git tree.
* `osp_templates_copy_only` - Default: false. Use rsync to copy files from the
  input directory to the output directory
* `osp_templates_owner` - The owner of the files and directories to be
  generated out of the templating process. By default, the behavior of the
  template/file modules will be maintained.
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
