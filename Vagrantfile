Vagrant.configure("2") do |cfg|
  cfg.vm.box = "bangma/win2016"

  cfg.vm.communicator = "winrm"
  # config.vm.provision "shell", path: "./Provision.ps1"
  # machine settings (virtualbox specific).
  cfg.vm.provider "virtualbox" do |vb|
    vb.name = "PSIM-Ready Windows2016 Server (vm-psim)"
    vb.memory = 8192 # 8GB RAM
    vb.cpus = 4 # 4 cores
  end

  cfg.trigger.before :up do |tr| 
    tr.run = { path: "scripts/triggers/BeforeUp.ps1" }
  end
end