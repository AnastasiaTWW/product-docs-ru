**Укажите объем оперативной памяти для Tarantool**

Количество памяти влияет на качество работы статистических алгоритмов.
Рекомендуемое значение — 75% от общей памяти сервера. Например, если у сервера
32 ГБ памяти, оптимально выделить под хранилище 24 ГБ.

Откройте конфигурационный файл Tarantool:

=== "Debian 8.x (jessie)"
    ```bash
    sudo vim /etc/default/wallarm-tarantool
    ```
=== "Debian 9.x (stretch)"
    ```bash
    sudo vim /etc/default/wallarm-tarantool
    ```
=== "Ubuntu 14.04 LTS (trusty)"
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
=== "CentOS 6.x"
    ```bash
    sudo vim /etc/sysconfig/wallarm-tarantool
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

**Настройте адреса сервера постаналитики**

Раскоментируйте переменные HOST и PORT и установите им следующие значения:

```
# address and port for bind
HOST='0.0.0.0'
PORT=3313
```

**Перезапустите Tarantool**

=== "Debian 8.x (jessie)"
    ```bash
    sudo systemctl restart wallarm-tarantool
    ```
=== "Debian 9.x (stretch)"
    ```bash
    sudo systemctl restart wallarm-tarantool
    ```
=== "Ubuntu 14.04 LTS (trusty)"
    ```bash
    sudo service wallarm-tarantool restart
    ```
=== "Ubuntu 16.04 LTS (xenial)"
    ```bash
    sudo systemctl restart wallarm-tarantool
    ```
=== "Ubuntu 18.04 LTS (bionic)"
    ```bash
    sudo systemctl restart wallarm-tarantool
    ```
=== "CentOS 6.x"
    ```bash
    sudo service wallarm-tarantool restart
    ```
=== "CentOS 7.x"
    ```bash
    sudo systemctl restart wallarm-tarantool
    ```