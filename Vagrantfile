# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Set the appropriate downloads folder to share
  config.vm.synced_folder File.expand_path("~/Downloads/windows"), '/Downloads'

  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"
    puppet.hiera_config_path = "hiera.yaml"
    # broken in 1.6.3
    #puppet.working_directory = "/vagrant"
    puppet.options = "--verbose"
  end

  config.vm.define "default" do |win2008|
    # Box can be obtained by using
    # https://github.com/brettporter/packer-windows/tree/with-volume-key
    win2008.vm.box = "windows_2008_r2"

    win2008.vm.network "private_network", ip: "192.168.33.10"
  end

  config.vm.define "win2012" do |win2012|
    # Box can be obtained by using
    # https://github.com/brettporter/packer-windows/tree/with-volume-key
    win2012.vm.box = "windows_2012_r2"

    win2012.vm.network "private_network", ip: "192.168.33.12"
  end
end
