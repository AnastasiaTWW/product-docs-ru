```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      # Элемент Валарм: описание sidecar‑контейнера Валарм
      - name: wallarm
        image: wallarm/node:2.16.0-9
        imagePullPolicy: Always
        env:
        # Конечная точка Валарм API:
        # "api.wallarm.com" для EU‑облака
        # "api.wallarm.ru" для RU‑облака
        - name: WALLARM_API_HOST 
          value: "api.wallarm.com"
        # Имя пользователя с ролью "Деплой"
        - name: DEPLOY_USER
          value: "username"
        # Пароль пользователя с ролью "Деплой"
        - name: DEPLOY_PASSWORD
          value: "password"
        - name: DEPLOY_FORCE
          value: "true"
        # Флаг для включения блокировки запросов по IP
        - name: WALLARM_ACL_ENABLE
          value: "true"
        # Объем оперативной памяти в ГБ для записи данных по аналитике запросов;
        # рекомендуемое значение — 75% от общей памяти сервера
        - name: TARANTOOL_MEMORY_GB
          value: "2"
        ports:
        - name: http
          # порт, по которому sidecar‑контейнер Валарм получает запросы от объекта Service
          containerPort: 80
        volumeMounts:	
        - mountPath: /etc/nginx/sites-enabled	
          readOnly: true	
          name: wallarm-nginx-conf
      # Описание основного контейнера вашего приложения
      - name: myapp
        image: <Image>
        resources:
          limits:
            memory: "128Mi"
            cpu: "500m"
        ports:
        # Порт, по которому контейнер приложения получает входящие запросы
        - containerPort: 8080
      volumes:
      # Элемент Валарм: описание ресурса wallarm-nginx-conf
      - name: wallarm-nginx-conf 
        configMap:
          name: wallarm-sidecar-nginx-conf
          items:
            - key: default
              path: default
```