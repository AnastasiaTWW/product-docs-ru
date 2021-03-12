1. Отправьте тестовый запрос с атаками [SQLI](../attacks-vulns-list.md#sqlинъекция-sql-injection) и [XSS](../attacks-vulns-list.md#межсайтовый-скриптинг-англ-cross-site-scripting-xss) на адрес защищенного ресурса:

    ```
    curl http://localhost/?id='or+1=1--a-<script>prompt(1)</script>'
    ```

    Если WAF‑нода работает в режиме `block`, запрос будет заблокирован с ответом `403 Forbidden`.
2. Перейдите в Консоль управления Валарм → секция **События** для [EU‑облака](https://my.wallarm.com/search) или для [RU‑облака](https://my.wallarm.ru/search) и убедитесь, что атаки появились в списке.
    ![!Атаки в интерфейсе](../images/admin-guides/yandex-cloud/test-attacks.png)