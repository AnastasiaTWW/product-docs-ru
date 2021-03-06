# Отчеты по email

Вы можете указать email-адреса для получения запланированных отчетов безопасности и уведомлений. Отправка сообщений на email, указанный при регистрации, настроена по умолчанию.

* Отчеты безопасности отправляются ежедневно, еженедельно или ежемесячно, в зависимости от указанных настроек. Отчет содержит подробную информацию об уязвимостях, атаках и инцидентах, обнаруженных в системе за выбранный промежуток времени.
* Уведомления отправляются при обнаружении следующих событий:
    --8<-- "../include/integrations/events-for-integrations.md"

## Настройка интеграции

1. Перейдите на вкладку **Интеграции** раздела **Настройки**.
2. Нажмите на блок **Отчеты по email** или нажмите кнопку **Добавить интеграцию** и выберите **Отчеты по email**.
3. Введите имя интеграции.
4. Введите через запятую email-адреса.
5. Выберите периодичность отчетов безопасности. Если периодичность не указана, отчеты не отправляются.
6. Выберите типы событий, о которых необходимо отправлять уведомления. Если события не выбраны, уведомления не отправляются.
7. [Протестируйте интеграцию](#тестирование-интеграции) и убедитесь в корректности настроек.
8. Нажмите **Добавить интеграцию**.

    ![!Добавление отчетов по email](../../../images/user-guides/settings/integrations/add-email-report-integration.png)

## Тестирование интеграции

--8<-- "../include/integrations/test-integration.md"

Пример тестового письма:

![!Тестовое письмо](../../../images/user-guides/settings/integrations/test-email-scope-changed.png)

## Редактирование интеграции

--8<-- "../include/integrations/update-integration.md"

## Отключение интеграции

--8<-- "../include/integrations/disable-integration.md"

## Удаление интеграции

--8<-- "../include/integrations/remove-integration.md"
