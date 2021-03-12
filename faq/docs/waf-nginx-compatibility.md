# Совместимость Валарм WAF с версиями NGINX

## Валарм WAF совместим с версией NGINX mainline?

Нет, модуль Валарм WAF несовместим с версией NGINX `mainline`. Вы можете установить модуль Валарм WAF следующим образом:

* подключить к официальной бесплатной версии NGINX `stable` по [инструкции](../waf-installation/nginx/dynamic-module.md)
* подключить к версии NGINX, установленной из репозитория Debian/CentOS, по [инструкции](../waf-installation/nginx/dynamic-module-from-distr.md)
* подключить к официальной коммерческой версии NGINX Plus по [инструкции](../waf-installation/nginx-plus.md)

## Модуль Валарм WAF может быть подключен к кастомной сборке NGINX?

Да, после пересборки модуль Валарм WAF может быть подключен к кастомной сборке NGINX. Для пересборки динамического модуля свяжитесь с [технической поддержкой Валарм](mailto:support@wallarm.com) и отправьте результаты выполнения команд:

* Версия ядра Linux: `uname -a`
* Версия операционной системы Linux: `cat /etc/*release`
* Версия установленного NGINX:
    * [официальная сборка NGINX](https://nginx.org/ru/linux_packages.html): `/usr/sbin/nginx -V`
    * кастомная сборка NGINX: `<путь к nginx>/nginx -V`
* Сигнатура совместимости:
    * [официальная сборка NGINX](https://nginx.org/ru/linux_packages.html): `egrep -ao '.,.,.,[01]{33}' /usr/sbin/nginx`
    * кастомная сборка NGINX: `egrep -ao '.,.,.,[01]{33}' <путь к nginx>/nginx`
* Пользователь (и его группа), от имени которого запускаются worker-процессы NGINX: `grep -w 'user' <путь к конфигурационным файлам NGINX/nginx.conf>`
