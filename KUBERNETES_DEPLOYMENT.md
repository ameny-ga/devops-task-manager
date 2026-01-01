# Instructions de déploiement Kubernetes

## Déploiement sur Minikube (Local)

### 1. Installation de Minikube

**Sur Windows:**
```powershell
# Installer minikube avec Chocolatey
choco install minikube

# Ou télécharger depuis https://minikube.sigs.k8s.io/docs/start/
```

### 2. Démarrer Minikube

```bash
# Démarrer minikube avec Docker driver
minikube start --driver=docker

# Vérifier le statut
minikube status

# Configurer kubectl pour utiliser minikube
kubectl config use-context minikube
```

### 3. Build l'image Docker dans Minikube

**Option A: Utiliser le daemon Docker de Minikube**
```bash
# Pointer Docker vers le daemon de Minikube
eval $(minikube docker-env)

# Build l'image
docker build -t task-manager-api:latest .

# Vérifier l'image
docker images | grep task-manager
```

**Option B: Utiliser Docker Hub**
```bash
# Build et push vers Docker Hub
docker build -t yourusername/task-manager-api:latest .
docker push yourusername/task-manager-api:latest

# Mettre à jour k8s/deployment.yaml avec votre image
```

### 4. Déployer sur Kubernetes

```bash
# Appliquer tous les manifests
kubectl apply -f k8s/

# Ou individuellement dans l'ordre
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/hpa.yaml
```

### 5. Vérifier le déploiement

```bash
# Voir les pods
kubectl get pods

# Voir les déploiements
kubectl get deployments

# Voir les services
kubectl get services

# Voir tous les objets
kubectl get all

# Logs d'un pod
kubectl logs -f deployment/task-manager-api

# Description détaillée
kubectl describe deployment task-manager-api
```

### 6. Accéder à l'application

**Option A: Port Forward**
```bash
# Forward le port 8080 local vers le service
kubectl port-forward service/task-manager-service 8080:80

# Accéder à http://localhost:8080
curl http://localhost:8080/health
```

**Option B: Minikube Service**
```bash
# Obtenir l'URL du service
minikube service task-manager-service --url

# Ouvrir dans le navigateur
minikube service task-manager-service
```

**Option C: Minikube Tunnel (LoadBalancer)**
```bash
# Dans un terminal séparé
minikube tunnel

# Le service aura une IP externe
kubectl get service task-manager-service
```

### 7. Tester l'API

```bash
# Health check
curl http://localhost:8080/health

# Créer une tâche
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Task","description":"Test from K8s"}'

# Lister les tâches
curl http://localhost:8080/api/tasks

# Métriques Prometheus
curl http://localhost:8080/metrics
```

### 8. Tester le scaling

```bash
# Augmenter le nombre de replicas
kubectl scale deployment task-manager-api --replicas=5

# Voir les pods se créer
kubectl get pods -w

# Vérifier l'HPA (Horizontal Pod Autoscaler)
kubectl get hpa

# Générer de la charge pour tester l'autoscaling
kubectl run -it --rm load-generator --image=busybox /bin/sh
# Dans le pod:
while true; do wget -q -O- http://task-manager-service/health; done
```

### 9. Mettre à jour l'application

```bash
# Rebuild l'image avec un nouveau tag
docker build -t task-manager-api:v2 .

# Mettre à jour le déploiement
kubectl set image deployment/task-manager-api api=task-manager-api:v2

# Suivre le rollout
kubectl rollout status deployment/task-manager-api

# Historique des rollouts
kubectl rollout history deployment/task-manager-api

# Rollback si nécessaire
kubectl rollout undo deployment/task-manager-api
```

### 10. Debugging

```bash
# Logs d'un pod spécifique
kubectl logs <pod-name>

# Logs en temps réel
kubectl logs -f deployment/task-manager-api

# Se connecter à un pod
kubectl exec -it <pod-name> -- /bin/sh

# Voir les events
kubectl get events --sort-by='.lastTimestamp'

# Décrire un pod avec problèmes
kubectl describe pod <pod-name>

# Vérifier les ressources
kubectl top pods
kubectl top nodes
```

### 11. Nettoyage

```bash
# Supprimer tous les objets du projet
kubectl delete -f k8s/

# Ou individuellement
kubectl delete deployment task-manager-api
kubectl delete service task-manager-service
kubectl delete configmap task-manager-config
kubectl delete hpa task-manager-hpa

# Arrêter minikube
minikube stop

# Supprimer le cluster
minikube delete
```

---

## Déploiement sur Cloud (Bonus)

### AWS EKS

```bash
# Créer un cluster EKS
eksctl create cluster --name task-manager-cluster --region us-east-1

# Configurer kubectl
aws eks update-kubeconfig --name task-manager-cluster --region us-east-1

# Déployer
kubectl apply -f k8s/

# Obtenir l'URL du LoadBalancer
kubectl get service task-manager-service
```

### GCP GKE

```bash
# Créer un cluster GKE
gcloud container clusters create task-manager-cluster --num-nodes=3

# Configurer kubectl
gcloud container clusters get-credentials task-manager-cluster

# Déployer
kubectl apply -f k8s/
```

### Azure AKS

```bash
# Créer un cluster AKS
az aks create --resource-group myResourceGroup --name task-manager-cluster --node-count 3

# Configurer kubectl
az aks get-credentials --resource-group myResourceGroup --name task-manager-cluster

# Déployer
kubectl apply -f k8s/
```

---

## Monitoring avec Prometheus & Grafana sur Kubernetes

### 1. Installer Prometheus Operator

```bash
# Ajouter le repo Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Installer Prometheus & Grafana
helm install prometheus prometheus-community/kube-prometheus-stack
```

### 2. Accéder à Grafana

```bash
# Port forward Grafana
kubectl port-forward svc/prometheus-grafana 3000:80

# Login: admin / prom-operator
```

### 3. Configurer le monitoring de l'API

```bash
# Créer un ServiceMonitor
kubectl apply -f - <<EOF
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: task-manager-metrics
spec:
  selector:
    matchLabels:
      app: task-manager
  endpoints:
  - port: http
    path: /metrics
EOF
```

---

## Troubleshooting commun

### Problème: ImagePullBackOff
```bash
# Vérifier si l'image existe
docker images | grep task-manager

# Utiliser imagePullPolicy: Never si image locale
kubectl patch deployment task-manager-api -p '{"spec":{"template":{"spec":{"containers":[{"name":"api","imagePullPolicy":"Never"}]}}}}'
```

### Problème: CrashLoopBackOff
```bash
# Voir les logs
kubectl logs <pod-name>

# Vérifier les resources
kubectl describe pod <pod-name>
```

### Problème: Service pas accessible
```bash
# Vérifier que les pods sont Ready
kubectl get pods

# Vérifier le service
kubectl describe service task-manager-service

# Vérifier les endpoints
kubectl get endpoints task-manager-service
```

---

## Commandes utiles

```bash
# Tout voir
kubectl get all -o wide

# Watch mode
kubectl get pods -w

# Output en YAML
kubectl get deployment task-manager-api -o yaml

# Dry run pour tester
kubectl apply -f k8s/deployment.yaml --dry-run=client

# Valider les manifests
kubectl apply -f k8s/ --dry-run=server

# Obtenir l'IP du cluster
kubectl cluster-info

# Dashboard Kubernetes
minikube dashboard
```
