Vagrant.configure("2") do |c|
  # always make sure you get the latest box when recreating your machine.
  c.vm.box_check_update = true
  c.vm.box = "bangma/win2016"
  c.vm.communicator = "winrm"
  c.vm.post_up_message = "MACHINE LOADED! RDP with =>     vagrant rdp"

  # If any of these ports dont seem to work, use the command `vagrant port` to
  # list the ports being forwarded on the vagrant machine.
  c.vm.network "forwarded_port", guest: 3389, host: 33389, auto_correct: true, id: "rdp"

  # access the vm's ponconf from https://localhost:8057
  c.vm.network "forwarded_port", guest: 8057, host: 8057, auto_correct: true, id: "ponconf-web"

  # access the cps / imcas endpoints on the vm from localhost:9080 or localhost:9443 on your host machine.
  c.vm.network "forwarded_port", guest: 80, host: 9080, auto_correct: true, id: "cps-http"
  c.vm.network "forwarded_port", guest: 443, host: 9443, auto_correct: true, id: "cps-https"

  # set a debug port in the vm to any of 5005-5007 and set your local intellij to the corresponding 55005-55007 port.
  c.vm.network "forwarded_port", guest: 5005, host: 55005, auto_correct: true, id: "debug-port-5005"
  c.vm.network "forwarded_port", guest: 5006, host: 55006, auto_correct: true, id: "debug-port-5006"
  c.vm.network "forwarded_port", guest: 5007, host: 55007, auto_correct: true, id: "debug-port-5007"

  # Install PSIM if the psim.exe and license.txt are present in the ./installer folder. Runs on `vagrant up` (first time) 
  # or `vagrant provision` (anytime)
  #
  # Performs a standard install by default. If you need a custom install, remove the psim.exe from the ./installer folder
  # until after the machine creation has completed. You may then vagrant rdp into the machine and run the PSIM installer
  # manually.
  c.vm.provision "shell", name: "PSIM Installer", privileged: true, reboot: true, keep_color: true, path: "scripts/PsimInstaller.ps1"
end