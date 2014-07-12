# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Box can be obtained by using
  # https://github.com/brettporter/packer-windows/tree/with-volume-key
  config.vm.box = "windows_2008_r2"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Set the appropriate downloads folder to share
  config.vm.synced_folder File.expand_path("~/Downloads"), '/Downloads'

  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"
    puppet.hiera_config_path = "hiera.yaml"
    # broken in 1.6.3
    #puppet.working_directory = "/vagrant"
    puppet.options = "--verbose"
  end
end
