[link-helm-chart-details]:  https://github.com/wallarm/ingress-chart#configuration

# Тонкая настройка Валарм Ingress Controller

!!! info "Официальная документация NGINX Ingress Controller"
    Настройка Валарм Ingress Controller незначительно отличается от настройки NGINX Ingress Controller, о которой рассказано в [официальной документации](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/). При работе с Валарм доступны все возможности настройки оригинального NGINX Ingress Controller.


## Дополнительные настройки Helm Chart

Настройка выполняется в файле `values.yaml`. По умолчанию файл имеет следующий вид:

```
controller:
  wallarm:
    enabled: false
    apiHost: api.wallarm.com
    apiPort: 444
    apiSSL: true
    token: ""
    tarantool:
      kind: Deployment
      service:
        annotations: {}
      replicaCount: 1
      arena: "0.2"
      livenessProbe:
        failureThreshold: 3
        initialDelaySeconds: 10
        periodSeconds: 10
        successThreshold: 1
        timeoutSeconds: 1
      resources: {}
    metrics:
      enabled: false

      service:
        annotations:
          prometheus.io/scrape: "true"
          prometheus.io/path: /wallarm-metrics
          prometheus.io/port: "18080"

        ## List of IP addresses at which the stats-exporter service is available
        ## Ref: https://kubernetes.io/docs/user-guide/services/#external-ips
        ##
        externalIPs: []

        loadBalancerIP: ""
        loadBalancerSourceRanges: []
        servicePort: 9913
        type: ClusterIP
    synccloud:
      resources: {}
    collectd:
      resources: {}
    acl:
      enabled: false
      resources: {}
```

Ниже приведено описание основных параметров, которые вы можете настроить. Остальные параметры используют значение по умолчанию или редко изменяются, их описание доступно по [ссылке][link-helm-chart-details].

### wallarm.enabled

Позволяет включать и выключать функциональность Валарм.

**Значение по умолчанию**: `false`

### wallarm.apiHost

Конечная точка API. Возможные значения:

* `api.wallarm.com` для [EU‑облака](../about-wallarm-waf/overview.md#euоблако)
* `api.wallarm.ru` для [RU‑облака](../about-wallarm-waf/overview.md#ruоблако)

**Значение по умолчанию**: `api.wallarm.com`

### wallarm.token

Токен *Cloud Node*, созданной в Личном кабинете по ссылке для [EU‑облака](https://my.wallarm.com/nodes) или для [RU‑облака](https://my.wallarm.ru/nodes). Необходим для доступа ноды к Валарм API.

**Значение по умолчанию**: `нет`

### wallarm.tarantool.replicaCount

Количество запускаемых pod'ов постаналитики. Постаналитика отвечает за определение поведенческих атак.

**Значение по умолчанию**: `1`

### wallarm.tarantool.arena

Объем памяти, выделенной для постаналитики. Рекомендуется выставлять значение, достаточное для хранения запросов за последние 5-15 минут.

**Значение по умолчанию**: `0.2`

### wallarm.metrics.enabled

Позволяет включать и выключать сбор метрик о работе Валарм. Если в Kubernetes кластере установлен [Promethes helm chart](https://github.com/helm/charts/tree/master/stable/prometheus), то дополнительных настроек не требуется.

**Значение по умолчанию**: `false`

## Глобальные настройки контроллера

Применяются при помощи [ConfigMap](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/).

Поддерживаются следующие дополнительные параметры кроме стандартных:

* `enable-wallarm` — включает обработку запросов с помощью Валарм
* [wallarm-upstream-connect-attempts](configure-parameters-ru.md#wallarm_tarantool_upstream)
* [wallarm-upstream-reconnect-interval](configure-parameters-ru.md#wallarm_tarantool_upstream)
* [wallarm-process-time-limit](configure-parameters-ru.md#wallarm_process_time_limit)
* [wallarm-process-time-limit-block](configure-parameters-ru.md#wallarm_process_time_limit_block)
* [wallarm-request-memory-limit](configure-parameters-ru.md#wallarm_request_memory_limit)
* `enable-wallarm-acl` — включает блокировку запросов по IP‑адресам, [указанным](../user-guides/blacklist.md) в Личном кабинете
* [wallarm-acl-mapsize](configure-parameters-ru.md#wallarm_acl_map_size)

## Аннотации Ingress

Используются для настройки параметров обработки отдельных Ingress''ов.

Кроме [стандартных](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/) аннотаций поддерживаются следующие дополнительные:

* [nginx.ingress.kubernetes.io/wallarm-mode](configure-parameters-ru.md#wallarm_mode), default: off
* [nginx.ingress.kubernetes.io/wallarm-mode-allow-override](configure-parameters-ru.md#wallarm_mode_allow_override)
* [nginx.ingress.kubernetes.io/wallarm-fallback](configure-parameters-ru.md#wallarm_fallback)
* [nginx.ingress.kubernetes.io/wallarm-instance](configure-parameters-ru.md#wallarm_instance)
* [nginx.ingress.kubernetes.io/wallarm-block-page](configure-parameters-ru.md#wallarm_block_page)
* [nginx.ingress.kubernetes.io/wallarm-parse-response](configure-parameters-ru.md#wallarm_parse_response)
* [nginx.ingress.kubernetes.io/wallarm-parse-websocket](configure-parameters-ru.md#wallarm_parse_websocket)
* [nginx.ingress.kubernetes.io/wallarm-unpack-response](configure-parameters-ru.md#wallarm_unpack_response)
* [nginx.ingress.kubernetes.io/wallarm-parser-disable](configure-parameters-ru.md#wallarm_parser_disable)
* [nginx.ingress.kubernetes.io/wallarm-acl](configure-parameters-ru.md#wallarm_acl)

### Применение аннотаций к Ingress

Чтобы применить настройки к вашему Ingress, используйте следующую команду:

``` bash
kubectl annotate --overwrite ingress YOUR_INGRESS_NAME ANNOTATION_NAME=VALUE
```

* `YOUR_INGRESS_NAME` — название вашего Ingress,
* `ANNOTATION_NAME` — название аннотации из списка выше,
* `VALUE` — значение для аннотации из списка выше.

### Примеры аннотаций

#### Включение блокировки по IP‑адресам

Для включения блокировки по IP‑адресам [создайте](../user-guides/blacklist.md) их список в Консоли управления Валарм и выполните следующую команду:

``` bash
kubectl annotate --overwrite ingress YOUR_INGRESS_NAME nginx.ingress.kubernetes.io/wallarm-acl=on
```

#### Настройка страницы блокировки и кода ошибки

Вы можете настроить страницу блокировки и код ошибки, которые возвращаются в ответ на запрос с признаками атаки, если WAF‑нода работает в [режиме](configure-wallarm-mode.md) блокировки. Для настройки используется аннотация `nginx.ingress.kubernetes.io/wallarm-block-page`.

Например, чтобы в ответ на заблокированный запрос вернуть стандартную страницу блокировки Валарм и код ошибки 445:

``` bash
kubectl annotate ingress <YOUR_INGRESS_NAME> nginx.ingress.kubernetes.io/wallarm-block-page='&/usr/share/nginx/html/wallarm_blocked.html response_code=445'
```

[Подробнее о способах настройки страницы блокировки и кода ошибки →](configuration-guides/configure-block-page-and-code.md)

!!! info "Передача пути до страницы блокировки и кода ошибки через запятую"
    Чтобы разделить путь до страницы блокировки и код ошибки в значении для аннотации Ingress, вы можете использовать запятую вместо пробела. Например:

    ``` bash
    kubectl annotate ingress <YOUR_INGRESS_NAME> nginx.ingress.kubernetes.io/wallarm-block-page='&/usr/share/nginx/html/wallarm_blocked.html,response_code=445'
    ```

#### Включение анализа атак с помощью библиотеки libdetection

Библиотека [**libdetection**](../about-wallarm-waf/protecting-against-attacks.md#библиотека-libdetection) выполняет дополнительную валидацию атак, обнаруженных с помощью библиотеки [**libproton**](../about-wallarm-waf/protecting-against-attacks.md#библиотека-libproton). Такой подход реализует двойное обнаружение атак и снижает количество ложных срабатываний.

Для парсинга тела запросов, необходимо также включить буферизацию тела запроса клиента ([`proxy_request_buffering on`](https://nginx.org/ru/docs/http/ngx_http_proxy_module.html#proxy_request_buffering)).

Вы можете использовать следующие способы включения анализа атак с **libdetection**:

* Применить следующую аннотацию [`nginx.ingress.kubernetes.io/server-snippet`](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/#server-snippet) к Ingress:

    ```bash
    kubectl annotate --overwrite ingress <YOUR_INGRESS_NAME> nginx.ingress.kubernetes.io/server-snippet="wallarm_enable_libdetection on; proxy_request_buffering on;"
    ```
* После [клонирования репозитория](installation-kubernetes-ru.md#шаг-1-установка-ingressконтроллера-валарм) с Helm‑чартом Валарм, открыть файл **values.yaml** клонированного репозитория и добавить в объект [`config`](https://github.com/wallarm/ingress-chart/blob/master/wallarm-ingress/values.yaml#L20) следующий параметр:

    ```bash
    config: {
        server-snippet: 'wallarm_enable_libdetection on; proxy_request_buffering on;'
    }
    ```
