# Your MACHINE_NAME will be the directory of your machine with unsafe characters replaced. eg:: C__USERS_PROJECTS_VM-PSIM
# From: https://support.microsoft.com/en-gb/help/909264/naming-conventions-in-active-directory-for-computers-domains-sites-and
# NetBIOS computer names cannot contain the following characters: \ / : * ? " < > |

MACHINE_NAME = "#{`hostname`[0..-2]}-" + File.basename(Dir.getwd).gsub(/[^\w\s]/i,'').upcase

# Add more machine ports here.
PORTS_TO_FORWARD = {
  "80" => "8080",     # http tomcat  
  "443" => "8443",    # https tomcat
  "1433" => "1433",   # mssql studio
  "3389" => "33389",  # remote desktop forwarding
  "8057" => "8057"    # ponconf
  
}

puts "Interacting with Machine: #{MACHINE_NAME} in: #{Dir.pwd}"
puts "#{ENV['FULL_INSTALL']}"
Vagrant.configure("2") do |c|
  # always make sure you get the latest box when recreating your machine.
  c.vm.box_check_update = true
  c.vm.box = "bangma/win2016"
  c.vm.communicator = "winrm"
  
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

  # forward the ports listed above out from the vagrant machine.
  PORTS_TO_FORWARD.each do |guest,host|
    c.vm.network "forwarded_port", guest: "#{guest}", host: "#{host}", auto_correct: true
  end

  # forward two collections of debug ports. 
  (5000..5009).each do |p|
    c.vm.network "forwarded_port", guest: "#{p}", host: "5#{p}", auto_correct: true, id: "debug-port-#{p}"
  end
  (5990..5999).each do |p|
    c.vm.network "forwarded_port", guest: "#{p}", host: "5#{p}", auto_correct: true, id: "debug-port-#{p}"
  end

  # install PSIM if the psim.exe and license.txt are present in the ./installer folder.
  c.vm.provision "shell", name: "PSIM Installer", privileged: true, reboot: true, keep_color: true, path: "scripts/PsimInstaller.ps1"
  c.vm.provision "shell", name: "First Run Setup", privileged: true, reboot: true, keep_color: true, path: "scripts/FirstRunRemoteSetup.ps1"
end