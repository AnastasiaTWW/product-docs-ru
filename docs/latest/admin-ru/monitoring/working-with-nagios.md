[img-nagios-service-status]:            ../../images/monitoring/nagios-service-status.png
[img-nagios-service-details]:           ../../images/monitoring/nagios-service-details-1.png
[img-nagios-service-perfdata-updated]:  ../../images/monitoring/nagios-service-details-2.png

[link-php4nagios]:                      https://docs.pnp4nagios.org/

#   Работа с метриками WAF‑ноды в Nagios

Проверьте, что Nagios успешно отслеживает статус созданного ранее сервиса. Для этого:
1.  Войдите в веб‑интерфейс Nagios.
2.  Перейдите на страницу сервисов, кликнув по ссылке *Services*.
3.  Убедитесь, что сервис `wallarm_nginx_attacks` отображается и имеет статус «OK»:
      
    ![!Статус сервиса в Nagios][img-nagios-service-status]
    
    !!! info "Принудительный запуск проверки"
        Если сервис не имеет статус  «OK», вы можете принудительно перезапустить проверку сервиса для подтверждения его статуса.
        
        Для этого нажмите на имя сервиса в столбце *Service*, а затем запустите проверку принудительно, выбрав в списке *Service Commands* пункт *Re-schedule the next check of this service* и введя необходимые параметры.    
    
    
4.  Просмотрите подробные сведения о сервисе, кликнув по ссылке с его именем в столбце *Status*:
    
    ![!Подробные сведения о сервисе][img-nagios-service-details]
    
    Также убедитесь, что значение метрики, отображаемое в Nagios (строка *Performance Data*), совпадает с данными `wallarm-status` на WAF‑ноде:
    
    --8<-- "../include/monitoring/wallarm-status-check.md"

5.  Выполните тестовую атаку на приложение, защищенное WAF‑нодой. Для этого можно выполнить команду `curl` с вредоносным запросом к приложению или выполнить этот запрос в браузере.
    
    --8<-- "../include/monitoring/sample-malicious-request.md"

6.  Убедитесь, что значение «Performance Data» в Nagios увеличилось и соответствует значению, отображаемому `wallarm-status` на WAF‑ноде:
    
    --8<-- "../include/monitoring/wallarm-status-output.md"
    
    ![!Обновленное значение Performance Data][img-nagios-service-perfdata-updated]

Теперь в информации о состоянии сервиса в Nagios отображаются значения метрики `curl_json-wallarm_nginx/gauge-attacks` WAF‑ноды.

!!! info "Визуализация данных Nagios"
    По умолчанию Nagios Core поддерживает только отслеживание статуса сервиса (`OK`, `WARNING`, `CRITICAL`). Для хранения и визуализации значений метрик, содержащихся в *Performance Data*, вы можете воспользоваться сторонними утилитами, например, [PHP4Nagios][link-php4nagios].