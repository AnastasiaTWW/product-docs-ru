[link-grpc-docs]:       https://grpc.io/
[link-http2-docs]:      https://developers.google.com/web/fundamentals/performance/http2
[link-protobuf-docs]:   https://developers.google.com/protocol-buffers/

# Что нового в WAF‑ноде 2.14

* Добавлена поддержка gRPC: теперь Валарм может защищать API и веб‑приложения, работающие по протоколу gRPC.
  
    !!! info "О протоколе gRPC"
        Это современный, открытый и высокопроизводительный [фреймворк][link-grpc-docs] для удаленного вызова процедур (Remote Procedure Call, RPC), созданный компанией Google.
        
        Высокая производительность достигается за счет использования [HTTP/2][link-http2-docs] в качестве транспорта и [protobuf][link-protobuf-docs] для описания типов данных.
        
        Протокол gRPC может использоваться при построении сервисов и API в качестве альтернативы REST.

* Добавлена поддержка настраиваемых страниц блокировки и кодов ответа сервера при блокировке по IP‑адресу. Настройка выполняется через директиву [`wallarm_acl_block_page`](../admin-ru/configure-parameters-ru.md#wallarm_acl_block_page).
* Добавлена поддержка кастомного кода ответа сервера при блокировке вредоносного запроса. Настройка выполняется через параметр `response_code` в директиве [`wallarm_block_page`](../admin-ru/configure-parameters-ru.md#wallarm_block_page).
* Улучшена работа мониторинга и других компонентов системы.
* Добавлена поддержка следующих операционных систем:
    * Debian 10
    * Amazon Linux 2
* Прекращена поддержка операционных систем Debian 8.x (jessie) и Ubuntu 14.04 LTS (trusty). Поддержка Debian 8.x (jessie-backports) доступна.
* Добавлена поддержка [блокировки запросов по IP‑адресам](../admin-ru/configure-ip-blocking-ru.md) для Ingress‑контроллера Валарм WAF и для WAF‑ноды, развернутой в Docker‑контейнере.

----------

[Другие обновления в продуктах и компонентах Валарм →](https://changelog.wallarm.ru/)
