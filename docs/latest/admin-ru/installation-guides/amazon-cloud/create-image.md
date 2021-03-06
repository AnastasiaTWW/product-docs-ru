[link-docs-aws-autoscaling]:        autoscaling-overview.md
[link-docs-aws-node-setup]:         ../../installation-ami-ru.md
[link-ssh-keys-guide]:              ../../installation-ami-ru.md#2-создание-ssh-ключей
[link-security-group-guide]:        ../../installation-ami-ru.md#3-создание-группы-безопасности
[link-cloud-connect-guide]:         ../../installation-ami-ru.md#6--подключение-wafноды-к-облаку-валарм
[link-docs-reverse-proxy-setup]:    ../../../quickstart-ru/qs-setup-proxy-ru.md
[link-docs-check-operation]:        ../../installation-check-operation-ru.md

[img-launch-ami-wizard]:        ../../../images/installation-ami/auto-scaling/common/create-image/launch-ami-wizard.png 
[img-config-ami-wizard]:        ../../../images/installation-ami/auto-scaling/common/create-image/config-ami-wizard.png  
[img-explore-created-ami]:      ../../../images/installation-ami/auto-scaling/common/create-image/explore-ami.png

[anchor-node]:  #1-создание-и-настройка-экземпляра-wafноды
[anchor-ami]:   #2-создание-образа-виртуальной-машины

#   Создание образа AMI с WAF‑нодой Валарм

Этот документ описывает, как подготовить образ виртуальной машины Amazon (Amazon Machine Image, AMI) с WAF‑нодой. Такой образ будет необходим вам при настройке автоматического масштабирования WAF‑нод. Подробнее о настройке масштабирования вы можете прочитать [здесь][link-docs-aws-autoscaling].

Чтобы создать образ AMI с WAF‑нодой Валарм, необходимо выполнить следующие шаги:
1.  [Создание и настройка экземпляра WAF‑ноды в облаке Amazon][anchor-node].
2.  [Создание образа виртуальной машины на основе настроенного экземпляра WAF‑ноды][anchor-ami].


##  1.  Создание и настройка экземпляра WAF‑ноды

Перед созданием AMI вам необходимо выполнить начальную настройку единичной WAF‑ноды Валарм. Для этого:
1.  [Создайте][link-docs-aws-node-setup] экземпляр WAF‑ноды в облаке Amazon.
    
    !!! warning "Приватный SSH-ключ"
        Убедитесь, что вы имеете доступ к приватному ключу в формате PEM, который вы [создавали][link-ssh-keys-guide] для подключения к вашему WAF‑ноде с использованием протокола SSH.
    
    !!! warning "Обеспечьте доступ к Валарм API"
        Для корректной работы WAF‑ноды ей требуется доступ к API-серверам Валарм. Адрес зависит от облака, которое вы используете:
        
        * `https://api.wallarm.com:444` для EU‑облака
        * `https://api.wallarm.ru:444` для RU‑облака
    
        Убедитесь, что при развертывании WAF‑ноды вы выбрали необходимые VPC и подсети, а также [настроили][link-security-group-guide] группу безопасности (security group) таким образом, чтобы у WAF‑ноды был доступ к серверам Валарм.

2.  [Подключите][link-cloud-connect-guide] WAF‑ноду к облаку Валарм.

    !!! warning "Используйте токен для подключения к облаку Валарм"
        Обратите внимание, что необходимо использовать вариант подключения с использованием токена. Это позволит нескольким WAF‑нодам подключаться к облаку Валарм с помощью одного и того же токена.
        
        Таким образом, при масштабировании WAF‑нод не потребуется подключать к облаку Валарм каждую отдельную WAF‑ноду вручную. 

3.  [Настройте][link-docs-reverse-proxy-setup] WAF‑ноду так, чтобы она выступала в качестве обратного прокси (reverse proxy) для вашего веб‑приложения.

4.  [Убедитесь][link-docs-check-operation], что WAF‑нода настроена правильно и защищает ваше веб‑приложение от атак.

Когда вы завершите настройку, выключите виртуальную машину с WAF‑нодой, выполнив следующие действия:
1.  Перейдите на вкладку *Instances* в дашборде Amazon EC2.
2.  Выберите ваш настроенный экземпляр WAF‑ноды.
3.  Выберите в выпадающем меню *Actions* пункт «Instance State», а затем — пункт «Stop».

!!! info "Выключение с помощью команды `poweroff`"
    Вы также можете выключить виртуальную машину, подключившись к ней с использованием протокола SSH и выполнив следующую команду:
 	
 	``` bash
   	poweroff
 	```


##  2.  Создание образа виртуальной машины

Теперь вы можете приступить к созданию образа виртуальной машины на основе настроенного экземпляра WAF‑ноды. Выполните следующие действия:
1.  Перейдите на вкладку *Instances* в дашборде Amazon EC2.
2.  Выберите ваш настроенный экземпляр WAF‑ноды.
3.  Запустите мастер создания образа, выбрав в выпадающем меню *Actions* пункт «Image», а затем — пункт «Create Image».

    ![!Запуск мастера создания AMI][img-launch-ami-wizard]
    
4.  В появившемся всплывающем окне введите имя создаваемого образа. Все прочие параметры можно оставить без изменений.

    ![!Настройка параметров в мастере создания AMI][img-config-ami-wizard]
    
5.  Нажмите на кнопку *Create Image* для запуска процесса создания образа виртуальной машины.

    Когда процесс создания образа завершится, будет выведено соответствующее сообщение. Перейдите на вкладку *AMIs* в дашборде Amazon EC2, чтобы убедиться, что образ успешно создан и находится в статусе «доступен» («Available»).
    
    ![!Просмотр созданного AMI][img-explore-created-ami]

!!! info "Видимость образа"
    Поскольку подготовленный образ содержит настройки, специфичные для вашего приложения, и токен Валарм, не рекомендуется изменять настройку видимости образа (*Visibility*) и делать его публичным (по умолчанию AMI создается с настройкой видимости «Private»).

Теперь вы можете [выполнить настройку][link-docs-aws-autoscaling] автоматического масштабирования WAF‑нод Валарм в облаке Amazon, используя подготовленный образ.