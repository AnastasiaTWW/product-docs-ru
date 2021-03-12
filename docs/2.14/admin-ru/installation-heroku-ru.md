[anchor1]:      #запуск-wafноды
[anchor2]:      #переменные-окружения
[anchor3]:      #координация-приложения-и-dyno
[anchor4]:      #настраиваемая-конфигурация-nginx
[doc-monitoring]: monitoring/intro.md

# Установка с использованием Heroku

!!! warning "Необходимые условия"
    Перед установкой WAF‑ноды Валарм убедитесь, что соблюдены следующие требования:
    
    * Ваше приложение использует стек Heroku-16 или Heroku-18. Более подробная информация о стеках доступна в [документации Heroku](https://devcenter.heroku.com/articles/stack).
    * У вас есть аккаунт Валарм с ролью «Администратор».

Веб‑приложения и API, развернутые на платформе Heroku, могут быть легко защищены с помощью Валарм. WAF‑нода Валарм в этом случае разворачивается с помощью специального созданного Buildpack’а, который необходимо подключить к приложению.

Вы можете получить Heroku Buildpack для WAF‑ноды из [открытого репозитория Валарм](https://github.com/wallarm/heroku-buildpack-wallarm-node).

Buildpack обладает следующими особенностями:
* Используется [L2met](https://github.com/ryandotsmith/l2met)-совместимый формат логирования NGINX;
* Идентификаторы [Heroku request IDs](https://devcenter.heroku.com/articles/http-request-id) встроены в логирование NGINX;
* Приложение останавливает dyno, если NGINX или сервер приложения выходит из строя. Это сделано из соображений безопасности;
* [Независимость от языка или сервера приложения][anchor1];
* [Параметры окружения для настройки WAF‑ноды][anchor2];
* [Настраиваемая конфигурация NGINX][anchor4];
* [Запуск dyno координируется приложением][anchor3].

### Запуск WAF‑ноды

Buildpack с WAF‑нодой предоставляет команду `wallarm/bin/start-wallarm`. В качестве аргумента ей передается команда для запуска вашего приложения.

Пример для запуска WAF‑ноды и сервера приложений Unicorn:

``` bash
cat Procfile
web: wallarm/bin/start-wallarm bundle exec unicorn -c config/unicorn.rb
```

### Переменные окружения

Общие параметры WAF‑ноды задаются через переменные окружения:

* `WALLARM_USER` — email пользователя [EU‑облака](https://my.wallarm.com/) или [RU‑облака](https://my.wallarm.ru/) с правами на добавление новых WAF‑нод.
* `WALLARM_PASSWORD` — пароль пользователя.
* `WALLARM_MODE` — режим обработки запросов: *off* (выключен), *monitoring* (режим мониторинга), *blocking* (режим блокировки).
* `WALLARM_TARANTOOL_MEMORY` — размер памяти в гигабайтах, выделенной для постаналитики; по умолчанию, 50% всей памяти.

Пример использования переменной окружения для установки режима блокировки:

``` bash
heroku config:set WALLARM_MODE=block
```

### Настраиваемая конфигурация NGINX

В некоторых случаях может понадобиться дополнительно настроить NGINX, который является важной частью buildpack’а. Вы можете задать собственную конфигурацию NGINX путем создания файла `nginx.conf.erb` в директории `wallarm/etc/nginx`.

Начните с копирования [конфигурационного файла buildpack](https://github.com/wallarm/heroku-buildpack-wallarm-node/blob/master/nginx.conf.erb).

!!! info "Мониторинг WAF‑ноды"
    С помощью этого конфигурационного файла вы можете включить возможность мониторинга WAF‑ноды, разворачиваемой в Heroku.
    
    Для этого в блоке location `/wallarm-status` добавьте директиву `allow <MONITORING_SERVER_IP_ADDRESS>` c публичным IP‑адресом `<MONITORING_SERVER_IP_ADDRESS>` вашей системы мониторинга:
    ```
    location = /wallarm-status {
      allow <MONITORING_SERVER_IP_ADDRESS>;
      allow 127.0.0.1;
      allow ::1;
      deny all;
      wallarm_status on;
      access_log off;
      }
    ```
    
    Про мониторинг WAF‑нод написано [здесь][doc-monitoring].

### Координация приложения и dyno

Buildpack не будет запускать NGINX с модулем Валарм, пока не будет создан файл `/tmp/app-initialized`. 

Поскольку NGINX привязан к $PORT dyno, и $PORT определяет, может ли приложение получать трафик, вы можете задержать получение трафика NGINX до тех пор, пока ваше приложение не будет к этому готово. В примерах ниже показано, как и когда записывать в этот файл при работе с Unicorn.

## Практический пример подключения WAF‑ноды

Ниже приведены два примера подключения Валарм: для существующего приложения и для нового приложения. 

В обоих случаях используются Ruby и Unicorn, однако аналогичным образом можно установить Валарм и для других языков программирования и серверов приложений.

### Защита уже существующего приложения

Подключите buildpack WAF‑ноды Валарм:

``` bash
heroku buildpacks:add https://github.com/wallarm/heroku-buildpack-wallarm-node.git
```

Обновите Procfile, чтобы стартовать WAF‑ноду, указав в параметрах команду для запуска текущего сервера приложений:

```
web: wallarm/bin/start-wallarm bundle exec unicorn -c config/unicorn.rb
```

``` bash
git add Procfile
git commit -m 'Update procfile for Wallarm Node buildpack'
```

Обновите конфигурацию сервера приложений для обработки запросов на локальном сокете и автоматического создания файла `/tmp/app-initialized` для приема трафика:

```
require 'fileutils'
listen '/tmp/nginx.socket'
before_fork do |server,worker|
  FileUtils.touch('/tmp/app-initialized')
end
```

``` bash
git add config/unicorn.rb
git commit -m 'Update unicorn config to listen on NGINX socket.'
```

Подключите WAF‑ноду к облаку Валарм:

=== "EU‑облако"
    ``` bash
    heroku config:set WALLARM_USER <your email>
    heroku config:set WALLARM_PASSWORD <your password>
    ```
=== "RU‑облако"
    ```bash
    heroku config:set WALLARM_API_HOST=api.wallarm.ru
    heroku config:set WALLARM_USER <your email>
    heroku config:set WALLARM_PASSWORD <your password>
    ```

Наконец, разверните изменения для запуска приложений с включенным анализом трафика:

``` bash
git push heroku master
```

### Защита нового приложения

Ниже — пример построения простого приложения, которое будет использовать Buildpack WAF‑ноды Валарм для анализа трафика.

Создайте директорию для приложения:

``` bash
mkdir myapp; cd myapp
git init
```

Создайте Gemfile со следующим содержимым:

```
source 'https://rubygems.org'
gem 'unicorn'
gem 'rack'
```

Создайте файл `config.ru`:

``` bash
run Proc.new {[200,{'Content-Type' => 'text/plain'}, ["hello world"]]}
```

Создайте файл `config/unicorn.rb` с настройками сервера приложений, принимающего подключения через локальный сокет:

```
require 'fileutils'
preload_app true
timeout 5
worker_processes 4
listen '/tmp/nginx.socket', backlog: 1024

before_fork do |server,worker|
  FileUtils.touch('/tmp/app-initialized')
end
```

Установите Gems:

``` bash
bundle install
```

Создайте Procfile:

```
web: wallarm/bin/start-wallarm bundle exec unicorn -c config/unicorn.rb
```

Создайте и разверните приложение Heroku командами ниже в зависимости от облака, которое вы используете.

=== "EU‑облако"
    ``` bash
    heroku create
    heroku buildpacks:add heroku/ruby
    heroku buildpacks:add https://github.com/wallarm/heroku-buildpack-wallarm-node.git
    heroku config:set WALLARM_USER <your email>
    heroku config:set WALLARM_PASSWORD <your password>
    git add .
    git commit -am "init"
    git push heroku master
    heroku logs -t
    ```
=== "RU‑облако"
    ``` bash
    heroku create
    heroku buildpacks:add heroku/ruby
    heroku buildpacks:add https://github.com/wallarm/heroku-buildpack-wallarm-node.git
    heroku config:set WALLARM_API_HOST=api.wallarm.ru
    heroku config:set WALLARM_USER <your email>
    heroku config:set WALLARM_PASSWORD <your password>
    git add .
    git commit -am "init"
    git push heroku master
    heroku logs -t
    ```

Проверьте приложение:

``` bash
heroku open
```