[link-nginx-logging-docs]:  https://docs.nginx.com/nginx/admin-guide/monitoring/logging/
[doc-vuln-list]:            ../attacks-vulns-list.md
[doc-monitor-node]:         monitoring/intro.md
[doc-lom]:                  ../user-guides/rules/compiling.md


#   Работа с логами WAF‑ноды

##  Расположение лог‑файлов WAF‑ноды

WAF‑нода хранит следующие лог‑файлы в директории `/var/log/wallarm`:
*   `brute-detect.log` и `sync-brute-clusters.log`: логи получения данных по счетчикам bruteforce-атак в кластере WAF‑нод.
*   `export-attacks.log`: лог экспорта информации об атаках из модуля постаналитики в облако Валарм.
*   `export-clusterization-data.log`: лог выгрузки данных кластера  WAF‑нод.
*   `export-counters.log`: лог выгрузки данных счетчиков (см. [«Мониторинг WAF‑ноды»][doc-monitor-node]).
*   `syncnode.log`: лог синхронизации WAF‑ноды с облаком Валарм (включая получение файлов [ЛОМ][doc-lom] и `proton.db` из облака).
*   `tarantool.log`: лог работы модуля постаналитики.
    

##  Настройка расширенного логирования для WAF‑ноды на основе NGINX

NGINX записывает логи обработанных запросов (англ. «access logs») в отдельный лог‑файл.

По умолчанию NGINX использует предопределенный формат логирования `combined`:

```
log_format combined '$remote_addr - $remote_user [$time_local] '
                    '"$request" $request_id $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent"';
```

Вы можете определить и использовать собственный формат логирования, включив в него одну или несколько переменных WAF‑ноды (а также другие переменные NGINX, если это необходимо). Это позволит проводить более быструю диагностику состояния WAF‑ноды, основываясь на содержимом лог‑файла NGINX.

###  Переменные WAF‑ноды

При определении формата логирования NGINX могут быть использованы следующие переменные WAF‑ноды:

|Имя|Тип|Значение|
|---|---|---|
|`request_id`|Строка|Идентификатор запроса<br>Имеет значение вида `a79199bcea606040cc79f913325401fb`|
|`wallarm_request_time`|Число с плавающей точкой|Время выполнения запроса в секундах|
|`wallarm_serialized_size`|Целое число|Размер сериализованного запроса в байтах|
|`wallarm_is_input_valid`|Целое число|Валидность запроса<br>`0`: запрос валиден. Запрос проверен WAF‑нодой и соответствует правилам ЛОМ.<br>`1`: запрос невалиден. Запрос проверен WAF‑нодой и не соответствует правилам ЛОМ.|
| `wallarm_attack_type_list` | Строка | [Типы атак][doc-vuln-list], обнаруженных в запросе с помощью библиотеки [libproton](../about-wallarm-waf/protecting-against-attacks.md#библиотека-libproton). Типы представлены в текстовом формате:<ul><li>xss</li><li>sqli</li><li>rce</li><li>xxe</li><li>ptrav</li><li>crlf</li><li>redir</li><li>nosqli</li><li>infoleak</li><li>overlimit_res</li><li>logic_bomb</li><li>vpatch</li><li>ldapi</li><li>scanner</li></ul>Если в запросе обнаружено несколько типов атак, они будут перечислены через символ `|`. Например: если в запросе обнаружены атаки типа XSS и SQLi, значение переменной равно `xss|sqli`. |
|`wallarm_attack_type`|Целое число|[Типы атак][doc-vuln-list], обнаруженных в запросе с помощью библиотеки [libproton](../about-wallarm-waf/protecting-against-attacks.md#библиотека-libproton). Типы представлены в виде битовой строки:<ul><li>`0x00000000`: отсутствие атаки: `"0"`</li><li>`0x00000002`: xss: `"2"`</li><li>`0x00000004`: sqli: `"4"`</li><li>`0x00000008`: rce: `"8"`</li><li>`0x00000010`: xxe: `"16"`</li><li>`0x00000020`: ptrav: `"32"`</li><li>`0x00000040`: crlf: `"64"`</li><li>`0x00000080`: redir: `"128"`</li><li>`0x00000100`: nosqli: `"256"`</li><li>`0x00000200`: infoleak: `"512"`</li><li>`0x20000000`: overlimit_res: `"536870912"`</li><li>`0x40000000`: logic_bomb: `"1073741824"`</li><li>`0x80000000`: vpatch: `"2147483648"`</li><li>`0x00002000`: ldapi: `"8192"`</li><li>`0x4000`: scanner: `"16384"`</li></ul>Если в запросе обнаружено несколько типов атак, значения суммируются. Например: если в запросе обнаружены атаки типа XSS и SQLi, значение переменной равно `6`.|

### Пример настройки

Пусть необходимо задать расширенный формат логирования с именем `wallarm_combined`, включающий в себя:
*   все переменные, используемые в формате `combined`; 
*   все переменные WAF‑ноды.

Чтобы это сделать, выполните следующие действия:
1.  Добавьте в блок `http` файла конфигурации NGINX следующие строки, описывающие формат логирования:

    ```
    log_format wallarm_combined '$remote_addr - $remote_user [$time_local] '
                                '"$request" $request_id $status $body_bytes_sent '
                                '"$http_referer" "$http_user_agent"'
                                '$wallarm_request_time $wallarm_serialized_size $wallarm_is_input_valid $wallarm_attack_type $wallarm_attack_type_list';
    ```

2.  Включите логирование в расширенном формате, добавив в тот же блок директиву:

    `access_log /var/log/nginx/access.log wallarm_combined;`
    
    Логи обработанных запросов будут записываться в формате `wallarm_combined` в файл `/var/log/nginx/access.log`. 
    
    !!! info "Логирование по условию"
        При использовании директивы, приведенной выше, в лог‑файл попадут данные по всем обработанным запросам. В том числе данные, которые не относятся к какой-либо атаке.
        
        Вы можете настроить логирование по условию, чтобы в лог‑файл попадала информация только по тем запросам, которые относятся к атаке (т.е. по запросам, для которых значение `wallarm_attack_type` не равно нулю). Для этого добавьте к директиве следующее условие:
        
            `access_log /var/log/nginx/access.log wallarm_combined if=$wallarm_attack_type;`
        
        Это может быть полезно для сокращения объема лог‑файла и для интеграции WAF‑ноды с SIEM‑системами.
    
3.  Перезапустите NGINX, выполнив одну из следующих команд в зависимости от используемой операционной системы:

    --8<-- "../include/waf/restart-nginx-2.16.md"

!!! info "Дополнительная информация"
    Подробная информация о настройке логирования в NGINX доступна [здесь][link-nginx-logging-docs].