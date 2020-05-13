templates
===========

Ansible role to template an entire directory structure efficiently. It can be operated
in different modes to template either the entire structure or to leverage git to only
template files which have changed. Rsync is used to drop the final files into place
once the templating step is complete

The role can operate in one of three modes. It has a "template all" mode, where
it walks the `osp_templates_input_dir` and processes each file through the Jinja2 filter
system and duplicates it into the `osp_templates_output_dir` structure. It can also
operate in a "quick" mode where it will do the same, but it will only operate on files
that are reported as changed by a git status. This will require that "git" be installed
on the Ansible operator node. The third mode is "copy only" mode, where rsync is used
to synchronize files from input to output directories. This requires rsync be installed
and that any hosts be accessible (without password arguments). For requirements on the
synchronize, check the [synchronize module](https://docs.ansible.com/ansible/latest/modules/synchronize_module.html#synchronize-module)
in Ansible.

The default mode is "template all". To enable quick mode set `osp_templates_quick_mode`
to true. This will avoid the extra time of evaluating every template. To enable copy
mode, set `osp_templates_copy_only` to true. Only one mode at a time can be executed.
See below for information on different ways to use the role multiple times if you need
to run in multiple steps.

There is a very extensive set of sample files in the `samples/` directory that should
be useful in deploying a [Red Hat OpenStack Platform](https://www.redhat.com/en/technologies/linux-platforms/openstack-platform)
instance with Director. These files are not necessarily going to be perfectly suited to
every environment or system. Feel free to grab those files, update them as appropriate,
and specify your own directory as the `osp_templates_input_dir` variable. Also, there is
nothing in this role, besides the samples, that is specifically tied to OpenStack.

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
  Director node. **copy_only** When executing in copy_only mode, this serves as the
  `src` paramter to the `synchronize` module. Thus, the presence or absence of a
  "/" at the end of the string is a significant detail in that mode, only
* `osp_templates_quick_mode` - Default: false. Use git in the input directory and
  only template files which are reported as changed in the git tree.
* `osp_templates_copy_only` - Default: false. Use rsync to copy files from the
  input directory to the output directory
* `osp_templates_owner` - The owner of the files and directories to be
  generated out of the templating process. By default, the behavior of the
  template/file modules will be maintained.
* `osp_templates_become` - Default: false. If this role needs administrator
  privileges, then use the Ansible become functionality (based off sudo).
* `osp_templates_become_user` - Default: root. If the role uses the become
  functionality for privilege escalation, then this is the name of the target
  user to change to.

### Sample Templates

The sample templates, which are appropriate for deploying a [Red Hat OpenStack
Platform](https://www.redhat.com/en/technologies/linux-platforms/openstack-platform)
instance with Director. To do so, it will depend on a few additional variables
that are not directly required by the role itself.

* `satellite_host` - Hostname or IP address for a satellite instance
* `satellite_port` - Port that the Satellite instance runs on, defaults to 5000
* `overcloud_nodes` - an array of dictionaries defining the nodes that
  will be part of the overcloud. Each element in the array should take the
  following form:
```yaml
name: node_name
arch: x86_64  # optional
role: compute | control
mac: some_mac_address  # optional mac address for the host
pm:  # This whole sub-dict is optional and defines power management interfaces
  addr: 10.0.0.1
  type: ipmi
  user: power
  password: somepass
```
* `named_env` - The stack name for the overcloud in Director's undercloud
  install process. TODO: How is this different from overcloud.cloudname mentioned
  below?!
* `overcloud` - A dictionary that defines aspects of the overcloud
  to be installed through Director. Components include:
```yaml
cloudname: MyAwesomeCloud
ControllerCount: 3
ComputeCount: 200
CephStorageCount: 20
ComputeHostnameFormat: '%s-some-%d-format'  # TODO: Where does this come from?!
ControllerHostnameFormat: '%s-some-controller-%d-format'  # TODO: Same as above
networks:  # an array of networks to create in the overcloud
  Control:
    cidr: 23  # Cidr prefix length for this network
    gateway_ip: 10.100.0.1  # IP for gateway of the Control network
  External:
    gateway_ip: 10.110.0.1  # IP for gateway of the External network
    default_route: true  # If this is the default gateway
    vip: 10.110.0.2  # Value of the vip for this network
    ip_subnet: 10.110.0.0
    vlan: 110
    allocation_pools:
      start: 10.110.0.10
      end: 10.110.0.200
  InternalApi:
    vip: myvip
    ip_subnet: 10.120.0.0
    vlan: 120
    allocation_pools:
      start: 10.120.0.10
      end: 10.120.0.200
  Management:  # Only include if there should be a separate Management network
    gateway_ip: 10.125.0.1
    default_route: false  # Set this as the default route network
    vlan: 125
    ip_subnet: 10.125.0.0
    allocation_pools:
      start: 10.125.0.10
      end: 10.125.0.200
  StorageMgmt:
    ip_subnet: 10.130.0.0
    vlan: 130
    allocation_pools:
      start: 10.130.0.10
      end: 10.130.0.200
  Storage:
    vip: 10.140.0.2
    ip_subnet: 10.140.0.0
    vlan: 140
    allocation_pools:
      start: 10.140.0.10
      end: 10.140.0.200
  Tenant:
    ip_subnet: 10.150.0.0
    vlan: 150
    allocation_pools:
      start: 10.150.0.10
      end: 10.150.0.200
dns_servers:  # list of DNS server addresses
  - 10.0.0.1
  - 8.8.4.4
  - 8.8.8.8
NtpServer: ntp.example.com
root_password: s0m3pass  # password for root accounts of the control plane nodes, set via Heat after creation
RedisVirtualFixedIP: 10.1.1.1  # IP for Redis
domain_name: example.com  # domain name for overcloud instances
ControlPlaneDefaultRoute: 192.168.1.1  # Gateway router for provisioning network or Undercloud IP
NeutronDhcpDomain: neutron.example.com
NeutronDnsDomain: neutron.example.com
swift:
  authurl: http://swift.example.com/
  key: swift_url_key
scaleio:
  protection_domain_name: scaleio.example.com
  storage_pool: scale_name
  san_ip: 10.199.1.1
  san_password: san_P4Ss
  MDMAddresses: mdm.scaleio.example.com  # ScaleIO MDM Addresses for the overcloud
```
* `undercloud` - A dictionary that defines aspects of the undercloud
  and looks like:
```yaml
ctlplane:
  vip: somevip  # The VIP for the undercloud's control plane
  subnet: 10.200.0.0
cidr: 192.168.1.1/24  # Most likely the IP of the undercloud itself
```
* `satellite` - A dictionary defining a Satellite instance that OpenStack nodes are subscribed
  to during installation. Takes the following form:
```yaml
overcloud:
  ak: my_activation_key  # Activation key for the satellite instance
  org: My Org Name  # Org name to register the system to
  hostname: hostname  # Hostname for overcloud nodes to register themselves to
  tools_repo: repo_name  # Repo to enable on the system
  port: 5000  # Host port satellite images are available on - defaults to 5000
```
* `IDM` - A dictionariy defining the LDAP idm server data
```yaml
domain: mydomain
servers: 192.168.1.10 192.168.1.11
bind_dn: some_user
bind_passwd: 's0m3_pass'
user_tree: "user tree DN"
user_filter: "some > user < filter = asdf"
group_tree: "group tree DN"
group_filter: "some > group % filter"
ca_cert: |-
  ca cert for
  the LDAP
  server
```
* `certs` - A collection of certificate anchors
```yaml
CAMap:
  - name: cert_name
    content: |-
      ======= CERT BEGIN ============
      blah blah blah
      ===============================
```

Dependencies
------------

If using the included samples/ directory, then you will need the "netaddr"
package for Python.

Example Playbook
----------------

A very minimal call that will execute in template-all mode using the built-in `samples/`
directory (this assumes that variables specific to the templates are defined elsewhere,
such as in group\_vars)
```yaml
- hosts: localhost
  roles:
    - role: oasis_roles.osp.templates
      osp_templates_output_dir: /some/output/string
```

To run the role in quick mode with a custom set of templates, ensure that the source files
are located within a git repository and run the following playbook:
```yaml
- hosts: some_hosts
  roles:
    - role: oasis_roles.osp.templates
      osp_templates_quick_mode: true
      osp_templates_input_dir: "{{ playbook_dir }}/my_site"
      osp_templates_output_dir: "{{ ansible_user_dir }}/public_html"
```

To generate templates locally, then synchronize them to a remote host, do:
```yaml
- hosts: localhost
  roles:
    - role: oasis_roles.osp.templates
      osp_templates_input_dir: "/home/user/website_templates"
      osp_templates_output_dir: "/home/user/website"
  post_tasks:
    - name: make sure rsync installed locally
      become: true
      package:
        name: rsync
        state: present


- hosts: webserver
  roles:
    - role: oasis_roles.osp.templates
      osp_template_intput_dir: /home/user/website  # no trailing '/' means the file goes, too
      osp_template_output_dir: /var/www  # will result in /var/www/website on remote
      osp_template_copy_only: true
```

License
-------

GPLv3

Author Information
------------------

Greg Hellings <greg.hellings@gmail.com>
Homero Pawlowski <homeski2@gmail.com>
