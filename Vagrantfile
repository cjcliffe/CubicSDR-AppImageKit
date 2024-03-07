# -*- mode: ruby -*-
# vi: set ft=ruby :
# https://docs.vagrantup.com.

Vagrant.configure("2") do |config|
  config.vm.box = "centos/8"

  config.vm.synced_folder "vagrant", "/vagrant"

   config.vm.provider "virtualbox" do |vb|
     vb.memory = "4096"
     vb.customize ["modifyvm", :id, "--ioapic", "on"]
     vb.customize ["modifyvm", :id, "--cpus", "2"]   
   end

  config.vm.provision "shell", path: "vagrant/scripts/bootstrap_centos.sh"
end
