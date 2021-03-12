[img-write-plugin-graphite]:    ../../images/monitoring/write-plugin-graphite.png

[link-docker-ce]:               https://docs.docker.com/install/
[link-docker-compose]:          https://docs.docker.com/compose/install/
[doc-gauge-attacks]:            available-metrics.md#количество-зафиксированных-атак
[doc-grafana]:                  working-with-grafana.md
[link-collectd-naming]:         https://collectd.org/wiki/index.php/Naming_schema
[link-write-plugin]:            https://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_write_graphite

#   Выгрузка метрик с помощью write‑плагина `collectd` в Graphite

В этом документе приводится пример использования write‑плагина `write_graphite` для экспорта метрик в Graphite.

## Схема работы примера

--8<-- "../include/monitoring/metric-example.md"


![!Схема работы примера][img-write-plugin-graphite]

В этом документе используется следующая схема развертывания:
*   WAF‑нода Валарм развернута на хосте, доступном по IP‑адресу `10.0.30.5` и полному доменному имени `node.example.local`.
  
    Плагин `write_graphite` для `collectd` на WAF‑ноде настроен следующим образом:

    *   Все метрики отсылаются на сервер `10.0.30.30`, слушающий на порту `2003/TCP`.
    *   Поскольку некоторые специфичные для Валарм плагины для `collectd` поддерживают несколько [инстансов][link-collectd-naming], плагин `write_graphite` содержит параметр `SeparateInstances`. Значение `true` у этого параметра означает, что плагин может работать с несколькими инстансами.
  
    Полный список параметров плагина доступен [здесь][link-write-plugin].
  
*   На отдельном хосте с IP‑адресом `10.0.30.30` (далее — хост Docker) развернуты сервисы `graphite` и `grafana` в виде Docker‑контейнеров.

    Сервис `graphite` с Graphite настроен следующим образом:

    *   Слушает входящие соединения на порту `2003/TCP`, на который `collectd` будет отправлять метрики WAF‑ноды.
    *   Слушает входящие соединения на порту `8080/TCP`, через который будет происходить коммуникация с Grafana.
    *   Сервис находится в общей Docker‑сети `sample-net` с сервисом `grafana`.
  
    Сервис `grafana` c Grafana настроен следующим образом:

    *   Веб-консоль Grafana доступна по адресу `http://10.0.30.30:3000`.
    *   Сервис находится в общей Docker‑сети `sample-net` с сервисом `graphite`. 


    
##  Настройка выгрузки метрик в Graphite


--8<-- "../include/monitoring/docker-prerequisites.md"


### Развертывание Graphite и Grafana

Разверните Graphite и Grafana на хосте Docker:
1.  Создайте файл `docker-compose.yaml` со следующим содержимым:
   
    ```
    version: "3"
    
    services:
      grafana:
        image: grafana/grafana
        container_name: grafana
        restart: always
        ports:
          - 3000:3000
        networks:
          - sample-net
    
      graphite:
        image: graphiteapp/graphite-statsd
        container_name: graphite
        restart: always
        ports:
          - 8080:8080
          - 2003:2003
        networks:
          - sample-net
    
    networks:
      sample-net:
    ```

2.  Соберите сервисы с помощью команды `docker-compose build`.

3.  Запустите сервисы с помощью команды `docker-compose up -d graphite grafana`.

На этом этапе у вас должны быть запущены Graphite, готовый принимать метрики от `collectd`, и Grafana, готовая осуществлять мониторинг и визуализацию данных, хранящихся в Graphite.

### Настройка `collectd`

Настройте `collectd` на выгрузку метрик в Graphite:
1.  Подключитесь к WAF‑ноде (например, с помощью протокола SSH). Убедитесь, что вы работаете под аккаунтом `root` или другим аккаунтом с правами суперпользователя.
2.  Создайте файл `/etc/collectd/collectd.conf.d/export-to-graphite.conf` со следующим содержимым:

    ```
    LoadPlugin write_graphite
    
    <Plugin write_graphite>
      <Node "node.example.local">
        Host "10.0.30.30"
        Port "2003"
        Protocol "tcp"
        SeparateInstances true
      </Node>
    </Plugin>
    ```
    
    Здесь задаются:
    
    1.  Имя хоста, с которого собираются метрики (`node.example.local`).
    2.  Сервер, на который необходимо отправлять метрики (`10.0.30.30`).
    3.  Порт сервера (`2003`) и протокол (`tcp`).
    4.  Логика передачи данных, при которой данные одного инстанса плагина отделены от данных другого инстанса (`SeparateInstances true`).
    
3.  Перезапустите сервис `collectd`, выполнив команду, соответствующую операционной системе, на которой установлена WAF‑нода:
  
    --8<-- "../include/monitoring/collectd-restart.md"

Теперь Graphite получает все метрики WAF‑ноды. Вы можете визуализировать интересующие вас метрики и осуществлять их мониторинг [с помощью Grafana][doc-grafana].