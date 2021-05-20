[doc-ip-blocking]:            configure-ip-blocking-ru.md
[doc-wallarm-mode]:           configure-parameters-ru.md#wallarm_mode
[doc-config-params]:          configure-parameters-ru.md
[doc-monitoring]:             monitoring/intro.md
[waf-mode-instr]:                   configure-wallarm-mode.md
[logging-instr]:                    configure-logging.md
[proxy-balancer-instr]:             using-proxy-or-balancer-ru.md
[scanner-whitelisting-instr]:       scanner-ips-whitelisting.md
[process-time-limit-instr]:         configure-parameters-ru.md#wallarm_process_time_limit
[default-ip-blocking-settings]:     configure-ip-blocking-nginx-ru.md
[wallarm-acl-directive]:            configure-parameters-ru.md#wallarm_acl
[allocating-memory-guide]:          configuration-guides/allocate-resources-for-waf-node.md
[mount-config-instr]:               #запуск-контейнера-с-примонтированным-конфигурационным-файлом

# Запуск Docker‑образа на основе NGINX

## Обзор образа

WAF‑нода на основе NGINX может быть установлена в виде Docker‑контейнера. Контейнер является «толстым» и содержит все подсистемы WAF‑ноды.

Функциональность WAF‑ноды, установленной в виде Docker‑контейнера, полностью идентична функциональности других вариантов установки.

!!! info "Если Валарм WAF уже развернут"
    Если вы разворачиваете образ Валарм WAF вместо существующего образа или дублируете установку, используйте версию существующего Валарм WAF или обновите версии всех образов до последней.

    Чтобы получить текущую версию, выполните команду в контейнере: 

    ```
    apt list wallarm-node
    ```

    * Если установлена версия `2.18.x`, используйте [инструкцию для 2.18](../../../admin-ru/installation-docker-ru/).
    * Если установлена версия `2.16.x`, используйте [инструкцию для 2.16](../../../2.16/admin-ru/installation-docker-ru/) или [обновите все образы до последней версии](../../../updating-migrating/docker-container/).
    * Если установлена версия `2.14.x` или ниже, [обновите все образы до последней версии](../../../updating-migrating/docker-container).
    
    Более подробная информация о поддержке версий доступна в [политике версионирования WAF‑ноды](../updating-migrating/versioning-policy.md).

## Требования

--8<-- "../include/waf/installation/requirements-docker.md"

## Варианты запуска контейнера

--8<-- "../include/waf/installation/docker-running-options.md"

## Запуск контейнера с переменными окружения

Вы можете передать в контейнер следующие базовые настройки WAF через опцию `-e`:

--8<-- "../include/waf/installation/nginx-docker-all-env-vars-214.md"

Для запуска образа используйте команду:

=== "EU‑облако"
    ```bash
    docker run -d -e DEPLOY_USER='deploy@example.com' -e DEPLOY_PASSWORD='very_secret' -e NGINX_BACKEND='example.com' -e TARANTOOL_MEMORY_GB=16 -p 80:80 wallarm/node:2.14
    ```
=== "RU‑облако"
    ```bash
    docker run -d -e DEPLOY_USER='deploy@example.com' -e DEPLOY_PASSWORD='very_secret' -e NGINX_BACKEND='example.com' -e WALLARM_API_HOST='api.wallarm.ru' -e TARANTOOL_MEMORY_GB=16 -p 80:80 wallarm/node:2.14
    ```

Команда выполнит следующие действия:

* Автоматически создаст WAF‑ноду в Облаке Валарм. Созданный элемент отобразится в Консоли управления → **Ноды**.
* Создаст файл `default` с минимальными настройками NGINX в директории контейнера `/etc/nginx/sites-enabled`.
* Создаст файлы с параметрами для доступа к Облаку Валарм в директории контейнера `/etc/wallarm`:
    * `node.yaml` с UUID WAF‑ноды и секретным ключом
    * `license.key` с лицензионным ключом Валарм
* Защитит ресурс `http://NGINX_BACKEND:80`

## Запуск контейнера с примонтированным конфигурационным файлом

Вы можете примонтировать в контейнер готовый конфигурационный файл через опцию `-v`. Файл должен содержать следующие настройки:

* [Директивы WAF‑ноды](configure-parameters-ru.md)
* [Настройки NGINX](https://nginx.org/ru/docs/beginners_guide.html)

??? info "Открыть пример примонтированного файла с минимальными настройками"
    ```bash
    server {
        listen 80 default_server;
        listen [::]:80 default_server ipv6only=on;
        #listen 443 ssl;

        server_name localhost;

        #ssl_certificate cert.pem;
        #ssl_certificate_key cert.key;

        root /usr/share/nginx/html;

        index index.html index.htm;

        wallarm_mode monitoring;
        # wallarm_instance 1;
        # wallarm_acl default;

        location / {
                proxy_pass http://example.com;
                include proxy_params;
        }
    }
    ```

Для запуска образа:

1. Передайте в контейнер обязательные переменные окружения через опцию `-e`:

    --8<-- "../include/waf/installation/nginx-docker-env-vars-to-mount.md"

2. Примонтируйте директорию с файлом `default` в директорию контейнера `/etc/nginx/sites-enabled` через опцию `-v`.

    === "EU‑облако"
        ```bash
        docker run -d -e DEPLOY_USER='deploy@example.com' -e DEPLOY_PASSWORD='very_secret' -v /configs/default:/etc/nginx/sites-enabled/default -p 80:80 wallarm/node:2.14
        ```
    === "RU‑облако"
        ```bash
        docker run -d -e DEPLOY_USER='deploy@example.com' -e DEPLOY_PASSWORD='very_secret' -e WALLARM_API_HOST='api.wallarm.ru' -v /configs/default:/etc/nginx/sites-enabled/default -p 80:80 wallarm/node:2.14
        ```

Команда выполнит следующие действия:

* Автоматически создаст WAF‑ноду в Облаке Валарм. Созданный элемент отобразится в Консоли управления → **Ноды**.
* Примонтирует файл `default` в директорию контейнера `/etc/nginx/sites-enabled`.
* Создаст файлы с параметрами для доступа к Облаку Валарм в директории контейнера `/etc/wallarm`:
    * `node.yaml` с UUID WAF‑ноды и секретным ключом
    * `license.key` с лицензионным ключом Валарм
* Защитит ресурс `http://NGINX_BACKEND:80`

!!! info "Монтирование других конфигурационных файлов"
    Директории контейнера, которые использует NGINX:

    * `/etc/nginx/conf.d` — общие настройки
    * `/etc/nginx/sites-enabled` — настройки виртуальных хостов
    * `/var/www/html` — статические файлы

    Вы можете примонтировать необходимые конфигурационные файлы в перечисленные директории. Директивы WAF‑ноды описываются в файле контейнера `/etc/nginx/sites-enabled/default`.

## Настройка логирования

Логирование по умолчанию включено. Логи пишутся в следующие директории:

* `/var/log/nginx` — логи NGINX
* `/var/log/wallarm` — логи подсистем Валарм WAF

Для настройки расширенного логирования используйте [инструкцию](configure-logging.md).

По умолчанию логи ротируются раз в сутки. Изменение параметров ротации через переменные окружения не предусмотрено. Настройка ротации происходит через конфигурационные файлы в `/etc/logrotate.d/`.

## Настройка мониторинга

Внутри контейнера установлены Nagios‑совместимые скрипты для мониторинга WAF‑ноды. Подробнее в разделе [Мониторинг WAF‑ноды][doc-monitoring].

Пример вызова скриптов:

``` bash
docker exec -it wallarm-node /usr/lib/nagios-plugins/check_wallarm_tarantool_timeframe -w 1800 -c 900
```

``` bash
docker exec -it wallarm-node /usr/lib/nagios-plugins/check_wallarm_export_delay -w 120 -c 300
```

## Тестирование работы Валарм WAF

--8<-- "../include/waf/installation/test-waf-operation-no-stats.md"

## Частые настройки

Примонтированный конфигурационный файл должен описывать настройки WAF‑ноды через [доступные директивы](configure-parameters-ru.md). Ниже приведен набор настроек, которые часто применяются к WAF‑ноде с помощью директив:

--8<-- "../include/waf/installation/common-customization-options-docker.md"