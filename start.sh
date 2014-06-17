#!/bin/bash
chown -R gogs:gogs /home/gogs/
export HOME=/home/gogs
su -m gogs /home/gogs/gogs/start.sh
