#!/bin/sh
cat > /etc/yum.repos.d/director.repo << EOF
DIRECTOR_REPOS
EOF

export MDM_IP=SCALEIOMDMIPS
yum makecache fast
yum install -y EMC-ScaleIO-sdc
