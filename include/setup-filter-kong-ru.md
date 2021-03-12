Для настройки правил проксирования и фильтрации необходимо отредактировать файл конфигурации `/etc/kong/nginx-wallarm.template`.

Подробную информацию о конфигурации NGINX вы можете найти в [официальной документации NGINX](https://nginx.org/ru/docs/beginners_guide.html).

Логика работы WAF‑ноды Валарм настраивается при помощи директив Валарм. Список доступных директив Валарм доступен на странице «[Тонкая настройка](configure-parameters-ru.md)». 

#### Пример файла конфигурации

Предположим, что вам необходимо настроить сервер для работы по следующим принципам:
* обработка HTTPS‑трафика не настроена;
* запросы осуществляются к двум доменам: `example.com` и `www.example.com`;
* все запросы нужно передавать на сервер `10.80.0.5`;
* все входящие запросы меньше 1 МБ (значение по умолчанию);
* нет запросов, которые обрабатываются дольше 60 секунд (значение по умолчанию);
* система должна работать в режиме мониторинга;
* клиенты обращаются к WAF‑ноде напрямую, не через промежуточный
  HTTP‑балансировщик.

Файл конфигурации в этом случае будет выглядеть следующим образом:

```
    server {
      listen 80;
      listen [::]:80 ipv6only=on;

      # the domains for which traffic is processed
      server_name example.com; 
      server_name www.example.com;

      # turn on the monitoring mode of traffic processing
      wallarm_mode monitoring; 

      location / {
        # setting the address for request forwarding
        proxy_pass http://10.80.0.5; 
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      }
    }

```