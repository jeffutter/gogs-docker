#!/bin/bash

service ssh start
/settings /home/gogs/gogs/custom/conf/app.ini
chown -R gogs:gogs /home/gogs/
export HOME=/home/gogs
su -m gogs /home/gogs/gogs/start.sh
