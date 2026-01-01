# GitHub Issues Template

## Exemples d'issues à créer pour le projet

### Issue 1: Développer l'API REST
**Titre:** Créer l'API REST avec endpoints CRUD  
**Description:**
- [ ] Créer les endpoints GET /api/tasks
- [ ] Créer l'endpoint POST /api/tasks
- [ ] Créer l'endpoint PUT /api/tasks/{id}
- [ ] Créer l'endpoint DELETE /api/tasks/{id}
- [ ] Ajouter la validation des entrées
- [ ] Implémenter la gestion d'erreurs

**Labels:** enhancement, backend

---

### Issue 2: Intégrer l'observabilité
**Titre:** Ajouter métriques, logs et tracing  
**Description:**
- [ ] Intégrer Prometheus Flask Exporter
- [ ] Configurer les logs structurés en JSON
- [ ] Ajouter OpenTelemetry pour le tracing
- [ ] Créer l'endpoint /metrics
- [ ] Tester la collecte de métriques

**Labels:** enhancement, observability

---

### Issue 3: Configuration CI/CD
**Titre:** Mettre en place le pipeline GitHub Actions  
**Description:**
- [ ] Créer le workflow ci-cd.yml
- [ ] Ajouter les jobs de tests
- [ ] Configurer les scans SAST (Bandit, Safety)
- [ ] Ajouter le build et push Docker
- [ ] Intégrer OWASP ZAP pour DAST
- [ ] Configurer le déploiement automatique

**Labels:** ci/cd, devops

---

### Issue 4: Containerisation Docker
**Titre:** Créer le Dockerfile et Docker Compose  
**Description:**
- [ ] Créer un Dockerfile multi-stage
- [ ] Optimiser la taille de l'image
- [ ] Ajouter un utilisateur non-root
- [ ] Créer docker-compose.yml avec Prometheus et Grafana
- [ ] Configurer les health checks
- [ ] Tester le build local

**Labels:** docker, containerization

---

### Issue 5: Déploiement Kubernetes
**Titre:** Créer les manifests Kubernetes  
**Description:**
- [ ] Créer deployment.yaml avec 3 replicas
- [ ] Créer service.yaml de type LoadBalancer
- [ ] Ajouter configmap.yaml pour la configuration
- [ ] Créer hpa.yaml pour l'autoscaling
- [ ] Tester sur minikube
- [ ] Documenter les commandes kubectl

**Labels:** kubernetes, deployment

---

### Issue 6: Tests unitaires
**Titre:** Écrire les tests unitaires avec Pytest  
**Description:**
- [ ] Tester tous les endpoints API
- [ ] Tester la gestion d'erreurs
- [ ] Tester la validation des entrées
- [ ] Atteindre 90%+ de coverage
- [ ] Intégrer au pipeline CI/CD

**Labels:** testing, quality

---

### Issue 7: Documentation
**Titre:** Créer la documentation complète  
**Description:**
- [ ] Rédiger le README.md avec exemples
- [ ] Documenter l'installation locale
- [ ] Ajouter les exemples d'utilisation Docker
- [ ] Documenter le déploiement Kubernetes
- [ ] Créer le rapport final (REPORT.md)

**Labels:** documentation

---

### Issue 8: Sécurité
**Titre:** Implémenter les scans de sécurité  
**Description:**
- [ ] Configurer Bandit pour SAST
- [ ] Ajouter Safety pour les dépendances
- [ ] Intégrer OWASP ZAP pour DAST
- [ ] Créer un container non-root
- [ ] Documenter les résultats de sécurité

**Labels:** security

---

## Instructions pour créer ces issues sur GitHub

1. Aller sur votre repository GitHub
2. Cliquer sur "Issues" → "New Issue"
3. Copier le titre et la description
4. Ajouter les labels appropriés
5. Assigner à vous-même
6. Créer l'issue

## Workflow recommandé

1. Créer toutes les issues
2. Créer une branche pour chaque issue: `git checkout -b issue-1-api-rest`
3. Travailler sur l'issue
4. Commit avec référence: `git commit -m "feat: Add CRUD endpoints #1"`
5. Push et créer une Pull Request
6. Demander une review à un collègue
7. Merger après approbation
8. Fermer l'issue automatiquement

## Exemple de Pull Request

**Titre:** [Issue #1] Créer l'API REST avec endpoints CRUD

**Description:**
Cette PR implémente les endpoints CRUD pour la gestion de tâches:
- ✅ GET /api/tasks - Liste toutes les tâches
- ✅ POST /api/tasks - Crée une nouvelle tâche
- ✅ PUT /api/tasks/{id} - Met à jour une tâche
- ✅ DELETE /api/tasks/{id} - Supprime une tâche
- ✅ Validation des entrées
- ✅ Gestion d'erreurs complète

**Tests:** Tous les tests passent ✓

**Closes #1**
