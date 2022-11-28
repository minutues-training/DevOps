#!/bin/bash
chmod -R 777 /var/log/logstash
chmod -R 777 /var/lib/logstash
/usr/share/logstash/bin/logstash --path.settings /etc/logstash -t
sudo /usr/share/logstash/bin/system-install /etc/logstash/startup.options systemd
cd /usr/share/logstash/
#bin/logstash-plugin list --verbose
bin/logstash-plugin install logstash-filter-grok
bin/logstash-plugin update
