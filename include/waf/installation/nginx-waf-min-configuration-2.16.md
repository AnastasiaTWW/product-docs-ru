Основные конфигурационные файлы NGINX и WAF‑ноды Валарм расположены в директориях:

* `/etc/nginx/conf.d/default.conf` с настройками NGINX
* `/etc/nginx/conf.d/wallarm.conf` с глобальными настройками WAF‑ноды Валарм

    Файл используется для настроек, которые применяются ко всем доменам. Чтобы применить разные настройки к отдельным группам доменов, используйте файл `default.conf` или создайте новые файлы конфигурации для каждой группы доменов (например, `example.com.conf` и `test.com.conf`). Более подробная информация о конфигурационных файлах NGINX доступна в [официальной документации NGINX](https://nginx.org/ru/docs/beginners_guide.html).
* `/etc/nginx/conf.d/wallarm-status.conf` с настройками мониторинга WAF‑ноды. Описание конфигурации доступно по [ссылке][wallarm-status-instr]
* `/etc/default/wallarm-tarantool` или `/etc/sysconfig/wallarm-tarantool` с настройками хранилища Tarantool

#### Режим фильтрации запросов

По умолчанию, WAF‑нода находится в режиме `off` и не фильтрует входящие запросы. Измените режим фильтрации для блокировки запросов с атаками на уровне настроек NGINX:

1. Откройте файл `/etc/nginx/conf.d/default.conf`:

    ```bash
    sudo vim /etc/nginx/conf.d/default.conf
    ```
2. Добавьте в блок `server` строку `wallarm_mode block;`.

??? "Пример файла `/etc/nginx/conf.d/default.conf`"

    ```bash
    server {
        # порт, для которого фильтруется трафик
        listen       80;
        # домен, для которого фильтруется трафик
        server_name  localhost;
        # режим работы WAF‑ноды
        wallarm_mode block;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/share/nginx/html;
        }
    }
    ```

#### Оперативная память

!!! info "Постаналитика на отдельном сервере"
    Если постаналитика установлена на отдельный сервер, пропустите этот шаг. Настройка постаналитики была выполнена во время отдельной установки.

WAF‑нода использует находящееся в памяти хранилище Tarantool. Рекомендуемое количество памяти для Tarantool: 75% от общей памяти виртуальной машины. Чтобы настроить объем памяти для Tarantool:

1. Откройте для редактирования конфигурационный файл Tarantool:

    === "Debian"
        ``` bash
        sudo vim /etc/default/wallarm-tarantool
        ```
    === "Ubuntu"
        ``` bash
        sudo vim /etc/default/wallarm-tarantool
        ```
    === "CentOS или Amazon Linux 2"
        ``` bash
        sudo vim /etc/sysconfig/wallarm-tarantool
        ```
2. Укажите размер выделенной памяти в директиве `SLAB_ALLOC_ARENA` в ГБ. Значение может быть целым или дробным (разделитель целой и дробной части — точка). Например, 24 ГБ:
    
    ```bash
    SLAB_ALLOC_ARENA=24
    ```

    Подробные рекомендации по выделению памяти для Tarantool описаны в [инструкции][memory-instr]. 
3. Чтобы применить изменения, перезапустите Tarantool:

    === "Debian"
        ``` bash
        sudo systemctl restart wallarm-tarantool
        ```
    === "Ubuntu"
        ``` bash
        sudo service wallarm-tarantool restart
        ```
    === " CentOS или Amazon Linux 2"
        ```bash
        sudo systemctl restart wallarm-tarantool
        ```

#### Адрес отдельного сервера постаналитики

!!! info "NGINX-Wallarm и постаналитика на одном сервере"
    Если модуль NGINX-Wallarm и постаналитика установлены на одном сервере, пропустите этот шаг.

--8<-- "../include/waf/configure-separate-postanalytics-address-nginx.md"

#### Другие настройки

Чтобы обновить другие настройки NGINX и Валарм WAF, используйте документацию NGINX и список доступных [директив Валарм WAF][waf-directives-instr].
