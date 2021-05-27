[img-collectd-nagios]:      ../../images/monitoring/collectd-nagios.png

[link-nagios]:              https://www.nagios.org/
[link-nagios-core]:         https://www.nagios.org/downloads/nagios-core/
[link-collectd-nagios]:     https://collectd.org/wiki/index.php/Collectd-nagios
[link-nagios-core-install]: https://support.nagios.com/kb/article/nagios-core-installing-nagios-core-from-source-96.html
[link-nrpe-docs]:           https://github.com/NagiosEnterprises/nrpe/blob/master/README.md
[link-visudo]:              https://www.sudo.ws/man/1.8.17/visudo.man.html
[link-collectd-docs]:       https://collectd.org/documentation/manpages/collectd-nagios.1.shtml
[link-nrpe-readme]:         https://github.com/NagiosEnterprises/nrpe
[link-nrpe-pdf]:            https://assets.nagios.com/downloads/nagioscore/docs/nrpe/NRPE.pdf

[doc-gauge-attacks]:        available-metrics.md#количество-зафиксированных-атак
[doc-unixsock]:             fetching-metrics.md#выгрузка-метрик-с-помощью-утилиты-collectdnagios

[anchor-header-7]:          #7--добавьте-в-файл-конфигурации-сервиса-nrpe-на-wafноде-команды-для-получения-требуемых-вам-метрик

#   Выгрузка метрик с помощью утилиты `collectd-nagios` в Nagios

В этом документе приводится пример настройки выгрузки метрик WAF‑ноды в систему мониторинга [Nagios][link-nagios] (рассматривается редакция [Nagios Core][link-nagios-core], однако этот документ подойдет для любой редакции Nagios) с помощью утилиты [`collectd-nagios`][link-collectd-nagios].

!!! info "Соглашения и необходимые требования"
    *   Сервис `collectd` должен быть настроен на выгрузку метрик через сокет домена Unix (подробнее [здесь][doc-unixsock]).
    *   Предполагается, что у вас уже установлена редакция Nagios Core.
        
        Если это не так, установите Nagios Core (например, следуя [этим инструкциям][link-nagios-core-install]).
    
        Вы можете использовать другую редакцию Nagios при необходимости (например, Nagios XI).
        
        Далее для обозначения любой редакции Nagios будет использоваться термин «Nagios», если не указано иное.

    *   Убедитесь, что у вас есть возможность подключения к WAF‑ноде и хосту Nagios (например, по протоколу SSH) и работы под аккаунтом `root` или другим аккаунтом с правами суперпользователя.
    *   Установите на WAF‑ноде сервис [Nagios Remote Plugin Executor][link-nrpe-docs] (далее — «NRPE»).

##  Схема работы примера

--8<-- "../include/monitoring/metric-example.md"

![!Схема работы примера][img-collectd-nagios]

В этом документе используется следующая схема развертывания:
*   WAF‑нода Валарм развернута на хосте, доступном по IP‑адресу `10.0.30.5` и полному доменному имени `node.example.local`.
*   Хост, на котором установлен Nagios, доступен по IP‑адресу `10.0.30.30`.
*   Для выполнения команд на удаленном хосте используется плагин NRPE. Плагин состоит из двух компонентов:
    *   Сервиса `nrpe`, который устанавливается на машину, мониторинг которой необходимо осуществлять. Работает на стандартном для NRPE порту `5666/TCP`.
    *   Nagios‑плагина NRPE `check_nrpe`, который устанавливается на хост Nagios и позволяет Nagios выполнять команды на удаленном хосте, на котором установлен сервис `nrpe`.
*   NPRE будет использоваться для вызова утилиты `collectd_nagios`, которая предоставляет метрики `collectd` в Nagios‑совместимом формате.

##  Настройка выгрузки метрик в Nagios

!!! info "Особенности установки"
    В этом документе описывается настройка плагина NRPE с параметрами по умолчанию в условиях, когда Nagios также установлен с параметрами по умолчанию (директория Nagios: `/usr/local/nagios`, Nagios работает под аккаунтом `nagios`). Если вы устанавливаете плагин или Nagios с использованием нестандартных параметров, скорректируйте приведенные в документе команды и указания соответствующим образом. 

Чтобы настроить выгрузку метрик WAF‑ноды, выполните следующие действия:

### 1.   Настройте сервис NRPE для коммуникации с хостом Nagios 

Для этого на хосте с WAF‑нодой:
1.  Откройте конфигурационный файл NRPE (по умолчанию `/usr/local/nagios/etc/nrpe.cfg`).

2.  Добавьте в директиву `allowed_hosts` файла IP‑адрес или полное доменное имя хоста Nagios. Например, если хост Nagios имеет IP‑адрес `10.0.30.30`:
   
    ```
    allowed_hosts=127.0.0.1,10.0.30.30
    ```
    
3.  Перезапустите сервис NRPE, выполнив одну из следующих команд:

    --8<-- "../include/monitoring/nrpe-restart-2.16.md"

### 2.   Установите Nagios‑плагин NRPE на хост Nagios

Для этого на хосте Nagios:
1.  Выполните действия по загрузке и распаковке исходных файлов плагина NRPE, а также установите необходимые для сборки и установки утилиты (см. [документацию NRPE][link-nrpe-docs]).  
2.  Перейдите в директорию с исходными файлами плагина, соберите его и установите Nagios‑плагин.

    Минимальная последовательность действий такова:
    ``` bash
    ./configure
    make all
    make install-plugin
    ```
    
### 3.  Убедитесь, что Nagios‑плагин NRPE успешно взаимодействует с сервисом NRPE

Для этого выполните следующую команду на хосте Nagios:

``` bash
/usr/local/nagios/libexec/check_nrpe -H node.example.local
```

В случае успешного функционирования NRPE в выводе команды должна содержаться версия NRPE (например, `NRPE v3.2.1`).

### 4.  На хосте Nagios определите команду `check_nrpe` для запуска Nagios‑плагина NRPE с одним аргументом

Для этого добавьте в файл `/usr/local/nagios/etc/objects/commands.cfg` следующие строки:

```
define command{
    command_name check_nrpe
    command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
 }
```

### 5.  Установите утилиту `collectd_nagios` на хосте с WAF‑нодой

Для этого выполните одну из следующих команд (в зависимости от дистрибутива):

--8<-- "../include/monitoring/install-collectd-utils.md"



### 6. Добавьте возможность запускать утилиту `collectd-nagios` с повышенными привилегиями от имени пользователя `nagios` 

Для этого выполните следующие действия на хосте с WAF‑нодой:
1.  С помощью утилиты [`visudo`][link-visudo] добавьте следующую строку в файл `/etc/sudoers`:
   
    ```
    nagios ALL=(ALL:ALL) NOPASSWD:/usr/bin/collectd-nagios
    ```
    
    Это позволит пользователю `nagios` запускать утилиту `collectd-nagios` с правами суперпользователя с помощью утилиты `sudo` без ввода пароля. 

    !!! info "Запуск `collectd-nagios` с правами суперпользователя"
        Утилита должна запускаться с правами суперпользователя, поскольку она использует сокет `collectd` (сокет домена Unix) для получения данных. Доступ к этому сокету есть только у суперпользователя.

2.  Убедитесь, что пользователь `nagios` может получать значения метрик от `collectd`, выполнив следующую тестовую команду на WAF‑ноде:
   
    ``` bash
    sudo -u nagios sudo /usr/bin/collectd-nagios -s /var/run/collectd-unixsock -n curl_json-wallarm_nginx/gauge-attacks -H node.example.local
    ```
    
    Эта команда позволяет пользователю `nagios` получить значение метрики [`curl_json-wallarm_nginx/gauge-attacks`][doc-gauge-attacks] (количество зафиксированных атак) для хоста `node.example.local` с WAF‑нодой.

    **Пример вывода команды:**
    
    ```
    OKAY: 0 critical, 0 warning, 1 okay | value=0.000000;;;;
    ```

3.  Добавьте в файл конфигурации сервиса NRPE префикс для запуска команд с помощью утилиты `sudo`:
   
    ```
    command_prefix=/usr/bin/sudo
    ```
    
### 7.  Добавьте в файл конфигурации сервиса NRPE на WAF‑ноде команды для получения требуемых вам метрик

Например, чтобы создать команду с именем `check_wallarm_nginx_attacks`, которая будет получать метрику `curl_json-wallarm_nginx/gauge-attacks` для WAF‑ноды с полным доменным именем `node.example.local`, добавьте в файл конфигурации следующую строку:

```
command[check_wallarm_nginx_attacks]=/usr/bin/collectd-nagios -s /var/run/collectd-unixsock -n curl_json-wallarm_nginx/gauge-attacks -H node.example.local
```

!!! info "Как задать пороговые значения для метрики"
    При необходимости вы можете указать диапазон значений, при которых утилита `collectd-nagios` будет возвращать статус `WARNING` или `CRITICAL` с помощью параметров `-w` и `-c` (подробная информация доступна в [документации][link-collectd-docs] утилиты).

После того, как в файл конфигурации сервиса NRPE добавлены все необходимые команды, перезапустите сервис NRPE, выполнив одну из следующих команд:

--8<-- "../include/monitoring/nrpe-restart-2.16.md"

### 8.  На хосте Nagios задайте с помощью конфигурационных файлов хост с WAF‑нодой и набор сервисов, мониторинг которых необходимо осуществлять

!!! info "Сервисы и метрики"
    В этом документе предполагается, что один сервис Nagios эквивалентен одной метрике.

Например, это можно сделать следующим образом:
1.  Создайте файл `/usr/local/nagios/etc/objects/nodes.cfg` со следующим содержимым:
   
    ```
    define host{
     use linux-server
     host_name node.example.local
     address 10.0.30.5
    }
    
    define service {
      use generic-service
      host_name node.example.local
      check_command check_nrpe!check_wallarm_nginx_attacks
      max_check_attempts 5
      service_description wallarm_nginx_attacks
    }
    ```
   
    Этот файл определяет хост `node.example.local` с IP‑адресом `10.0.30.5`, и команду для проверки состояния сервиса `wallarm_nginx_attacks`, что эквивалентно получению метрики `curl_json-wallarm_nginx/gauge-attacks` с WAF‑ноды (см. описание команды [`check_wallarm_nginx_attacks`][anchor-header-7]).
    
2.  Добавьте в конфигурационный файл Nagios (по умолчанию, `/usr/local/nagios/etc/nagios.cfg`) следующую строку:
   
    ```
    cfg_file=/usr/local/nagios/etc/objects/nodes.cfg
    ```
   
    Это необходимо для того, чтобы Nagios начал использовать данные из созданного ранее файла `nodes.cfg` при следующем запуске.
   
3.  Перезапустите сервис Nagios, выполнив одну из следующих команд:   

    --8<-- "../include/monitoring/nagios-restart-2.16.md"

##  Настройка завершена

Теперь Nagios осуществляет мониторинг сервиса, связанного с конкретной метрикой WAF‑ноды. При необходимости вы можете определить другие команды и сервисы для проверки интересующих вас метрик.

!!! info "Информация о NRPE"
    Несколько источников дополнительной информации о NRPE:

    * [README][link-nrpe-readme] проекта NRPE на GitHub;
    * Документация NRPE ([PDF][link-nrpe-pdf]).