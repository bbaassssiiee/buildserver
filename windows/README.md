windows support
===========
This directory contains the information and scripts to get going with this project on the windows platform

VirtualBox
============
Download the Windows version of VirtualBox from: https://www.virtualbox.org/wiki/Downloads
(Used http://download.virtualbox.org/virtualbox/4.3.26/VirtualBox-4.3.26-98988-Win.exe at time of writing)

Vagrant
============
Download the Windows version of Vagrant from: http://www.vagrantup.com/downloads
(Used https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2.msi at time of writing) 

Buildserver
============
Download the Buildserver source from Git using:
    git clone https://github.com/bbaassssiiee/buildserver.git buildserver

Cygwin
============
Cygwin and the required modules can be downloaded and installed by executing the following script from the downloaded Git source:
    cd buildserver\windows
	cygwin_install.bat (accept the security warning)
In case the installer hangs for a long time, close the CMD dialog and just re-execute the above command
	
Ansible
============
Start the Cygwin64 shell by doubleclicking the shortcut on the Windows desktop.
On the cygwin prompt, cd to the buildserver home directory and execute:
    python /usr/lib/python2.7/site-packages/easy_install.py pip
	pip install ansible httplib2

Provision the buildserver
================================
Keep working from the cygwin prompt in the buildserver home directory:
	chmod -x ansible.ini
	chmod a+rw *.*
	
	mkdir .ssh
    cp C:/Users/kroonwijk/.vagrant.d/insecure_private_key .ssh
	chmod go-rwx .ssh/insecure_private_key


#    cp .ssh/insecure_private_key ~/.ssh

	export PATH=$PATH:`pwd`/windows
	
#	export ANSIBLE_CONFIG=`pwd`/ansible.cfg
	
    ansible-playbook -v -i ansible.ini -l local install.yml
	vagrant up ubuntu
	
if anything fails, repeat each next statement with:
    vagrant provision ubuntu

if connection could not be made during last statement, check that the selected VirtualBox host-only network card is using the ip address 192.168.10.1.
If not true, select the appropriate virtual network card with this host IP address and reboot de VM.
