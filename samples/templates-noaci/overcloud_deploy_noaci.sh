#!/bin/sh

source /home/stack/stackrc

openstack overcloud deploy --stack overcloud-{{ named_env }} --templates \
-r /home/stack/ansible-generated/templates-noaci/roles_data.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/ssl/tls-endpoints-public-dns.yaml \
-e /home/stack/ansible-generated/templates-noaci/environments/network-environment.yaml \
-e /home/stack/ansible-generated/templates-noaci/environments/external-storage-environment.yaml \
-e /home/stack/ansible-generated/templates-noaci/environments/misc-settings.yaml \
-e /home/stack/ansible-generated/templates-noaci/environments/firstboot-environment.yaml \
-e /home/stack/ansible-generated/templates-noaci/environments/vip-config.yaml \
-e /home/stack/ansible-generated/templates-noaci/environments/scaleio-sdc.yaml \
-e /home/stack/ansible-generated/templates-noaci/environments/enable-tls.yaml \
-e /home/stack/ansible-generated/templates-noaci/environments/inject-trust-anchor-hiera.yaml \
-e /home/stack/ansible-generated/templates-noaci/environments/set-domain-postconfig.yaml \
-e /home/stack/ansible-generated/templates-noaci/environments/instance-domain.yaml \
-e /home/stack/ansible-generated/templates-noaci/environments/extra-configs.yaml \
-e /home/stack/ansible-generated/templates-noaci/environments/keystone_domain_specific_ldap_backend.yaml \
-e /home/stack/ansible-generated/templates-noaci/environments/overcloud_images.yaml
