# IBM QRadar через Fluentd

## Обзор примера

--8<-- "../include/integrations/webhook-examples/overview.md"

В приведенном примере уведомления о событиях отправляются через вебхуки в сборщик логов Fluentd и выгружаются в SIEM‑систему QRadar.

![!Движение вебхука](../../../../images/user-guides/settings/integrations/webhook-examples/fluentd/qradar-scheme.png)

## Используемые ресурсы

* [Fluentd](#настройка-fluentd), установленный на Debian 10.4 (Buster) и доступный по адресу `https://fluentd‑example‑domain.com`
* [QRadar V7.3.3](#настройка-qradar-опционально), установленный на Linux Red Hat и доступный по IP‑адресу `https://109.111.35.11:514`
* Доступ администратора к Консоли управления Валарм в [EU‑облаке](https://my.wallarm.com) для [настройки webhook‑интеграции](#настройка-webhookинтеграции)

### Настройка Fluentd

Настройка Fluentd описана в конфигурационном файле `td-agent.conf`:

* Обработка входящих вебхуков настроена в директиве `source`:
    * Весь HTTP и HTTPS‑трафик поступает на порт Fluentd 9880
    * TLS‑сертификат для HTTPS‑подключения расположен в файле `/etc/pki/ca.pem`
* Отправка логов в QRadar и вывод логов настроены в директиве `match`:
    * Логи всех событий копируются из Fluentd и отправляются в QRadar по IP‑адресу `https://109.111.35.11:514`
    * Логи из Fluentd в QRadar отправляются в формате JSON по стандарту [Syslog](https://en.wikipedia.org/wiki/Syslog)
    * Соединение с QRadar выполняется по протоколу TCP
    * Логи Fluentd дополнительно выводятся в командную строку в формате JSON (19-22 строки кода). Настройка используется для проверки, что события записываются в логи Fluentd

```bash linenums="1"
<source>
  @type http # input‑плагин для HTTP и HTTPS‑трафика
  port 9880 # порт для входящих запросов
  <transport tls> # сертификаты для HTTPS‑подключения
    ca_path /etc/pki/ca.pem
  </transport>
</source>
<match **>
  @type copy
  <store>
      @type remote_syslog # output‑плагин для отправки логов из Fluentd по стандарту Syslog
      host 109.111.35.11 # IP‑адрес, на который отправляются логи
      port 514 # порт, на который отправляются логи
      protocol tcp # протокол соединения
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
    Чтобы протестировать запись логов в Fluentd и выгрузку данных в QRadar, можно отправить POST или PUT‑запрос в Fluentd.

    **Пример запроса:**
    ```curl
    curl -X POST 'https://fluentd‑example‑domain.com' -H "Content-Type: application/json" -d '{"key1":"value1", "key2":"value2"}'
    ```

    **Логи Fluentd:**
    ![!Логи Fluentd](../../../../images/user-guides/settings/integrations/webhook-examples/fluentd/qradar-curl-log.png)

    **Логи QRadar:**
    ![!Логи QRadar](../../../../images/user-guides/settings/integrations/webhook-examples/qradar/fluentd-curl-log.png)

    **Payload лога в QRadar:**
    ![!Логи QRadar](../../../../images/user-guides/settings/integrations/webhook-examples/qradar/fluentd-curl-log-payload.png)

### Настройка QRadar (опционально)

На стороне QRadar выполнена настройка источника логов. Это позволяет отличать логи Fluentd от остального списка логов в QRadar, а также может использоваться для дальнейшей сортировки логов. Источник логов настроен следующим образом:

* **Log Source Name**: название источника логов `Fluentd`
* **Log Source Description**: описание источника логов `Logs from Fluentd`
* **Log Source Type**: тип парсера для входящих логов `Universal LEEF`, используется для стандарта Syslog
* **Protocol Configuration**: стандарт передачи логов `Syslog`
* **Log Source Identifier**: идентификатор источника логов, используется IP‑адрес Fluentd
* Остальные настройки по умолчанию

Более подробная информация о настройке источника логов в QRadar доступна в [официальной документации IBM](https://www.ibm.com/support/knowledgecenter/en/SS42VS_DSM/com.ibm.dsm.doc/b_dsm_guide.pdf?origURL=SS42VS_DSM/b_dsm_guide.pdf).

![!Настройка источника логов Fluentd в QRadar](../../../../images/user-guides/settings/integrations/webhook-examples/qradar/fluentd-setup.png)

### Настройка webhook‑интеграции

--8<-- "../include/integrations/webhook-examples/create-fluentd-webhook.md"

![!Webhook-интеграция с Fluentd](../../../../images/user-guides/settings/integrations/webhook-examples/fluentd/add-webhook-integration.png)

## Тестирование примера

--8<-- "../include/integrations/webhook-examples/send-test-webhook.md"

В логах Fluentd появится запись:

![!Запись о новом пользователе в логах Fluentd](../../../../images/user-guides/settings/integrations/webhook-examples/fluentd/qradar-user-log.png)

В payload лога в QRadar отобразится информация о добавленном пользователе в формате JSON:

![!Карточка о новом пользователе Fluentd в QRadar](../../../../images/user-guides/settings/integrations/webhook-examples/qradar/fluentd-user.png)