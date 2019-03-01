#!/bin/bash -e
wget "{{ selenium_download }}"
HUB_URL=http://{{ inventory_hostname }}:4444
java -jar selenium-server-standalone-{{ selenium_version }}.jar -role node -hub $HUB_URL -nodeConfig "macConfig.json"
