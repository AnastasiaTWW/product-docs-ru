```
wallarm:
  image:
     repository: wallarm/node
     tag: 2.14
     pullPolicy: Always
  # Конечная точка Валарм API:
  # wallarm_host_api: "api.wallarm.com" для EU‑облака
  # wallarm_host_api: "api.wallarm.ru" для RU‑облака
  wallarm_host_api: "api.wallarm.com"
  # Имя пользователя с ролью "Деплой"
  deploy_username: "username"
  # Пароль пользователя с ролью "Деплой"
  deploy_password: "password"
  # Порт, по которому контейнер получает входящие запросы;
  # значение должно совпадать с ports.containerPort
  # в описании основного контейнера вашего приложения
  app_container_port: 80
  # Режим фильтрации запросов: 
  # "off" для отключения фильтрации
  # "monitoring" для обработки всех запросов без блокировки
  # "block" для обработки всех запросов и блокировки вредоносных
  mode: "block"
  # Объем оперативной памяти в ГБ для записи данных по аналитике запросов; 
  # рекомендуемое значение — 75% от общей памяти сервера
  tarantool_memory_gb: 2
  # Передайте значение "true", чтобы включить блокировку запросов по IP
  enable_ip_blocking: "false"
```