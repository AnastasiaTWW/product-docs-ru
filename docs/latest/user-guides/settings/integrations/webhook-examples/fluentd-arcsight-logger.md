# Micro Focus ArcSight Logger через Fluentd

## Обзор примера

--8<-- "../include/integrations/webhook-examples/overview.md"

В приведенном примере уведомления о событиях отправляются через вебхуки в сборщик логов Fluentd и выгружаются в систему ArcSight Logger.

![!Движение вебхука](../../../../images/user-guides/settings/integrations/webhook-examples/fluentd/arcsight-logger-scheme.png)

!!! info "Интеграция с Enterprise‑версией SIEM‑системы ArcSight ESM"
    Чтобы настроить отправку логов в Enterprise‑версию SIEM‑системы ArcSight ESM через Fluentd, рекомендуется настроить Syslog Connector для обработки логов по стандарту Syslog на стороне ArcSight и отправлять логи из Fluentd на порт настроенного коннектора. Для получения более подробной информации о коннекторах, скачайте **SmartConnector User Guide** из [официальной документации на коннекторы ArcSight](https://community.microfocus.com/t5/ArcSight-Connectors/ct-p/ConnectorsDocs).

## Используемые ресурсы

* [ArcSight Logger 7.1](#настройка-arcsight-logger), установленный на CentOS 7.8, с веб‑интерфейсом на URL `https://192.168.1.73:443`
* [Fluentd](#настройка-fluentd), установленный на Debian 10.4 (Buster) и доступный по адресу `https://192.168.1.65:9880`
* Доступ администратора к Консоли управления Валарм в [EU‑облаке](https://my.wallarm.com) для [настройки webhook‑интеграции](#настройка-webhookинтеграции)

Ссылки на сервисы ArcSight Logger и Fluentd приведены в документации в качестве примера и недоступны для внешнего использования.

### Настройка ArcSight Logger

На стороне ArcSight Logger настроен получатель логов `Wallarm Fluentd logs`:

* Принимает логи по протоколу UDP (`Type = UDP Receiver`)
* Слушает порт `514`
* Применяет к логам парсер syslog
* Использует остальные настройки по умолчанию

![!Настройка получателя логов ArcSight Logger](../../../../images/user-guides/settings/integrations/webhook-examples/arcsight-logger/fluentd-setup.png)

Для получения более подробной информации о настройке получателя логов, скачайте **Logger Installation Guide** подходящей версии из [официальной документации на ArcSight Logger](https://community.microfocus.com/t5/Logger-Documentation/ct-p/LoggerDoc).

### Настройка Fluentd

Настройка Fluentd описана в конфигурационном файле `td-agent.conf`:

* Обработка входящих вебхуков настроена в директиве `source`:
    * Весь HTTP и HTTPS‑трафик поступает на порт Fluentd 9880
    * Сертификат для подключения к Fluentd по HTTPS расположен в файле `/etc/ssl/certs/fluentd.crt`
    * Приватный ключ сертификата расположен в файле `/etc/ssl/private/fluentd.key`
* Отправка логов в ArcSight Logger и вывод логов настроены в директиве `match`:
    * Логи всех событий копируются из Fluentd и отправляются в ArcSight Logger по IP‑адресу `https://192.168.1.73:514`
    * Логи из Fluentd в ArcSight Logger отправляются в формате JSON по стандарту [Syslog](https://en.wikipedia.org/wiki/Syslog)
    * Соединение с ArcSight Logger выполняется по протоколу UDP
    * Логи Fluentd дополнительно выводятся в командную строку в формате JSON (19-22 строки кода). Настройка используется для проверки, что события записываются в логи Fluentd

```bash linenums="1"
<source>
  @type http # input‑плагин для HTTP и HTTPS‑трафика
  port 9880 # порт для входящих запросов
  <transport tls> # сертификаты для HTTPS‑подключения
    cert_path /etc/ssl/certs/fluentd.crt
    private_key_path /etc/ssl/private/fluentd.key
  </transport>
</source>
<match **>
  @type copy
  <store>
      @type remote_syslog # output‑плагин для отправки логов из Fluentd по стандарту Syslog
      host 192.168.1.73 # IP‑адрес, на который отправляются логи
      port 514 # порт, на который отправляются логи
      protocol udp # протокол соединения
    <format>
      @type json # формат отправки логов
    </format>
  </store>
  <store>
     @type stdout # output‑плагин для вывода логов Fluentd в командную строку
     output_type json # формат вывода логов Fluentd в командную строку
  </store>
</match>
```

Более подробное описание конфигурационного файла доступно в [официальной документации Fluentd](https://docs.fluentd.org/configuration/config-file).

!!! info "Тестирование настроек Fluentd"
    Чтобы протестировать запись логов в Fluentd и выгрузку данных в ArcSight Logger, можно отправить POST‑запрос в Fluentd.

    **Пример запроса:**
    ```curl
    curl -X POST 'https://192.168.1.65:9880' -H "Content-Type: application/json" -d '{"key1":"value1", "key2":"value2"}'
    ```

    **Логи Fluentd:**
    ![!Логи Fluentd](../../../../images/user-guides/settings/integrations/webhook-examples/fluentd/arcsight-logger-curl-log.png)

    **Событие в ArcSight Logger:**
    ![!Логи ArcSight Logger](../../../../images/user-guides/settings/integrations/webhook-examples/arcsight-logger/fluentd-curl-log.png)

### Настройка webhook‑интеграции

--8<-- "../include/integrations/webhook-examples/create-fluentd-webhook-ip.md"

![!Webhook-интеграция с Fluentd](../../../../images/user-guides/settings/integrations/webhook-examples/fluentd/add-webhook-integration-ip.png)

## Тестирование примера

--8<-- "../include/integrations/webhook-examples/send-test-webhook.md"

В логах Fluentd появится запись:

![!Запись о новом пользователе в логах Fluentd](../../../../images/user-guides/settings/integrations/webhook-examples/fluentd/arcsight-logger-user-log.png)

В событиях ArcSight Logger появится запись:

![!Карточка о новом пользователе Fluentd в ArcSight Logger](../../../../images/user-guides/settings/integrations/webhook-examples/arcsight-logger/fluentd-user.png)