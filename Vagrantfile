Vagrant.configure("2") do |cfg|
  cfg.vm.box = "local/win2016"

  cfg.vm.communicator = "winrm"
  # config.vm.provision "shell", path: "./Provision.ps1"
  # machine settings (virtualbox specific).
  cfg.vm.provider "virtualbox" do |vb|
    vb.name = "PSIM-Ready Windows2016 Server (vm-psim)"
    vb.memory = 8192 # 8GB RAM
    vb.cpus = 4 # 4 cores
  end

  cfg.vm.network "forwarded_port", guest: 3389, host: 33389, auto_correct: true, id: "rdp"

  cfg.vm.provision "shell", privileged: true, reboot: true, path: "scripts/PsimInstaller.ps1"

  cfg.trigger.before :up do |tr| 
    tr.run = { path: "triggers/local/BeforeUp.ps1" }
  end
  cfg.trigger.after :provision do |tr| 
    tr.run = { path: "triggers/local/AfterUp.ps1" }
  end
  cfg.trigger.after :destroy do |tr| 
    tr.run = { path: "triggers/local/AfterDestroy.ps1" }
  end
end