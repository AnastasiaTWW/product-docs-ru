# Сохранение IP‑адреса клиента при использовании балансировщика нагрузки

--8<-- "../include/ingress-controller-best-practices-intro.md"

По умолчанию Ingress‑контроллер Валарм предполагает, что pod'ы доступны из сети Интернет или других потенциально опасных ресурсов напрямую. При передаче запросов сервисам, Ingress‑контроллер автоматически добавляет HTTP‑заголовок `X-Forwarded-For` с IP‑адресом клиента.

Если для направления внешнего трафика на Ingress‑контроллер используется балансировщик нагрузки (AWS ELB, Google Network Load Balancer и т.д.), возможны способы корректной передачи IP‑адреса клиента ниже.

#### Настроить передачу реального IP‑адреса клиента на сетевом уровне

Способ настройки зависит от подключенного балансировщика, но в большинстве случаев необходимо перейти к файлу `values.yaml` Helm chart и передать значение `Local` в атрибуте `controller.service.externalTrafficPolicy`:

```
controller:
    service:
        externalTrafficPolicy: "Local"
```

#### Настроить для Ingress‑контроллера получение значения из HTTP‑заголовка X-Forwarded-For

Данный вариант применяется при использовании внешних CDN-сервисов, например Cloudflare или Fastly. Для настройки:
1. Убедитесь, что балансировщик нагрузки передает IP‑адрес в заголовке `X-Forwarded-For`.
2. Перейдите к файлу `values.yaml` Helm chart и передайте значение `true` в атрибуте `controller.config.use-forwarded-headers`:

```
controller:
    config:
        use-forwarded-headers: "true"
```
