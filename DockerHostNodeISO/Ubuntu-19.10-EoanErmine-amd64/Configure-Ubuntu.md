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

````sh
sudo apt update
sudo apt upgrade
sudo apt install linux-azure
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

````sh
fdisk /dev/sdb
mkfs.ext4 /dev/sdb1
mkdir /srv/data
mount /dev/sdb1 /srv/data
df -H

nano /etc/fstab
# append /dev/sdb1               /disk1           ext3    defaults        1 2

````

## Install Docker

````sh

````

## Install a Build Agent

````sh

# NO SUDO ALLOWED
mkdir /srv/data/buildagent && cd /srv/data/buildagent
wget -O /tmp/agent.tar.gz https://vstsagentpackage.azureedge.net/agent/2.160.1/vsts-agent-linux-x64-2.160.1.tar.gz
tar zxvf /tmp/agent.tar.gz

sudo ./bin/installdependencies.sh
./config.sh

````
