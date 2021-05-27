[img-zabbix-scheme]:        ../../images/monitoring/zabbix-scheme.png

[link-zabbix]:              https://www.zabbix.com/
[link-collectd-nagios]:     https://collectd.org/wiki/index.php/Collectd-nagios
[link-zabbix-agent]:        https://www.zabbix.com/zabbix_agent
[link-zabbix-passive]:      https://www.zabbix.com/documentation/4.0/ru/manual/appendix/items/activepassive
[link-zabbix-app]:          https://hub.docker.com/r/zabbix/zabbix-appliance
[link-docker-ce]:           https://docs.docker.com/install/
[link-zabbix-repo]:         https://www.zabbix.com/download
[link-allowroot]:           https://www.zabbix.com/documentation/4.0/ru/manual/appendix/config/zabbix_agentd
[link-sed-docs]:            https://www.gnu.org/software/sed/manual/sed.html#sed-script-overview
[link-visudo]:              https://www.sudo.ws/man/1.8.17/visudo.man.html

[doc-gauge-attacks]:        available-metrics.md#количество-зафиксированных-атак
[doc-unixsock]:             fetching-metrics.md#выгрузка-метрик-с-помощью-утилиты-collectdnagios

#   Выгрузка метрик с помощью утилиты `collectd-nagios` в Zabbix

В этом документе приводится пример настройки выгрузки метрик WAF‑ноды в систему мониторинга [Zabbix][link-zabbix] с помощью утилиты [`collectd-nagios`][link-collectd-nagios].

##  Схема работы примера

--8<-- "../include/monitoring/metric-example.md"


![!Схема работы примера][img-zabbix-scheme]

В этом документе используется следующая схема развертывания:
*   WAF‑нода Валарм развернута на хосте, доступном по IP‑адресу `10.0.30.5` и полному доменному имени `node.example.local`.
    
    На хосте также развернут [Zabbix‑агент][link-zabbix-agent] версии 4.0 LTS, который:

    *   Получает значения метрик WAF‑ноды, используя утилиту `collectd-nagios`.
    *   Слушает входящие соединения на порту `10050/TCP` ([пассивные проверки][link-zabbix-passive] с помощью Zabbix Appliance).
    *   Передает значения метрик в Zabbix Appliance.  
    
*   На отдельном хосте с IP‑адресом `10.0.30.30` (далее — «хост Docker») развернут [Zabbix Appliance][link-zabbix-app] версии 4.0 LTS в виде Docker‑контейнера.
    
    Zabbix Appliance включает в себя:
    
    *   Сервер Zabbix, который периодически опрашивает Zabbix‑агент, установленный на хосте с WAF‑нодой, на предмет изменения значений метрик.
    *   Веб-интерфейс для управления сервером Zabbix, доступный на порту `80/TCP`.



##  Настройка выгрузки метрик в Zabbix

!!! info "Необходимые условия"
    Предполагается, что: 
    
    *   Сервис `collectd` настроен на выгрузку метрик через сокет домена Unix (подробнее [здесь][doc-unixsock]).
    *   На хост Docker `10.0.30.30` уже установлен [Docker Community Edition][link-docker-ce].
    *   WAF‑нода `node.example.local` уже развернута, настроена, доступна для дальнейшей настройки (например, по протоколу SSH) и работает.

### Развертывание Zabbix

Для развертывания Zabbix Appliance 4.0 LTS выполните на хосте Docker следующую команду:

``` bash
docker run --name zabbix-appliance -p 80:80 -d zabbix/zabbix-appliance:alpine-4.0-latest
```

Теперь у вас есть работающая система мониторинга Zabbix.

### Развертывание Zabbix‑агента

Установите Zabbix‑агент 4.0 LTS на хост с WAF‑нодой:
1.  Подключитесь к WAF‑ноде (например, с помощью протокола SSH). Убедитесь, что вы работаете под аккаунтом `root` или другим аккаунтом с правами суперпользователя.
2.  Подключите репозитории Zabbix (используйте пункт «Install Zabbix repository» [инструкции][link-zabbix-repo], соответствующей используемой операционной системе).
3.  Установите Zabbix‑агент, выполнив одну из следующих команд в зависимости от используемой операционной системы:

    --8<-- "../include/monitoring/install-zabbix-agent.md"
   
4.  Настройте Zabbix‑агент для работы с Zabbix Appliance. Для этого внесите следующие изменения в файл конфигурации агента `/etc/zabbix/zabbix_agentd.conf`:
   
    ```
    Server=10.0.30.30                  # IP‑адрес Zabbix 
    Hostname=node.example.local        # Полное доменное имя хоста с WAF‑нодой 
    ```
    
### Настройка сбора метрик с помощью Zabbix‑агента

Подключитесь к WAF‑ноде (например, с помощью протокола SSH) и настройте сбор метрик с помощью Zabbix‑агента. Для этого выполните следующие действия на хосте с WAF‑нодой:

####    1.  Установите утилиту `collectd_nagios`.

Для этого выполните следующую команду:

--8<-- "../include/monitoring/install-collectd-utils.md"
   
####    2.  Добавьте возможность запускать утилиту `collectd-nagios` с повышенными привилегиями от имени пользователя `zabbix`
    
Для этого с помощью утилиты [`visudo`][link-visudo] добавьте следующую строку в файл `/etc/sudoers`:
   
```
zabbix ALL=(ALL:ALL) NOPASSWD:/usr/bin/collectd-nagios
```
    
Это позволит пользователю `zabbix` запускать утилиту `collectd-nagios` с правами суперпользователя с помощью утилиты `sudo` без ввода пароля. 
 
!!! info "Запуск `collectd-nagios` с правами суперпользователя"
    Утилита должна запускаться с правами суперпользователя, поскольку она использует сокет `collectd` (сокет домена Unix) для получения данных. Доступ к этому сокету есть только у суперпользователя.
    
    Также, в качестве альтернативы добавлению пользователя `zabbix` в `sudoers`, вы можете настроить Zabbix‑агент так, чтобы он запускался с правами пользователя `root` (это может представлять угрозу безопасности, поэтому использовать этот способ не рекомендуется). Это достигается с помощью включения опции [`AllowRoot`][link-allowroot] в конфигурационном файле агента.
    
####    3.  Убедитесь, что пользователь `zabbix` может получать значения метрик от `collectd`
   
Для этого выполните следующую тестовую команду на WAF‑ноде:
   
``` bash
sudo -u zabbix sudo /usr/bin/collectd-nagios -s /var/run/collectd-unixsock -n curl_json-wallarm_nginx/gauge-attacks -H node.example.local
```

Эта команда позволяет пользователю `zabbix` получить значение метрики [`curl_json-wallarm_nginx/gauge-attacks`][doc-gauge-attacks] (количество зафиксированных атак) для хоста `node.example.local` с WAF‑нодой.

**Пример вывода команды:**
    
```
OKAY: 0 critical, 0 warning, 1 okay | value=0.000000;;;;
```
    
####    4.  Добавьте в файл конфигурации Zabbix‑агента на WAF‑ноде пользовательские параметры для получения требуемых вам метрик

Например, чтобы создать пользовательский параметр `wallarm_nginx-gauge-attacks`, который будет соответствовать метрике `curl_json-wallarm_nginx/gauge-attacks` для WAF‑ноды с полным доменным именем `node.example.local`, добавьте в файл конфигурации следующую строку:
   
```
UserParameter=wallarm_nginx-gauge-attacks, sudo /usr/bin/collectd-nagios -s /var/run/collectd-unixsock -n curl_json-wallarm_nginx/gauge-attacks -H node.example.local | sed -n "s/.*value\=\(.*\);;;;.*/\1/p"
```

!!! info "Извлечение значения метрики"
    Для извлечения значения метрики, идущего после `value=` в выводе утилиты `collectd-nagios` (например, `OKAY: 0 critical, 0 warning, 1 okay | value=0.000000;;;;`), используется перенаправление вывода в утилиту `sed` с последующим выполнением скрипта.
    
    Обратитесь к [документации `sed`][link-sed-docs] для получения дополнительных сведений о синтаксисе его скриптов.
        
####    5.  После того, как в файл конфигурации Zabbix‑агента добавлены все необходимые команды, перезапустите агент
   
Для этого выполните одну из следующих команд:

--8<-- "../include/monitoring/zabbix-agent-restart.md"

## Настройка завершена

Теперь вы можете осуществлять мониторинг пользовательских параметров, связанных со специфичными для Валарм метриками, с помощью Zabbix.
