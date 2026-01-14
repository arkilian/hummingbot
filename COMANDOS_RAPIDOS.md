# ⚡ Comandos Rápidos - Hummingbot Deploy

Referência rápida para operações comuns do Hummingbot Deploy.

## 🚀 Início Rápido

```powershell
# Navegar para a pasta deploy
cd c:\github\hummingbot\deploy

# Iniciar todos os serviços
docker-compose up -d

# Abrir Dashboard no navegador
Start-Process http://localhost:8501
```

## 📊 Monitoramento

```powershell
# Ver status de todos os containers
docker-compose ps

# Ver logs em tempo real (todos os serviços)
docker-compose logs -f

# Ver logs de um serviço específico
docker-compose logs -f dashboard
docker-compose logs -f hummingbot-api
docker-compose logs -f hummingbot-broker
docker-compose logs -f hummingbot-postgres

# Ver últimas 50 linhas de logs
docker-compose logs --tail=50 dashboard
```

## 🔄 Gestão de Serviços

```powershell
# Parar todos os serviços
docker-compose down

# Parar sem remover volumes (preserva dados)
docker-compose stop

# Reiniciar todos os serviços
docker-compose restart

# Reiniciar um serviço específico
docker-compose restart dashboard
docker-compose restart hummingbot-api

# Iniciar serviços parados
docker-compose start

# Ver recursos utilizados
docker stats
```

## 🔧 Atualização

```powershell
# Parar serviços
docker-compose down

# Atualizar imagens Docker
docker-compose pull

# Reiniciar com novas imagens
docker-compose up -d

# Ver versões das imagens
docker images | findstr hummingbot
```

## 🗄️ Gestão de Dados

```powershell
# Backup do PostgreSQL
docker exec hummingbot-postgres pg_dump -U hbot hummingbot_api > backup.sql

# Restaurar backup
Get-Content backup.sql | docker exec -i hummingbot-postgres psql -U hbot hummingbot_api

# Ver volumes criados
docker volume ls | findstr deploy

# Remover volumes (CUIDADO: remove todos os dados)
docker-compose down -v
```

## 🤖 Gestão de Bots

```powershell
# Listar bots em execução
docker ps --filter "name=hummingbot"

# Aceder ao shell de um bot
docker exec -it hummingbot bash
docker exec -it <nome-do-bot> bash

# Ver logs de um bot específico
docker logs -f hummingbot
docker logs -f <nome-do-bot>

# Parar um bot específico
docker stop hummingbot
docker stop <nome-do-bot>

# Remover um bot parado
docker rm hummingbot
docker rm <nome-do-bot>
```

## 🔍 Diagnóstico

```powershell
# Testar conectividade à API
Invoke-WebRequest -Uri http://localhost:8000/docker/running -UseBasicParsing

# Testar conectividade com autenticação
$cred = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("admin:admin"))
Invoke-WebRequest -Uri http://localhost:8000/docker/running -Headers @{Authorization="Basic $cred"} -UseBasicParsing

# Ver endpoints disponíveis na API
Start-Process http://localhost:8000/docs

# Verificar se portas estão abertas
Test-NetConnection -ComputerName localhost -Port 8501  # Dashboard
Test-NetConnection -ComputerName localhost -Port 8000  # API
Test-NetConnection -ComputerName localhost -Port 1883  # MQTT
Test-NetConnection -ComputerName localhost -Port 18083 # EMQX Dashboard
Test-NetConnection -ComputerName localhost -Port 5432  # PostgreSQL

# Ver processos a usar uma porta
netstat -ano | findstr :8501
netstat -ano | findstr :8000
```

## 🧹 Limpeza

```powershell
# Remover containers parados
docker container prune -f

# Remover imagens não utilizadas
docker image prune -a -f

# Remover volumes não utilizados
docker volume prune -f

# Limpeza completa (CUIDADO!)
docker system prune -a --volumes -f

# Remover apenas containers do deploy
docker-compose down
docker-compose rm -f
```

## 📝 Configuração

```powershell
# Editar variáveis de ambiente
notepad .env

# Editar credenciais do Dashboard
notepad credentials.yml

# Editar configuração do Docker Compose
notepad docker-compose.yml

# Aplicar mudanças (reiniciar serviços)
docker-compose down
docker-compose up -d
```

## 🔐 Segurança

```powershell
# Alterar senha do PostgreSQL
# 1. Editar .env
notepad .env
# Alterar: DATABASE_URL=postgresql+asyncpg://hbot:NOVA_SENHA@postgres:5432/hummingbot_api

# 2. Reiniciar
docker-compose down -v
docker-compose up -d

# Ver credenciais configuradas
Get-Content .env | Select-String "USERNAME|PASSWORD"

# Alterar senha do EMQX
# Aceder http://localhost:18083 → Settings → Users
```

## 📱 Acesso aos Serviços

```powershell
# Dashboard
Start-Process http://localhost:8501

# API Documentation
Start-Process http://localhost:8000/docs

# EMQX Dashboard
Start-Process http://localhost:18083

# Conectar ao PostgreSQL (requer psql)
docker exec -it hummingbot-postgres psql -U hbot -d hummingbot_api
```

## 🐛 Troubleshooting Rápido

```powershell
# Dashboard não carrega
docker-compose restart dashboard
docker-compose logs dashboard

# API não responde
docker-compose restart hummingbot-api
docker-compose logs hummingbot-api

# PostgreSQL não inicia
docker-compose down
docker volume rm deploy_postgres-data
docker-compose up -d

# EMQX não acessível
docker-compose restart hummingbot-broker
Start-Sleep -Seconds 10
Start-Process http://localhost:18083

# Bot não aparece no Dashboard
docker-compose restart
docker exec -it hummingbot config mqtt_bridge
```

## 📊 Informações do Sistema

```powershell
# Ver uso de recursos
docker stats --no-stream

# Ver espaço em disco usado
docker system df

# Ver informações do Docker
docker info

# Ver versão do Docker
docker --version
docker-compose --version

# Ver redes Docker
docker network ls

# Ver detalhes de uma rede
docker network inspect deploy_emqx-bridge
```

## 💾 Backup Completo

```powershell
# Criar pasta de backup
New-Item -ItemType Directory -Force -Path ".\backups\$(Get-Date -Format 'yyyy-MM-dd')"

# Backup PostgreSQL
docker exec hummingbot-postgres pg_dump -U hbot hummingbot_api > ".\backups\$(Get-Date -Format 'yyyy-MM-dd')\postgres.sql"

# Backup configurações
Copy-Item .env ".\backups\$(Get-Date -Format 'yyyy-MM-dd')\"
Copy-Item credentials.yml ".\backups\$(Get-Date -Format 'yyyy-MM-dd')\"
Copy-Item -Recurse bots ".\backups\$(Get-Date -Format 'yyyy-MM-dd')\"

# Backup volumes EMQX
docker run --rm -v deploy_emqx-data:/data -v ${PWD}/backups:/backup alpine tar czf /backup/$(Get-Date -Format 'yyyy-MM-dd')/emqx-data.tar.gz /data
```

## 🎯 Aliases Úteis (Opcional)

Adicione ao seu `$PROFILE` do PowerShell:

```powershell
# Editar profile
notepad $PROFILE

# Adicionar aliases
function hbot-start { cd c:\github\hummingbot\deploy; docker-compose up -d }
function hbot-stop { cd c:\github\hummingbot\deploy; docker-compose down }
function hbot-restart { cd c:\github\hummingbot\deploy; docker-compose restart }
function hbot-logs { cd c:\github\hummingbot\deploy; docker-compose logs -f $args }
function hbot-status { cd c:\github\hummingbot\deploy; docker-compose ps }
function hbot-dash { Start-Process http://localhost:8501 }
function hbot-api { Start-Process http://localhost:8000/docs }
function hbot-mqtt { Start-Process http://localhost:18083 }

# Usar aliases
hbot-start    # Iniciar serviços
hbot-dash     # Abrir Dashboard
hbot-logs     # Ver logs
```

---

**Dica**: Marque esta página nos seus favoritos para acesso rápido! 📌
