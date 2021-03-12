# Блокировка запросов по IP‑адресам

--8<-- "../include/ingress-controller-best-practices-intro.md"

Включение [блокировки запросов по IP‑адресу](../../../configure-ip-blocking-ru.md) предоставляет следующие возможности:
* Автоматическая блокировка IP‑адреса на 1 час при отправке трех или более векторов атаки. Если после снятия блокировки поведение повторяется, IP‑адрес блокируется на 2 часа. Время блокировки увеличивается на 1 час с каждым разом.
* [Управление](../../../../user-guides/blacklist.md) заблокированными IP‑адресами через интерфейс Личного кабинета Валарм.
* Защита приложения от поведенческих атак типа [брутфорс атака](../../../../attacks-vulns-list.md#брутфорс-англ-bruteforce-attack), [path traversal](../../../../attacks-vulns-list.md#path-traversal), [принудительный просмотр ресурсов веб‑приложения](../../../../attacks-vulns-list.md#принудительный-просмотр-ресурсов-вебприложения-англ-forced-browsing).

Для включения блокировки по IP‑адресам выполните следующие шаги:
1. Обновите версию Helm chart для Ingress‑контроллера Валарм до 1.7.0 или выше из репозитория [GitHub](https://github.com/wallarm/ingress-chart), включая файл `values.yaml`.
2. Откройте файл `ingress-chart/wallarm-ingress/values.yaml` обновленной версии Helm chart и установите значение `true` для атрибута `controller.wallarm.acl.enabled`:
    ```
    controller:
        wallarm:
            acl:
                enabled: true
    ```
3. Примените обновления к уже существующему Ingress‑контроллеру Валарм, используя следующую команду:
    ``` bash
    helm upgrade INGRESS_CONTROLLER_NAME VALUES_YAML_FOLDER --reuse-values
    ```
    * `INGRESS_CONTROLLER_NAME` — название уже существующего Ingress‑контроллера Валарм;
    * `VALUES_YAML_FOLDER` — путь до папки с обновленным файлом `values.yaml`.
    
    Теперь синхронизация между данными черного списка IP‑адресов включена для Ingress‑контроллера и облака Валарм.
4. Включите блокировку запросов по IP‑адресам для вашего Ingress, используя команду:
    ``` bash
    kubectl annotate ingress YOUR_INGRESS_NAME nginx.ingress.kubernetes.io/wallarm-acl=on
    ```
    * `YOUR_INGRESS_NAME` — название вашего Ingress.

Для отключения опции используйте аналогичную команду со значением `off`:
``` bash
kubectl annotate ingress YOUR_INGRESS_NAME nginx.ingress.kubernetes.io/wallarm-acl=off
```
