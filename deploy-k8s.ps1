# Script de déploiement simplifié sur Kubernetes
Write-Host "🚀 Déploiement sur Kubernetes (Minikube)" -ForegroundColor Cyan
Write-Host "=" * 50

# 1. Vérifier Minikube
Write-Host "`n1️⃣  Vérification de Minikube..." -ForegroundColor Yellow
minikube status | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Minikube n'est pas démarré. Lancement..." -ForegroundColor Red
    minikube start
}
Write-Host "✅ Minikube actif" -ForegroundColor Green

# 2. Configurer Docker pour Minikube
Write-Host "`n2️⃣  Configuration de Docker..." -ForegroundColor Yellow
minikube docker-env --shell powershell | Invoke-Expression
Write-Host "✅ Docker configuré" -ForegroundColor Green

# 3. Construire l'image
Write-Host "`n3️⃣  Construction de l'image Docker..." -ForegroundColor Yellow
docker build -t task-manager-api:latest . | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Image construite" -ForegroundColor Green
} else {
    Write-Host "❌ Erreur lors de la construction" -ForegroundColor Red
    exit 1
}

# 4. Déployer sur Kubernetes
Write-Host "`n4️⃣  Déploiement sur Kubernetes..." -ForegroundColor Yellow
kubectl apply -f k8s/ | Out-Null
Write-Host "✅ Application déployée" -ForegroundColor Green

# 5. Attendre que les pods soient prêts
Write-Host "`n5️⃣  Attente du démarrage des pods..." -ForegroundColor Yellow
$maxAttempts = 30
$attempt = 0
do {
    Start-Sleep -Seconds 2
    $readyPods = (kubectl get pods -l app=task-manager -o jsonpath='{.items[*].status.containerStatuses[0].ready}' | Select-String -Pattern "true" -AllMatches).Matches.Count
    $attempt++
    Write-Host "." -NoNewline
} while ($readyPods -lt 1 -and $attempt -lt $maxAttempts)

Write-Host ""
if ($readyPods -gt 0) {
    Write-Host "✅ Pods prêts ($readyPods/3)" -ForegroundColor Green
} else {
    Write-Host "⚠️  Pods pas encore prêts, mais continuons..." -ForegroundColor Yellow
}

# 6. Afficher les informations
Write-Host "`n" + ("=" * 50) -ForegroundColor Cyan
Write-Host "📊 État du déploiement:" -ForegroundColor Cyan
Write-Host ("=" * 50) -ForegroundColor Cyan
kubectl get pods -l app=task-manager
kubectl get svc task-manager-service

Write-Host "`n" + ("=" * 50) -ForegroundColor Green
Write-Host "✅ DÉPLOIEMENT TERMINÉ!" -ForegroundColor Green
Write-Host ("=" * 50) -ForegroundColor Green

Write-Host "`n📝 Pour accéder à l'application, utilisez:" -ForegroundColor Yellow
Write-Host "   .\start-k8s.ps1" -ForegroundColor White
Write-Host "`nOu manuellement:" -ForegroundColor Yellow
Write-Host "   minikube service task-manager-service" -ForegroundColor White
