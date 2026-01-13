# Script pour acceder a Grafana
Write-Host "Demarrage de Grafana..." -ForegroundColor Cyan

Write-Host "Grafana accessible sur http://localhost:3000" -ForegroundColor Yellow
Write-Host "Cette fenetre doit rester OUVERTE" -ForegroundColor Red
Write-Host "`nIdentifiants:" -ForegroundColor Cyan
Write-Host "  Username: admin" -ForegroundColor White
Write-Host "  Password: admin" -ForegroundColor White
Write-Host "`nEtapes de configuration:" -ForegroundColor Cyan
Write-Host "  1. Se connecter avec admin/admin" -ForegroundColor White
Write-Host "  2. Ajouter une Data Source (Prometheus)" -ForegroundColor White
Write-Host "     URL: http://prometheus-service:9090" -ForegroundColor White
Write-Host "  3. Creer un dashboard pour visualiser les metriques" -ForegroundColor White
Write-Host ("=" * 60)

kubectl port-forward service/grafana-service 3000:3000
