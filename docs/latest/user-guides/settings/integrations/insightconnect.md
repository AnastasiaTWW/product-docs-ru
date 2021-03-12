# InsightConnect

Вы можете настроить отправку уведомлений в InsightConnect для следующих событий:

--8<-- "../include/integrations/advanced-events-for-integrations.md"

## Настройка интеграции

Сгенерируйте и скопируйте ключ InsightConnect API:

1. Перейдите в интерфейс InsightConnect → **Settings** → [**API Keys**](https://insight.rapid7.com/platform#/apiKeyManagement) и нажмите **New User Key**.
2. Введите название ключа API (например, `Wallarm API`) и нажмите **Generate**.
3. Скопируйте сгенерированный ключ API.
4. Перейдите в Личный кабинет Валарм → **Настройки** → **Интеграции** по ссылке для [EU‑облака](https://my.wallarm.com/settings/integrations/) или для [RU‑облака](https://my.wallarm.ru/settings/integrations/) и выберите **InsightConnect**.
5. Вставьте значение скопированного ключа API в поле **Ключ API**.

Сгенерируйте и скопируйте InsightConnect API URL:

1. Вернитесь в интерфейс InsightConnect на страницу **Automation** → **Workflows** и создайте новый Workflow для обработки оповещений от Валарм.
2. Выберите **API Trigger** на шаге **Choose a trigger**.
3. Скопируйте сгенерированный URL.
4. Вернитесь к настройке **InsightConnect** в Личном кабинете Валарм и вставьте скопированный URL в поле **API URL**.

Завершите настройку в Личном кабинете Валарм:

1. Введите имя интеграции.
2. Выберите типы событий, о которых необходимо отправлять уведомления. Если события не выбраны, уведомления не отправляются.
3. [Протестируйте интеграцию](#тестирование-интеграции) и убедитесь в корректности настроек.
4. Нажмите **Добавить интеграцию**.

![!Добавление интеграции с InsightConnect](../../../images/user-guides/settings/integrations/add-insightconnect-integration.png)

## Тестирование интеграции

--8<-- "../include/integrations/test-integration.md"

Пример уведомления в InsightConnect:

![!Тестовое уведомление в InsightConnect](../../../images/user-guides/settings/integrations/test-insightconnect-scope-changed.png)

## Редактирование интеграции

--8<-- "../include/integrations/update-integration.md"

## Отключение интеграции

--8<-- "../include/integrations/disable-integration.md"

## Удаление интеграции

--8<-- "../include/integrations/remove-integration.md"
