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

# Обновление Linux‑пакетов WAF

Инструкция описывает способ обновления Linux‑пакетов WAF, установленных по инструкциям ниже, до версии 2.14.

* [Модуль для NGINX `stable`](../waf-installation/nginx/dynamic-module.md)
* [Модуль для NGINX из репозиториев CentOS/Debian](../waf-installation/nginx/dynamic-module-from-distr.md)
* [Модуль для NGINX Plus](../waf-installation/nginx-plus.md)
* [Модуль для Kong](../admin-ru/installation-kong-ru.md)

## Порядок обновления

* Если модули WAF‑ноды и постаналитики установлены на одном сервере, выполните шаги ниже.
* Если модули WAF‑ноды и постаналитики установлены на разных серверах, обновите модуль постаналитики по [инструкции](separate-postanalytics.md) и выполните шаги ниже для модуля WAF‑ноды.

## Шаг 1: Подключите новые репозитории Валарм WAF

--8<-- "../include/migration-212-214/add-new-repo.md"

## Шаг 2: Обновите пакеты Валарм WAF

### WAF‑нода и постаналитика на одном сервере

=== "Debian"
    ```bash
    sudo apt install wallarm-node wallarm-node-tarantool --no-install-recommends
    ```
=== "Ubuntu"
    ```bash
    sudo apt install wallarm-node wallarm-node-tarantool --no-install-recommends
    ```
=== "CentOS или Amazon Linux 2"
    ```bash
    sudo yum update wallarm-node wallarm-node-tarantool
    ```

### WAF‑нода и постаналитика на разных серверах

1. Обновите пакеты постаналитики по [инструкции](separate-postanalytics.md).
2. Обновите пакеты WAF‑ноды:

    === "Debian"
        ```bash
        sudo apt install wallarm-node-nginx --no-install-recommends
        ```
    === "Ubuntu"
        ```bash
        sudo apt install wallarm-node-nginx --no-install-recommends
        ```
    === "CentOS или Amazon Linux 2"
        ```bash
        sudo yum update wallarm-node-nginx
        ```

## Шаг 3: Перезапустите NGINX

--8<-- "../include/waf/restart-nginx.md"

## Шаг 4: Протестируйте работу Валарм WAF

--8<-- "../include/waf/installation/test-waf-operation.md"

## Настройка

Модули Валарм WAF обновлены до версии 2.14. Настройки Валарм WAF из предыдущей версии применятся к новой версии автоматически. Чтобы применить дополнительные настройки, используйте [доступные директивы](../admin-ru/configure-parameters-ru.md).

--8<-- "../include/waf/installation/common-customization-options-nginx.md"