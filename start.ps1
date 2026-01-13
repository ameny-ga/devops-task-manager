# Quick Start Script for Task Manager API
# This script sets up and runs the application locally

Write-Host ""
Write-Host "=== Task Manager API - Quick Start ===" -ForegroundColor Cyan
Write-Host ""

# Check Python installation
Write-Host "Checking Python installation..." -ForegroundColor Yellow
$pythonVersion = python --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "OK $pythonVersion installed" -ForegroundColor Green
} else {
    Write-Host "ERROR Python not found. Please install Python 3.11+" -ForegroundColor Red
    exit 1
}

# Check if virtual environment exists
if (-not (Test-Path "venv")) {
    Write-Host ""
    Write-Host "Creating virtual environment..." -ForegroundColor Yellow
    python -m venv venv
    Write-Host "OK Virtual environment created" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "OK Virtual environment already exists" -ForegroundColor Green
}

# Activate virtual environment
Write-Host ""
Write-Host "Activating virtual environment..." -ForegroundColor Yellow
& .\venv\Scripts\Activate.ps1
Write-Host "OK Virtual environment activated" -ForegroundColor Green

# Upgrade pip
Write-Host ""
Write-Host "Upgrading pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip --quiet
Write-Host "OK pip upgraded" -ForegroundColor Green

# Install dependencies
Write-Host ""
Write-Host "Installing dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "OK Dependencies installed" -ForegroundColor Green
} else {
    Write-Host "ERROR Failed to install dependencies" -ForegroundColor Red
    exit 1
}

# Run tests
Write-Host ""
Write-Host "Running unit tests..." -ForegroundColor Yellow
pytest test_app.py -v --tb=short
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "OK All tests passed!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "ERROR Some tests failed" -ForegroundColor Red
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne "y") {
        exit 1
    }
}

# Start the application
Write-Host ""
Write-Host "=== Starting Task Manager API ===" -ForegroundColor Cyan
Write-Host "API will be available at: http://localhost:5000" -ForegroundColor Yellow
Write-Host "Press CTRL+C to stop the server" -ForegroundColor Yellow
Write-Host ""
Start-Sleep -Seconds 2

python app.py
