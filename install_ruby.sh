#!/bin/sh -ex

if [ -f /etc/debian_version ]; then
  ri_OS=Debian
  ri_OS_VER=$(cat /etc/debian_version)
fi
echo $ri_OS

