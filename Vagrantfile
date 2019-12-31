# -*- mode: ruby -*-
# vi: set ft=ruby :

# Check to determine whether we're on a windows or linux/os-x host,
# later on we use this to launch ansible in the supported way
# source: https://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
def which(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each { |ext|
            exe = File.join(path, "#{cmd}#{ext}")
            return exe if File.executable? exe
        }
    end
    return nil
end


VAGRANTFILE_API_VERSION = "2"
$MEMSIZE=1024

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # The ordering of these 2 lines expresses a preference for a hypervisor
  config.vm.provider "virtualbox"
  config.vm.provider "vmware_fusion"

  config.ssh.forward_agent = false
  config.ssh.insert_key = false
  # Timeouts
  config.vm.boot_timeout = 900
  config.vm.graceful_halt_timeout=30

  # build_master
  config.vm.define :build_master, primary: true, autostart: true do |build_master|
    build_master.vm.box = "redesign/centos7"
    build_master.vm.box_check_update = false
    build_master.vm.synced_folder ".", "/vagrant", id: "vagrant-root"
    build_master.vm.network "private_network", ip: "192.168.10.28", :netmask => "255.255.255.0",  auto_config: true
    build_master.vm.network "forwarded_port", id: 'ssh', guest: 22, host: 2228, auto_correct: false
#    build_master.vm.network "forwarded_port", guest: 443, host: 8443, auto_correct: true
    build_master.vm.provision "shell", inline: "ifup enp0s8", run: "always"
    build_master.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "8192", "--natnet1", "172.16.1/24"]
      vb.gui = false
      vb.name = "build_master"
    end
    build_master.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "/vagrant/provision.yml"
      ansible.compatibility_mode = "2.0"
      ansible.galaxy_role_file = "requirements.yml"
      ansible.galaxy_roles_path = "galaxy_roles"
      ansible.limit = "build_master"
      ansible.verbose = 'vv'
    end
  end

  config.vm.define :centos6, autostart: false do |centos6|
    centos6.vm.box = "dockpack/centos6"
    centos6.vm.box_check_update = false
    centos6.vbguest.auto_update = false
    centos6.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: true
    centos6.vm.network "private_network", ip: "192.168.10.16", :netmask => "255.255.255.0",  auto_config: true
    centos6.vm.network "forwarded_port", id: 'ssh', guest: 22, host: 2216, auto_correct: false
    centos6.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512", "--natnet1", "172.16.1/24"]
      vb.gui = false
      vb.name = "centos6"
    end
  end

  config.vm.define :centos7, autostart: false do |centos7|
    centos7.vm.box = "redesign/centos7"
    centos7.vm.box_check_update = false
    centos7.vbguest.auto_update = false
    centos7.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: true
    centos7.vm.network "private_network", ip: "192.168.10.17", :netmask => "255.255.255.0",  auto_config: true
    centos7.vm.network "forwarded_port", id: 'ssh', guest: 22, host: 2217, auto_correct: false
    centos7.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048", "--natnet1", "172.16.1/24"]
      vb.gui = false
      vb.name = "centos7"
    end
  end

  config.vm.define :trusty, autostart: false do |trusty|
    trusty.vm.box = "trusty"
    trusty.vbguest.auto_update = true
    trusty.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: false
    trusty.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
    trusty.vm.network "private_network", ip: "192.168.10.19", :netmask => "255.255.255.0",  auto_config: true
    trusty.vm.network "forwarded_port", id: 'ssh', guest: 22, host: 2219, auto_correct: true
    trusty.vm.network :forwarded_port, guest:8000, host:8000
    trusty.vm.provider "vmware_fusion" do |vmware|
      vmware.vmx["memsize"] = "2048"
      vmware.vmx["numvcpus"] = "2"
    end
    trusty.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048", "--natnet1", "172.16.1/24"]
      vb.gui = false
      vb.name = "trusty"
    end
  end

  config.vm.define :xenial, autostart: false do |xenial|
    xenial.vm.box = "xenial"
    xenial.vbguest.auto_update = true
    xenial.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: false
    xenial.vm.box_url = "https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-vagrant.box"
    xenial.vm.network "private_network", ip: "192.168.10.20", :netmask => "255.255.255.0",  auto_config: true
    xenial.vm.network "forwarded_port", id: 'ssh', guest: 22, host: 2220, auto_correct: true
    xenial.vm.network :forwarded_port, guest:8000, host:8000
    xenial.vm.provider "vmware_fusion" do |vmware|
      vmware.vmx["memsize"] = "2048"
      vmware.vmx["numvcpus"] = "2"
    end
    xenial.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048", "--natnet1", "172.16.1/24"]
      vb.gui = false
      vb.name = "xenial"
    end
  end

  config.vm.define :win_slave, autostart: false do |win_slave|
    win_slave.vm.box = "jborean93/WindowsServer2016"
    win_slave.vm.guest = :windows
    win_slave.vm.communicator = "winrm"
    win_slave.winrm.username = 'vagrant'
    win_slave.winrm.password = 'vagrant'
    win_slave.vm.box_check_update = true
    win_slave.vm.network :private_network, ip: "192.168.10.26"
    win_slave.vm.network :forwarded_port, guest:8000, host:8000
    win_slave.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
    win_slave.vm.provider "virtualbox" do |vb|
     vb.default_nic_type = "virtio"
     vb.gui = false
     vb.name = "win_slave"
     vb.customize [
          "modifyvm", :id,
          "--memory", "4096",
          "--natnet1", "172.16.1/24",
          "--natdnshostresolver1", "on",
          "--cableconnected1", "on",
     ]
    end
    win_slave.vm.provision "ansible" do |ansible|
      ansible.playbook = "windows.yml"
      ansible.compatibility_mode = "2.0"
      ansible.galaxy_role_file = "requirements.yml"
      ansible.galaxy_roles_path = "galaxy_roles"
      ansible.limit = "win_slave"
      ansible.verbose = 'vv'
    end
  end
end
