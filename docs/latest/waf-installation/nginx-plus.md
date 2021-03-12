[img-wl-console-users]:             ../images/check-users.png 
[wallarm-status-instr]:             ../admin-ru/configure-statistics-service.md
[memory-instr]:                     ../admin-ru/configuration-guides/allocate-resources-for-waf-node.md
[waf-directives-instr]:             ../admin-ru/configure-parameters-ru.md
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
[2.16-install-postanalytics-instr]: ../../2.16/admin-ru/installation-postanalytics-ru/
[update-instr]:                     ../updating-migrating/nginx-modules.md
[2.16-installation-instr]:          ../../2.16/waf-installation/nginx-plus/
[nginx-modules-update-docs]:        ../../updating-migrating/nginx-modules/
[separate-postanalytics-update-docs]:   ../../updating-migrating/separate-postanalytics/
[install-postanalytics-docs]:        ../../admin-ru/installation-postanalytics-ru/
[versioning-policy]:                ../updating-migrating/versioning-policy.md
[enable-libdetection-docs]:         ../admin-ru/configure-parameters-ru.md#wallarm_enable_libdetection

# Установка динамического модуля WAF для NGINX Plus

Инструкция описывает подключение Валарм WAF как динамического модуля к официальной коммерческой версии NGINX Plus.

--8<-- "../include/waf/installation/already-installed-waf-2.18.md"

## Требования

--8<-- "../include/waf/installation/nginx-requirements.md"

## Варианты установки

--8<-- "../include/waf/installation/nginx-installation-options.md"

Команды установки для разных вариантов описаны в соответствующих шагах.

## Установка
    
### 1. Установите NGINX Plus и зависимости

Установите NGINX Plus и зависимости, используя [официальную инструкцию NGINX](https://www.nginx.com/resources/admin-guide/installing-nginx-plus/).

!!! info "Установка на Amazon Linux 2"
    Для установки NGINX Plus на Amazon Linux 2 используйте инструкцию для CentOS 7.

### 2. Добавьте репозитории Валарм WAF

Валарм WAF устанавливается и обновляется из репозиториев Валарм. Для добавления репозиториев используйте команды для вашей платформы.

--8<-- "../include/waf/installation/add-nginx-waf-repos-2.18.md"

### 3. Установите пакеты Валарм WAF

#### Обработка запросов и постаналитика на одном сервере

Для обработки запросов и проведения статистического анализа на одном сервере, необходимо установить следующие группы пакетов:

* `nginx-plus-module-wallarm` для модуля NGINX Plus-Wallarm
* `wallarm-node` для модуля постаналитики, хранилища Tarantool и дополнительных пакетов NGINX Plus-Wallarm

=== "Debian"
    ```bash
    sudo apt install --no-install-recommends wallarm-node nginx-plus-module-wallarm
    ```
=== "Ubuntu"
    ```bash
    sudo apt install --no-install-recommends wallarm-node nginx-plus-module-wallarm
    ```
=== "CentOS или Amazon Linux 2"
    ```bash
    sudo yum install wallarm-node nginx-plus-module-wallarm
    ```

#### Обработка запросов и постаналитика на разных серверах

Для обработки запросов и проведения статистического анализа на разных серверах, необходимо установить следующие группы пакетов:

* `wallarm-node-nginx` и `nginx-plus-module-wallarm` для модуля NGINX Plus-Wallarm

    === "Debian"
        ```bash
        sudo apt install --no-install-recommends wallarm-node-nginx nginx-plus-module-wallarm
        ```
    === "Ubuntu"
        ```bash
        sudo apt install --no-install-recommends wallarm-node-nginx nginx-plus-module-wallarm
        ```
    === "CentOS или Amazon Linux 2"
        ```bash
        sudo yum install wallarm-node-nginx nginx-plus-module-wallarm
        ```

* `wallarm-node-tarantool` на отдельный сервер для модуля постаналитики и хранилища Tarantool (установка описана в [инструкции](../admin-ru/installation-postanalytics-ru.md))

### 4. Подключите модуль Валарм WAF

1. Откройте файл `/etc/nginx/nginx.conf`:

    ```bash
    sudo vim /etc/nginx/nginx.conf
    ```
2. Добавьте следующую директиву под директивой `worker_processes`:

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
    sudo cp /usr/share/doc/nginx-plus-module-wallarm/examples/*.conf /etc/nginx/conf.d/
    ```

### 5. Подключите WAF‑ноду к Облаку Валарм

--8<-- "../include/waf/installation/connect-waf-and-cloud.md"

### 6. Обновите конфигурацию Валарм WAF

--8<-- "../include/waf/installation/nginx-waf-min-configuration-2.16.md"

### 7. Перезапустите NGINX Plus

--8<-- "../include/waf/root_perm_info.md"

--8<-- "../include/waf/restart-nginx-2.16.md"

### 8. Протестируйте работу Валарм WAF

--8<-- "../include/waf/installation/test-waf-operation.md"

## Настройка

Динамический модуль Валарм WAF со стандартными настройками установлен на NGINX Plus. Чтобы кастомизировать настройки Валарм WAF, используйте [доступные директивы](../admin-ru/configure-parameters-ru.md).

--8<-- "../include/waf/installation/common-customization-options-216.md"
