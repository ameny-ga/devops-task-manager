# Script pour demarrer et acceder a l'application sur Kubernetes
Write-Host "Demarrage de l'acces a l'application..." -ForegroundColor Cyan

Write-Host "Creation du tunnel sur http://localhost:9000" -ForegroundColor Yellow
Write-Host "Cette fenetre doit rester OUVERTE" -ForegroundColor Red
Write-Host "`nTestez l'API avec:" -ForegroundColor Cyan
Write-Host "  - http://localhost:9000/health" -ForegroundColor White
Write-Host "  - http://localhost:9000/tasks" -ForegroundColor White
Write-Host "  - http://localhost:9000/metrics" -ForegroundColor White
Write-Host ("=" * 50)

# Lancer le port-forward vers le service
kubectl port-forward service/task-manager-service 9000:80
