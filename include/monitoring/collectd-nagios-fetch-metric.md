=== "Linux"
    ```bash
    /usr/bin/collectd-nagios -s /var/run/collectd-unixsock -n <название метрики без указания имени хоста> -H <полное доменное имя хоста с WAF‑нодой, на котором запускается утилита>
    ```
=== "Docker"
    ```bash
    docker exec <имя контейнера> /usr/bin/collectd-nagios -s /var/run/collectd-unixsock -n <название метрики без указания имени хоста> -H <идентификатор контейнера>
    ```