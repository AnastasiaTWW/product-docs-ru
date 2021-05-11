[img-new-local-repo]:                   ../../../../images/integration-guides/repo-mirroring/centos/common/new-local-repo.png
[img-artifactory-repo-settings]:        ../../../../images/integration-guides/repo-mirroring/centos/common/new-local-repo-settings.png
[img-import-into-artifactory]:          ../../../../images/integration-guides/repo-mirroring/centos/common/import-repo-into-artifactory.png
[img-local-repo-ok]:                    ../../../../images/integration-guides/repo-mirroring/centos/common/local-repo-ok.png

[link-jfrog-installation]:              https://www.jfrog.com/confluence/display/RTF/Installing+on+Linux+Solaris+or+Mac+OS
[link-jfrog-comparison-matrix]:         https://www.jfrog.com/confluence/display/RTF/Artifactory+Comparison+Matrix
[link-artifactory-naming-agreement]:    https://jfrog.com/whitepaper/best-practices-structuring-naming-artifactory-repositories/

[doc-installation-from-artifactory]:    how-to-use-mirrored-repo.md

[anchor-fetch-repo]:                    #1-cоздание-локальной-копии-репозитория-валарм
[anchor-setup-repo-artifactory]:        #2-создание-локального-rpmрепозитория-в-jfrog-artifactory
[anchor-import-repo]:                   #3-импортирование-пакетов-валарм-в-jfrog-artifactory


#   Зеркалирование репозитория Валарм для CentOS

Вы можете создать локальную копию (*зеркало*) репозитория Валарм, чтобы быть уверенными, что все WAF‑ноды в вашей инфраструктуре разворачиваются из одного репозитория и имеют одинаковую версию.

Это руководство описывает процесс создания зеркала репозитория Валарм в системе управления артефактами JFrog Artifactory на сервере с операционной системой CentOS 7.

!!! info "Необходимые условия"
    Перед выполнением этой инструкции убедитесь, что выполнены следующие условия:
    
    *   На вашем сервере установлены:
        *   операционная система CentOS 7;
        *   пакеты `yum-utils` и `epel-release`;
        *   версия JFrog Artifactory, которая позволяет создавать RPM‑репозитории ([инструкция по установке][link-jfrog-installation]). 
            
            О различиях версий JFrog Artifactory вы можете узнать по [этой ссылке][link-jfrog-comparison-matrix].
             
    *   JFrog Artifactory запущен и работает.
    *   Ваш сервер имеет доступ в интернет.

Настройка зеркалирования пакетов Валарм состоит из следующих этапов:
1.  [Создание локальной копии репозитория Валарм.][anchor-fetch-repo]
2.  [Создание локального RPM‑репозитория в JFrog Artifactory;][anchor-setup-repo-artifactory]
3.  [Импортирование локальной копии репозитория Валарм в JFrog Artifactory.][anchor-import-repo]

##  1.  Создание локальной копии репозитория Валарм

Для того, чтобы создать локальную копию репозитория Валарм, выполните следующие действия:
1.  Установите репозиторий Валарм, выполнив следующую команду:

    ```bash
    sudo rpm --install https://repo.wallarm.com/centos/wallarm-node/7/2.18/x86_64/Packages/wallarm-node-repo-1-6.el7.noarch.rpm
    ```

2.  Перейдите во временную директорию (например, `/tmp`)  и синхронизируйте репозиторий Валарм с ней. Для этого выполните следующую команду:

    ``` bash
    reposync -r wallarm-node -p .
    ```
    
После успешного выполнения команды `reposync`, пакеты Валарм будут помещены в поддиректорию `wallarm‑node/Packages` рабочей директории (например, `/tmp/wallarm‑node/Packages`).


##  2.  Создание локального RPM‑репозитория в JFrog Artifactory

Чтобы создать локальный RPM‑репозиторий в JFrog Artifactory, выполните следующие действия:
1.  Откройте веб‑интерфейс JFrog Artifactory в браузере, обратившись к нему по доменному имени или IP‑адресу (например, `http://jfrog.example.local:8081/artifactory`).

    Войдите в веб‑интерфейс, используя аккаунт с правами администратора.

2.  Нажмите на раздел *Admin* и затем на ссылку *Local* в секции *Repositories*.

3.  Нажмите на кнопку *New*, чтобы создать новый локальный репозиторий.

    ![!Создание нового локального репозитория][img-new-local-repo]

4.  Выберите тип пакетов «RPM». 

5.  Введите уникальное (в рамках вашего Artifactory) имя репозитория в поле *Repository Key*. Мы рекомендуем вам выбрать имя, которое соответствует [соглашению о наименовании репозиториев Artifactory][link-artifactory-naming-agreement] (например, `wallarm-centos-upload-local`).

    Выберите схему (*layout*) репозитория «maven-2-default» из выпадающего списка *Repository Layout*.
    
    Вы можете оставить все остальные настройки репозитория без изменений.

    Нажмите на кнопку *Save & Finish*, чтобы создать локальный репозиторий.
    
    ![!Параметры репозитория][img-artifactory-repo-settings]
    
    Созданный вами репозиторий появится в списке локальных репозиториев.
    
Чтобы завершить процесс создания зеркала репозитория Валарм, импортируйте [загруженные на предыдущем шаге][anchor-fetch-repo] пакеты в локальный репозиторий.


##  3.  Импортирование пакетов Валарм в JFrog Artifactory

Чтобы импортировать пакеты Валарм в локальный RPM‑репозиторий JFrog Artifactory, выполните следующие действия:
1.  Войдите в JFrog Artifactory под учетной записью администратора.

2.  Нажмите на раздел *Admin* и затем на ссылку *Repositories* в секции *Import & Export*.

3.  В секции *Import Repository from Path* выберите [созданный вами ранее][anchor-setup-repo-artifactory] локальный RPM‑репозиторий из выпадающего списка *Target Local Repository*.

4.  Нажмите на кнопку *Browse*, выберите [созданную ранее][anchor-fetch-repo] директорию с пакетами Валарм.

5.  Нажмите на кнопку *Import*, чтобы импортировать выбранную папку с пакетами.

    ![!Импорт пакетов в локальный репозиторий][img-import-into-artifactory]
    
6.  Нажмите на раздел *Artifacts*. Убедитесь, что пакеты Валарм присутствуют в репозитории, в который вы их импортировали.

    ![!Пакеты в репозитории][img-local-repo-ok]



Теперь вы можете [разворачивать WAF‑ноды Валарм][doc-installation-from-artifactory] из локального зеркала репозитория Валарм.