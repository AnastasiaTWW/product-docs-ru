[kong-install]:         https://konghq.com/get-started/#install
[kong-docs]:            https://getkong.org/docs/
[kong-admin-api]:       https://getkong.org/docs/0.10.x/admin-api/

[doc-wallarm_block_page]: ../admin-ru/configure-parameters-ru.md#wallarm_block_page
[doc-postanalytics]:    installation-postanalytics-ru.md
[doc-supported-os]:     supported-platforms.md

# Установка на платформу Kong

!!! info "Необходимые условия"
    Платформа Kong должна соответствовать следующим требованиям:
    
    * Kong версии 1.4.3 или ниже
    * Установлена в соответствии с [официальными инструкциями][kong-install] для одного из [поддерживаемых Валарм дистрибутивов][doc-supported-os]

    Обратите внимание, что для корректной работы Kong требуются:
    
    * либо подготовленные конфигурационные файлы,
    * либо настроенная база данных.
    
    Убедитесь, что один из этих пунктов выполнен, прежде чем переходить к установке модулей Валарм.
    
    Смотрите также официальную [документацию Kong][kong-docs].

!!! warning "Известные ограничения"
    * Не поддерживается директива [`wallarm_block_page`][doc-wallarm_block_page].
    * Не поддерживается настройка через [Kong Admin API][kong-admin-api].

## Установка

!!! warning "Установка постаналитики на отдельный сервер"
    Если вы планируете установить модуль постаналитики на отдельный сервер, необходимо сначала установить его. Подробнее в [Отдельная установка модуля постаналитики][doc-postanalytics].

Установка модуля Валарм на платформу Kong проходит следующим образом:

1. Добавление репозиториев Валарм.
2. Установка пакетов Валарм.
3. Настройка постаналитики.
4. Настройка WAF‑ноды для использования прокси‑сервера.
5. Подключение WAF‑ноды к облаку Валарм.
6. Настройка адреса сервера постаналитики.
7. Настройка режима фильтрации.
8. Настройка логирования.

--8<-- "../include/elevated-priveleges.md"

!!! info "Если Валарм WAF уже установлен"
    Если вы устанавливаете Валарм WAF вместо существующего Валарм WAF или дублируете установку, используйте версию существующего Валарм WAF или обновите версии всех установок до последней. Для отдельно установленной постаналитики также необходимо использовать одинаковые версии при замене или дублировании установок.

    Чтобы получить установленную версию, если WAF‑нода и постаналитика расположены на одном сервере:

    === "Debian"
        ```bash
        apt list wallarm-node
        ```
    === "Ubuntu"
        ```bash
        apt list wallarm-node
        ```
    === "CentOS"
        ```bash
        yum list wallarm-node
        ```
    
    Чтобы получить версии WAF‑ноды и постаналитики, установленных на разных серверах:

    === "Debian"
        ```bash
        # выполните на сервере с WAF‑нодой
        apt list wallarm-node-nginx
        # выполните на сервере с постаналитикой
        apt list wallarm-node-tarantool
        ```
    === "Ubuntu"
        ```bash
        # выполните на сервере с WAF‑нодой
        apt list wallarm-node-nginx
        # выполните на сервере с постаналитикой
        apt list wallarm-node-tarantool
        ```
    === "CentOS"
        ```bash
        # выполните на сервере с WAF‑нодой
        yum list wallarm-node-nginx
        # выполните на сервере с постаналитикой
        yum list wallarm-node-tarantool
        ```
    
    * Если установлена версия `2.18`, используйте [инструкцию для WAF‑ноды 2.18](../../../admin-ru/installation-kong-ru/) и для [отдельной постаналитики версии 2.18](../../../admin-ru/installation-postanalytics-ru/).
    * Если установлена версия `2.16`, используйте текущую инструкцию для WAF‑ноды и для [отдельной постаналитики 2.16](../../../2.16/admin-ru/installation-postanalytics-ru/) или обновите [пакеты WAF‑ноды](../../../updating-migrating/nginx-modules/) и [пакеты отдельной постаналитики](../../../updating-migrating/separate-postanalytics/) до последней версии для всех установок.
    * Если установлена версия `2.14` или ниже, обновите [пакеты WAF‑ноды](../../../updating-migrating/nginx-modules/) и [пакеты отдельной постаналитики](../../../updating-migrating/separate-postanalytics/) до последней версии для всех установок.

    Более подробная информация о поддержке версий доступна в [политике версионирования WAF‑ноды](../updating-migrating/versioning-policy.md).

## 1. Добавьте репозитории Валарм

Установка и обновление WAF‑ноды происходит из репозиториев Валарм.

В зависимости от вашей операционной системы, выполните одну из следующих команд:

=== "Debian 9.x (stretch)"
    ```bash
    sudo apt install dirmngr
    curl -fsSL https://repo.wallarm.com/wallarm.gpg | sudo apt-key add -
    sh -c "echo 'deb http://repo.wallarm.com/debian/wallarm-node stretch/2.16/' | sudo tee /etc/apt/sources.list.d/wallarm.list"
    sudo apt update
    ```
=== "Ubuntu 16.04 LTS (xenial)"
    ```bash
    curl -fsSL https://repo.wallarm.com/wallarm.gpg | sudo apt-key add -
    sh -c "echo 'deb http://repo.wallarm.com/ubuntu/wallarm-node xenial/2.16/' | sudo tee /etc/apt/sources.list.d/wallarm.list"
    sudo apt update
    ```
=== "Ubuntu 18.04 LTS (bionic)"
    ```bash
    curl -fsSL https://repo.wallarm.com/wallarm.gpg | sudo apt-key add -
    sh -c "echo 'deb http://repo.wallarm.com/ubuntu/wallarm-node bionic/2.16/' | sudo tee /etc/apt/sources.list.d/wallarm.list"
    sudo apt update
    ```
=== "CentOS 7.x"
    ```bash
    sudo yum install -y epel-release
    sudo rpm -i https://repo.wallarm.com/centos/wallarm-node/7/2.16/x86_64/Packages/wallarm-node-repo-1-5.el7.noarch.rpm
    ```

--8<-- "../include/access-repo-ru.md"

## 2. Установите пакеты Валарм

Для установки WAF‑ноды и постаналитики на одном сервере выполните
следующую команду:

=== "Debian 9.x (stretch)"
    ```bash
    sudo apt install --no-install-recommends wallarm-node kong-module-wallarm
    ```
=== "Ubuntu 16.04 LTS (xenial)"
    ```bash
    sudo apt install --no-install-recommends wallarm-node kong-module-wallarm
    ```
=== "Ubuntu 18.04 LTS (bionic)"
    ```bash
    sudo apt install --no-install-recommends wallarm-node kong-module-wallarm
    ```
=== "CentOS 7.x"
    ```bash
    sudo yum install wallarm-node kong-module-wallarm
    ```

Для установки только WAF‑ноды выполните следующую команду:

=== "Debian 9.x (stretch)"
    ```bash
    sudo apt install --no-install-recommends wallarm-node-nginx kong-module-wallarm
    ```
=== "Ubuntu 16.04 LTS (xenial)"
    ```bash
    sudo apt install --no-install-recommends wallarm-node-nginx kong-module-wallarm
    ```
=== "Ubuntu 18.04 LTS (bionic)"
    ```bash
    sudo apt install --no-install-recommends wallarm-node-nginx kong-module-wallarm
    ```
=== "CentOS 7.x"
    ```bash
    sudo yum install wallarm-node-nginx kong-module-wallarm
    ```

## 3. Настройте постаналитику

!!! info
    Пропустите этот шаг, если постаналитика установлена на отдельный сервер. Вы уже настроили постаналитику во время отдельной установки.

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

## 4. Настройте WAF‑ноду для использования прокси‑сервера

--8<-- "../include/setup-proxy.md"

## 5. Подключите WAF‑ноду к облаку Валарм

--8<-- "../include/connect-cloud-ru.md"

## 6. Настройте адреса сервера постаналитики

!!! info
    * Пропустите данный шаг, если постаналитика и WAF‑нода установлены на один сервер.
    * Выполните данный шаг, если постаналитика и WAF‑нода установлены на разные серверы.

--8<-- "../include/configure-postanalytics-address-kong-ru.md"

## 7. Настройте режим фильтрации

--8<-- "../include/setup-filter-kong-ru.md"

## 8. Настройте логирование

--8<-- "../include/installation-step-logging.md"

## Запуск Kong

Запуск Kong с установленным Валарм выполняется следующей командой:

``` bash
kong start --nginx-conf /etc/kong/nginx-wallarm.template
```

## Установка завершена

На этом установка завершена.

--8<-- "../include/check-setup-installation-ru.md"

--8<-- "../include/filter-node-defaults.md"

--8<-- "../include/installation-extra-steps.md"