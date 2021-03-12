[link-selinux]:     https://www.redhat.com/en/topics/linux/what-is-selinux
[doc-monitoring]:   monitoring/intro.md

# Настройка SELinux

Если на хосте с WAF‑нодой активирован механизм [SELinux][link-selinux], то он может помешать работе WAF‑ноды, так как будут недоступны:
* экспорт показателей RPS (requests per second) и APS (attacks per second) WAF‑ноды в облако Валарм;
* экспорт метрик WAF‑ноды в системы мониторинга/сбора данных с использованием протокола TCP (см. документацию по [настройке мониторинга][doc-monitoring]).

SELinux по умолчанию установлен и активирован в дистрибутивах, основанных на RedHat Linux (например, CentOS и Amazon Linux 2). Он также доступен для установки и использования в других дистрибутивах, например, Debian и Ubuntu.

Требуется либо отключить SELinux, либо настроить его так, чтобы он не влиял на работу WAF‑ноды.

## Проверьте статус SELinux

Выполните команду:

``` bash
sestatus
```

Изучите вывод команды:
* `SELinux status: enabled` — SELinux включен.
* `SELinux status: disabled` — SELinux отключен.

## Настройте SELinux

Чтобы SELinux не препятствовал работе WAF‑ноды, разрешите `collectd` работать с TCP-сокетами:

``` bash
setsebool -P collectd_tcp_network_connect 1
```

Проверьте, что команда выполнена успешно:

``` bash
semanage export | grep collectd_tcp_network_connect

# Вывод команды должен содержать строку:
# boolean -m -1 collectd_tcp_network_connect
```

## Отключение SELinux 

Чтобы отключить SELinux (перевести его в статус «disabled»), выполните одно из следующих действий:
* выполните команду `setenforce 0` (SELinux будет отключен до перезагрузки);
* откройте файл `/etc/selinux/config` и измените значение переменной `SELINUX` на `disabled` (требуется перезагрузка, SELinux будет отключен постоянно).