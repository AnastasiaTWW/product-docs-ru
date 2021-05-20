[default-ip-blocking-settings]:     ../../../admin-ru/configure-ip-blocking-nginx-ru.md
[wallarm-acl-directive]:            ../../../admin-ru/configure-parameters-ru.md#wallarm_acl
[allocating-memory-guide]:          ../../../admin-ru/configuration-guides/allocate-resources-for-waf-node.md
[mount-config-instr]:               #деплой-контейнера-с-настройкой-waf-ноды-через-примонтированный-файл

# Деплой Docker‑образа WAF‑ноды в Alibaba Cloud

Данная инструкция содержит краткое руководство по деплою [Docker‑образа WAF‑ноды (NGINX)](https://hub.docker.com/r/wallarm/node) с помощью облачной платформы Alibaba Cloud. Для деплоя Docker-образа используется [сервис Alibaba Cloud Elastic Compute Service (ECS)](https://www.alibabacloud.com/product/ecs).

!!! warning "Ограничение инструкции"
    В данной инструкции не описана конфигурация для балансировки нагрузки и автоматического масштабирования WAF‑нод. Чтобы выполнить конфигурацию самостоятельно, рекомендуем ознакомиться с [документацией Alibaba Cloud](https://www.alibabacloud.com/help/product/27537.htm?spm=a2c63.m28257.a1.82.dfbf5922VNtjka).

## Требования

* Доступ к [Консоли Alibaba Cloud](https://account.alibabacloud.com/login/login.htm)
* Доступ к аккаунту с ролью **Деплой** или **Администратор** и отключенная двухфакторная аутентификация в Консоли управления Валарм для [RU‑облака](https://my.wallarm.ru) или [EU‑облака](https://my.wallarm.com)

## Способы конфигурации Docker-контейнера с WAF-нодой

При деплое необходимо передать в Docker‑контейнер параметры WAF‑ноды одним из способов:

* **Через доступные переменные окружения**. С помощью переменных окружения задаются базовые настройки WAF-ноды. Большинство [доступных директив](../../../admin-ru/configure-parameters-ru.md) не могут быть переданы через переменные.
* **В примонтированном конфигурационном файле**. С помощью конфигурационного файла можно выполнить полную настройку WAF-ноды, используя  любые [доступные директивы](../../../admin-ru/configure-parameters-ru.md). При этом способе конфигурации параметры для подключения к Облаку Валарм передаются в переменных окружения.

## Деплой контейнера с настройкой WAF-ноды через переменные окружения

Для деплоя контейнера с настройками WAF-ноды, переданными только через переменные окружения, необходимо создать инстанс в Alibaba Cloud и запустить Docker-контейнер в этом же инстансе. Для этого вы можете использовать Консоль Alibaba Cloud или [CLI](https://www.alibabacloud.com/help/doc-detail/25499.htm). В данной инструкции используется Консоль Alibaba Cloud.

1. Перейдите в Консоль Alibaba Cloud → список сервисов → **Elastic Compute Service** → **Instances**.
2. Создайте инстанс по [инструкции Alibaba Cloud](https://www.alibabacloud.com/help/doc-detail/87190.htm?spm=a2c63.p38356.b99.137.77df24df7fJ2XX). При создании необходимо учесть следующие особенности:

    * Инстанс может быть создан на основе образа любой операционной системы.
    * Инстанс должен быть доступен для внешних ресурсов (необходимо настроить публичный IP-адрес или домен).
    * Настройки инстанса должны учитывать [способ](https://www.alibabacloud.com/help/doc-detail/71529.htm?spm=a2c63.p38356.b99.143.22388e44kpTM1l), с помощью которого вы планируете подключаться к инстансу.
3. Подключитесь к инстансу одним из способов, описанных в [документации Alibaba Cloud](https://www.alibabacloud.com/help/doc-detail/71529.htm?spm=a2c63.p38356.b99.143.22388e44kpTM1l).
4. Установите в инстансе пакеты Docker по [инструкции для подходящей ОС](https://docs.docker.com/engine/install/#server).
5. Запишите данные от аккаунта Валарм в локальные переменные окружения инстанса:

    ```bash
    export DEPLOY_USER='<DEPLOY_USER>'
    export DEPLOY_PASSWORD='<DEPLOY_PASSWORD>'
    ```
    
    * `<DEPLOY_USER>`: email для аккаунта пользователя **Деплой** или **Администратор** в Консоли управления Валарм.
    * `<DEPLOY_PASSWORD>`: пароль для аккаунта пользователя **Деплой** или **Администратор** в Консоли управления Валарм.
6. Запустите Docker-контейнер с настройками WAF-ноды через переменными окружения.

    === "Команда для EU‑облака"
        ```bash
        docker run -d -e DEPLOY_USER=${DEPLOY_USER} -e DEPLOY_PASSWORD=${DEPLOY_PASSWORD} -e NGINX_BACKEND=<HOST_TO_PROTECT_WITH_WAF> -p 80:80 wallarm/node:2.16.0-9
        ```
    === "Команда для RU‑облака"
        ```bash
        docker run -d -e DEPLOY_USER=${DEPLOY_USER} -e DEPLOY_PASSWORD=${DEPLOY_PASSWORD} -e NGINX_BACKEND=<HOST_TO_PROTECT_WITH_WAF> -e WALLARM_API_HOST='api.wallarm.ru' -p 80:80 wallarm/node:2.16.0-9
        ```

    * `-p`: порт, через который WAF-нода принимает запросы. Значение должно совпадать с портом инстанса.
    * `-e`: переменные окружения с настройками WAF-ноды из таблицы ниже. Не рекомендуется передавать значения переменных `DEPLOY_USER` и `DEPLOY_PASSWORD` в явном виде.

        --8<-- "../include/waf/installation/nginx-docker-all-env-vars.md"
7.  [Протестируйте работу WAF-ноды](#тестирование-работы-waf-ноды).

## Деплой контейнера с настройкой WAF-ноды через примонтированный файл

Для деплоя контейнера с настройками WAF-ноды, переданными через переменные окружения и примонтированный конфигурационный файл, необходимо создать инстанс с конфигурационным файлом и запустить Docker-контейнер в этом же инстансе. Для этого вы можете использовать Консоль Alibaba Cloud или [CLI](https://www.alibabacloud.com/help/doc-detail/25499.htm). В данной инструкции используется Консоль Alibaba Cloud.

1. Перейдите в Консоль Alibaba Cloud → список сервисов → **Elastic Compute Service** → **Instances**.
2. Создайте инстанс по [инструкции Alibaba Cloud](https://www.alibabacloud.com/help/doc-detail/87190.htm?spm=a2c63.p38356.b99.137.77df24df7fJ2XX). При создании необходимо учесть следующие особенности:

    * Инстанс может быть создан на основе образа любой операционной системы.
    * Инстанс должен быть доступен для внешних ресурсов (необходимо настроить публичный IP-адрес или домен).
    * Настройки инстанса должны учитывать [способ](https://www.alibabacloud.com/help/doc-detail/71529.htm?spm=a2c63.p38356.b99.143.22388e44kpTM1l), с помощью которого вы планируете подключаться к инстансу.
3. Подключитесь к инстансу одним из способов, описанных в [документации Alibaba Cloud](https://www.alibabacloud.com/help/doc-detail/71529.htm?spm=a2c63.p38356.b99.143.22388e44kpTM1l).
4. Установите в инстансе пакеты Docker по [инструкции для подходящей ОС](https://docs.docker.com/engine/install/#server).
5. Запишите данные от аккаунта Валарм в локальные переменные окружения инстанса:

    ```bash
    export DEPLOY_USER='<DEPLOY_USER>'
    export DEPLOY_PASSWORD='<DEPLOY_PASSWORD>'
    ```
    
    * `<DEPLOY_USER>`: email для аккаунта пользователя **Деплой** или **Администратор** в Консоли управления Валарм.
    * `<DEPLOY_PASSWORD>`: пароль для аккаунта пользователя **Деплой** или **Администратор** в Консоли управления Валарм.
6. Создайте в инстансе директорию с конфигурационным файлом `default` с настройками WAF-ноды (например, директорию `configs`). Пример файла с минимальными настройками:

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

    [Набор директив, которые могут быть указаны в конфигурационном файле →](../../../admin-ru/configure-parameters-ru.md)
6.  Запустите Docker-контейнер с WAF-нодой с примонтированным конфигурационным файлом и переменными окружения.

    === "EU‑облако"
        ```bash
        docker run -d -e DEPLOY_USER=${DEPLOY_USER} -e DEPLOY_PASSWORD=${DEPLOY_PASSWORD} -v <INSTANCE_PATH_TO_CONFIG>:<CONTAINER_PATH_FOR_MOUNTING> -p 80:80 wallarm/node:2.16.0-9
        ```
    === "RU‑облако"
        ```bash
        docker run -d -e DEPLOY_USER=${DEPLOY_USER} -e DEPLOY_PASSWORD=${DEPLOY_PASSWORD} -e WALLARM_API_HOST='api.wallarm.ru' -v <INSTANCE_PATH_TO_CONFIG>:<DIRECTORY_FOR_MOUNTING> -p 80:80 wallarm/node:2.16.0-9
        ```

    * `<INSTANCE_PATH_TO_CONFIG>`: путь до конфигурационного файла, созданного на предыдущем шаге. Например: `configs`.
    * `<DIRECTORY_FOR_MOUNTING>`: директория контейнера, в которую монтируется конфигурационный файл. Конфигурационный файл может быть примонтирован в директории контейнера, которые использует NGINX:

        * `/etc/nginx/conf.d` — общие настройки
        * `/etc/nginx/sites-enabled` — настройки виртуальных хостов
        * `/var/www/html` — статические файлы

        Директивы WAF‑ноды описываются в файле контейнера `/etc/nginx/sites-enabled/default`.
    
    * `-p`: порт, через который WAF-нода принимает запросы. Значение должно совпадать с портом инстанса.
    * `-e`: переменные окружения с настройками WAF-ноды из таблицы ниже. Не рекомендуется передавать значения переменных `DEPLOY_USER` и `DEPLOY_PASSWORD` в явном виде.

        --8<-- "../include/waf/installation/nginx-docker-env-vars-to-mount.md"
7.  [Протестируйте работу WAF-ноды](#тестирование-работы-waf-ноды).

## Тестирование работы WAF-ноды

1. Перейдите в Консоль Alibaba Cloud → список сервисов → **Elastic Compute Service** → **Instances** и скопируйте публичный IP-адрес инстанса из столбца **IP Address**.

    ![!Настройка экземпляра контейнера](../../../images/waf-installation/alibaba-cloud/container-copy-ip.png)

    Если IP-адрес отсутствует, убедитесь, что инстанс находится в статусе **Running**.
1. Отправьте тестовый запрос с атаками [SQLI](../../../attacks-vulns-list.md#sqlинъекция-sql-injection) и [XSS](../../../attacks-vulns-list.md#межсайтовый-скриптинг-англ-cross-site-scripting-xss) на скопированный адрес:

    ```
    curl http://<COPIED_IP>/?id='or+1=1--a-<script>prompt(1)</script>'
    ```

    Если WAF‑нода работает в режиме `block`, запрос будет заблокирован с ответом `403 Forbidden`.
2. Перейдите в Консоль управления Валарм → секция **События** для [EU‑облака](https://my.wallarm.com/search) или для [RU‑облака](https://my.wallarm.ru/search) и убедитесь, что атаки появились в списке.
    ![!Атаки в интерфейсе](../../../images/admin-guides/yandex-cloud/test-attacks.png)

Чтобы посмотреть сообщения об ошибках запуска контейнера, необходимо [подключиться к инстансу одним из способов](https://www.alibabacloud.com/help/doc-detail/71529.htm?spm=a2c63.p38356.b99.143.22388e44kpTM1l) и проверить [логи контейнера](../../../admin-ru/configure-logging.md). Если инстанс недоступен, убедитесь, что в контейнер переданы корректные значения всех обязательных параметров WAF-ноды.
