# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04"

   # Install PowerShell and PowerCLI
   config.vm.provision "shell", inline: <<-SHELL
     curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
     curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list
     sudo apt-get update
     sudo apt-get install powershell -y
     sudo pwsh -Command "& {Set-PSRepository -Name PSGallery -InstallationPolicy Trusted}"
     sudo pwsh -Command "& {Install-Module -Name VMware.PowerCLI -Force}"
   SHELL

   # Install InSpec
   config.vm.provision "shell", inline: <<-SHELL
     curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec
   SHELL

   # Download and vendor InSpec-VMware dependencies
   config.vm.provision "shell", inline: <<-SHELL
     git clone https://github.com/jjasghar/inspec-vmware-example
     sudo chown -R vagrant:vagrant inspec-vmware-example
     pushd inspec-vmware-example
       inspec vendor
     popd
   SHELL
end
