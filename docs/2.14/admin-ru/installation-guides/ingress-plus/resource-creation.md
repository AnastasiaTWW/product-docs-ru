[link-kubectl-website]:             https://kubernetes.io/docs/reference/kubectl/overview/
[link-kubectl-docs]:                https://kubernetes.io/docs/tasks/tools/install-kubectl/
[link-host-header]:                 https://tools.ietf.org/html/rfc7230#section-5.4
[link-ingress-docs]:                https://kubernetes.io/docs/concepts/services-networking/ingress/
[link-example-domain]:              https://www.example.com/
[anchor1]:      #1-создание-файла-настроек-для-ресурса-ingress
[anchor2]:      #2-развертывание-ресурса-ingress
[link-next-chapter]:        wallarm-services-check.md
[link-previous-chapter]:    deploy.md

#   Создание ресурса Ingress
    
!!! info "Соглашение о терминах"
    В этом документе используется русскоязычный эквивалент английского термина *Ingress resource* — ресурс Ingress.

Для успешного функционирования раннее развернутого Ingress‑контроллера Валарм NGINX Plus необходимо также развернуть ресурс Ingress с требуемыми правилами маршрутизации для ваших сервисов. 

Чтобы сделать это, выполните следующие действия:
1.  [Создайте файл настроек для ресурса Ingress.][anchor1]
2.  [Разверните ресурс Ingress.][anchor2]

В данном руководстве также представлен [пример][link-next-chapter] работы с ресурсом Ingress для тестового приложения Café.

Убедитесь, что у вас установлен и настроен инструмент для управления кластерами Kubernetes — [Kubectl][link-kubectl-website] ([официальная документация][link-kubectl-docs]).

##  1.  Создание файла настроек для ресурса Ingress

Создайте текстовый YAML-файл `ingress.yaml` (вы можете выбрать любое имя файла) со следующим содержимым:

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: <имя ресурса Ingress>
  annotations:
    wallarm.com/mode: "monitoring"
spec:
  rules:
  - host: <имя домена, где располагается приложение>
    http:
      paths:
      - path: /
        backend:
          serviceName: <имя сервиса>
          servicePort: <порт для доступа к сервису>
```

При помощи этого файла будет настроена балансировка по заголовку [Host][link-host-header]. Вы можете добавить несколько записей `host` в секцию `spec.rules`. Для каждого доменного имени, заданного при помощи `host`, можно определить правило маршрутизации для необходимых путей. В файле настроено поведение, при котором пользователь, зашедший на `/`, будет перенаправлен к определенному сервису, развернутому в кластере Kubenetes.

Более подробная информация о развертывании ресурса Ingress доступна по [ссылке][link-ingress-docs].

##  2.  Развертывание ресурса Ingress

Для развертывания ресурса Ingress, настройки которого описаны в файле `ingress.yaml`,  выполните следующую команду:

```
kubectl apply -f ingress.yaml
```

При успешном развертывании будет выведено следующее сообщение:

```
ingress.extensions/<имя ресурса Ingress> created
```

Проверьте, что ресурс Ingress успешно развернут, выполнив следующую команду:

```
kubectl get ingress <имя ресурса Ingress>
```

Пример вывода:

```
NAME           HOSTS              ADDRESS         PORTS     AGE
cafe-ingress   cafe.example.com   13.80.xxx.161   80, 443   1h
```

Просмотрите детальное описание развернутого ресурса Ingress, выполнив следующую команду:

```
kubectl describe ingress <имя ресурса Ingress>
```

Вам будет предоставлено описание, где вы сможете найти следующую информацию:
*   IP‑адрес и порты Ingress‑контроллера, по котором он доступен;
*   правила маршрутизации Ingress;
*   список событий.

Убедитесь, что заданы корректные DNS-записи для требуемых доменов, указывающие на IP‑адрес Ingress‑контроллера.

Затем проверьте работоспособность Ingress, пройдя в браузере на необходимый адрес, по которому доступно ваше приложение (например, [www.example.com][link-example-domain]). В случае успешного развертывания Ingress‑контроллера Валарм NGINX Plus и связанного с ним ресурса Ingress, вас должно перенаправить на страницу вашего приложения.
