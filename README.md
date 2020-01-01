README:

[![Build Status](https://travis-ci.org/bbaassssiiee/buildserver.svg?branch=master)](https://travis-ci.org/bbaassssiiee/buildserver)

Buildserver
===========
This is a complete development environment provisioned with Ansible+Vagrant.

The build server on Centos is provisioned with Vagrant and Ansible. It uses several roles published on http://galaxy.ansible.com.
**C++17 with Boost, Miniconda, Java 8,11,13, Ant, Maven, Gradle, Jenkins, Sonar, Artifactory with MariaDB as database.**
It comes fully configured with the example project (game-of-life) of the open source book ["Jenkins, the Definitive Guide"](http://www.wakaleo.com/books/jenkins-the-definitive-guide).
Plugins for Jenkins and Sonar are provisioned from specs in roles/jenkins/vars/main.yml and roles/sonar/vars/main.yml.

**Docker** is deployed on a separate VM to mimic production.
**Windows 2016** can be used for compiling Java8/C++ with Boost, or IE testing.

Requirements
============
On Windows
----------
1. [Chocolatey](https://chocolatey.org) (on windows only)
2. [VirtualBox](http://download.virtualbox.org/virtualbox/6.0.14/)
3. Install Ansible, Vagrant & Cygwin using [this Powershell script](https://github.com/Hruodland/cygvagans)


On Mac
----------------------
 **VirtualBox**,
 **Vagrant**,

On RedHat/Fedora/Centos Linux:
------------------------------
 `yum install ansible`

 Download & install [VirtualBox](http://download.virtualbox.org/virtualbox/6.0.14/)

 Download & install [Vagrant](https://www.vagrantup.com/downloads.html)


Quickstart
==========
You need access to the internet (i.e. `nslookup mirrorlist.centos.org` should work)

**Add these hostnames** to /etc/hosts or to \WINDOWS\SYSTEM32\drivers\etc\hosts

    192.168.10.28 build_master.test build_master

    192.168.10.16 centos6
    192.168.10.17 centos7
    192.168.10.18 rhel7
    192.168.10.19 trusty
    192.168.10.20 xenial
    192.168.10.40 windows

**Fork & clone this repo:**

    git clone https://github.com/bbaassssiiee/buildserver
    cd buildserver
    vagrant up

**Bring up additional virtual machines:**

    vagrant up centos7
    vagrant up centos6
    vagrant up win_slave

**Run the provisioner**

    vagrant ssh
    cd /vagrant
    ./provision.yml -i inventories/vagrant -

**Install Docker on target too**

    ansible-playbook -l centos7 playbook.yml

**Bring up the windows 7 VM, and provision it:**

    vagrant up --no-provision win_slave
    ansible-playbook -l win_slave provision.yml

**Connect to the buildserver** at the host-only address [http://192.168.10.28](http://192.168.10.28) (you can set that address in the Vagrantfile)

development
===============
Please use the github issue tracker. Feature requests, bug reports, etc, should all be opened as GitHub tickets.
Pull-requests should not contain any merges or merge-conflicts. In general for each change fork the repository, make changes, and submit a specific pull-request.

dockpack roles
==============

DOCKPACK roles store local facts to use:
```
"ansible_local": {
            "ant": {
                "ant": {
                    "ant_base": "/opt",
                    "ant_home": "/opt/apache-ant-1.10.5",
                    "ant_name": "apache-ant-1.10.5"
                }
            },
            "gradle": {
                "gradle": {
                    "gradle_home": "/opt/gradle-4.10.2",
                    "gradle_name": "gradle-4.10.2"
                }
            },
            "java8": {
                "java8": {
                    "java8_home": "/usr/lib/jvm/java",
                    "java8_name": "Java8"
                }
            },
            "maven": {
                "maven": {
                    "maven_home": "/opt/maven/apache-maven-3.5.4",
                    "maven_name": "apache-maven-3.5.4"
                }
            }
        }
```
