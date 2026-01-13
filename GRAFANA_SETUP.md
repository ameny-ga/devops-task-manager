# Guide de Configuration Grafana pour Task Manager

## Accès à Grafana

1. **Démarrer Grafana**
   ```powershell
   .\access-grafana.ps1
   ```

2. **Ouvrir** http://localhost:3000

3. **Se connecter**
   - Username: `admin`
   - Password: `admin`

## Configuration de la Data Source Prometheus

1. **Menu** → Configuration → Data Sources
2. **Cliquer** sur "Add data source"
3. **Sélectionner** "Prometheus"
4. **Configuration:**
   - Name: `Prometheus`
   - URL: `http://prometheus-service:9090`
5. **Cliquer** sur "Save & Test"

## Créer un Dashboard

### Dashboard 1: Métriques HTTP

1. **Menu** → Dashboards → New Dashboard
2. **Ajouter** un panel:
   - **Titre:** Requêtes HTTP Total
   - **Requête:** `flask_http_request_total`
   - **Visualisation:** Graph

3. **Ajouter** un autre panel:
   - **Titre:** Durée des Requêtes
   - **Requête:** `rate(flask_http_request_duration_seconds_sum[5m]) / rate(flask_http_request_duration_seconds_count[5m])`
   - **Visualisation:** Graph

### Dashboard 2: Métriques de l'Application

1. **Ajouter** un panel:
   - **Titre:** Total des Tâches
   - **Requête:** `task_manager_tasks_total`
   - **Visualisation:** Stat

2. **Ajouter** un panel:
   - **Titre:** Requêtes par Seconde
   - **Requête:** `rate(flask_http_request_total[1m])`
   - **Visualisation:** Graph

### Dashboard 3: Métriques Kubernetes

1. **Ajouter** un panel:
   - **Titre:** Pods Actifs
   - **Requête:** `count(up{job="task-manager-api"})`
   - **Visualisation:** Stat

## Requêtes PromQL Utiles

### Métriques HTTP
```promql
# Total des requêtes HTTP
flask_http_request_total

# Taux de requêtes par seconde
rate(flask_http_request_total[1m])

# Durée moyenne des requêtes
rate(flask_http_request_duration_seconds_sum[5m]) / rate(flask_http_request_duration_seconds_count[5m])

# Requêtes par endpoint
sum(rate(flask_http_request_total[5m])) by (path)

# Requêtes par code de statut
sum(rate(flask_http_request_total[5m])) by (status)
```

### Métriques de l'Application
```promql
# Total des tâches
task_manager_tasks_total

# Taux de création de tâches
rate(task_manager_tasks_total[5m])

# Requêtes au endpoint /health
flask_http_request_total{path="/health"}
```

### Métriques Système
```promql
# Pods en cours d'exécution
up{job="task-manager-api"}

# Nombre de pods actifs
count(up{job="task-manager-api"} == 1)
```

## Tester les Métriques

Générez du trafic vers l'API pour voir les métriques:

```powershell
# Plusieurs requêtes vers l'API
for ($i=1; $i -le 50; $i++) {
    curl.exe http://localhost:9090/tasks
    curl.exe http://localhost:9090/health
}
```

## URLs Importantes

- **Grafana:** http://localhost:3000
- **Prometheus:** http://localhost:9091
- **API:** http://localhost:8080
- **Métriques API:** http://localhost:8080/metrics

## Sauvegarder le Dashboard

1. **Cliquer** sur l'icône de sauvegarde (disquette)
2. **Nom:** Task Manager Monitoring
3. **Cliquer** sur "Save"

## Exporter le Dashboard (JSON)

1. **Dashboard settings** (icône engrenage)
2. **JSON Model**
3. **Copier** le JSON pour le sauvegarder
