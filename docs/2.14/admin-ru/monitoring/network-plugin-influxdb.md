[img-network-plugin-influxdb]:     ../../images/monitoring/network-plugin-influxdb.png

[doc-gauge-attacks]:               available-metrics.md#количество-зафиксированных-атак
[doc-grafana]:                     working-with-grafana.md

[link-collectd-networking]:        https://collectd.org/wiki/index.php/Networking_introduction
[link-network-plugin]:             https://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_network
[link-typesdb]:                    https://collectd.org/documentation/manpages/types.db.5.shtml
[link-typesdb-file]:               https://github.com/collectd/collectd/blob/master/src/types.db

#   Выгрузка метрик с помощью плагина Network `collectd` в InfluxDB

В этом документе приводится пример использования плагина Network для экспорта метрик в темпоральную базу данных InfluxDB. Также будет продемонстрировано, как визуализировать собранные в InfluxDB метрики с помощью Grafana.

##  Схема работы примера

--8<-- "../include/monitoring/metric-example.md"

![!Схема работы примера][img-network-plugin-influxdb]

В этом документе используется следующая схема развертывания:
*   WAF‑нода Валарм развернута на хосте, доступном по IP‑адресу `10.0.30.5` и полному доменному имени `node.example.local`.
    
    Плагин `network` для `collectd` на WAF‑ноде настроен так, что все метрики отсылаются на сервер InfluxDB `10.0.30.30` на порт `25826/UDP`.
    
    !!! info "Особенности плагина Network"
        Обратите внимание, что плагин может работать только с использованием протокола UDP (см. [примеры использования][link-collectd-networking] и [документацию][link-network-plugin] плагина `network`).
    
*   На отдельном хосте с IP‑адресом `10.0.30.30` (далее — «хост Docker») развернуты сервисы `influxdb` и `grafana` в виде Docker‑контейнеров.
    
    Сервис `influxdb` с базой данных InfluxDB настроен следующим образом:

    *   Создан источник данных `collectd` (`collectd input` в терминологии InfluxDB), который слушает на порту `25826/UDP` и записывает поступающие метрики в базу данных с именем `collectd`.
    *   Коммуникация с API InfluxDB происходит при помощи порта `8086/TCP`.
    *   Сервис находится в общей Docker‑сети `sample-net` с сервисом `grafana`.
    
    Сервис `grafana` c Grafana настроен следующим образом:

    *   Веб-консоль Grafana доступна по адресу `http://10.0.30.30:3000`.
    *   Сервис находится в общей Docker‑сети `sample-net` с сервисом `influxdb`. 

##  Настройка выгрузки метрик в InfluxDB

--8<-- "../include/monitoring/docker-prerequisites.md"

### Развертывание InfluxDB и Grafana

Разверните InfluxDB и Grafana на хосте Docker:
1.  Создайте рабочую директорию, например, `/tmp/influxdb-grafana` и перейдите в нее:
  
    ``` bash
    mkdir /tmp/influxdb-grafana
    cd /tmp/influxdb-grafana
    ```

2.  Для работы источника данных InfluxDB потребуется файл с типами измеряемых величин `collectd` под названием `types.db`. 

    Этот файл описывает спецификации наборов данных (англ. «dataset specifications»), которые используются `collectd`. Такие наборы данных включают в себя в том числе типы измеряемых величин. Подробная информация о файле доступна [здесь][link-typesdb].
  
    [Скачайте файл `types.db`][link-typesdb-file]  из репозитория GitHub проекта `collectd` и поместите его в рабочую директорию. 

3.  Получите базовый файл конфигурации InfluxDB, выполнив следующую команду в рабочей директории: 
    
    ``` bash
    docker run --rm influxdb influxd config > influxdb.conf
    ```

4.  Включите источник данных `collectd` в файле конфигурации InfluxDB `influxdb.conf`, поменяв значение параметра `enabled` в секции `[[collectd]]` с `false` на `true`.
   
    Прочие параметры оставьте без изменений.
   
    Секция должна выглядеть следующим образом:
   
    ```
    [[collectd]]
      enabled = true
      bind-address = ":25826"
      database = "collectd"
      retention-policy = ""
      batch-size = 5000
      batch-pending = 10
      batch-timeout = "10s"
      read-buffer = 0
      typesdb = "/usr/share/collectd/types.db"
      security-level = "none"
      auth-file = "/etc/collectd/auth_file"
      parse-multivalue-plugin = "split"  
    ```
    
5.  Создайте в рабочей директории файл `docker-compose.yaml` со следующим содержимым:
   
    ```
    version: "3"
    
    services:
      influxdb:
        image: influxdb
        container_name: influxdb
        ports:
          - 8086:8086
          - 25826:25826/udp
        networks:
          - sample-net
        volumes:
          - ./:/var/lib/influxdb
          - ./influxdb.conf:/etc/influxdb/influxdb.conf:ro
          - ./types.db:/usr/share/collectd/types.db:ro
    
      grafana:
        image: grafana/grafana
        container_name: grafana
        restart: always
        ports:
          - 3000:3000
        networks:
          - sample-net
    
    networks:
      sample-net:
    ```
 
    Согласно настройкам в `volumes:`, InfluxDB будет использовать: 

    *   Рабочую директорию в качестве хранилища баз данных.
    *   Файл конфигурации `influxdb.conf`, который находится в рабочей директории.
    *   Файл с типами измеряемых величин `types.db`, который находится в рабочей директории.  

6.  Соберите сервисы с помощью команды `docker-compose build`.

7.  Запустите сервисы с помощью команды `docker-compose up -d influxdb grafana`.

8.  Создайте базу данных с именем `collectd` для соответствующего источника данных InfluxDB, выполнив следующую команду:
   
    ``` bash
    curl -i -X POST http://10.0.30.30:8086/query --data-urlencode "q=CREATE DATABASE collectd"
    ```
    
    Сервер InfluxDB должен вернуть похожий ответ:
   
    ```
    HTTP/1.1 200 OK
    Content-Type: application/json
    Request-Id: 23604241-b086-11e9-8001-0242ac190002
    X-Influxdb-Build: OSS
    X-Influxdb-Version: 1.7.7
    X-Request-Id: 23604241-b086-11e9-8001-0242ac190002
    Date: Sat, 27 Jul 2019 15:49:37 GMT
    Transfer-Encoding: chunked
    
    {"results":[{"statement_id":0}]}
    ```
    
На этом этапе у вас должны быть запущены InfluxDB, готовый принимать метрики от `collectd`, и Grafana, готовая осуществлять мониторинг и визуализацию данных, хранящихся в InfluxDB.

### Настройка `collectd`

Настройте `collectd` на выгрузку метрик в InfluxDB:
1.  Подключитесь к WAF‑ноде (например, с помощью протокола SSH). Убедитесь, что вы работаете под аккаунтом `root` или другим аккаунтом с правами суперпользователя.

2.  Создайте файл `/etc/collectd/collectd.conf.d/export-to-influxdb.conf` со следующим содержимым:

    ```
    LoadPlugin network
    
    <Plugin "network">
        Server "10.0.30.30" "25826"
    </Plugin>
    ```

    Здесь задаются:

    *   Сервер, на который отправлять метрики (`10.0.30.30`).
    *   Порт сервера (`25826/UDP`).

3.  Перезапустите сервис `collectd`, выполнив команду, соответствующую операционной системе, на которой установлена WAF‑нода:

    --8<-- "../include/monitoring/collectd-restart.md"

Теперь InfluxDB получает все метрики WAF‑ноды. Вы можете визуализировать интересующие вас метрики и осуществлять их мониторинг [с помощью Grafana][doc-grafana].