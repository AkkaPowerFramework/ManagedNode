# Configure Alpine

The Hyper-V VM should be started by now and Alpine ready to be configured.

The default username for Alpine is ````root```` with out any password set.

## Setup Alpine to run off the VHD

Followed instructions [Alpine - Install to disk](https://wiki.alpinelinux.org/wiki/Install_to_disk)

````sh
setup-alpine
````

Choose everything you want to have. When it comes to choosing the disk to install it, choose ````sda```` as the disk and then ````sys```` for installing it onto the VHDX. Then it needs a reeboot and after that SSH and networking should be configured properly.

## Install Nano to use it instead of vi and Bash, Curl, Sudo for VSCode

````sh
apk update
apk add nano bash curl sudo e2fsprogs libintl icu
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

This image is based on Alpine. See <http://wiki.alpinelinux.org/>.

See <https://github.com/Stelzi79/AkkaPowerNode.Run> for mor Infos
````

## Connect via VSCode

Connect with the following ssh command in VSCode to the Node

````sh
# NOT AVAILABLE WITH ALPINE BECAUSE OF A GLIBC THING!!!!
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
nano /etc/apk/repositories
# uncomment the community source
apk update
apk add docker
nano /etc/docker/daemon.json
# add { "graph": "/mnt/docker"} in this file
rc-update add docker boot
service docker start
````

## Install a Build Agent

````sh
apk add git

exit # NO SUDO ALLOWED
mkdir /srv/data/buildagent && cd /srv/data/buildagent
wget -O /tmp/agent.tar.gz https://vstsagentpackage.azureedge.net/agent/2.160.1/vsts-agent-linux-x64-2.160.1.tar.gz
tar zxvf /tmp/agent.tar.gz

sudo ./bin/installdependencies.sh
./config.sh

````
