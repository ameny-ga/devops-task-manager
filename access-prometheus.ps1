# Script pour acceder a Prometheus
Write-Host "Demarrage de Prometheus..." -ForegroundColor Cyan

Write-Host "Prometheus accessible sur http://localhost:9091" -ForegroundColor Yellow
Write-Host "Cette fenetre doit rester OUVERTE" -ForegroundColor Red
Write-Host "`nRequetes utiles dans Prometheus:" -ForegroundColor Cyan
Write-Host "  - flask_http_request_total" -ForegroundColor White
Write-Host "  - flask_http_request_duration_seconds" -ForegroundColor White
Write-Host "  - task_manager_tasks_total" -ForegroundColor White
Write-Host ("=" * 60)

kubectl port-forward service/prometheus-service 9091:9090
