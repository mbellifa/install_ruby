#!/bin/sh -ex

#Root check 
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root." 1>&2
  exit 1
fi

if [ -f /etc/debian_version ]; then
  ri_OS=Debian
  ri_OS_VER=$(cat /etc/debian_version)
fi
echo $ri_OS

if [ "$ri_OS" = "Debian" ]; then
  apt-get update
fi
