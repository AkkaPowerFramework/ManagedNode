# Configure Ubuntu

The Hyper-V VM should be started by now and Alpine ready to be configured.

Follow the Live Installer and set the following values:

| key      | value             |
| -------- | ----------------- |
| Hostname | AkkaPowerNode-001 |
| User     | nodeadmin         |
| Packages | OpenSSH Server    |

ith ````ip addr show```` you get the IP address of the node.

At this time the Node is sufficiently enough configured so you can ssh into with it and do Remoteing with VS Code.

````powershell
ssh nodeadmin@000.000.000.000 -A # replace the placeholder IP with the correct value
````

## Install Perquisite

````bash
sudo apt update
sudo apt upgrade
sudo apt install linux-azure
````

## Change Shell to Bash

````sh
sudo usermod -s /bin/bash nodeadmin
````

## Change Login Welcome Text

````bash
sudo chmod -x /etc/update-motd.d/
sudo apt install inxi screenfetch
sudo nano /etc/update-motd.d/01-akkapowernode
````

Change it to

````sh
#!/bin/sh
echo "GENERAL SYSTEM INFORMATION"
/usr/bin/screenfetch
echo
echo "SYSTEM DISK USAGE"
export TERM=xterm; inxi -D
echo
echo "Network"
export TERM=xterm; inxi -i
echo
echo "Welcome to AkkaPowerNode!"
echo
echo "See <https://github.com/Stelzi79/AkkaPowerNode.Run> for mor Infos"
echo
````

enable it with

````bash
sudo chmod +x /etc/update-motd.d/01-akkapowernode
````

## Mount the DataVHD

````bash
sudo -i
fdisk /dev/sdb
mkfs.ext4 /dev/sdb1
mkdir /srv/data
mount /dev/sdb1 /srv/data
df -H

nano /etc/fstab
# append /dev/sdb1               /srv/data          ext4    defaults        1 2

sudo chown -R nodeadmin /srv/data
exit
reboot
````

## Install .net Core 3.0

````bash
wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo apt-get update
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install dotnet-sdk-3.0 -y

````

## Install PowerShell Core

````bash
dotnet tool install --global PowerShell
# Start PowerShell
pwsh
````

## Install Docker

[Docker Docs](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

````bash
sudo apt-get update

sudo apt install docker.io -y

sudo gpasswd -a $USER docker

newgrp docker

mkdir /srv/data/docker

sudo nano /etc/docker/daemon.json
# add { "data-root": "/srv/data/docker"} in this file
# rc-update add docker boot
sudo service docker restart

docker run hello-world
````

## Install a Build Agent

````bash

# NO SUDO ALLOWED
mkdir /srv/data/buildagent && cd /srv/data/buildagent
wget -O /tmp/agent.tar.gz https://vstsagentpackage.azureedge.net/agent/2.160.1/vsts-agent-linux-x64-2.160.1.tar.gz
tar zxvf /tmp/agent.tar.gz

sudo ./bin/installdependencies.sh
./config.sh

````
