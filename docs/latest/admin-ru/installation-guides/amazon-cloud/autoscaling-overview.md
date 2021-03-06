[link-doc-aws-as]:          https://docs.aws.amazon.com/autoscaling/plans/userguide/what-is-aws-auto-scaling.html
[link-doc-ec2-as]:          https://docs.aws.amazon.com/autoscaling/ec2/userguide/GettingStartedTutorial.html
[link-doc-as-faq]:          https://aws.amazon.com/autoscaling/faqs/

[link-doc-ami-creation]:    create-image.md
[link-doc-asg-guide]:       autoscaling-group-guide.md
[link-doc-lb-guide]:        load-balancing-guide.md


# Введение в автоматическое масштабирование WAF‑ноды в AWS

В облаке Amazon вы можете настроить автоматическое масштабирование WAF‑нод Валарм в условиях неравномерной нагрузки. В частности, внедрение такого масштабирования позволит обрабатывать входящий трафик к приложению с помощью WAF‑нод даже при существенном увеличении объема трафика.

Облако Amazon поддерживает два механизма автоматического масштабирования:
*   AWS Autoscaling:
    Новая технология автоматического масштабирования, базируется на метриках, собираемых AWS.
    
    При необходимости вы можете воспользоваться [документацией][link-doc-aws-as] по AWS Autoscaling;

*   EC2 Autoscaling:
    Legacy-технология автоматического масштабирования, позволяет задавать собственные переменные для определения правил масштабирования.
    
    При необходимости вы можете воспользоваться [документацией][link-doc-ec2-as] по EC2 Autoscaling.
    
!!! info "Информация по механизмам масштабирования"
    Подробный FAQ от Amazon по механизмам масштабирования доступен [по ссылке][link-doc-as-faq].

В этом руководстве описывается использование EC2 Autoscaling, однако, при необходимости вы можете использовать и AWS Autoscaling.

!!! warning "Необходимые условия"
    Для настройки автоматического масштабирования вам потребуется образ виртуальной машины (Amazon Machine Image, AMI) с WAF‑нодой Валарм.
    
    Подробная информация о процессе создания AMI с WAF‑нодой Валарм доступна по [ссылке][link-doc-ami-creation].

!!! warning "Доступ к приватному SSH-ключу"
    Убедитесь, что вы имеете доступ к приватному ключу в формате PEM, который используется для подключения к созданной WAF‑ноде с использованием протокола SSH.

Чтобы настроить автоматическое масштабирование WAF‑нод в облаке Amazon, необходимо выполнить следующие шаги:
1.  [Настройка автоматического масштабирования WAF‑нод:][link-doc-asg-guide]
    1.  Создание запускаемого шаблона (Launch Template);
    2.  Создание группы автоматического масштабирования (Autoscaling Group);
2.  [Настройка балансировки входящих соединений:][link-doc-lb-guide]
    1.  Создание балансировщика нагрузки (Load Balancer);
    2.  Настройка группы автоматического масштабирования для использования созданного балансировщика.