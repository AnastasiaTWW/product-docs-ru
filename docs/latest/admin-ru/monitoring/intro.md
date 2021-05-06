[link-collectd]:            https://collectd.org/

[doc-bruteforce]:           ../../attacks-vulns-list.md#брутфорс-англ-bruteforce-attack
[doc-postanalitycs]:        ../installation-postanalytics-ru.md

[link-collectd-naming]:     https://collectd.org/wiki/index.php/Naming_schema
[link-data-source]:         https://collectd.org/wiki/index.php/Data_source
[link-collectd-networking]: https://collectd.org/wiki/index.php/Networking_introduction
[link-collectd-nagios]:     https://collectd.org/wiki/index.php/Collectd-nagios
[link-influxdb]:            https://www.influxdata.com/products/influxdb-overview/
[link-grafana]:             https://grafana.com/
[link-graphite]:            https://github.com/graphite-project/graphite-web
[link-network-plugin]:      https://collectd.org/wiki/index.php/Plugin:Network
[link-write-plugins]:       https://collectd.org/wiki/index.php/Table_of_Plugins
[link-nagios-format]:       https://nagios-plugins.org/doc/guidelines.html#AEN200
[link-nagios]:              https://www.nagios.org/
[link-zabbix]:              https://www.zabbix.com/
[link-selinux]:             https://www.redhat.com/en/topics/linux/what-is-selinux

[doc-available-metrics]:    available-metrics.md
[doc-network-plugin]:       fetching-metrics.md#выгрузка-метрик-с-помощью-плагина-network
[doc-write-plugins]:        fetching-metrics.md#выгрузка-метрик-с-помощью-writeплагина-collectd
[doc-collectd-nagios]:      fetching-metrics.md#выгрузка-метрик-с-помощью-утилиты-collectd-nagios
[doc-collectd-notices]:     fetching-metrics.md#отправка-уведомлений-от-collectd

[doc-selinux]:  ../configure-selinux.md

# Введение в работу мониторинга

Вы можете мониторить состояние WAF‑ноды с помощью предоставляемых нодой метрик. Их сбор осуществляется [`collectd`][link-collectd], установленным на каждой ноде. 

`collectd` предоставляет несколько способов передачи данных, что позволяет направить поток метрик во множество систем мониторинга для контроля состояния WAF‑нод Валарм.

## Необходимость мониторинга

Отказ или нестабильная работа модуля Валарм могут привести к полному или частичному отказу в обслуживании пользовательских запросов к защищаемому WAF‑нодой приложению.

Отказ или нестабильная работа модуля постаналитики может привести к недоступности следующей функциональности:
*   Выгрузка данных об атаках в облако Валарм. В результате этого атаки перестанут отображаться на портале Валарм.
*   Обнаружение поведенческих атак (см. [«брутфорс»][doc-bruteforce]).
*   Получение сведений о структуре защищаемого приложения.

Вы можете осуществлять мониторинг как модуля Валарм, так и модуля постаналитики (в том числе, если он [установлен отдельно][doc-postanalitycs]).

!!! info "Формы мониторинга"
    Все документы, описывающие настройку мониторинга WAF‑ноды, пригодны для настройки мониторинга:
    
    *   Отдельно развернутого модуля Валарм.
    *   Отдельно развернутого модуля постаналитики.
    *   Совместно развернутых модулей Валарм и постаналитики.

##  Необходимые условия для работы мониторинга

Для функционирования мониторинга требуется, чтобы:
* NGINX отдавал статистику работы WAF‑ноды (`wallarm_status on`),
* нода находилась в [режиме](../configure-wallarm-mode.md#возможные-режимы-фильтрации) `monitoring`/`block`.

По умолчанию статистика доступна по адресу `http://127.0.0.8/wallarm_status`.

Если вы настроили отображение статистики так, чтобы для этого использовался нестандартный адрес, вам необходимо внести этот адрес в файл конфигурации `collectd` в параметр `URL`. Расположение этого файла зависит от типа вашего дистрибутива:

--8<-- "../include/monitoring/collectd-config-location.md"


Если используется нестандартный IP‑адрес или порт для Tarantool, необходимо внести эту информацию в файл настроек Tarantool. Расположение этого файла зависит от типа вашего дистрибутива:

--8<-- "../include/monitoring/tarantool-config-location.md"


Если на системе с WAF‑нодой установлен SELinux, [убедитесь, что он настроен или отключен][doc-selinux]. В этом руководстве для упрощения предполагается, что SELinux отключен.

##  Вид метрик

### Как выглядят метрики `collectd`

Метрики `collectd` имеют следующий вид:

```
host/plugin[-plugin_instance]/type[-type_instance]
```

Где:
*   `host` — полное доменное имя хоста (англ. Fully Qualified Domain Name, FQDN), для которого получается метрика.
*   `plugin` — имя плагина, с помощью которого получается метрика.
*   `-plugin_instance` — инстанс плагина, если он есть.
*   `type` — тип значения метрики. Допустимые типы:
    *   `counter`, 
    *   `derive`, 
    *   `gauge`. 
    
    Подробная информация о типах значения доступна [здесь][link-data-source].
    
*   `-type_instance` — инстанс типа (тип инстанса эквивалентен величине, метрику для которой мы хотим получить), если он есть.



Полная расшифровка иерархии в имени метрики доступна [здесь][link-collectd-naming].

### Как выглядят метрики `collectd`, специфичные для Валарм

На WAF‑ноде используется `collectd`, собирающий метрики, специфичные для Валарм.

Метрики для NGINX с модулем Валарм, собираемые `collectd`, имеют следующий вид:

```
host/curl_json-wallarm_nginx/type-type_instance
```

Метрики для модуля постаналитики, собираемые `collectd`, имеют следующий вид:

```
host/wallarm-tarantool/type-type_instance
```

!!! info "Примеры метрик"
    Для хоста `node.example.local` с WAF‑нодой: 
    
    *   Метрика, описывающая количество зафиксированных атак:
                
        ```
        node.example.local/curl_json-wallarm_nginx/gauge-attacks
        ```
    
    *   Метрика, описывающая задержку экспорта в Tarantool в секундах:
       
        ```
        node.example.local/wallarm-tarantool/gauge-export_delay
        ```
    
    Полный список метрик, которые могут использоваться для мониторинга, доступен [здесь][doc-available-metrics].


##  Способы получения метрик

Вы можете собрать метрики с WAF‑ноды несколькими способами:
*   С помощью выгрузки данных напрямую из `collectd`.
    
    Такую выгрузку можно настроить следующим образом:

    *   [С помощью плагина Network для `collectd`][doc-network-plugin].
        
        Этот [плагин][link-network-plugin] позволяет `collectd` выгружать метрики с WAF‑ноды на сервер [`collectd`][link-collectd-networking] или в базу данных [InfluxDB][link-influxdb].
        
        !!! info "InfluxDB"
            Может использоваться для агрегации метрик, поступающих от `collectd` и других источников данных, с их последующей визуализацией (например, с помощью системы мониторинга [Grafana][link-grafana]).
        
    *   [С помощью одного из write‑плагинов для `collectd`][doc-write-plugins].
        
        Например, плагин `write_graphite` позволяет передавать собранные данные в [Graphite][link-graphite].
        
        !!! info "Graphite"
            Может использоваться в качестве источника данных для систем мониторинга и визуализации (например, [Grafana][link-grafana]).

    Этот способ получения метрик поддерживается WAF‑нодами, которые:
    
    *   развернуты в облаках Amazon AWS, Google Cloud;
    *   установлены на Linux для платформ NGINX/NGINX Plus и Kong.

*   [С помощью выгрузки данных утилитой `collectd‑nagios`][doc-collectd-nagios].

    Эта [утилита][link-collectd-nagios] получает значение заданной метрики от `collectd` (на момент вызова утилиты) и представляет его в [Nagios‑совместимом формате][link-nagios-format].
    
    Этим способом вы можете выгружать метрики с WAF‑ноды в системы мониторинга [Nagios][link-nagios] или [Zabbix][link-zabbix].
    
    Этот способ поддерживается всеми вариантами WAF‑нод.

*   [С помощью отправки уведомлений от `collectd`][doc-collectd-notices] при достижении заданного порогового значения какой-либо метрикой.
    
    Этот способ получения метрик поддерживается всеми вариантами WAF‑нод.