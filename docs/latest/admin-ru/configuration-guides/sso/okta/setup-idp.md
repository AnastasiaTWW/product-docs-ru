[img-dashboard]:            ../../../../images/admin-guides/configuration-guides/sso/okta/dashboard.png
[img-general]:              ../../../../images/admin-guides/configuration-guides/sso/okta/wizard-general.png  
[img-saml]:                 ../../../../images/admin-guides/configuration-guides/sso/okta/wizard-saml.png
[img-saml-preview]:         ../../../../images/admin-guides/configuration-guides/sso/okta/wizard-saml-preview.png
[img-feedback]:             ../../../../images/admin-guides/configuration-guides/sso/okta/wizard-feedback.png
[img-fetch-metadata-xml]:   ../../../../images/admin-guides/configuration-guides/sso/okta/fetch-metadata-xml.png
[img-xml-metadata]:         ../../../../images/admin-guides/configuration-guides/sso/okta/xml-metadata-example.png
[img-fetch-metadata-manually]:  ../../../../images/admin-guides/configuration-guides/sso/okta/fetch-metadata-manually.png

[doc-setup-sp]:             setup-sp.md
[doc-metadata-transfer]:    metadata-transfer.md

[link-okta-docs]:           https://help.okta.com/en/prod/Content/Topics/Apps/Apps_App_Integration_Wizard.htm

[anchor-general-settings]:  #1-общие-настройки-general-settings
[anchor-configure-saml]:    #2-настройка-saml-configure-saml
[anchor-feedback]:          #3-обратная-связь-feedback
[anchor-fetch-metadata]:    #выгрузка-метаданных  


#   Шаг 2.  Создание и настройка приложения в Okta

!!! info "Необходимые сведения"
    В этом руководстве в качестве демонстрационных используются следующие значения:
    
    *   `WallarmApp` — для параметра **App name** (в Okta);
    *   `https://sso.online.wallarm.com/acs` — для параметра **Single sign on URL** (в Okta);
    *   `https://sso.online.wallarm.com/entity-id` — для параметра **Audience URI** (в Okta).

!!! warning "Обратите внимание"
    Убедитесь, что вместо демонстрационных значений последних двух параметров вы используете значения, [полученные ранее][doc-setup-sp].

Авторизуйтесь в сервисе Okta (аккаунт должен быть с правами администрирования) и нажмите на кнопку *Администратор* в правом верхнем углу.

В разделе *Dashboard* нажмите на кнопку *Add Applications* справа.

![!Дэшборд Okta][img-dashboard]

Далее в разделе добавления новых приложений нажмите кнопку *Create New App* справа.

Во всплывающем окне установите следующие параметры:
*   **Platform** → «Web».
*   **Sign on method** → «SAML 2.0».

Нажмите на кнопку *Create*.

После этого вы перейдете в мастер создания SAML‑интеграции (*Create SAML Integration*). Для создания и настройки SAML‑интеграции предлагается пройти три этапа:
1.  [Общие настройки][anchor-general-settings] (**General Settings**).
2.  [Настройка SAML][anchor-configure-saml] (**Configure SAML**).
3.  [Обратная связь][anchor-feedback] (**Feedback**).

Затем потребуется [выгрузить метаданные][anchor-fetch-metadata] для созданной интеграции.


##  1.  Общие настройки (General Settings)

На этом этапе введите имя создаваемого приложения в поле **App Name**. 

Опционально вы можете загрузить логотип создаваемого приложения (поле
**App logo**) и настроить видимость приложения (поле **App visibility**) для ваших пользователей на домашней странице Okta и в мобильном приложении Okta.

Нажмите кнопку *Next*.

![!Общие настройки][img-general]


##  2.  Настройка SAML (Configure SAML)

На этом этапе вам понадобятся параметры, сгенерированные [ранее][doc-setup-sp] на стороне Валарм:
*   **Wallarm Entity ID**;
*   **Assertion Consumer Service URL (ACS URL)**.

!!! info "Параметры Okta"
    Это руководство описывает только обязательные для заполнения параметры при настройке SSO с Okta.
    
    Чтобы узнать подробнее об остальных параметрах (в том числе связанных с настройками цифровой подписи и шифрования сообщений SAML), воспользуйтесь [документацией Okta][link-okta-docs].

Заполните следующие основные параметры:
*   **Single sign on URL** — введите значение **Assertion Consumer Service URL (ACS URL)**, полученное ранее на стороне Валарм.
*   **Audience URI (SP Entity ID)** — введите значение **Wallarm Entity ID**, полученное ранее на стороне Валарм.

Остальные параметры для первоначальной настройки можно оставить по умолчанию.

![!Настройки SAML][img-saml]

Для продолжения настройки нажмите кнопку *Next*. При необходимости вернуться к предыдущему этапу нажмите кнопку *Previous*.

![!Предварительный просмотр настроек SAML][img-saml-preview]


##  3.  Обратная связь (Feedback)

На этом этапе вам предлагается предоставить сервису Okta дополнительную информацию о типе вашего приложения, являетесь ли вы клиентом или партнером Okta и другие данные. На данном этапе достаточно выбрать для параметра **Are you a customer or partner?** значение «I'm an Okta customer adding an internal app». 

При необходимости заполните другие доступные параметры. 

После этого вы можете завершить работу с мастером создания SAML‑интеграции, нажав на кнопку *Finish*. Для перехода на предыдущий шаг нажмите кнопку *Previous*.

![!Форма обратной связи][img-feedback]

После этого этапа вы попадете на страницу настроек созданного приложения.

Теперь требуется [выгрузить метаданные][anchor-fetch-metadata] для созданной интеграции, чтобы [продолжить настройку SSO‑провайдера][doc-metadata-transfer] на стороне Валарм. 

Метаданные представляют собой набор параметров, описывающих свойства поставщика идентификационных данных (подобных тем, что были сформированы для поставщика сервиса на [Шаге 1][doc-setup-sp]), необходимых для настройки SSO.


##  Выгрузка метаданных

Вы можете выгрузить метаданные либо в виде XML‑файла, либо «как есть» в текстовом виде (полученные таким образом метаданные потребуется вводить вручную при дальнейшей настройке).

Для выгрузки в виде XML‑файла:
1.  На странице настроек созданного приложения нажмите на ссылку «Identity Provider metadata»:

    ![!Ссылка для выгрузки метаданных][img-fetch-metadata-xml]
    
    В результате вы перейдете на новую вкладку вашего браузера с подобным содержимым:
    
    ![!Пример метаданных в формате XML][img-xml-metadata]
    
2.  Сохраните содержимое (средствами браузера или другим удобным для вас способом) в XML‑файл.


Для выгрузки метаданных «как есть»:
1.  На странице настроек созданного приложения нажмите кнопку *View Setup instructions*:

    ![!Кнопка «View Setup instructions»][img-fetch-metadata-manually]
    
2.  Скопируйте все предоставленные данные.

Теперь вы можете [продолжить настройку SSO][doc-metadata-transfer] на стороне Валарм.