# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.network "private_network", ip: "192.168.12.32", id: "core", :nfs => true, :mount_options => ['nolock,vers=3,udp,noatime']
  config.vm.synced_folder ".", "/vagrant", type: "nfs"
  config.vm.provision "shell", path: "startup.sh"
end
