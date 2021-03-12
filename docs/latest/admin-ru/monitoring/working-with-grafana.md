[img-influxdb-query-graphical]:     ../../images/monitoring/grafana-influx-1.png
[img-influxdb-query-plaintext]:     ../../images/monitoring/grafana-influx-2.png
[img-query-visualization]:          ../../images/monitoring/grafana-query-visualization.png
[img-grafana-0-attacks]:            ../../images/monitoring/grafana-0-attacks.png
[img-grafana-16-attacks]:           ../../images/monitoring/grafana-16-attacks.png

[link-grafana]:                     https://grafana.com/

[doc-network-plugin-influxdb]:      network-plugin-influxdb.md
[doc-network-plugin-graphite]:      write-plugin-graphite.md
[doc-gauge-attacks]:                available-metrics.md#количество-зафиксированных-атак
[doc-available-metrics]:            available-metrics.md

[anchor-verify-monitoring]:         #проверка-работы-мониторинга-grafana
[anchor-query]:                     #получение-метрик-из-источника-данных

#   Работа с метриками WAF‑ноды в Grafana

Если вы настроили выгрузку метрик в InfluxDB или Graphite, то вы можете визуализировать эти метрики с помощью [Grafana][link-grafana].

!!! info "Допущения"
    В этом документе предполагается, что вы развернули Grafana вместе с [InfluxDB][doc-network-plugin-influxdb] или [Graphite][doc-network-plugin-graphite].
    
    В качестве примера описывается работа с одной метрикой [`curl_json-wallarm_nginx/gauge-attacks`][doc-gauge-attacks] (количество зафиксированных атак) WAF‑ноды `node.example.local`.
    
    Вы можете настроить мониторинг любых метрик, [доступных для WAF‑ноды][doc-available-metrics].

Перейдите в браузере по адресу `http://10.0.30.30:3000`, чтобы попасть в веб-консоль Grafana и войдите в консоль, используя стандартные логин (`admin`) и пароль (`admin`). 

Для мониторинга метрик WAF‑ноды с помощью Grafana требуется:
1.  Подключить источник данных.
2.  Получить требуемые метрики из источника данных.
3.  Настроить отображение этих метрик.

Далее описывается работа со следующими источниками данных:
* InfluxDB,
* Graphite.

##  Подключение источника данных

### InfluxDB

Требуемые шаги для подключения:
1.  На главной странице консоли Grafana нажмите на кнопку *Add data source*.
2.  Выберите тип источника данных «InfluxDB».
3.  Введите необходимые параметры для настройки источника данных:
    *   Name: InfluxDB
    *   URL: `http://influxdb:8086`
    *   Database: `collectd`
    *   User: `root`
    *   Password: `root`
4.  Нажмите на кнопку *Save & Test*.

### Graphite

Требуемые шаги для подключения:
1.  На главной странице консоли Grafana нажмите на кнопку *Add data source*.
2.  Выберите тип источника данных «Graphite».
3.  Введите необходимые параметры для настройки источника данных:
    *   Name: Graphite
    *   URL: `http://graphite:8080`.
    *   Version: выберите наиболее новую доступную версию из выпадающего списка.
4. Нажмите на кнопку *Save & Test*.

!!! info "Проверка состояния источника данных"
    При успешном подключении любого источника данных должно появиться сообщение «Data source is working».

### Дальнейшие действия

Чтобы Grafana могла мониторить метрику:
1.  Нажмите на иконку Grafana в левом верхнем углу консоли, чтобы вернуться на главную страницу.
2.  Создайте новый дэшборд, нажав на кнопку *New dashboard*. Далее добавьте на дэшборд [запрос][anchor-query] для получения метрики, нажав на кнопку *Add Query*.

##  Получение метрик из источника данных

### InfluxDB

Чтобы получить метрику из источника данных:
1.  Выберите созданный источник данных «InfluxDB» из выпадающего списка *Query*.
2.  Сконструируйте запрос к InfluxDB:
    *   либо с помощью графического конструктора запросов:
     
        ![!Графический конструктор запросов][img-influxdb-query-graphical]

    * либо введя запрос вручную, нажав на кнопку *Toggle text edit mode* (кнопка подсвечена на скриншоте):
    
        ![!Текстовый конструктор запросов][img-influxdb-query-plaintext]

Запрос для получения метрики `curl_json-wallarm_nginx/gauge-attacks` выглядит следующим образом:

```
SELECT value FROM curl_json_value WHERE (host = 'node.example.local' AND instance = 'wallarm_nginx' AND type = 'gauge' AND type_instance = 'attacks')
```

### Graphite

Чтобы получить метрику из источника данных:
1.  Выберите созданный источник данных «Graphite» из выпадающего списка *Query*.
2.  Последовательно выберите нажатием на кнопку *select metric* части требуемой метрики в строке *Series*.

    Для метрики `curl_json-wallarm_nginx/gauge-attacks` необходимо выбрать следующие элементы метрики:

    1.  Имя хоста (было задано ранее в файле конфигурации плагина `write_graphite`). По умолчанию плагин использует символ `_` в качестве разделителя, поэтому доменное имя `node.example.local` преобразуется в `node_example_local`.
    2.  Имя плагина `collectd`, который предоставляет конкретное значение: `curl_json`.
    3.  Имя инстанса плагина: `wallarm_nginx`.
    4.  Тип величины: `gauge`.
    5.  Имя величины: `attacks`.
    
### Дальнейшие действия

После создания запроса для получения метрики настройте ее отображение.

##  Настройка отображения метрики 

Перейдите из редактора запросов на вкладку «Visualization» и выберите визуализацию метрики.

Для метрики `curl_json-wallarm_nginx/gauge-attacks` мы рекомендуем использовать визуализацию «Gauge»:
1.  Выберите *Calc: Last* для отображения текущего значения метрики.
2.  При необходимости вы можете настроить пороги допустимых значений (англ. «thresholds») и другие параметры.

![!Настройка отображения метрики][img-query-visualization]

### Дальнейшие действия

После настройки отображения метрики:
*   Завершите настройку, нажав на кнопку *«←»* в верхнем левом углу консоли Grafana.
*   Сохраните внесенные в дэшборд изменения.
*   Проверьте, что Grafana успешно мониторит настроенную метрику.

##  Проверка работы мониторинга Grafana

После того, как вы подключили один из источников данных, а также настроили запрос для получения метрики `curl_json-wallarm_nginx/gauge-attacks` и отображение этой метрики, проверьте работу мониторинга:
1.  Включите автоматическое обновление метрики каждые пять секунд (выберите значение из выпадающего списка в правом верхнем углу консоли Grafana).
2.  Убедитесь, что текущее количество атак на дэшборде Grafana совпадает с выводом `wallarm-status` на WAF‑ноде:

    --8<-- "../include/monitoring/wallarm-status-check.md"
   
    ![!Количество атак в Grafana][img-grafana-0-attacks]

3.  Выполните тестовую атаку на приложение, защищенное WAF‑нодой. Для этого можно выполнить команду `curl` с вредоносным запросом к приложению или выполнить этот запрос в браузере.

    --8<-- "../include/monitoring/sample-malicious-request.md"

4.  Убедитесь, что счетчик атак увеличился как в выводе `wallarm-status`, так и на дэшборде Grafana:
    
    --8<-- "../include/monitoring/wallarm-status-output.md"

    ![!Обновленное количество атак в Grafana][img-grafana-16-attacks]

Теперь в дэшборде Grafana отображаются значения метрики `curl_json-wallarm_nginx/gauge-attacks` для WAF‑ноды `node.example.local`.
