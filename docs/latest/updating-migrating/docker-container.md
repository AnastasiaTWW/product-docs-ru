[waf-mode-instr]:                   ../admin-ru/configure-wallarm-mode.md
[logging-instr]:                    ../admin-ru/configure-logging.md
[proxy-balancer-instr]:             ../admin-ru/using-proxy-or-balancer-ru.md
[scanner-whitelisting-instr]:       ../admin-ru/scanner-ips-whitelisting.md
[process-time-limit-instr]:         ../admin-ru/configure-parameters-ru.md#wallarm_process_time_limit
[default-ip-blocking-settings]:     ../admin-ru/configure-ip-blocking-nginx-ru.md
[wallarm-acl-directive]:            ../admin-ru/configure-parameters-ru.md#wallarm_acl
[allocating-memory-guide]:          ../admin-ru/configuration-guides/allocate-resources-for-waf-node.md
[enable-libdetection-docs]:         ../admin-ru/configure-parameters-ru.md#wallarm_enable_libdetection

# Обновление запущенного Docker‑образа на основе NGINX или Envoy

Инструкция описывает способ обновления запущенного Docker‑образа на основе NGINX или Envoy до версии 2.18.

!!! warning "Использование данных существующей WAF‑ноды"
    Мы не рекомендуем использовать уже созданную WAF‑ноду предыдущей версии. Пожалуйста, используйте данную инструкцию, чтобы создать новую WAF‑ноду версии 2.18 и развернуть Docker‑контейнер с новой версией.

## Требования

--8<-- "../include/waf/installation/requirements-docker.md"

## Шаг 1: Загрузите обновленный образ

=== "Образ на основе NGINX"
    ``` bash
    docker pull wallarm/node:2.18.0-3
    ```
=== "Образ на основе Envoy"
    ``` bash
    docker pull wallarm/envoy:2.18.0-1
    ```

## Шаг 2: Остановите текущий контейнер

```bash
docker stop <RUNNING_CONTAINER_NAME>
```

## Шаг 3: Запустите контейнер на основе нового образа

При запуске контейнера на основе нового образа, вы можете использовать те же параметры конфигурации, которые были переданы с предыдущей версией образа. Набор параметров, которые больше не используются или были добавлены в новой версии WAF‑ноды, публикуется в списке [изменений в новой версии WAF‑ноды](what-is-new.md).

Вы можете передать параметры конфигурации в контейнер одним из следующих способов:

* **Через переменные окружения** для базовой настройки WAF‑ноды
    * [Перейти к иструкции для Docker-контейнера на основе NGINX →](../admin-ru/installation-docker-ru.md#запуск-контейнера-с-переменными-окружения)
    * [Перейти к иструкции для Docker-контейнера на основе Envoy →](../admin-ru/installation-guides/envoy/envoy-docker.md#запуск-контейнера-с-переменными-окружения)
* **В примонтированном конфигурационном файле** для расширенной настройки WAF‑ноды
    * [Перейти к иструкции для Docker-контейнера на основе NGINX →](../admin-ru/installation-docker-ru.md#запуск-контейнера-с-примонтированным-конфигурационным-файлом)
    * [Перейти к иструкции для Docker-контейнера на основе Envoy →](../admin-ru/installation-guides/envoy/envoy-docker.md#запуск-контейнера-с-примонтированным-конфигурационным-файлом)

## Шаг 4: Протестируйте работу Валарм WAF

--8<-- "../include/waf/installation/test-waf-operation-no-stats.md"

## Шаг 5: Удалите WAF‑ноду предыдущей версии

Если развернутый образ версии 2.18 работает корректно, вы можете удалить WAF‑ноду предыдущей версии в Консоли управления Валарм → секция **Ноды**.
