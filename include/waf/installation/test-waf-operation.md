1. Получите статистику о работе WAF‑ноды, выполнив запрос:

    ```bash
    curl http://127.0.0.8/wallarm-status
    ```

    Запрос вернет статистические данные о проанализированных запросах. Формат ответа приведен ниже, подробное описание параметров доступно по [ссылке][wallarm-status-instr].
    ```
    { "requests":0,"attacks":0,"blocked":0,"abnormal":0,"tnt_errors":0,"api_errors":0,
    "requests_lost":0,"segfaults":0,"memfaults":0,"softmemfaults":0,"time_detect":0,"db_id":46,
    "lom_id":16767,"proton_instances": { "total":1,"success":1,"fallback":0,"failed":0 },
    "stalled_workers_count":0,"stalled_workers":[] }
    ```
2. Отправьте тестовый запрос с атаками [SQLI][sqli-attack-desc] и [XSS][xss-attack-desc] на адрес приложения:

    ```
    curl http://localhost/?id='or+1=1--a-<script>prompt(1)</script>'
    ```

    Если WAF‑нода работает в режиме `block`, запрос будет заблокирован с ответом `403 Forbidden`.
3. Выполните запрос к `wallarm-status` и убедитесь, что значение параметров `requests` и `attacks` увеличилось:

    ```bash
    curl http://127.0.0.8/wallarm-status
    ```
4. Перейдите в Консоль управления Валарм → секция **События** для [EU‑облака](https://my.wallarm.com/search) или для [RU‑облака](https://my.wallarm.ru/search) и убедитесь, что атаки появились в списке.
    ![!Атаки в интерфейсе][img-test-attacks-in-ui]
