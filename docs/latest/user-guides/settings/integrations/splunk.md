# Splunk

Вы можете настроить оповещения Splunk для следующих событий:

--8<-- "../include/integrations/advanced-events-for-integrations.md"

##  Настройка интеграции

В интерфейсе Splunk:

1. Перейдите на страницу **Settings** ➝ **Add Data** и выберите **Monitor**.
2. Выберите тип **HTTP Event Collector**, введите название интеграции и нажмите **Next**.
3. Пропустите выбор типа данных на странице **Input Settings** и перейдите к **Review Settings**.
4. Проверьте и подтвердите настройки.
5. Скопируйте полученный токен.

В Личном кабинете Валарм:

1. Откройте **Настройки** → **Интеграции**.
2. Нажмите на блок **Splunk** или нажмите кнопку **Добавить интеграцию** и выберите **Splunk**.
3. Введите имя интеграции.
4. Вставьте скопированный токен в поле **HEC Token**.
5. Вставьте HEC URI и номер порта вашего инстанса Splunk в поле `HEC URI:PORT`. Например: `https://hec.splunk.com:8088`.
6. Выберите типы событий, о которых необходимо отправлять уведомления. Если события не выбраны, уведомления не отправляются.
7. [Протестируйте интеграцию](#тестирование-интеграции) и убедитесь в корректности настроек.
8. Нажмите **Добавить интеграцию**.

    ![!Добавление интеграции со Splunk](../../../images/user-guides/settings/integrations/add-splunk-integration.png)

## Тестирование интеграции

--8<-- "../include/integrations/test-integration.md"

Пример уведомления в Splunk в формате JSON:

```
{
    "title": "Test",
    "source": "Wallarm",
    "type": "Info",
    "domain": "example.com",
    "threat": "Medium",
    "link": "https://my.wallarm.com/object/555",
    "summary": "[Тестовое сообщение] Обнаружена новая уязвимость"
}
```

## Редактирование интеграции

--8<-- "../include/integrations/update-integration.md"

## Отключение интеграции

--8<-- "../include/integrations/disable-integration.md"

## Удаление интеграции

--8<-- "../include/integrations/remove-integration.md"
