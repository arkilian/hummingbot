# 🚀 Guia Completo de Instalação do Hummingbot com Dashboard

Este guia explica como instalar e configurar o Hummingbot com Dashboard usando o **repositório oficial Deploy**.

## 📋 Pré-requisitos

- **Docker Desktop** instalado e em execução
- **Windows 10/11** com WSL2 (para Docker)
- **Git** instalado

## 🎯 Arquitetura do Sistema

O sistema completo inclui 4 componentes principais:

1. **Dashboard** (porta 8501) - Interface web Streamlit para gestão de bots
2. **Hummingbot API** (porta 8000) - Backend FastAPI para operações de bots
3. **PostgreSQL** (porta 5432) - Armazenamento persistente de dados
4. **EMQX Broker** (porta 1883) - Broker MQTT para comunicação em tempo real

Todos os serviços são orquestrados com Docker Compose.

## 📥 Instalação

### 1. Clonar o Repositório Deploy

```powershell
cd c:\github\hummingbot
git clone https://github.com/hummingbot/deploy.git
cd deploy
```

### 2. Configurar e Iniciar os Serviços

#### Opção A: Usar o Script PowerShell (Recomendado)

```powershell
.\setup.ps1
```

O script irá solicitar:
- **Config password**: Senha para configuração (padrão: `admin`)
- **Dashboard username**: Nome de usuário (padrão: `admin`)
- **Dashboard password**: Senha do dashboard (padrão: `admin`)

#### Opção B: Configuração Manual

1. **Criar arquivo `.env`** com o seguinte conteúdo:

```env
# Dashboard credentials
USERNAME=admin
PASSWORD=admin
CONFIG_PASSWORD=admin

# Bot paths
BOTS_PATH=.

# Debug settings
DEBUG_MODE=false

# MQTT Broker settings
BROKER_HOST=emqx
BROKER_PORT=1883
BROKER_USERNAME=admin
BROKER_PASSWORD=public

# Database settings
DATABASE_URL=postgresql+asyncpg://hbot:hummingbot-api@postgres:5432/hummingbot_api

# Feed and cleanup settings
CLEANUP_INTERVAL=300
FEED_TIMEOUT=600

# Logging
LOGFIRE_ENV=prod

# Banned tokens
BANNED_TOKENS=["NAV","ARS","ETHW","ETHF","NEWT"]
```

2. **Iniciar os serviços**:

```powershell
docker-compose up -d
```

### 3. Verificar Status dos Containers

```powershell
docker ps
```

Deve ver 4 containers rodando:
- `dashboard`
- `hummingbot-api`
- `hummingbot-broker` (EMQX)
- `hummingbot-postgres`

## 🌐 Acesso aos Serviços

### Dashboard Principal
- **URL**: http://localhost:8501
- **Credenciais**: `admin` / `admin` (se autenticação ativada)
- **Função**: Criar, configurar e monitorar bots de trading

### API do Hummingbot
- **URL**: http://localhost:8000/docs
- **Credenciais**: `admin` / `admin`
- **Função**: Documentação interativa da API (Swagger)

### EMQX Broker (MQTT)
- **URL**: http://localhost:18083
- **Credenciais**: `admin` / `public`
- **Função**: Monitorar mensagens MQTT em tempo real

### PostgreSQL Database
- **Host**: `localhost:5432`
- **Database**: `hummingbot_api`
- **Usuário**: `hbot`
- **Senha**: `hummingbot-api`

## 🤖 Criar e Executar um Bot Hummingbot

### 1. Adicionar Credenciais da Exchange

1. Aceda ao Dashboard: http://localhost:8501
2. Vá para a página **Credentials**
3. Selecione a exchange (ex: Binance)
4. Adicione **API Key** e **Secret**
5. Clique em **Save**

### 2. Criar uma Configuração de Estratégia

1. Vá para a página da estratégia (ex: **PMM Simple**)
2. Configure os parâmetros:
   - Exchange
   - Par de trading (ex: BTC-USDT)
   - Spread
   - Quantidades
3. Clique em **Save Configuration**

### 3. Deploy do Bot

1. Vá para a página **Deploy**
2. Preencha:
   - **Bot Name**: Nome único (ex: `bot-btc-usdt`)
   - **Image**: `hummingbot/hummingbot:latest`
   - **Credentials Profile**: Selecione a conta criada
   - **Config**: Selecione a configuração criada
3. Clique em **Deploy**

### 4. Monitorar o Bot

1. Vá para a página **Instances**
2. Veja o status do bot:
   - **Starting**: Bot a iniciar (aguarde alguns segundos)
   - **Running**: Bot em execução
   - **Stopped**: Bot parado (verifique logs se não esperado)
3. Clique no bot para ver:
   - Performance em tempo real
   - Gráficos de P&L
   - Ordens ativas
   - Histórico de trades

## 🔗 Conectar Bot Hummingbot Existente ao Dashboard

Se já tem um bot Hummingbot rodando separadamente, pode conectá-lo ao Dashboard:

### 1. Aceder ao Container do Bot

```powershell
docker exec -it hummingbot bash
```

### 2. Configurar MQTT

Dentro do container do Hummingbot:

```bash
config mqtt_bridge
```

Responda as perguntas:

```
mqtt_host: host.docker.internal
mqtt_port: 1883
mqtt_username: (deixe vazio)
mqtt_password: (deixe vazio)
mqtt_namespace: hbot
mqtt_ssl: False
mqtt_logger: True
mqtt_notifier: True
mqtt_commands: True
```

### 3. Reiniciar o Bot

```bash
exit
start
```

O bot agora estará conectado ao Dashboard via MQTT.

## 🛠️ Comandos Úteis

### Gerir Containers

```powershell
# Ver logs de todos os serviços
docker-compose logs -f

# Ver logs de um serviço específico
docker-compose logs -f dashboard
docker-compose logs -f hummingbot-api

# Parar todos os serviços
docker-compose down

# Parar e remover volumes (CUIDADO: remove dados)
docker-compose down -v

# Reiniciar um serviço
docker-compose restart dashboard

# Ver status
docker-compose ps
```

### Atualizar Imagens

```powershell
# Parar serviços
docker-compose down

# Atualizar imagens
docker-compose pull

# Reiniciar serviços
docker-compose up -d
```

## 🔧 Troubleshooting

### Dashboard não conecta à API

**Sintoma**: Erro "Cannot connect to host backend-api:8000"

**Solução**:
1. Verifique se todos os containers estão rodando:
   ```powershell
   docker ps
   ```
2. Verifique logs da API:
   ```powershell
   docker-compose logs hummingbot-api
   ```
3. Teste a API manualmente:
   ```powershell
   curl http://localhost:8000/docker/running -u admin:admin
   ```

### PostgreSQL não inicia

**Sintoma**: Container `hummingbot-postgres` em estado "Restarting"

**Solução**:
1. Verifique logs:
   ```powershell
   docker-compose logs hummingbot-postgres
   ```
2. Verifique se a porta 5432 não está ocupada:
   ```powershell
   netstat -ano | findstr :5432
   ```

### EMQX não acessível

**Sintoma**: http://localhost:18083 não carrega

**Solução**:
1. Verifique se o container está "healthy":
   ```powershell
   docker ps
   ```
2. Aguarde alguns segundos após o início
3. Verifique logs:
   ```powershell
   docker-compose logs hummingbot-broker
   ```

### Bot não aparece no Dashboard

**Sintoma**: Bot criado mas não aparece em "Instances"

**Solução**:
1. Verifique se o bot está rodando:
   ```powershell
   docker ps
   ```
2. Verifique se o MQTT está configurado corretamente no bot
3. Refresque a página do Dashboard (F5)

## 📚 Recursos Adicionais

- **Documentação Oficial**: https://hummingbot.org/dashboard/
- **GitHub Dashboard**: https://github.com/hummingbot/dashboard
- **GitHub Deploy**: https://github.com/hummingbot/deploy
- **GitHub Hummingbot**: https://github.com/hummingbot/hummingbot
- **Discord Community**: https://discord.gg/hummingbot

## 🔐 Segurança

### Alterar Credenciais Padrão

É **altamente recomendado** alterar as credenciais padrão:

1. **Edite o arquivo `.env`**:
   ```env
   USERNAME=seu_usuario_forte
   PASSWORD=sua_senha_forte
   CONFIG_PASSWORD=sua_config_senha_forte
   ```

2. **Edite `credentials.yml`** para autenticação do Dashboard:
   ```yaml
   credentials:
     usernames:
       seu_usuario:
         email: seu@email.com
         name: Seu Nome
         password: sua_senha_forte
   ```

3. **Reinicie os serviços**:
   ```powershell
   docker-compose down
   docker-compose up -d
   ```

### Ativar Autenticação do Dashboard

Por padrão, a autenticação está **desativada**. Para ativar:

1. **Edite `docker-compose.yml`**:
   ```yaml
   dashboard:
     environment:
       - AUTH_SYSTEM_ENABLED=True
   ```

2. **Reinicie**:
   ```powershell
   docker-compose restart dashboard
   ```

## ✅ Checklist de Instalação

- [ ] Docker Desktop instalado e rodando
- [ ] Repositório `deploy` clonado
- [ ] Arquivo `.env` criado
- [ ] Containers iniciados (`docker-compose up -d`)
- [ ] Dashboard acessível em http://localhost:8501
- [ ] API acessível em http://localhost:8000/docs
- [ ] EMQX acessível em http://localhost:18083
- [ ] Credenciais padrão alteradas (recomendado)
- [ ] Credenciais da exchange adicionadas
- [ ] Primeiro bot criado e em execução

## 🎉 Próximos Passos

1. **Explorar estratégias disponíveis** no Dashboard
2. **Fazer backtesting** de estratégias com dados históricos
3. **Otimizar parâmetros** usando a funcionalidade de otimização
4. **Monitorar performance** dos bots em tempo real
5. **Configurar notificações** (Telegram, Discord, etc.)

---

**Nota**: Este guia usa o repositório oficial **Deploy** recomendado pela equipe do Hummingbot, que garante compatibilidade entre todos os componentes.
