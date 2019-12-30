@ECHO OFF
cd D:\Program Files\Selenium
SET HUB_URL=http://{{ inventory_hostname }}:4444
java -jar selenium-server-standalone-{{ selenium_version }}.jar -role node -nodeConfig "Windows.json" -hub %HUB_URL%
@pause
