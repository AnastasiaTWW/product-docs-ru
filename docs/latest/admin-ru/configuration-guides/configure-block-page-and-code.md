# Настройка страницы блокировки и кода ошибки

Данная инструкция описывает способ настройки страницы и кода ошибки, которые возвращаются клиенту в ответ на заблокированный запрос.

## Способы настройки

Настройка страницы блокировки и кода ответа выполняется через директивы NGINX. Набор директив зависит от причины и способа блокировки запроса:

* Если запрос содержит признаки атаки и WAF‑нода работает в [режиме](../configure-wallarm-mode.md) блокировки: `wallarm_block_page` и `wallarm_block_page_add_dynamic_path`
* Если запрос отправлен с [заблокированного IP‑адреса](../configure-ip-blocking-ru.md): `wallarm_acl_block_page` и `wallarm_block_page_add_dynamic_path`

По умолчанию, в ответ на заблокированный запрос возвращаются код ошибки 403 и стандартная страница блокировки NGINX.

## Директивы NGINX

### wallarm_block_page

Директива `wallarm_block_page` используется для настройки ответа на запрос, в котором WAF‑нода обнаружила признаки атаки в [режиме](../configure-wallarm-mode.md) блокировки.

Директива принимает значения в следующем формате:

* Путь до HTM- или HTML-файла со страницей блокировки и код ошибки (опционально)

    ```bash
    wallarm_block_page &/<PATH_TO_FILE/HTML_HTM_FILE_NAME> response_code=<CUSTOM_CODE>;
    ```
    
    Вы можете использовать [переменные NGINX](http://nginx.org/ru/docs/varindex.html) на странице блокировки. Для этого вставьте в код страницы имя переменной в `{}`, начиная с символа `$`. Например, `${remote_addr}` отобразит на странице блокировки IP‑адрес, с которого отправлен запрос.

    Валарм предоставляет стандартную страницу блокировки. Чтобы ее использовать, необходимо передать в директиве следующий путь: `&/usr/share/nginx/html/wallarm_blocked.html`.

    !!! info "Важная информация для пользователей Debian и CentOS"
        Если вы используете NGINX версии ниже 1.11, установленный из репозиториев [CentOS/Debian](../../waf-installation/nginx/dynamic-module-from-distr.md), для корректного отображения страницы блокировки необходимо удалить из кода страницы переменную `request_id`:
        ```
        UUID ${request_id}
        ```

        Удаление переменной требуется при использовании как собственного шаблона динамической страницы, так и `wallarm_blocked.html`.

* URL для перенаправления клиента

    ``` bash
    wallarm_block_page /<REDIRECT_URL>;
    ```

* Именованный `location` NGINX

    ``` bash
    wallarm_block_page @<NAMED_LOCATION>;
    ```

* Переменная и код ошибки (опционально)

    ``` bash
    wallarm_block_page &<VARIABLE_NAME> response_code=<CUSTOM_CODE>;
    ```

    !!! warning "Инициализация страницы блокировки с переменными NGINX"
        Если вы задаете страницу блокировки через переменную и внутри страницы блокировки также используются [переменные NGINX](https://nginx.org/ru/docs/varindex.html), необходимо инициализировать страницу блокировки с переменными с помощью директивы [`wallarm_block_page_add_dynamic_path`](#wallarm_block_page_add_dynamic_path).

Директива `wallarm_block_page` может быть передана в блоках `http`, `server`, `location` конфигурационного файла NGINX.

### wallarm_acl_block_page

Директива `wallarm_acl_block_page` используется для настройки ответа на запрос, который был отправлен с [заблокированного IP‑адреса](../configure-ip-blocking-ru.md).

Директива принимает значения в таком же формате, как и [`wallarm_block_page`](#wallarm_block_page).

### wallarm_block_page_add_dynamic_path

Директива `wallarm_block_page_add_dynamic_path` используется для инициализации страницы блокировки, если внутри страницы используются переменные NGINX и путь до страницы блокировки также задан с помощью переменной. В остальных случаях директива не используется.

Директива `wallarm_acl_block_page` может быть передана только в блоке `http` конфигурационного файла NGINX.

## Примеры настройки

Ниже приведены примеры настройки страницы блокировки и кода ошибки через директивы `wallarm_block_page` и `wallarm_block_page_add_dynamic_path`. Настройки применяются к запросам, в которых WAF‑нода обнаружила признаки атаки в [режиме](../configure-wallarm-mode.md) блокировки.

При настройке ответа на запрос, который отправлен с [заблокированного IP‑адреса](../configure-ip-blocking-ru.md), необходимо заменить название директивы `wallarm_block_page` на `wallarm_acl_block_page`.

### Путь до HTM- или HTML-файла со страницей блокировки и код ошибки

В примере приведены настройки для возвращения клиенту:

* Стандартной страницы блокировки Валарм и кода ошибки 445
* Собственной страницы блокировки `/usr/share/nginx/html/block.html` и кода ошибки 445

#### Конфигурационный файл NGINX

=== "Стандартная страница блокировки Валарм"
    ```bash
    wallarm_block_page &/usr/share/nginx/html/wallarm_blocked.html response_code=445;
    ```
=== "Собственная страница блокировки"
    ```bash
    wallarm_block_page &/usr/share/nginx/html/block.html response_code=445;
    ```

* Чтобы применить настройку к Docker-контейнеру, необходимо примонтировать в контейнер конфигурационный файл NGINX с необходимыми настройками. Если вы используете собственную страницу блокировки, ее также необходимо примонтировать в контейнер. [Запуск контейнера с примонтированным конфигурационным файлом →](../installation-docker-ru.md#запуск-контейнера-с-примонтированным-конфигурационным-файлом)
* Чтобы применить настройку к sidecar‑контейнеру, необходимо передать директиву в ConfigMap Валарм (инструкция для приложения, опубликованного с использованием [Helm Charts](../installation-guides/kubernetes/wallarm-sidecar-container-helm.md#шаг-1-создание-configmap-валарм) или [Kubernetes‑манифестов](../installation-guides/kubernetes/wallarm-sidecar-container-manifest.md#шаг-1-создание-configmap-валарм)).

#### Аннотация Ingress

=== "Стандартная страница блокировки Валарм"
    ```bash
    kubectl annotate ingress <INGRESS_NAME> nginx.ingress.kubernetes.io/wallarm-block-page='&/usr/share/nginx/html/wallarm_blocked.html response_code=445'
    ```
=== "Собственная страница блокировки"
    ```bash
    kubectl annotate ingress <INGRESS_NAME> nginx.ingress.kubernetes.io/wallarm-block-page='&/usr/share/nginx/html/block.html  response_code=445'
    ```

    Перед добавлением аннотации Ingress, необходимо:
    
    1. [Создать ConfigMap из файла](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-configmaps-from-files) `block.html`.
    2. Примонтировать созданный ConfigMap в pod с Ingress‑контроллером Валарм. Для этого необходимо изменить объект Deployment Ingress‑контроллера Валарм по [инструкции](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#populate-a-volume-with-data-stored-in-a-configmap).

        !!! info "Директория для монтирования ConfigMap"
            Рекомендуется использовать отдельную директорию для файлов, примонтированных с помощью ConfigMap. При монтировании файлов в существующую директорию, предыдущие файлы в этой директории могут быть удалены.

### URL для перенаправления клиента

В примере приведены настройки для перенаправления клиента на страницу `host/err445`.

#### Конфигурационный файл NGINX

```bash
wallarm_block_page /err445;
```

* Чтобы применить настройку к Docker-контейнеру, необходимо примонтировать в контейнер конфигурационный файл NGINX с необходимыми настройками. [Запуск контейнера с примонтированным конфигурационным файлом →](../installation-docker-ru.md#запуск-контейнера-с-примонтированным-конфигурационным-файлом)
* Чтобы применить настройку к sidecar‑контейнеру, необходимо передать директиву в ConfigMap Валарм (инструкция для приложения, опубликованного с использованием [Helm Charts](../installation-guides/kubernetes/wallarm-sidecar-container-helm.md#шаг-1-создание-configmap-валарм) или [Kubernetes‑манифестов](../installation-guides/kubernetes/wallarm-sidecar-container-manifest.md#шаг-1-создание-configmap-валарм)).

#### Аннотация Ingress

```bash
kubectl annotate ingress <INGRESS_NAME> nginx.ingress.kubernetes.io/wallarm-block-page='/err445'
```

### Именованный `location` NGINX

В примере приведены настройки для возвращения клиенту сообщения `The page is blocked` и кода ошибки 445.

#### Конфигурационный файл NGINX

```bash
wallarm_block_page @block;
location @block {
    return 445 'The page is blocked';
}
```

* Чтобы применить настройку к Docker-контейнеру, необходимо примонтировать в контейнер конфигурационный файл NGINX с необходимыми настройками. [Запуск контейнера с примонтированным конфигурационным файлом →](../installation-docker-ru.md#запуск-контейнера-с-примонтированным-конфигурационным-файлом)
* Чтобы применить настройку к sidecar‑контейнеру, необходимо передать директиву в ConfigMap Валарм (инструкция для приложения, опубликованного с использованием [Helm Charts](../installation-guides/kubernetes/wallarm-sidecar-container-helm.md#шаг-1-создание-configmap-валарм) или [Kubernetes‑манифестов](../installation-guides/kubernetes/wallarm-sidecar-container-manifest.md#шаг-1-создание-configmap-валарм)).

#### Аннотация Ingress

```bash
kubectl annotate ingress <INGRESS_NAME> nginx.ingress.kubernetes.io/server-snippet="location @block {return 445 'The page is blocked';}"
kubectl annotate ingress <INGRESS_NAME> nginx.ingress.kubernetes.io/wallarm-block-page='@block'
```

### Переменная и код ошибки

В зависимости от значенния заголовка `User-Agent`, клиенту возвращаются разные страницы блокировки:

* По умолчанию — стандартная страница блокировки Валарм `/usr/share/nginx/html/wallarm_blocked.html`. Страница содержит переменные NGINX, поэтому ее необходимо инициализировать в директиве `wallarm_block_page_add_dynamic_path`.
* Для пользователей Firefox — `/usr/share/nginx/html/block_page_firefox.html`:

    ```bash
    You are blocked!

    IP ${remote_addr}
    Blocked on ${time_iso8601}
    UUID ${request_id}
    ```

    Страница содержит переменные NGINX, поэтому ее необходимо инициализировать в директиве `wallarm_block_page_add_dynamic_path`.
* Для пользователей Chrome — `/usr/share/nginx/html/block_page_chrome.html`:

    ```bash
    You are blocked!
    ```

    Страница не содержит переменные NGINX, поэтому ее не нужно инициализировать.

#### Конфигурационный файл NGINX

```bash
wallarm_block_page_add_dynamic_path /usr/share/nginx/html/block_page_firefox.html /usr/share/nginx/html/wallarm_blocked.html;

map $http_user_agent $block_page {
  "~Firefox"  &/usr/share/nginx/html/block_page_firefox.html;
  "~Chrome"   &/usr/share/nginx/html/block_page_chrome.html;
  default     &/usr/share/nginx/html/wallarm_blocked.html;
}

wallarm_block_page $block_page;
```

* Чтобы применить настройку к Docker-контейнеру, необходимо примонтировать в контейнер конфигурационный файл NGINX с необходимыми настройками. Если вы используете собственную страницу блокировки, ее также необходимо примонтировать в контейнер. [Запуск контейнера с примонтированным конфигурационным файлом →](../installation-docker-ru.md#запуск-контейнера-с-примонтированным-конфигурационным-файлом)
* Чтобы применить настройку к sidecar‑контейнеру, необходимо передать директивы в ConfigMap Валарм (инструкция для приложения, опубликованного с использованием [Helm Charts](../installation-guides/kubernetes/wallarm-sidecar-container-helm.md#шаг-1-создание-configmap-валарм) или [Kubernetes‑манифестов](../installation-guides/kubernetes/wallarm-sidecar-container-manifest.md#шаг-1-создание-configmap-валарм)).

#### Ingress‑контроллер

1. После [клонирования репозитория](../installation-kubernetes-ru.md#шаг-1-установка-ingressконтроллера-валарм) с Helm‑чартом Валарм, необходимо открыть файл **values.yaml** клонированного репозитория и добавить в объект [`config`](https://github.com/wallarm/ingress-chart/blob/master/wallarm-ingress/values.yaml#L20) следующий параметр:

    ```bash
    config: {
        http-snippet: 'wallarm_block_page_add_dynamic_path /usr/test-block-page/blocked.html /usr/share/nginx/html/wallarm_blocked.html; map $http_user_agent $block_page { "~Firefox" &/usr/test-block-page/blocked.html; "~Chrome" &/usr/test-block-page/blocked-2.html; default &/usr/share/nginx/html/wallarm_blocked.html;}'
    }
    ```
2. Выполнить команду `helm install`, как описано в шаге 4 в [инструкции по установке](../installation-kubernetes-ru.md#шаг-1-установка-ingressконтроллера-валарм).
3. [Создать ConfigMap из файлов](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-configmaps-from-files) `block_page_firefox.html` и `block_page_chrome.html`.
4. Примонтировать созданный ConfigMap в pod с Ingress‑контроллером Валарм. Для этого необходимо изменить объект Deployment Ingress‑контроллера Валарм по [инструкции](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#populate-a-volume-with-data-stored-in-a-configmap).

    !!! info "Директория для монтирования ConfigMap"
        Рекомендуется использовать отдельную директорию для файлов, примонтированных с помощью ConfigMap. При монтировании файлов в существующую директорию, предыдущие файлы в этой директории могут быть удалены.
5. Добавить аннотацию к Ingress:

    ```bash
    kubectl annotate ingress dummy-ingress nginx.ingress.kubernetes.io/wallarm-block-page='$block_page'
    ```
