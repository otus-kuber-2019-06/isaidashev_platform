# isaidashev_platform
isaidashev Platform repository

##  ДЗ 1

1. Установил minikube и kubectl
2. Запустил minikube и проверил состояние kubectl cluster-info
3. Запустил Dashboard kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta1/aio/deploy/recommended.yaml
4. Установил cli k9s
5. Провел тестирование отказойстойчивости kubernetis удалив все pods:
```
docker rm -f $(docker ps -a -q)1.8
```
и 
```
kubectl delete pod --all -n kube-system
```
6. Проверка работы состояния кластера `kubectl get componentstatuses`
7. Создал образ c nginx который работает на 8000 порту с UID 1001 и отдает содержимое директории из папки /app
8. Подготовлен манифест web-pod.yaml и применен `kubectl apply -f web-pod.yaml`
9. Выгрузить манифест у уже запущеного POD `kubectl get pod web -o yaml`
10. Посмотреть описание POD `kubectl describe pod web`. Как один из способов диагностики неисправнсти пода посмотреть events
11. В манифест добавлен init контейнер который запускается перед POD и делает необходимые дополнительные манипуляции (проверки, прогревка кеша, дамп базы и тд) 
```
initContainers:
    - name: busybox-wget
      image: busybox:1.31.0
      command: ['sh', '-c', 'wget -O- https://raw.githubusercontent.com/express42/otus-platform-snippets/master/Module-02/Introduction-to-Kubernetes/wget.sh | sh']
```
Для того чтобы результаты работы передать из init контейнера в основной был примонтирован volume EmptyDir
```
volumes:  
    - name: app
      emptyDir: {}
```
12. Отслеживание статуса изменений kubectl get pods -w.
13. Проверить работоспособность пода можно через.
```
kubectl port-forward --adress 0.0.0.0 pod/web 8000:8000
```

##  ДЗ 2

Для доступа к kubernetis используется подход с тремя AAA
- Autentification
- Autorization
- Admision

### Autentification

https://kubernetes.io/docs/reference/access-authn-authz/controlling-access/

Нужно kubernetes обьяснять от куда аутентифицировать. 
Распространненые спрособы:
- по сертификату
- по парольному файлу
- OpenID Connect Tokens

Способы аутентификации задаются при помощи командной строки api-server. Посмотреть что сейчас включено можно через `kubect cluster-info dump`

Для подключению к кластеру kubectl использует конфигурации назваемыми контекстами:
`kubectl config view`
В переменой среды KUBECONFIG указан путь до конфига. В нее можно прописать несколько путей до конфигурационых файлов. 

```
apiVersion: v1
contexts:
- context: 
    cluster: minikube
    user: static-admin
  name: minikube-static
  kind: Config
users: 
- name: static-admin
  user:
    username: admin
    password: password
```

### Autentification
1. Посмотреть группы api (ресурсы) к котором можно предоставить доступ:
`kubectl api-resources`
2. Группы api указываются в ролях. Роли бывают кластерные (глобальные в рамках кластера) и роли с рапостранением на namespace. Roles соединяют ресурсы и глаголы. Для просмотра предустановленых ролей:
```
kubectl get clusterrole
kubectl get role
```
Пример конфига:
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  # "namespace" omitted since ClusterRoles are not namespaced
  name: secret-reader
rules:
- apiGroups: [""] 
  resources: ["secrets"]
  verbs: ["get", "watch", "list"] #Verbs (глаголы) — совокупность операций, которые могут быть выполнены над ресурсами. 
```
Ссылка на документацию: https://kubernetes.io/docs/reference/access-authn-authz/authorization/
3. RoleBindings или ClusterRoleBindings - соеденияет роли с субьектами. 

- Users — глобальные пользователи, предназначены для людей или процессов, живущих вне кластера;
- ServiceAccounts — ограниченные пространством имён и предназначенные для процессов внутри кластера, запущенных на подах.

```
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: salme-pods
  namespace: test
subjects:
- kind: User
  name: jsalmeron
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-read-create
  apiGroup: rbac.authorization.k8s.io
```
4. Проверка возможности доступа к API:

```
kubectl auth can-i create deployments --namespace dev
```

Ссылки:
https://habr.com/ru/company/flant/blog/422801/

##  ДЗ 3

Переключена работа kube-proxy с iptables на IPVS. В конфиг configmap/kube-proxy установлен  `mode: "ipvs"`.

Настроена балансировка для сервисов при помощи metallb `kubectl apply -fhttps://raw.githubusercontent.com/google/metallb/v0.8.0/manifests/metallb.yaml` и выделен пул сетевых адресов.

Предоставлен доступ к тестовому приложению в при помощи обычного сервис и автоматического выделеного IP а так же к внешним запросам на CoreDNS.

Настроен Ingress `kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml` для установленого дашборда kubernetis через headless сервис с автоматическим выделением IP.

##  ДЗ 3

Развернут minio https://raw.githubusercontent.com/express42/otus-platform-snippets/master/Module-02/Kuberenetes-volumes/minio-statefulset.yaml

В конфигурацию добавлен headles и secret.

