# **vm-psim**   |  PSIM Testing Vagrant Virtual Machine
A PSIM ready Windows Virtualbox for local PSIM development.

The goal is to never have to open the virtualbox gui, or interact with virtualbox outside of the command line.

----

## Port Reference

> Ports may be autocorrected by vagrant if there is a conflict. If you are having issues, run `vagrant port` to list the ports your machine is running.

| Guest | Host | Purpose          |
|-------|------|------------------|
| 8057  | 8057 | Ponconf Web      |
| 80    | 9080 | cps http access  |
| 443   | 9443 | cps https access |
| 5005  | 55005| debug port       |
| 5006  | 55006| debug port       |
| 5007  | 55007| debug port       |

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
| **List Ports**                  | `vagrant port`        | List the ports that your VM is forwarding. (Useful when ports have changed due to collisions).  |

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

## General Information
- The main administrator user is `vagrant`, the password is `vagrant`.
- The password for the `Administrator` account is also `vagrant`. However, you shouldn't need to use it, since `vagrant` is an admin.

### Updating your base box
To update your base box. Open a powershell window, and navigate to the vm-psim folder.
run the command:
``` Powershell
  vagrant box update
```
This will update your machine to the latest base box.
> **Note:** You will not be able to see changes until you `vagrant destroy` and `vagrant up` to create a machine from the new base box.

----

## PSIM Installation Info
Open file explorer, and navigate to where you saved the vm-psim folder.
 - Place a PSIM installer in the `installer` sub-folder.
   - It ***must*** be named `psim.exe`
 - Place a valid license file in the `installer` sub-folder.
   - It ***must*** be named `license.txt`

Your file structure should resemble:
```
vm-psim/                <-- the vm-psim repository folder.
  installer/
    psim.exe            <-- Your psim executable.
    license.txt         <-- Your license file.
  Vagrantfile           <-- The configuration for your VM.
  Readme.md             <-- This help document.
  deploy/
    ...
  triggers/
    ...
  scripts/
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
