
[link-git-website]:         https://git-scm.com/
[link-git-docs]:            https://git-scm.com/doc
[link-kubectl-website]:     https://kubernetes.io/docs/reference/kubectl/overview/
[link-kubectl-docs]:        https://kubernetes.io/docs/tasks/tools/install-kubectl/
[link-curl-website]:        https://curl.haxx.se/
[link-curl-docs]:           https://curl.haxx.se/docs/tooldocs.html
[link-wallarm-portal]:      https://my.wallarm.com/
[link-wallarm-portal-ru]:   https://my.wallarm.ru/
    
[img-wallarm-portal-events]:    ../../../images/installation-ingress/1-wallarm-portal-events-ru.png
    
[link-previous-chapter]:    resource-creation.md
    
    
#   Проверка работы сервисов Валарм

!!! info "Соглашение о терминах"
    В этом документе используются следующие русскоязычные эквиваленты английских терминов:
    
    *   ресурс Ingress  — Ingress resource.

Убедитесь, что у вас установлены и настроены следующие инструменты:
*   [Git][link-git-website] ([официальная документация][link-git-docs]).
*   [Kubectl][link-kubectl-website] ([официальная документация][link-kubectl-docs]).
*   [Curl][link-curl-website] ([официальная документация][link-curl-docs])


Для проверки работоспособности сервисов Валарм для развернутого ранее Ingress‑контроллера выполните следующие действия:

1.  Если вы еще не выполнили клонирование репозитория с Ingress‑контроллером Валарм NGINX Plus, то клонируйте его, выполнив следующую команду:
    
    ```
    git clone https://github.com/wallarm/ingress-plus/
    ```
    
2.  Перейдите в директорию `ingress-plus/examples/complete-example`, выполнив следующую команду:
    
    ```
    cd ingress-plus/examples/complete-example/
    ```
    
3.  Задайте необходимые переменные среды окружения, выполнив следующие команды:
    
    ```
    IC_IP=<IP‑адрес контроллера Ingress>
    IC_HTTPS_PORT=<порт для HTTPS‑соединений контроллера Ingress>
    ```
    
4.  Разверните тестовое приложение Café, выполнив следующие команды:
    
    ```
    kubectl apply -f cafe.yaml
    kubectl apply -f cafe-secret.yaml
    ```
    
5.  Откройте YAML-файл `cafe-ingress.yaml` любым текстовым редактором (например, Nano) и добавьте в секцию `metadata` секцию `annotations` с параметрами Валарм:
    
    ```
    ...часть файла намеренно опущена...
    metadata:
      name: cafe-ingress
      annotations:
        wallarm.com/mode: "monitoring"
    ...часть файла намеренно опущена...
    ```
    
    Сохраните сделанные изменения.
     
6.  Разверните ресурс Ingress с именем `cafe-ingress`, выполнив команду:
    
    ```
    kubectl apply -f cafe-ingress.yaml
    ```
    
7.  Теперь у вас развернуто приложение, которое обслуживается двумя бэкендами.
    *   `путь cafe.example.com/tea` обслуживается сервисом `tea-svc`,
    *   `путь cafe.example.com/coffee` обслуживается сервисом `coffee-svc`.
    
8.  Проверьте работоспособность приложения, выполнив следующую команду:
    
    ```
    curl --resolve cafe.example.com:$IC_HTTPS_PORT:$IC_IP https://cafe.example.com:$IC_HTTPS_PORT/tea --insecure
    ```
    
    Вывод команды должен выглядеть похожим образом:
    
    ```
    Server address: 10.244.0.93:80
    Server name: tea-7d57856c44-29p2g
    Date: 12/Dec/2018:08:53:23 +0000
    URI: /tea
    Request ID: 3c58ec15740a85ecf236836387dcaa32
    ```
    
9.  Выполните тестовую SQLi-атаку на `cafe.example.com/coffee`, выполнив следующую команду:
    
    ```
    curl --resolve cafe.example.com:$IC_HTTPS_PORT:$IC_IP https://cafe.example.com:$IC_HTTPS_PORT/coffee/UNION%20SELECT --insecure
    ```
    
    Вывод команды должен выглядеть похожим образом:
    
    ```
    Server address: 10.244.0.90:80
    Server name: coffee-7dbb5795f6-ktd49
    Date: 12/Dec/2018:08:58:10 +0000
    URI: /coffee/UNION%20SELECT
    Request ID: c1482cd43a4b285d68a16f31b818c847
    ```
    
10. Войдите на портал Валарм по ссылке для [EU‑облака][link-wallarm-portal] или [RU‑облака][link-wallarm-portal-ru], используя вашу учетную запись Валарм.
    
    Во вкладке *События* вы увидите выполненную SQLi-атаку.
    
    ![!Вкладка «События» на портале Валарм][img-wallarm-portal-events]
    
11. Переведите Ingress‑контроллер Валарм NGINX Plus из режима мониторинга в режим блокировки атакующего. Для этого модифицируйте существующий ресурс Ingress с именем `cafe-ingress`, выполнив команду:
    
    ```
    kubectl annotate --overwrite ingress cafe-ingress wallarm.com/mode=block
    ```
    
12. Снова выполните тестовую SQLi-атаку на `cafe.example.com/coffee`, выполнив следующую команду:
    
    ```
    curl --resolve cafe.example.com:$IC_HTTPS_PORT:$IC_IP https://cafe.example.com:$IC_HTTPS_PORT/coffee/UNION%20SELECT --insecure
    ```
    
    Вывод команды должен выглядеть похожим образом:
    
    ```
    <html>
    <head><title>403 Forbidden</title></head>
    <body bgcolor="white">
    <center><h1>403 Forbidden</h1></center>
    <hr><center>nginx/1.15.2</center>
    </body>
    </html>
    ```
    
    Если вы получили ответ `403 Forbidden`, значит, сервисы Валарм настроены и работают.
    
    !!! info
        Блокировка будет также работать и для `cafe.example.com/tea.`
