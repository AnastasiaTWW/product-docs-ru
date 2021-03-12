# Как работает sidecar‑контейнер Валарм

WAF‑нода Валарм устанавливается в виде sidecar‑контейнера в один pod с основным контейнером приложения. Нода фильтрует запросы, которые поступают приложению, и пропускает в основной контейнер только легитимные. 

Kubernetes запускает sidecar‑контейнер одновременно с образом основного контейнера. Также, sidecar‑контейнер и контейнер основного приложения имеют одинаковый жизненный цикл.

!!! info "Смотрите также"
    * [Типы контейнеров в pod'е Kubernetes](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/)

## Движение запросов

Обычно, доступность pod'ов Kubernetes определяется в объекте `Service` с типом `ClusterIP` или `NodePort`. Ниже приведены примеры движения запросов без Sidecar‑контейнера Валарм и с Sidecar‑контейнером Валарм для архитектуры с объектом `Service` типа `ClusterIP` или `NodePort`.

### Схема движения запросов без sidecar‑контейнера Валарм

Если контейнер приложения принимает запросы на порт `8080/TCP`, объект `Service` перенаправляет запросы pod'ам приложения на такой же порт `8080/TCP`. Порт для перенаправления запросов настраивается в объекте `Deployment` в Kubernetes.

![!Схема движения запросов без sidecar‑контейнера Валарм](../../../images/admin-guides/kubernetes/requests-scheme-without-wallarm-sidecar.png)

### Схема движения запросов с sidecar‑контейнером Валарм

Если контейнер приложения принимает запросы на порт `8080/TCP`, объект `Service` перенаправляет запросы Sidecar‑контейнеру Валарм на другой порт (например, `80/TCP`). Sidecar‑контейнер Валарм фильтрует запросы и перенаправляет легитимные pod'ам приложения на порт `8080/TCP`.

![!Схема движения запросов с sidecar‑контейнером Валарм](../../../images/admin-guides/kubernetes/requests-scheme-with-wallarm-sidecar.png)

При настройке Sidecar‑контейнера Валарм необходимо изменить номера портов в конфигурационных файлах. Более подробное описание приведено в инструкциях.

## Установка Sidecar‑контейнера Валарм

Способ установки контейнера зависит от схемы публикации приложения в Kubernetes. Выберите вашу схему ниже и следуйте инструкциям:
* [Публикация приложения с использованием Helm Charts](wallarm-sidecar-container-helm.md)
* [Публикация приложения с использованием Kubernetes-манифестов](wallarm-sidecar-container-manifest.md)

## Демо‑видео

<div class="video-wrapper">
  <iframe width="1280" height="720" src="https://www.youtube.com/embed/N5mEXPoU2Lw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>