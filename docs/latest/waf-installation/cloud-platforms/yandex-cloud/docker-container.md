[default-ip-blocking-settings]:     ../../../admin-ru/configure-ip-blocking-nginx-ru.md
[wallarm-acl-directive]:            ../../../admin-ru/configure-parameters-ru.md#wallarm_acl
[allocating-memory-guide]:          ../../../admin-ru/configuration-guides/allocate-resources-for-waf-node.md
[mount-config-instr]:               #деплой-контейнера-с-настройкой-waf-ноды-через-примонтированный-файл

# Деплой Docker‑образа WAF‑ноды в Яндекс.Облако

Данная инструкция содержит краткое руководство по деплою [Docker‑образа WAF‑ноды (NGINX)](https://hub.docker.com/r/wallarm/node) с помощью облачной платформы Яндекс.Облако. Для деплоя Docker-образа используется [сервис Yandex Container Solution](https://cloud.yandex.ru/docs/cos/).

!!! warning "Ограничение инструкции"
    В данной инструкции не описана конфигурация для балансировки нагрузки и автоматического масштабирования WAF‑нод. Чтобы выполнить конфигурацию самостоятельно, рекомендуем ознакомиться с [документацией Яндекс.Облака](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-autoscaled-group).

## Требования

* Доступ к [консоли управления](https://console.cloud.yandex.ru/) Яндекс.Облаком
* Платежный аккаунт на [странице биллинга](https://console.cloud.yandex.ru/billing) в статусе `ACTIVE` или `TRIAL_ACTIVE`
* Созданный каталог. По умолчанию создается каталог `default`, для настройки нового каталога используйте [инструкцию](https://cloud.yandex.ru/docs/resource-manager/operations/folder/create)
* Для деплоя контейнера с настройкой WAF-ноды через переменные окружения: [установленный и настроенный CLI для работы с Яндекс.Облаком](https://cloud.yandex.ru/docs/cli/quickstart)
* Доступ к аккаунту с ролью **Деплой** или **Администратор** и отключенная двухфакторная аутентификация в Консоли управления Валарм для [RU‑облака](https://my.wallarm.ru) или [EU‑облака](https://my.wallarm.com)

## Способы конфигурации Docker-контейнера с WAF-нодой

При деплое необходимо передать в Docker‑контейнер параметры WAF‑ноды одним из способов:

* **Через доступные переменные окружения**. С помощью переменных окружения задаются базовые настройки WAF-ноды. Большинство [доступных директив](../../../admin-ru/configure-parameters-ru.md) не могут быть переданы через переменные.
* **В примонтированном конфигурационном файле**. С помощью конфигурационного файла можно выполнить полную настройку WAF-ноды, используя  любые [доступные директивы](../../../admin-ru/configure-parameters-ru.md). При этом способе конфигурации параметры для подключения к Облаку Валарм передаются в переменных окружения.

## Деплой контейнера с настройкой WAF-ноды через переменные окружения

Для деплоя контейнера с настройками WAF-ноды, переданными только в переменных окружения, вы можете использовать [консоль управления Яндекс.Облаком или CLI](https://cloud.yandex.ru/docs/cos/quickstart). В данной инструкции используется CLI.

1. Запишите данные от аккаунта Валарм в локальные переменные окружения, чтобы передать чувствительные данные в Яндекс.Облако более безопасным образом:

    ```bash
    export DEPLOY_USER='<DEPLOY_USER>'
    export DEPLOY_PASSWORD='<DEPLOY_PASSWORD>'
    ```
    
    * `<DEPLOY_USER>`: email для аккаунта пользователя **Деплой** или **Администратор** в Консоли управления Валарм.
    * `<DEPLOY_PASSWORD>`: пароль для аккаунта пользователя **Деплой** или **Администратор** в Консоли управления Валарм.
2. Создайте инстанс с запущенным Docker-контейнером с помощью команды [`yc compute instance create-with-container`](https://cloud.yandex.ru/docs/cli/cli-ref/managed-services/compute/instance/create-with-container):

    === "Команда для EU-облака Валарм"
        ```bash
        yc compute instance create-with-container \
            --name <INSTANCE_NAME> \
            --zone=<DEPLOYMENT_ZONE> \
            --public-ip \
            --container-image=wallarm/node:2.18.1-2 \
            --container-env=DEPLOY_USER=${DEPLOY_USER},DEPLOY_PASSWORD=${DEPLOY_PASSWORD},NGINX_BACKEND=<HOST_TO_PROTECT_WITH_WAF>
        ```
    === "Команда для RU-облака Валарм"
        ```bash
        yc compute instance create-with-container \
            --name <INSTANCE_NAME> \
            --zone=<DEPLOYMENT_ZONE> \
            --public-ip \
            --container-image=wallarm/node:2.18.1-2 \
            --container-env=DEPLOY_USER=${DEPLOY_USER},DEPLOY_PASSWORD=${DEPLOY_PASSWORD},NGINX_BACKEND=<HOST_TO_PROTECT_WITH_WAF>,WALLARM_API_HOST=api.wallarm.ru
        ```

    * `--name`: название инстанса, например: `wallarm-waf`.
    * `--zone`: [зона](https://cloud.yandex.ru/docs/overview/concepts/geo-scope), в которой будет запущен инстанс.
    * `--public-ip`: флаг, указывающий, что необходимо создать публичный IP-адрес для инстанса, чтобы он принимал запросы из внешних ресурсов.
    * `--container-image`: ссылка на Docker-образ с WAF-нодой.
    * `--container-env`: переменные окружения с настройками WAF-ноды из таблицы ниже. Не рекомендуется передавать значения переменных `DEPLOY_USER` и `DEPLOY_PASSWORD` в явном виде.

        --8<-- "../include/waf/installation/nginx-docker-all-env-vars.md"
    
    * Описание всех параметров команды `yc compute instance create-with-container` приведено в [документации Яндекс.Облака](https://cloud.yandex.ru/docs/cli/cli-ref/managed-services/compute/instance/create-with-container).
3.  Перейдите в консоль управления Яндекс.Облаком → **Compute Cloud** → **Virtual machines** и убедитесь, что инстанс появился в списке.
4.  [Протестируйте работу WAF-ноды](#тестирование-работы-waf-ноды).

## Деплой контейнера с настройкой WAF-ноды через примонтированный файл

Для деплоя контейнера с настройками WAF-ноды, переданными через переменные окружения и примонтированный конфигурационный файл, необходимо создать инстанс с конфигурационным файлом и запустить Docker-контейнер в этом же инстансе. Для этого вы можете [использовать консоль управления Яндекс.Облаком](https://cloud.yandex.ru/docs/compute/quickstart/) или [CLI](https://cloud.yandex.ru/docs/cli/cli-ref/managed-services/compute/instance/create). В данной инструкции используется консоль управления.

1. Создайте инстанс на основе образа любой операционной системы по [инструкции](https://cloud.yandex.ru/docs/compute/quickstart/quick-create-linux). Пример настроек инстанса:

    ![!Настройка экземпляра контейнера](../../../images/waf-installation/yandex-cloud/create-vm.png)
2. Подключитесь к инстансу по SSH, используя [инструкцию Яндекс.Облака](https://cloud.yandex.ru/docs/compute/operations/vm-connect/ssh#vm-connect).
3. Установите в инстансе пакеты Docker по [инструкции для подходящей ОС](https://docs.docker.com/engine/install/#server).
4. Запишите данные от аккаунта Валарм в локальные переменные окружения инстанса:

    ```bash
    export DEPLOY_USER='<DEPLOY_USER>'
    export DEPLOY_PASSWORD='<DEPLOY_PASSWORD>'
    ```
    
    * `<DEPLOY_USER>`: email для аккаунта пользователя **Деплой** или **Администратор** в Консоли управления Валарм.
    * `<DEPLOY_PASSWORD>`: пароль для аккаунта пользователя **Деплой** или **Администратор** в Консоли управления Валарм.
5. Создайте в инстансе директорию с конфигурационным файлом `default` с настройками WAF-ноды (например, директорию `configs`). Пример файла с минимальными настройками:

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

    === "Команда для EU‑облака Валарм"
        ```bash
        docker run -d -e DEPLOY_USER=${DEPLOY_USER} -e DEPLOY_PASSWORD=${DEPLOY_PASSWORD} -v <INSTANCE_PATH_TO_CONFIG>:<CONTAINER_PATH_FOR_MOUNTING> -p 80:80 wallarm/node:2.18.1-2
        ```
    === "Команда для RU‑облака Валарм"
        ```bash
        docker run -d -e DEPLOY_USER=${DEPLOY_USER} -e DEPLOY_PASSWORD=${DEPLOY_PASSWORD} -e WALLARM_API_HOST='api.wallarm.ru' -v <INSTANCE_PATH_TO_CONFIG>:<DIRECTORY_FOR_MOUNTING> -p 80:80 wallarm/node:2.18.1-2
        ```

    * `<INSTANCE_PATH_TO_CONFIG>`: путь до конфигурационного файла, созданного на предыдущем шаге. Например: `configs`.
    * `<DIRECTORY_FOR_MOUNTING>`: директория контейнера, в которую монтируется конфигурационный файл. Конфигурационный файл может быть примонтирован в директории контейнера, которые использует NGINX:

        * `/etc/nginx/conf.d` — общие настройки
        * `/etc/nginx/sites-enabled` — настройки виртуальных хостов
        * `/var/www/html` — статические файлы

        Директивы WAF‑ноды описываются в файле контейнера `/etc/nginx/sites-enabled/default`.
    
    * `-p`: порт, через который WAF-нода принимает запросы. Значение должно совпадать с портом инстанса.
    * `-e`: переменные окружения из таблицы ниже.

        --8<-- "../include/waf/installation/nginx-docker-env-vars-to-mount.md"
7.  [Протестируйте работу WAF-ноды](#тестирование-работы-waf-ноды).

## Тестирование работы WAF-ноды

1. Перейдите в консоль управления Яндекс.Облаком → **Compute Cloud** → **Virtual machines** и скопируйте IP-адрес инстанса из столбца **Public IPv4**.

    ![!Настройка экземпляра контейнера](../../../images/waf-installation/yandex-cloud/container-copy-ip.png)

    Если IP-адрес отсутствует, убедитесь, что инстанс находится в статусе **Running**.
2. Отправьте тестовый запрос с атаками [SQLI](../../../attacks-vulns-list.md#sqlинъекция-sql-injection) и [XSS](../../../attacks-vulns-list.md#межсайтовый-скриптинг-англ-cross-site-scripting-xss) на скопированный адрес:

    ```
    curl http://<COPIED_IP>/?id='or+1=1--a-<script>prompt(1)</script>'
    ```

    Если WAF‑нода работает в режиме `block`, запрос будет заблокирован с ответом `403 Forbidden`.
3. Перейдите в Консоль управления Валарм → секция **События** для [EU‑облака](https://my.wallarm.com/search) или для [RU‑облака](https://my.wallarm.ru/search) и убедитесь, что атаки появились в списке.
    ![!Атаки в интерфейсе](../../../images/admin-guides/yandex-cloud/test-attacks.png)

Чтобы посмотреть сообщения об ошибках запуска контейнера, необходимо [подключиться к инстансу по SSH](https://cloud.yandex.ru/docs/compute/operations/vm-connect/ssh) и проверить [логи контейнера](../../../admin-ru/configure-logging.md). Если инстанс недоступен, убедитесь, что в контейнер переданы корректные значения всех обязательных параметров WAF-ноды.
