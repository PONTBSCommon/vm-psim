# vm-psim
A PSIM ready Windows Virtualbox for local PSIM development.

## Getting Started (From Scratch)
 - Install Vagrant [Download the latest version here](https://www.vagrantup.com/downloads.html)
 - Install Virtualbox [Download it here](https://www.virtualbox.org/wiki/Downloads)
 - Restart your computer.
 - Clone this repository to an easily accessible location.
 - Follow the instructions below.

## PSIM Installation Info
 - Place a PSIM installer in the `./installer` folder.
   - It **must** be named `psim.exe`
 - Place a valid license file in the `./installer` folder.
   - It **must** be named `license.txt`

### New Machine (First Time Run)
 - Ensure you have a `psim.exe` and a `license.txt` in the `./installer` folder.
 - Run `vagrant up` in a powershell window.

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


## Common Commands
| Command | Description |
|---------|-------------|
| `vagrant halt`        | Stop your machine.  |
| `vagrant up`          | Start your machine. |
| `vagrant powershell`  | Open a powershell connection to your machine. |
| `vagrant rdp`         | Open a Remote Desktop Connection with your machine.  |
| `vagrant provision`   | Run the PsimInstaller script, to upgrade PSIM. |
