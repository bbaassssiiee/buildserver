#Install notes#


On **linux**:
(Tested on fedora 21/22).

You will need:
*vagrant and its dependencies
*ansible and its dependencies
*virtualbox (virtualbox extensions are not a requirement)
*open-ssh
*bash

If you are a fan of cows install package: cowsay.
Ansible logs will look like:
```
 ___________________________________________
< NOTIFIED: postgres | start postgresql-9.4 >
 -------------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

```
For **Cygwin**: See the cygwin directory for additional install notes.

1 Set default provider in ~/.bashrc.
Otherwise it will try to build for libvirt.


```Shell
export VAGRANT_DEFAULT_PROVIDER=virtualbox
```

Alternative:
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox' in vagrantfile.


2.1 Setup **ssh** configuration.
The whole setup assumes you create a local login vagrant on the build host.
Then setup .ssh (ssh-keygen -t rsa) and copy the keys delivered in the PKI directory
over the generated keys.
Setting up a new vagrant user can be an issue in none personal hosted environments.

An alternative is to create a standard VM once (use vagrant up <some server>) to
get an insecure private key file.
Then you could use vagrant ssh-config to generate a template for .ssh/config.

An example for my login:


Paste this into ~/.ssh/config (change home path!)

<pre>
  Host 192.168.10.16
  HostName build_master
  User vagrant
  Port 22
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/roland/.vagrant.d/insecure_private_key
  IdentitiesOnly yes
  LogLevel FATAL

  Host 192.168.10.18
  HostName target
  User vagrant
  Port 22
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/roland/.vagrant.d/insecure_private_key
  IdentitiesOnly yes
  LogLevel FATAL

  Host 192.168.10.20
  HostName test
  User vagrant
  Port 22
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/roland/.vagrant.d/insecure_private_key
  IdentitiesOnly yes
  LogLevel FATAL
</pre>



2.2 Add the servers to **/etc/hosts** on the build host:
```
192.168.10.16		dev
192.168.10.18		target
192.168.10.20		test
192.168.10.40		windows
```

3 Optionally: change MEMSIZE in the vagrantfile.

  You can increase memory in virtualbox later when needed, but if you have more RAM
  increasing may speed up the build process.
  Suggested value: 8192 on a 16G+ system.

4 Run make interactive or **make.sh** (logs to a file).
  ```Shell
  make
  ```

5 **Troubleshooting**:

Sometimes you will have to manually remove the directory for the virtualbox machine
directory after build failures.

When provisioning  fails try manual steps first like:
vagrant provision dev

Check /var/log/boot.log inside the virtual servers for startup errors.

Increase log level:

Vagrant: export VAGRANT_LOG=info
Ansible: see ansible.cfg file
