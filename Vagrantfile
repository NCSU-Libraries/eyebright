# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # This box works better than the centos project created one
  config.vm.box = "bento/centos-7.2"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.31"

  # on host: sudo ufw allow from 192.168.33.0/24
  # on guest: sudo yum remove firewalld
  config.vm.synced_folder '.', '/vagrant', type: 'nfs', mount_options: ['nolock', 'rw', 'vers=3', 'tcp', 'actimeo=2']

  # host: vagrant plugin install vagrant-sshfs
  # host: sudo apt-get install openssh-server
  # config.vm.synced_folder '.', '/vagrant', type: 'sshfs'

  config.vm.network "forwarded_port", guest: 80, host: 8089,
      auto_correct: true
  config.vm.network "forwarded_port", guest: 443, host: 8444,
      auto_correct: true
  config.vm.network "forwarded_port", guest: 3000, host: 8091,
      auto_correct: true
  config.vm.network "forwarded_port", guest: 8983, host: 8985,
      auto_correct: true

  config.ssh.forward_agent = true 

  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
    vb.memory = 1024
    vb.cpus = 1
  end

  # install git before running ansible provisioner
  config.vm.provision "shell", inline: "yum -y install git"

  config.vm.provision "ansible" do |ansible|
    ansible.galaxy_role_file = 'ansible/requirements.yml'
    ansible.playbook = 'ansible/development-playbook.yml'
    ansible.inventory_path = 'ansible/development.ini'
    ansible.limit = 'all'
    # ansible.verbose = 'vvvv'
  end

  # https://github.com/kierate/vagrant-port-forwarding-info
  # vagrant plugin install vagrant-triggers
  # Get the port details in these cases:
  # - after "vagrant up" and "vagrant resume"
  config.trigger.after [:up, :resume] do
    run "#{File.dirname(__FILE__)}/get-ports.sh #{@machine.id}"
  end
  # - before "vagrant ssh"
  config.trigger.before :ssh do
    run "#{File.dirname(__FILE__)}/get-ports.sh #{@machine.id}"
  end

  # set auto_update to false, if you do NOT want to check the correct
  # additions version when booting this machine
  config.vbguest.auto_update = true

  # do NOT download the iso file from a webserver
  config.vbguest.no_remote = false

end
