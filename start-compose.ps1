param (
    [Parameter(HelpMessage = "Prevents the browser from automatically opening when the environment starts.")]
    [switch]$Headless
)

$localConfig = Join-Path $PSScriptRoot ".env"

if (-not (Test-Path $localConfig)) {
    Write-Host -ForegroundColor Red "Local configuration not found. Run '.\init-compose.ps1' before continuing."
    exit 1
}

Write-Host -ForegroundColor Yellow "Starting environment..."
docker compose stop nginx
docker compose up -d
if ($LASTEXITCODE -ne 0) { throw "docker compose up failed" }

Write-Host -ForegroundColor Green "Environment available at http://localhost:8080"

if (-not $Headless) {
    Start-Process "http://localhost:8080"
}