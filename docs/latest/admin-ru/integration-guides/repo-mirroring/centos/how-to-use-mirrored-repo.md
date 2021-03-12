[img-working-with-repo]:        ../../../../images/integration-guides/repo-mirroring/centos/common/working-with-repo.png
[img-repo-creds]:               ../../../../images/integration-guides/repo-mirroring/centos/common/repo-creds.png
[img-repo-code-snippet]:        ../../../../images/integration-guides/repo-mirroring/centos/common/repo-code-snippet.png

[doc-repo-mirroring]:           how-to-mirror-repo-artifactory.md
[doc-install-nginx]:            ../../../installation-nginx-overview.md
[doc-install-kong]:             ../../../installation-kong-ru.md
[doc-install-postanalytics]:    ../../../installation-postanalytics-ru.md


#   Установка пакетов Валарм из репозитория JFrog Artifactory для CentOS

Чтобы установить пакеты Валарм из [репозитория JFrog Artifactory][doc-repo-mirroring] на хост, предназначенный для WAF‑ноды, выполните следующие действия на этом хосте:
1.  Откройте веб‑интерфейс JFrog Artifactory в браузере, обратившись к нему по доменному имени или IP‑адресу (например, `http://jfrog.example.local:8081/artifactory`).

    Войдите в веб‑интерфейс, используя аккаунт с правами пользователя.
 
2.  Нажмите на раздел *Artifacts* и выберите репозиторий с пакетами Валарм.  

3.  Нажмите на ссылку *Set Me Up*.

    ![!Работа с репозиторием][img-working-with-repo]
    
    В появившемся окне введите пароль от своей учетной записи пользователя в поле *Type Password* и нажмите Enter. Теперь инструкции в этом окне будут содержать ваши данные для авторизации.
    
    ![!Ввод данных для авторизации][img-repo-creds]
    
4.  Прокрутите окно в веб‑интерфейсе JFrog Artifactory вниз до примера файла конфигурации `yum` с репозиторием Artifactory и нажмите на кнопку *Copy snippet to clipboard*, чтобы скопировать пример конфигурации в буфер обмена.    

    ![!Пример конфигурации][img-repo-code-snippet]
    
5.  Создайте файл конфигурации `yum` (например, `/etc/yum.repos.d/artifactory.repo`) с приведенным примером конфигурации.

    !!! warning "Важно!"
        Удалите последнюю часть пути `<PATH_TO_REPODATA_FOLDER>` из значения параметра `baseurl`, чтобы путь указывал на корневую директорию репозитория.
    
    Например, файл `/etc/yum.repos.d/artifactory.repo` для текущего примера будет содержать следующие строки:

    ```
    [Artifactory]
    name=Artifactory
    baseurl=http://user:password@jfrog.example.local:8081/artifactory/wallarm-centos-upload-local/
    enabled=1
    gpgcheck=0
    #Optional - if you have GPG signing keys installed, use the below flags to verify the repository metadata signature:
    #gpgkey=http://user:password@jfrog.example.local:8081/artifactory/wallarm-centos-upload-local/<PATH_TO_REPODATA_FOLDER>/repomd.xml.key
    #repo_gpgcheck=1
    ```
    
6.  Установите пакет `epel-release`:

    ``` bash
    sudo yum install epel-release
    ```
    
Теперь вы можете следовать инструкции, соответствующей желаемому типу установки WAF‑ноды. При установке вам необходимо пропустить шаг с добавлением репозиториев Валарм, так как вы уже настроили локальный репозиторий с пакетами Валарм.
