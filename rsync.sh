# Run the build scripts
apt-get update

# Install rsync.
apt-get install -y --no-install-recommends rsync

# Clean up system
apt-get clean
rm -rf /tmp/* /var/tmp/*
rm -rf /var/lib/apt/lists/*
