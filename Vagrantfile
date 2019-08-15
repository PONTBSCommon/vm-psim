#### Your MACHINE_NAME will be the hostname of your host machine and the name of your current folder with unsafe characters removed. eg: USER1-VMPSIM
#### From: https://support.microsoft.com/en-gb/help/909264/naming-conventions-in-active-directory-for-computers-domains-sites-and
#### NetBIOS computer names cannot contain the following characters: \ / : * ? " < > |
HOSTNAME = "#{`hostname`[0..-2]}-" + File.basename(Dir.getwd).gsub(/[^\w\s]/i,'').upcase
MACHINE_IP = ("#{`ping -4 -n 1 #{HOSTNAME}`}".match(/\d*\.\d*\.\d*\.\d*/) || ['NO_ADDRESS_FOUND'])[0]
MACHINE_IP = 'NO_ADDRESS_FOUND' if MACHINE_IP.include? "Request timed out."
MACHINE_IP = 'NO_ADDRESS_FOUND' if MACHINE_IP.include? "Ping request could not find host"

Vagrant.configure("2") do |c|
  #### always make sure you get the latest box when recreating your machine. ####
  c.vm.box_check_update = true
  c.vm.box = "bangma/win2016"
  c.vm.communicator = "winrm"
  c.vm.network "public_network"

  c.vm.post_up_message = <<-POST_MSG
  VM-PSIM is running! Here's some options:

    Connect via RDP         => vagrant rdp
    Connect via Powershell  => vagrant powershell
    DNS Domain Name         => https://#{HOSTNAME.downcase}.printeron.local/
    IPv4 Address            => #{MACHINE_IP}

  POST_MSG

  #### This section deals with naming the machine. ####
  c.vm.define "#{HOSTNAME.downcase}" # vagrant machine name
  c.vm.hostname = HOSTNAME # windows hostname
  c.vm.provider "virtualbox" do |v|
    v.name = "#{HOSTNAME}" # virtualbox name
  end

  #### Flush DNS entries for the machines before up. ####
  c.trigger.before :up, :reload do |t| 
    t.ruby do || `ipconfig /flushdns` end
  end

  #### install PSIM if the psim.exe and license.txt are present in the ./installer folder. ####
  c.vm.provision "shell", name: "PSIM Installer", privileged: true, reboot: true, keep_color: true, path: "scripts/PsimInstaller.ps1"
  c.vm.provision "shell", name: "First Run Setup", privileged: true, reboot: false, keep_color: true, path: "scripts/FirstRunRemoteSetup.ps1"
end