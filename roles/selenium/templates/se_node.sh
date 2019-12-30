#!/bin/bash -e
# Connect browser to the Selenium Grid on Jenkins

# Download selenium if needed
if [ ! -f selenium-server-standalone-{{ selenium_version }}.jar ]
then
    wget "{{ selenium_download }}"
fi

HUB_URL=http://{{ inventory_hostname }}:4444
java -jar selenium-server-standalone-{{ selenium_version }}.jar -role node -hub $HUB_URL -nodeConfig "$(uname).json"
read -r
