# **vm-psim**   |  PSIM Testing Vagrant Virtual Machine
A PSIM ready Windows Virtualbox for local PSIM development.

The goal is to never have to open the virtualbox gui, or interact with virtualbox outside of the command line.

## Prerequisites
1. If your host is Windows or macOS, download and install Vagrant from [here](https://www.vagrantup.com/downloads.html).
2. If your host computer is Windows, download [PowerShell 6](https://github.com/PowerShell/PowerShell/releases/tag/v6.2.3) and install it, then run it as Administrator.
3. If your host is Ubuntu server, create SSH keys to access the server by following [this documentation](https://github.azc.ext.hp.com/PONCommon/vm-psim/wiki/Install-and-config-PuTTY-on-Windows).
4. If your host is Ubuntu server, you need to have [WinSCP](https://github.azc.ext.hp.com/PONCommon/vm-psim/wiki/Config-WinSCP-with-SSH-access) installed in oder to upload your vagrant folder to the server.
5. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
6. Make sure your license file is not expired and you did not alter it anyhow. Otherwise, you may obtain PSIM license file from Nowshi Nahrin.
7. Make sure the "ServiceURL" in your license.txt file is "https://127.0.0.1/cps"

## Quick Start ## 
(Right click on the image, then click "Open Image in New Tab" for **better view**)
![Screenshot](https://github.azc.ext.hp.com/PONCommon/images-in-readme/blob/master/vg-psim/Vagrant%20Quick%20Start.png)

#### Ubuntu


- Download this project to your computer

- Duplicate the project folder and rename it like “yournamevm”(one word without spaces or any special characters)

- Go into the “yournamevm” folder and find **Vagrant-XXX** file based on your environment and rename it to **Vagrantfile**

- Copy **PSIM.exe** and **license.txt** files to installer folder

- Upload entire “yournamevm” folder to Ubuntu via WinSCP

- Use SSH client like “Putty” navigate into the “yournamevm” folder on Ubuntu 

- Run `vagrant up` command


#### Windows


- Download this project to your computer

- Duplicate the project folder and rename it like “yournamevm”(one word without spaces or any special characters)

- Go into the “yournamevm” folder and find **Vagrant-XXX** file based on your environment and rename it to **Vagrantfile**

- Copy **PSIM.exe** and **license.txt** files to installer folder

- Navigate into the “yournamevm” folder from PowerShell 6

- Run `vagrant up` command


#### macOS


- Download this project to your computer

- Duplicate the project folder and rename it like “yournamevm”(one word without spaces or any special characters)

- Go into the “yournamevm” folder and find **Vagrant-XXX** file based on your environment and rename it to **Vagrantfile**

- Copy **PSIM.exe** and **license.txt** files to installer folder

- Navigate into the “yournamevm” folder from Terminal

- Run `vagrant up` command
