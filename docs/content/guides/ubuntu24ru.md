---
title: Ubuntu 24.x install amneziawg-linux-kernel-module
---


Для работы обязательно требуется установить модуль ядра AmneziaWG на хост-систему.

https://habr.com/ru/companies/amnezia/articles/807539/

Инструкция по установке модуля: amneziawg-linux-kernel-module https://github.com/amnezia-vpn/amneziawg-linux-kernel-module

Откройте Terminal и следуйте инструкциям:

1. Обновите систему до последних версий пакетов, включая последнюю доступную версию ядра, выполнив команды:
sudo apt-get update
sudo apt-get upgrade
sudo apt-get full-upgrade

После обновления ядра требуется перезагрузка.

1.1 Установите Докер если еще не установлен:

Обновляем индексы пакетов apt
sudo apt update

Устанавливаем дополнительные пакеты
sudo apt install curl software-properties-common ca-certificates apt-transport-https -y

Импортируем GPG-ключ
wget -O- https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/docker.gpg > /dev/null

Добавляем репозиторий докера
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu noble stable"| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

В очередной раз обновляем индексы пакетов
sudo apt update

Устанавливаем докер
sudo apt install docker-ce docker-cli docker-compose -y

Убедимся в успешности установки, проверив статус в системе:
sudo systemctl status docker

2. Убедитесь, что у вас настроены исходные репозитории для APT. Запустите nano /etc/apt/sources.list.d/ubuntu.sources и убедитесь, что есть хотя бы одна строка, начинающаяся с deb-src и не содержащая комментариев. Если нет то после "deb" добавить "deb-src". Примерный вид:

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

После этого повторить п.1

3. Установите предварительные требования — запустите:
sudo apt install -y software-properties-common python3-launchpadlib gnupg2 linux-headers-$(uname -r)

4. По инструкции https://github.com/amnezia-vpn/amneziawg-linux-kernel-module/issues/91 нужно скачать, установить и скомпилировать правильные модули:
sudo dpkg --configure -a
sudo apt update -y && sudo apt upgrade -y

Добавить репозиторий:
sudo add-apt-repository ppa:amnezia/ppa

Установить модули Амнезии:
sudo apt-get install -y amneziawg

После ошибки удалить старый модуль и заменить рабочим:
sudo apt-get purge amneziawg-dkms amneziawg
sudo apt clean
sudo apt autoremove

sudo apt-get install dkms
sudo apt update -y && sudo apt upgrade -y


curl -L -O https://ppa.launchpadcontent.net/amnezia/ppa/ubuntu/pool/main/a/amneziawg-linux-kmod/amneziawg-dkms_1.0.0-0~202506030004+b91faba~ubuntu24.10.1_all.deb
dpkg -i amneziawg-dkms_1.0.0-0~202506030004+b91faba~ubuntu24.10.1_all.deb

После компиляции модуля переустановить пакет модуля Амнезии:

sudo apt-get install -y amneziawg

service restart dpkg
reboot
needrestart

dpkg -s

5. Развернуть Амнезию на сервере в Docker:

sudo mkdir -p /etc/docker/containers/awg-easy
sudo curl -o /etc/docker/containers/awg-easy/docker-compose.yml https://raw.githubusercontent.com/evoll/awg-easy/main/docker-compose.yml

cd /etc/docker/containers/awg-easy
sudo docker compose up -d

Обновление awg-easy
Чтобы обновить awg-easy до актуальной версии, запустите:

cd /etc/docker/containers/awg-easy
sudo docker compose pull
sudo docker compose up -d



Настройки можно посмотреть тут: https://evoll.github.io/awg-easy/latest/examples/tutorials/basic-installation/
