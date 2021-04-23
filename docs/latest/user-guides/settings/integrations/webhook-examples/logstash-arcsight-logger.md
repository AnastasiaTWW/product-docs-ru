# Micro Focus ArcSight Logger через Logstash

## Обзор примера

--8<-- "../include/integrations/webhook-examples/overview.md"

В приведенном примере уведомления о событиях отправляются через вебхуки в сборщик логов Logstash и выгружаются в систему ArcSight Logger.

![!Движение вебхука](../../../../images/user-guides/settings/integrations/webhook-examples/logstash/arcsight-logger-scheme.png)

!!! info "Интеграция с Enterprise‑версией SIEM‑системы ArcSight ESM"
    Чтобы настроить отправку логов в Enterprise‑версию SIEM‑системы ArcSight ESM через Logstash, рекомендуется настроить Syslog Connector для обработки логов по стандарту Syslog на стороне ArcSight и отправлять логи из Logstash на порт настроенного коннектора. Для получения более подробной информации о коннекторах, скачайте **SmartConnector User Guide** из [официальной документации на коннекторы ArcSight](https://community.microfocus.com/t5/ArcSight-Connectors/ct-p/ConnectorsDocs).

## Используемые ресурсы

* [ArcSight Logger 7.1](#настройка-arcsight-logger), установленный на CentOS 7.8, с веб‑интерфейсом на URL `https://192.168.1.73:443`
* [Logstash 7.7.0](#настройка-logstash), установленный на Debian 10.4 (Buster) и доступный по адресу `https://192.168.1.65:5044`
* Доступ администратора к Консоли управления Валарм в [EU‑облаке](https://my.wallarm.com) для [настройки webhook‑интеграции](#настройка-webhookинтеграции)

Ссылки на сервисы ArcSight Logger и Logstash приведены в документации в качестве примера и недоступны для внешнего использования.

### Настройка ArcSight Logger

На стороне ArcSight Logger настроен получатель логов `Wallarm Logstash logs`:

* Принимает логи по протоколу UDP (`Type = UDP Receiver`)
* Слушает порт `514`
* Применяет к логам парсер syslog
* Использует остальные настройки по умолчанию

![!Настройка получателя логов ArcSight Logger](../../../../images/user-guides/settings/integrations/webhook-examples/arcsight-logger/logstash-setup.png)

Для получения более подробной информации о настройке получателя логов, скачайте **Logger Installation Guide** подходящей версии из [официальной документации на ArcSight Logger](https://community.microfocus.com/t5/Logger-Documentation/ct-p/LoggerDoc).

### Настройка Logstash

Настройка Logstash описана в конфигурационном файле `logstash-sample.conf`:

* Обработка входящих вебхуков настроена в секции `input`:
    * Весь HTTP и HTTPS‑трафик поступает на порт Logstash 5044
    * SSL‑сертификат для HTTPS‑подключения расположен в файле `/etc/pki/ca.pem`
* Отправка логов в ArcSight Logger и вывод логов настроены в секции `output`:
    * Логи всех событий из Logstash отправляются в ArcSight Logger по IP‑адресу `https://192.168.1.73:514`
    * Логи из Logstash в ArcSight Logger отправляются в формате JSON по стандарту [Syslog](https://en.wikipedia.org/wiki/Syslog)
    * Соединение с ArcSight Logger выполняется по протоколу UDP
    * Логи Logstash дополнительно выводятся в командную строку (15 строка кода). Настройка используется для проверки, что события записываются в логи Logstash

```bash linenums="1"
input {
  http { # input‑плагин для HTTP и HTTPS‑трафика
    port => 5044 # порт для входящих запросов
    ssl => true # обработка HTTPS‑трафика
    ssl_certificate => "/etc/pki/ca.pem" # сертификат для HTTPS‑подключения
  }
}
output {
  syslog { # output‑плагин для отправки логов из Logstash по стандарту Syslog
    host => "192.168.1.73" # IP‑адрес, на который отправляются логи
    port => "514" # порт, на который отправляются логи
    protocol => "udp" # протокол соединения
    codec => json # формат отправки логов
  }
  stdout {} # output‑плагин для вывода логов Logstash в командную строку
}
```

Более подробное описание конфигурационного файла доступно в [официальной документации Logstash](https://www.elastic.co/guide/en/logstash/current/configuration-file-structure.html).

!!! info "Тестирование настроек Logstash"
    Чтобы протестировать запись логов в Logstash и выгрузку данных в ArcSight Logger, можно отправить POST‑запрос в Logstash.

    **Пример запроса:**
    ```curl
    curl -X POST 'https://192.168.1.65:5044' -H "Content-Type: application/json" -d '{"key1":"value1", "key2":"value2"}'
    ```

    **Логи Logstash:**
    ![!Логи Logstash](../../../../images/user-guides/settings/integrations/webhook-examples/logstash/arcsight-logger-curl-log.png)

    **Событие в ArcSight Logger:**
    ![!Логи ArcSight Logger](../../../../images/user-guides/settings/integrations/webhook-examples/arcsight-logger/logstash-curl-log.png)

### Настройка webhook‑интеграции

--8<-- "../include/integrations/webhook-examples/create-logstash-webhook-ip.md"

![!Webhook-интеграция с Logstash](../../../../images/user-guides/settings/integrations/webhook-examples/logstash/add-webhook-integration-ip.png)

## Тестирование примера

--8<-- "../include/integrations/webhook-examples/send-test-webhook.md"

В логах Logstash появится запись:

![!Запись о новом пользователе в логах Logstash](../../../../images/user-guides/settings/integrations/webhook-examples/logstash/arcsight-logger-user-log.png)

В событиях ArcSight Logger появится запись:

![!Карточка о новом пользователе Logstash в ArcSight Logger](../../../../images/user-guides/settings/integrations/webhook-examples/arcsight-logger/logstash-user.png)