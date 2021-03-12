[link-pagerduty-docs]: https://support.pagerduty.com/docs/services-and-integrations

# PagerDuty

Вы можете настроить создание инцидентов PagerDuty для следующих событий:

--8<-- "../include/integrations/events-for-integrations.md"

##  Настройка интеграции

Настройте [интеграцию в PagerDuty][link-pagerduty-docs] для существующего сервиса или создайте новый сервис для Валарм:

1.  Перейдите в меню **Configuration** → **Services**.
2.  Откройте настройки сервиса из списка или нажмите кнопку **New Service**.
3.  Перейдите к созданию новой интеграции.

    *   Если вы настраиваете итеграцию в существующем сервисе, перейдите на вкладку **Integrations** и нажмите на кнопку **New Integration**. 
    *   Если вы создаете новый сервис, введите имя сервиса и перейдите к секции **Integration Settings**.
4.  Введите название интеграции и выберите способ интеграции **Use our API directly**.
5. Сохраните настройки:

    *   Если вы настраиваете интеграцию в существующем сервисе, нажмите на кнопку **Add Integration**.
    *   Если вы создаете новый сервис, заполните остальные параметры сервиса и нажмите на кнопку **Add Service**.
6.  Скопируйте полученное значение **Integration Key**.

В Личном кабинете Валарм:

1. Откройте **Настройки** → **Интеграции**.
2. Нажмите на блок **PagerDuty** или нажмите кнопку **Добавить интеграцию** и выберите **PagerDuty**.
3. Введите имя интеграции.
4. Вставьте скопированный **Integration Key** в соответствующее поле.
5. Выберите типы событий, для которых необходимо создавать инициденты PagerDuty. Если события не выбраны, инциденты не создаются.
6. [Протестируйте интеграцию](#тестирование-интеграции) и убедитесь в корректности настроек.
7. Нажмите **Добавить интеграцию**.

    ![!Добавление интеграции с PagerDuty](../../../images/user-guides/settings/integrations/add-pagerduty-integration.png)

## Тестирование интеграции

--8<-- "../include/integrations/test-integration.md"

Пример уведомления в PagerDuty:

![!Тестовое уведомление в PagerDuty](../../../images/user-guides/settings/integrations/test-pagerduty-scope-changed.png)

## Редактирование интеграции

--8<-- "../include/integrations/update-integration.md"

## Отключение интеграции

--8<-- "../include/integrations/disable-integration.md"

## Удаление интеграции

--8<-- "../include/integrations/remove-integration.md"
