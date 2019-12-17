#!/bin/bash
hostname -s | grep ctrl
if [ $? != 0 ]; then
  echo "Not a controller"
  exit 0
fi
cat << EOF > /etc/keystone/domains/keystone.IDMDOMAINNAME.conf
[ldap]
url=IDMSERVERS
user=IDMBINDUSER
password=IDMBINDPASSWORD
user_tree_dn=IDMUSERTREE
user_filter=IDMUSERFILTER
group_filter=IDMGROUPFILTER
user_objectclass=person
user_id_attribute=cn
user_name_attribute=sAMAccountName
user_mail_attribute=mail
user_pass_attribute=
user_enabled_attribute=userAccountControl
user_enabled_mask=2
user_enabled_default=512
user_allow_create=False
user_allow_update=False
user_allow_delete=False
group_tree_dn=IDMGROUPTREE
group_id_attribute=cn
group_name_attribute=name
group_objectclass=group
group_allow_create=False
group_update_create=False
group_delete_create=False
group_member_attribute=member
query_scope=sub
tls_cacertfile=/etc/keystone/ldap-ca.crt

[identity]
driver=ldap

[assignment]
driver=sql
EOF

cat << EOF > /etc/keystone/ldap-ca.crt
IDMCACERT
EOF

chown root:keystone /etc/keystone/domains/keystone.IDMDOMAINNAME.conf
chown root:keystone /etc/keystone/ldap-ca.crt
chmod 0640 /etc/keystone/domains/keystone.IDMDOMAINNAME.conf
chmod 0640 /etc/keystone/ldap-ca.crt

restorecon -R /etc/keystone

openstack -f value --c Name --os-auth-url "$(hiera keystone::endpoint::admin_url)" --os-identity-api-version 3 --os-username admin --os-password $(hiera keystone::roles::admin::password) --os-project-name admin domain list | grep IDMDOMAINNAME

if [ $? != 0 ]; then
    openstack --os-auth-url "$(hiera keystone::endpoint::admin_url)" --os-identity-api-version 3 --os-username admin --os-password $(hiera keystone::roles::admin::password) --os-project-name admin domain create IDMDOMAINNAME
fi

ROLE_ASSIGNED=$(openstack --os-auth-url "$(hiera keystone::endpoint::admin_url)" --os-identity-api-version 3 --os-username admin --os-password $(hiera keystone::roles::admin::password) --os-project-name admin role assignment list --user admin --domain default --role admin -f value -c Role | wc -l)

if [ $ROLE_ASSIGNED == 0 ]; then
    openstack --os-auth-url "$(hiera keystone::endpoint::admin_url)" --os-identity-api-version 3 --os-username admin --os-password $(hiera keystone::roles::admin::password) --os-project-name admin role add --domain default --user admin admin
fi

systemctl reload httpd
