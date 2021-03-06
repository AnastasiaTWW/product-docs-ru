# Обзор WAF‑нод

В Личном кабинете Валарм → секция **Ноды** вы можете управлять WAF‑нодами:

* получить свойства и метрики установленной WAF‑ноды,
* пересоздать токен для облачной WAF‑ноды,
* удалить WAF‑ноду,
* создать новую WAF‑ноду.

![!WAF‑ноды](../../images/user-guides/nodes/table-nodes.png)

!!! info "Доступ администратора"
    Создание, удаление и пересоздание токена WAF‑ноды доступно пользователям только с ролью **Администратор**. Просмотр информации об установленных WAF‑нодах доступен всем пользователям.

## Типы WAF‑ноды

Тип WAF‑ноды зависит от платформы установки:

* [Локальная нода](regular-node.md) устанавливается на NGINX, NGINX Plus, Kong и в форме Docker‑образа.
* [Облачная нода](cloud-node.md) устанавливается в облако Amazon AWS, Google Cloud Platform, Heroku и в форме Ingress‑контроллера в Kubernetes.

Подробная информация о работе с разными типами нод описана в инструкциях по ссылкам выше.

## Фильтрация WAF‑нод

Для фильтрации WAF‑нод в таблице вы можете ввести имя, UUID, токен или IP‑адрес ноды в строку поиска или использовать вкладки:

* **Все** с активными и неактивными локальными, облачными нодами.
* **Локальные** с активными и неактивными [локальными нодами](regular-node.md).
* **Облачные** с активными и неактивными [облачными нодами](cloud-node.md).
* **Неактивные** с неактивными локальными и облачными нодами. Нода считается неактивной, если установлена для неактивного инстанса.
