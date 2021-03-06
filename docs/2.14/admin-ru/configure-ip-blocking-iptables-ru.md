# Блокировка по IP‑адресам (iptables)

!!! warning "Экспериментальная функция"
    Функция блокировки по IP‑адресам является экспериментальной.
    Функция может быть изменена без предупреждения.

Для блокировки по IP‑адресам с помощью `iptables` используется готовый скрипт — `block_with_iptables.rb`. Для успешного применения блокировок по IP‑адресам WAF‑ноде нужно регулярно получать из облака Валарм обновленный список адресов, принадлежащих атакующим и подлежащих блокировке.

!!! info "Белый список"
    Также есть возможность организовать белый список IP‑адресов. Если адрес находится в белом списке, то запросы с него будут пропускаться к серверу приложения без проверки на принадлежность к черному списку.

## Настройте блокировку по IP‑адресам

1.  Обратитесь в [службу технической поддержки](mailto:support@wallarm.com) с запросом на создание системного пользователя для доступа к информации о черных списках.

2.  Установите пакет `wallarm_extra_scripts`. Пакет находится в репозитории
   Валарм.

    Для установки пакета выполните команду:

    === "Debian 9.x (stretch)"
         ```bash
         sudo apt install wallarm-extra-scripts
         ```
    === "Debian 10.x (buster)"
         ```bash
         sudo apt install wallarm-extra-scripts
         ```
    === "Ubuntu 16.04 LTS (xenial)"
         ```bash
         sudo apt install wallarm-extra-scripts
         ```
    === "Ubuntu 18.04 LTS (bionic)"
         ```bash
         sudo apt install wallarm-extra-scripts
         ```
    === "CentOS 6.x"
         ```bash
         sudo yum install wallarm-extra-scripts
         ```
    === "CentOS 7.x"
         ```bash
         sudo yum install wallarm-extra-scripts
         ```
    === "Amazon Linux 2"
         ```bash
         sudo yum install wallarm-extra-scripts
         ```

    Cкрипт `block_with_iptables.rb` будет установлен автоматически.
    Предлагаемый скрипт при каждом запуске создает или обновляет цепочку `wallarm_blacklist` в таблице `filter`. Для каждого заблокированного адреса добавляется правило `REJECT`.

3.  Создайте и сконфигурируйте таблицы `iptables`, указав какой трафик будет блокироваться. Например, для блокировки всего трафика, поступающего на 80 и 443 порты, выполните команды:

    ``` bash
    iptables -N wallarm_check
    iptables -N wallarm_blacklist
    iptables -A INPUT -p tcp --dport 80 -j wallarm_check
    iptables -A INPUT -p tcp --dport 443 -j wallarm_check
    iptables -A wallarm_check -j wallarm_blacklist
    ```

4.  Настройте регулярный запуск скрипта с помощью `cron`:
    1.  Откройте для редактирования файл `crontab` пользователя `root`:
        
        ``` bash
        crontab -e
        ```
        
    2.  Добавьте в этот файл следующие строки (замените `/path/to/log` на путь к лог‑файлу, в который скрипт будет писать логи):   
        
        ```
        PATH=/bin:/sbin:/usr/bin:/usr/sbin
        */5 *  * * *  root  timeout 90 /usr/share/wallarm-extra-scripts/block_with_iptables.rb >> /path/to/log 2>&1
        ```
        
        Эта конструкция задает следующее поведение cron-задачи:

        *   Cкрипт `block_with_iptables.rb` будет запускаться каждые 5 минут от имени пользователя `root`.
        *   Если скрипт не завершится до истечения таймаута в 90 секунд, то он будет завершен принудительно.
        *   Лог работы скрипта будет записан в заданный файл (например, `/path/to/log`); при этом поток вывода ошибок `stderr` перенаправляется в `stdout`.
        
5.  Если необходимо, настройте мониторинг работы скрипта. Для этого можно отслеживать время модификации (`mtime`) файла `/tmp/.wallarm.blacklist-sync.last`, которое будет изменяться при каждом успешном запуске скрипта.

6.  Добавление адресов в белый список.

    Чтобы внести несколько IP‑адресов в белый список, выполните следующую команду для диапазона адресов. Вместо `1.2.3.4/30`, укажите нужное значение:

    ``` bash
    iptables -I wallarm_check -s 1.2.3.4/30 -j RETURN
    ```

   Чтобы внести один IP‑адрес в белый список, замените значение `1.2.3.4` на необходимый адрес:

   ``` bash
   iptables -I wallarm_check -s 1.2.3.4 -j RETURN
   ```
