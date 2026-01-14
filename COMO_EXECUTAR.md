# Guia Rapido: Executar Hummingbot e Conectar ao Dashboard

## 🚀 Passo a Passo Completo

### 1️⃣ Iniciar o Dashboard (Primeiro)

```powershell
cd C:\github\hummingbot\dashboard
docker-compose up -d
```

✅ **Verificar se está rodando:**
```powershell
docker-compose ps
```

✅ **Acessar Dashboard:** http://localhost:8501

---

### 2️⃣ Iniciar o Hummingbot

**Opção A - Usando docker-compose:**
```powershell
cd C:\github\hummingbot\hummingbot-app
docker-compose up
```

**Opção B - Usando o script de instalação:**
```powershell
cd C:\github\hummingbot\hummingbot-app
.\install-docker.ps1
```

**Opção C - Comando direto Docker:**
```powershell
cd C:\github\hummingbot\hummingbot-app

docker run -it --name hummingbot `
  -p 8888:8888 `
  --network host `
  -v ${PWD}/hummingbot_files/conf:/conf `
  -v ${PWD}/hummingbot_files/logs:/logs `
  -v ${PWD}/hummingbot_files/data:/data `
  -v ${PWD}/hummingbot_files/scripts:/scripts `
  hummingbot/hummingbot:latest
```

---

### 3️⃣ Conectar Hummingbot ao Dashboard

**Dentro do terminal do Hummingbot, configure o MQTT:**

```bash
# 1. Configurar MQTT bridge
config mqtt_bridge

# Quando perguntar, responda:
mqtt_bridge >>> Yes

# 2. Configurar host MQTT
config mqtt_host

# Responda:
mqtt_host >>> host.docker.internal

# 3. Configurar porta MQTT
config mqtt_port

# Responda (default):
mqtt_port >>> 1883

# 4. Configurar username (se necessário)
config mqtt_username

# Responda (ou deixe em branco):
mqtt_username >>> 

# 5. Configurar password (se necessário)
config mqtt_password

# Responda (ou deixe em branco):
mqtt_password >>> 

# 6. Salvar configurações
config mqtt_bridge
mqtt_bridge >>> Yes

# 7. Iniciar o gateway
start --script
```

---

### 4️⃣ Verificar Conexão

**No Dashboard (http://localhost:8501):**
1. Vá para a página **"Instances"**
2. Você deve ver seu bot listado
3. Status deve aparecer como **"Connected"** ou **"Running"**

**No Hummingbot CLI:**
```bash
# Ver status
status

# Ver configurações MQTT
config mqtt_bridge
```

---

## 🔄 Comandos de Gerenciamento

### Iniciar/Parar Hummingbot

**Se o container já existe:**
```powershell
# Iniciar
docker start hummingbot
docker attach hummingbot

# Parar (Ctrl+C ou)
docker stop hummingbot

# Ver logs
docker logs hummingbot

# Remover container
docker rm hummingbot
```

### Desconectar sem Parar o Bot

**Dentro do Hummingbot:**
- Pressione: `Ctrl+P` seguido de `Ctrl+Q`

**Para reconectar:**
```powershell
docker attach hummingbot
```

---

## 📊 Estrutura Completa

```
C:\github\hummingbot\
│
├── dashboard/                           # Dashboard Web
│   ├── docker-compose.yml              # (já rodando na porta 8501)
│   └── DASHBOARD_GUIA.md
│
└── hummingbot-app/                     # Hummingbot
    ├── docker-compose.yml              # Configuração Docker
    ├── install-docker.ps1              # Script de instalação
    ├── hummingbot_files/               # Dados persistentes
    │   ├── conf/                       # Configurações e credenciais
    │   ├── logs/                       # Logs do bot
    │   ├── data/                       # Dados históricos
    │   └── scripts/                    # Scripts customizados
    └── COMANDOS_DOCKER.md
```

---

## 🎯 Configuração Rápida - 5 Minutos

### Terminal 1 - Dashboard
```powershell
cd C:\github\hummingbot\dashboard
docker-compose up -d
```
✅ Abra: http://localhost:8501

### Terminal 2 - Hummingbot
```powershell
cd C:\github\hummingbot\hummingbot-app
docker-compose up
```

### Terminal 3 - Dentro do Hummingbot
```bash
# Configurar MQTT
config mqtt_bridge
# Digite: Yes

config mqtt_host
# Digite: host.docker.internal

# Iniciar estratégia (exemplo)
create --strategy pure_market_making

# Configurar parâmetros da estratégia
# Exchange: binance
# Trading pair: BTC-USDT
# Etc...

# Iniciar bot
start
```

---

## 🔧 Troubleshooting

### Bot não aparece no Dashboard

**1. Verificar se MQTT está configurado:**
```bash
config mqtt_bridge
# Deve mostrar: Yes
```

**2. Verificar se Dashboard está rodando:**
```powershell
docker ps | Select-String dashboard
```

**3. Verificar logs do Dashboard:**
```powershell
cd C:\github\hummingbot\dashboard
docker-compose logs -f
```

**4. Reiniciar ambos:**
```powershell
# Dashboard
cd C:\github\hummingbot\dashboard
docker-compose restart

# Hummingbot
docker restart hummingbot
```

### Erro de conexão MQTT

**Usar IP do Docker Desktop:**
```bash
config mqtt_host
# Tente: 172.17.0.1 ou host.docker.internal
```

**Verificar portas:**
```powershell
# Verificar se porta 1883 está aberta
docker ps -a
```

---

## 📝 Comandos Úteis Hummingbot

```bash
# Ver estratégias disponíveis
list

# Criar nova estratégia
create

# Iniciar bot
start

# Parar bot
stop

# Ver status
status

# Ver histórico de trades
history

# Ver balanço
balance

# Ver configurações
config

# Limpar terminal
clear

# Sair
exit
```

---

## 🎓 Primeira Estratégia Recomendada

### Pure Market Making no Binance (Paper Trading)

```bash
# 1. Criar estratégia
create

# 2. Escolher tipo
Strategy: pure_market_making

# 3. Configurar
Exchange: binance_paper_trade
Trading pair: BTC-USDT
Bid spread: 0.5
Ask spread: 0.5
Order amount: 0.001
Order refresh time: 30

# 4. Iniciar
start
```

Agora você verá tudo funcionando no Dashboard! 🎉

---

## ✅ Checklist de Verificação

- [ ] Dashboard rodando (http://localhost:8501)
- [ ] Hummingbot rodando
- [ ] MQTT configurado no Hummingbot
- [ ] Bot aparece na página "Instances" do Dashboard
- [ ] Status mostra "Connected"
- [ ] Estratégia criada e iniciada
- [ ] Trades aparecendo no Dashboard

---

**Pronto para trading!** 🚀

URLs Importantes:
- Dashboard: http://localhost:8501
- Documentação: https://docs.hummingbot.org/
- Discord: https://discord.gg/hummingbot
