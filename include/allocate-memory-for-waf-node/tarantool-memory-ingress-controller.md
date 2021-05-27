Настройка памяти Tarantool для pod'а `ingress-controller-wallarm-tarantool` выполяется в следующем блоке файла `values.yaml`:

* Для передачи значения в Гбит:
    ```
    controller:
      wallarm:
        tarantool:
          arena: "0.2"
    ```

* Для передачи количества ядер ЦП:
    ```
    controller:
      wallarm:
        tarantool:
          resources:
            limits:
              cpu: 1000m
              memory: 1640Mi
            requests:
              cpu: 1000m
              memory: 1640Mi
    ```
