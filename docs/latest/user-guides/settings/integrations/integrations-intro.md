[integration-pane-img]:         ../../../images/user-guides/settings/integrations/integration-panel.png
[add-integration-img]:          ../../../images/user-guides/settings/integrations/add-integration-button.png
[disable-button]:               ../../../images/user-guides/settings/integrations/disable-button.png

[email-notifications]:          ./email.md
[slack-notifications]:          ./slack.md
[telegram-notifications]:       ./telegram.md
[opsgenie-notifications]:       ./opsgenie.md
[pagerduty-notifications]:      ./pagerduty.md
[splunk-notifications]:         ./splunk.md
[sumologic-notifications]:      ./sumologic.md
[insightconnect-notifications]: ./insightconnect.md
[webhook-notifications]:        ./webhook.md
[account]:                      ../account.md


# Обзор интеграций

На вкладке **Настройки** → **Интеграции** вы можете настроить системы для получения регулярных отчетов и мгновенных уведомлений:

* Отчеты безопасности отправляются ежедневно, еженедельно или ежемесячно, в зависимости от указанных настроек. Отчет содержит подробную информацию об уязвимостях, атаках и инцидентах, обнаруженных в системе за выбранный промежуток времени.
* Уведомления отправляются при обнаружении уязвимости, хита, изменений периметра и системных событий. Уведомления содержат краткий обзор обнаруженной активности.

!!! info "Доступ администратора"
    Настройка интеграций доступна пользователям только с ролью **Администратор**.

## Типы интеграций

Доступные системы разделены на блоки: **Email и мессенджеры**, **Системы управления инцидентами и SIEM‑системы** и **Другие системы**.

![!Обзор интеграций][integration-pane-img]

### Email и мессенджеры

* **Основной email** — отчеты и уведомления на email, указанный при регистрации. Вы также можете настраивать эту интеграцию на вкладке **Настройки** → [**Профиль**][account]
* [Отчеты по email][email-notifications]
* [Slack][slack-notifications]
* [Telegram][telegram-notifications]

### Системы управления инцидентами и SIEM‑системы

* [Opsgenie][opsgenie-notifications]
* [InsightConnect][insightconnect-notifications]
* [PagerDuty][pagerduty-notifications]
* [Splunk][splunk-notifications]
* [Sumo Logic][sumologic-notifications]

### Другие системы

* [Webhook][webhook-notifications] для интеграции с любой системой, которая принимает входящие вебхуки по протоколу HTTPS. Например:
    * Fluentd с выгрузкой логов в [IBM QRadar](webhook-examples/fluentd-qradar.md), [Splunk Enterprise](webhook-examples/fluentd-splunk.md), [ArcSight Logger](webhook-examples/fluentd-arcsight-logger.md)
    * Logstash с выгрузкой логов в [IBM QRadar](webhook-examples/logstash-qradar.md), [Splunk Enterprise](webhook-examples/logstash-splunk.md), [ArcSight Logger](webhook-examples/logstash-arcsight-logger.md)

## Добавление интеграции

Для добавления интеграции нажмите на иконку ненастроенной системы на вкладке **Все** или нажмите кнопку **Добавить интеграцию** и выберите систему. Следующие шаги описаны в инструкции для выбранной системы.

![!Добавление интеграций][add-integration-img]

Количество интеграций с одной системой не ограничено. Например: для отправки отчетов безопасности в три канала Slack вы можете добавить три интеграции со Slack.

## Фильтрация интеграций

Для фильтрации интеграций вы можете использовать вкладки:

* **Все** с включенными, отключенными и ненастроенными интеграциями
* **Активные** с активными настроенными интеграциями
* **Отключенные** с отключенными настроенными интеграциями

![!Фильтрация интеграций][disable-button]

!!! info "Расширенная настройка уведомлений"
    Для расширенной настройки уведомлений вы можете использовать [триггеры](../../triggers/triggers.md).

## Повторная отправка запроса при неуспешном ответе

Чтобы отправить уведомление в систему, Валарм выполняет запрос к системе. Если система отвечает любым кодом кроме `2xx`, Валарм отправляет запрос повторно до получения кода `2xx` с интервалом:

* В первом цикле: 1, 3, 5, 10, 10 секунд
* Во втором цикле: 0, 1, 3, 5, 30 секунд
* В третьем цикле: 1, 1, 3, 5, 10, 30 минут

Если за 12 часов процент неуспешных запросов достигает 60%, интеграция автоматически отключается. Уведомление об отключенной интеграции отправляется в настроенные системы и на email администраторов аккаунта.

## Демо‑видео

<div class="video-wrapper">
  <iframe width="1280" height="720" src="https://www.youtube.com/embed/DVfoXYuBy-Y" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>