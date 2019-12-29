VAGRANT_DEFAULT_PROVIDER=virtualbox
export ANSIBLE_SSH_ARGS='-o ControlMaster=no'
export PYCURL_SSL_LIBRARY=openssl
export LDFLAGS=-L/usr/local/opt/openssl/lib
export CPPFLAGS=-I/usr/local/opt/openssl/include

default: help


.PHONY: help
help:
	@echo "Beginner tasks:"
	@echo "make galaxy_roles  -install requirements"
	@echo "make trust         -generate keys"
	@echo "make myself        -install locally on centos7"
	@echo "make vagrant       -Install 2 vagrant virtual machines"
	@echo "make install       -Build the build_master from a Mac, and install docker on centos7"
#	@echo "make deploy        -Deploy the application game of life to target"
	@echo "make cleanroles    -Cleanup vm's and  ansible roles"

.venv:
	@echo Install a python3 venv.
	python3 -m venv .venv
	( . .venv/bin/activate && pip3 install --upgrade --ignore-installed -r requirements.txt )

.PHONY: galaxy_roles
galaxy_roles: .venv
	@echo Install Ansible galaxy roles.
	( . .venv/bin/activate && ansible-galaxy install -p ./galaxy_roles --force --role-file requirements.yml )

files/ca-certificates/internal_ca.cer: .venv
	@( . .venv/bin/activate && ./trust_me.yml )

.PHONY: trust
trust: files/ca-certificates/internal_ca.cer

install: .venv galaxy_roles files/ca-certificates/internal_ca.cer .vagrant
	vagrant up --no-provision centos7
	( . .venv/bin/activate && ansible-playbook -l centos7 playbook.yml -vv ) || /usr/bin/true
	vagrant up --no-provision build_master
	vagrant provision build_master

.PHONY: provision
provision:
	vagrant provision build_master

.PHONY: myself
myself: .venv
	( . .venv/bin/activate && ansible-playbook -b -K -i inventories/local -l build provision.yml -vv )

.PHONY: addboxes
addboxes:
	vagrant box add -f -name win_slave boxes/windows.box

.PHONY: vagrant
vagrant:
	@echo Bring up vagrant VM:** 'build_master' the CI server
	vagrant up --no-provision build_master centos7
	vagrant provision build_master

.vagrant:
	@echo Bring up vagrant VM:** 'build_master' the CI server
	vagrant up --no-provision build_master
	vagrant provision build_master

.PHONY: build
build:
	@echo Triggers build jobs Jenkins on [build_master].
	( . .venv/bin/activate && ansible-playbook -vv -l build_master build.yml )

.PHONY: cleanroles
cleanroles:
	rm -rf galaxy_roles

.PHONY: destroy
destroy:
	@echo halt virtual machine
	vagrant halt build_master
	vagrant halt win_slave
	@echo Destroys virtual machines
	vagrant destroy -f build_master
	vagrant destroy -f win_slave

.PHONY: clean
clean: cleanroles destroy

.PHONY: deploy
deploy:
	( . .venv/bin/activate && ansible-playbook -vv -l target deploy.yml )

.PHONY: smoketest
smoketest:
	( . .venv/bin/activate && ansible-playbook -vv -l build_master:target smoketest.yml )
.PHONY: webtest
webtest:
	( . .venv/bin/activate && ansible-playbook -vv -l target webtest.yml )
.PHONY: test
test: smoketest webtest

.PHONY: all
all: clean setup install deploy

build.box:
	vagrant halt build_master
	vagrant package --base build_master --output boxes/build.box

boxes/target.box:
	vagrant halt target
	vagrant package --base target --output boxes/target.box
boxes/test.box:
	vagrant halt test_slave
	vagrant package --base test_slave --output boxes/test.box
boxes/windows.box:
	vagrant halt win_slave
	vagrant package --base win_slave --output boxes/windows.box

.PHONY: boxes
boxes: boxes/build.box boxes/target.box boxes/test.box boxes/windows.box
