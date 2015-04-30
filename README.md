buildserver
===========
*Java, Ant, Maven, Gradle, Jenkins, Sonar, Nexus, Artifactory with MariaDB as database.*

This build server on Centos is provisioned with Vagrant and Ansible. It uses several roles published on http://galaxy.ansible.com.

Plugins for Jenkins and Sonar are provisioned from specs in roles/jenkins/vars/main.yml and roles/sonar/vars/main.yml.

It comes fully configure with the example project (game-of-life) of the book "Jenkins, the Definitive Guide".
That is an open source book available at http://www.wakaleo.com/books/jenkins-the-definitive-guide


requirements
============
*Vagrant and Ansible; and VirtualBox or VMWare (Fusion)*

http://download.virtualbox.org/virtualbox/4.3.18/
https://dl.bintray.com/mitchellh/vagrant/

getting started
===============
    git clone https://github.com/bbaassssiiee/buildserver
    cd buildserver
    ansible-playbook -v -i ansible.ini -l local install.yml 
    vagrant up

Connect to the buildserver at the host-only address http://192.168.10.16 (you can set that address in the Vagrantfile)
