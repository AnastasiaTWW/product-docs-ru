Добавьте в `/etc/nginx/conf.d/wallarm.conf` адреса серверов постаналитики:

```bash
upstream wallarm_tarantool {
    server <ip1>:3313 max_fails=0 fail_timeout=0 max_conns=1;
    server <ip2>:3313 max_fails=0 fail_timeout=0 max_conns=1;
    
    keepalive 2;
    }

    # omitted

wallarm_tarantool_upstream wallarm_tarantool;
```

* Значение `max_conns` должно быть указано для каждого сервера, чтобы предотвратить создание лишних соединений.
* Значение `keepalive` должно быть не меньше, чем количество серверов Tarantool.
