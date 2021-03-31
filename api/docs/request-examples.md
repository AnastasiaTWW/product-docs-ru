# Примеры запросов к Валарм API

Ниже приведены примеры запросов к Валарм API. Вы также можете сгенерировать пример кода из интерфейса справочника API по ссылке для [EU‑облака](https://apiconsole.eu1.wallarm.com/) или для [RU‑облака](https://apiconsole.ru1.wallarm.ru/) или посмотреть реальные запросы через консоль разработчика в браузере. Более подробная информация о консоли разработчика приведена в документации браузеров: [Safari](https://support.apple.com/guide/safari/use-the-developer-tools-in-the-develop-menu-sfri20948/mac), [Chrome](https://developers.google.com/web/tools/chrome-devtools/), [Firefox](https://developer.mozilla.org/en-US/docs/Tools), [Vivaldi](https://help.vivaldi.com/article/developer-tools/).

## Получение первых 50 атак за последние 24 часа

Значение `TIMESTAMP` необходимо заменить на дату 24 часа назад в формате [Unix Timestamp](https://www.unixtimestamp.com/).

=== "EU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.com/v1/objects/attack" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"filter\": { \"clientid\": [YOUR_CLIENT_ID], \"time\": [[TIMESTAMP, null]] }, \"offset\": 0, \"limit\": 50, \"order_by\": \"last_time\", \"order_desc\": true}"
    ```
=== "RU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.ru/v1/objects/attack" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"filter\": { \"clientid\": [YOUR_CLIENT_ID], \"time\": [[TIMESTAMP, null]] }, \"offset\": 0, \"limit\": 50, \"order_by\": \"last_time\", \"order_desc\": true}"
    ```

## Получение первых 50 инцидентов за последние 24 часа

Для получения инцидентов используется запрос, приведенный в примере выше, с параметром `"!vulnid": null`. Параметр указывает, что необходимо вернуть атаки, которые не содержат ID обнаруженных уязвимостей.

Значение `TIMESTAMP` необходимо заменить на дату 24 часа назад в формате [Unix Timestamp](https://www.unixtimestamp.com/).

=== "EU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.com/v1/objects/attack" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"filter\": { \"clientid\": [YOUR_CLIENT_ID], \"\!vulnid\": null, \"time\": [[TIMESTAMP, null]] }, \"offset\": 0, \"limit\": 50, \"order_by\": \"last_time\", \"order_desc\": true}"
    ```
=== "RU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.ru/v1/objects/attack" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"filter\": { \"clientid\": [YOUR_CLIENT_ID], \"\!vulnid\": null, \"time\": [[TIMESTAMP, null]] }, \"offset\": 0, \"limit\": 50, \"order_by\": \"last_time\", \"order_desc\": true}"
    ```

## Получение первых 50 уязвимостей в статусе "активная" в течение последних 24 часов

Значение `TIMESTAMP` необходимо заменить на дату 24 часа назад в формате [Unix Timestamp](https://www.unixtimestamp.com/).

=== "EU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.com/v1/objects/vuln" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"limit\":50, \"offset\":0, \"filter\":{\"clientid\":[YOUR_CLIENT_ID], \"testrun_id\":null, \"validated\":true, \"time\":[[TIMESTAMP, null]]}}"
    ```
=== "RU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.ru/v1/objects/vuln" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"limit\":50, \"offset\":0, \"filter\":{\"clientid\":[YOUR_CLIENT_ID], \"testrun_id\":null, \"validated\":true, \"time\":[[TIMESTAMP, null]]}}"
    ```

## Получение настроенных правил обработки запросов

=== "EU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.com/v1/objects/hint" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"filter\":{\"clientid\": [YOUR_CLIENT_ID]},\"order_by\": \"updated_at\",\"order_desc\": true,\"limit\": 1000,\"offset\": 0}"
    ```
=== "RU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.ru/v1/objects/hint" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"filter\":{\"clientid\": [YOUR_CLIENT_ID]},\"order_by\": \"updated_at\",\"order_desc\": true,\"limit\": 1000,\"offset\": 0}"
    ```

## Получение настроенных условий блокировки запросов

=== "EU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.com/v1/objects/action" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"filter\": { \"clientid\": [YOUR_CLIENT_ID] }, \"offset\": 0, \"limit\": 1000}"
    ```
=== "RU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.ru/v1/objects/action" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"filter\": { \"clientid\": [YOUR_CLIENT_ID] }, \"offset\": 0, \"limit\": 1000}"
    ```

## Получение правил по ID условия

=== "EU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.com/v1/objects/hint" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"filter\":{\"clientid\": [YOUR_CLIENT_ID],\"actionid\": YOUR_CONDITION_ID},\"limit\": 1000,\"offset\": 0}"
    ```
=== "RU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.ru/v1/objects/hint" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"filter\":{\"clientid\": [YOUR_CLIENT_ID],\"actionid\": YOUR_CONDITION_ID},\"limit\": 1000,\"offset\": 0}"
    ```

## Создание виртуального патча для блокировки всех запросов к `/my/api/*`

=== "EU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.com/v1/objects/hint/create" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"clientid\": YOUR_CLIENT_ID, \"type\": \"vpatch\", \"action\": [ {\"type\":\"equal\",\"value\":\"my\",\"point\":[\"path\",0]}, {\"type\":\"equal\",\"value\":\"api\",\"point\":[\"path\",1]}, {\"type\":\"equal\",\"value\":\"endpoint\",\"point\":[\"header\",\"2\"]}], \"validated\": false, \"point\": [ [ \"header\", \"HOST\" ] ], \"attack_type\": \"any\"}"
    ```
=== "RU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.ru/v1/objects/hint/create" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"clientid\": YOUR_CLIENT_ID, \"type\": \"vpatch\", \"action\": [ {\"type\":\"equal\",\"value\":\"my\",\"point\":[\"path\",0]}, {\"type\":\"equal\",\"value\":\"api\",\"point\":[\"path\",1]}, {\"type\":\"equal\",\"value\":\"endpoint\",\"point\":[\"header\",\"2\"]}], \"validated\": false, \"point\": [ [ \"header\", \"HOST\" ] ], \"attack_type\": \"any\"}"
    ```

## Создание виртуального патча для блокировки всех запросов к `/my/api/*` для ID отдельного приложения

ID приложения указывается в параметре `action.value`.

=== "EU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.com/v1/objects/hint/create" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"type\":\"vpatch\",\"action\":[{\"point\":[\"instance\"],\"type\":\"equal\",\"value\":\"-1\",\"weight\":102},{\"point\":[\"path\",0],\"type\":\"equal\",\"value\":\"my\",\"weight\":72},{\"point\":[\"path\",1],\"type\":\"equal\",\"value\":\"api\",\"weight\":72},{\"point\":[\"header\",\"2\"],\"type\":\"equal\",\"value\":\"endpoint\",\"weight\":42}],\"clientid\":YOUR_CLIENT_ID,\"validated\":false,\"point\":[[\"header\",\"HOST\"]],\"attack_type\":\"any\"}"
    ```
=== "RU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.ru/v1/objects/hint/create" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"type\":\"vpatch\",\"action\":[{\"point\":[\"instance\"],\"type\":\"equal\",\"value\":\"-1\",\"weight\":102},{\"point\":[\"path\",0],\"type\":\"equal\",\"value\":\"my\",\"weight\":72},{\"point\":[\"path\",1],\"type\":\"equal\",\"value\":\"api\",\"weight\":72},{\"point\":[\"header\",\"2\"],\"type\":\"equal\",\"value\":\"endpoint\",\"weight\":42}],\"clientid\":YOUR_CLIENT_ID,\"validated\":false,\"point\":[[\"header\",\"HOST\"]],\"attack_type\":\"any\"}"
    ```

## Создание правила для блокировки всех запросов с определенными значениями заголовков HOST и X-FORWARDED-FOR

Правило блокирует все запросы к `MY.DOMAIN.COM`, кроме запросов с IP-адресом `44.33.22.11` в значении заголовка `X-FORWARDED-FOR`.

=== "EU‑облако"
    ```bash
    curl -v -X POST "https://api.wallarm.com/v1/objects/hint/create" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"type\":\"regex\",\"action\":[{\"point\":[\"header\",\"HOST\"],\"type\":\"equal\",\"value\":\"MY.DOMAIN.NAME\"}],\"clientid\":YOUR_CLIENT_ID,\"validated\":false,\"comment\":\"comment\",\"point\":[[\"header\",\"X-FORWARDED-FOR\"]],\"attack_type\":\"scanner\",\"regex\":\"^\(~\(44[.]33[.]22[.]11\)\)$\"}"
    ```
=== "RU‑облако"
    ```bash
    curl -v -X POST "https://api.wallarm.ru/v1/objects/hint/create" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"type\":\"regex\",\"action\":[{\"point\":[\"header\",\"HOST\"],\"type\":\"equal\",\"value\":\"MY.DOMAIN.NAME\"}],\"clientid\":YOUR_CLIENT_ID,\"validated\":false,\"comment\":\"comment\",\"point\":[[\"header\",\"X-FORWARDED-FOR\"]],\"attack_type\":\"scanner\",\"regex\":\"^\(~\(44[.]33[.]22[.]11\)\)$\"}"
    ```

## Удаление правила по ID

=== "EU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.com/v1/objects/hint/delete" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"filter\":{\"clientid\":[YOUR_CLIENT_ID],\"id\": YOUR_RULE_ID}}"
    ```
=== "RU‑облако"
    ``` bash
    curl -v -X POST "https://api.wallarm.ru/v1/objects/hint/delete" -H "X-WallarmAPI-UUID: YOUR_UUID" -H "X-WallarmAPI-Secret: YOUR_SECRET_KEY" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"filter\":{\"clientid\":[YOUR_CLIENT_ID],\"id\": YOUR_RULE_ID}}"
    ```
