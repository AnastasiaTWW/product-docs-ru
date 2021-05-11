[wallarm-status-instr]:             ../admin-ru/configure-statistics-service.md
[sqli-attack-desc]:                 ../attacks-vulns-list.md#sqlинъекция-sql-injection
[xss-attack-desc]:                  ../attacks-vulns-list.md#межсайтовый-скриптинг-англ-cross-site-scripting-xss
[img-test-attacks-in-ui]:           ../images/admin-guides/yandex-cloud/test-attacks.png
[waf-mode-instr]:                   ../admin-ru/configure-wallarm-mode.md
[logging-instr]:                    ../admin-ru/configure-logging.md
[proxy-balancer-instr]:             ../admin-ru/using-proxy-or-balancer-ru.md
[scanner-whitelisting-instr]:       ../admin-ru/scanner-ips-whitelisting.md
[process-time-limit-instr]:         ../admin-ru/configure-parameters-ru.md#wallarm_process_time_limit
[configure-selinux-instr]:          ../admin-ru/configure-selinux.md
[configure-proxy-balancer-instr]:   ../admin-ru/configuration-guides/access-to-wallarm-api-via-proxy.md
[install-postanalytics-instr]:      ../admin-ru/installation-postanalytics-ru.md
[dynamic-dns-resolution-nginx]:     ../admin-ru/configure-dynamic-dns-resolution-nginx.md
[enable-libdetection-docs]:         ../admin-ru/configure-parameters-ru.md#wallarm_enable_libdetection

# Обновление Linux‑пакетов WAF

Инструкция описывает способ обновления Linux‑пакетов WAF, установленных по инструкциям ниже, до версии 2.18.

* [Модуль для NGINX `stable`](../waf-installation/nginx/dynamic-module.md)
* [Модуль для NGINX из репозиториев CentOS/Debian](../waf-installation/nginx/dynamic-module-from-distr.md)
* [Модуль для NGINX Plus](../waf-installation/nginx-plus.md)
* [Модуль для Kong](../admin-ru/installation-kong-ru.md)

## Порядок обновления

* Если модули WAF‑ноды и постаналитики установлены на одном сервере, выполните шаги ниже.
* Если модули WAF‑ноды и постаналитики установлены на разных серверах, обновите модуль постаналитики по [инструкции](separate-postanalytics.md) и выполните шаги ниже для модуля WAF‑ноды.

## Шаг 1: Подключите новый репозиторий Валарм WAF

Отключите предыдущий репозиторий Валарм WAF и подключите новый, используя команды для подходящей платформы.

**CentOS и Amazon Linux 2**

=== "CentOS 7 и Amazon Linux 2"
    ```bash
    sudo yum remove wallarm-node-repo
    sudo rpm -i https://repo.wallarm.com/centos/wallarm-node/7/2.18/x86_64/Packages/wallarm-node-repo-1-6.el7.noarch.rpm
    ```
=== "CentOS 8"
    ```bash
    sudo yum remove wallarm-node-repo
    sudo rpm -i https://repo.wallarm.com/centos/wallarm-node/8/2.18/x86_64/Packages/wallarm-node-repo-1-6.el8.noarch.rpm
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
        deb http://repo.wallarm.com/debian/wallarm-node stretch/2.18/
        ```
    === "Debian 9.x (stretch-backports)"
        ```bash
        deb http://repo.wallarm.com/debian/wallarm-node stretch/2.18/
        deb http://repo.wallarm.com/debian/wallarm-node stretch-backports/2.18/
        ```
    === "Debian 10.x (buster)"
        ```bash
        deb http://repo.wallarm.com/debian/wallarm-node buster/2.18/
        ```
    === "Ubuntu 16.04 LTS (xenial)"
        ```bash
        deb http://repo.wallarm.com/ubuntu/wallarm-node xenial/2.18/
        ```
    === "Ubuntu 18.04 LTS (bionic)"
        ```bash
        deb http://repo.wallarm.com/ubuntu/wallarm-node bionic/2.18/
        ```

## Шаг 2: Обновите пакеты Валарм WAF

### WAF‑нода и постаналитика на одном сервере

=== "Debian"
    ```bash
    sudo apt update
    sudo apt dist-upgrade
    ```
=== "Ubuntu"
    ```bash
    sudo apt update
    sudo apt dist-upgrade
    ```
=== "CentOS или Amazon Linux 2"
    ```bash
    sudo yum update
    ```

### WAF‑нода и постаналитика на разных серверах

!!! warning "Порядок обновления модулей"
    Если WAF‑нода и постаналитика установлены на разных серверах, необходимо обновить пакеты постаналитики перед обновлением пакетов WAF‑ноды.

1. Обновите пакеты постаналитики по [инструкции](separate-postanalytics.md).
2. Обновите пакеты WAF‑ноды:

    === "Debian"
        ```bash
        sudo apt update
        sudo apt dist-upgrade
        ```
    === "Ubuntu"
        ```bash
        sudo apt update
        sudo apt dist-upgrade
        ```
    === "CentOS или Amazon Linux 2"
        ```bash
        sudo yum update
        ```

## Шаг 3: Перезапустите NGINX

--8<-- "../include/waf/restart-nginx-2.16.md"

## Шаг 4: Протестируйте работу Валарм WAF

--8<-- "../include/waf/installation/test-waf-operation.md"

## Настройка

Модули Валарм WAF обновлены до версии 2.18. Настройки Валарм WAF из предыдущей версии применятся к новой версии автоматически. Чтобы применить дополнительные настройки, используйте [доступные директивы](../admin-ru/configure-parameters-ru.md).

--8<-- "../include/waf/installation/common-customization-options-nginx-216.md"