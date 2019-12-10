# Configure Ubuntu

The Hyper-V VM should be started by now and Ubuntu 18.04 LTS ready to be configured.

Follow the Live Installer and set the following values:

| key      | value             |
| -------- | ----------------- |
| Hostname | AkkaPowerNode-001 |
| User     | nodeadmin         |
| Packages | OpenSSH Server    |

````bash
ip addr show
````

you get the IP address of the node.

At this time the Node is sufficiently enough configured so you can ssh into with it and do Remoteing with VS Code.

````powershell
ssh nodeadmin@000.000.000.000 -A # replace the placeholder IP with the correct value
````

## Install Perquisite

````bash
sudo apt update
sudo apt upgrade
sudo apt install linux-azure -y
````

## Change Login Welcome Text

````bash
sudo chmod -x /etc/update-motd.d/
sudo apt install inxi screenfetch -y
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

reboot
````

## Install .net Core 3.1

````bash
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo apt-get install software-properties-common
sudo apt-get update
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install dotnet-sdk-3.1 dotnet-sdk-2.2.8 -y
````

## Install PowerShell Core

````bash
#dotnet tool install --global PowerShell --version  7.0.0-preview.6
wget https://aka.ms/install-powershell.sh; sudo bash install-powershell.sh -preview; rm install-powershell.sh

# make an alias for pwsh-preview !!

# Start PowerShell
pwsh
exit
````

## Install Docker

[Docker Docs](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

````bash
sudo apt-get update

sudo apt install docker.io -y

newgrp docker

sudo gpasswd -a $USER docker

mkdir /srv/data/docker

sudo nano /etc/docker/daemon.json
# add { "data-root": "/srv/data/docker"} in this file

sudo service docker restart

docker run hello-world
````

## Install a Build Agent

````bash

# NO SUDO ALLOWED
mkdir /srv/data/buildagent && cd /srv/data/buildagent
wget -O /tmp/agent.tar.gz https://vstsagentpackage.azureedge.net/agent/2.160.1/vsts-agent-linux-x64-2.160.1.tar.gz

tar zxvf /tmp/agent.tar.gz
rm /tmp/agent.tar.gz

sudo ./bin/installdependencies.sh
./config.sh
sudo ./svc.sh install nodeadmin
sudo ./svc.sh start

````

## Next

Now you can trigger any CI/ReleasePipelines build on this managed node to for example install the ManagedNode applications that manages to setup and configure any services you might want to run on this ManagedNode.
