Vagrant.configure("2") do |config|
  config.vm.box = "win2016"

  config.vm.communicator = "winrm"
  config.vm.provision "shell", path: "./Provision.ps1"
  # machine settings (virtualbox specific).
  config.vm.provider "virtualbox" do |vb|
    vb.name = "PSIM-Ready Windows2016 Server (vm-psim)"
    vb.memory = 8192 # 8GB RAM
    vb.cpus = 4 # 4 cores
  end
end

  
