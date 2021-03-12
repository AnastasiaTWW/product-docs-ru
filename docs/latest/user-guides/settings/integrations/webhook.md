# Webhook

Вы можете настроить отправку уведомлений в любую систему, которая принимает входящие вебхуки по протоколу HTTPS. Для этого необходимо указать Webhook URL, на который будут отправляться уведомления с деталями о следующих типах событий:

--8<-- "../include/integrations/advanced-events-for-integrations.md"

## Формат уведомлений

Уведомления о событиях отправляются в формате JSON. Набор объектов в JSON зависит от события, для которого отправлено уведомление. Например:

* Обнаружен хит

    ```json
    [
    {
        "anomality": 0.9806949806949808,
        "domain": "example.com",
        "heur_distance": 36.28571421111111,
        "method": "GET",
        "parameter": "GET_id_value",
        "path": "/",
        "payloads": [
        "'or 1=1--"
        ],
        "point": [
        "get",
        "id"
        ],
        "probability": 36.11111118571429,
        "remote_country": null,
        "remote_port": 41616,
        "remote_addr4": "111.17.1.1",
        "remote_addr6": null,
        "datacenter": "unknown",
        "tor": "none",
        "request_time": 1591261367,
        "create_time": 1591261381,
        "response_len": 345,
        "response_status": 404,
        "response_time": 257,
        "stamps": [
        1173
        ],
        "regex": [],
        "stamps_hash": -1888294073,
        "regex_hash": -2147483648,
        "type": "sqli",
        "block_status": "monitored",
        "id": [
        "hits_production_6396_202006_v_1",
        "vpuRfnIBVc0URvOZ6ALA"
        ],
        "object_type": "hit"
    }
    ]
    ```

* Обнаружена уязвимость

    ```json
    [
    {
        "title": "Missing \"Strict-Transport-Security\" header in server's response at '93.184.216.34:443'",
        "source": "93.184.216.34:443",
        "type": "Info",
        "domain": "www.example.com",
        "threat": "Low",
        "link": "https://my.wallarm.com/object/282157",
        "summary": "Обнаружена новая уязвимость"
    }
    ]
    ```

## Настройка интеграции

1. Перейдите в Личный кабинет Валарм → **Настройки** → **Интеграции**.
2. Нажмите на блок **Webhook** или нажмите кнопку **Добавить интеграцию** и выберите **Webhook**.
3. Введите имя интеграции.
4. Введите Webhook URL, на который необходимо отправлять уведомления.
5. Если требуется, задайте дополнительные настройки:

    * **Тип запроса**: `POST` или `PUT`. По умолчанию отправляются POST-запросы.
    * **Заголовок запроса** и значение, если для запроса к серверу требуется передать нестандартный заголовок. Количество заголовков не ограничено.
    * **Сертификат безопасности**, если для запроса к серверу требуется авторизация с помощью SSL‑сертификата.
    * **Время ожидания ответа, сек**: если сервер не отвечает на запрос в течение указанного времени, запрос завершается с ошибкой. По умолчанию: 15 секунд.
    * **Время ожидания соединения, сек**: если в течение указанного времени не удается установить соединение с сервером, запрос завершается с ошибкой. По умолчанию: 20 секунд.

    ![!Пример дополнительных настроек для webhook-интеграции](../../../images/user-guides/settings/integrations/additional-webhook-settings.png)

6. Выберите типы событий, для которых необходимо отправлять уведомления на указанный Webhook URL. Если события не выбраны, уведомления не отправляются.
7. [Протестируйте интеграцию](#тестирование-интеграции) и убедитесь в корректности настроек.
8. Нажмите **Добавить интеграцию**.

    ![!Добавление интеграции с webhook](../../../images/user-guides/settings/integrations/add-webhook-integration.png)

## Примеры интеграций

--8<-- "../include/integrations/webhook-examples/overview.md"

Примеры для настройки интеграций с популярными сборщиками логов и выгрузки логов в SIEM‑системы описаны по ссылкам ниже:

* Webhook‑интеграция с **Fluentd** с выгрузкой логов в [IBM QRadar](webhook-examples/fluentd-qradar.md), [Splunk Enterprise](webhook-examples/fluentd-splunk.md), [ArcSight Logger](webhook-examples/fluentd-arcsight-logger.md)
* Webhook‑интеграция с **Logstash** с выгрузкой логов в [IBM QRadar](webhook-examples/logstash-qradar.md), [Splunk Enterprise](webhook-examples/logstash-splunk.md), [ArcSight Logger](webhook-examples/logstash-arcsight-logger.md)

## Тестирование интеграции

--8<-- "../include/integrations/test-integration.md"

Пример тестового вебхука:

```
[
  {
    "title": "Test",
    "source": "Wallarm",
    "type": "Info",
    "domain": "example.com",
    "threat": "Medium",
    "link": "https://my.wallarm.com/object/555",
    "summary": "[Тестовое сообщение] Обнаружена новая уязвимость"
  }
]
```

## Редактирование интеграции

--8<-- "../include/integrations/update-integration.md"

## Отключение интеграции

--8<-- "../include/integrations/disable-integration.md"

## Удаление интеграции

--8<-- "../include/integrations/remove-integration.md"