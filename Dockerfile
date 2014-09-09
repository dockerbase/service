# VERSION 1.0
# DOCKER-VERSION  1.2.0
# AUTHOR:         Richard Lee <lifuzu@gmail.com>
# DESCRIPTION:    Ubuntu Image Container

FROM dockerbase/ubuntu

MAINTAINER Richad Lee "lifuzu@gmail.com"

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

# Run the build scripts
RUN	apt-get update

# Install runit.
RUN	apt-get install -y runit

# Install syslog-ng.
RUN	apt-get install -y --no-install-recommends syslog-ng-core
RUN	mkdir -p /etc/service/syslog-ng
ADD	build/runit/syslog-ng /etc/service/syslog-ng/run
# Replace the system() source because inside Docker we can't access /proc/kmsg.
# https://groups.google.com/forum/#!topic/docker-user/446yoB0Vx6w
RUN	sed -i -E 's/^(\s*)system\(\);/\1unix-stream("\/dev\/log");/' /etc/syslog-ng/syslog-ng.conf
# Uncomment 'SYSLOGNG_OPTS="--no-caps"' to avoid the following warning:
# syslog-ng: Error setting capabilities, capability management disabled; error='Operation not permitted'
# http://serverfault.com/questions/524518/error-setting-capabilities-capability-management-disabled#
RUN	sed -i 's/^#\(SYSLOGNG_OPTS="--no-caps"\)/\1/g' /etc/default/syslog-ng

# Install openssh-server.
RUN	apt-get install -y --no-install-recommends openssh-server

# Config openssh-server.
RUN	mkdir /var/run/sshd
RUN	mkdir -p /etc/service/sshd
ADD	build/runit/sshd /etc/service/sshd/run

## Install default SSH key for root.
RUN	mkdir -p /root/.ssh && \
	chmod 700 /root/.ssh && \
	chown root:root /root/.ssh
ADD	build/insecure_key.pub /etc/insecure_key.pub
ADD	build/insecure_key /etc/insecure_key
RUN	chmod 644 /etc/insecure_key* && \
	chown root:root /etc/insecure_key*
ADD	build/bin/enable_insecure_key /usr/sbin/

## Install cron daemon.
RUN     apt-get install -y --no-install-recommends cron
RUN	mkdir -p /etc/service/cron
ADD	build/runit/cron /etc/service/cron/run

# Remove useless cron entries.
# Checks for lost+found and scans for mtab.
RUN	rm -f /etc/cron.daily/standard

# Runit
ADD	build/runit/1 /etc/runit/1
ADD	build/runit/1.d/cleanup-pids /etc/runit/1.d/cleanup-pids
ADD	build/runit/2 /etc/runit/2

# Clean up system
RUN	apt-get clean
RUN	rm -rf /tmp/* /var/tmp/*
RUN	rm -rf /var/lib/apt/lists/*

# Set environment variables.
ENV 	HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
ENTRYPOINT ["/usr/sbin/runsvdir-start"]
CMD ["-P", "/etc/service"]

