[whitelist-scanner-addresses]: ../admin-ru/attack-rechecker-best-practices.md#добавьте-ip-адреса-сканера-валарм-в-белый-список

# Обнаружение уязвимостей

## Что такое уязвимость?

Уязвимость — ошибка, допущенная при проектировании, разработке или внедрении вашего веб‑приложения, которая может привести к реализации риска информационной безопасности. К таким рискам относятся:

* Несанкционированный доступ к данным, например: чтение или модификация данных пользователей
* Отказ в обслуживании
* Нарушение целостности данных и другие

## Методы обнаружения уязвимостей

Для поиска уязвимостей Валарм WAF отправляет на адрес защищаемого приложения запросы с атаками и анализирует ответы на запросы. Если в ответе на запрос есть признаки уязвимости, Валарм WAF записывает открытую уязвимость.

Например: если ответ на запрос на чтение файла `/etc/passwd` включает содержимое `/etc/passwd`, защищаемое приложение считается уязвимым для атак типа Path Traversal и Валарм WAF записывает соответствующую уязвимость в приложении.

Валарм WAF использует следующие методы для отправки на адреса защищаемых приложений запросов с атаками:

* **Пассивное детектирование**: уязвимость обнаруживается в ходе реальной атаки.
* **Перепроверка атак**: модуль **Активной проверки атак** автоматически воспроизводит атаки из реального трафика, обработанного WAF‑нодой, и ищет уязвимости в соответствующих частях приложения. По умолчанию этот метод выключен.
* **Сканер уязвимостей**: все элементы сетевого периметра проверяются на наличие типовых уязвимостей.

### Пассивное детектирование

При пассивном детектировании уязвимость обнаруживается в ходе реальной атаки. Если в ходе атаки удалось проэксплуатировать уязвимость приложения, система Валарм WAF записывает инцидент безопасности и проэксплуатированную уязвимость.

Пассивное детектирование уязвимостей работает по умолчанию.

### Перепроверка атак

#### Как работает

--8<-- "../include/how-attack-rechecker-works.md"

#### Потенциальные риски использования модуля активной проверки атак

* Легитимные запросы, распознанные WAF-нодой как атака ([ложные срабатывания](../about-wallarm-waf/protecting-against-attacks.md#ложные-срабатывания)), также воспроизводятся модулем активной проверки атак. Если запросы меняют поведение приложения и в них переданы авторизационные данные, модуль активной проверки атак может выполнить нежелательные операции с приложением. Например: при активной проверке авторизованного запроса для создания нового объекта в приложении, модуль может создать набор нежелательных объектов в приложении.

    Чтобы минимизировать описанный риск, модуль активной проверки атак автоматически вырезает следующие HTTP-заголовки из запросов:

    * `Cookie`
    * `Authorization: Basic`
    * `Viewstate`
* Если в приложении используется нестандартный способ авторизации запросов или авторизация запросов не требуется, модуль активной проверки атак может воспроизвести любой запрос из трафика 100 и более раз и вызвать непредвиденное поведение системы. Например: повторить 100 и более транзакций или заказов. Чтобы минимизировать описанный риск, мы рекомендуем использовать [тестовую или staging-среду](../admin-ru/attack-rechecker-best-practices.md#опционально-настройте-замену-элементов-запроса-для-активной-проверки) для активной проверки атак и [маскировать нестандартные параметры авторизации](../admin-ru/attack-rechecker-best-practices.md#настройте-корректную-маскировку-данных).

#### Настройка

По умолчанию модуль активной проверки атак выключен. Для корректной настройки модуля следуйте [рекомендациям по управлению активной проверкой атак](../admin-ru/attack-rechecker-best-practices.md).

### Сканер уязвимостей

#### Как работает

Сканер уязвимостей выполняет проверку всех элементов сетевого периметра на наличие типовых уязвимостей. Для этого сканер отправляет запросы на адреса приложений с фиксированного списка IP‑адресов и с заголовком `X-Wallarm-Scanner-Info`.

#### Настройка

* [Включение / отключение](../user-guides/scanner/configure-scanner-modules.md) сканера выполняется в Консоли управления Валарм → секция **Сканер**. По умолчанию модуль включен
* [Настройка списка уязвимостей](../user-guides/scanner/configure-scanner-modules.md), которые может обнаруживать сканер, выполняется в Консоли управления Валарм → секция **Сканер**. По умолчанию включено обнаружение всех уязвимостей из списка
* Установка [ограничения на количество запросов от сканера](../user-guides/scanner/configure-scanner.md#ограничение-на-rps-сканера) выполняется в Консоли управления Валарм → секция **Сканер**
* Если WAF‑нода работает в режиме `block`, необходимо [отключить блокировку IP‑адресов](../admin-ru/scanner-ips-whitelisting.md), с которых отправляются запросы

## Ложные срабатывания

**Ложное срабатывание** — обнаружение признаков атаки в легитимном запросе или определение легитимной сущности как уязвимости ([подробнее о ложных срабатываниях на атаки →](protecting-against-attacks.md#ложные-срабатывания)).

Ложные срабатывания на уязвимости происходят из‑за особенностей защищаемых приложений. Один ответ на запрос может указывать на открытую уязвимость в одном защищаемом приложении и быть ожидаемым поведением в другом защищаемом приложении.

При обнаружении ложного срабатывания на уязвимость, вы можете самостоятельно добавить к уязвимости соответствующую отметку в Консоли управления Валарм. Уязвимость, отмеченная как ложное срабатывание, будет переведена в соответствующий статус и не будет перепроверяться. [Подробнее об управлении ложными срабатываниями через Консоль управления Валарм →](../user-guides/vulnerabilities/false-vuln.md)

Если обнаруженная уязвимость действительно существует в защищаемом приложении, но не может быть исправлена, рекомендуем настроить правило [**Применить виртуальный патч**](../user-guides/rules/vpatch-rule.md). Правило позволит блокировать атаки, направленные на обнаруженный тип уязвимости, и исключит риск инцидента.

## Управление обнаруженными уязвимостями

Все обнаруженные уязвимости отображаются в Консоли управления Валарм → секция **Уязвимости**. Вы можете управлять уязвимостями через интерфейс следующим образом:

* Просматривать и анализировать уязвимости
* Запускать перепроверку статуса уязвимости: открыта или исправлена на стороне приложения
* Самостоятельно закрывать уязвимости или отмечать их как ложное срабатывание

Более подробная информация об управлении уязвимостями приведена в инструкции по [работе с уязвимостиями](../user-guides/vulnerabilities/check-vuln.md).

![!Секция уязвимостей](../images/about-wallarm-waf/vulnerabilities-list.png)
