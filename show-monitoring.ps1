# Script pour afficher l'etat du monitoring
Write-Host "Demarrage du monitoring stack..." -ForegroundColor Cyan
Write-Host ("=" * 60)

# Verifier que les pods sont prets
Write-Host "`nVerification des pods..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

kubectl get pods -l 'app in (prometheus,grafana,task-manager)'

Write-Host "`n" + ("=" * 60) -ForegroundColor Green
Write-Host "Stack de monitoring deploye!" -ForegroundColor Green
Write-Host ("=" * 60) -ForegroundColor Green

# Obtenir les noms des pods
$apiPod = kubectl get pods -l app=task-manager -o jsonpath='{.items[0].metadata.name}'
$promPod = kubectl get pods -l app=prometheus -o jsonpath='{.items[0].metadata.name}'
$grafanaPod = kubectl get pods -l app=grafana -o jsonpath='{.items[0].metadata.name}'

Write-Host "`nPour acceder aux services, ouvrez 3 terminaux:" -ForegroundColor Cyan
Write-Host ""
Write-Host "Terminal 1 - API Task Manager (port 9000):" -ForegroundColor Yellow
Write-Host "  kubectl port-forward service/task-manager-service 9000:80" -ForegroundColor White
Write-Host ""
Write-Host "Terminal 2 - Prometheus (port 9091):" -ForegroundColor Yellow
Write-Host "  kubectl port-forward service/prometheus-service 9091:9090" -ForegroundColor White
Write-Host ""
Write-Host "Terminal 3 - Grafana (port 3000):" -ForegroundColor Yellow
Write-Host "  kubectl port-forward service/grafana-service 3000:3000" -ForegroundColor White

Write-Host "`nURLs d'acces:" -ForegroundColor Cyan
Write-Host "  - API:        http://localhost:9000" -ForegroundColor White
Write-Host "  - Prometheus: http://localhost:9091" -ForegroundColor White
Write-Host "  - Grafana:    http://localhost:3000 (admin/admin)" -ForegroundColor White
