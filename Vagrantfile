# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  # The ordering of these 2 lines expresses a preference for a hypervisor
  config.vm.provider "virtualbox"
  config.vm.provider "vmware_fusion"
  
  # Use the Ansible playbook provision.yml to setup the virtual machines.
  config.vm.provision "ansible" do |ansible|
    ansible.inventory_path = "ansible.ini"
    ansible.playbook = "provision.yml"
    ansible.verbose = "vvvv"
    ansible.host_key_checking = "false"
	ansible.raw_ssh_args = "-o ControlMaster=no"
  end

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box = "chef/centos-6.6"
  config.vm.box_url = "https://atlas.hashicorp.com/chef/boxes/centos-6.6"
  config.vm.box_check_update = false

  # disable guest additions
  config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: true
  config.ssh.insert_key = false

  config.vm.define :dev,  primary: true do |dev_config|
    # This host only network for use of Apache as a reverse proxy.
    dev_config.vm.network "private_network", ip: "192.168.10.16", :netmask => "255.255.255.0",  auto_config: true
    # To access this host use: 'vagrant ssh dev'
    dev_config.vm.network "forwarded_port", id: 'ssh', guest: 22, host: 2222, auto_correct: true
    # HTTPS for reverse proxy
    #dev_config.vm.network "forwarded_port", guest: 443, host: 8443, auto_correct: true
    
    dev_config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", 4096, "--natnet1", "172.16.1/24"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"  ]
      vb.name = "dev"
      vb.gui = false
    end
    
    dev_config.vm.provider "vmware_fusion" do |vmware|
      vmware.gui = false
      vmware.vmx["memsize"] = "4096"
      vmware.vmx["numvcpus"] = "2"
    end
  end

  config.vm.define :test, autostart: false do |test_config|
    test_config.vm.network "private_network", ip: "192.168.10.18", :netmask => "255.255.255.0",  auto_config: true
    test_config.vm.network "forwarded_port", id: 'ssh', guest: 22, host: 2223, auto_correct: true
    test_config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true

    test_config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", 1024, "--natnet1", "172.16.1/24"]
      vb.gui = false
      vb.name = "test"
    end

    test_config.vm.provider "vmware_fusion" do |vmware|
      vmware.gui = false
      vmware.vmx["memsize"] = 1024
      vmware.vmx["numvcpus"] = 2
    end
  end
  
  config.vm.define :ubuntu, autostart: false do |ubuntu_config|
    ubuntu_config.vm.box = "chef/ubuntu-14.04"  # to delete: 'vagrant destroy; box remove chef/ubuntu-14.04'
    ubuntu_config.vm.box_url = "https://atlas.hashicorp.com/chef/boxes/ubuntu-14.04"
    ubuntu_config.vm.network "private_network", ip: "192.168.10.20", :netmask => "255.255.255.0",  auto_config: true
    ubuntu_config.vm.network "forwarded_port", id: 'ssh', guest: 22, host: 2224, auto_correct: true
    ubuntu_config.vm.network :forwarded_port, guest:4444, host:4444
    ubuntu_config.vm.provider "vmware_fusion" do |vmware|
      vmware.vmx["memsize"] = "4096"
      vmware.vmx["numvcpus"] = "2"
    end
    ubuntu_config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", 4096, "--natnet1", "172.16.1/24"]
      vb.gui = true
      vb.name = "client"
    end
    ubuntu_config.vm.provider "vmware_fusion" do |vmware|
      vmware.gui = false
      vmware.vmx["memsize"] = 4096
      vmware.vmx["numvcpus"] = 2
    end
  end
end
