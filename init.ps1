$RootDir     = $PSScriptRoot
$ServicesDef = Join-Path $RootDir "services.psd1"
$LocalConfig = Join-Path $RootDir "local.psd1"
$EnvFile     = Join-Path $RootDir ".env"

$repoDef    = Import-PowerShellDataFile $ServicesDef
$localPaths = @{}

foreach ($service in $repoDef.Services) {
    $clonePath = Join-Path $RootDir $service.Name

    if (-not (Test-Path $clonePath)) {
        Write-Host -ForegroundColor Yellow "Cloning '$($service.Name)'..."
        git clone $service.RepositoryUrl $clonePath
    } else {
        Write-Host -ForegroundColor Green "'$($service.Name)' already exists, skipping clone."
    }

    $localPaths[$service.Name] = $clonePath
}

if (Test-Path $LocalConfig) {
    Write-Host -ForegroundColor Yellow "Backing up local.psd1..."
    Copy-Item $LocalConfig (Join-Path $RootDir "local.old.psd1") -Force
}

# Salvar local.psd1
$lines = @("@{", "    Repositories = @{")
foreach ($key in $localPaths.Keys) {
    $lines += "        `"$key`" = `"$($localPaths[$key])`""
}
$lines += @("    }", "}")
$lines | Set-Content -Path $LocalConfig -Encoding UTF8

# Gerar .env
$envLines = @("# Gerado automaticamente por init.ps1")
foreach ($service in $repoDef.Services) {
    $envPrefix = ($service.Name -replace "-", "_").ToUpper()
    $envLines += "$($envPrefix)_PATH=$($localPaths[$service.Name])"
}
$envLines | Set-Content -Path $EnvFile -Encoding UTF8

Write-Host -ForegroundColor Yellow "Building images..."
docker compose build

Write-Host -ForegroundColor Green "Done."
Write-Host -ForegroundColor Green "Run 'docker compose up -d' to start the environment."
