#!/bin/bash
# you need yo run the script with sudo, so
if [ "$EUID" -ne 0 ]; then
  echo "run this with sudo."
  exec sudo "$0" "$@"
  exit
fi
User="myapiuser"
Log_dir="/home/logs"
#in script 5, I set permissions to rwx, so it need to be changed to rw
setfacl -R -m u:"$User":rw "$Log_dir"
# rw permissions for new files
setfacl -d -m u:"$User":rw "$Log_dir"
