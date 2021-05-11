[default-ip-blocking-settings]:     ../../../admin-ru/configure-ip-blocking-nginx-ru.md
[wallarm-acl-directive]:            ../../../admin-ru/configure-parameters-ru.md#wallarm_acl
[allocating-memory-guide]:          ../../../admin-ru/configuration-guides/allocate-resources-for-waf-node.md
[mount-config-instr]:               #деплой-контейнера-с-примонтированным-конфигурационным-файлом

# Деплой Docker‑образа WAF‑ноды в Azure

Данная инструкция содержит краткое руководство по деплою [Docker‑образа WAF‑ноды (NGINX)](https://hub.docker.com/r/wallarm/node) с помощью облачной платформы Microsoft Azure.

!!! warning "Ограничение инструкции"
    В данной инструкции не описана конфигурация для балансировки нагрузки и автоматического масштабирования WAF‑нод. Соответствующие шаги будут добавлены в инструкцию позже. Чтобы выполнить конфигурацию самостоятельно, рекомендуем ознакомиться с документацией на [шлюз приложений Azure](https://docs.microsoft.com/ru-ru/azure/application-gateway/overview).

## Требования

* Действующая подписка Azure
* Для запуска Docker‑контейнера с примонтированным конфигурационным файлом: [установленный Azure CLI](https://docs.microsoft.com/ru-ru/cli/azure/install-azure-cli) версии не ниже 2.0.55
* Доступ к аккаунту с ролью **Администратор** и отключенная двухфакторная аутентификация в Консоли управления Валарм для [RU‑облака](https://my.wallarm.ru) или [EU‑облака](https://my.wallarm.com)

## Способы деплоя

При деплое необходимо передать в Docker‑контейнер параметры WAF‑ноды одним из способов:

* **Через доступные переменные окружения**. В контейнер передаются базовые настройки WAF‑ноды, большинство [доступных директив](../../../admin-ru/configure-parameters-ru.md) не могут быть переданы через переменные окружения.

    Деплой контейнера выполняется с помощью [портала Azure](https://portal.azure.com/).
* **В примонтированном конфигурационном файле**. В контейнер могут быть переданы все [доступные директивы](../../../admin-ru/configure-parameters-ru.md) WAF‑ноды.

    Деплой контейнера выполняется с помощью [Azure CLI](https://docs.microsoft.com/ru-ru/cli/azure/install-azure-cli).

## Деплой контейнера с переменными окружения

Деплой контейнера с настройками, переданными через переменные окружения, выполняется с помощью [портала Azure](https://portal.azure.com/).

### 1. Настройте службу Azure "Экземпляры контейнеров"

1. Войдите на [портал Azure](https://portal.azure.com/) и нажмите **Создать ресурс**.
2. Найдите службу **Экземпляры контейнеров** на Azure Marketplace и нажмите **Создать**.

    ![!Экземпляры контейнеров на Azure Marketplace](../../../images/waf-installation/azure/marketplace-container-instances.png)

### 2. Задайте основные настройки и настройки сети для экземпляра контейнера

На вкладке **Основные сведения** в настройках экземпляра контейнера заполните поля:

* **Группа ресурсов**: создайте новую или выберите существующую [группу ресурсов](https://docs.microsoft.com/ru-ru/azure/azure-resource-manager/management/manage-resource-groups-portal#what-is-a-resource-group)
* **Имя контейнера**: например, `wallarm-waf`
* **Регион**: выберите [регион](https://azure.microsoft.com/ru-ru/global-infrastructure/geographies/), в котором необходимо развернуть экземпляр контейнера
* **Источник образа**: Docker Hub или другой реестр
* **Тип образа**: общедоступный
* **Образ**: `wallarm/node:2.16.0-9`
* **Тип ОС**: Linux
* Остальные настройки на вкладке **Основные сведения** по умолчанию

На вкладке **Сеть** в настройках экземпляра контейнера заполните поля:

* **Метка DNS-имени**: например, `wallarm-waf`
* **Порты**, на которых будет доступна WAF-нода: например, `80 TCP`
* Остальные настройки на вкладке **Сеть** по умолчанию

![!Настройка экземпляра контейнера](../../../images/waf-installation/azure/container-instances-basics-networking.png)

### 3. Настройте дополнительные свойства контейнера и запустите его

На вкладке **Дополнительно** в настройках экземпляра контейнера добавьте переменные окружения, которые необходимо передать в Docker-контейнер с WAF-нодой. Набор доступных переменных окружения:

--8<-- "../include/waf/installation/nginx-docker-all-env-vars.md"

На вкладке **Теги** сохраните настройки по умолчанию.

На вкладке **Просмотр и создание** проверьте корректность настроек и нажмите **Создать**.

![!Настройка экземпляра контейнера](../../../images/waf-installation/azure/container-instances-advanced-review.png)

## Деплой контейнера с примонтированным конфигурационным файлом

Деплой контейнера с настройками, переданными через переменные окружения и примонтированный конфигурационный файл, выполняется с помощью [Azure CLI](https://docs.microsoft.com/ru-ru/cli/azure/install-azure-cli).

!!! info "Пути для монтирования конфигурационного файла"
    Конфигурационный файл может быть примонтирован в директории контейнера, которые использует NGINX:

    * `/etc/nginx/conf.d` — общие настройки
    * `/etc/nginx/sites-enabled` — настройки виртуальных хостов
    * `/var/www/html` — статические файлы

    Директивы WAF‑ноды необходимо описать в файле контейнера `/etc/nginx/sites-enabled/default`.

Чтобы запустить контейнер с переменными окружения и примонтированным конфигурационным файлом:

1. Выполните вход в Azure CLI с помощью команды [`az login`](https://docs.microsoft.com/ru-ru/cli/azure/reference-index?view=azure-cli-latest#az_login).
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
            --image registry-1.docker.io/wallarm/node:2.16.0-9 \
            --environment-variables DEPLOY_USER='deploy@example.com' DEPLOY_PASSWORD='very_secret' \
            --dns-name-label wallarm-waf \
            --ports 80 \
            --gitrepo-url <URL_OF_GITREPO> \
            --gitrepo-mount-path /etc/nginx/sites-enabled
         ```
    === "Команда для RU-облака Валарм"
         ```bash
         az container create \
            --resource-group myResourceGroup \
            --name waf-node \
            --image registry-1.docker.io/wallarm/node:2.16.0-9 \
            --environment-variables DEPLOY_USER='deploy@example.com' DEPLOY_PASSWORD='very_secret' WALLARM_API_HOST='api.wallarm.ru' \
            --dns-name-label wallarm-waf \
            --ports 80 \
            --gitrepo-url <URL_OF_GITREPO> \
            --gitrepo-mount-path /etc/nginx/sites-enabled
         ```
        
    
    В параметре `--environment-variables` могут быть переданы следующие переменные окружения:

    --8<-- "../include/waf/installation/nginx-docker-env-vars-to-mount.md"
6. Перейдите на [портал Azure](https://portal.azure.com/) и убедитесь, что созданный ресурс отображается в списке ресурсов.

## Тестирование работы WAF-ноды

1. На портале AWS перейдите к ресурсу с запущенной WAF-нодой и скопируйте **Полное доменной имя**.

    ![!Настройка экземпляра контейнера](../../../images/waf-installation/azure/container-copy-domain-name.png)

    Если доменное имя отсутствует, убедитесь, что контейнер находится в статусе **Выполняется**.
2. Отправьте тестовый запрос с атаками [SQLI](../../../attacks-vulns-list.md#sqlинъекция-sql-injection) и [XSS](../../../attacks-vulns-list.md#межсайтовый-скриптинг-англ-cross-site-scripting-xss) на скопированный адрес:

    ```
    curl http://<COPIED_DOMAIN>/?id='or+1=1--a-<script>prompt(1)</script>'
    ```

    Если WAF‑нода работает в режиме `block`, запрос будет заблокирован с ответом `403 Forbidden`.
3. Перейдите в Консоль управления Валарм → секция **События** для [EU‑облака](https://my.wallarm.com/search) или для [RU‑облака](https://my.wallarm.ru/search) и убедитесь, что атаки появились в списке.
    ![!Атаки в интерфейсе](../../../images/admin-guides/yandex-cloud/test-attacks.png)
