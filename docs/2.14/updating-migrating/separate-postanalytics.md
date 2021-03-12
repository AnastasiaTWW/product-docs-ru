[docs-module-update]:   nginx-modules.md

#   Обновление отдельно установленного модуля постаналитики

Инструкция описывает способ обновления модуля постаналитики, установленного на отдельном сервере. Модуль постаналитики обновляется перед [обновлением модуля WAF‑ноды][docs-module-update].

## Шаг 1: Подключите новые репозитории Валарм WAF

--8<-- "../include/migration-212-214/add-new-repo.md"

## Шаг 2: Установите обновленные пакеты Tarantool

=== "Debian"
    ```bash
    sudo apt install wallarm-node-tarantool
    ```
=== "Ubuntu"
    ```bash
    sudo apt install wallarm-node-tarantool
    ```
=== "CentOS или Amazon Linux 2"
    ```bash
    sudo yum update wallarm-node-tarantool
    ```

## Шаг 3: Перезапустите модуль постаналитики

=== "Debian"
    ```bash
    sudo systemctl restart wallarm-tarantool
    ```
=== "Ubuntu"
    ```bash
    sudo service wallarm-tarantool restart
    ```
=== "CentOS 6.x"
    ```bash
    sudo service wallarm-tarantool restart
    ```
=== "CentOS 7.x или Amazon Linux 2"
    ```bash
    sudo systemctl restart wallarm-tarantool
    ```
