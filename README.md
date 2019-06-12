# vm-psim
A PSIM ready Windows Virtualbox for local PSIM development.

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