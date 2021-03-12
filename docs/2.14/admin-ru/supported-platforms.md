[link-wallarm-account]:         https://my.wallarm.com
[link-wallarm-account-ru]:      https://my.wallarm.ru

[link-doc-nginx-overview]:      installation-nginx-overview.md

[link-ig-ingress-nginx]:        installation-kubernetes-ru.md
[link-ig-ingress-nginx-d2iq]:   https://docs.d2iq.com/ksphere/konvoy/partner-solutions/wallarm/
[link-ig-ingress-nginxplus]:    installation-guides/ingress-plus/introduction.md
[link-ig-aws]:                  installation-ami-ru.md
[link-ig-gcloud]:               installation-gcp-ru.md
[link-ig-heroku]:               installation-heroku-ru.md
[link-ig-docker-nginx]:         installation-docker-ru.md
[link-ig-vmware-vapp]:          installation-vmware-ru.md
[link-ig-kong]:                 installation-kong-ru.md

#   Поддерживаемые платформы

!!! info "Необходимые условия для установки"
    Чтобы установить WAF‑ноду, вам необходимы:
    
    *   Поддерживаемая платформа
    *   Возможность выполнять команды с правами `root`
    *   Аккаунт Валарм в [RU‑облаке][link-wallarm-account-ru] или [EU‑облаке][link-wallarm-account]
    
WAF‑нода Валарм может быть установлена на следующие платформы:

*   NGINX и NGINX Plus
    
    Интеграция WAF‑ноды с NGINX или NGINX Plus осуществляется с помощью нескольких модулей. 
    
    Существует [несколько вариантов установки модулей][link-doc-nginx-overview]. Выбор конкретного варианта зависит от того, каким образом был установлен NGINX или NGINX Plus.
    
    Также вы можете [развернуть WAF‑ноду с помощью Docker][link-ig-docker-nginx]. Контейнер с WAF‑нодой содержит в себе все необходимые модули.
    
    !!! info "Поддерживаемые операционные системы"
        Модули Валарм могут быть установлены на следующие операционные системы:
        
        *   Debian 8.x (jessie-backports)
        *   Debian 9.x (stretch)
        *   Debian 10.x (buster)
        *   Ubuntu 16.04 LTS (xenial)
        *   Ubuntu 18.04 LTS (bionic)
        *   CentOS 6.x
        *   CentOS 7.x
        *   Amazon Linux 2
    
    !!! warning "Требования к разрядности операционной системы"
        Установка модулей возможна только на 64-битные операционные системы.
    
*   Кластер Kubernetes

    !!! warning "Поддержка платформы Kubernetes"
        Обратите внимание, что Ingress‑контроллеры NGINX или NGINX Plus Валарм работают только на платформе Kubernetes версии 1.16 и ниже. 
    
    Вы можете установить WAF‑ноду в кластере Kubernetes в следующих вариантах:

    *   Ingress‑контроллер NGINX с сервисами Валарм ([инструкция по установке][link-ig-ingress-nginx]);
    
        !!! info "Поддержка Konvoy"
            Обратите внимание, что вы можете развернуть такой Ingress‑контроллер в том числе с помощью Konvoy от компании D2IQ, ранее известной как Mesosphere.
            
            [Инструкция по установке от Валарм][link-ig-ingress-nginx] подходит и для Konvoy. Также вы можете ознакомиться с [инструкцией по установке от D2IQ][link-ig-ingress-nginx-d2iq] (на английском языке).
    
    *   Ingress‑контроллер NGINX Plus с сервисами Валарм ([инструкция по установке][link-ig-ingress-nginxplus]).
*   Облачные платформы:
    *   Amazon AWS ([инструкция по установке][link-ig-aws]);
    *   Google Cloud ([инструкция по установке][link-ig-gcloud]);
    *   Heroku со стеком Heroku-16 или Heroku-18 ([инструкция по установке][link-ig-heroku]).
*   Kong ([инструкция по установке][link-ig-kong])

    !!! info "Поддерживаемые операционные системы"
        Для работы с модулями Валарм платформа Kong должна иметь версию 1.4.3 или ниже и должна быть установлена на операционную систему из следующего списка:
        
        *   Debian 9.x (stretch)
        *   Ubuntu 16.04 LTS (xenial)
        *   Ubuntu 18.04 LTS (bionic)
        *   CentOS 6.x
        *   CentOS 7.x
