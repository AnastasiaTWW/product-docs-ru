# Мониторинг Ingress‑контроллера

--8<-- "../include/ingress-controller-best-practices-intro.md"

Помимо использования стандартных метрик NGINX, Валарм предоставляет дополнительный набор метрик мониторинга, которые необходимо отслеживать на production-окружении. Сбор метрик WAF‑ноды включается в файле `values.yaml` > атрибут `controller.wallarm.metrics`. Например:

```
controller:
  wallarm:
      metrics:
        enabled: true
        service:
          annotations:
            prometheus.io/scrape: "true"
            prometheus.io/path: /wallarm-metrics
            prometheus.io/port: "18080"
```

Ниже приведен список метрик Валарм, полученный из системы Prometheus, после применения настроек выше.

```
# HELP nginx_wallarm_requests requests count
# TYPE nginx_wallarm_requests gauge
nginx_wallarm_requests 5
# HELP nginx_wallarm_attacks attack requests count
# TYPE nginx_wallarm_attacks gauge
nginx_wallarm_attacks 5
# HELP nginx_wallarm_blocked blocked requests count
# TYPE nginx_wallarm_blocked gauge
nginx_wallarm_blocked 5
# HELP nginx_wallarm_abnormal abnormal requests count
# TYPE nginx_wallarm_abnormal gauge
nginx_wallarm_abnormal 5
# HELP nginx_wallarm_tnt_errors tarantool write errors count
# TYPE nginx_wallarm_tnt_errors gauge
nginx_wallarm_tnt_errors 0
# HELP nginx_wallarm_api_errors API write errors count
# TYPE nginx_wallarm_api_errors gauge
nginx_wallarm_api_errors 0
# HELP nginx_wallarm_requests_lost lost requests count
# TYPE nginx_wallarm_requests_lost gauge
nginx_wallarm_requests_lost 0
# HELP nginx_wallarm_overlimits_time overlimits_time count
# TYPE nginx_wallarm_overlimits_time gauge
nginx_wallarm_overlimits_time 0
# HELP nginx_wallarm_segfaults segmentation faults count
# TYPE nginx_wallarm_segfaults gauge
nginx_wallarm_segfaults 0
# HELP nginx_wallarm_memfaults vmem limit reached events count
# TYPE nginx_wallarm_memfaults gauge
nginx_wallarm_memfaults 0
# HELP nginx_wallarm_softmemfaults request memory limit reached events count
# TYPE nginx_wallarm_softmemfaults gauge
nginx_wallarm_softmemfaults 0
# HELP nginx_wallarm_proton_errors libproton non-memory related libproton faults events count
# TYPE nginx_wallarm_proton_errors gauge
nginx_wallarm_proton_errors 0
# HELP nginx_wallarm_time_detect_seconds time spent for detection
# TYPE nginx_wallarm_time_detect_seconds gauge
nginx_wallarm_time_detect_seconds 0
# HELP nginx_wallarm_db_id proton.db file id
# TYPE nginx_wallarm_db_id gauge
nginx_wallarm_db_id 9
# HELP nginx_wallarm_lom_id LOM file id
# TYPE nginx_wallarm_lom_id gauge
nginx_wallarm_lom_id 38
# HELP nginx_wallarm_proton_instances proton instances count
# TYPE nginx_wallarm_proton_instances gauge
nginx_wallarm_proton_instances{status="success"} 4
nginx_wallarm_proton_instances{status="fallback"} 0
nginx_wallarm_proton_instances{status="failed"} 0
# HELP nginx_wallarm_stalled_worker_time_seconds time a worker stalled in libproton
# TYPE nginx_wallarm_stalled_worker_time_seconds gauge
```

Более подробная информация о настройке мониторинга и список доступных метрик приведены в [документации](../../../monitoring/intro.md).