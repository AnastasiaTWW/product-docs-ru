[waf-mode-instr]:                   ../admin-ru/configure-wallarm-mode.md
[logging-instr]:                    ../admin-ru/configure-logging.md
[proxy-balancer-instr]:             ../admin-ru/using-proxy-or-balancer-ru.md
[scanner-whitelisting-instr]:       ../admin-ru/scanner-ips-whitelisting.md
[process-time-limit-instr]:         ../admin-ru/configure-parameters-ru.md#wallarm_process_time_limit
[default-ip-blocking-settings]:     ../admin-ru/configure-ip-blocking-nginx-ru.md
[wallarm-acl-directive]:            ../admin-ru/configure-parameters-ru.md#wallarm_acl
[allocating-memory-guide]:          ../admin-ru/configuration-guides/allocate-resources-for-waf-node.md
[enable-libdetection-docs]:         ../admin-ru/configure-parameters-ru.md#wallarm_enable_libdetection
[mount-config-instr]:               #запуск-контейнера-с-примонтированным-конфигурационным-файлом

# Обновление запущенного Docker‑образа на основе NGINX

Инструкция описывает способ обновления запущенного Docker‑образа на основе NGINX до версии 2.16.

!!! warning "Использование данных существующей WAF‑ноды"
    Мы не рекомендуем использовать уже созданную WAF‑ноду предыдущей версии. Пожалуйста, используйте данную инструкцию, чтобы создать новую WAF‑ноду версии 2.16 и развернуть Docker‑контейнер с новой версией.

## Требования

--8<-- "../include/waf/installation/requirements-docker.md"

## Шаг 1: Загрузите обновленный образ

```bash
docker pull wallarm/node:2.16.0-9
```

## Шаг 2: Остановите текущий контейнер

```bash
docker stop <RUNNING_CONTAINER_NAME>
```

## Шаг 3: Запустите контейнер на основе нового образа

### Варианты запуска контейнера

При запуске контейнера на основе нового образа, вы можете использовать те же параметры конфигурации, которые были переданы с предыдущей версией образа. Набор параметров, которые больше не используются или были добавлены в новой версии WAF‑ноды, публикуется в списке [изменений в новой версии WAF‑ноды](what-is-new.md).

Вы можете передать параметры конфигурации в контейнер одним из следующих способов:

* **Через переменные окружения**. В контейнер передаются базовые настройки WAF‑ноды, большинство [доступных директив](../admin-ru/configure-parameters-ru.md) не могут быть переданы через переменные окружения.
* **В примонтированном конфигурационном файле**. В контейнер могут быть переданы все [доступные директивы](../admin-ru/configure-parameters-ru.md) WAF‑ноды.

### Запуск контейнера с переменными окружения

Вы можете передать в контейнер следующие базовые настройки WAF через опцию `-e`:

--8<-- "../include/waf/installation/nginx-docker-all-env-vars.md"

Для запуска образа используйте команду:

=== "EU‑облако"
    ```bash
    docker run -d -e DEPLOY_USER='deploy@example.com' -e DEPLOY_PASSWORD='very_secret' -e NGINX_BACKEND='example.com' -e TARANTOOL_MEMORY_GB=16 -p 80:80 wallarm/node:2.16.0-9
    ```
=== "RU‑облако"
    ```bash
    docker run -d -e DEPLOY_USER='deploy@example.com' -e DEPLOY_PASSWORD='very_secret' -e NGINX_BACKEND='example.com' -e WALLARM_API_HOST='api.wallarm.ru' -e TARANTOOL_MEMORY_GB=16 -p 80:80 wallarm/node:2.16.0-9
    ```

Команда выполнит следующие действия:

* Автоматически создаст WAF‑ноду версии 2.16 в Облаке Валарм. Созданный элемент отобразится в Консоли управления → **Ноды**.
* Создаст файл `default` с минимальными настройками NGINX в директории контейнера `/etc/nginx/sites-enabled`.
* Создаст файлы с параметрами для доступа к Облаку Валарм в директории контейнера `/etc/wallarm`:
    * `node.yaml` с UUID WAF‑ноды и секретным ключом
    * `license.key` с лицензионным ключом Валарм
* Защитит ресурс `http://NGINX_BACKEND:80`

### Запуск контейнера с примонтированным конфигурационным файлом

Вы можете примонтировать в контейнер готовый конфигурационный файл через опцию `-v`. Файл должен содержать следующие настройки:

* [Директивы WAF‑ноды](../admin-ru/configure-parameters-ru.md)
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
        docker run -d -e DEPLOY_USER='deploy@example.com' -e DEPLOY_PASSWORD='very_secret' -v /configs/default:/etc/nginx/sites-enabled/default -p 80:80 wallarm/node:2.16.0-9
        ```
    === "RU‑облако"
        ```bash
        docker run -d -e DEPLOY_USER='deploy@example.com' -e DEPLOY_PASSWORD='very_secret' -e WALLARM_API_HOST='api.wallarm.ru' -v /configs/default:/etc/nginx/sites-enabled/default -p 80:80 wallarm/node:2.16.0-9
        ```

Команда выполнит следующие действия:

* Автоматически создаст WAF‑ноду версии 2.16 в Облаке Валарм. Созданный элемент отобразится в Консоли управления → **Ноды**.
* Примонтирует файл `default` в директорию контейнера `/etc/nginx/sites-enabled`.
* Создаст файлы с параметрами для доступа к Облаку Валарм в директории контейнера `/etc/wallarm`:
    * `node.yaml` с UUID WAF‑ноды и секретным ключом
    * `license.key` с лицензионным ключом Валарм
* Защитит ресурс `http://example.com`

!!! info "Монтирование других конфигурационных файлов"
    Директории контейнера, которые использует NGINX:

    * `/etc/nginx/conf.d` — общие настройки
    * `/etc/nginx/sites-enabled` — настройки виртуальных хостов
    * `/var/www/html` — статические файлы

    Вы можете примонтировать необходимые конфигурационные файлы в перечисленные директории. Директивы WAF‑ноды описываются в файле контейнера `/etc/nginx/sites-enabled/default`.

## Шаг 4: Протестируйте работу Валарм WAF

--8<-- "../include/waf/installation/test-waf-operation-no-stats.md"

## Шаг 5: Удалите WAF‑ноду предыдущей версии

Если развернутый образ версии 2.16 работает корректно, вы можете удалить WAF‑ноду предыдущей версии в Консоли управления Валарм → секция **Ноды**.

## Частые настройки

* [Настройка логирования](../admin-ru/installation-docker-ru.md#настройка-логирования)
* [Настройка мониторинга](../admin-ru/installation-docker-ru.md#настройка-мониторинга)

Примонтированный конфигурационный файл должен описывать настройки WAF‑ноды через [доступные директивы](../admin-ru/configure-parameters-ru.md). Ниже приведен набор настроек, которые часто применяются к WAF‑ноде с помощью директив:

--8<-- "../include/waf/installation/common-customization-options-docker-216.md"