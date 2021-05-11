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
[2.16-install-postanalytics-instr]: ../../admin-ru/installation-postanalytics-ru.md
[update-instr]:                     ../../updating-migrating/nginx-modules.md
[2.16-installation-instr]:          ../../../2.16/waf-installation/nginx/dynamic-module-from-distr/
[nginx-modules-update-docs]:        ../../../../updating-migrating/nginx-modules/
[separate-postanalytics-update-docs]:   ../../../../updating-migrating/separate-postanalytics/
[install-postanalytics-docs]:        ../../../admin-ru/installation-postanalytics-ru/
[versioning-policy]:                ../../updating-migrating/versioning-policy.md
[dynamic-dns-resolution-nginx]:     ../../admin-ru/configure-dynamic-dns-resolution-nginx.md
[enable-libdetection-docs]:         ../../admin-ru/configure-parameters-ru.md#wallarm_enable_libdetection
[2.18-install-postanalytics-instr]: ../../../../admin-ru/installation-postanalytics-ru/
[2.18-installation-instr]:          ../../../../waf-installation/nginx/dynamic-module-from-distr/

# Установка динамического модуля для NGINX из репозитория Debian/CentOS

Инструкция описывает подключение Валарм WAF как динамического модуля к бесплатной версии NGINX, установленной из репозитория Debian/CentOS.

--8<-- "../include/waf/installation/already-installed-waf-distr-2.16.md"

## Требования

--8<-- "../include/waf/installation/nginx-requirements.md"

## Варианты установки

--8<-- "../include/waf/installation/nginx-installation-options.md"

Команды установки для разных вариантов описаны в соответствующих шагах.

## Установка

### 1. Добавьте репозитории Debian/CentOS

=== "Debian 9.x (stretch)"
    ```bash
    sudo apt install dirmngr
    curl -fsSL https://repo.wallarm.com/wallarm.gpg | sudo apt-key add -
    sh -c "echo 'deb http://repo.wallarm.com/debian/wallarm-node stretch/2.16/' | sudo tee /etc/apt/sources.list.d/wallarm.list"
    sudo apt update
    ```
=== "Debian 9.x (stretch-backports)"
    ```bash
    sudo apt install dirmngr
    curl -fsSL https://repo.wallarm.com/wallarm.gpg | sudo apt-key add -
    sh -c "echo 'deb http://repo.wallarm.com/debian/wallarm-node stretch/2.16/' | sudo tee /etc/apt/sources.list.d/wallarm.list"
    sh -c "echo 'deb http://repo.wallarm.com/debian/wallarm-node stretch-backports/2.16/' | sudo tee --append /etc/apt/sources.list.d/wallarm.list"
    # для корректной работы снимите комментарий со следующей строки в файле /etc/apt/sources.list`:
    # deb http://deb.debian.org/debian stretch-backports main contrib non-free
    sudo apt update
    ```
=== "Debian 10.x (buster)"
    ```bash
    sudo apt install dirmngr
    curl -fsSL https://repo.wallarm.com/wallarm.gpg | sudo apt-key add -
    sh -c "echo 'deb http://repo.wallarm.com/debian/wallarm-node buster/2.16/' | sudo tee /etc/apt/sources.list.d/wallarm.list"
    sudo apt update
    ```
=== "CentOS 7.x"
    ```bash
    sudo yum install -y epel-release
    sudo rpm -i https://repo.wallarm.com/centos/wallarm-node/7/2.16/x86_64/Packages/wallarm-node-repo-1-5.el7.noarch.rpm
    ```
=== "CentOS 8.x"
    ```bash
    sudo yum install -y epel-release
    sudo rpm -i https://repo.wallarm.com/centos/wallarm-node/8/2.16/x86_64/Packages/wallarm-node-repo-1-5.el8.noarch.rpm
    ```

### 2. Установите NGINX с пакетами Валарм WAF

#### Обработка запросов и постаналитика на одном сервере

Команда выполняет установку следующих пакетов:

* `nginx` для NGINX
* `libnginx-mod-http-wallarm` или `nginx-mod-http-wallarm` для модуля NGINX-Wallarm
* `wallarm-node` для модуля постаналитики, хранилища Tarantool и дополнительных пакетов NGINX-Wallarm

=== "Debian 9.x (stretch)"
    ```bash
    sudo apt install --no-install-recommends nginx wallarm-node libnginx-mod-http-wallarm
    ```
=== "Debian 9.x (stretch-backports)"
    ```bash
    sudo apt install --no-install-recommends nginx wallarm-node libnginx-mod-http-wallarm -t stretch-backports
    ```
=== "Debian 10.x (buster)"
    ```bash
    sudo apt install --no-install-recommends nginx wallarm-node libnginx-mod-http-wallarm
    ```
=== "CentOS 7.x"
    ```bash
    sudo yum install nginx wallarm-node nginx-mod-http-wallarm
    ```
=== "CentOS 8.x"
    ```bash
    sudo yum install nginx wallarm-node nginx-mod-http-wallarm
    ```

#### Обработка запросов и постаналитика на разных серверах

Для обработки запросов и проведения статистического анализа на разных серверах, необходимо установить следующие группы пакетов:

* `wallarm-node-tarantool` на отдельный сервер для модуля постаналитики и хранилища Tarantool по [инструкции](../../admin-ru/installation-postanalytics-ru.md)

* `wallarm-node-nginx` и `libnginx-mod-http-wallarm`/`nginx-mod-http-wallarm` для модуля NGINX-Wallarm

Команда выполняет установку пакетов для NGINX и для модуля NGINX-Wallarm:

=== "Debian 9.x (stretch)"
    ```bash
    sudo apt install --no-install-recommends nginx wallarm-node-nginx libnginx-mod-http-wallarm
    ```
=== "Debian 9.x (stretch-backports)"
    ```bash
    sudo apt install --no-install-recommends nginx wallarm-node-nginx libnginx-mod-http-wallarm -t stretch-backports
    ```
=== "Debian 10.x (buster)"
    ```bash
    sudo apt install --no-install-recommends nginx wallarm-node-nginx libnginx-mod-http-wallarm
    ```
=== "CentOS 7.x"
    ```bash
    sudo yum install nginx wallarm-node-nginx nginx-mod-http-wallarm
    ```
=== "CentOS 8.x"
    ```bash
    sudo yum install nginx wallarm-node-nginx nginx-mod-http-wallarm
    ```

### 3. Подключите модуль Валарм WAF

Скопируйте конфигурационные файлы для настройки системы:

=== "Debian"
    ```bash
    sudo cp /usr/share/doc/libnginx-mod-http-wallarm/examples/*conf /etc/nginx/conf.d/
    ```
=== "CentOS"
    ```bash
    sudo cp /usr/share/doc/nginx-mod-http-wallarm/examples/*conf /etc/nginx/conf.d/
    ```

### 4. Подключите WAF‑ноду к Облаку Валарм

--8<-- "../include/waf/installation/connect-waf-and-cloud.md"

### 5. Обновите конфигурацию Валарм WAF

Основные конфигурационные файлы NGINX и WAF‑ноды Валарм расположены в директориях:

* `/etc/nginx/conf.d/default.conf` с настройками NGINX
* `/etc/nginx/conf.d/wallarm.conf` с глобальными настройками WAF‑ноды Валарм

    Файл используется для настроек, которые применяются ко всем доменам. Чтобы применить разные настройки к отдельным группам доменов, используйте файл `default.conf` или создайте новые файлы конфигурации для каждой группы доменов (например, `example.com.conf` и `test.com.conf`). Более подробная информация о конфигурационных файлах NGINX доступна в [официальной документации NGINX](https://nginx.org/ru/docs/beginners_guide.html).
* `/etc/nginx/conf.d/wallarm‑status.conf` с настройками мониторинга WAF‑ноды. Описание конфигурации доступно по [ссылке][wallarm-status-instr]
* `/etc/default/wallarm-tarantool` или `/etc/sysconfig/wallarm-tarantool` с настройками хранилища Tarantool

#### Режим фильтрации запросов

По умолчанию, WAF‑нода находится в режиме `off` и не фильтрует входящие запросы. Измените режим фильтрации для блокировки запросов с атаками на уровне настроек NGINX:

1. Откройте файл `/etc/nginx/conf.d/default.conf`:

    ```bash
    sudo vim /etc/nginx/conf.d/default.conf
    ```
2. Добавьте в блок `server` строку `wallarm_mode block;`.

??? "Пример файла `/etc/nginx/conf.d/default.conf`"

    ```bash
    server {
        # порт, для которого фильтруется трафик
        listen       80;
        # домен, для которого фильтруется трафик
        server_name  localhost;
        # режим работы WAF‑ноды
        wallarm_mode block;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/share/nginx/html;
        }
    }
    ```

#### Оперативная память

!!! info "Постаналитика на отдельном сервере"
    Если постаналитика установлена на отдельный сервер, пропустите этот шаг. Настройка постаналитики была выполнена во время отдельной установки.

WAF‑нода использует находящееся в памяти хранилище Tarantool. Рекомендуемое количество памяти для Tarantool: 75% от общей памяти виртуальной машины. Чтобы настроить объем памяти для Tarantool:

1. Откройте для редактирования конфигурационный файл Tarantool:

    === "Debian"
        ``` bash
        sudo vim /etc/default/wallarm-tarantool
        ```
    === "CentOS"
        ``` bash
        sudo vim /etc/sysconfig/wallarm-tarantool
        ```
2. Укажите размер выделенной памяти в директиве `SLAB_ALLOC_ARENA` в ГБ. Значение может быть целым или дробным (разделитель целой и дробной части — точка). Например, 24 ГБ:
    
    ```bash
    SLAB_ALLOC_ARENA=24
    ```

    Подробные рекомендации по выделению памяти для Tarantool описаны в [инструкции][memory-instr]. 
3. Чтобы применить изменения, перезапустите Tarantool:

    === "Debian"
        ``` bash
        sudo systemctl restart wallarm-tarantool
        ```
    === " CentOS 7.x"
        ```bash
        sudo systemctl restart wallarm-tarantool
        ```

#### Адрес отдельного сервера постаналитики

!!! info "NGINX-Wallarm и постаналитика на одном сервере"
    Если модуль NGINX-Wallarm и постаналитика установлены на одном сервере, пропустите этот шаг.

--8<-- "../include/waf/configure-separate-postanalytics-address-nginx.md"

#### Другие настройки

Чтобы обновить другие настройки NGINX и Валарм WAF, используйте документацию NGINX и список доступных [директив Валарм WAF][waf-directives-instr].

### 6. Перезапустите NGINX

--8<-- "../include/waf/root_perm_info.md"

=== "Debian"
    ```bash
    sudo systemctl restart nginx
    ```
=== "CentOS 7.x"
    ```bash
    sudo systemctl restart nginx
    ```

### 7. Протестируйте работу Валарм WAF

--8<-- "../include/waf/installation/test-waf-operation.md"

## Настройка

Динамический модуль Валарм WAF со стандартными настройками установлен на NGINX из репозитория Debian/CentOS. Чтобы кастомизировать настройки Валарм WAF, используйте [доступные директивы](../../admin-ru/configure-parameters-ru.md).

--8<-- "../include/waf/installation/common-customization-options-nginx-216.md"
