# Run the build scripts
apt-get update

# Install ntp.
apt-get install -y --no-install-recommends ntp

# Clean up system
apt-get clean
rm -rf /tmp/* /var/tmp/*
rm -rf /var/lib/apt/lists/*
