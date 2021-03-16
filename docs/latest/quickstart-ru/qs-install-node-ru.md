[img-wl-console-users]:             ../images/check-users.png 
[memory-instr]:                     ../admin-ru/configuration-guides/allocate-resources-for-waf-node.md

# Установка и подключение WAF‑ноды на основе NGINX

## Обзор способа установки

Обработка запросов в Валарм WAF делится на две фазы:

1. Первичная обработка в модуле NGINX-Wallarm
2. Статистический анализ обработанных запросов в модуле постаналитики

В зависимости от архитектуры системы, модуль NGINX-Wallarm и модуль постаналитики могут быть установлены **на один сервер** или **на разные серверы**.

Данная инструкция описывает установку модулей NGINX-Wallarm и постаналитики **на один сервер**. WAF‑нода Валарм будет установлена как динамический модуль к бесплатной версии NGINX `stable`, установленной из репозитория NGINX.

[Список всех доступных форм установки →](../admin-ru/supported-platforms.md)

## Требования

* Доступ к аккаунту с [ролью](../user-guides/settings/users.md) **Администратор** или **Деплой** и отключенной двухфакторной аутентификацией в Консоли управления Валарм для [RU‑облака](https://my.wallarm.ru/) или [EU‑облака](https://my.wallarm.com/)
* Выполнение команд от имени суперпользователя (например, `root`)
* Поддерживаемая 64‑битная ОС:
    * Debian 9.x (stretch)
    * Debian 10.x (buster)
    * Ubuntu 16.04 LTS (xenial)
    * Ubuntu 18.04 LTS (bionic)
    * Ubuntu 20.04 LTS (focal)
    * CentOS 7.x
    * Amazon Linux 2
    * CentOS 8.x
* SELinux, отключенный или настроенный по [инструкции](../admin-ru/configure-selinux.md)
* Возможность обращаться к `https://repo.wallarm.com` для загрузки пакетов. Убедитесь, что доступ не ограничен настройками файервола
* Доступ к `https://api.wallarm.com:444` для работы с EU‑облаком Валарм или к `https://api.wallarm.ru:444` для работы с RU‑облаком Валарм. Если доступ к Валарм API возможен только через прокси‑сервер, используйте [инструкцию](qs-setup-proxy-ru.md) для настройки
* Установленный текстовый редактор **vim**, **nano** или другой. В инструкции используется редактор **vim**

## Установка

### 1. Установите NGINX stable и зависимости

Возможны следующие способы установки NGINX `stable` из репозитория NGINX:

* Установка из готового пакета

    === "Debian"
        ```bash
        sudo apt install curl gnupg2 ca-certificates lsb-release
        echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
        curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
        sudo apt update
        sudo apt install nginx
        ```
    === "Ubuntu"
        ```bash
        sudo apt install curl gnupg2 ca-certificates lsb-release
        echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
        curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
        sudo apt update
        sudo apt install nginx
        ```
    === "CentOS или Amazon Linux 2"
        ```bash
        echo -e '\n[nginx-stable] \nname=nginx stable repo \nbaseurl=http://nginx.org/packages/centos/$releasever/$basearch/ \ngpgcheck=1 \nenabled=1 \ngpgkey=https://nginx.org/keys/nginx_signing.key \nmodule_hotfixes=true' | sudo tee /etc/yum.repos.d/nginx.repo
        sudo yum install nginx
        ```

* Компиляция и установка с аналогичными опциями из исходного кода из ветки `stable` [репозитория NGINX](https://hg.nginx.org/pkg-oss/branches)

Более подробная информация об установке доступна в [официальной документации NGINX](https://www.nginx.com/resources/admin-guide/installing-nginx-open-source/).

### 2. Добавьте репозитории Валарм WAF

Валарм WAF устанавливается и обновляется из репозиториев Валарм. Для добавления репозиториев используйте команды для вашей платформы.

--8<-- "../include/waf/installation/add-nginx-waf-repos-2.18.md"

### 3. Установите пакеты Валарм WAF

В зависимости от вашей операционной системы, выполните одну из следующих команд:

--8<-- "../include/waf/installation/nginx-postanalytics.md"

### 4. Подключите модуль Валарм WAF

1. Откройте файл `/etc/nginx/nginx.conf`:

    ```bash
    sudo vim /etc/nginx/nginx.conf
    ```
2. Проверьте, что в файле есть строка `include /etc/nginx/conf.d/*`. Если такой строки нет, добавьте ее.
3. Добавьте следующую директиву под директивой `worker_processes`:

    ```bash
    load_module modules/ngx_http_wallarm_module.so;
    ```

    Пример файла с добавленной директивой:

    ```
    user  nginx;
    worker_processes  auto;
    load_module modules/ngx_http_wallarm_module.so;

    error_log  /var/log/nginx/error.log notice;
    pid        /var/run/nginx.pid;
    ```

3. Скопируйте конфигурационные файлы для настройки системы:

    ``` bash
    sudo cp /usr/share/doc/nginx-module-wallarm/examples/*.conf /etc/nginx/conf.d/
    ```

### 5. Подключите WAF‑ноду к Облаку Валарм

--8<-- "../include/waf/installation/connect-waf-and-cloud.md"

### 6. Настройте память для модуля постаналитики

WAF‑нода использует находящееся в памяти хранилище Tarantool. Рекомендуемое количество памяти для Tarantool: 75% от общей памяти виртуальной машины. Чтобы настроить объем памяти для Tarantool:

1. Откройте для редактирования конфигурационный файл Tarantool:

    === "Debian"
        ``` bash
        sudo vim /etc/default/wallarm-tarantool
        ```
    === "Ubuntu"
        ``` bash
        sudo vim /etc/default/wallarm-tarantool
        ```
    === "CentOS или Amazon Linux 2"
        ``` bash
        sudo vim /etc/sysconfig/wallarm-tarantool
        ```
2. Укажите размер выделенной памяти в директиве `SLAB_ALLOC_ARENA` в ГБ. Значение может быть целым или дробным (разделитель целой и дробной части — точка). Например, 24 ГБ:
    
    ```bash
    SLAB_ALLOC_ARENA=24
    ```

    Подробные рекомендации по выделению памяти для Tarantool описаны в [инструкции][memory-instr]. 
3. Чтобы применить изменения, перезапустите Tarantool:

    === "Debian"
        ``` bash
        sudo systemctl restart wallarm-tarantool
        ```
    === "Ubuntu"
        ``` bash
        sudo service wallarm-tarantool restart
        ```
    === "CentOS или Amazon Linux 2"
        ```bash
        sudo systemctl restart wallarm-tarantool
        ```

### 7. Перезапустите NGINX

--8<-- "../include/waf/restart-nginx-2.16.md"

## Следующие шаги

Установка WAF‑ноды завершена. Далее необходимо настроить WAF‑ноду для фильтрации трафика.

[Настройка правил проксирования и фильтрации →](qs-setup-proxy-ru.md)
