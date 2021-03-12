# Блокировка по IP-адресам (NGINX)

По умолчанию блокировка по IP-адресам на стороне NGINX не активна. Для её активации необходимо выполнить следующие действия:

1.  Перейдите в папку с конфигурационными файлами NGINX:

    ```bash
    cd /etc/nginx/conf.d
    ```

2.  Создайте в текущей папке файл `wallarm-acl.conf` со следующим содержимым:
    
    ```
    wallarm_acl_db default {
        wallarm_acl_path <путь-до-папки-Валарм-ACL>;
        wallarm_acl_mapsize 64m;
    }
    
    server {
        listen 127.0.0.9:80;
    
        server_name localhost;
    
        allow 127.0.0.0/8;
        deny all;
    
        access_log off;
    
        location /wallarm-acl {
            wallarm_acl default;
            wallarm_acl_api on;
        }
    }
    ```
    
    В конфигурации выше `<путь-до-папки-Валарм-ACL>`&nbsp;— путь до любой пустой директории, в которой пользователь `nginx` может создавать поддиректории и файлы для хранения списков управления доступом. 

    !!! info "Проверка прав пользователя `nginx`"
        Для того, чтобы узнать, имеет ли пользователь `nginx` права на действия с определенной директорией, выполните следующую команду:
        ```
        sudo -u nginx [ -r <путь-до-директории> ] && [ -w <путь-до-директории> ] && echo "ОК"
        ```
        
        В этой команде `<путь-до-директории>` — это путь до папки, права на действия с которой вам необходимо проверить.
        
        Из-за префикса `sudo -u nginx` эта команда будет выполнена под пользователем `nginx`.
        
        Команда сначала проверяет, есть ли у пользователя права на чтение директории (часть `[ ‑r <путь‑до‑директории]`). Затем проверяется, есть ли у пользователя права на запись в директорию (часть `[ ‑w <путь‑до‑директории]`).   
        
        Если пользователь `nginx` имеет права на просмотр и редактирование директории, путь до которой вы указали в команде, то терминал выведет сообщение `ОК`. Такая директория подходит для указания в качестве значения `wallarm_acl_path`.
        
        Если у пользователя `nginx` нет необходимых прав, вывод терминала будет пуст.
    
    **Пример:**
    
    Директории, подходящие для хранения списков управления доступом, зависят от типа установки WAF‑ноды и от операционной системы:
    
    *   Динамический модуль NGINX:
    
        === "Debian 9.x (stretch)"
            ```bash
            /var/cache/nginx/wallarm_acl_default
            ```
        === "Debian 10.x (buster)"
            ```bash
            /var/cache/nginx/wallarm_acl_default
            ```
        === "Ubuntu 16.04 LTS (xenial)"
            ```bash
            /var/cache/nginx/wallarm_acl_default
            ```
        === "Ubuntu 18.04 LTS (bionic)"
            ```bash
            /var/cache/nginx/wallarm_acl_default
            ```
        === "CentOS 7.x"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```
        === "Amazon Linux 2"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```
        === "CentOS 8.x"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```
    
    *   Динамический модуль NGINX из репозиториев ОС:
    
        === "Debian 9.x (stretch)"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```
        === "Debian 10.x (buster)"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```
        === "Ubuntu 16.04 LTS (xenial)"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```
        === "Ubuntu 18.04 LTS (bionic)"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```
        === "CentOS 7.x"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```
        === "Amazon Linux 2"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```
        === "CentOS 8.x"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```

    *   Модуль NGINX Plus:
    
        === "Debian 9.x (stretch)"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```
        === "Debian 10.x (buster)"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```
        === "Ubuntu 16.04 LTS (xenial)"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```
        === "Ubuntu 18.04 LTS (bionic)"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```
        === "CentOS 7.x"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```
        === "Amazon Linux 2"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```
        === "CentOS 8.x"
            ```bash
            /var/lib/nginx/wallarm_acl_default
            ```

3.  Включите блокировку для соответствующих виртуальных хостов и/или location'ов, добавив следующие строки в их конфигурационные файлы:

    ```
    server {
        ...
        wallarm_acl default;
        ...
    }
    ```

4.  Добавьте в файл `/etc/wallarm/node.yaml` следующие строки:
    
    ```
    sync_blacklist:
        nginx_url: http://127.0.0.9/wallarm-acl
    ```
5.  Перезапустите NGINX:

    ``` bash
    sudo service nginx reload
    ```

6.  Активируйте синхронизацию черных списков.

    Один из способов сделать это — снять комментарий со строки, содержащей `sync‑blacklist` в качестве подстроки, удалив символ `#` из начала этой строки в файле `/etc/cron.d/wallarm-node-nginx`.
    
    Вы также можете исполнить следующую команду, которая сделает это за вас:
    
    ``` bash
    sed -i -Ee 's/^#(.*sync-blacklist.*)/\1/' /etc/cron.d/wallarm-node-nginx
    ```
    
    !!! info "Работа с командой `sed`"
        Sed — это потоковый редактор.
        
        По умолчанию sed записывает изменения в стандартный поток вывода. Опция `-i` означает, что все изменения будут записаны в редактируемый файл. 
        
        Опция `-eE` — это комбинация двух отдельных опций:

        * Опция `-e` означает следующее:
        * Первый параметр, не являющийся опцией, будет использован на входные данные в качестве скрипта;
        * Второй параметр, не являющийся опцией, будет использован в качестве файла со входными данными.
        * Опция `-E` означает, что следующий за этой опцией скрипт написан на [расширенном языке регулярных выражений](https://www.gnu.org/software/sed/manual/sed.html#ERE-syntax).
        
        Следующий за опциями скрипт заменит в файле `/etc/cron.d/wallarm-node-nginx` строки, которые удовлетворяют регулярному выражению `^#(.*sync‑blacklist.*)` на последовательности символов, которые удовлетворяют регулярному выражению внутри круглых скобок. Обратная ссылка `\ 1` в этом скрипте означает, что подвыражение в первой паре круглых скобок должно использоваться в качестве замены.
        
        Строка, удовлетворяющая регулярному выражению `^#(.*sync‑blacklist.*)`:

        * Начинается с символа `#`;
        * Содержит `sync-blacklist` в качестве подстроки.
        
        Замена для описанной строки — подстрока этой строки без символа `#` в начале строки.
        
        Эта команда снимает комментарий со строки, указывающей на синхронизацию черного списка. Таким образом, будет активирована синхронизация черных списков.
        
        Подробнее о работе потокового редактора sed вы можете узнать [здесь](https://www.gnu.org/software/sed/manual/sed.html).

7.  Адреса можно добавлять в белый список, чтобы пропускать запросы, приходящие с этих адресов, без проверки на принадлежность к черному списку. Например, следующие строки в конфигурационном файле хоста или location'а добавляют в его белый список диапазон IP-адресов `1.2.3.4/32`:
    
    ```
    server {
        ...
        wallarm_acl default;
        allow 1.2.3.4/32;
        satisfy any;
        ...
    }
    ```

    После сохранения правок в конфигурации, перезапустите NGINX:

    ``` bash
    sudo service nginx reload
    ```
