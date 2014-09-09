#!/bin/bash
set -e
source /build/config
set -x

# Install runit.
apt-get install -y --no-install-recommends runit
