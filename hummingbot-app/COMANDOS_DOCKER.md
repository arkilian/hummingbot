# Comandos Docker para Hummingbot - Manual Rapido

## Problema: Docker nao reconhecido no PowerShell

Se voce tem Docker Desktop instalado mas o comando 'docker' nao funciona:

### Solucao 1: Reiniciar Terminal
1. Feche TODOS os terminais PowerShell
2. Abra um NOVO terminal PowerShell
3. Execute: `docker --version`

### Solucao 2: Reiniciar Docker Desktop
1. Abra Docker Desktop (procure no menu Iniciar)
2. Aguarde ate o icone ficar verde
3. Abra um novo terminal PowerShell
4. Execute: `docker --version`

### Solucao 3: Adicionar ao PATH manualmente
Execute no PowerShell como Administrador:
```powershell
$env:Path += ";C:\Program Files\Docker\Docker\resources\bin"
docker --version
```

---

## Comandos Manuais para Instalar Hummingbot

### Passo 1: Criar pastas
```powershell
cd C:\github\hummingbot\hummingbot-app
mkdir hummingbot_files
mkdir hummingbot_files\conf
mkdir hummingbot_files\logs
mkdir hummingbot_files\data
mkdir hummingbot_files\scripts
```

### Passo 2: Baixar imagem
```powershell
docker pull hummingbot/hummingbot:latest
```

### Passo 3: Iniciar Hummingbot
```powershell
cd C:\github\hummingbot\hummingbot-app

docker run -it --name hummingbot --mount "type=bind,source=$PWD\hummingbot_files\conf,destination=/conf" --mount "type=bind,source=$PWD\hummingbot_files\logs,destination=/logs" --mount "type=bind,source=$PWD\hummingbot_files\data,destination=/data" --mount "type=bind,source=$PWD\hummingbot_files\scripts,destination=/scripts" hummingbot/hummingbot:latest
```

---

## Comandos Uteis Apos Instalacao

### Iniciar container existente
```powershell
docker start hummingbot
docker attach hummingbot
```

### Ver containers
```powershell
docker ps -a
```

### Ver logs
```powershell
docker logs hummingbot
```

### Parar container
```powershell
docker stop hummingbot
```

### Remover container (dados ficam salvos em hummingbot_files)
```powershell
docker rm hummingbot
```

### Atualizar Hummingbot
```powershell
docker stop hummingbot
docker rm hummingbot
docker pull hummingbot/hummingbot:latest
# Executar comando do Passo 3 novamente
```

---

## Desconectar sem Parar o Bot

Quando estiver dentro do Hummingbot e quiser desconectar SEM parar o bot:
- Pressione: `Ctrl + P`, depois `Ctrl + Q`

Para reconectar:
```powershell
docker attach hummingbot
```

---

## Alternativa: Docker Compose

Se preferir usar docker-compose:

1. Ja existe o arquivo `docker-compose.yml` criado
2. Execute:
```powershell
cd C:\github\hummingbot\hummingbot-app
docker-compose up
```

3. Para parar:
```powershell
docker-compose down
```

---

## Verificar se Docker esta funcionando

```powershell
# Ver versao
docker --version

# Ver informacoes
docker info

# Testar com container hello-world
docker run hello-world
```

Se ainda nao funcionar, reinicie o computador apos instalar o Docker Desktop.
