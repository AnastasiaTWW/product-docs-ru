# Opsgenie

Вы можете настроить оповещения Opsgenie для следующих событий:

* Обнаружена [уязвимость](../../../glossary-ru.md#уязвимость)

## Настройка интеграции

В интерфейсе [Opsgenie](https://app.opsgenie.com/teams/list):

1. Перейдите к вашей команде ➝ **Integrations**.
2. Нажмите кнопку **Add integration** и выберите **API**.
3. Введите название интеграции и нажмите **Save Integration**.
4. Скопируйте полученный ключ API.

В Личном кабинете Валарм:

1. Откройте **Настройки** → **Интеграции**.
2. Нажмите на блок **Opsgenie** или нажмите кнопку **Добавить интеграцию** и выберите **Opsgenie**.
3. Введите имя интеграции.
4. Вставьте скопированный ключ API в поле **Ключ API**.
5. Если вы используете [EU‑инстанс](https://docs.opsgenie.com/docs/european-service-region) Opsgenie, выберите соответствующий эндпоинт Opsgenie API из списка. По умолчанию установлен эндпоинт US‑инстанса.
6. Выберите типы событий, о которых необходимо отправлять уведомления. Если события не выбраны, уведомления не отправляются.
7. [Протестируйте интеграцию](#тестирование-интеграции) и убедитесь в корректности настроек.
8. Нажмите **Добавить интеграцию**.

    ![!Добавление интеграции с Opsgenie](../../../images/user-guides/settings/integrations/add-opsgenie-integration.png)

## Тестирование интеграции

--8<-- "../include/integrations/test-integration.md"

Пример уведомления в Opsgenie:

![!Тестовое уведомление в Opsgenie](../../../images/user-guides/settings/integrations/test-opsgenie-new-vuln.png)

## Редактирование интеграции

--8<-- "../include/integrations/update-integration.md"

## Отключение интеграции

--8<-- "../include/integrations/disable-integration.md"

## Удаление интеграции

--8<-- "../include/integrations/remove-integration.md"
