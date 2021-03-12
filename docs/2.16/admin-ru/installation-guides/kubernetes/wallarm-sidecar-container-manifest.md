# Публикация приложения с использованием Kubernetes-манифестов

## Требования

* Локальный или облачный (EKS, GKE, AKE и т.д.) кластер любой версии Kubernetes
* Приложение, опубликованное в Kubernetes с использованием манифестов
* Доступность pod'а из сети Интернет или других потенциально опасных ресурсов
* Ingress‑контроллер или внешний балансировщик нагрузки (например, AWS ELB, AWS ALB) передает публичный IP‑адрес подключающегося клиента в заголовке `X‑Forwarded‑For`
* Аккаунт в Личном кабинете Валарм для [EU‑облака](https://my.wallarm.com/) или [RU‑облака](https://my.wallarm.ru/)
* Email и пароль пользователя с ролью **Деплой**, который добавлен в ваш аккаунт в Личном кабинете Валарм. Для добавления пользователя используйте [инструкцию](../../../user-guides/settings/users.md#добавление-нового-пользователя)

## Установка

1. [Создайте](#шаг-1-создание-configmap-валарм) ConfigMap Валарм.
2. [Обновите](#шаг-2-обновление-объекта-deployment-в-kubernetes) описание объекта `Deployment` в Kubernetes.
3. [Обновите](#шаг-3-обновление-объекта-service-в-kubernetes) описание объекта `Service` в Kubernetes.
4. [Опубликуйте](#шаг-4-публикация-обновленного-приложения-в-kubernetes) обновленное приложение в Kubernetes.
5. [Протестируйте](#шаг-5-тестирование-sidecarконтейнера-валарм) sidecar‑контейнер Валарм.

!!! info "Если Валарм WAF уже установлен"
    Если вы устанавливаете Валарм WAF вместо существующего Валарм WAF или дублируете установку, используйте версию существующего Валарм WAF или обновите версии всех установок до последней.

    Версия установленного Валарм WAF указана в шаблоне Deployment → секция `spec.template.spec.containers` → `image` контейнера Валарм WAF.

    * Если указана версия `2.18`, используйте [инструкцию для 2.18](../../../../../admin-ru/installation-guides/kubernetes/wallarm-sidecar-container-manifest/).
    * Если указана версия `2.16`, используйте текущую инструкцию или увеличьте версии образов во всех установках до 2.18 и следуйте [инструкции для 2.18](../../../../../admin-ru/installation-guides/kubernetes/wallarm-sidecar-container-manifest/).
    * Если указана версия `2.14` или ниже, увеличьте версии образов во всех установках до 2.18 и следуйте [инструкции для 2.18](../../../../../admin-ru/installation-guides/kubernetes/wallarm-sidecar-container-manifest/).

    Более подробная информация о поддержке версий доступна в [политике версионирования WAF‑ноды](../../../updating-migrating/versioning-policy.md).

### Шаг 1: Создание ConfigMap Валарм

<ol start="1"><li>Создайте новый манифест Kubernetes или обновите существующий со следующими настройками NGINX для sidecar‑контейнера Валарм:</li></ol>

--8<-- "../include/kubernetes-sidecar-container/wallarm-sidecar-configmap-manifest.md"

<ol start="2"><li>Обновите значения параметров, следуя комментариям к коду.</li></ol>

### Шаг 2: Обновление объекта Deployment в Kubernetes

<ol start="1"><li>Перейдите к манифестам Kubernetes и откройте шаблон с описанием объекта <code>Deployment</code>. Если в приложении несколько объектов <code>Deployment</code>, откройте тот, в котором описаны pod'ы, доступные из сети Интернет. Например:</li></ol>

--8<-- "../include/kubernetes-sidecar-container/deployment-template.md"

<ol start="2"><li>Скопируйте в шаблон следующие элементы:<ul><li>в секцию <code>spec.template.spec.containers</code>описание sidecar‑контейнера <code>wallarm</code>;</li><li>в секцию <code>spec.template.spec.volumes</code> описание ресурса <code>wallarm-nginx-conf</code>.</li></ul>Ниже приведен пример шаблона с добавленными элементами. Элементы для копирования обозначены комментарием <code>элемент Валарм</code>.</li></li></ol>

--8<-- "../include/kubernetes-sidecar-container/deployment-with-wallarm-example-manifest-2.16.md"

<ol start="3"><li>Обновите значения параметров, следуя комментариям к коду.</li></ol>

### Шаг 3: Обновление объекта Service в Kubernetes

<ol start="1"><li>Вернитесь к манифестам Kubernetes и откройте шаблон с описанием объекта <code>Service</code>, который соответствует объекту <code>Deployment</code> из шага 2. Например:</li></ol>

--8<-- "../include/kubernetes-sidecar-container/service-template-manifest.md"

<ol start="2"><li>Обновите значение <code>ports.targetPort</code> в соответствии с <code>ports.containerPort</code> из описания sidecar‑контейнера Валарм. Например:</li></ol>

--8<-- "../include/kubernetes-sidecar-container/service-template-sidecar-port-manifest.md"

### Шаг 4: Публикация обновленного приложения в Kubernetes

Опубликуйте приложение в Kubernetes, используя обновленные манифесты.

!!! warning "Объект NetworkPolicy в Kubernetes"
    Если вы также используете объект `NetworkPolicy` в Kubernetes, убедитесь, что он обрабатывает трафик, поступающий с порта sidecar‑контейнера Валарм.

### Шаг 5: Тестирование sidecar‑контейнера Валарм

--8<-- "../include/kubernetes-sidecar-container/test-sidecar-container-in-kubernetes.md"