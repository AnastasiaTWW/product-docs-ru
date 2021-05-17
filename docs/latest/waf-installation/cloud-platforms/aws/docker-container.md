[default-ip-blocking-settings]:     ../../../admin-ru/configure-ip-blocking-nginx-ru.md
[wallarm-acl-directive]:            ../../../admin-ru/configure-parameters-ru.md#wallarm_acl
[allocating-memory-guide]:          ../../../admin-ru/configuration-guides/allocate-resources-for-waf-node.md
[mount-config-instr]:               #деплой-контейнера-с-настройкой-waf-ноды-через-примонтированный-файл

# Деплой Docker‑образа WAF‑ноды в AWS

Данная инструкция содержит краткое руководство по деплою [Docker‑образа WAF‑ноды (NGINX)](https://hub.docker.com/r/wallarm/node) с помощью облачной платформы AWS. Для деплоя Docker-образа используется [сервис Amazon Elastic Container Service (Amazon ECS)](https://aws.amazon.com/ru/getting-started/hands-on/deploy-docker-containers/).

!!! warning "Ограничение инструкции"
    В данной инструкции не описана конфигурация для балансировки нагрузки и автоматического масштабирования WAF‑нод. Чтобы выполнить конфигурацию самостоятельно, рекомендуем ознакомиться с соответствующими шагами в [инструкции AWS](https://aws.amazon.com/ru/getting-started/hands-on/deploy-docker-containers/).

## Требования

* Аккаунт AWS и данные пользователя с ролью **admin**
* [Установленный](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) и [настроенный](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) AWS CLI (вы можете использовать любую версию AWS CLI: 1 или 2)
* Доступ к аккаунту с ролью **Деплой** или **Администратор** и отключенная двухфакторная аутентификация в Консоли управления Валарм для [RU‑облака](https://my.wallarm.ru) или [EU‑облака](https://my.wallarm.com)

## Способы конфигурации Docker-контейнера с WAF-нодой

При деплое необходимо передать в Docker‑контейнер параметры WAF‑ноды одним из способов:

* **Через доступные переменные окружения**. С помощью переменных окружения задаются базовые настройки WAF-ноды. Большинство [доступных директив](../../../admin-ru/configure-parameters-ru.md) не могут быть переданы через переменные.
* **В примонтированном конфигурационном файле**. С помощью конфигурационного файла можно выполнить полную настройку WAF-ноды, используя  любые [доступные директивы](../../../admin-ru/configure-parameters-ru.md). При этом способе конфигурации параметры для подключения к Облаку Валарм передаются в переменных окружения.

## Деплой контейнера с настройкой WAF-ноды через переменные окружения

Для деплоя контейнера с настройками WAF-ноды, переданными только в переменных окружения, используется Консоль AWS и AWS CLI.

1. Войдите в [Консоль AWS](https://console.aws.amazon.com/console/home) и в списке **Services** выберите **Elastic Container Service**.
2. Перейдите к созданию кластера по кнопке **Create Cluster**:
      1. Выберите шаблон **EC2 Linux + Networking**.
      2. Задайте имя кластера, например `waf-cluster`.
      3. Если требуется, задайте другие настройки по [инструкции](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create_cluster.html).
      4. Сохраните кластер.
3. Сохраните чувствительные данные для подключения WAF-ноды к Облаку Валарм в [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/tutorials_basic.html) или [AWS Systems Manager → Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-paramstore-su-create.html). К чувствительным данным относятся следующие переменные окружения:
    * `DEPLOY_USER`: email для аккаунта пользователя **Деплой** или **Администратор** в Консоли управления Валарм.
    * `DEPLOY_PASSWORD`: пароль для аккаунта пользователя **Деплой** или **Администратор** в Консоли управления Валарм.

    !!! warning "Доступ к хранилищу с чувствительными данными"
        Чтобы Docker-контейнер прочитал зашифрованные данные из хранилища, необходимо:
        
        * Убедиться, что данные хранятся в том же регионе, в котором вы запускаете Docker-контейнер.
        * Убедиться, что для роли, заданной в определении задания в параметре `executionRoleArn`, добавлена политика **SecretsManagerReadWrite**. [Подробнее о настройке IAM-политик →](https://docs.aws.amazon.com/secretsmanager/latest/userguide/auth-and-access_identity-based-policies.html)
4. Создайте следующий конфигурационный файл с [определением задания](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html) (в определении задания описывается схема работы Docker-контейнера с WAF-нодой):

    === "Для EU-облака Валарм"
         ```json
         {
             "executionRoleArn": "arn:aws:iam::<AWS_ACCOUNT_ID>:role/ecsTaskExecutionRole",
             "containerDefinitions": [
                 {
                     "memory": 128,
                     "portMappings": [
                    {
                        "hostPort": 80,
                        "containerPort": 80,
                        "protocol": "tcp"
                    }
                ],
                "essential": true,
                "environment": [
                    {
                        "name": "NGINX_BACKEND",
                        "value": "<HOST_TO_PROTECT_WITH_WAF>"
                    }
                ],
                "secrets": [
                    {
                        "name": "DEPLOY_PASSWORD",
                        "valueFrom": "arn:aws:secretsmanager:<AWS_REGION_FOR_DEPLOY>:<AWS_ACCOUNT_ID>:secret:<SECRET_NAME>:<DEPLOY_PASSWORD_PARAMETER_NAME>::"
                    },
                    {
                        "name": "DEPLOY_USER",
                        "valueFrom": "arn:aws:secretsmanager:<AWS_REGION_FOR_DEPLOY>:<AWS_ACCOUNT_ID>:secret:<SECRET_NAME>:<DEPLOY_USER_PARAMETER_NAME>::"
                    }
                ],
                "name": "waf-container",
                "image": "registry-1.docker.io/wallarm/node:2.18.1-1"
                }
            ],
            "family": "wallarm-waf-node"
            }
         ```
    === "Для RU-облака Валарм"
         ```json
         {
             "executionRoleArn": "arn:aws:iam::<AWS_ACCOUNT_ID>:role/ecsTaskExecutionRole",
             "containerDefinitions": [
                 {
                     "memory": 128,
                     "portMappings": [
                    {
                        "hostPort": 80,
                        "containerPort": 80,
                        "protocol": "tcp"
                    }
                ],
                "essential": true,
                "environment": [
                    {
                        "name": "WALLARM_API_HOST",
                        "value": "api.wallarm.ru"
                    },
                    {
                        "name": "NGINX_BACKEND",
                        "value": "<HOST_TO_PROTECT_WITH_WAF>"
                    }
                ],
                "secrets": [
                    {
                        "name": "DEPLOY_PASSWORD",
                        "valueFrom": "arn:aws:secretsmanager:<AWS_REGION_FOR_DEPLOY>:<AWS_ACCOUNT_ID>:secret:<SECRET_NAME>:<DEPLOY_PASSWORD_PARAMETER_NAME>::"
                    },
                    {
                        "name": "DEPLOY_USER",
                        "valueFrom": "arn:aws:secretsmanager:<AWS_REGION_FOR_DEPLOY>:<AWS_ACCOUNT_ID>:secret:<SECRET_NAME>:<DEPLOY_USER_PARAMETER_NAME>::"
                    }
                ],
                "name": "waf-container",
                "image": "registry-1.docker.io/wallarm/node:2.18.1-1"
                }
            ],
            "family": "wallarm-waf-node"
            }
         ```

    * `<AWS_ACCOUNT_ID>`: [ID вашего аккаунта AWS](https://docs.aws.amazon.com/IAM/latest/UserGuide/console_account-alias.html).
    * `<AWS_REGION_FOR_DEPLOY>`: [регион AWS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html).
    * В объекте `environment` передаются переменные окружения для Docker-контейнера в текстовом виде. Набор доступных переменных окружения приведен в таблице ниже. Рекомендуется передавать переменные `DEPLOY_USER` и `DEPLOY_PASSWORD` в объекте `secrets`.
    * В объекте `secrets` передаются переменные окружения для Docker-контейнера в виде ссылки на хранилище с чувствительными данными. Рекомендуется передавать переменные `DEPLOY_USER` и `DEPLOY_PASSWORD` в объекте `secrets`.

    --8<-- "../include/waf/installation/nginx-docker-all-env-vars.md"
    
    * Описание всех параметров конфигурационного файла приведено в [документации AWS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html).
5. Создайте определение задания из конфигурационного файла с помощью команды [`aws ecs register-task-definition`](https://docs.aws.amazon.com/cli/latest/reference/ecs/register-task-definition.html):

    ```bash
    aws ecs register-task-definition --cli-input-json file://<PATH_TO_JSON_FILE>/<JSON_FILE_NAME>
    ```
6. Запустите задание в кластере с помощью команды [`aws ecs run-task`](https://docs.aws.amazon.com/cli/latest/reference/ecs/run-task.htmlhttps://docs.aws.amazon.com/cli/latest/reference/ecs/run-task.html):

    ```bash
    aws ecs run-task --cluster <CLUSTER_NAME> --launch-type EC2 --task-definition <FAMILY_PARAM_VALUE>
    ```
7. Перейдите в Консоль AWS → **Elastic Container Service** → кластер, в котором вы запустили задание  → **Tasks** и убедитесь, что задание появилось в списке.

## Деплой контейнера с настройкой WAF-ноды через примонтированный файл

Для деплоя контейнера с настройками WAF-ноды, переданными через переменные окружения и примонтированный конфигурационный файл, используется Консоль AWS и AWS CLI.

В данной инструкции конфигурационный файл монтируется из файловой системы [AWS EFS](https://docs.aws.amazon.com/efs/latest/ug/whatisefs.html). Вы также можете ознакомиться с другими способами монтирования файла в [документации AWS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_data_volumes.html).

Чтобы запустить контейнер с переменными окружения и конфигурационным файлом, который монтируется из AWS EFS:

1. Войдите в [Консоль AWS](https://console.aws.amazon.com/console/home) и в списке **Services** выберите **Elastic Container Service**.
2. Перейдите к созданию кластера по кнопке **Create Cluster**:
      1. Выберите шаблон **EC2 Linux + Networking**.
      2. Задайте имя кластера, например `waf-cluster`.
      3. Если требуется, задайте другие настройки по [инструкции](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create_cluster.html).
      4. Сохраните кластер.
3. Сохраните чувствительные данные для подключения WAF-ноды к Облаку Валарм в [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/tutorials_basic.html) или [AWS Systems Manager → Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-paramstore-su-create.html). К чувствительным данным относятся следующие переменные окружения:
    * `DEPLOY_USER`: email для аккаунта пользователя **Деплой** или **Администратор** в Консоли управления Валарм.
    * `DEPLOY_PASSWORD`: пароль для аккаунта пользователя **Деплой** или **Администратор** в Консоли управления Валарм.

    !!! warning "Доступ к хранилищу с чувствительными данными"
        Чтобы Docker-контейнер прочитал зашифрованные данные из хранилища, необходимо:
        
        * Убедиться, что данные хранятся в том же регионе, в котором вы запускаете Docker-контейнер.
        * Убедиться, что для роли, заданной в определении задания в параметре `executionRoleArn`, добавлена политика **SecretsManagerReadWrite**. [Подробнее о настройке IAM-политик →](https://docs.aws.amazon.com/secretsmanager/latest/userguide/auth-and-access_identity-based-policies.html)
4. Создайте локально конфигурационный файл с настройками WAF-ноды. Пример файла с минимальными настройками:

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
5. Загрузите конфигурационный файл в хранилище AWS EFS, следуя шагам 1-4 из [инструкции AWS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/tutorial-efs-volumes.html).
6. Создайте следующий конфигурационный файл с [определением задания](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html) (в определении задания описывается схема работы Docker-контейнера с WAF-нодой):

    === "Для EU-облака Валарм"
         ```json
         {
             "executionRoleArn": "arn:aws:iam::<AWS_ACCOUNT_ID>:role/ecsTaskExecutionRole",
             "containerDefinitions": [
                 {
                     "memory": 128,
                     "portMappings": [
                    {
                        "hostPort": 80,
                        "containerPort": 80,
                        "protocol": "tcp"
                    }
                ],
                "essential": true,
                "mountPoints": [
                    {
                        "containerPath": "/etc/nginx/sites-enabled",
                        "sourceVolume": "default"
                    }
                ],
                "secrets": [
                    {
                        "name": "DEPLOY_PASSWORD",
                        "valueFrom": "arn:aws:secretsmanager:<AWS_REGION_FOR_DEPLOY>:<AWS_ACCOUNT_ID>:secret:<SECRET_NAME>:<DEPLOY_PASSWORD_PARAMETER_NAME>::"
                    },
                    {
                        "name": "DEPLOY_USER",
                        "valueFrom": "arn:aws:secretsmanager:<AWS_REGION_FOR_DEPLOY>:<AWS_ACCOUNT_ID>:secret:<SECRET_NAME>:<DEPLOY_USER_PARAMETER_NAME>::"
                    }
                ],
                "name": "waf-container",
                "image": "registry-1.docker.io/wallarm/node:2.18.1-1"
                }
            ],
            "volumes": [
                {
                    "name": "default",
                    "efsVolumeConfiguration": {
                        "fileSystemId": "<EFS_FILE_SYSTEM_ID>",
                        "transitEncryption": "ENABLED"
                    }
                }
            ],
            "family": "wallarm-waf-node"
            }
         ```
    === "Для RU-облака Валарм"
         ```json
         {
             "executionRoleArn": "arn:aws:iam::<AWS_ACCOUNT_ID>:role/ecsTaskExecutionRole",
             "containerDefinitions": [
                 {
                     "memory": 128,
                     "portMappings": [
                    {
                        "hostPort": 80,
                        "containerPort": 80,
                        "protocol": "tcp"
                    }
                ],
                "essential": true,
                "mountPoints": [
                    {
                        "containerPath": "<PATH_FOR_MOUNTED_CONFIG>",
                        "sourceVolume": "<NAME_FROM_VOLUMES_OBJECT>"
                    }
                ],
                "environment": [
                    {
                        "name": "WALLARM_API_HOST",
                        "value": "api.wallarm.ru"
                    }
                ],
                "secrets": [
                    {
                        "name": "DEPLOY_PASSWORD",
                        "valueFrom": "arn:aws:secretsmanager:<AWS_REGION_FOR_DEPLOY>:<AWS_ACCOUNT_ID>:secret:<SECRET_NAME>:<DEPLOY_PASSWORD_PARAMETER_NAME>::"
                    },
                    {
                        "name": "DEPLOY_USER",
                        "valueFrom": "arn:aws:secretsmanager:<AWS_REGION_FOR_DEPLOY>:<AWS_ACCOUNT_ID>:secret:<SECRET_NAME>:<DEPLOY_USER_PARAMETER_NAME>::"
                    }
                ],
                "name": "waf-container",
                "image": "registry-1.docker.io/wallarm/node:2.18.1-1"
                }
            ],
            "volumes": [
                {
                    "name": "<VOLUME_NAME>",
                    "efsVolumeConfiguration": {
                        "fileSystemId": "<EFS_FILE_SYSTEM_ID>",
                        "transitEncryption": "ENABLED"
                    }
                }
            ],
            "family": "wallarm-waf-node"
            }
         ```

    * `<AWS_ACCOUNT_ID>`: [ID вашего аккаунта AWS](https://docs.aws.amazon.com/IAM/latest/UserGuide/console_account-alias.html).
    * `<AWS_REGION_FOR_DEPLOY>`: [регион AWS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html).
    * `<PATH_FOR_MOUNTED_CONFIG>`: директория контейнера, в которую монтируется конфигурационный файл. Конфигурационный файл может быть примонтирован в директории контейнера, которые использует NGINX:

        * `/etc/nginx/conf.d` — общие настройки
        * `/etc/nginx/sites-enabled` — настройки виртуальных хостов
        * `/var/www/html` — статические файлы

        Директивы WAF‑ноды необходимо описать в файле контейнера `/etc/nginx/sites-enabled/default`.
    
    * `<NAME_FROM_VOLUMES_OBJECT>`: название объекта `volumes`, в котором описано хранилище AWS EFS (значение должно быть идентично `<VOLUME_NAME>`).
    * `<VOLUME_NAME>`: название объекта `volumes`, в котором необходимо описать хранилище AWS EFS.
    * `<EFS_FILE_SYSTEM_ID>`: ID файловой системы AWS EFS, в которой хранится конфигурационный файл для монтирования. ID отображается в Консоли AWS → **Services** → **EFS** → **File systems**.
    * В объекте `environment` передаются переменные окружения для Docker-контейнера в текстовом виде. Набор доступных переменных окружения приведен в таблице ниже. Рекомендуется передавать переменные `DEPLOY_USER` и `DEPLOY_PASSWORD` в объекте `secrets`.
    * В объекте `secrets` передаются переменные окружения для Docker-контейнера в виде ссылки на хранилище с чувствительными данными. Рекомендуется передавать переменные `DEPLOY_USER` и `DEPLOY_PASSWORD` в объекте `secrets`.

    --8<-- "../include/waf/installation/nginx-docker-env-vars-to-mount.md"
    
    * Описание всех параметров конфигурационного файла приведено в [документации AWS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html).
7. Создайте определение задания из конфигурационного файла с помощью команды [`aws ecs register-task-definition`](https://docs.aws.amazon.com/cli/latest/reference/ecs/register-task-definition.html):

    ```bash
    aws ecs register-task-definition --cli-input-json file://<PATH_TO_JSON_FILE>/<JSON_FILE_NAME>
    ```
8. Запустите задание в кластере с помощью команды [`aws ecs run-task`](https://docs.aws.amazon.com/cli/latest/reference/ecs/run-task.htmlhttps://docs.aws.amazon.com/cli/latest/reference/ecs/run-task.html):

    ```bash
    aws ecs run-task --cluster <CLUSTER_NAME> --launch-type EC2 --task-definition <FAMILY_PARAM_VALUE>
    ```
9. Перейдите в Консоль AWS → **Elastic Container Service** → кластер, в котором вы запустили задание  → **Tasks** и убедитесь, что задание появилось в списке.

## Тестирование работы WAF-ноды

1. В Консоли AWS перейдите к запущенному заданию и скопируйте IP-адрес контейнера.
2. Отправьте тестовый запрос с атаками [SQLI](../../../attacks-vulns-list.md#sqlинъекция-sql-injection) и [XSS](../../../attacks-vulns-list.md#межсайтовый-скриптинг-англ-cross-site-scripting-xss) на скопированный адрес:

    ```
    curl http://<COPIED_IP>/?id='or+1=1--a-<script>prompt(1)</script>'
    ```

    Если WAF‑нода работает в режиме `block`, запрос будет заблокирован с ответом `403 Forbidden`.
3. Перейдите в Консоль управления Валарм → секция **События** для [EU‑облака](https://my.wallarm.com/search) или для [RU‑облака](https://my.wallarm.ru/search) и убедитесь, что атаки появились в списке.
    ![!Атаки в интерфейсе](../../../images/admin-guides/yandex-cloud/test-attacks.png)

Сообщения об ошибках запуска контейнера отображаются в информации о задании в Консоли AWS. Если контейнер недоступен, убедитесь, что в контейнер переданы корректные значения всех обязательных параметров WAF-ноды.
