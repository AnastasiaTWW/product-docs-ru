[link-scanner-rps]:     ../scanner/configure-scanner.md#ограничение-на-rps-сканера

[img-verification-statuses]:        ../../images/user-guides/events/attack-verification-statuses.png
[img-verify-attack]:                ../../images/user-guides/events/verify-attack.png
[img-verified-icon]:                ../../images/user-guides/events/verified.png#mini
[img-error-icon]:                   ../../images/user-guides/events/error.png#mini
[img-forced-icon]:                  ../../images/user-guides/events/forced.png#mini
[img-sheduled-icon]:                ../../images/user-guides/events/sheduled.png#mini
[img-cloud-icon]:                   ../../images/user-guides/events/cloud.png#mini

[al-brute-force-attack]:      ../../attacks-vulns-list.md#брутфорс-англ-bruteforce-attack
[al-forced-browsing]:         ../../attacks-vulns-list.md#принудительный-просмотр-ресурсов-вебприложения-англ-forced-browsing


# Перепроверка атак

Валарм выполняет автоматическую перепроверку атак.

Вы можете посмотреть статус перепроверки атак, а также повысить приоритет проверки атак в очереди на вкладке *События*.

![!Атаки с различными статусами перепроверки][img-verification-statuses]

## Просмотр статуса перепроверки атак

Чтобы посмотреть статусы перепроверки атак:
1. Перейдите на вкладку *События*.
2. Посмотрите статус атаки в столбце «Проверка».

## Статусы перепроверки атак

Возможны следующие статусы перепроверки атак:
* ![!Проверенные][img-verified-icon] *Проверенные*&nbsp;— атака перепроверена;
* ![!С ошибкой][img-error-icon] *С ошибкой*&nbsp;— перепроверка атаки не поддерживается;
* ![!Форсированные][img-forced-icon] *Форсированные*&nbsp;— атаки с повышенным приоритетом в очереди на перепроверку;
* ![!Планируемые][img-sheduled-icon] *Планируемые*&nbsp;— атаки в очереди на перепроверку;
* ![!Ошибка соединения с сервером][img-cloud-icon] *Не удалось установить соединение с сервером*&nbsp;— возникли проблемы во время запроса к серверу.

## Повышение приоритета атаки в очереди на перепроверку

Чтобы повысить приоритет атаки в очереди на перепроверку: 
1. Выберите атаку.
2. Нажмите на знак статуса атаки в столбце «Проверка».
3. Нажмите *Форсировать проверку*.

Валарм повысит приоритет атаки в очереди на перепроверку.

## Атаки, не поддерживающие перепроверку

Атаки следующих типов не поддерживают перепроверку:
* [брутфорс][al-brute-force-attack];
* [forced browsing][al-forced-browsing];
* атаки с лимитом обработки запросов;
* атаки, уязвимости для которых уже закрыты;
* атаки, для перепроверки которых недостаточно данных.
