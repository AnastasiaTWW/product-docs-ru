# Установка WAF‑ноды с использованием Terraform

Terraform — инструмент для описания инфраструктуры приложения в конфигурационных файлах и для запуска приложения на основе этих файлов. Более подробная информация о Terraform доступна в [официальной документации](https://www.terraform.io/intro/index.html).

Используя Terraform, вы также можете развернуть WAF‑ноду. В данной инструкции приведен [пример кода Terraform](https://github.com/wallarm/terraform-example) для установки WAF‑ноды в публичное облако AWS. В данном примере WAF‑нода настраивается для защиты сайта на Wordpress. Код разворачивает необходимый набор ресурсов AWS: VPC, subnets, route tables, security groups, публичные ключи SSH и другие ресурсы, в том числе сервис Wordpress.

!!! info "Рекомендуемые статьи для более полного понимания кода Terraform"
    * [Managing auto scaling groups and load balancers](https://hands-on.cloud/terraform-recipe-managing-auto-scaling-groups-and-load-balancers/)
    * [Cloud config examples](https://cloudinit.readthedocs.io/en/latest/topics/examples.html) 

## Используемые ресурсы

В примере используются следующие ресурсы:

* Официальный [Wallarm WAF Node AMI](https://aws.amazon.com/marketplace/server/procurement?productId=34faafd7-601d-43ac-8d22-3f2d839028c5), доступный в AWS Marketplace.
* AWS Autoscaling Group (ASG) для автоматической настройки ресурсов для кластера в зависимости от нагрузки WAF‑ноды на ЦП.
* Метрики и уведомления AWS CloudWatch для мониторинга нагрузки активной WAF‑ноды на ЦП.
* Балансировщик нагрузки AWS NLB для мониторинга доступности WAF‑ноды и распределения запросов между доступными экземплярами.

Вы можете использовать описанный подход как для официального Wallarm WAF Node AMI, так и для созданного образа AMI с WAF‑нодой.

## Развернутая инфраструктура

Приведенный пример кода разворачивает следующую инфраструктуру:

* Новый VPC с названием `tf-wallarm-demo` и необходимые ресурсы: subnets, route tables, Internet Gateway.
* ASG, управляющий кластером WAF‑нод. ASG использует опцию UserData для автоматической установки новых WAF‑нод. Процесс установки соответствует [ручному способу](../../../installation-ami-ru.md) настройки WAF‑ноды.
* Экземпляр NLB, который принимает запросы на порт 80/TCP и 443/TCP и передает их на WAF‑ноды. NLB не завершает SSL‑соединение, если его завершает WAF‑нода.
* ASG, запускающий приложение Wordpress, и соответствующий экземпляр ELB. WAF‑ноды автоматически настраиваются для проксирования входящего трафика на DNS экземпляра Wordpress ELB.
