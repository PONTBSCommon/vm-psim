# Your MACHINE_NAME will be the hostname of your host machine and the name of your current folder with unsafe characters removed. eg: USER1-VMPSIM
# From: https://support.microsoft.com/en-gb/help/909264/naming-conventions-in-active-directory-for-computers-domains-sites-and
# NetBIOS computer names cannot contain the following characters: \ / : * ? " < > |
MACHINE_NAME = "#{`hostname`[0..-2]}-" + File.basename(Dir.getwd).gsub(/[^\w\s]/i,'').upcase
MACHINE_IP = ("#{`ping -n 1 #{MACHINE_NAME}`}".match(/\d*\.\d*\.\d*\.\d*/) || ['NO_ADDRESS_FOUND'])[0]

puts "Interacting with Machine: #{MACHINE_NAME} in: #{Dir.pwd}"
puts "[https://#{MACHINE_NAME.downcase}.printeron.local] has the IP: [#{MACHINE_IP}]\n"

Vagrant.configure("2") do |c|
  # always make sure you get the latest box when recreating your machine.
  c.vm.box_check_update = true
  c.vm.box = "bangma/win2016"
  c.vm.communicator = "winrm"
  c.vm.network "public_network"

  c.vm.post_up_message = <<-post_up_message
  VM-PSIM is running! Here's some options:
    start an RDP connection with        =>      vagrant rdp
    connect on the command line with    =>      vagrant powershell
  post_up_message

  #### This section deals with naming the machine. ####
  c.vm.define "#{MACHINE_NAME}"     # sets the name in the vagrant output.
  c.vm.hostname = MACHINE_NAME                # sets the windows hostname.
  c.vm.provider "virtualbox" do |v|           # sets the name in virtualbox.
    v.name = MACHINE_NAME
  end

  #### Output the machine IP after provisioning has completed.
  c.trigger.after :provision do |t| 
    t.ruby do || puts "[#{MACHINE_NAME}.printeron.local] has the IP: [#{MACHINE_IP}]\n" end
  end

  # install PSIM if the psim.exe and license.txt are present in the ./installer folder.
  c.vm.provision "shell", name: "PSIM Installer", privileged: true, reboot: true, keep_color: true, path: "scripts/PsimInstaller.ps1"
  c.vm.provision "shell", name: "First Run Setup", privileged: true, reboot: true, keep_color: true, path: "scripts/FirstRunRemoteSetup.ps1"
end