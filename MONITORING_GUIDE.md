# Guide de Visualisation - Prometheus et Grafana

## PROMETHEUS - Requetes PromQL

### 1. Ouvrir Prometheus
http://localhost:9091

### 2. Requetes utiles dans l'onglet "Graph"

#### Metriques HTTP
```promql
# Total des requetes HTTP
flask_http_request_total

# Requetes par seconde
rate(flask_http_request_total[1m])

# Requetes par endpoint
sum(rate(flask_http_request_total[5m])) by (path)

# Requetes par code de statut
sum(rate(flask_http_request_total[5m])) by (status)

# Duree moyenne des requetes (en secondes)
rate(flask_http_request_duration_seconds_sum[5m]) / rate(flask_http_request_duration_seconds_count[5m])
```

#### Metriques de l'application
```promql
# Total des taches
task_manager_tasks_total

# Taux de creation de taches
rate(task_manager_tasks_total[5m])

# Health checks
flask_http_request_total{path="/health"}
```

#### Metriques Kubernetes
```promql
# Pods actifs
up{job="task-manager-api"}

# Nombre de pods en cours d'execution
count(up{job="task-manager-api"} == 1)
```

### 3. Generer du trafic pour voir les metriques

```powershell
# Dans un terminal PowerShell
for ($i=1; $i -le 20; $i++) {
    curl.exe http://localhost:9000/health
    curl.exe http://localhost:9000/tasks
    curl.exe http://localhost:9000/metrics
    Start-Sleep -Milliseconds 500
}
```

---

## GRAFANA - Configuration et Dashboards

### 1. Ouvrir Grafana
http://localhost:3000

### 2. Se connecter
- Username: admin
- Password: admin

### 3. Ajouter Prometheus comme Data Source

1. Menu (burger icon) → Configuration → Data Sources
2. Cliquer "Add data source"
3. Selectionner "Prometheus"
4. Configuration:
   - Name: Prometheus
   - URL: http://prometheus-service:9090
   - Access: Server (default)
5. Cliquer "Save & Test" (doit afficher "Data source is working")

### 4. Creer votre premier Dashboard

#### Dashboard 1: Vue d'ensemble de l'API

1. Menu → Dashboards → New Dashboard
2. Cliquer "Add visualization"
3. Selectionner "Prometheus" comme data source

**Panel 1: Requetes par seconde**
- Title: Requetes HTTP par seconde
- Query: rate(flask_http_request_total[1m])
- Visualization: Time series
- Legend: {{method}} {{path}}

**Panel 2: Total des requetes**
- Title: Total des requetes HTTP
- Query: sum(flask_http_request_total)
- Visualization: Stat

**Panel 3: Duree moyenne des requetes**
- Title: Duree moyenne (secondes)
- Query: rate(flask_http_request_duration_seconds_sum[5m]) / rate(flask_http_request_duration_seconds_count[5m])
- Visualization: Gauge
- Unit: seconds (s)

**Panel 4: Requetes par endpoint**
- Title: Requetes par endpoint
- Query: sum(rate(flask_http_request_total[5m])) by (path)
- Visualization: Bar chart

**Panel 5: Status codes**
- Title: Codes de statut HTTP
- Query: sum(flask_http_request_total) by (status)
- Visualization: Pie chart

**Panel 6: Total des taches**
- Title: Nombre de taches
- Query: task_manager_tasks_total
- Visualization: Stat

5. Sauvegarder le dashboard:
   - Cliquer l'icone de sauvegarde (disquette)
   - Name: Task Manager - Monitoring
   - Cliquer "Save"

#### Dashboard 2: Kubernetes Metrics

**Panel 1: Pods actifs**
- Title: Pods en execution
- Query: count(up{job="task-manager-api"} == 1)
- Visualization: Stat

**Panel 2: Status des pods**
- Title: Status des pods
- Query: up{job="task-manager-api"}
- Visualization: Time series

**Panel 3: Health checks**
- Title: Health checks par minute
- Query: rate(flask_http_request_total{path="/health"}[1m]) * 60
- Visualization: Time series

### 5. Variables utiles dans Grafana

Pour rendre vos dashboards dynamiques, ajoutez des variables:

Dashboard Settings → Variables → Add variable
- Name: endpoint
- Type: Query
- Query: label_values(flask_http_request_total, path)

Puis utilisez $endpoint dans vos requetes:
```promql
flask_http_request_total{path="$endpoint"}
```

### 6. Alertes (optionnel)

Creer une alerte si trop d'erreurs:
1. Panel → Alert → Create alert rule
2. Condition: 
   - Query: sum(rate(flask_http_request_total{status=~"5.."}[5m]))
   - Threshold: > 0.1
3. Configure notification channel

---

## VERIFICATION RAPIDE

### Tester que tout fonctionne:

```powershell
# 1. Verifier l'API
curl.exe http://localhost:9000/health

# 2. Verifier les metriques sont exposees
curl.exe http://localhost:9000/metrics

# 3. Generer du trafic
for ($i=1; $i -le 50; $i++) {
    curl.exe http://localhost:9000/tasks
    Start-Sleep -Milliseconds 200
}

# 4. Verifier dans Prometheus (http://localhost:9091)
#    Requete: rate(flask_http_request_total[1m])

# 5. Verifier dans Grafana (http://localhost:3000)
#    Vous devriez voir les graphiques se mettre a jour
```

---

## LOGS (Bonus)

Les logs de votre application sont disponibles via kubectl:

```powershell
# Logs de tous les pods
kubectl logs -l app=task-manager --tail=50

# Logs en temps reel
kubectl logs -l app=task-manager -f

# Logs d'un pod specifique
kubectl logs task-manager-api-xxxxx

# Logs Prometheus
kubectl logs -l app=prometheus --tail=20

# Logs Grafana
kubectl logs -l app=grafana --tail=20
```

---

## DASHBOARDS RECOMMANDES

### Dashboard Task Manager Complet

Creer un dashboard avec:
- Row 1: Stats (Total requests, Avg duration, Total tasks, Active pods)
- Row 2: Time series (Requests/sec, Response times)
- Row 3: Distribution (Requests by endpoint, Status codes)
- Row 4: Kubernetes (Pod health, Resource usage)

### Exporter/Importer des dashboards

Export:
- Dashboard Settings → JSON Model → Copy to Clipboard

Import:
- Menu → Dashboards → Import → Paste JSON
