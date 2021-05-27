
[link-nginx-website]:   https://www.nginx.com/free-trial-request/
[link-docker-website]:  https://www.docker.com/
[link-docker-docs]:     https://docs.docker.com/
[link-git-website]:     https://git-scm.com/
[link-git-docs]:        https://git-scm.com/doc
[link-gnu-website]:     https://www.gnu.org/software/make/
[link-gnu-docs]:        https://www.gnu.org/software/make/manual/
[link-docker-hub]:      https://hub.docker.com/
[link-google-cr]:       https://cloud.google.com/container-registry/
[link-ms-azure-cr]:     https://azure.microsoft.com/ru-ru/services/container-registry/
[link-local-docker]:    https://docs.docker.com/registry/deploying/
[link-docker-security]: https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface
[link-acr-docs]:        https://docs.microsoft.com/ru-ru/azure/container-registry/container-registry-authentication
[link-gcloud-docs]:     https://cloud.google.com/container-registry/docs/quickstart
[link-ingress-github]:  https://github.com/wallarm/ingress-plus/
    
[anchor1]:  #настройка-окружения-для-сборки
[anchor2]:  #запуск-процесса-сборки
[anchor3]:  #имена-реестров-docker
    
[link-next-chapter]:        deploy.md
[link-previous-chapter]:    introduction.md
    
    
    
    
#   Сборка Ingress‑контроллера Валарм NGINX Plus

!!! info "Соглашение о терминах"
    В этом документе используются следующие русскоязычные эквиваленты английских терминов:

    *   реестр Docker — Docker registry,
    *   репозиторий Docker — Docker repository.
    

    
!!! info
    Перед началом процесса сборки убедитесь, что у вас имеется лицензия на использование NGINX Plus. При необходимости вы можете получить пробную лицензию на [сайте NGINX][link-nginx-website]. Лицензия NGINX Plus представлена двумя файлами:
    
    *   файл ключа `nginx-repo.key`,
    *   файл сертификата `nginx-repo.crt`.

Для сборки NGINX Plus с сервисами Валарм выполните следующие действия:
1.  [Настройте окружение для сборки.][anchor1]
2.  [Запустите процесс сборки][anchor2].

!!! info
    Данное руководство предполагает, что вы выполняете сборку в операционной системе семейства Linux.

##  Настройка окружения для сборки
Убедитесь, что у вас установлены необходимые инструменты:
*   [Docker][link-docker-website] ([официальная документация][link-docker-docs]),
*   [Git][link-git-website] ([официальная документация][link-git-docs]),
*   [GNU Make][link-gnu-website] ([официальная документация][link-gnu-docs]).

Также вам потребуется приватный репозиторий Docker.

Сервисы по предоставлению доступа к репозиториям образов Docker и управлению ими предоставляются реестрами Docker. 

Если у вас нет существующего реестра Docker, создайте его. Вы можете использовать ваш собственный реестр Docker или воспользоваться сервисами, предоставляющими возможность хостинга приватных образов Docker (например, [Docker Hub][link-docker-hub], [Google Container Registry][link-google-cr], [Microsoft Azure Container Registry][link-ms-azure-cr]).
    
!!! info
    Информация по созданию локального реестра Docker доступна по [ссылке][link-local-docker].

    
!!! warning
    Настоятельно не рекомендуется размещать сборку Ingress‑контроллера Валарм NGINX Plus, содержащую в себе лицензионные ключи, в публичном репозитории Docker, который доступен всем желающим.

    
!!! info
    Для целей данного руководства будет достаточно доступа к реестру Docker Hub, который предоставляет для пользователя один бесплатный приватный репозиторий.
    
Вам потребуется следующая информация: 
*   логин и пароль для доступа к реестру Docker,
*   имя реестра Docker,
*   путь для доступа к репозиторию.

!!! info "Имена реестров Docker"
    В зависимости от выбранного поставщика услуг, имя для доступа к реестру и путь к репозиторию может быть разным. Уточняйте данную информацию в соответствующей документации от вашего поставщика услуг.
    
    Реестры Docker, Microsoft и Google имеют следующие известные имена реестров:

    *   `docker.io` для Docker Hub,
    *   `gcr.io` для Google Container Registry,
    *   `<имя вашего реестра>.azurecr.io` для Microsoft Azure Container Registry.
    
    Путь для доступа к репозиторию содержит в себе имя реестра Docker.
    Например, для Docker Hub путь для доступа к репозиторию `example-repository`, созданного пользователем `user`, будет иметь следующий вид:
    
    `docker.io/user/example-repository`

##  Запуск процесса сборки:
1.  Войдите в ваш реестр Docker, выполнив следующую команду:
    
    ```
    docker login <имя реестра Docker>
    ```
    
    Далее вам будет необходимо ввести логин и пароль для доступа к реестру.
    
    !!! info "Пример"
        Для входа в реестр Docker Hub выполните следующую команду:
        
        ```
        docker login docker.io
        ```
        
    !!! warning
        В зависимости от настроек, для выполнения команды `docker` может потребоваться повышение прав с помощью команды `sudo` или выполнение команды пользователем `root`.
        
        Вы также можете настроить возможность выполнения команды `docker` текущим пользователем с помощью добавления пользователя в группу `docker`. Однако необходимо помнить, что членство в данной группе дает права, эквивалентные правам пользователя `root`, что может потенциально привести к проблемам, связанным с безопасностью. Подробную информацию можно получить по [ссылке][link-docker-security]. 
        
    !!! info
        Некоторые поставщики услуг также предоставляют свои инструменты для работы с реестрами Docker, например, [`az acr`][link-acr-docs] для Microsoft Azure Container Registry или [`gcloud`][link-gcloud-docs] для Google Container Registry. Вы можете использовать данные команды вместо `docker`&nbsp;`login` для входа в соответствующие реестры. Для получения более подробной информации обратитесь к документации вашего поставщика услуг.
    
2.  Склонируйте репозиторий Валарм NGINX Plus Ingress, выполнив следующую команду:
    
    ```
    git clone https://github.com/wallarm/ingress-plus/
    ```
    
3.  Перейдите в директорию `ingress-plus/`, выполнив следующую команду:
    
    ```
    cd ingress-plus/
    ```
    
4.  Скопируйте в текущую директорию ключ и сертификат NGINX Plus. Если у вас нет этих файлов, получите лицензию на использование NGINX Plus. Для копирования вы можете воспользоваться утилитой `scp` или иным инструментом.
    
    Убедитесь, что текущая директория содержит необходимые файлы, выполнив команду:
    ```
    ls nginx-repo.*
    ```

    Вы должны получить следующий вывод:
    
    ```
    nginx-repo.crt nginx-repo.key
    ```
    
5.  Запустите процесс сборки, последовательно выполнив следующие команды:
    
    ```
    make clean
    make DOCKERFILE=DockerfileForPlus PREFIX=<имя для доступа к вашему репозиторию Docker>
    ```
    
    Обратите внимание, что в качестве аргумента `PREFIX` команде `make` необходимо предоставить путь для доступа к вашему репозиторию, в который необходимо опубликовать итоговый образ Docker для Валарм NGINX Plus.
    
    !!! info "Пример"
        Для того, чтобы опубликовать образ для пользователя `user` в приватном репозитории `example-repository`, который предоставляется реестром Docker Hub, используйте следующую команду:
        ```
        make DOCKERFILE=DockerfileForPlus PREFIX=docker.io/user/example-repository
        ```

По завершению процесса сборки вы можете приступать к [развертыванию Ingress‑контроллера][link-next-chapter].
