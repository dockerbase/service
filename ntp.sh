# Run the build scripts
apt-get update

# Install cron.
apt-get install -y --no-install-recommends cron

# Clean up system
apt-get clean
rm -rf /tmp/* /var/tmp/*
rm -rf /var/lib/apt/lists/*
