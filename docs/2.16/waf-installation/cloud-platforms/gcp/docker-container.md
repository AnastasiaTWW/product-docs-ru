[default-ip-blocking-settings]:     ../../../admin-ru/configure-ip-blocking-nginx-ru.md
[wallarm-acl-directive]:            ../../../admin-ru/configure-parameters-ru.md#wallarm_acl
[allocating-memory-guide]:          ../../../admin-ru/configuration-guides/allocate-resources-for-waf-node.md
[mount-config-instr]:               #деплой-контейнера-с-настройкой-waf-ноды-через-примонтированный-файл

# Деплой Docker‑образа WAF‑ноды в GCP

Данная инструкция содержит краткое руководство по деплою [Docker‑образа WAF‑ноды (NGINX)](https://hub.docker.com/r/wallarm/node) с помощью облачной платформы Google Cloud Platform. Для деплоя Docker-образа используется [компонент Google Compute Engine (GCE)](https://cloud.google.com/compute).

!!! warning "Ограничение инструкции"
    В данной инструкции не описана конфигурация для балансировки нагрузки и автоматического масштабирования WAF‑нод. Чтобы выполнить конфигурацию самостоятельно, рекомендуем ознакомиться с [документацией GCP](https://cloud.google.com/compute/docs/load-balancing-and-autoscaling).

## Требования

* Активный платежный аккаунт GCP
* [Созданный проект GCP](https://cloud.google.com/resource-manager/docs/creating-managing-projects)
* Включенный [Compute Engine API](https://console.cloud.google.com/apis/library/compute.googleapis.com?q=compute%20eng&id=a08439d8-80d6-43f1-af2e-6878251f018d)
* [Установленный и настроенный](https://cloud.google.com/sdk/docs/quickstart) Google Cloud SDK (gcloud CLI)
* Доступ к аккаунту с ролью **Деплой** или **Администратор** и отключенная двухфакторная аутентификация в Консоли управления Валарм для [RU‑облака](https://my.wallarm.ru) или [EU‑облака](https://my.wallarm.com)

## Способы конфигурации Docker-контейнера с WAF-нодой

При деплое необходимо передать в Docker‑контейнер параметры WAF‑ноды одним из способов:

* **Через доступные переменные окружения**. С помощью переменных окружения задаются базовые настройки WAF-ноды. Большинство [доступных директив](../../../admin-ru/configure-parameters-ru.md) не могут быть переданы через переменные.
* **В примонтированном конфигурационном файле**. С помощью конфигурационного файла можно выполнить полную настройку WAF-ноды, используя  любые [доступные директивы](../../../admin-ru/configure-parameters-ru.md). При этом способе конфигурации параметры для подключения к Облаку Валарм передаются в переменных окружения.

## Деплой контейнера с настройкой WAF-ноды через переменные окружения

Для деплоя контейнера с настройками WAF-ноды, переданными только в переменных окружения, вы можете использовать [Консоль GCP или gcloud CLI](https://cloud.google.com/compute/docs/containers/deploying-containers). В данной инструкции используется gcloud CLI.

1. Запишите данные от аккаунта Валарм в локальные переменные окружения, чтобы передать чувствительные данные в GCP более безопасным образом:

    ```bash
    export DEPLOY_USER='<DEPLOY_USER>'
    export DEPLOY_PASSWORD='<DEPLOY_PASSWORD>'
    ```
    
    * `<DEPLOY_USER>`: email для аккаунта пользователя **Деплой** или **Администратор** в Консоли управления Валарм.
    * `<DEPLOY_PASSWORD>`: пароль для аккаунта пользователя **Деплой** или **Администратор** в Консоли управления Валарм.
2. Создайте инстанс с запущенным Docker-контейнером с помощью команды [`gcloud compute instances create-with-container`](https://cloud.google.com/sdk/gcloud/reference/compute/instances/create-with-container):

    === "Команда для EU-облака Валарм"
        ```bash
        gcloud compute instances create-with-container <INSTANCE_NAME> \
            --zone <DEPLOYMENT_ZONE> \
            --tags http-server \
            --container-env DEPLOY_USER=${DEPLOY_USER} \
            --container-env DEPLOY_PASSWORD=${DEPLOY_PASSWORD} \
            --container-env NGINX_BACKEND=<HOST_TO_PROTECT_WITH_WAF>
            --container-image registry-1.docker.io/wallarm/node:2.16.0-9
        ```
    === "Команда для RU-облака Валарм"
        ```bash
        gcloud compute instances create-with-container <INSTANCE_NAME> \
            --zone <DEPLOYMENT_ZONE> \
            --tags http-server \
            --container-env DEPLOY_USER=${DEPLOY_USER} \
            --container-env DEPLOY_PASSWORD=${DEPLOY_PASSWORD} \
            --container-env NGINX_BACKEND=<HOST_TO_PROTECT_WITH_WAF> \
            --container-env WALLARM_API_HOST=api.wallarm.ru \
            --container-image registry-1.docker.io/wallarm/node:2.16.0-9
        ```

    * `<INSTANCE_NAME>`: название инстанса, например: `wallarm-waf`.
    * `--zone`: [зона](https://cloud.google.com/compute/docs/regions-zones), в которой будет запущен инстанс.
    * `--tags`: теги для инстанса. Через теги настраивается доступность инстанса из других ресурсов. В данном случае передается значение `http-server`, чтобы порт инстанса 80 принимал входящие запросы.
    * `--container-image`: ссылка на Docker-образ с WAF-нодой.
    * `--container-env`: переменные окружения с настройками WAF-ноды из таблицы ниже. Не рекомендуется передавать значения переменных `DEPLOY_USER` и `DEPLOY_PASSWORD` в явном виде.

        --8<-- "../include/waf/installation/nginx-docker-all-env-vars.md"
    
    * Описание всех параметров команды `gcloud compute instances create-with-container` приведено в [документации GCP](https://cloud.google.com/sdk/gcloud/reference/compute/instances/create-with-container).
3.  Перейдите в [Консоль GCP → **Compute Engine** → VM instances](https://console.cloud.google.com/compute/instances) и убедитесь, что инстанс появился в списке.
4.  [Протестируйте работу WAF-ноды](#тестирование-работы-waf-ноды).

## Деплой контейнера с настройкой WAF-ноды через примонтированный файл

Для деплоя контейнера с настройками WAF-ноды, переданными через переменные окружения и примонтированный конфигурационный файл, необходимо создать инстанс с конфигурационным файлом и запустить Docker-контейнер в этом же инстансе. Для этого вы можете использовать [Консоль GCP или gcloud CLI](https://cloud.google.com/compute/docs/containers/deploying-containers). В данной инструкции используется gcloud CLI.

1. Создайте инстанс из любого образа операционной системы, доступного в реестре Compute Engine, с помощью команды [`gcloud compute instances create`](https://cloud.google.com/sdk/gcloud/reference/compute/instances/create):

    ```bash
    gcloud compute instances create <INSTANCE_NAME> \
        --image <PUBLIC_IMAGE_NAME> \
        --zone <DEPLOYMENT_ZONE> \
        --tags http-server
    ```

    * `<INSTANCE_NAME>`: название инстанса.
    * `--image`: название образа операционной системы из реестра Compute Engine. Инстанс будет создан из указанного образа, и Docker-контейнер будет запущен в созданном инстансе. Если параметр опущен, инстанс будет создан на основе образа Debian 10.
    * `--zone`: [зона](https://cloud.google.com/compute/docs/regions-zones), в которой будет запущен инстанс.
    * `--tags`: теги для инстанса. Через теги настраивается доступность инстанса из других ресурсов. В данном случае передается значение `http-server`, чтобы порт инстанса 80 принимал входящие запросы.
    * Описание всех параметров команды `gcloud compute instances create` приведено в [документации GCP](https://cloud.google.com/sdk/gcloud/reference/compute/instances/create).
2. Перейдите в [Консоль GCP → **Compute Engine** → VM instances](https://console.cloud.google.com/compute/instances) и убедитесь, что инстанс появился в списке и находится в статусе **RUNNING**.
3. Подключитесь к инстансу по SSH, используя [инструкцию GCP](https://cloud.google.com/compute/docs/instances/ssh).
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
7. Запустите Docker-контейнер с WAF-нодой с примонтированным конфигурационным файлом и переменными окружения.

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
    * `-e`: переменные окружения из таблицы ниже.

        --8<-- "../include/waf/installation/nginx-docker-env-vars-to-mount.md"
8.  [Протестируйте работу WAF-ноды](#тестирование-работы-waf-ноды).

## Тестирование работы WAF-ноды

1. Перейдите в [Консоль GCP → **Compute Engine** → VM instances](https://console.cloud.google.com/compute/instances) и скопируйте IP-адрес инстанса из столбца **External IP**.

    ![!Настройка экземпляра контейнера](../../../images/waf-installation/gcp/container-copy-ip.png)

    Если IP-адрес отсутствует, убедитесь, что инстанс находится в статусе **RUNNING**.
2. Отправьте тестовый запрос с атаками [SQLI](../../../attacks-vulns-list.md#sqlинъекция-sql-injection) и [XSS](../../../attacks-vulns-list.md#межсайтовый-скриптинг-англ-cross-site-scripting-xss) на скопированный адрес:

    ```
    curl http://<COPIED_IP>/?id='or+1=1--a-<script>prompt(1)</script>'
    ```

    Если WAF‑нода работает в режиме `block`, запрос будет заблокирован с ответом `403 Forbidden`.
3. Перейдите в Консоль управления Валарм → секция **События** для [EU‑облака](https://my.wallarm.com/search) или для [RU‑облака](https://my.wallarm.ru/search) и убедитесь, что атаки появились в списке.
    ![!Атаки в интерфейсе](../../../images/admin-guides/yandex-cloud/test-attacks.png)

Чтобы посмотреть сообщения об ошибках запуска контейнера, в меню инстанса необходимо выбрать **View logs**. Если инстанс недоступен, убедитесь, что в контейнер переданы корректные значения всех обязательных параметров WAF-ноды.
