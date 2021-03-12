[wallarm-status-instr]:             ../admin-ru/configure-statistics-service.md
[memory-instr]:                     ../admin-ru/configuration-guides/allocate-resources-for-waf-node.md
[waf-directives-instr]:             ../admin-ru/configure-parameters-ru.md
[sqli-attack-desc]:                 ../attacks-vulns-list.md#sqlинъекция-sql-injection
[xss-attack-desc]:                  ../attacks-vulns-list.md#межсайтовый-скриптинг-англ-cross-site-scripting-xss
[img-test-attacks-in-ui]:           ../images/admin-guides/yandex-cloud/test-attacks.png

# Обновление облачного образа WAF‑ноды

Инструкция описывает способ обновления образа WAF‑ноды, развернутого в AWS или GCP, до версии 2.16.

## Порядок обновления

Чтобы обновить версию WAF‑ноды, развернутой в облаке, необходимо:

1. Запустить новую виртуальную машину из образа WAF‑ноды версии 2.16.
2. Перенести настройки WAF‑ноды предыдущей версии на новую версию.
3. Удалить инстанс с предыдущей версией WAF‑ноды.

Более подробное описание шагов по обновлению приведено ниже.

## Шаг 1: Запустите новый инстанс с WAF‑нодой 2.16

1. Откройте образ WAF‑ноды Валарм на [Amazon Marketplace](https://aws.amazon.com/marketplace/pp/B073VRFXSD) или на [GCP Marketplace](https://console.cloud.google.com/marketplace/details/wallarm-node-195710/wallarm-node) и перейдите к запуску.
2. При запуске выполните следующие настройки:

      * Выберите версию образа `2.16.x`
      * Для AWS выберите [созданную группу безопасности](../admin-ru/installation-ami-ru.md#3--создание-группы-безопасности) в поле **Security Group Settings**
      * Для AWS выберите название [созданной пары ключей](../admin-ru/installation-ami-ru.md#2--создание-ssh-ключей) в поле **Key Pair Settings**
3. Подтвердите запуск инстанса.
4. Для GCP выполните настройку инстанса по [инструкции](../admin-ru/installation-gcp-ru.md#3-настройка-инстанса-с-wafнодой-валарм).

## Шаг 2: Подключите WAF‑ноду к Облаку Валарм

1. Подключитесь к инстансу с WAF‑нодой по SSH. Подробная инструкция по подключению к инстансу доступна в [документации AWS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html) и в [документации GCP](https://cloud.google.com/compute/docs/instances/connecting-to-instance).
2. Подключите WAF‑ноду к Облаку Валарм по токену новой ноды или по логину и паролю в Консоли управления Валарм, как описано в инструкции для [AWS](../admin-ru/installation-ami-ru.md#6--подключение-wafноды-к-облаку-валарм) или для [GCP](../admin-ru/installation-gcp-ru.md#4-подключение-по-ssh-к-инстансу-с-wafнодой).

## Шаг 3: Скопируйте настройки WAF‑ноды из предыдущей версии в новую версию

1. Скопируйте настройки обработки и проксирования запросов из следующих конфигурационных файлов предыдущей версии WAF‑ноды в файлы WAF‑ноды 2.16:

      * `/etc/nginx/nginx.conf` и другие файлы с настройками NGINX
      * `/etc/nginx/conf.d/wallarm.conf` с глобальными настройками WAF‑ноды
      * `/etc/nginx/conf.d/wallarm-status.conf` с настройками сервиса мониторинга WAF‑ноды
      * `/etc/environment` с переменными окружения
      * `/etc/default/wallarm-tarantool` с настройками Tarantool
      * другие файлы с кастомными настройками обработки и проксирования запросов
2. Перезапустите NGINX, чтобы применить настройки: 

    ```bash
    sudo systemctl restart nginx
    ```

Подробная информация о работе с конфигурационными файлами NGINX доступна в [официальной документации NGINX](https://nginx.org/ru/docs/beginners_guide.html).

Список доступных директив для настройки WAF‑ноды доступен по [ссылке](../admin-ru/configure-parameters-ru.md).

## Шаг 4: Протестируйте работу WAF‑ноды

--8<-- "../include/waf/installation/test-waf-operation.md"

## Шаг 5: Создайте образ виртуальной машины с WAF‑нодой 2.16

Для создания образа виртуальной машины с WAF‑нодой 2.16, используйте инструкцию для [AWS](../admin-ru/installation-guides/amazon-cloud/create-image.md) или [GCP](../admin-ru/installation-guides/google-cloud/create-image.md).

## Шаг 6: Удалите инстанс с предыдущей версией WAF‑ноды

После успешной настройки и тестирования новой версии WAF‑ноды, удалите инстанс и виртуальную машину с предыдущей версией WAF‑ноды, используя консоль управления AWS или GCP.
