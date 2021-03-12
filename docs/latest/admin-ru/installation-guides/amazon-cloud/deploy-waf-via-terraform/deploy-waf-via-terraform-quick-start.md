# Быстрый старт примера кода Terraform

## Необходимые условия

* Аккаунт в Личном кабинете Валарм для [EU‑облака](https://my.wallarm.com/) или [RU‑облака](https://my.wallarm.ru/)
* Имя и пароль пользователя с ролью **Деплой**, который добавлен в ваш аккаунт в Личном кабинете Валарм. Для добавления пользователя используйте [инструкцию](../../../../user-guides/settings/users.md#create-a-user)
* Аккаунт AWS и данные пользователя с ролью **admin**
* Подтвержденные условия использования продуктов AWS: [WordPress Certified by Bitnami and Automattic](https://aws.amazon.com/marketplace/server/procurement?productId=7d426cb7-9522-4dd7-a56b-55dd8cc1c8d0) и [Wallarm Node (AI-based NG-WAF instance) by Wallarm](https://aws.amazon.com/marketplace/server/procurement?productId=34faafd7-601d-43ac-8d22-3f2d839028c5)
* Установленный [`terraform`](https://learn.hashicorp.com/terraform/getting-started/install.html) CLI версии 0.12.18 или выше
* Установленный [`jq`](https://stedolan.github.io/jq/download/) CLI
* Установленный [`git`](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) CLI
* Установленный [`aws`](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) CLI

## Быстрый старт

1. [Скачайте](#шаг-1-скачивание-примера-кода-terraform) пример кода Terraform.
2. [Настройте](#шаг-2-настройка-среды-и-переменных-terraform) среду и переменные Terraform.
3. [Разверните](#шаг-3-запуск-описанной-инфраструктуры) описанную инфраструктуру.
4. [Протестируйте](#шаг-4-тестирование-работы-wafноды) работу WAF‑ноды.

### Шаг 1: Скачивание примера кода Terraform

Пример кода доступен в [репозитории GitHub](https://github.com/wallarm/terraform-example). Клонируйте репозиторий, используя следующую команду:

``` bash
git clone https://github.com/wallarm/terraform-example.git
```

Конфигурационные файлы расположены в папке `terraform`:

* `variables.tf` содержит переменные Terraform;
* `main.tf` содержит настройки AWS.

### Шаг 2: Настройка среды и переменных Terraform

1. Запишите данные пользователя Валарм с ролью **Деплой** в переменные окружения:
    ``` bash
    export TF_VAR_deploy_username='DEPLOY_USERNAME'
    export TF_VAR_deploy_password='DEPLOY_PASSWORD'
    ```
    * `DEPLOY_USERNAME` — имя пользователя с ролью **Деплой**
    * `DEPLOY_PASSWORD` — пароль пользователя с ролью **Деплой**
2. Запишите [AWS Access Keys](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) в переменные окружения:
    ``` bash
    export AWS_ACCESS_KEY_ID='YOUR_ACCESS_KEY_ID'
    export AWS_SECRET_ACCESS_KEY='YOUR_SECRET_ACCESS_KEY'
    ```
    * `YOUR_ACCESS_KEY_ID` — Access Key ID
    * `YOUR_SECRET_ACCESS_KEY` —  Secret Access Key
3. Передайте конечную точку API `api.wallarm.com` в файле `variables.tf` в переменной `wallarm_api_domain`, если вы используете EU‑облако. Для RU‑облака передайте значение `api.wallarm.ru`.
4. (Опционально) Передайте публичный SSH-ключ в файле `variables.tf` в переменной `key_pair` для доступа к экземпляру EC2 по SSH.
5. (Опционально) Настройте регион AWS в файле `variables.tf`, используя переменные ниже. В приведенном примере используется используется регион `us-west-1` (Северная Калифорния).
    * `aws_region`, список регионов доступен по [ссылке](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html)
    * `az_a`
    * `az_b`
    * `wallarm_node_ami_id` — ID образа WAF‑ноды AWS EC2. Чтобы получить значение, используйте команду ниже, `REGION_CODE` необходимо заменить на значение переменной `aws-region`:
    ``` bash
    aws ec2 describe-images --filters "Name=name,Values=*Wallarm Node-2.18*" --region REGION_CODE | jq -r '.Images[] | "\(.ImageId)"'
    ```

    * `wordpress_ami_id` — ID образа AWS EC2 Wordpress. Чтобы получить значение, используйте команду ниже, `REGION_CODE` необходимо заменить на значение переменной `aws-region`:
    ``` bash
    aws ec2 describe-images --filters "Name=name,Values=*bitnami-wordpress-5.3.2-3-linux-ubuntu-16.04*" --region REGION_CODE | jq -r '.Images[] | "\(.ImageId)"'
    ```

### Шаг 3: Запуск описанной инфраструктуры

1. Перейдите к папке `terraform` склонированного репозитория:
    ``` bash
    cd terraform-example/terraform
    ```
2. Разверните инфраструктуру, используя следующие команды:

    ``` bash
    terraform init
    terraform plan
    terraform apply
    ```

После успешного выполнения команд, вы получите DNS развернутого экземпляра NLB. Например:

```
Apply complete! Resources: 4 added, 2 changed, 4 destroyed.

Outputs:

waf_nlb_dns_name = [
  "tf-wallarm-demo-asg-nlb-7b32738728e6ea44.elb.us-east-1.amazonaws.com",
]
```

Чтобы перейти к развернутому сервису Wordpress с WAF‑нодой, откройте ссылку из командной строки в браузере.

![!Установленный сервис Wordpress](../../../../images/admin-guides/configuration-guides/terraform-guide/opened-dns-wordress.png)

### Шаг 4: Тестирование работы WAF‑ноды

Развернутый кластер WAF самоподписан сертификатом SSL. Поэтому запросы, отправленные на DNS сервиса Wordpress, сначала будут обработаны WAF‑нодой.

Чтобы отправить тестовую атаку, добавьте `/?id='or+1=1--a-<script>prompt(1)</script>'` в запрос. Запрос будет заблокирован с кодом 403.

![!Ответ 403 на запрос с атакой](../../../../images/admin-guides/configuration-guides/terraform-guide/attacked-source.png)

Через несколько минут атаки типа SQLI и XSS отобразятся в Личном кабинет Валарм в разделе **События**:

![!Отображение атак в Личном кабинете Валарм](../../../../images/admin-guides/configuration-guides/terraform-guide/wallarm-account-with-attacks.png)

Настройки WAF‑ноды описаны в файле `main.tf` в объекте `wallarm_launch_config`. Для изменения настроек используйте описание директив по [ссылке](../../../configure-parameters-ru.md).

!!! info
    Чтобы удалить демо-окружение, используйте команду `terraform destroy`.