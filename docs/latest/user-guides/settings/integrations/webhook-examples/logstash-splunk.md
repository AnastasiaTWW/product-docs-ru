# Splunk Enterprise через Logstash

## Обзор примера

--8<-- "../include/integrations/webhook-examples/overview.md"

В приведенном примере уведомления о событиях отправляются через вебхуки в сборщик логов Logstash и выгружаются в SIEM‑систему Splunk.

![!Движение вебхука](../../../../images/user-guides/settings/integrations/webhook-examples/logstash/splunk-scheme.png)

## Используемые ресурсы

* [Splunk Enterprise](#настройка-splunk-enterprise) с веб‑интерфейсом на URL `https://109.111.35.11:8000` и с API на URL `https://109.111.35.11:8088`
* [Logstash 7.7.0](#настройка-logstash), установленный на Debian 10.4 (Buster) и доступный по адресу `https://logstash.example.domain.com`
* Доступ администратора к Консоли управления Валарм в [EU‑облаке](https://my.wallarm.com) для [настройки webhook‑интеграции](#настройка-webhookинтеграции)

### Настройка Splunk Enterprise

Логи Logstash отправляются в Splunk HTTP Event Collector с названием `Wallarm Logstash logs` и остальными настройками по умолчанию:

![!Настройка HTTP Event Collector](../../../../images/user-guides/settings/integrations/webhook-examples/splunk/logstash-setup.png)

Для доступа к HTTP Event Collector сгенерирован токен: `93eaeba4-97a9-46c7-abf3-4e0c545fa5cb`.

Более подробная информация о настройке HTTPS Event Collector в Splunk доступна в [официальной документации Splunk](https://docs.splunk.com/Documentation/Splunk/8.0.5/Data/UsetheHTTPEventCollector).

### Настройка Logstash

Настройка Logstash описана в конфигурационном файле `logstash-sample.conf`:

* Обработка входящих вебхуков настроена в секции `input`:
    * Весь HTTP и HTTPS‑трафик поступает на порт Logstash 5044
    * SSL‑сертификат для HTTPS‑подключения расположен в файле `/etc/pki/ca.pem`
* Отправка логов в Splunk и вывод логов настроены в секции `output`:
    * Логи из Logstash в Splunk отправляются в формате JSON
    * Логи всех событий из Logstash отправляются через POST‑запрос к Splunk API на эндпоинт `https://109.111.35.11:8088/services/collector/raw`. Для авторизации запросов используется токен HTTPS Event Collector
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
  http { # output‑плагин для отправки логов из Logstash по протоколу HTTP/HTTPS
    format => "json" # формат отправки логов 
    http_method => "post" # HTTP‑метод для отправки запросов
    url => "https://109.111.35.11:8088/services/collector/raw" # эндпоинт для отправки HTTP‑запросов
    headers => ["Authorization", "Splunk 93eaeba4-97a9-46c7-abf3-4e0c545fa5cb"] # HTTP‑заголовки для авторизации запросов
  }
  stdout {} # output‑плагин для вывода логов Logstash в командную строку
}
```

Более подробное описание конфигурационного файла доступно в [официальной документации Logstash](https://www.elastic.co/guide/en/logstash/current/configuration-file-structure.html).

!!! info "Тестирование настроек Logstash"
    Чтобы протестировать запись логов в Logstash и выгрузку данных в Splunk, можно отправить POST‑запрос в Logstash.

    **Пример запроса:**
    ```curl
    curl -X POST 'https://logstash.example.domain.com' -H "Content-Type: application/json" -H "Authorization: Splunk 93eaeba4-97a9-46c7-abf3-4e0c545fa5cb" -d '{"key1":"value1", "key2":"value2"}'
    ```

    **Логи Logstash:**
    ![!Логи Logstash](../../../../images/user-guides/settings/integrations/webhook-examples/logstash/splunk-curl-log.png)

    **Событие Splunk:**
    ![!Событие Splunk](../../../../images/user-guides/settings/integrations/webhook-examples/splunk/logstash-curl-log.png)

### Настройка webhook‑интеграции

--8<-- "../include/integrations/webhook-examples/create-logstash-webhook.md"

![!Webhook-интеграция с Logstash](../../../../images/user-guides/settings/integrations/webhook-examples/logstash/add-webhook-integration.png)

## Тестирование примера

--8<-- "../include/integrations/webhook-examples/send-test-webhook.md"

В логах Logstash появится запись:

![!Запись о новом пользователе в логах Logstash](../../../../images/user-guides/settings/integrations/webhook-examples/logstash/splunk-user-log.png)

В событиях Splunk появится запись:

![!Карточка о новом пользователе Logstash в Splunk](../../../../images/user-guides/settings/integrations/webhook-examples/splunk/logstash-user.png)