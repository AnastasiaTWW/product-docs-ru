# Настройка страницы блокировки и кода ошибки

Данная инструкция описывает способ настройки страницы и кода ошибки, которые возвращаются клиенту в ответ на заблокированный запрос.

## Способы настройки

Настройка страницы блокировки и кода ответа выполняется через директивы NGINX. Набор директив зависит от причины и способа блокировки запроса:

* Если запрос содержит признаки атаки и WAF‑нода работает в [режиме](../configure-wallarm-mode.md) блокировки: `wallarm_block_page`
* Если запрос отправлен с [заблокированного IP‑адреса](../configure-ip-blocking-ru.md): `wallarm_acl_block_page`

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

Директива `wallarm_block_page` может быть передана в блоках `http`, `server`, `location` конфигурационного файла NGINX.

### wallarm_acl_block_page

Директива `wallarm_acl_block_page` используется для настройки ответа на запрос, который был отправлен с [заблокированного IP‑адреса](../configure-ip-blocking-ru.md).

Директива принимает значения в таком же формате, как и [`wallarm_block_page`](#wallarm_block_page).

## Примеры настройки

Ниже приведены примеры настройки страницы блокировки и кода ошибки через директиву `wallarm_block_page`. Настройки применяются к запросам, в которых WAF‑нода обнаружила признаки атаки в [режиме](../configure-wallarm-mode.md) блокировки.

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

--8<-- "../include/waf/acl-block-page-annotation-support.md"

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

--8<-- "../include/waf/acl-block-page-annotation-support.md"

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

--8<-- "../include/waf/acl-block-page-annotation-support.md"
