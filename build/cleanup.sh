#!/bin/bash
set -e
source /build/config
set -x

# Clean up system
apt-get clean
rm -rf /build
rm -rf /tmp/* /var/tmp/*
rm -rf /var/lib/apt/lists/*

rm -f /etc/ssh/ssh_host_*
