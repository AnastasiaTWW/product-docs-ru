[link-wallarm-account]:         https://my.wallarm.com
[link-wallarm-account-ru]:      https://my.wallarm.ru

[link-doc-nginx-overview]:      installation-nginx-overview.md

[link-ig-ingress-nginx]:        installation-kubernetes-ru.md
[link-ig-ingress-nginx-d2iq]:   https://docs.d2iq.com/ksphere/konvoy/partner-solutions/wallarm/
[link-ig-aws]:                  installation-ami-ru.md
[link-ig-gcloud]:               installation-gcp-ru.md
[link-ig-docker-nginx]:         installation-docker-ru.md
[link-ig-vmware-vapp]:          installation-vmware-ru.md
[link-ig-kong]:                 installation-kong-ru.md

# Поддерживаемые платформы

WAF‑нода Валарм может быть установлена на следующие платформы:

| Платформа                                                                                             | Форма установки                       |
| ----------------------------------------------------------------------------------------------------- | ------------------------------------- |
| NGINX `stable`, установленный на 64‑битную ОС:<ul><li>Debian 9.x (stretch)</li><li>Debian 10.x (buster)</li><li>Ubuntu 16.04 LTS (xenial)</li><li>Ubuntu 20.04 LTS (focal)</li><li>Ubuntu 18.04 LTS (bionic)</li><li>CentOS 7.x</li><li>CentOS 8.x</li><li>Amazon Linux 2</li></ul> | <ul><li>[Модуль для NGINX `stable` из репозитория NGINX](../waf-installation/nginx/dynamic-module.md)</li><li>[Модуль для NGINX `stable` из репозитория Debian/CentOS](../waf-installation/nginx/dynamic-module-from-distr.md)</li></ul>                                                                                                   |
| NGINX Plus                                                                                            | <ul><li>[Модуль для NGINX Plus](../waf-installation/nginx-plus.md)</li></ul>                                                                                                       |
| Docker                                                                                                | <ul><li>[Docker‑контейнер с модулями NGINX](installation-docker-ru.md)</li><li>[Docker‑контейнер с модулями Envoy](installation-guides/envoy/envoy-docker.md)</li></ul>                                                                                                                                             |
| Kubernetes версии 1.20 или ниже                                                                              | <ul><li>[Ingress‑контроллер NGINX][link-ig-ingress-nginx]<br>Вы можете развернуть Ingress‑контроллер в том числе с помощью Konvoy от компании D2IQ (Mesosphere). Для этого используйте инструкцию по ссылке выше или [инструкцию от D2IQ][link-ig-ingress-nginx-d2iq].</li><li>[Sidecar‑контейнер](installation-guides/kubernetes/wallarm-sidecar-container.md)</li></ul>                                                                                                         |
| Облачные платформы                                                                                    | <ul><li>[Образ AWS](installation-ami-ru.md)</li><li>[Образ Google Cloud Platform](installation-gcp-ru.md)</li><li>[Образ Яндекс.Облако](installation-guides/install-in-yandex-cloud.md)</li></ul>                                                                                      |
| Kong 1.4.3 и ниже, установленный на 64‑битную ОС:<br><ul><li>Debian 9.x (stretch)</li><li>Ubuntu 16.04 LTS (xenial)</li><li>Ubuntu 18.04 LTS (bionic)</li><li>Ubuntu 20.04 LTS (focal)</li><li>CentOS 7.x</li></ul>                                                                   | <ul><li>[Модуль для Kong][link-ig-kong]</li></ul>                                                                                                                                        |
