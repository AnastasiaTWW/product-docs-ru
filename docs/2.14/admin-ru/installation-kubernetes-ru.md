# Установка в кластере Kubernetes

## Требования

* Kubernetes версии 1.16 или ниже
* Менеджер пакетов [Helm](https://helm.sh/) 
* Совместимость сервисов с [официальным Ingress‑контроллером NGINX](https://github.com/kubernetes/ingress-nginx)

!!! info "Смотрите также"
    * [Что такое Ingress?](https://kubernetes.io/docs/concepts/services-networking/ingress/)
    * [Установка Helm](https://helm.sh/docs/intro/install/)

## Известные ограничения

* Не поддерживается работа без сервиса постаналитики.
* Масштабирование постаналитики (уменьшение) может приводить к частичной потере данных об атаках.

## Установка

1. [Установите](#шаг-1-установка-ingressконтроллера-валарм) Ingress‑контроллер Валарм.
2. [Включите](#шаг-2-включение-анализа-трафика-для-вашего-ingress) анализ трафика для вашего Ingress.
3. [Протестируйте](#шаг-3-тестирование-работы-ingressконтроллера-валарм) работу Ingress‑контроллера Валарм.

### Шаг 1: Установка Ingress‑контроллера Валарм

1. Перейдите в Консоль управления Валарм → секция **Ноды** по ссылке:
    * https://my.wallarm.com/nodes для EU‑облака
    * https://my.wallarm.ru/nodes для RU‑облака
2. Создайте WAF‑ноду с типом **Облако** и скопируйте токен.

    ![!Создание облачной WAF‑ноды](../images/installation-kubernetes/create-cloud-node.png)

3. Склонируйте репозиторий Helm‑чарта Валарм:

    ``` bash
    git clone https://github.com/wallarm/ingress-chart --branch 2.14.0-1 --single-branch
    ```
4. Установите Ingress-контроллер Валарм:

    === "EU‑облако"
        ``` bash
        helm install --set controller.wallarm.enabled=true,controller.wallarm.token=<YOUR_CLOUD_NODE_TOKEN> <INGRESS_CONTROLLER_NAME> ingress-chart/wallarm-ingress -n <KUBERNETES_NAMESPACE>
        ```
    === "RU‑облако"
        ``` bash
        helm install --set controller.wallarm.enabled=true,controller.wallarm.token=<YOUR_CLOUD_NODE_TOKEN>,controller.wallarm.apiHost=api.wallarm.ru <INGRESS_CONTROLLER_NAME> ingress-chart/wallarm-ingress -n <KUBERNETES_NAMESPACE>
        ```
    
    * `<YOUR_CLOUD_NODE_TOKEN>` — токен облачной WAF‑ноды
    * `<INGRESS_CONTROLLER_NAME>` — название Ingress‑контроллера Валарм
    * `<KUBERNETES_NAMESPACE>` — namespace вашего Ingress

### Шаг 2: Включение анализа трафика для вашего Ingress

``` bash
kubectl annotate ingress <YOUR_INGRESS_NAME> nginx.ingress.kubernetes.io/wallarm-mode=monitoring
kubectl annotate ingress <YOUR_INGRESS_NAME> nginx.ingress.kubernetes.io/wallarm-instance=<INSTANCE>
```

* `<YOUR_INGRESS_NAME>` — название вашего Ingress
* `<INSTANCE>` — положительное число, уникальное для каждого из ваших приложений или группы приложений; используется для получения раздельной статистики и отличия атак, направленных на соответствующие приложения

### Шаг 3: Тестирование работы Ingress‑контроллера Валарм

1. Получите список pod'ов, передав в `<INGRESS_CONTROLLER_NAME>` название Ingress‑контроллера Валарм:
    ``` bash
    kubectl get po -l release=<INGRESS_CONTROLLER_NAME>
    ```

    Все pod'ы должны быть в состоянии: «STATUS: Running» и «READY: N/N». Например:

    ```
    NAME                                                              READY     STATUS    RESTARTS   AGE
    ingress-controller-nginx-ingress-controller-675c68d46d-cfck8      3/3       Running   0          5m
    ingress-controller-nginx-ingress-controller-wallarm-tarantljj8g   8/8       Running   0          5m
    ingress-controller-nginx-ingress-default-backend-584ffc6c7xj5xx   1/1       Running   0          5m
    ```

2. Отправьте тестовый запрос с атаками [SQLI](../attacks-vulns-list.md#sqlинъекция-sql-injection) и [XSS](../attacks-vulns-list.md#межсайтовый-скриптинг-англ-cross-site-scripting-xss) на адрес Ingress‑контроллера Валарм:

    ```bash
    curl http://<INGRESS_CONTROLLER_IP>/?id='or+1=1--a-<script>prompt(1)</script>'
    ```

    Если WAF‑нода находится в статусе `block`, в ответ на запрос вернется код `403 Forbidden` и атаки отобразятся в Консоли управления Валарм → секция **События**.

## Настройка

После успешной установки и тестирования Ingress‑контроллера Валарм вы можете применить к решению дополнительные настройки, например:

* [Сохранение IP‑адреса клиента при использовании балансировщика нагрузки](configuration-guides/wallarm-ingress-controller/best-practices/report-public-user-ip.md)
* [Блокировка запросов по IP‑адресам](configuration-guides/wallarm-ingress-controller/best-practices/block-ip-addresses.md)
* [Добавление IP‑адресов Валарм в белый список для работы сканера](configuration-guides/wallarm-ingress-controller/best-practices/whitelist-wallarm-ip-addresses.md)
* [Повышение стабильности работы Ingress‑контроллера](configuration-guides/wallarm-ingress-controller/best-practices/high-availability-considerations.md)
* [Мониторинг Ingress‑контроллера](configuration-guides/wallarm-ingress-controller/best-practices/ingress-controller-monitoring.md)

Для получения списка всех настроек и соответствующих инструкций перейдите по [ссылке](configure-kubernetes-ru.md).
