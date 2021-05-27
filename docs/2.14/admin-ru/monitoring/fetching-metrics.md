[link-network-plugin]:              https://collectd.org/wiki/index.php/Plugin:Network
[link-network-plugin-docs]:         https://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_network
[link-collectd-networking]:         https://collectd.org/wiki/index.php/Networking_introduction
[link-influx-collectd-support]:     https://docs.influxdata.com/influxdb/v1.7/supported_protocols/collectd/
[link-plugin-table]:                https://collectd.org/wiki/index.php/Table_of_Plugins
[link-nagios-plugin-docs]:          https://collectd.org/documentation/manpages/collectd-nagios.1.shtml
[link-notif-common]:                https://collectd.org/wiki/index.php/Notifications_and_thresholds
[link-notif-details]:               https://collectd.org/documentation/manpages/collectd-threshold.5.shtml
[link-unixsock]:                    https://collectd.org/wiki/index.php/Plugin:UnixSock

[doc-network-plugin-example]:       network-plugin-influxdb.md
[doc-write-plugin-example]:         write-plugin-graphite.md
[doc-zabbix-example]:               collectd-zabbix.md
[doc-nagios-example]:               collectd-nagios.md

#   Получение метрик

##  Выгрузка метрик напрямую из `collectd`

Вы можете напрямую выгружать метрики, собранные `collectd`, в инструменты, которые поддерживают работу с потоком данных в формате `collectd`.

!!! warning "Внимание"
    Все дальнейшие действия необходимо выполнять с правами суперпользователя (например, `root`).

### Выгрузка метрик с помощью плагина Network

Настройте и подключите плагин [Network][link-network-plugin] к `collectd`:

1.  Создайте в директории `/etc/collectd/collectd.conf.d/` файл конфигурации для плагина с расширением `.conf` (например, `export-via-network.conf`) и следующим содержимым:

    ```
    LoadPlugin network
    
    <Plugin "network">
      Server "Server IPv4/v6 address or FQDN" "Server port"
    </Plugin>
    ```
    
    Согласно этому конфигурационному файлу, плагин будет запускаться при старте `collectd`, работать в режиме клиента и пересылать данные о метриках WAF‑ноды на указанный сервер. 
    
2.  Настройте сервер, который будет принимать данные от collectd-клиента. Необходимые шаги по настройке зависят от выбранного сервера (примеры: [`collectd`][link-collectd-networking], [InfluxDB][link-influx-collectd-support]).
   
    
!!! info "Работа с плагином Network"
    Плагин Network работает с использованием протокола UDP (см. [документацию плагина][link-network-plugin-docs]). Убедитесь, что на сервере разрешена работа по протоколу UDP.
      
3.  Перезапустите сервис `collectd`, выполнив команду, соответствующую операционной системе, на которой установлена WAF‑нода:

    --8<-- "../include/monitoring/collectd-restart.md"

!!! info "Пример"
    Вы можете ознакомиться с [примером выгрузки метрик][doc-network-plugin-example] с помощью плагина Network в InfluxDB с последующей визуализацией метрик в Grafana.

### Выгрузка метрик с помощью write‑плагина `collectd`

Для того, чтобы настроить выгрузку метрик с помощью [write‑плагина][link-plugin-table] `collectd`, обратитесь к документации соответствующего плагина. 

!!! info "Пример"
    Для получения базовых сведений об использовании write‑плагинов, вы можете ознакомиться с [примером выгрузки метрик][doc-write-plugin-example] в Graphite с последующей визуализацией метрик в Grafana.

##  Выгрузка метрик с помощью утилиты `collectd-nagios`

Для выгрузки метрик с помощью этого способа:
1.  Установите утилиту `collectd-nagios` на хост с WAF‑нодой, выполнив одну из следующих команд (для WAF‑ноды, установленной на Linux):

    --8<-- "../include/monitoring/install-collectd-utils.md"
    
    !!! info "Образ Docker"
        Образ Docker c WAF‑нодой уже содержит в себе предустановленную утилиту `collectd-nagios`.
    
2.  Убедитесь, что у вас есть возможность запускать эту утилиту с повышенными правами либо от имени пользователя суперпользователя (например, `root`), либо с помощью `sudo` путем добавления необходимых пользователей в файл `sudoers` с директивой `NOPASSWD`.

    !!! info "Работа с Docker‑контейнером"  
        При вызове утилиты `collectd-nagios` из Docker‑контейнера с WAF‑нодой повышение прав не требуется.
    
3.  Подключите и настройте плагин [`UnixSock`][link-unixsock] для передачи метрик `collectd` через сокет домена Unix. Для этого создайте файл `/etc/collectd/collectd.conf.d/unixsock.conf` со следующим содержимым:

    ```
    LoadPlugin unixsock

    <Plugin unixsock>
        SocketFile "/var/run/collectd-unixsock"
        SocketGroup "root"
        SocketPerms "0770"
        DeleteSocket true
    </Plugin>
    ```

4. Перезапустите сервис `collectd`, выполнив команду, соответствующую операционной системе, на которой установлена WAF‑нода:
    
    --8<-- "../include/monitoring/collectd-restart.md"

5.  Получите значения требуемых метрик, выполнив следующую команду:
    
    --8<-- "../include/monitoring/collectd-nagios-fetch-metric.md"
    
    !!! info "Получение идентификатора контейнера Docker"
        Вы можете узнать значение идентификатора контейнера, выполнив команду `docker ps` (см. столбец «CONTAINER ID»).

!!! info "Настройка порогов для утилиты `collectd-nagios`"
    При необходимости вы можете указать диапазон значений, при которых утилита `collectd-nagios` будет возвращать статус `WARNING` или `CRITICAL` с помощью параметров `-w` и `-c` (подробная информация доступна в [документации][link-nagios-plugin-docs] утилиты).
    
**Примеры вызова утилиты:**
*   Чтобы получить значение метрики `curl_json-wallarm_nginx/gauge-attacks` на Linux‑хосте `node.example.local` с WAF‑нодой, необходимо выполнить следующую команду:

    ``` bash
    /usr/bin/collectd-nagios -s /var/run/collectd-unixsock -n curl_json-wallarm_nginx/gauge-attacks -H node.example.local
    ```

*   Чтобы получить значение метрики `curl_json-wallarm_nginx/gauge-attacks` (на момент вызова `collectd-nagios`) для WAF‑ноды, запущенной в Docker‑контейнере с именем `wallarm-node` и с идентификатором `95d278317794`, необходимо выполнить следующую команду:
     
    ``` bash
    docker exec wallarm-node /usr/bin/collectd-nagios -s /var/run/collectd-unixsock -n curl_json-wallarm_nginx/gauge-attacks -H 95d278317794
    ```

!!! info "Примеры"
    Для получения базовых сведений об использовании утилиты `collectd-nagios`, вы можете ознакомиться с примерами выгрузки метрик:
    
    *   [в систему мониторинга Nagios][doc-nagios-example];
    *   [в систему мониторинга Zabbix][doc-zabbix-example].

##  Отправка уведомлений от `collectd`

Уведомления настраиваются в файле: 

--8<-- "../include/monitoring/notification-config-location.md"

Общее описание работы уведомлений доступно [здесь][link-notif-common].
Подробное описание процесса настройки уведомлений доступно [здесь][link-notif-details].

Возможные методы для отправки уведомлений:
*   NSCA и NSCA-ng,
*   SNMP TRAP,
*   почтовые сообщения,
*   собственные скрипты.