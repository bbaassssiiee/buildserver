# Buildserver

## In short

This is a complete development environment provisioned with Ansible+Vagrant.

The build server on Centos is provisioned with Vagrant and Ansible.
It uses several roles published on [http://galaxy.ansible.com](http://galaxy.ansible.com).
**Java, Ant, Maven, Gradle, Jenkins, Sonar, Nexus, Artifactory with MariaDB as database.**
It comes fully configured with the example project (game-of-life)
of the open source book ["Jenkins, the Definitive Guide"](http://www.wakaleo.com/books/jenkins-the-definitive-guide).
Plugins for Jenkins and Sonar are provisioned from specs in
`roles/jenkins/vars/main.yml` and `roles/sonar/vars/main.yml`.

**Tomcat+PostgreSQL** are deployed on a separate VM to mimic production.

**Windows 7 IE 10** is used for post-deployment testing.

## Requirements

### On Windows

 1. [Chocolatey](https://chocolatey.org) (on windows only)
 1. [VirtualBox](http://download.virtualbox.org/virtualbox/4.3.30/)
 1. Install Ansible, Vagrant & Cygwin using [this Powershell script](https://github.com/Hruodland/cygvagans)

### On Mac

Install/Upgrade **XCode** from the AppStore.
 **HomeBrew**,
 **Caskroom**,
 **VirtualBox**,
 **Vagrant**,
 **Ansible**

It is easiest to install homebrew first, from **[brew.sh](http://brew.sh)**, then:

```
    brew install --upgrade python
    brew install --upgrade ansible
    brew install caskroom/cask/brew-cask
    brew cask install --upgrade virtualbox
    brew cask install --upgrade vagrant
```

Note that it is custom nowadays on mac to change ownership for
`/usr/local`, so you don't need sudo.

### On RedHat/Fedora/Centos Linux

Run `yum install ansible`

Download & install [VirtualBox](http://download.virtualbox.org/virtualbox/4.3.30/)

Download & install [Vagrant](https://dl.bintray.com/mitchellh/vagrant/)

## Quickstart

You need access to the internet (i.e. `nslookup mirrorlist.centos.org` should work)

### Add these hostnames to `/etc/hosts` or to \WINDOWS\SYSTEM32\drivers\etc\hosts

```
    192.168.10.16 dev
    192.168.10.18 target
    192.168.10.28 lab
    192.168.10.36 nolio
    192.168.10.40 windows
```

### Fork & clone this repo

```
    git clone https://github.com/bbaassssiiee/buildserver
    cd buildserver
    make install
```

### Bring up 2 virtual machines

'dev' the CI server and 'target' the Tomcat server

```
    vagrant up --no-provision
```

### Run the provisioner

```
    ansible-playbook -l dev:target provision.yml
```

### Install Docker on target too

```
    ansible-playbook -l target playbook.yml
```

### Bring up the windows 7 VM, and provision it

```
    vagrant up --no-provision windows
    ansible-playbook -l windows provision.yml
```

### Connect to the buildserver

At the host-only address [http://192.168.10.16](http://192.168.10.16).
You can set that address in the Vagrantfile.

## Development

Please use the github issue tracker.
Feature requests, bug reports, etc, should all be opened as GitHub tickets.
Pull-requests should not contain any merges or merge-conflicts.
In general for each change fork the repository,
make changes, and submit a specific pull-request.
