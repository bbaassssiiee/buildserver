#!/usr/bin/env python3
import unittest
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
import requests


class SeleniumCBT(unittest.TestCase):
    def setUp(self):

        self.api_session = requests.Session()
        self.test_result = None

        caps = {}
        caps['browserName'] = "chrome"
        caps['platform'] = "macOS 10.14"
        caps['platform'] = "MAC"
        caps['version'] = "79.0"

        self.driver = webdriver.Remote(
            desired_capabilities=caps,
            command_executor="http://{{ inventory_hostname }}:4444/wd/hub"
        )

        self.driver.implicitly_wait(20)

    def test_CBT(self):
        self.driver.get('http://crossbrowsertesting.github.io/selenium_example_page.html')
        self.assertEqual("Selenium Test Example Page", self.driver.title)
        self.test_result = 'pass'
        self.driver.quit()

    def test_Keys(self):
        self.driver.get('http://www.google.com')
        elem = self.driver.find_element_by_name("q")
        elem.send_keys("selenium")
        elem.submit()
        self.driver.quit()

if __name__ == '__main__':
    unittest.main()
