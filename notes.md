https://app.vagrantup.com/mwrock/boxes/Windows2016

# from scratch
- create a windows 2016 box from mwrock image.
- apply all windos updates
- add `slmgr /rearm` to reset the the trial license. (service that lets you run a command on computer boot).
- disable UAC.
- disable firewalls. (windows firewall, conrad clement.)
- install ms c++ redist.
    - install chocolately https://chocolatey.org/install
    - `Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`
    - `choco install vcredist140` https://chocolatey.org/packages?q=redist
- package the box https://www.vagrantup.com/docs/cli/package.html
  - `vagrant package --output my_updated_win2016_server.box`
- upload the file to vagrantup. OR upload to a fileserv.
  - getting boxes from a temp drive. 
    - instead of `vagrant init --minimal bangma/win2016` you have to do `vagrant box add \\print\temp\path\to\boxfile.box bangma/win2016 --force`
  - uploading to vagrant cloud.
    - make an account.
    - log in to it with `vagrant cloud login`
    - publish your new boxfile with `vagrant cloud publish boxfile [-options]`
      - https://www.vagrantup.com/docs/cli/cloud.html#cloud-publish

# upgrading the existing bangma/win2016 box file.

- create a machine for updating. `vagrant init --minimal bangma/win2016`
- apply windows updates
- make other requested changes.



# psim installer scripting.
psim exe silent installs - https://tools.printeron.com/confluence/pages/viewpage.action?pageId=18317443
