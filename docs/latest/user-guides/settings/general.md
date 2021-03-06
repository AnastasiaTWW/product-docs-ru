[link-config-parameters]:       ../../admin-ru/configure-parameters-ru.md#wallarm_mode

[img-general-settings]:         ../../images/user-guides/settings/general.png

# Общие настройки

На вкладке *Общие* раздела *Настройки* вы можете вручную переключить режим работы Валарм:

* **По умолчанию**&nbsp;— использовать режим работы, заданный в конфигурационных файлах WAF‑ноды; 
* **Мониторинг** &nbsp;— обрабатывать все запросы, но не блокировать никакие из них, даже если обнаружены вредоносные запросы;
* **Блокировка**&nbsp;— блокировать все вредоносные запросы.

Больше информации о доступных настройках доступно по [ссылке][link-config-parameters].

![!Общие настройки][img-general-settings]

!!! info "Qrator"
    Для клиентов Валарм, подключенных через сеть фильтрации трафика Qrator, настройка *Блокировка на стороне Qrator* позволяет включить автоматическую блокировку вредоносных запросов. Блокировка осуществляется через черные списки IP‑адресов Qrator. Валарм передает Qrator свои данные об IP‑адресах, с которых производятся атаки.
