#!/bin/sh

source /home/stack/stackrc
openstack overcloud container image prepare \
   --namespace={{ satellite_host }}:{{ satellite_port }} \
   --prefix=dis-osp13_containers- \
   --tag-from-label {version}-{release} \
   --output-env-file=/home/stack/ansible-generated/templates-noaci/environments/overcloud_images.yaml \
   -r /home/stack/ansible-generated/templates-noaci/roles_data.yaml \
   -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
   -e /usr/share/openstack-tripleo-heat-templates/extraconfig/pre_deploy/rhel-registration/environment-rhel-registration.yaml \
   -e /home/stack/ansible-generated/templates-noaci/environments/satellite-registration.yaml \
   -e /usr/share/openstack-tripleo-heat-templates/environments/ssl/tls-endpoints-public-dns.yaml \
   -e /home/stack/ansible-generated/templates-noaci/environments/network-environment.yaml \
   -e /home/stack/ansible-generated/templates-noaci/environments/external-storage-environment.yaml \
   -e /home/stack/ansible-generated/templates-noaci/environments/misc-settings.yaml \
   -e /home/stack/ansible-generated/templates-noaci/environments/firstboot-environment.yaml \
   -e /home/stack/ansible-generated/templates-noaci/environments/vip-config.yaml \
   -e /home/stack/ansible-generated/templates-noaci/environments/idm-settings.yaml \
   -e /home/stack/ansible-generated/templates-noaci/environments/scaleio-sdc.yaml \
   -e /home/stack/ansible-generated/templates-noaci/environments/custom-glance-api.yaml \
   -e /home/stack/ansible-generated/templates-noaci/environments/enable-tls.yaml \
   -e /home/stack/ansible-generated/templates-noaci/environments/inject-trust-anchor-hiera.yaml \
   -e /home/stack/ansible-generated/templates-noaci/environments/set-domain-postconfig.yaml \
   -e /home/stack/ansible-generated/templates-noaci/environments/instance-domain.yaml \
   -e /home/stack/ansible-generated/templates-noaci/environments/compute-instance-ha-fence.yaml \
   -e /usr/share/openstack-tripleo-heat-templates/environments/compute-instanceha.yaml \
   -e /home/stack/ansible-generated/templates-noaci/environments/overcloud_images.yaml
