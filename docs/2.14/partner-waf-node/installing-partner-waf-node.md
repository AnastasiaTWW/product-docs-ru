[waf-mode-instr]:                   ../admin-ru/configure-wallarm-mode.md
[logging-instr]:                    ../admin-ru/configure-logging.md
[proxy-balancer-instr]:             ../admin-ru/using-proxy-or-balancer-ru.md
[scanner-whitelisting-instr]:       ../admin-ru/scanner-ips-whitelisting.md
[process-time-limit-instr]:         ../admin-ru/configure-parameters-ru.md#wallarm_process_time_limit
[dynamic-dns-resolution-nginx]:     ../admin-ru/configure-dynamic-dns-resolution-nginx.md

# Установка и настройка партнерской WAF‑ноды

## Требования

* [Партнерский аккаунт](creating-partner-account.md) в системе Валарм, UUID партнера
* [Привязанные клиенты](connecting-clients.md), ID связи между клиентами и партнером
* Выполнение установки от пользователя с ролью **Глобальный администратор** или **Деплой**/**Администратор**. Пользователь с ролью **Деплой**/**Администратор** должен быть добавлен в аккаунт технического клиента или партнерского клиента, в зависимости от того, в каком аккаунте должна быть создана WAF‑нода
* Отключенная двухфакторная аутентификация для пользователя, который выполняет установку WAF‑ноды
* [Поддерживаемая платформа для установки](../admin-ru/supported-platforms.md)

## Особенности партнерской WAF‑ноды

* Устанавливается на те же [платформы](../admin-ru/supported-platforms.md) и по тем же инструкциям, что и обычная WAF‑нода.
* Может быть установлена на уровне **технического клиента** или на уровне **партнерского клиента**. Если необходимо предоставить клиенту доступ к Консоли управления, WAF‑нода должна быть установлена на уровне соответствующего партнерского клиента.
* Настраивается по инструкциям для обычной WAF‑ноды, за исключением:
    * Директива [`wallarm_instance`](../admin-ru/configure-parameters-ru.md#wallarm_instance) используется для разделения по приложениям клиентов партнера.
    * Чтобы включить блокировку запросов по IP‑адресам, необходимо отправить запрос в [техническую поддержку Валарм](mailto:support@wallarm.ru). После этого, для блокировки IP‑адресов необходимо добавлять их в черный список на уровне соответствующих аккаунтов партнерских клиентов.

## Рекомендации к установке партнерской WAF‑ноды

* Если клиент должен иметь доступ к Консоли управления, создайте WAF‑ноду в аккаунте партнерского клиента
* Выполняйте настройку WAF‑ноды в конфигурационном файле, который описывает обработку трафика клиента

## Процедура установки партнерской WAF‑ноды

1. Выберите подходящую форму установки и следуйте соответствующей инструкции:
      * [Модуль для NGINX `stable` из репозитория NGINX](../waf-installation/nginx/dynamic-module.md)
      * [Модуль для NGINX `stable` из репозитория Debian/CentOS](../waf-installation/nginx/dynamic-module-from-distr.md)
      * [Модуль для NGINX Plus](../waf-installation/nginx-plus.md)
      * [Docker‑контейнер с модулями NGINX](../admin-ru/installation-docker-ru.md)
      * [Ingress‑контроллер NGINX](../admin-ru/installation-kubernetes-ru.md)
      * [Ingress‑контроллер NGINX Plus](../admin-ru/installation-guides/ingress-plus/introduction.md)
      * [Sidecar‑контейнер](../admin-ru/installation-guides/kubernetes/wallarm-sidecar-container.md)
      * [Образ AWS](../admin-ru/installation-ami-ru.md)
      * [Образ Google Cloud Platform](../admin-ru/installation-gcp-ru.md)
      * [Heroku со стеком Heroku-16 или Heroku-18](../admin-ru/installation-heroku-ru.md)
      * [Модуль для Kong](../admin-ru/installation-kong-ru.md)
2. Отправьте запрос в [техническую поддержку Валарм](mailto:support@wallarm.ru) для переключения WAF‑ноды в партнерский статус. В запросе передайте следующие данные:
    * Название Облака Валарм, в котором вы зарегистрировались: EU‑облако или RU‑облако
    * Название партнерского аккаунта
    * UUID партнера, полученный при [создании партнерского аккаунта](creating-partner-account.md#шаг-2-получите-доступ-к-партнерскому-аккаунту-и-параметры-для-настройки-wafнод)
    * UUID установленной WAF‑ноды (отображается в Консоли управления Валарм → секция **Ноды**)
3. Откройте конфигурационный файл NGINX с описанием обработки трафика клиента и укажите ID связи между соответствующим клиентом и партнером в директиве `wallarm_instance`.
    
    Пример конфигурационного файла с описанием обработки трафика двух клиентов:

    ```bash
    server {
        listen       80;
        server_name  client1.com;
        wallarm_mode block;
        wallarm_instance 13;
        
        location / {
            proxy_pass      http://upstream1:8080;
        }
    }
    
    server {
        listen       80;
        server_name  client2.com;
        wallarm_mode monitoring;
        wallarm_instance 14;
        
        location / {
            proxy_pass      http://upstream2:8080;
        }
    }
    ```

    * На стороне клиентов настроены A‑записи DNS с IP‑адресом партнера
    * На стороне партнера настроено проксирование запросов к доменам клиентов на адреса, которые передали клиенты (`http://upstream1:8080` для клиента с ID 13 и `http://upstream2:8080` для клиента с ID 14)
    * Все входящие запросы поступают на IP‑адрес партнера для фильтрации, легитимные запросы отправляются на `http://upstream1:8080` для клиента с ID 13 и `http://upstream2:8080` для клиента с ID 14

## Настройка партнерской WAF‑ноды

Чтобы кастомизировать настройки WAF‑ноды, используйте [доступные директивы](../admin-ru/configure-parameters-ru.md).

--8<-- "../include/waf/installation/common-customization-options-nginx.md"
