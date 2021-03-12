# Повышение стабильности работы Ingress‑контроллера

--8<-- "../include/ingress-controller-best-practices-intro.md"

Рекомендации по повышению стабильности работы Ingress‑контроллера ниже применяются к production-окружениям.

* Используйте более одного pod'a Ingress‑контроллера. Количество настраивается в файле `values.yaml` > атрибут `controller.replicaCount`. Например:
    ```
    controller:
        replicaCount: 2
    ```
* Расположите pod'ы Ingress‑контроллеров на разных WAF‑нодах в кластере Kubernetes для увеличения стабильности Ingress в случае ошибки на стороне ноды. Настройка выполняется в файле `values.yaml` > атрибут `controller.affinity.podAntiAffinity`. Например:
    ```
    controller:
        affinity:
            podAntiAffinity:
                requiredDuringSchedulingIgnoredDuringExecution:
                - labelSelector:
                    matchExpressions:
                    - key: app
                      operator: In
                      values:
                      - nginx-ingress
                topologyKey: "kubernetes.io/hostname"
    ```
* Используйте [модуль горизонтального масштабирования](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) Kubernetes (HPA) для кластеров, которые могут подвергаться скачкам трафика или другим событиям. Включение выполняется в файле `values.yaml` > атрибут `controller.autoscaling`. Например:
    ```
    controller:
        autoscaling:
            enabled: true
            minReplicas: 1
            maxReplicas: 11
            targetCPUUtilizationPercentage: 50
            targetMemoryUtilizationPercentage: 50
    ```
* Запустите как минимум 2 экземпляра модуля постаналитики Валарм на основе базы данных Tarantool. Pod'ы для модулей в Kubernetes содержат в названии `ingress‑controller‑wallarm‑tarantool`. Настройка количества экземпляров выполняется в файле `values.yaml` > атрибут `controller.wallarm.tarantool.replicaCount`. Например:
    ```
    controller:
        wallarm:
            tarantool:
                replicaCount: 2
    ```