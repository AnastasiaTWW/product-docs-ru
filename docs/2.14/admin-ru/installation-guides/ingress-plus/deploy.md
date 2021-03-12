    
[link-kubernetes-docs-rbac]:            https://kubernetes.io/docs/reference/access-authn-authz/rbac/
[link-helm-website]:                    https://helm.sh/
[link-helm-docs]:                       https://docs.helm.sh/
[link-git-website]:                     https://git-scm.com/
[link-git-docs]:                        https://git-scm.com/doc
[link-kubectl-website]:                 https://kubernetes.io/docs/reference/kubectl/overview/
[link-kubectl-docs]:                    https://kubernetes.io/docs/tasks/tools/install-kubectl/
[link-configure-kubectl-kubernetes]:    https://kubernetes.io/docs/tasks/tools/install-kubectl/#configure-kubectl
[link-configure-kubectl-ms]:            https://docs.microsoft.com/ru-ru/azure/aks/kubernetes-walkthrough#connect-to-the-cluster
[link-configure-kubectl-google]:        https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl
[link-open-ssl-website]:                https://www.openssl.org/
[link-ssl-helm-tiller]:                 https://docs.helm.sh/using_helm/#using-ssl-between-helm-and-tiller
[link-kubernetes-docs-secret]:          https://kubernetes.io/docs/concepts/configuration/secret/
[link-wallarm-website]:                 https://my.wallarm.com/
[link-wallarm-website-ru]:              https://my.wallarm.ru/
[link-wallarm-signup]:                  https://my.wallarm.com/signup
[link-wallarm-signup-ru]:               https://my.wallarm.ru/signup
[link-helm-chart-configuration-docs]:   https://github.com/nginxinc/kubernetes-ingress/tree/master/deployments/helm-chart#configuration
[link-kubernetes-secrets-docs]:         https://kubernetes.github.io/ingress-nginx/user-guide/tls/

    
[anchor1]:  #1-настройка-окружения-для-развертывания
[anchor2]:  #2-настройка-конфигурации-ingress-контроллера
[anchor3]:  #3-развертывание-ingressконтроллера
[anchor4]:  #1-настройка-kubectl-для-работы-с-кластером-kubernetes
[anchor5]:  #2-настройка-helm-для-работы-с-кластером-kubernetes
[anchor6]:  #3-создание-секрета-kubernetes-для-доступа-к-реестру-docker
[anchor7]:  #4-получение-токена-для-привязки-ingressконтроллера-к-облаку-wallarm
    
[link-next-chapter]:        resource-creation.md
[link-previous-chapter]:    assembly.md

#   Развертывание Ingress‑контроллера Валарм NGINX Plus

!!! info "Соглашение о терминах"
    В этом документе используются следующие русскоязычные эквиваленты английских терминов:

    * реестр Docker — Docker registry,
    * репозиторий Docker — Docker repository.
    * под Kubernetes — Kubernetes pod,
    * ресурс Ingress  — Ingress resource.
    
--8<-- "../include/ingress-k8s-limitations.md"

Теперь, когда в вашем приватном репозитории есть собранный образ Ingress‑контроллера Валарм NGINX Plus, вы можете развернуть его в вашем кластере Kubernetes.

Чтобы развернуть Ingress‑контроллер Валарм NGINX Plus, выполните следующие действия:
1.  [Настройте окружение для развертывания.][anchor1]
2.  [Настройте конфигурацию Ingress‑контроллера.][anchor2]
3.  [Разверните Ingress‑контроллер.][anchor3]

    
!!! info "Поддержка RBAC"
    Если в вашем кластере Kubernetes включено управление доступом на основе ролей (Role-Based Access Control, RBAC) вам будет необходимо выполнить дополнительные шаги по настройке. В данном руководстве вам будут предложены базовые варианты настроек для кластеров с включенным и выключенным RBAC. 
    
    Если у вас присутствует особая конфигурация RBAC или вам необходима дополнительная информация об управлении доступом к кластеру на основе ролей, обратитесь к [официальной документации][link-kubernetes-docs-rbac] Kubernetes или документации вашего поставщика услуг, если вы используете кластер Kubernetes от поставщиков облачных услуг.   

##  1.  Настройка окружения для развертывания

Для настройки окружения выполните следующие действия:
1.   [Настройте Kubectl для работы с вашим кластером Kubernetes.][anchor4]
2.   [Настройте Helm для работы с вашим кластером Kubernetes.][anchor5]
3.   [Создайте секрет Kubernetes для доступа к вашему реестру Docker.][anchor6]
4.   [Получите токен для привязки Ingress‑контроллера к облаку Валарм.][anchor7]

Убедитесь, что у вас установлены следующие инструменты:
*   [Helm][link-helm-website] ([официальная документация][link-helm-docs]),
*   [Git][link-git-website] ([официальная документация][link-git-docs]),
*   [Kubectl][link-kubectl-website] ([официальная документация][link-kubectl-docs]). 

### 1.  Настройка Kubectl для работы с кластером Kubernetes

Общая информация по настройке доступна по [ссылке][link-configure-kubectl-kubernetes].

Если вы используете кластер Kubernetes от поставщиков облачных услуг, обратитесь к соответствующей документации от поставщика услуг (например, документация [Microsoft][link-configure-kubectl-ms], [Google][link-configure-kubectl-google]). 

После настройки Kubectl убедитесь в его работоспособности, выполнив команду:

```
kubectl get nodes
```

Вывод команды должен содержать в себе все WAF‑ноды вашего Kubernetes-кластера.

!!! info "Пример"
    ```
    kubectl get nodes
    NAME                                             STATUS    ROLES     AGE       VERSION
    gke-ingress-scratch-default-pool-a3fd18a6-smfn   Ready     <none>    3d        v1.11.3-gke.18
    ```

### 2.  Настройка Helm для работы с кластером Kubernetes

!!! info
    Helm представлен двумя компонентами:

    *   Клиентская часть Helm, которая передает команды серверу Tiller.
    *   Серверная часть Tiller, которая непосредственно инсталлируется в ваш кластер и обеспечивает развертывание приложений с помощью Helm Charts.
    
    По умолчанию коммуникация между клиентской и серверной частью происходит по открытому каналу. Вы можете добавить SSL‑шифрование для большей безопасности. Для этого вам потребуется [OpenSSL][link-open-ssl-website]. Подробная информация о защите Helm и Tiller доступна по [ссылке][link-ssl-helm-tiller]. 

Настройка Helm выполняется по-разному в зависимости от того, включен ли механизм RBAC в вашем кластере Kubernetes. 

Для кластера с выключенным RBAC выполните команду `helm init`.

Для кластера c включенным RBAC:
1.  Убедитесь, что Kubectl работает в контексте с необходимыми правами (у пользователя, с правами которого запущен Kubectl, должна быть корректно настроенная роль `cluster‑admin`).
    
    !!! info
        Некоторые провайдеры кластеров Kubernetes создают и привязывают такую роль при инициализации Kubectl (например, Microsoft), некоторые этого не делают и привязку роли приходится создавать вручную, как, например, в Google Kubernetes Engine:
        ```
        kubectl create clusterrolebinding user-admin-binding --clusterrole=cluster-admin --user=$(gcloud config get-value account)  
        ```
        Для получения более подробной информации обратитесь к документации вашего поставщика услуг.

2.  Создайте текстовый YAML-файл `helm-rbac.yaml` со следующим содержимым:
    ```
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: tiller-account
      namespace: kube-system
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: tiller-admin-binding
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cluster-admin
    subjects:
      - kind: ServiceAccount
        name: tiller-account
        namespace: kube-system
    ```
    
    В данном файле задается сервисный аккаунт `tiller-account` с ролью `cluster‑admin`.
    
3.  Примените настройки из файла `helm-rbac.yaml`, выполнив следующую команду:
    
    ```
    kubectl apply -f helm-rbac.yaml
    ```
    
    Вы должны получить следующий вывод:
    ```
    serviceaccount "tiller-account" created
    clusterrolebinding.rbac.authorization.k8s.io "tiller-admin-binding" created
    ```
    
4.  Для инициализации Tiller с правами созданного сервисного аккаунта с именем `tiller-account`, выполните следующую команду:

    ```
    helm init --service-account=tiller-account
    ```

В случае успешного выполнения команды `helm init`, вывод команды будет выглядеть похожим образом:

```
Tiller (the Helm server-side component) has been installed into your Kubernetes Cluster.

Please note: by default, Tiller is deployed with an insecure 'allow unauthenticated users' policy.
To prevent this, run `helm init` with the --tiller-tls-verify flag.
For more information on securing your installation see: https://docs.helm.sh/using_helm/#securing-your-helm-installation
Happy Helming!
```

Проверьте работоспособность Helm и Tiller, выполнив команду `helm ls --all`. Команда должна выполниться без ошибок и предоставить либо пустой вывод, либо вывод, содержащий список всех развернутых в кластере Helm Charts.

### 3.  Создание секрета Kubernetes для доступа к реестру Docker

Для того, чтобы при установке Helm Chart иметь возможность загрузить образ Ingress‑контроллера Валарм NGINX Plus из приватного репозитория Docker, необходимо задать *секрет Kubernetes* для доступа к необходимому реестру Docker (Docker registry). 

Данный секрет представляет собой комбинацию имени реестра Docker и учетных данных для доступа к нему (логин и пароль для реестра Docker).

Для создания секрета Kubernetes выполните следующую команду:

```
kubectl create secret docker-registry <имя секрета> --docker-server=<FQDN или IP‑адрес реестра Docker> --docker-username=<логин для реестра Docker> --docker-password=<пароль для реестра Docker>
```

Вам необходимо предоставить следующие значения:
*   имя секрета, 
*   имя реестра Docker для параметра `--docker-server`,
*   логин для доступа к реестру для параметра `--docker-username`,
*   пароль для доступа к реестру для параметра `--docker-password`.

!!! info "Пример команды"
    Чтобы создать секрет `my-secret`, обеспечивающий доступ к реестру Docker Hub для пользователя `example‑user` с паролем `pAssw0rd`, необходимо выполнить следующую команду:
    ```
    kubectl create secret docker-registry my-secret --docker-server=https://index.docker.io/v1/ --docker-username=example-user --docker-password=pAssw0rd
    ```
    
!!! info
    Значение параметра `--docker-server` задается для различных реестров Docker по-разному. Уточняйте необходимое значение параметра у вашего поставщика услуг.
    
!!! info "Конфигурация секретов Kubernetes"
    Более подробная информация доступна по [ссылке][link-kubernetes-docs-secret].

### 4.  Получение токена для привязки Ingress‑контроллера к облаку Валарм

Ingress‑контроллер в процессе работы взаимодействует с облаком Валарм.

Привязка Ingress‑контроллера Валарм NGINX Plus к облаку осуществляется с помощью токена. Для получения токена выполните следующие действия:
1.  Войдите на портал Валарм по ссылке для [EU‑облака][link-wallarm-website] или [RU‑облака][link-wallarm-website-ru], используя вашу учетную запись Валарм. Если у вас нет учетной записи, создайте её и получите пробную лицензию сроком на 14 дней, пройдя по ссылке для [EU‑облака][link-wallarm-signup] или [RU‑облака][link-wallarm-signup-ru].
2.  Перейдите во вкладку *Nodes* и нажмите на кнопку *Create new node*. 
3.  Введите желаемое имя WAF‑ноды (это ваша инсталляция Ingress‑контроллера) и выберите вариант установки «Cloud» из выпадающего списка «Type of installation».
4.  Нажмите на кнопку *Create*.
5.  Скопируйте значение токена из появившегося всплывающего окна.

##  2.  Настройка конфигурации Ingress‑контроллера

Выполните следующие действия:
1.  Если вы еще не выполнили клонирование репозитория с Ingress‑контроллером Валарм NGINX Plus, то клонируйте его, выполнив следующую команду:
    
    ```
    git clone https://github.com/wallarm/ingress-plus/
    ```
    
2.  Перейдите в директорию `ingress-plus/deployments/helm-chart/`, выполнив следующую команду:
    
    ```
    cd ingress-plus/deployments/helm-chart/
    ```
    
3.  Файл `values-plus.yaml` содержит в себе шаблон файла конфигурации для развертывания Ingress‑контроллера Валарм NGINX Plus с помощью Helm Chart.
    
    Скопируйте этот шаблон в файл с именем `wl-ingress-plus.yaml` (вы можете выбрать любое имя файла) и откройте его для редактирования (например, с помощью текстового редактора Nano):
    
    ```
    cp values-plus.yaml wl-ingress-plus.yaml 
    nano wl-ingress-plus.yaml
    ```
    
4.  Внесите необходимые изменения в содержимое файла:
    1.  Задайте в качестве значения параметра `controller.image.repository` путь к вашему репозиторию Docker, содержащему собранный образ Docker для Ingress‑контроллера Валарм NGINX Plus. Также убедитесь, что версия образа Docker (или тег) совпадает со значением параметра `controller.image.tag`:
        
        ```
        controller:
        ...часть файла намеренно опущена...
          image:
            repository: <путь к репозиторию Docker>
            tag: "<версия сборки Ingress‑контроллера>"
        ...часть файла намеренно опущена...
        ```
        
        !!! info "Пример"
            Следующие параметры задают путь к репозиторию Docker `example.com/example-repository` и тег `1.3.2`:
            ```
            image:
              repository: example.com/example-repository
              tag: "1.3.2"
            ```
    
    2.  Задайте `true` в качестве значения параметра `controller.wallarm.enabled`:
    
        ```
        controller:
        ...часть файла намеренно опущена...
          wallarm:
            enabled: true
            ...часть файла намеренно опущена...
        ```
    
    Сохраните внесенные изменения.
    
    !!! info
        Рекомендуется задать иные значения для TLS-ключа и сертификата, вместо используемых NGINX Plus по умолчанию в секции `controller.defaultTLS`. 
        
        Для генерации сертификата и ключей вы можете использовать [OpenSSL][link-open-ssl-website]. Также доступна информация о [параметрах Helm Chart][link-helm-chart-configuration-docs] и заданию [секрета Kubernetes][link-kubernetes-secrets-docs] для TLS-ключа и TLS-сертификата.
    
5.  Если в вашем кластере Kubernetes выключена поддержка RBAC, необходимо внести дополнительные изменения в содержимое файла:
    1.  Создайте параметр `controller:serviceAccountName` пустым:
        
        ```
        controller:
        ...часть файла намеренно опущена...
          serviceAccountName:
        ...часть файла намеренно опущена...    
        ```
        
    2.  Измените значение параметра `rbac.create` на `false`:
        
        ```
        rbac:
          create: false
        ```
    
    Сохраните внесенные изменения.

##  3.  Развертывание Ingress‑контроллера

Выполните приведенную ниже команду для развертывания Ingress‑контроллера Валарм NGINX Plus с параметрами, описанными в файле `wl-ingress-plus.yaml`. 

Перед этим подставьте следующие значения в соответствующие параметры команды:
*   `<имя секрета>` — имя ранее созданного секрета Kubernetes (например, `my-secret`);
*   `<значение токена>` — значение полученного ранее токена (например, `qwerty`).

```
helm install --set controller.wallarm.imagePullSecrets.name="<имя секрета>",controller.wallarm.token="<значение токена>" --name wl-ingress-plus -f wl-ingress-plus.yaml .
```

!!! info
    Вы можете выбрать любое имя в качестве значения параметра `--name` при условии, что такое имя не используется в других развертываниях Helm.

Проверьте корректность развертывания, последовательно выполнив следующие команды:

```
helm ls
kubectl get pods,deployments,svc
```

Вы должны получить похожий вывод (имена подов Kubernetes могут отличаться от представленных):

```
helm ls
NAME            REVISION        UPDATED                         STATUS          CHART                           APP VERSION     NAMESPACE
wl-ingress-plus 1               Mon Dec 10 11:09:55 2018        DEPLOYED        wallarm-ingress-plus-1.0.3      1.3.2           default


kubectl get pods,deployments,svc
NAME                                                   READY     STATUS    RESTARTS   AGE
pod/nginx-ingress-75b6958849-wdv7s                     3/3       Running   0          13m
pod/nginx-ingress-wallarm-tarantool-846c69b49b-qcqdq   8/8       Running   0          13m

NAME                                                    DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment.extensions/nginx-ingress                     1         1         1            1           13m
deployment.extensions/nginx-ingress-wallarm-tarantool   1         1         1            1           13m

NAME                                      TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)                      AGE
service/kubernetes                        ClusterIP      10.0.0.1      <none>        443/TCP                      5d
service/nginx-ingress                     LoadBalancer   10.0.86.245   <pending>        80:30614/TCP,443:31593/TCP   13m
service/nginx-ingress-wallarm-tarantool   ClusterIP      10.0.81.30    <none>        3313/TCP                     13m
```

Ingress‑контроллер работает в связке с ресурсом Ingress, который описывает правила маршрутизации входящего HTTP‑ и HTTPS‑трафика до ваших сервисов, развернутых в кластере Kubernetes. 

Чтобы контроллер заработал, следующим шагом выполните развертывание ресурса Ingress.
