# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "lucid32"
  config.vm.box_url = "http://files.vagrantup.com/lucid32.box"
  config.vm.host_name = "python-web-dev"

  config.ssh.forward_agent = true

  # Shared folders
  hosthome = "#{ENV['HOME']}/"
  config.vm.share_folder("v-boxhome", "/boxhome", ".", :nfs => true)
  config.vm.share_folder("v-hosthome", "/home/vagrant/.hosthome", hosthome)

  # Host-only network required to use NFS shared folders
  config.vm.network :hostonly, "1.2.3.4"

  # Forward ports from the guest to the host:  note that this (may) allow
  # other computers to access the VM
  config.vm.forward_port 80, 8080
  config.vm.forward_port 8000, 8001

  # Provisioning
  config.vm.provision :shell, :inline => "/boxhome/provisioning/shell/install-chef.sh 10.16.2"
  config.vm.provision :shell, :inline => "su vagrant -c /boxhome/provisioning/shell/init-system.sh"

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.cookbooks_path = "provisioning/cookbooks"
    chef.roles_path = "provisioning/roles"
    chef.add_role "vagrant"
  end
end
