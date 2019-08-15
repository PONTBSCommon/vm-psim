# **vm-psim**   |  PSIM Testing Vagrant Virtual Machine
A PSIM ready Windows Virtualbox for local PSIM development.

The goal is to never have to open the virtualbox gui, or interact with virtualbox outside of the command line.

## Breaking Change Support ##
Old machine may not connect anymore. You should delete and recreate your machines. If you cannot currently, here is a workaround:
Change the line `v.name` in:
```
c.vm.provider "virtualbox" do |v|
    v.name = "#{HOSTNAME}" # virtualbox name
  end
```
from `"#{HOSTNAME}"` to whatever the name of your machine is in the virtualbox UI (usually `vm-psim-default-.....`).

> Currently the vagrant mv domain names are still not accessible outside of the local computer.
----

## Common Commands

| Use                             | Command               | Description                                                                                     |
|---------------------------------|-----------------------|-------------------------------------------------------------------------------------------------|
| **Start Up / Create**           | `vagrant up`          | Start your machine. (Or create one, if it doesn't exist)                                        |
| **Shut Down**                   | `vagrant halt`        | Shut down your machine.                                                                         |
| **Connect Via Remote Desktop**  | `vagrant rdp`         | Open a Remote Desktop Connection with your machine.                                             |
| **Connect Via Powershell**      | `vagrant powershell`  | Open a powershell connection to your machine.                                                   |
| **Delete VM**                   | `vagrant destroy -f`  | Delete your VM so a new one can be initialized.                                                 |
| **Update VM Image**             | `vagrant box update`  | Update the base box your machine is built from.                                                 |
| **Upgrade PSIM**                | `vagrant provision`   | Run the PsimInstaller script, to upgrade PSIM.                                                  |
| **Reload (Restart Machine)**    | `vagrant reload`      | This command restarts the vagrant machine, and picks up any changes to the vagrant file.        |
| **Show Machine Status (and IP)**| `vagrant status`      | This will tell you if your machine is running. and will also print out your ip, and domain.     |

----

## General Information
- The main administrator user is `vagrant`, the password is `vagrant`.
- The password for the `Administrator` account is also `vagrant`. However, you shouldn't need to use it, since `vagrant` is an admin.
- You can reach your vagrant machine at `{MACHINE_NAME}`, for you convenience the domain and IP are printed when the machine is created.

### Updating your base box
> ***Only do this step if you are notified on slack of a new base box version.***

To update your base box. Open a powershell window, and navigate to the vm-psim folder.
run the command:
``` Powershell
  vagrant box update
```
This will update your machine to the latest base box.
> **Note:** You will not be able to see changes until you `vagrant destroy` and `vagrant up` to create a machine from the new base box.

### Adding vagrant commands to your context menu
If you want vagrant commands in your right-click context menu.
- Open a powershell window and run the script under `./scripts/VagrantContextEntries.ps1`
> If you are not in an admin powershell window it will ask you to launch one.
----

## Getting Started (From Scratch)
 - Install Vagrant: [Download here.](https://www.vagrantup.com/downloads.html)
 - Install Virtualbox: [Download here.](https://www.virtualbox.org/wiki/Downloads)
 - Restart your computer.
 - Clone this repository to an easily accessible location.
 - Retrieve a PSIM installer (PSIM.exe). [Go to the PSIM master branch on bamboo.](https://tools.printeron.com/bamboo/browse/DEP-PSIMM41331)
 - Get a license file, send a message in the slack `#yfk-all-dev` room. Someone will have an extra `license.txt`, or speak to Nowshi for help.

 - Follow the instructions below, under the header: **PSIM Installation Info `=>` New Machine (First Time Run)**

----

## PSIM Installation Info
Open file explorer, and navigate to where you saved the vm-psim folder.
 - Place a PSIM installer in the `installer` sub-folder.
   - It ***must*** be named `psim.exe`
 - Place a valid license file in the `installer` sub-folder.
   - It ***must*** be named `license.txt`
 - If you wish to install **all** components, instead of just a standard install. Add: `full_install.txt` to the `installer` subfolder.
   - It ***must*** be named `full_install.txt` for a full install to be triggered.

Your file structure should resemble:
```
vm-psim/                <-- the vm-psim repository folder.
  installer/
    psim.exe            <-- Your psim executable.
    license.txt         <-- Your license file.
    full_install.txt    <-- (optional) if you want a full install, instead of a standard install.
  Vagrantfile           <-- The configuration for your VM.
  Readme.md             <-- This help document.
  deploy/
    ...
  scripts/              <-- Setup scripts for the machine (Don't touch)
    ...
```

### New Machine (First Time Run)
 - Ensure you have a `psim.exe` and a `license.txt` in the `./installer` folder.
 - Run `vagrant up` in a powershell window.
    - This step will take about 25 minutes to complete. Go get a coffee. ☕
 - Once your machine is running you can connect to it!
  - **Via Remote Desktop:** using the `vagrant rdp` command in the vm-psim folder.
  - **Via a Powershell Session:** using the `vagrant powershell` command.

### Existing Machine
 - _This will completely wipe the machine._
 - Run `vagrant destroy --force`
 - Then `vagrant up`

### Upgrading PSIM (Keep Existing Installation)
 - remove the old `./installer/psim.exe` file.
 - copy your new psim.exe version into the `./installer` folder with the name `psim.exe`.
 - run the `vagrant provision` command.
 - When you see **`Your PSIM Installation is complete.`** and vagrant has rebooted. Your machine is upgraded and ready for use!

### Upgrading PSIM (Clean Install Upgrade)
 - _This will completely wipe the machine._
 - Replace the `psim.exe` in `./installer` with the new version.
 - Run `vagrant destroy --force`
 - Then `vagrant up`
