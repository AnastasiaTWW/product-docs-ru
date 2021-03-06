# Перечень проверочных операций

В данном разделе представлен перечень операций для проверки работоспособности Валарм.

| Операция                                                                                                                                                            | Ожидаемый результат | Проверено |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|-----------|
| [WAF‑нода обнаруживает атаки](#wafнода-обнаруживает-атаки)                                                          |                     |           |
| [У вас есть доступ в интерфейс Валарм](#у-вас-есть-доступ-в-интерфейс-валарм)                                                      |                     |           |
| [Интерфейс показывает количество запросов в секунду](#интерфейс-показывает-количество-запросов-в-секунду)                            |                     |           |
| [Валарм обнаруживает уязвимости и создает инциденты безопасности](#валарм-обнаруживает-уязвимости-и-создает-инциденты-безопасности)|                     |           |
| [Валарм помечает запросы как ложные и перестает их блокировать](#валарм-помечает-запросы-как-ложные-и-перестает-их-блокировать)    |                     |           |
| [Перепроверка атак работает](#перепроверка-атак-работает)                                                                            |                     |           |
| [Валарм обнаруживает периметр](#валарм-обнаруживает-периметр)                                                                     |                     |           |
| [Черные списки работают](#черные-списки-работают)                                                                                    |                     |           |
| [Пользователей можно задавать и отключать](#пользователей-можно-задавать-и-отключать)                                                |                     |           |
| [В журнале действий пользователей есть записи](#в-журнале-действий-пользователей-есть-записи)                                        |                     |           |
| [Отчеты создаются](#отчеты-создаются)                                                                                                |                     |           | |

## WAF‑нода обнаруживает атаки

1. Отправьте вредоносный запрос на ваш ресурс:

   ```
   http://<resource_URL>/?id='or+1=1--a-<script>prompt(1)</script>'
   ```

2. Проверьте, что счетчик атак увеличился:

   ``` bash
   curl http://127.0.0.8/wallarm-status
   ```

Смотрите также [Проверка работоспособности WAF‑ноды](../quickstart-ru/qs-check-operation-ru.md)

## У вас есть доступ в интерфейс Валарм

1. Перейдите в Личный кабинет Валарм по ссылке для [EU‑облака](https://my.wallarm.com) или для [RU‑облака](https://my.wallarm.ru).
2. Проверьте, что вы можете войти в интерфейс.

Смотрите также [Дэшборд](../user-guides/dashboard/intro.md).

## Интерфейс показывает количество запросов в секунду

1. Отправьте запрос на ваш ресурс:
   
      ``` bash
      curl http://<resource_URL>
      ```

      Или отправьте сразу несколько запросов при помощи скрипта:

      ```
      for (( i=0 ; $i<10 ; i++ )) ;
      do 
         curl http://<resource_URL> ;
      done
      ```

      Данный пример отправляет 10 запросов.

2. Проверьте, что интерфейс Валарм показывает количество запросов в секунду.

Смотрите также [Дэшборд "WAF"](../user-guides/dashboard/waf.md).

## Валарм помечает запросы как ложные и перестает их блокировать

1. Разверните атаку на вкладке *Атаки*. 
2. Выберите запрос и нажмите *Ошибка*.
3. Подождите около трех минут.
4. Заново отправьте запрос и проверьте, что Валарм не определяет запрос как атаку и не блокирует его.

Смотрите также [Работа с ложным срабатыванием](../user-guides/events/false-attack.md).

## Валарм обнаруживает уязвимости и создает инциденты безопасности

1. Убедитесь, что у вас есть открытая уязвимость на вашем ресурсе.
2. Отправьте вредоносный запрос на уязвимость.
3. Проверьте, что в интерфейсе Валарм появился инцидент безопасности.

Смотрите также [Просмотр атак и инцидентов](../user-guides/events/check-attack.md).

## Перепроверка атак работает

1. На вкладке *Атаки* посмотрите обнаруженный вредоносный запрос из предыдущего шага.
2. Проверьте статус в колонке *Проверка*.

Смотрите также [Перепроверка атак](../user-guides/events/verify-attack.md).

## Валарм обнаруживает периметр

1. На вкладке *Периметр* добавьте домен вашего ресурса.
2. Проверьте, что Валарм обнаруживает все ресурсы, связанные с добавленным доменом.

Смотрите также [Работа со сканером](../user-guides/scanner/intro.md).

## Черные списки работают

1. Настройте блокировку как описано в [Блокировка по IP‑адресам](../admin-ru/configure-ip-blocking-ru.md).
2. На вкладке *Настройки* -> *Черные списки* добавьте блокировку.
3. Проверьте, что добавленный IP‑адрес блокируется и интерфейс Валарм показывает его как заблокированный.

Смотрите также [Черный список](../user-guides/blacklist.md).

## Пользователей можно задавать и отключать

1. Убедитесь в том, что у вас роль «Администратор» в системе Валарм.
2. Создайте, измените роль, отключите и удалите пользователей как описано в [Управление пользователями](../user-guides/settings/users.md).

## В журнале действий пользователей есть записи

1. Откройте вкладку *Настройки* –> *Пользователи*.
2. Проверьте что в *Журнале действий пользователей* есть записи.

Смотрите также [Журнал действий пользователей](../user-guides/settings/audit-log.md).

## Отчеты создаются

1. На вкладке *Атаки* введите поисковый запрос.
2. Нажмите на кнопку отчетов справа.
3. Введите ваш почтовый адрес и снова нажмите на кнопку отчетов.
5. Проверьте, что вы получили отчет.

Смотрите также [Создание отчета](../user-guides/search-and-filters/custom-report.md).
