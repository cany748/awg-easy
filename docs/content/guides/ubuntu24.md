---
title: Ubuntu 24.x Install AmneziaWG Linux Kernel Module
hide:
    - navigation
---

# Установка AmneziaWG Kernel Module на Ubuntu 24.x

To work, you must install the AmneziaWG kernel module on the host system.

## Links

- [Статья на Habr](https://habr.com/ru/companies/amnezia/articles/807539/)
- [Репозиторий amneziawg-linux-kernel-module](https://github.com/amnezia-vpn/amneziawg-linux-kernel-module)

## Инструкция по установке

Open the Terminal and follow the instructions:

### 1. Update the system to the latest package versions, including the latest available kernel version, by running the following commands:
sudo apt-get update
sudo apt-get upgrade
sudo apt-get full-upgrade

After updating the kernel, a reboot is required.

### 1.1 Install Docker if not already installed:

Updating the apt package indexes
sudo apt update

Installing additional packages
sudo apt install curl software-properties-common ca-certificates apt-transport-https -y

Importing the GPG key
wget -O- https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/docker.gpg > /dev/null

Adding the docker repository
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu noble stable"| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

We are updating the package indexes once again.
sudo apt update 

Installing Docker
sudo apt docker install docker-ce docker-cli docker-compose -y

Let's make sure the installation is successful by checking the status in the system:

sudo systemctl status docker

### 2. Make sure that you have configured the source repositories for APT. Run nano /etc/apt/sources.list.d/ubuntu.sources and make sure that there is at least one line starting with deb-src and containing no comments. If not, then add "deb-src" after "deb". Approximate view:

## See the sources.list(5) manual page for further settings.
Types: deb deb-src
URIs: http://de.archive.ubuntu.com/ubuntu
Suites: noble noble-updates noble-backports
Components: main universe restricted multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

## Ubuntu security updates. Aside from URIs and Suites,
## this should mirror your choices in the previous section.
Types: deb deb-src
URIs: http://security.ubuntu.com/ubuntu
Suites: noble-security
Components: main universe restricted multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

After that, repeat step 1.

### 3. Set the prerequisites — run:
sudo apt install -y software-properties-common python3-launchpadlib gnupg2 linux-headers-$(uname -r)

### 4. According to the instructions https://github.com/amnezia-vpn/amneziawg-linux-kernel-module/issues/91 you need to download, install and compile the correct modules:
sudo dpkg --configure -a
sudo apt update -y && sudo apt upgrade -y

Add repository:
sudo add-apt-repository ppa:amnesia/ppa

Install the Amnesia modules:
sudo apt-get install -y amneziawg

After the error, delete the old module and replace it with a working one:
sudo apt-get purge amneziawg-dkms amneziawg
sudo apt clean
sudo apt autoremove

sudo apt-get install dkms
sudo apt update -y && sudo apt upgrade -y


curl -L -O https://ppa.launchpadcontent.net/amnezia/ppa/ubuntu/pool/main/a/amneziawg-linux-kmod/amneziawg-dkms_1.0.0-0~202506030004+b91faba~ubuntu24.10.1_all.deb
dpkg -i amneziawg-dkms_1.0.0-0~202506030004+b91faba~ubuntu24.10.1_all.deb

After compiling the module, reinstall the Amnesia module package:

sudo apt-get install -y amneziawg

service restart dpkg
reboot
needrestart

dpkg -s

### 5. Deploy Amnesia on a Docker server:

sudo mkdir -p /etc/docker/containers/awg-easy
sudo curl -o /etc/docker/containers/awg-easy/docker-compose.yml https://raw.githubusercontent.com/evoll/awg-easy/main/docker-compose.yml

cd /etc/docker/containers/awg-easy
sudo docker compose up -d

Update awg-easy
To update awg-easy to the latest version, run:

cd /etc/docker/containers/awg-easy
sudo docker compose pull
sudo docker compose up -d



The settings can be viewed here: https://evoll.github.io/awg-easy/latest/examples/tutorials/basic-installation/