```
apiVersion: v1
kind: Service
metadata:
  name: myapp
spec:
  selector:
    app: myapp
  ports:
  - port: {{ .Values.service.port }}
    # Порт sidecar‑контейнера Валарм, на который объект Service перенаправляет запросы; 
    # значение должно совпадать с ports.containerPort в описании sidecar‑контейнера Валарм
    targetPort: 8080
```