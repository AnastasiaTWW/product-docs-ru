[img-wl-console-users]:             ../../images/check-users.png 
[wallarm-status-instr]:             ../../admin-ru/configure-statistics-service.md
[memory-instr]:                     ../../admin-ru/configuration-guides/allocate-resources-for-waf-node.md
[waf-directives-instr]:             ../../admin-ru/configure-parameters-ru.md
[sqli-attack-desc]:                 ../../attacks-vulns-list.md#sqlинъекция-sql-injection
[xss-attack-desc]:                  ../../attacks-vulns-list.md#межсайтовый-скриптинг-англ-cross-site-scripting-xss
[img-test-attacks-in-ui]:           ../../images/admin-guides/yandex-cloud/test-attacks.png
[waf-mode-instr]:                   ../../admin-ru/configure-wallarm-mode.md
[logging-instr]:                    ../../admin-ru/configure-logging.md
[proxy-balancer-instr]:             ../../admin-ru/using-proxy-or-balancer-ru.md
[scanner-whitelisting-instr]:       ../../admin-ru/scanner-ips-whitelisting.md
[process-time-limit-instr]:         ../../admin-ru/configure-parameters-ru.md#wallarm_process_time_limit
[configure-selinux-instr]:          ../../admin-ru/configure-selinux.md
[configure-proxy-balancer-instr]:   ../../admin-ru/configuration-guides/access-to-wallarm-api-via-proxy.md
[install-postanalytics-instr]:      ../../admin-ru/installation-postanalytics-ru.md
[2.14-install-postanalytics-instr]: ../../admin-ru/installation-postanalytics-ru.md
[2.18-install-postanalytics-instr]: ../../../../admin-ru/installation-postanalytics-ru/
[update-instr]:                     ../../updating-migrating/nginx-modules.md
[2.18-installation-instr]:          ../../../../waf-installation/nginx/dynamic-module/
[nginx-modules-update-docs]:        ../../../../updating-migrating/nginx-modules/
[separate-postanalytics-update-docs]:   ../../../../updating-migrating/separate-postanalytics/
[install-postanalytics-docs]:        ../../../../2.16/admin-ru/installation-postanalytics-ru/
[versioning-policy]:                ../../updating-migrating/versioning-policy.md
[dynamic-dns-resolution-nginx]:     ../../admin-ru/configure-dynamic-dns-resolution-nginx.md
[2.16-installation-instr]:          ../../../../2.16/waf-installation/nginx/dynamic-module/

# Установка динамического модуля WAF для NGINX stable из репозитория NGINX

Инструкция описывает подключение Валарм WAF как динамического модуля к бесплатной версии NGINX `stable`, установленной из репозитория NGINX.

--8<-- "../include/waf/installation/already-installed-waf.md"

## Требования

--8<-- "../include/waf/installation/nginx-requirements.md"

## Варианты установки

--8<-- "../include/waf/installation/nginx-installation-options.md"

Команды установки для разных вариантов описаны в соответствующих шагах.

## Установка

### 1. Установите NGINX stable и зависимости

Возможны следующие способы установки NGINX `stable` из репозитория NGINX:

* Установка из готового пакета

    === "Debian"
        ```bash
        sudo apt install curl gnupg2 ca-certificates lsb-release
        echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
        curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
        sudo apt update
        sudo apt install nginx
        ```
    === "Ubuntu"
        ```bash
        sudo apt install curl gnupg2 ca-certificates lsb-release
        echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
        curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
        sudo apt update
        sudo apt install nginx
        ```
    === "CentOS или Amazon Linux 2"
        ```bash
        echo -e '\n[nginx-stable] \nname=nginx stable repo \nbaseurl=http://nginx.org/packages/centos/$releasever/$basearch/ \ngpgcheck=1 \nenabled=1 \ngpgkey=https://nginx.org/keys/nginx_signing.key \nmodule_hotfixes=true' | sudo tee /etc/yum.repos.d/nginx.repo
        sudo yum install nginx
        ```

* Компиляция и установка с аналогичными опциями из исходного кода из ветки `stable` [репозитория NGINX](https://hg.nginx.org/pkg-oss/branches)

Более подробная информация об установке доступна в [официальной документации NGINX](https://www.nginx.com/resources/admin-guide/installing-nginx-open-source/).

!!! info "Установка на Amazon Linux 2"
    Для установки NGINX на Amazon Linux 2 используйте инструкцию для CentOS 7.

### 2. Добавьте репозитории Валарм WAF

Валарм WAF устанавливается и обновляется из репозиториев Валарм. Для добавления репозиториев используйте команды для вашей платформы.

--8<-- "../include/waf/installation/add-nginx-waf-repos.md"

### 3. Установите пакеты Валарм WAF

#### Обработка запросов и постаналитика на одном сервере

Для обработки запросов и проведения статистического анализа на одном сервере, необходимо установить следующие группы пакетов:

* `nginx-module-wallarm` для модуля NGINX-Wallarm
* `wallarm-node` для модуля постаналитики, хранилища Tarantool и дополнительных пакетов NGINX-Wallarm

--8<-- "../include/waf/installation/nginx-postanalytics.md"

#### Обработка запросов и постаналитика на разных серверах

Для обработки запросов и проведения статистического анализа на разных серверах, необходимо установить следующие группы пакетов:

* `wallarm-node-nginx` и `nginx-module-wallarm` для модуля NGINX-Wallarm

    === "Debian"
        ```bash
        sudo apt install --no-install-recommends wallarm-node-nginx nginx-module-wallarm
        ```
    === "Ubuntu"
        ```bash
        sudo apt install --no-install-recommends wallarm-node-nginx nginx-module-wallarm
        ```
    === "CentOS или Amazon Linux 2"
        ```bash
        sudo yum install wallarm-node-nginx nginx-module-wallarm
        ```

* `wallarm-node-tarantool` на отдельный сервер для модуля постаналитики и хранилища Tarantool (установка описана в [инструкции](../../admin-ru/installation-postanalytics-ru.md))

### 4. Подключите модуль Валарм WAF

1. Откройте файл `/etc/nginx/nginx.conf`:

    ```bash
    sudo vim /etc/nginx/nginx.conf
    ```
2. Проверьте, что в файле есть строка `include /etc/nginx/conf.d/*`. Если такой строки нет, добавьте ее.
3. Добавьте следующую директиву под директивой `worker_processes`:

    ```bash
    load_module modules/ngx_http_wallarm_module.so;
    ```

    Пример файла с добавленной директивой:

    ```
    user  nginx;
    worker_processes  auto;
    load_module modules/ngx_http_wallarm_module.so;

    error_log  /var/log/nginx/error.log notice;
    pid        /var/run/nginx.pid;
    ```

3. Скопируйте конфигурационные файлы для настройки системы:

    ``` bash
    sudo cp /usr/share/doc/nginx-module-wallarm/examples/*.conf /etc/nginx/conf.d/
    ```

### 5. Подключите WAF‑ноду к Облаку Валарм

--8<-- "../include/waf/installation/connect-waf-and-cloud.md"

### 6. Обновите конфигурацию Валарм WAF

--8<-- "../include/waf/installation/nginx-waf-min-configuration.md"

### 7. Перезапустите NGINX

--8<-- "../include/waf/root_perm_info.md"

--8<-- "../include/waf/restart-nginx.md"

### 8. Протестируйте работу Валарм WAF

--8<-- "../include/waf/installation/test-waf-operation.md"

## Настройка

Динамический модуль Валарм WAF со стандартными настройками установлен на NGINX. Чтобы кастомизировать настройки Валарм WAF, используйте [доступные директивы](../../admin-ru/configure-parameters-ru.md).

--8<-- "../include/waf/installation/common-customization-options-nginx.md"
