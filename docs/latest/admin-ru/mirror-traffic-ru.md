# Анализ зеркалированного трафика с помощью NGINX

Начиная с версии NGINX 1.13 доступна опция по зеркалированию трафика на дополнительный бэкенд. Если в качестве такого бэкенда установить WAF‑ноду Валарм, то можно получить возможность анализировать копию трафика без серьезных изменений в «живой» системе.

Подобная настройка полезна в следующих случаях:

* Для быстрого запуска пилотного проекта.
* Для полной гарантии, что средства защиты не повлияют на работоспособность и производительность приложения.
* Для предварительного обучения на трафике до запуска модуля в «боевом» режиме.

Ограничения:

* Анализ только запрсов, нет анализа ответов.
* Отсутствие блокировки атаки в реальном времени на уровне запроса.

## Настройка

### Общая схема

![!](../images/mirror-traffic-ru.png)

1. Настройка NGINX: установка модуля и настройка зеркалирования запросов.
2. Установка и настройка WAF‑ноды Валарм. Смотрите [Установка динамически подключаемого модуля NGINX](../waf-installation/nginx/dynamic-module.md).

На Шаге 1 устанавливается модуль зеркалирования [ngx_http_mirror_module](https://nginx.org/ru/docs/http/ngx_http_mirror_module.html) и настраивается зеркалирование запросов на дополнительный бэкенд.

На Шаге 2 в качестве дополнительного бэкенда устанавливается WAF‑нода Валарм.

### Настройка NGINX

Зеркалирование настраивается директивой `mirror`, которая может использоваться на уровне `location` и `server`.

Пример зеркалирования запросов к `location /` на `location /mirror-test`:

```
location / {
        mirror /mirror-test;
        mirror_request_body on;
        root   /usr/share/nginx/html;
        index  index.html index.htm; 
    }
    
location /mirror-test {
        internal;
        #proxy_pass http://111.11.111.1$request_uri;
        proxy_pass http://222.222.222.222$request_uri;
        proxy_set_header X-SERVER-PORT $server_port;
        proxy_set_header X-SERVER-ADDR $server_addr;
        proxy_set_header HOST $http_host;
        proxy_set_header X-REAL-IP  $remote_addr;
        proxy_set_header X-Request-ID $request_id;
    }
```

В настройках `location` для отправки зеркалирования трафика необходимо указать перечень заголовков, которые будут переданы. В качестве IP‑адреса указывается машина с WAF‑нодой Валарм, которая принимает копию трафика.

### Настройка WAF‑ноды Валарм для приема зеркалированного трафика

Для того, чтобы в интерфейсе Валарм правильно отображались IP‑адреса атакующих, необходимо настроить `real_ip_header`, а также отключить обработку запросов — запросы не будут анализироваться с помощью директив `wallarm_force_response_*`, так как передаются только копии запросов.

Пример настроенного `real_ip_header` с отключенной обработкой запросов:

```
wallarm_force server_addr $http_x_server_addr;
wallarm_force server_port $http_x_server_port;
#Change 222.222.222.22 to the mirror server address
set_real_ip_from  222.222.222.22;
real_ip_header    X-REAL-IP;
#real_ip_recursive on;
wallarm_force response_status 0;
wallarm_force response_time 0;
wallarm_force response_size 0;
```