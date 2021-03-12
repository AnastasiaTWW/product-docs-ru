Количество памяти влияет на качество работы статистических алгоритмов. Рекомендуемое значение — 75% от общей памяти сервера. Например, если у сервера 32 ГБ памяти, оптимально выделить под хранилище 24 ГБ.

**Укажите объем оперативной памяти для Tarantool:**

Откройте конфигурационный файл Tarantool:

=== "Debian 9.x (stretch)"
    ```bash
    sudo vim /etc/default/wallarm-tarantool
    ```
=== "Ubuntu 16.04 LTS (xenial)"
    ```bash
    sudo vim /etc/default/wallarm-tarantool
    ```
=== "Ubuntu 18.04 LTS (bionic)"
    ```bash
    sudo vim /etc/default/wallarm-tarantool
    ```
=== "CentOS 7.x"
    ```bash
    sudo vim /etc/sysconfig/wallarm-tarantool
    ```


Укажите размер выделяемой памяти в конфигурационном файле Tarantool директивой `SLAB_ALLOC_ARENA`. Значение может быть целым или дробным (разделитель целой и дробной части — точка).

Например:

```
SLAB_ALLOC_ARENA=24
```

**Перезапустите Tarantool:**

=== "Debian 9.x (stretch)"
    ```bash
    sudo systemctl restart wallarm-tarantool
    ```
=== "Ubuntu 16.04 LTS (xenial)"
    ```bash
    sudo service wallarm-tarantool restart
    ```
=== "Ubuntu 18.04 LTS (bionic)"
    ```bash
    sudo service wallarm-tarantool restart
    ```
=== "CentOS 7.x"
    ```bash
    sudo systemctl restart wallarm-tarantool
    ```