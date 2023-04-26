# -*- mode: ruby -*-
# vi: set ft=ruby :
# https://docs.vagrantup.com.

Vagrant.configure("2") do |config|
  config.vm.box = "centos/8"

  config.vm.synced_folder "vagrant", "/vagrant"

   config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
   end

  config.vm.provision "shell", path: "vagrant/scripts/bootstrap_centos.sh"
end
