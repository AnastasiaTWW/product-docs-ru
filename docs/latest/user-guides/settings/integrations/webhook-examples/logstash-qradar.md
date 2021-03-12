# IBM QRadar через Logstash

## Обзор примера

--8<-- "../include/integrations/webhook-examples/overview.md"

В приведенном примере уведомления о событиях отправляются через вебхуки в сборщик логов Logstash и выгружаются в SIEM‑систему QRadar.

![!Движение вебхука](../../../../images/user-guides/settings/integrations/webhook-examples/logstash/splunk-scheme.png)

## Используемые ресурсы

* [Logstash 7.7.0](#настройка-logstash), установленный на Debian 10.4 (Buster) и доступный по адресу `https://logstash.example.domain.com`
* [QRadar V7.3.3](#настройка-qradar-опционально), установленный на Linux Red Hat и доступный по IP‑адресу `https://109.111.35.11:514`
* Доступ администратора к Консоли управления Валарм в [EU‑облаке](https://my.wallarm.com) для [настройки webhook‑интеграции](#настройка-webhookинтеграции)

### Настройка Logstash

Настройка Logstash описана в конфигурационном файле `logstash-sample.conf`:

* Обработка входящих вебхуков настроена в секции `input`:
    * Весь HTTP и HTTPS‑трафик поступает на порт Logstash 5044
    * SSL‑сертификат для HTTPS‑подключения расположен в файле `/etc/pki/ca.pem`
* Отправка логов в QRadar и вывод логов настроены в секции `output`:
    * Логи всех событий из Logstash отправляются в QRadar по IP‑адресу `https://109.111.35.11:514`
    * Логи из Logstash в QRadar отправляются в формате JSON по стандарту [Syslog](https://en.wikipedia.org/wiki/Syslog)
    * Соединение с QRadar выполняется по протоколу TCP
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
    host => "109.111.35.11" # IP‑адрес, на который отправляются логи
    port => "514" # порт, на который отправляются логи
    protocol => "tcp" # протокол соединения
    codec => json # формат отправки логов
  }
  stdout {} # output‑плагин для вывода логов Logstash в командную строку
}
```

Более подробное описание конфигурационного файла доступно в [официальной документации Logstash](https://www.elastic.co/guide/en/logstash/current/configuration-file-structure.html).

!!! info "Тестирование настроек Logstash"
    Чтобы протестировать запись логов в Logstash и выгрузку данных в QRadar, можно отправить POST‑запрос в Logstash.

    **Пример запроса:**
    ```curl
    curl -X POST 'https://logstash.example.domain.com' -H "Content-Type: application/json" -d '{"key1":"value1", "key2":"value2"}'
    ```

    **Логи Logstash:**
    ![!Логи Logstash](../../../../images/user-guides/settings/integrations/webhook-examples/logstash/qradar-curl-log.png)

    **Логи QRadar:**
    ![!Логи QRadar](../../../../images/user-guides/settings/integrations/webhook-examples/qradar/logstash-curl-log.png)

    **Payload лога в QRadar:**
    ![!Логи QRadar](../../../../images/user-guides/settings/integrations/webhook-examples/qradar/logstash-curl-log-payload.png)

### Настройка QRadar (опционально)

На стороне QRadar выполнена настройка источника логов. Это позволяет отличать логи Logstash от остального списка логов в QRadar, а также может использоваться для дальнейшей сортировки логов. Источник логов настроен следующим образом:

* **Log Source Name**: название источника логов `Logstash`
* **Log Source Description**: описание источника логов `Logs from Logstash`
* **Log Source Type**: тип парсера для входящих логов `Universal LEEF`, используется для стандарта Syslog
* **Protocol Configuration**: стандарт передачи логов `Syslog`
* **Log Source Identifier**: идентификатор источника логов, используется IP‑адрес Logstash
* Остальные настройки по умолчанию

Более подробная информация о настройке источника логов в QRadar доступна в [официальной документации IBM](https://www.ibm.com/support/knowledgecenter/en/SS42VS_DSM/com.ibm.dsm.doc/b_dsm_guide.pdf?origURL=SS42VS_DSM/b_dsm_guide.pdf).

![!Настройка источника логов Logstash в QRadar](../../../../images/user-guides/settings/integrations/webhook-examples/qradar/logstash-setup.png)

### Настройка webhook‑интеграции

--8<-- "../include/integrations/webhook-examples/create-logstash-webhook.md"

![!Webhook-интеграция с Logstash](../../../../images/user-guides/settings/integrations/webhook-examples/logstash/add-webhook-integration.png)

## Тестирование примера

--8<-- "../include/integrations/webhook-examples/send-test-webhook.md"

В логах Logstash появится запись:

![!Запись о новом пользователе в логах Logstash](../../../../images/user-guides/settings/integrations/webhook-examples/logstash/qradar-user-log.png)

В payload лога в QRadar отобразится лог Logstash:

![!Карточка о новом пользователе Logstash в QRadar](../../../../images/user-guides/settings/integrations/webhook-examples/qradar/logstash-user.png)