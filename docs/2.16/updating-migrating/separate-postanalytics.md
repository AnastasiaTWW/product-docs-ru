[docs-module-update]:   nginx-modules.md

# Обновление отдельно установленного модуля постаналитики

Инструкция описывает способ обновления модуля постаналитики, установленного на отдельном сервере. Модуль постаналитики обновляется перед [обновлением Linux‑пакетов WAF][docs-module-update].

## Шаг 1: Подключите новый репозитории Валарм WAF

Отключите предыдущий репозиторий Валарм WAF и подключите новый, используя команды для подходящей платформы.

**CentOS 7 и Amazon Linux 2**

```bash
sudo yum remove wallarm-node-repo
sudo rpm -i https://repo.wallarm.com/centos/wallarm-node/7/2.16/x86_64/Packages/wallarm-node-repo-1-5.el7.noarch.rpm
```

**Debian и Ubuntu**

1. Откройте для редактирования файл `/etc/apt/sources.list.d/wallarm.list`:

    ```bash
    sudo vim /etc/apt/sources.list.d/wallarm.list
    ```
2. Закомментируйте или удалите предыдущий адрес репозитория.
3. Добавьте новый адрес репозитория:

    === "Debian 9.x (stretch)"
        ``` bash
        deb http://repo.wallarm.com/debian/wallarm-node stretch/2.16/
        ```
    === "Debian 9.x (stretch-backports)"
        ```bash
        deb http://repo.wallarm.com/debian/wallarm-node stretch/2.16/
        deb http://repo.wallarm.com/debian/wallarm-node stretch-backports/2.16/
        ```
    === "Debian 10.x (buster)"
        ```bash
        deb http://repo.wallarm.com/debian/wallarm-node buster/2.16/
        ```
    === "Ubuntu 16.04 LTS (xenial)"
        ```bash
        deb http://repo.wallarm.com/ubuntu/wallarm-node xenial/2.16/
        ```
    === "Ubuntu 18.04 LTS (bionic)"
        ```bash
        deb http://repo.wallarm.com/ubuntu/wallarm-node bionic/2.16/
        ```

## Шаг 2: Обновите пакеты Tarantool

=== "Debian"
    ```bash
    sudo apt update
    sudo apt dist-upgrade -o Dir::Etc::sourcelist=/etc/apt/sources.list.d/wallarm.list -o Dir::Etc::sourceparts=""
    ```
=== "Ubuntu"
    ```bash
    sudo apt update
    sudo apt dist-upgrade -o Dir::Etc::sourcelist=/etc/apt/sources.list.d/wallarm.list -o Dir::Etc::sourceparts=""
    ```
=== "CentOS или Amazon Linux 2"
    ```bash
    sudo yum update
    ```

## Шаг 3: Перезапустите модуль постаналитики

=== "Debian"
    ```bash
    sudo systemctl restart wallarm-tarantool
    ```
=== "Ubuntu"
    ```bash
    sudo service wallarm-tarantool restart
    ```
=== "CentOS 7.x или Amazon Linux 2"
    ```bash
    sudo systemctl restart wallarm-tarantool
    ```
