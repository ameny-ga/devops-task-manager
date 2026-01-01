# PowerShell Script to test the Task Manager API
# Usage: .\test_api.ps1

$API_URL = "http://localhost:5000"

Write-Host "`n=== Testing Task Manager API ===" -ForegroundColor Cyan
Write-Host "`n"

# Test 1: Health Check
Write-Host "1. Health Check" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$API_URL/health" -Method Get
    Write-Host "✓ Health check passed" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host "✗ Health check failed: $_" -ForegroundColor Red
}
Write-Host "`n"

# Test 2: Create Task
Write-Host "2. Creating a new task..." -ForegroundColor Yellow
$body = @{
    title = "Test Task from PowerShell"
    description = "This is a test task created via API"
    status = "pending"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_URL/api/tasks" -Method Post -Body $body -ContentType "application/json"
    $taskId = $response.id
    Write-Host "✓ Task created with ID: $taskId" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host "✗ Failed to create task: $_" -ForegroundColor Red
    exit 1
}
Write-Host "`n"

# Test 3: Get all tasks
Write-Host "3. Getting all tasks..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$API_URL/api/tasks" -Method Get
    Write-Host "✓ Retrieved $($response.count) task(s)" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 3
} catch {
    Write-Host "✗ Failed to get tasks: $_" -ForegroundColor Red
}
Write-Host "`n"

# Test 4: Get specific task
Write-Host "4. Getting task $taskId..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$API_URL/api/tasks/$taskId" -Method Get
    Write-Host "✓ Task retrieved successfully" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host "✗ Failed to get task: $_" -ForegroundColor Red
}
Write-Host "`n"

# Test 5: Update task
Write-Host "5. Updating task..." -ForegroundColor Yellow
$updateBody = @{
    title = "Updated Task Title"
    description = "This task has been updated"
    status = "completed"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_URL/api/tasks/$taskId" -Method Put -Body $updateBody -ContentType "application/json"
    Write-Host "✓ Task updated successfully" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host "✗ Failed to update task: $_" -ForegroundColor Red
}
Write-Host "`n"

# Test 6: Delete task
Write-Host "6. Deleting task..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$API_URL/api/tasks/$taskId" -Method Delete
    Write-Host "✓ Task deleted successfully" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host "✗ Failed to delete task: $_" -ForegroundColor Red
}
Write-Host "`n"

# Test 7: Verify deletion (should fail with 404)
Write-Host "7. Verifying deletion (expecting 404)..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$API_URL/api/tasks/$taskId" -Method Get
    Write-Host "✗ Task still exists (unexpected)" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 404) {
        Write-Host "✓ Task properly deleted (404 received)" -ForegroundColor Green
    } else {
        Write-Host "✗ Unexpected error: $_" -ForegroundColor Red
    }
}
Write-Host "`n"

# Test 8: Metrics
Write-Host "8. Getting Prometheus metrics..." -ForegroundColor Yellow
try {
    $metrics = Invoke-WebRequest -Uri "$API_URL/metrics" -Method Get
    $metricsLines = $metrics.Content -split "`n" | Where-Object { $_ -match "flask_http" } | Select-Object -First 10
    Write-Host "✓ Metrics endpoint working" -ForegroundColor Green
    $metricsLines | ForEach-Object { Write-Host $_ }
} catch {
    Write-Host "✗ Failed to get metrics: $_" -ForegroundColor Red
}
Write-Host "`n"

Write-Host "=== All tests completed ===" -ForegroundColor Cyan
Write-Host "`n"
