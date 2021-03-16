| Платформа                                                                                             | Форма установки                       |
| ----------------------------------------------------------------------------------------------------- | ------------------------------------- |
| NGINX `stable`, установленный на 64‑битную ОС:<ul><li>Debian 9.x (stretch)</li><li>Debian 10.x (buster)</li><li>Ubuntu 16.04 LTS (xenial)</li><li>Ubuntu 18.04 LTS (bionic)</li><li>Ubuntu 20.04 LTS (focal)</li><li>CentOS 7.x</li><li>CentOS 8.x</li><li>Amazon Linux 2</li></ul> | <ul><li>[Модуль для NGINX `stable` из репозитория NGINX](../waf-installation/nginx/dynamic-module.md)</li><li>[Модуль для NGINX `stable` из репозитория Debian/CentOS](../waf-installation/nginx/dynamic-module-from-distr.md)</li></ul>                                                                                                   |
| NGINX Plus                                                                                            | <ul><li>[Модуль для NGINX Plus](../waf-installation/nginx-plus.md)</li></ul>                                                                                                       |
| Docker                                                                                                | <ul><li>[Docker‑контейнер с модулями NGINX](../admin-ru/installation-docker-ru.md)</li><li>[Docker‑контейнер с модулями Envoy](../admin-ru/installation-guides/envoy/envoy-docker.md)</li></ul>                                                                                                                                             |
| Kubernetes версии 1.20 или ниже                                                                              | <ul><li>[Ingress‑контроллер NGINX](../admin-ru/installation-kubernetes-ru.md)<br>Вы можете развернуть Ingress‑контроллер в том числе с помощью Konvoy от компании D2IQ (Mesosphere). Для этого используйте инструкцию по ссылке выше или [инструкцию от D2IQ](https://docs.d2iq.com/ksphere/konvoy/partner-solutions/wallarm/).</li><li>[Sidecar‑контейнер](../admin-ru/installation-guides/kubernetes/wallarm-sidecar-container.md)</li></ul>                                                                                                         |
| Облачные платформы                                                                                    | <ul><li>[Образ AWS](../admin-ru/installation-ami-ru.md)</li><li>[Образ Google Cloud Platform](../admin-ru/installation-gcp-ru.md)</li><li>[Образ Яндекс.Облако](../admin-ru/installation-guides/install-in-yandex-cloud.md)</li></ul>                                                                                      |
| Kong 1.4.3 и ниже, установленный на 64‑битную ОС:<br><ul><li>Debian 9.x (stretch)</li><li>Ubuntu 16.04 LTS (xenial)</li><li>Ubuntu 18.04 LTS (bionic)</li><li>Ubuntu 20.04 LTS (focal)</li><li>CentOS 7.x</li></ul>                                                                   | <ul><li>[Модуль для Kong](../admin-ru/installation-kong-ru.md)</li></ul>                                                                                                                                        |