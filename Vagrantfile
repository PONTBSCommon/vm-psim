Vagrant.configure("2") do |cfg|
  cfg.vm.box_check_update = true
  cfg.vm.box = "bangma/win2016"

  cfg.vm.network "forwarded_port", guest: 3389, host: 33389, auto_correct: true, id: "rdp"
  cfg.vm.network "forwarded_port", guest: 8057, host: 8057, auto_correct: true, id: "ponconf-web"

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