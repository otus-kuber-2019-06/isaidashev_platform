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
12. Отслеживание статуса изменений kubectl get pods -w
13. Проверить работоспособность пода можно через 
```
kubectl port-forward --adress 0.0.0.0 pod/web 8000:8000
```