1.  Используйте команду `curl http://127.0.0.8/wallarm-status`, если используются настройки WAF‑ноды по умолчанию. 
2.  Если мониторинг настроен иначе, см. файл конфигурации `/etc/nginx/conf.d/wallarm‑status.conf`.

    Вывод команды будет аналогичен выводу ниже:
    ```
    {"requests":0,"attacks":0,"blocked":0,"abnormal":0,"tnt_errors":0,"api_errors":0,"requests_lost":0,"segfaults":0,"memfaults":0,"softmemfaults":0,"time_detect":0,"db_id":46,"lom_id":4,"proton_instances": { "total":2,"success":2,"fallback":0,"failed":0 },"stalled_workers_count":0,"stalled_workers":[] }
    ```