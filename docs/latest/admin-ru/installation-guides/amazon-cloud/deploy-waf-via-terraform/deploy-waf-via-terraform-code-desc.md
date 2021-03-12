# Описание примера кода Terraform

Ниже приведено описание частей кода для [запуска](#настройка-запуска-wafноды) и [автомасштабирования](#настройка-автомасштабирования-wafноды) WAF‑ноды. Остальная часть кода описывает сервис Wordpress.

## Настройка запуска WAF‑ноды

Настройки запуска описаны в файле `main.tf` в объекте `wallarm_launch_config`. В приведенном примере выполняются следующие действия с WAF‑нодой:

1. Создание файла `/etc/nginx/conf.d/wallarm-acl.conf` с настройками [блокировки по IP](../../../configure-ip-blocking-nginx-ru.md).
2. Создание файлов `/etc/nginx/key.pem` и `/etc/nginx/cert.pem` с самоподписанным сертификатом SSL и приватным ключом. Для использования в боевой среде необходимо заменить данные реальными значениями.
3. Создание файла `/etc/nginx/sites-available/default` с настройкой ресурсов, которые защищены WAF‑нодой. В приведенном примере файл содержит следующие настройки:

    * блоки с конфигурацией HTTP и HTTPS в качестве прокси‑серверов для всех входящих запросов;
    * блок `/healthcheck` с описанием конечной точки для проверки работоспособности сервиса: всегда возвращает HTTP‑статус 200;
    * проксирование всех входящих HTTP и HTTPS запросов на DNS экземпляра ELB Wordpress, который описан в переменной `${aws_elb.wp_elb.dns_name}`.

4. Запуск набора команд, описанных в блоке `runcmd`, для настройки WAF‑ноды:

    * создание новой WAF‑ноды в облаке Валарм;
    * добавление новых строк в файлы `/etc/wallarm/node.yaml` и `/etc/cron.d/wallarm-node-nginx` для [блокировки по IP](../../../configure-ip-blocking-nginx-ru.md);
    * тестирование конфигурации и запуск экземпляра NGINX.

## Настройка автомасштабирования WAF‑ноды

Настройки автомасштабирования описаны в следующем объекте файла `main.tf`:

```
resource "aws_autoscaling_group" "wallarm_waf_asg" {
  lifecycle { create_before_destroy = true }

  name                 = "tf-wallarm-demo-waf-asg-${aws_launch_configuration.wallarm_launch_config.name}"
  launch_configuration = "${aws_launch_configuration.wallarm_launch_config.name}"
  min_size             = "2"
  max_size             = "5"
  min_elb_capacity     = "2"
  availability_zones   = [var.az_a]
  vpc_zone_identifier  = ["${aws_subnet.public_a.id}"]
  target_group_arns = [ "${aws_lb_target_group.wallarm_asg_target_http.arn}", "${aws_lb_target_group.wallarm_asg_target_https.arn}"
  ]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"

  tag {
      key                 = "Name"
      value               = "tf-wallarm-demo-waf-node"
      propagate_at_launch = true
    }
}
```

* Для автомасштабирования ресурсов ASG в зависимости от нагрузки на ЦП, требуются включенные метрики CloudWatch (параметр `enabled_metrics`). Если вы используете фиксированное количество WAF‑нод, эта часть может быть опущена.
* Объекты `wallarm_policy_up`, `wallarm_policy_down` и соответствующие метрики CloudWatch определяют пороговые значения и периоды использования ЦП при автомасштабировании ресурсов ASG.
* Объект `lifecycle { create_before_destroy = true }` определяет порядок действий при изменении конфигурации кластера WAF. В приведенном примере Terraform создает новый набор Launch Configuration и объектов ASG; проверяет, что новые WAF‑ноды определены соответствующим балансировщиком нагрузки как доступные по показателю `min_elb_capacity`; удаляет предыдущие набор Launch Configuration и ресурсы ASG. Подход гарантирует, что запуск новой конфигурации WAF‑ноды не прервет поток трафика.
