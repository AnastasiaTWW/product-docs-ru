[tarantool-status]:           ../images/tarantool-status.png
[configure-selinux-instr]:    configure-selinux.md
[configure-proxy-balancer-instr]:   configuration-guides/access-to-wallarm-api-via-proxy.md
[img-wl-console-users]:             ../images/check-users.png 

# Отдельная установка модуля постаналитики

--8<-- "../include/waf/installation/nginx-installation-options.md"

Данная инструкция описывает способ установки модуля постаналитики на отдельный сервер.

## Требования

* Модуль NGINX-Wallarm, установленный для [NGINX stable из репозитория NGINX](../waf-installation/nginx/dynamic-module.md), [NGINX из репозитория Debian/CentOS](../waf-installation/nginx/dynamic-module-from-distr.md) или [NGINX Plus](../waf-installation/nginx-plus.md)
* Доступ к аккаунту с ролью **Администратор** или **Деплой** и отключенной двухфакторной аутентификацией в Консоли управления Валарм для [RU‑облака](https://my.wallarm.ru/) или [EU‑облака](https://my.wallarm.com/)
* SELinux, отключенный или настроенный по [инструкции][configure-selinux-instr]
* Выполнение команд от имени суперпользователя (например, `root`)
* Возможность обращаться к `https://repo.wallarm.com` для загрузки пакетов. Убедитесь, что доступ не ограничен настройками файервола
* Доступ к `https://api.wallarm.com:444` для работы с EU‑облаком Валарм или к `https://api.wallarm.ru:444` для работы с RU‑облаком Валарм. Если доступ к Валарм API возможен только через прокси‑сервер, используйте [инструкцию][configure-proxy-balancer-instr] для настройки
* Установленный текстовый редактор **vim**, **nano** или другой. В инструкции используется редактор **vim**

## Установка

### 1. Добавьте репозитории Валарм WAF

Модуль постаналитики, как и другие модули Валарм WAF, устанавливается и обновляется из репозиториев Валарм. Для добавления репозиториев используйте команды для вашей платформы:

--8<-- "../include/waf/installation/add-nginx-waf-repos-2.18.md"

### 2. Установите пакеты для модуля постаналитики

Для модуля постаналитики и хранилища Tarantool необходимо установить группу пакетов `wallarm-node-tarantool` из репозитория Валарм:

=== "Debian"
    ```bash
    sudo apt install --no-install-recommends wallarm-node-tarantool
    ```
=== "Ubuntu"
    ```bash
    sudo apt install --no-install-recommends wallarm-node-tarantool
    ```
=== "CentOS или Amazon Linux 2"
    ```bash
    sudo yum install wallarm-node-tarantool
    ```

### 3. Подключите модуль постаналитики к Облаку Валарм

В процессе работы модуль постаналитики взаимодействует с Облаком Валарм. Чтобы обеспечить взаимодействие с Облаком, необходимо создать отдельную WAF‑ноду для модуля постаналитики. WAF‑нода будет получать правила обработки трафика из Облака и выгружать данные об атаках в Облако.

Чтобы создать WAF‑ноду и подключить модуль постаналитики к Облаку, выполните следующие действия:

1. Убедитесь, что роль вашего пользователя в Консоли управления Валарм — **Администратор** или **Деплой** и для пользователя отключена двухфакторная аутентификация.

    Для этого перейдите к списку пользователей в [RU‑облаке](https://my.wallarm.ru/settings/users) или [EU‑облаке](https://my.wallarm.com/settings/users) и проверьте столбцы **Роль** и **Auth**:

    ![!Список пользователей в консоли Валарм][img-wl-console-users]
    
2. В системе с установленными пакетами модуля постаналитики запустите скрипт `addnode`:
    
    === "EU‑облако"
        ``` bash
        sudo /usr/share/wallarm-common/addnode --no-sync
        ```
    === "RU‑облако"
        ``` bash
        sudo /usr/share/wallarm-common/addnode -H api.wallarm.ru --no-sync
        ```

3. Введите email и пароль от вашего аккаунта Валарм.
4. Введите название WAF‑ноды для модуля постаналитики или нажмите Enter, чтобы использовать название, сгенерированное автоматически.
5. Перейдите в Консоль управления Валарм → секция **Ноды** для [RU‑облака](https://my.wallarm.ru/nodes) или [EU‑облака](https://my.wallarm.com/nodes) и убедитесь, что в списке появилась созданная WAF‑нода.

### 4. Обновите конфигурацию модуля постаналитики

Конфигурационный файл для модуля постаналитики расположен по пути:

* `/etc/default/wallarm-tarantool` для операционных систем Debian и Ubuntu
* `/etc/sysconfig/wallarm-tarantool` для операционных систем CentOS и Amazon Linux 2

Чтобы открыть файл для редактирования, используйте команду:

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

#### Оперативная память

Модуль постаналитики использует находящееся в памяти хранилище Tarantool. Рекомендуемое количество памяти для Tarantool: 75% от общей памяти виртуальной машины.

Размер памяти для Tarantool необходимо передать в ГБ в директиве `SLAB_ALLOC_ARENA` в конфигурационном файле `wallarm-tarantool`. Значение может быть целым или дробным (разделитель целой и дробной части — точка). Например, 24 ГБ:

```bash
SLAB_ALLOC_ARENA=24
```

Подробные рекомендации по выделению памяти для Tarantool описаны в [инструкции](configuration-guides/allocate-resources-for-waf-node.md). 

#### Адрес сервера постаналитики

Чтобы настроить адрес сервера постаналитики, необходимо:

1. Снять комментарии с переменных `HOST` и `PORT` в конфигурационном файле `wallarm-tarantool` и указать следующие значения для переменных:

    ```bash
    # address and port for bind
    HOST='0.0.0.0'
    PORT=3313
    ```
2. Если конфигурационный файл Tarantool настроен принимать соединения на адресах, отличных от `0.0.0.0` или `127.0.0.1`, указать эти адреса в конфигурационном файле `/etc/wallarm/node.yaml`:

    ```bash
    hostname: <name of postanalytics WAF node>
    uuid: <UUID of postanalytics WAF node>
    secret: <secret key of postanalytics WAF node>
    tarantool:
        host: '<IP address of Tarantool>'
        port: 3313
    ```
3. Указать адрес отдельного сервера постаналитики на сервере с установленными пакетами NGINX‑Wallarm, как описано в инструкции для подходящей формы установки:

    * [NGINX stable из репозитория NGINX](../waf-installation/nginx/dynamic-module.md#адрес-отдельного-сервера-постаналитики)
    * [NGINX из репозитория Debian/CentOS](../waf-installation/nginx/dynamic-module-from-distr.md#адрес-отдельного-сервера-постаналитики)
    * [NGINX Plus](../waf-installation/nginx-plus.md#адрес-отдельного-сервера-постаналитики)

### 5. Перезапустите сервисы Валарм WAF

Чтобы применить заданные настройки к модулю постаналитики и к модулю NGINX‑Wallarm, необходимо:

1. Перезапустить сервис `wallarm-tarantool` на сервере с модулем постаналитики:

    === "Debian"
        ```bash
        sudo systemctl restart wallarm-tarantool
        ```
    === "Ubuntu"
        ```bash
        sudo systemctl restart wallarm-tarantool
        ```
    === "CentOS или Amazon Linux 2"
        ```bash
        sudo systemctl restart wallarm-tarantool
        ```
2. Перезапустить сервис NGINX на сервере с модулем NGINX‑Wallarm:

    === "Debian"
        ```bash
        sudo systemctl restart nginx
        ```
    === "Ubuntu"
        ```bash
        sudo service nginx restart
        ```
    === "CentOS или Amazon Linux 2"
        ```bash
        sudo systemctl restart nginx
        ```

### 6. Проверьте взаимодействие модуля NGINX‑Wallarm и модуля постаналитики

Чтобы проверить взаимодействие модулей Валарм WAF, установленных на разных серверах, вы можете отправить на адрес защищаемого приложения тестовую атаку:

```bash
curl http://localhost/?id='or+1=1--a-<script>prompt(1)</script>'
```

Если модуль NGINX‑Wallarm и модуль постаналитики настроены корректно, атака выгрузится в Облако Валарм и отобразится в Консоли управления Валарм → секция **События**:

![!Атаки в интерфейсе](../images/admin-guides/yandex-cloud/test-attacks.png)

Если атака не выгрузилась в Облако, проверьте наличие ошибок в работе сервисов:

* Убедитесь, что сервис модуля постаналитики `wallarm-tarantool` находится в статусе `active`

    ```bash
    sudo systemctl status wallarm-tarantool
    ```

    ![!Статус wallarm-tarantool][tarantool-status]
* Проанализируйте логи модуля постаналитики

    ```bash
    sudo cat /var/log/wallarm/tarantool.log
    ```

    Если в логах есть запись, подобная `SystemError binary: failed to bind: Cannot assign requested address`, убедитесь, что сервер принимает соединение по указанному адресу и порту.
* На сервере с модулем NGINX‑Wallarm проанализируйте логи NGINX:

    ```bash
    sudo cat /var/log/nginx/error.log
    ```

    Если в логах есть запись, подобная `[error] wallarm: <address> connect() failed`, убедитесь, что на сервере с модулем NGINX‑Wallarm указан верный адрес сервера с модулем постаналитики и сервер с модулем постаналитики принимает соединение по указанному адресу и порту.
* На сервере с модулем NGINX‑Wallarm: выполните команду для получения статистики по обработанным запросам и убедитесь, что значение `tnt_errors` равно 0

    ```bash
    curl http://127.0.0.8/wallarm-status
    ```

    [Описание всех параметров, которые возвращает сервис статистики →](configure-statistics-service.md)

## Защита модуля постаналитики

!!! warning "Защита постаналитики"
    Мы **настоятельно рекомендуем** защитить установленный модуль постаналитики файерволом. В противном случае есть риск несанкционированного подключения к сервису, что может привести к получению:
    
    *   информации об обработанных запросах
    *   возможности выполнения произвольного Lua-кода и команд операционной системы
   
    Обратите внимание, что если модуль постаналитики устанавливается на одном сервере с модулем NGINX‑Wallarm, то такого риска нет, так как модуль постаналитики подключается к порту 3313.
    
    **Настройки файервола для отдельно установленного модуля постаналитики:**
    
    *   Разрешите прохождение HTTPS‑трафика к API-серверам Валарм (`api.wallarm.com:444` для EU‑облака или `api.wallarm.ru:444` для RU‑облака) в обоих направлениях, чтобы модуль постаналитики мог взаимодействовать с этими серверами.
    *   Ограничьте доступ к порту `3313` Tarantool по протоколам TCP и UDP, разрешив соединения только с IP‑адресов WAF‑нод Валарм.
