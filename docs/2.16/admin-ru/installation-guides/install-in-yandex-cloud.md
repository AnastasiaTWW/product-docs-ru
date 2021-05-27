[waf-mode-instr]:                   ../../admin-ru/configure-wallarm-mode.md
[logging-instr]:                    ../../admin-ru/configure-logging.md
[proxy-balancer-instr]:             ../../admin-ru/using-proxy-or-balancer-ru.md
[scanner-whitelisting-instr]:       ../../admin-ru/scanner-ips-whitelisting.md
[process-time-limit-instr]:         ../../admin-ru/configure-parameters-ru.md#wallarm_process_time_limit
[enable-libdetection-docs]:         ../configure-parameters-ru.md#wallarm_enable_libdetection

# Установка в Яндекс.Облаке

Инструкция описывает настройку виртуальной машины с [Валарм WAF](https://cloud.yandex.ru/marketplace/products/f2emrc60s1nh9356v1rq) в Яндекс.Облаке.

## Требования

### Для работы с Яндекс.Облаком

* Доступ к [консоли управления](https://console.cloud.yandex.ru/) Яндекс.Облаком
* Платежный аккаунт на [странице биллинга](https://console.cloud.yandex.ru/billing) в статусе `ACTIVE` или `TRIAL_ACTIVE`
* Созданный каталог. По умолчанию создается каталог `default`, для настройки нового каталога используйте [инструкцию](https://cloud.yandex.ru/docs/resource-manager/operations/folder/create)
* Пара SSH‑ключей типа rsa с 2048 битами. Для создания пары ключей используйте [инструкцию](https://cloud.yandex.ru/docs/compute/operations/vm-connect/ssh#creating-ssh-keys)

### Для работы с Валарм WAF

* Доступ к аккаунту с ролью **Администратор** и отключенная двухфакторная аутентификация в Консоли управления Валарм для [RU‑облака](https://my.wallarm.ru) или [EU‑облака](https://my.wallarm.com)
* Доступ виртуальной машины к Валарм API по адресу `api.wallarm.com:444` для EU‑облака или `api.wallarm.ru:444` для RU‑облака. Убедитесь, что доступ не ограничен файерволом
* Выполнение команд от имени суперпользователя (например, `root`)

## Установка

### 1. Создайте виртуальную машину с WAF‑нодой

!!! info "Если виртуальная машина с WAF‑нодой уже создана"
    Если вы создаете новую виртуальную машину вместо существующей виртуальной машины или дублируете установку, используйте версию существующего Валарм WAF или обновите версии всех установок до последней.

    Чтобы получить текущую версию, используйте команду: 

    ```
    apt list wallarm-node
    ```

    * Если установлена версия `2.18.x`, используйте [инструкцию для 2.18](../../../../admin-ru/installation-guides/install-in-yandex-cloud/).
    * Если установлена версия `2.16.x`, используйте текущую инструкцию или обновите все установки Валарм WAF до 2.18.

    Более подробная информация о поддержке версий доступна в [политике версионирования WAF‑ноды](../../updating-migrating/versioning-policy.md).

1. Войдите в [консоль управления](https://console.cloud.yandex.ru/) и выберите каталог, в котором будет создана виртуальная машина.
2. Выберите **Compute Cloud** в списке сервисов.
3. Нажмите кнопку **Создать ВМ**.
4. Выберите Wallarm WAF из списка образов в блоке **Образы из Cloud Marketplace**.
5. Настройте остальные параметры виртуальной машины, следуя [инструкции](https://cloud.yandex.ru/docs/compute/quickstart/quick-create-linux#create-vm).

![!Пример настроек ВМ](../../images/admin-guides/yandex-cloud/vm-settings.png)

### 2. Подключитесь к виртуальной машине с WAF‑нодой

1. Убедитесь, что виртуальная машина находится в статусе `RUNNING`:
    ![!ВМ в статусе RUNNING](../../images/admin-guides/yandex-cloud/running-vm.png)
2. Подключитесь к виртуальной машине по протоколу SSH, используя [инструкцию](https://cloud.yandex.ru/docs/compute/quickstart/quick-create-linux#connect-to-vm).

### 3. Подключите WAF‑ноду к Облаку Валарм

Подключите WAF‑ноду к облаку Валарм **по токену ноды** или **по логину и паролю** администратора в Консоли управления Валарм.

#### По токену WAF‑ноды

1. Перейдите в Консоль управления Валарм → секция **Ноды** и создайте **Облачную ноду**.
2. Откройте карточку созданной WAF‑ноды и скопируйте **Токен ноды**.
3. На виртуальной машине с WAF‑нодой запустите скрипт `addcloudnode`:
    
    === "EU‑облако"
        ```bash
        sudo /usr/share/wallarm-common/addcloudnode
        ```
    === "RU‑облако"
        ```bash
        sudo /usr/share/wallarm-common/addcloudnode -H api.wallarm.ru
        ```
4. Вставьте скопированный токен WAF‑ноды.

WAF‑нода будет синхронизироваться с Облаком Валарм каждые 2‑4 минуты в соответствии с конфигурацией синхронизации по умолчанию. [Подробнее о настройке синхронизации WAF‑ноды с Облаком Валарм →](../configure-cloud-node-synchronization-ru.md#синхронизация-облачной-wafноды-с-облаком-валарм)

#### По логину и паролю администратора

1. На виртуальной машине с WAF‑нодой запустите скрипт `addnode`:
    
    === "EU‑облако"
        ```bash
        sudo /usr/share/wallarm-common/addnode
        ```
    === "RU‑облако"
        ```bash
        sudo /usr/share/wallarm-common/addnode -H api.wallarm.ru
        ```
    
2. Введите логин и пароль от аккаунта администратора в Консоли управления Валарм.
3. Введите имя новой WAF‑ноды или нажмите Enter, чтобы использовать имя пользователя виртуальной машины.

WAF‑нода будет синхронизироваться с Облаком Валарм каждые 2‑4 минуты в соответствии с конфигурацией синхронизации по умолчанию. [Подробнее о настройке синхронизации WAF‑ноды с Облаком Валарм →](../configure-cloud-node-synchronization-ru.md#синхронизация-локальной-wafноды-с-облаком-валарм)

### 4. Обновите конфигурацию Валарм WAF

Основные конфигурационные файлы NGINX и WAF‑ноды Валарм расположены в директориях:

* `/etc/nginx/nginx.conf` с настройками NGINX
* `/etc/nginx/conf.d/wallarm.conf` с глобальными настройками WAF‑ноды Валарм

    Файл используется для настроек, которые применяются ко всем доменам. Чтобы применить разные настройки к отдельным группам доменов, используйте файл `nginx.conf` или создайте новые файлы конфигурации для каждой группы доменов (например, `example.com.conf` и `test.com.conf`). Более подробная информация о конфигурационных файлах NGINX доступна в [официальной документации NGINX](https://nginx.org/ru/docs/beginners_guide.html).
* `/etc/nginx/conf.d/wallarm-status.conf` с настройками мониторинга WAF‑ноды. Описание конфигурации доступно по [ссылке](../configure-statistics-service.md)
* `/etc/default/wallarm-tarantool` с настройками хранилища Tarantool

#### Режим фильтрации запросов

По умолчанию, WAF‑нода находится в режиме `monitoring` и не блокирует атаки. Измените режим фильтрации для блокировки запросов с атаками на уровне настроек NGINX:

1. Откройте файл `/etc/nginx/conf.d/wallarm.conf`:

    ```bash
    sudo vim /etc/nginx/conf.d/wallarm.conf
    ```
2. Закомментируйте строку `wallarm_mode monitoring;`.
3. Откройте файл `/etc/nginx/nginx.conf`:

    ```bash
    sudo vim /etc/nginx/nginx.conf
    ```
4. Добавьте в блок `http` строку `wallarm_mode block;`.

??? "Пример файла `/etc/nginx/nginx.conf`"

    ```bash
    user www-data;
    worker_processes auto;
    pid /run/nginx.pid;
    include /etc/nginx/modules-enabled/*.conf;

    events {
        worker_connections 768;
        # multi_accept on;
    }

    http {
        wallarm_mode block;

        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        # server_tokens off;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        ##
        # SSL Settings
        ##

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
        ssl_prefer_server_ciphers on;

        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        ##
        # Gzip Settings
        ##

        gzip on;

        # gzip_vary on;
        # gzip_proxied any;
        # gzip_comp_level 6;
        # gzip_buffers 16 8k;
        # gzip_http_version 1.1;
        # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

        ##
        # Virtual Host Configs
        ##

        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
    }
    ```

#### Оперативная память

WAF‑нода использует находящееся в памяти хранилище Tarantool. По умолчанию развернутый образ WAF‑ноды Валарм выделяет под Tarantool 75% от общей памяти виртуальной машины. Чтобы изменить значение:

1. Откройте для редактирования конфигурационный файл Tarantool:

    ```bash
    sudo vim /etc/default/wallarm-tarantool
    ```
2. Укажите размер выделенной памяти в директиве `SLAB_ALLOC_ARENA` в ГБ. Значение может быть целым или дробным (разделитель целой и дробной части — точка). Например, 24 ГБ:
    
    ```bash
    SLAB_ALLOC_ARENA=24
    ```
3. Чтобы применить изменения, перезапустите Tarantool:

    ```bash
    sudo systemctl restart wallarm-tarantool
    ```

#### Другие настройки

Чтобы обновить другие настройки NGINX и Валарм WAF, используйте документацию NGINX и список доступных [директив Валарм WAF](../configure-parameters-ru.md).

### 5. Перезапустите NGINX

Чтобы применить изменения, перезапустите NGINX:

```bash
sudo systemctl restart nginx
```

### 6. Протестируйте работу Валарм WAF

1. Получите статистику о работе WAF‑ноды, выполнив запрос:

    ```bash
    curl http://127.0.0.8/wallarm-status
    ```

    Запрос вернет статистические данные о проанализированных запросах. Формат ответа приведен ниже, подробное описание параметров доступно по [ссылке](../configure-statistics-service.md).
    ```
    { "requests":0,"attacks":0,"blocked":0,"abnormal":0,"tnt_errors":0,"api_errors":0,
    "requests_lost":0,"segfaults":0,"memfaults":0,"softmemfaults":0,"time_detect":0,"db_id":46,
    "lom_id":16767,"proton_instances": { "total":1,"success":1,"fallback":0,"failed":0 },
    "stalled_workers_count":0,"stalled_workers":[] }
    ```
2. Отправьте тестовый запрос с атаками [SQLI](../../attacks-vulns-list.md#sqlинъекция-sql-injection) и [XSS](../../attacks-vulns-list.md#межсайтовый-скриптинг-англ-cross-site-scripting-xss) на внешний IP‑адрес:

    ```
    curl http://84.201.148.210/?id='or+1=1--a-<script>prompt(1)</script>'
    ```

    Если WAF‑нода работает в режиме `block`, запрос будет заблокирован с ответом `403 Forbidden`.
3. Выполните запрос к `wallarm-status` и убедитесь, что значение параметров `requests` и `attacks` увеличилось:

    ```bash
    curl http://127.0.0.8/wallarm-status
    ```
4. Перейдите в Консоль управления Валарм → секция **События** для [EU‑облака](https://my.wallarm.com/search) или для [RU‑облака](https://my.wallarm.ru/search) и убедитесь, что атаки появились в списке.
   
    ![!Атаки в интерфейсе](../../images/admin-guides/yandex-cloud/test-attacks.png)

## Дополнительные настройки

WAF‑нода со стандартными настройками развернута в Яндекс.Облаке. Чтобы кастомизировать настройки Валарм WAF, вы можете использовать [доступные директивы](../configure-parameters-ru.md).

--8<-- "../include/waf/installation/common-customization-options-216.md"
