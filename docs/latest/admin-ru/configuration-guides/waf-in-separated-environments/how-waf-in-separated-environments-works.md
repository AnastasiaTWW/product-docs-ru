# Как работает WAF‑нода в изолированных средах

В процессе публикации приложения могут использоваться несколько сред: боевая, тестовая, среда разработки и другие, в зависимости от ваших настроек. Данный раздел документации описывает способы управления WAF‑нодой в нескольких изолированных средах.

## Что такое среда?

Определение термина в разных компаниях может отличаться. В данном разделе документации используется определение, приведенное ниже.

**Среда** — изолированный набор компьютерных ресурсов, который может использоваться для различных целей, например: разработка, тестирование или публикация. Средой управляет одна или несколько команд, например: SRE, команда разработки и QA. При этом, в управлении применяется набор правил по настройке сети, обновлению и версионированию приложения и другие стандарты.

Для повышения стабильности и качества фильтрации запросов рекомендуется поддерживать одинаковую конфигурацию WAF‑ноды для всех сред, которые настроены для приложения: боевой, тестовой, среды разработки и других.

## Возможности Валарм WAF в работе с изолированными средами

Для управления настройками WAF‑ноды в разных средах используются следующие возможности продукта Валарм WAF:

* [Идентификация ресурсов](#идентификация-ресурсов)
* [Использование разных аккаунтов Валарм](#использование-разных-аккаунтов-валарм)
* [Настройка режима фильтрации запросов](../../configure-wallarm-mode.md)

### Идентификация ресурсов

Вы можете настроить WAF‑ноду для определенной среды, используя следующие способы идентификации ресурсов:

* по уникальному Валарм ID для каждой среды;
* по домену URL среды, если вы используете разные значения для разных сред.

#### Идентификация среды по ID

Чтобы присвоить уникальный идентификатор каждой среде и настроить для сред правила фильтрации запросов, используется концепция [приложений](../../../user-guides/settings/applications.md).

Для настройки идентификаторов выполните следующие шаги:

1. Добавьте названия и идентификаторы всех сред в Личном кабинете Валарм > **Настройки** > **Приложения**.

    ![!Добавленные среды](../../../images/admin-guides/configuration-guides/waf-in-separate-environments/added-applications.png)

2. Передайте ID среды WAF‑ноде, которая настроена для этой среды. ID передается в следующем параметре WAF‑ноды:

    * [`wallarm_instance`](../../configure-parameters-ru.md#wallarm_instance), если WAF‑нода установлена в систему на базе Linux, в форме sidecar‑контейнера Kubernetes или Docker‑образа;
    * [`nginx.ingress.kubernetes.io/wallarm-instance`](../../configure-kubernetes-ru.md#аннотации-ingress), если WAF‑нода установлена в форме Ingress‑контроллера Kubernetes.

Теперь при создании правила фильтрации запросов вы можете указать ID сред, к которым применяется правило. Если ID сред не указаны, правило будет применяться ко всем ресурсам, на которых установлена WAF‑нода. 

![!Создание правила для отдельной среды по ID](../../../images/admin-guides/configuration-guides/waf-in-separate-environments/create-rule-for-id.png)

#### Идентификация среды по домену

Имя домена также может использоваться в качестве уникального идентификатора среды, если для каждой среды настроен отдельный домен, который передается в HTTP‑запросах в заголовке `HOST`.

Чтобы использовать идентификацию по домену, при создании правила фильтрации запросов добавьте условие с доменом конкретной среды в параметре запроса `HOST`. Правило из примера ниже будет применяться только к запросам со значением `dev.domain.com` в параметр `HOST`:

![!Создание правила для отдельной среды по домену](../../../images/admin-guides/configuration-guides/waf-in-separate-environments/create-rule-for-host.png)

### Использование разных аккаунтов Валарм

Один из способов отдельной настройки WAF‑нод для разных сред — использование разных аккаунтов Валарм для отдельных сред или групп сред. Многие провайдеры облачных сервисов, в том числе Amazon AWS, рекомендуют данный подход.

Для упрощения управления несколькими аккаунтами Валарм вы можете создать master‑аккаунт и привязать к нему остальные аккаунты. Данная настройка позволяет управлять всеми аккаунтами через один master‑аккаунт и не переключаться.

Чтобы привязать все аккаунты к master‑аккаунту, обратитесь в [службу поддержки Валарм](mailto:support@wallarm.com). Данная возможность продукта доступна только клиентам с enterprise-лицензией.

<div class="video-wrapper">
  <iframe width="1280" height="720" src="https://www.youtube.com/embed/Ol4CqJX2QSQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

!!! warning "Известные ограничения"
    * Набор правил фильтрации запросов применяется ко всем WAF‑нодам, привязанным к одному аккаунту Валарм. Чтобы применить правила к отдельным ресурсам, вы можете настроить [уникальные HTTP‑заголовки или ID](#идентификация-ресурсов).
    * Если WAF‑нода блокирует IP‑адрес запроса, блокировка применяется ко всем ресурсам, настроенным в рамках одного аккаунта Валарм. Автоматическая блокировка может произойти в нескольких случаях, например, при обнаружении трех или более векторов атак, отправленных с одного IP‑адреса.