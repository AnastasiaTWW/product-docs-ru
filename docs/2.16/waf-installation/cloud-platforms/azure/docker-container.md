[default-ip-blocking-settings]:     ../../../admin-ru/configure-ip-blocking-nginx-ru.md
[wallarm-acl-directive]:            ../../../admin-ru/configure-parameters-ru.md#wallarm_acl
[allocating-memory-guide]:          ../../../admin-ru/configuration-guides/allocate-resources-for-waf-node.md
[mount-config-instr]:               #деплой-контейнера-с-настройкой-waf-ноды-через-примонтированный-файл

# Деплой Docker‑образа WAF‑ноды в Azure

Данная инструкция содержит краткое руководство по деплою [Docker‑образа WAF‑ноды (NGINX)](https://hub.docker.com/r/wallarm/node) с помощью облачной платформы Microsoft Azure. Для деплоя Docker-образа используется [служба Azure **Экземпляры контейнеров**](https://docs.microsoft.com/ru-ru/azure/container-instances/).

!!! warning "Ограничение инструкции"
    В данной инструкции не описана конфигурация для балансировки нагрузки и автоматического масштабирования WAF‑нод. Чтобы выполнить конфигурацию самостоятельно, рекомендуем ознакомиться с документацией на [шлюз приложений Azure](https://docs.microsoft.com/ru-ru/azure/application-gateway/overview).

## Требования

* Действующая подписка Azure
* [Установленный Azure CLI](https://docs.microsoft.com/ru-ru/cli/azure/install-azure-cli)
* Доступ к аккаунту с ролью **Деплой** или **Администратор** и отключенная двухфакторная аутентификация в Консоли управления Валарм для [RU‑облака](https://my.wallarm.ru) или [EU‑облака](https://my.wallarm.com)

## Способы конфигурации Docker-контейнера с WAF-нодой

При деплое необходимо передать в Docker‑контейнер параметры WAF‑ноды одним из способов:

* **Через доступные переменные окружения**. С помощью переменных окружения задаются базовые настройки WAF-ноды. Большинство [доступных директив](../../../admin-ru/configure-parameters-ru.md) не могут быть переданы через переменные.
* **В примонтированном конфигурационном файле**. С помощью конфигурационного файла можно выполнить полную настройку WAF-ноды, используя  любые [доступные директивы](../../../admin-ru/configure-parameters-ru.md). При этом способе конфигурации параметры для подключения к Облаку Валарм передаются в переменных окружения.

## Деплой контейнера с настройкой WAF-ноды через переменные окружения

Для деплоя контейнера с настройками WAF-ноды, переданными только в переменных окружения, вы можете использовать следующие инструменты:

* [Azure CLI](https://docs.microsoft.com/ru-ru/azure/container-instances/container-instances-quickstart) (используется в данной инструкции)
* [Портал Azure](https://docs.microsoft.com/ru-ru/azure/container-instances/container-instances-quickstart-portal)
* [Azure PowerShell](https://docs.microsoft.com/ru-ru/azure/container-instances/container-instances-quickstart-powershell)
* [Шаблон ARM](https://docs.microsoft.com/ru-ru/azure/container-instances/container-instances-quickstart-template)
* [Docker CLI](https://docs.microsoft.com/ru-ru/azure/container-instances/quickstart-docker-cli)

Для деплоя контейнера с помощью Azure CLI:

1. Выполните вход в Azure CLI с помощью команды [`az login`](https://docs.microsoft.com/ru-ru/cli/azure/reference-index?view=azure-cli-latest#az_login):

    ```bash
    az login
    ```
2. Создайте группу ресурсов с помощью команды [`az group create`](https://docs.microsoft.com/ru-ru/cli/azure/group?view=azure-cli-latest#az_group_create). Например, группа `myResourceGroup` в Восточном регионе США:

    ```bash
    az group create --name myResourceGroup --location eastus
    ```
3. Создайте ресурс Azure из Docker-контейнера с WAF-нодой с помощью команды [`az container create`](https://docs.microsoft.com/ru-ru/cli/azure/container?view=azure-cli-latest#az_container_create):

    === "Команда для EU-облака Валарм"
         ```bash
         az container create \
            --resource-group myResourceGroup \
            --name waf-node \
            --dns-name-label wallarm-waf \
            --ports 80 \
            --image registry-1.docker.io/wallarm/node:2.16.0-9 \
            --environment-variables DEPLOY_USER='deploy@example.com' DEPLOY_PASSWORD='very_secret' NGINX_BACKEND='example.com'
         ```
    === "Команда для RU-облака Валарм"
         ```bash
         az container create \
            --resource-group myResourceGroup \
            --name waf-node \
            --dns-name-label wallarm-waf \
            --ports 80 \
            --image registry-1.docker.io/wallarm/node:2.16.0-9 \
            --environment-variables DEPLOY_USER='deploy@example.com' DEPLOY_PASSWORD='very_secret' NGINX_BACKEND='example.com' WALLARM_API_HOST='api.wallarm.ru'
         ```
        
    * `--resource-group`: название группы ресурсов, созданной на шаге 2
    * `--name`: название контейнера
    * `--dns-name-label`: метка DNS-имени для контейнера
    * `--ports`: порт, на котором будет доступен контейнер
    * `--image`: название Docker-образа с WAF-нодой
    * `--environment-variables`: переменные окружения с настройками WAF-ноды из списка ниже

    --8<-- "../include/waf/installation/nginx-docker-all-env-vars.md"
4. Перейдите на [портал Azure](https://portal.azure.com/) и убедитесь, что созданный ресурс отображается в списке ресурсов.

## Деплой контейнера с настройкой WAF-ноды через примонтированный файл

Для деплоя контейнера с настройками WAF-ноды, переданными через переменные окружения и примонтированный конфигурационный файл, может использоваться только [Azure CLI](https://docs.microsoft.com/ru-ru/cli/azure/install-azure-cli).

Чтобы запустить контейнер с переменными окружения и примонтированным конфигурационным файлом:

1. Выполните вход в Azure CLI с помощью команды [`az login`](https://docs.microsoft.com/ru-ru/cli/azure/reference-index?view=azure-cli-latest#az_login):

    ```bash
    az login
    ```
2. Создайте группу ресурсов с помощью команды [`az group create`](https://docs.microsoft.com/ru-ru/cli/azure/group?view=azure-cli-latest#az_group_create). Например, группа `myResourceGroup` в Восточном регионе США:

    ```bash
    az group create --name myResourceGroup --location eastus
    ```
3. Создайте локально конфигурационный файл с настройками WAF-ноды. Пример файла с минимальными настройками:

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
4. Расположите конфигурационный файл одним из способов, который подходит для подключения томов данных в Azure. Все способы описаны в разделе [**Подключение томов данных** в документации Azure](https://docs.microsoft.com/ru-ru/azure/container-instances/container-instances-volume-azure-files).

    В данной инструкции конфигурационный файл монтируется из репозитория Git.
5. Создайте ресурс Azure из Docker-контейнера с WAF-нодой с помощью команды [`az container create`](https://docs.microsoft.com/ru-ru/cli/azure/container?view=azure-cli-latest#az_container_create). Например:


    === "Команда для EU-облака Валарм"
         ```bash
         az container create \
            --resource-group myResourceGroup \
            --name waf-node \
            --dns-name-label wallarm-waf \
            --ports 80 \
            --image registry-1.docker.io/wallarm/node:2.16.0-9 \
            --gitrepo-url <URL_OF_GITREPO> \
            --gitrepo-mount-path /etc/nginx/sites-enabled \
            --environment-variables DEPLOY_USER='deploy@example.com' DEPLOY_PASSWORD='very_secret'
         ```
    === "Команда для RU-облака Валарм"
         ```bash
         az container create \
            --resource-group myResourceGroup \
            --name waf-node \
            --dns-name-label wallarm-waf \
            --ports 80 \
            --image registry-1.docker.io/wallarm/node:2.16.0-9 \
            --gitrepo-url <URL_OF_GITREPO> \
            --gitrepo-mount-path /etc/nginx/sites-enabled \
            --environment-variables DEPLOY_USER='deploy@example.com' DEPLOY_PASSWORD='very_secret' WALLARM_API_HOST='api.wallarm.ru'
         ```

    * `--resource-group`: название группы ресурсов, созданной на шаге 2
    * `--name`: название контейнера
    * `--dns-name-label`: метка DNS-имени для контейнера
    * `--ports`: порт, на котором будет доступен контейнер
    * `--image`: название Docker-образа с WAF-нодой
    * `--gitrepo-url`: URL репозитория Git, в котором хранится конфигурационный файл. Если файл хранится в корне репозитория, достаточно передать только этот параметр. Если файл хранится в директории репозитория, необходимо дополнительно передать параметр `--gitrepo-dir` с путем до директории, например: `--gitrepo-dir ./dir1`.
    * `--gitrepo-mount-path`: директория контейнера, в которую монтируется конфигурационный файл. Конфигурационный файл может быть примонтирован в директории контейнера, которые использует NGINX:

        * `/etc/nginx/conf.d` — общие настройки
        * `/etc/nginx/sites-enabled` — настройки виртуальных хостов
        * `/var/www/html` — статические файлы

        Директивы WAF‑ноды необходимо описать в файле контейнера `/etc/nginx/sites-enabled/default`.
    
    * `--environment-variables`: переменные окружения с параметрами для подключения к Облаку Валарм из списка ниже

    --8<-- "../include/waf/installation/nginx-docker-env-vars-to-mount.md"
6. Перейдите на [портал Azure](https://portal.azure.com/) и убедитесь, что созданный ресурс отображается в списке ресурсов.

## Тестирование работы WAF-ноды

1. На портале Azure перейдите к ресурсу с запущенной WAF-нодой и скопируйте **Полное доменной имя**.

    ![!Настройка экземпляра контейнера](../../../images/waf-installation/azure/container-copy-domain-name.png)

    Если доменное имя отсутствует, убедитесь, что контейнер находится в статусе **Выполняется**.
2. Отправьте тестовый запрос с атаками [SQLI](../../../attacks-vulns-list.md#sqlинъекция-sql-injection) и [XSS](../../../attacks-vulns-list.md#межсайтовый-скриптинг-англ-cross-site-scripting-xss) на скопированный адрес:

    ```
    curl http://<COPIED_DOMAIN>/?id='or+1=1--a-<script>prompt(1)</script>'
    ```

    Если WAF‑нода работает в режиме `block`, запрос будет заблокирован с ответом `403 Forbidden`.
3. Перейдите в Консоль управления Валарм → секция **События** для [EU‑облака](https://my.wallarm.com/search) или для [RU‑облака](https://my.wallarm.ru/search) и убедитесь, что атаки появились в списке.
    ![!Атаки в интерфейсе](../../../images/admin-guides/yandex-cloud/test-attacks.png)

Сообщения об ошибках запуска контейнера отображаются в информации о ресурсе на вкладке **Контейнеры** → **Журналы** на портале Azure. Если ресурс недоступен, убедитесь, что в контейнер переданы корректные значения всех обязательных параметров WAF-ноды.
