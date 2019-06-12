_Leave this file here so that git maintains the folder structure._

# PSIM Installation Info
 - Place a PSIM installer in this folder.
   - It **must** be named `psim.exe`
 - Place a valid license file in this folder.
   - It **must** be named `license.txt`

## New Machine
 - Run `vagrant up`.

## Existing Machine
 - _This will completely wipe the machine._
 - Run `vagrant destroy --force`
 - Then `vagrant up`