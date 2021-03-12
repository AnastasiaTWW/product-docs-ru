# Sumo Logic

Вы можете настроить отправку сообщений в Sumo Logic для следующих типов событий:

--8<-- "../include/integrations/advanced-events-for-integrations.md"

## Настройка интеграции

В интерфейсе Sumo Logic:

1. Настройте Hosted Collector, используя [инструкцию](https://help.sumologic.com/03Send-Data/Hosted-Collectors/Configure-a-Hosted-Collector).
2. Настройте HTTP Logs & Metrics Source, используя [инструкцию](https://help.sumologic.com/03Send-Data/Sources/02Sources-for-Hosted-Collectors/HTTP-Source).
3. Скопируйте полученный **HTTP Source Address (URL)**.

В Личном кабинете Валарм:

1. Откройте **Настройки** → **Интеграции**.
2. Нажмите на блок **Sumo Logic** или нажмите кнопку **Добавить интеграцию** и выберите **Sumo Logic**.
3. Введите имя интеграции.
4. Вставьте скопированное значение **HTTP Source Address (URL)** в соответствующее поле.
5. Выберите типы событий, о которых необходимо отправлять сообщения в Sumo Logic. Если события не выбраны, сообщения не отправляются.
6. [Протестируйте интеграцию](#тестирование-интеграции) и убедитесь в корректности настроек.
7. Нажмите **Добавить интеграцию**.

    ![!Добавление интеграции с Sumo Logic](../../../images/user-guides/settings/integrations/add-sumologic-integration.png)

## Тестирование интеграции

--8<-- "../include/integrations/test-integration.md"

Пример уведомления в Sumo Logic:

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
