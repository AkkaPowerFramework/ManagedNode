# Configure Ubuntu

The Hyper-V VM should be started by now and Alpine ready to be configured.

The default username for Alpine is ````root```` with out any password set.

## Install Perquisite

````sh

````

## Add the user NodeAdmin

````sh
addgroup sudo
adduser NodeAdmin sudo
EDITOR=nano visudo
# uncomment %wheel and %sudo thing at end
````

## Setup SSH

````sh
nano /etc/ssh/sshd_config
# make changes
/etc/init.d/sshd restart
````

## Change Login Welcome Text

````sh
nano /etc/motd
````

Change it to

````sh
Welcome to AkkaPowerNode!

This image is based on Ubuntu. See <>.

See <https://github.com/Stelzi79/AkkaPowerNode.Run> for mor Infos
````

## Connect via VSCode

Connect with the following ssh command in VSCode to the Node

````sh

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
