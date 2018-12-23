# -*- mode: ruby -*-
# vi: set ft=ruby :

# Here we go, ah yeah

Vagrant.configure("2") do |config|
  # Use bento as Canonical's official Xenial vagrant weirdly doesn't comply with vagrant standards
  config.vm.box = "bento/ubuntu-16.04"

  # SSH password
  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"

  # Name
  config.vm.define "devbox" do |devbox|
  end

  # Hostname
  config.vm.hostname = "devbox"

  # Memory
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
  end

  # Private network
  config.vm.network "private_network", ip: "192.168.33.10"

  # Forward mysql
  config.vm.network "forwarded_port", guest: 3306, host: 3306

  # Share folder setup
  # Standard option
  config.vm.synced_folder ".", "/var/www", :mount_options => ["dmode=777", "fmode=666"]
  # Or You might need to use the following, faster option for some frameworks where speed is an issue, e.g. Magento, just comment/uncomment as necessary
  # config.vm.synced_folder ".", "/var/www", nfs: true

  # Provision all the things
  config.vm.provision :shell, path: "setup.sh"
end
