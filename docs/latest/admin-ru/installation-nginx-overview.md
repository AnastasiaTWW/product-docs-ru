[img-postanalytics-options]:    ../images/installation-nginx-overview/postanalytics-options.png
[img-nginx-options]:            ../images/installation-nginx-overview/nginx-options.png

[anchor-mod-overview]:              #обзор-модулей
[anchor-mod-installation]:          #установка-и-настройка-модулей
[anchor-mod-inst-nginx]:            #модуль-для-nginx
[anchor-mod-inst-nginxplus]:        #модуль-для-nginx-plus
[anchor-mod-inst-postanalytics]:    #модуль-постаналитики

[link-ig-nginx]:                    ../waf-installation/nginx/dynamic-module.md
[link-ig-nginx-distr]:              ../waf-installation/nginx/dynamic-module-from-distr.md
[link-ig-nginxplus]:                ../waf-installation/nginx-plus.md
[link-ig-docker]:                   installation-docker-ru.md


#   Обзор вариантов установки

WAF‑нода, предназначенная для использования с NGINX или NGINX Plus представляет собой два модуля:
*   Модуль, подключаемый к NGINX (NGINX Plus);
*   Модуль постаналитики.

Порядок установки и настройки модулей зависит от того, каким образом вы устанавливаете NGINX или NGINX Plus.

В этом документе содержатся:
*   [Обзор модулей][anchor-mod-overview];
*   [Ссылки][anchor-mod-installation] на конкретные документы по установке и настройке модулей.

Также вы можете [развернуть WAF‑ноду с помощью Docker][link-ig-docker]. Контейнер с WAF‑нодой содержит в себе все необходимые модули.


##  Обзор модулей

При использовании WAF‑ноды для обработки трафика, входящий трафик последовательно проходит через этапы первичной обработки и обработки с помощью модулей Валарм:
1.  Первичная обработка трафика производится при помощи модуля, который подключается к уже установленному [NGINX][anchor-mod-inst-nginx] или [NGINX Plus][anchor-mod-inst-nginxplus].

2.  Дальнейшая обработка трафика происходит с использованием [модуля постаналитики][anchor-mod-inst-postanalytics].

    Для работы модуля постаналитики требуется наличие большого объема оперативной памяти, поэтому вы можете выбрать один из следующих вариантов развертывания:
    
    *   На серверах вместе с NGINX (NGINX Plus), если конфигурация серверов это позволяет;
    *   На выделенной группе серверов отдельно от NGINX (NGINX Plus).
    
    ![!Варианты установки модуля постаналитики][img-postanalytics-options]

##  Установка и настройка модулей

### Модуль для NGINX

!!! warning "Выбор модуля для установки"
    Процедуры установки и подключения модуля Валарм для NGINX зависят от того, каким образом вы устанавливаете NGINX.

Подключение модуля Валарм для NGINX поддерживается для следующих вариантов установки NGINX (в скобках приведены ссылки на инструкции по установке модулей для выбранного варианта установки):

![!Варианты установки модуля для NGINX][img-nginx-options]

*   Сборка NGINX из исходных файлов ([инструкция][link-ig-nginx]);
*   Установка пакетов NGINX из репозитория NGINX ([инструкция][link-ig-nginx]);
*   Установка пакетов NGINX из репозитория Debian ([инструкция][link-ig-nginx-distr]);
*   Установка пакетов NGINX из репозитория CentOS ([инструкция][link-ig-nginx-distr]).

### Модуль для NGINX Plus

Подключение модуля Валарм для NGINX Plus описано в [этой][link-ig-nginxplus] инструкции.

### Модуль постаналитики

Инструкции по установке и настройке модуля постаналитики (в любом из доступных вариантов развертывания: на одном сервере с NGINX/NGINX Plus или на отдельном сервере) содержатся в документации по установке модулей для [NGINX][anchor-mod-inst-nginx] и [NGINX Plus][anchor-mod-inst-nginxplus].