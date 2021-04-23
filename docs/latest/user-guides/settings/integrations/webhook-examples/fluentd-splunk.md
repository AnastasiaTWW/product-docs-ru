# Splunk Enterprise через Fluentd

## Обзор примера

--8<-- "../include/integrations/webhook-examples/overview.md"

В приведенном примере уведомления о событиях отправляются через вебхуки в сборщик логов Fluentd и выгружаются в SIEM‑систему Splunk.

![!Движение вебхука](../../../../images/user-guides/settings/integrations/webhook-examples/fluentd/splunk-scheme.png)

## Используемые ресурсы

* [Splunk Enterprise](#настройка-splunk-enterprise) с веб‑интерфейсом на URL `https://109.111.35.11:8000` и с API на URL `https://109.111.35.11:8088`
* [Fluentd](#настройка-fluentd), установленный на Debian 10.4 (Buster) и доступный по адресу `https://fluentd‑example‑domain.com`
* Доступ администратора к Консоли управления Валарм в [EU‑облаке](https://my.wallarm.com) для [настройки webhook‑интеграции](#настройка-webhookинтеграции)

Ссылки на сервисы Splunk Enterprise и Fluentd приведены в документации в качестве примера и недоступны для внешнего использования.

### Настройка Splunk Enterprise

Логи Fluentd отправляются в Splunk HTTP Event Collector с названием `Wallarm Fluentd logs` и остальными настройками по умолчанию:

![!Настройка HTTP Event Collector](../../../../images/user-guides/settings/integrations/webhook-examples/splunk/fluentd-setup.png)

Для доступа к HTTP Event Collector сгенерирован токен: `f44b3179-91aa-44f5-a6f7-202265e10475`.

Более подробная информация о настройке HTTPS Event Collector в Splunk доступна в [официальной документации Splunk](https://docs.splunk.com/Documentation/Splunk/8.0.5/Data/UsetheHTTPEventCollector).

### Настройка Fluentd

Настройка Fluentd описана в конфигурационном файле `td-agent.conf`:

* Обработка входящих вебхуков настроена в директиве `source`:
    * Весь HTTP и HTTPS‑трафик поступает на порт Fluentd 9880
    * Сертификат для подключения к Fluentd по HTTPS расположен в файле `/etc/ssl/certs/fluentd.crt`
    * Приватный ключ сертификата расположен в файле `/etc/ssl/private/fluentd.key`
* Отправка логов в Splunk и вывод логов настроены в директиве `match`:
    * Логи всех событий копируются из Fluentd и отправляются в Splunk HTTP Event Controller через output‑плагин [fluent-plugin-splunk-hec](https://github.com/splunk/fluent-plugin-splunk-hec)
    * Логи Fluentd дополнительно выводятся в командную строку в формате JSON (19-22 строки кода). Настройка используется для проверки, что события записываются в логи Fluentd

```bash linenums="1"
<source>
  @type http # input‑плагин для HTTP и HTTPS‑трафика
  port 9880 # порт для входящих запросов
  <transport tls> # сертификаты для HTTPS‑подключения к Fluentd
    cert_path /etc/ssl/certs/fluentd.crt
    private_key_path /etc/ssl/private/fluentd.key
  </transport>
</source>
<match **>
  @type copy
  <store>
      @type splunk_hec # output‑плагин fluent-plugin-splunk-hec для отправки логов из Fluentd в Splunk API через HTTP Event Controller
      hec_host 109.111.35.11 # адрес Splunk
      hec_port 8088 # порт Splunk API
      hec_token f44b3179-91aa-44f5-a6f7-202265e10475 # токен HTTP Event Controller
    <format>
      @type json # формат отправки логов в Splunk
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
    Чтобы протестировать запись логов в Fluentd и выгрузку данных в Splunk, можно отправить POST или PUT‑запрос в Fluentd.

    **Пример запроса:**
    ```curl
    curl -X POST 'https://fluentd‑example‑domain.com' -H "Content-Type: application/json" -H "Authorization: Splunk f44b3179-91aa-44f5-a6f7-202265e10475" -d '{"key1":"value1", "key2":"value2"}'
    ```

    **Логи Fluentd:**
    ![!Логи Fluentd](../../../../images/user-guides/settings/integrations/webhook-examples/fluentd/splunk-curl-log.png)

    **Событие в Splunk:**
    ![!События Splunk](../../../../images/user-guides/settings/integrations/webhook-examples/splunk/fluentd-curl-log.png)

### Настройка webhook‑интеграции

--8<-- "../include/integrations/webhook-examples/create-fluentd-webhook.md"

![!Webhook-интеграция с Fluentd](../../../../images/user-guides/settings/integrations/webhook-examples/fluentd/add-webhook-integration.png)

## Тестирование примера

--8<-- "../include/integrations/webhook-examples/send-test-webhook.md"

В логах Fluentd появится запись:

![!Запись о новом пользователе в логах Fluentd](../../../../images/user-guides/settings/integrations/webhook-examples/fluentd/splunk-user-log.png)

В событиях Splunk появится запись:

![!Карточка о новом пользователе Fluentd в Splunk](../../../../images/user-guides/settings/integrations/webhook-examples/splunk/fluentd-user.png)