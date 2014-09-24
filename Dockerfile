# VERSION 1.2
# DOCKER-VERSION  1.2.0
# AUTHOR:         Richard Lee <lifuzu@gmail.com>
# DESCRIPTION:    Service Image Container

FROM dockerbase/openssh-server

# Run dockerbase script
ADD     syslog-ng.sh /dockerbase/
RUN     /dockerbase/syslog-ng.sh

# Add syslog-ng into runit
ADD	build/runit/syslog-ng /etc/service/syslog-ng/run
# Replace the system() source because inside Docker we can't access /proc/kmsg.
# https://groups.google.com/forum/#!topic/docker-user/446yoB0Vx6w
RUN	sed -i -E 's/^(\s*)system\(\);/\1unix-stream("\/dev\/log");/' /etc/syslog-ng/syslog-ng.conf
# Uncomment 'SYSLOGNG_OPTS="--no-caps"' to avoid the following warning:
# syslog-ng: Error setting capabilities, capability management disabled; error='Operation not permitted'
# http://serverfault.com/questions/524518/error-setting-capabilities-capability-management-disabled#
RUN	sed -i 's/^#\(SYSLOGNG_OPTS="--no-caps"\)/\1/g' /etc/default/syslog-ng

# Run dockerbase script
ADD     cron.sh /dockerbase/
RUN     /dockerbase/cron.sh

# Add cron into runit
ADD     build/runit/cron /etc/service/cron/run

# Remove useless cron entries.
# Checks for lost+found and scans for mtab.
RUN	rm -f /etc/cron.daily/standard


