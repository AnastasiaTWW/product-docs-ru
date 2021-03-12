[link-ingress-controller-deploy]:     deploy.md
[link-ingress-controller-assembly]:   assembly.md
[link-ingress-resource-creation]:     resource-creation.md
[link-wallarm-services-check]:        wallarm-services-check.md

# Введение

Перед развертыванием Ingress‑контроллера NGINX Plus с сервисами Валарм (далее — Ingress‑контроллер Валарм NGINX Plus) его необходимо собрать из исходных файлов. 

Данное руководство описывает процесс сборки, конфигурирования и развертывания Ingress‑контроллера Валарм NGINX Plus. Также будет предоставлен пример конфигурирования ресурса Ingress (Ingress resource) для тестового веб‑приложения Café.

Чтобы развернуть Ingress‑контроллер Валарм NGINX Plus, выполните следующие действия:

1.   [Соберите Ingress‑контроллер][link-ingress-controller-assembly].
2.   [Разверните Ingress‑контроллер][link-ingress-controller-deploy].
3.   [Создайте ресурс Ingress (Ingress resource)][link-ingress-resource-creation].
4.   [Проверьте работоспособность сервисов Валарм (опционально)][link-wallarm-services-check].

--8<-- "../include/ingress-k8s-limitations.md"