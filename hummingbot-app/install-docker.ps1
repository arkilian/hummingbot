# Script de Instalacao Rapida do Hummingbot via Docker
# Execute este arquivo: .\install-docker.ps1

Write-Host ""
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host "    HUMMINGBOT - INSTALACAO VIA DOCKER" -ForegroundColor Cyan
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se Docker esta instalado
Write-Host "Verificando Docker..." -ForegroundColor Yellow
$dockerVersion = docker --version 2>$null
if ($LASTEXITCODE -eq 0 -and $dockerVersion) {
    Write-Host "OK Docker encontrado: $dockerVersion" -ForegroundColor Green
} else {
    Write-Host "ERRO Docker nao encontrado!" -ForegroundColor Red
    Write-Host "  Por favor, instale o Docker Desktop:" -ForegroundColor Yellow
    Write-Host "  https://www.docker.com/products/docker-desktop" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Pressione Enter para sair"
    exit 1
}

# Criar estrutura de pastas
Write-Host ""
Write-Host "Criando estrutura de pastas..." -ForegroundColor Yellow
$folders = @("hummingbot_files", "hummingbot_files/conf", "hummingbot_files/logs", "hummingbot_files/data", "hummingbot_files/scripts", "hummingbot_files/certs")

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
        Write-Host "  Criado: $folder" -ForegroundColor Green
    } else {
        Write-Host "  Ja existe: $folder" -ForegroundColor Gray
    }
}

# Baixar imagem do Hummingbot
Write-Host ""
Write-Host "Baixando imagem do Hummingbot..." -ForegroundColor Yellow
Write-Host "  (Isso pode levar alguns minutos na primeira vez)" -ForegroundColor Gray
docker pull hummingbot/hummingbot:latest

if ($LASTEXITCODE -eq 0) {
    Write-Host "OK Imagem baixada com sucesso!" -ForegroundColor Green
} else {
    Write-Host "ERRO ao baixar imagem" -ForegroundColor Red
    Read-Host "Pressione Enter para sair"
    exit 1
}

# Verificar se ja existe um container
Write-Host ""
Write-Host "Verificando containers existentes..." -ForegroundColor Yellow
$existingContainer = docker ps -a --filter "name=hummingbot" --format "{{.Names}}" 2>$null

if ($existingContainer -eq "hummingbot") {
    Write-Host "  Container 'hummingbot' ja existe" -ForegroundColor Yellow
    $response = Read-Host "  Deseja remove-lo e criar um novo? (s/N)"
    if (($response -eq "s") -or ($response -eq "S")) {
        docker stop hummingbot 2>$null | Out-Null
        docker rm hummingbot 2>$null | Out-Null
        Write-Host "  Container anterior removido" -ForegroundColor Green
    } else {
        Write-Host "  Mantendo container existente" -ForegroundColor Gray
        Write-Host ""
        Write-Host "===================================================================" -ForegroundColor Cyan
        Write-Host "  Para iniciar o Hummingbot:" -ForegroundColor White
        Write-Host "    docker start hummingbot" -ForegroundColor Yellow
        Write-Host "    docker attach hummingbot" -ForegroundColor Yellow
        Write-Host "===================================================================" -ForegroundColor Cyan
        Read-Host "Pressione Enter para sair"
        exit 0
    }
}

# Criar e iniciar container
Write-Host ""
Write-Host "Iniciando Hummingbot..." -ForegroundColor Yellow
Write-Host ""

$currentPath = (Get-Location).Path

docker run -it --name hummingbot --mount "type=bind,source=$currentPath\hummingbot_files\conf,destination=/conf" --mount "type=bind,source=$currentPath\hummingbot_files\logs,destination=/logs" --mount "type=bind,source=$currentPath\hummingbot_files\data,destination=/data" --mount "type=bind,source=$currentPath\hummingbot_files\scripts,destination=/scripts" hummingbot/hummingbot:latest

Write-Host ""
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host "  Hummingbot encerrado" -ForegroundColor White
Write-Host ""
Write-Host "  Para reiniciar:" -ForegroundColor White
Write-Host "    docker start hummingbot" -ForegroundColor Yellow
Write-Host "    docker attach hummingbot" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Comandos uteis:" -ForegroundColor White
Write-Host "    docker logs hummingbot    # Ver logs" -ForegroundColor Gray
Write-Host "    docker stop hummingbot    # Parar" -ForegroundColor Gray
Write-Host "    docker rm hummingbot      # Remover" -ForegroundColor Gray
Write-Host "===================================================================" -ForegroundColor Cyan
