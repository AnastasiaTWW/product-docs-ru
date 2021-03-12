# Обновление Ingress‑контроллера NGINX с сервисами Валарм WAF

Инструкция описывает способ обновления развернутого Ingress‑контроллера Валарм до новой версии с WAF‑нодой 2.18.

* Для обновления необходимо склонировать новую версию Helm‑чарта и применить обновления к установленной версии.
* Настройки, примененные к установленному Ingress‑контроллеру, и аннотации Ingress сохраняются после обновления.

## Обновление

1. Склонируйте новую версию Helm‑чарта из репозитория Валарм:

    ```bash
    git clone https://github.com/wallarm/ingress-chart --branch 2.18.0-3 --single-branch
    ```
2. Обновите предыдущий Helm‑чарт:

    === "EU‑облако"
        ``` bash
        helm upgrade --set controller.wallarm.enabled=true,controller.wallarm.token=<YOUR_CLOUD_NODE_TOKEN> <INGRESS_CONTROLLER_NAME> ingress-chart/wallarm-ingress -n <KUBERNETES_NAMESPACE>
        ```
    === "RU‑облако"
        ``` bash
        helm upgrade --set controller.wallarm.enabled=true,controller.wallarm.token=<YOUR_CLOUD_NODE_TOKEN>,controller.wallarm.apiHost=api.wallarm.ru <INGRESS_CONTROLLER_NAME> ingress-chart/wallarm-ingress -n <KUBERNETES_NAMESPACE>
        ```

    * `<YOUR_CLOUD_NODE_TOKEN>` — токен облачной WAF‑ноды, созданной при [установке Ingress‑контроллера Валарм](../admin-ru/installation-kubernetes-ru.md)
    * `<INGRESS_CONTROLLER_NAME>` — название развернутого Ingress‑контроллера Валарм
    * `<KUBERNETES_NAMESPACE>` — namespace вашего Ingress

## Тестирование 

1. Убедитесь, что чарт обновлен:

    ```bash
    helm ls
    ```

    Версия чарта должна соответствовать `wallarm-ingress-1.8.x`.
2. Получите список pod'ов, передав в `<INGRESS_CONTROLLER_NAME>` название Ingress‑контроллера Валарм:
    
    ``` bash
    kubectl get po -l release=<INGRESS_CONTROLLER_NAME>
    ```

    Все pod'ы должны быть в состоянии: **STATUS: Running** и **READY: N/N**. Например:

    ```
    NAME                                                              READY     STATUS    RESTARTS   AGE
    ingress-controller-nginx-ingress-controller-675c68d46d-cfck8      3/3       Running   0          5m
    ingress-controller-nginx-ingress-controller-wallarm-tarantljj8g   8/8       Running   0          5m
    ingress-controller-nginx-ingress-default-backend-584ffc6c7xj5xx   1/1       Running   0          5m
    ```

3. Отправьте тестовый запрос с атаками [SQLI](../attacks-vulns-list.md#sqlинъекция-sql-injection) и [XSS](../attacks-vulns-list.md#межсайтовый-скриптинг-англ-cross-site-scripting-xss) на адрес Ingress‑контроллера Валарм:

    ```bash
    curl http://<INGRESS_CONTROLLER_IP>/?id='or+1=1--a-<script>prompt(1)</script>'
    ```

    Если WAF‑нода находится в статусе `block`, в ответ на запрос вернется код `403 Forbidden` и атаки отобразятся в Консоли управления Валарм → секция **События**.

## Настройка

Глобальные настройки Ingress‑контроллера Валарм и аннотации Ingress, примененные к предыдущей версии, сохранятся для новой версии. Список всех настроек и аннотаций доступен по [ссылке](../admin-ru/configure-kubernetes-ru.md).

Частые настройки:

* [Сохранение IP‑адреса клиента при использовании балансировщика нагрузки](../admin-ru/configuration-guides/wallarm-ingress-controller/best-practices/report-public-user-ip.md)
* [Блокировка запросов по IP‑адресам](../admin-ru/configuration-guides/wallarm-ingress-controller/best-practices/block-ip-addresses.md)
* [Добавление IP‑адресов Валарм в белый список для работы сканера](../admin-ru/configuration-guides/wallarm-ingress-controller/best-practices/whitelist-wallarm-ip-addresses.md)
* [Повышение стабильности работы Ingress‑контроллера](../admin-ru/configuration-guides/wallarm-ingress-controller/best-practices/high-availability-considerations.md)
* [Мониторинг Ingress‑контроллера](../admin-ru/configuration-guides/wallarm-ingress-controller/best-practices/ingress-controller-monitoring.md)
