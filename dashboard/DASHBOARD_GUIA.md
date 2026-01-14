# Hummingbot Dashboard - Guia Completo

## 📊 Visão Geral

O Hummingbot Dashboard é uma interface web moderna e completa para monitorar, gerenciar e otimizar seus bots de trading. Construído com Streamlit, oferece visualizações avançadas e controle centralizado de múltiplas instâncias do Hummingbot.

**Localização:** `C:\github\hummingbot\dashboard`
**URL de Acesso:** http://localhost:8501

---

## 🚀 Iniciando o Dashboard

### Iniciar Dashboard
```powershell
cd C:\github\hummingbot\dashboard
docker-compose up -d
```

### Parar Dashboard
```powershell
docker-compose down
```

### Ver Logs
```powershell
docker-compose logs -f
```

### Reiniciar Dashboard
```powershell
docker-compose restart
```

---

## 🔗 Conectar Hummingbot ao Dashboard

### Passo 1: Configurar Broker MQTT

O Dashboard usa MQTT para comunicação. Você precisa conectar suas instâncias do Hummingbot ao broker MQTT do dashboard.

**No Hummingbot CLI:**

```bash
# Configurar gateway (MQTT bridge)
config mqtt_bridge

# Configurar host MQTT
mqtt_host: host.docker.internal

# Configurar porta MQTT
mqtt_port: 1883

# Configurar username (se configurado)
mqtt_username: seu_usuario

# Configurar password (se configurado)
mqtt_password: sua_senha

# Habilitar
mqtt_bridge: true
```

### Passo 2: Iniciar Gateway

Dentro do Hummingbot:
```bash
gateway start
```

### Passo 3: Configurar Credenciais (Opcional)

No Dashboard, vá em **Settings** e configure as credenciais MQTT se necessário.

---

## 📱 Principais Funcionalidades

### 1. **Dashboard Principal (Home)**
- Visão geral de todas as instâncias ativas
- Performance em tempo real
- Status de conexão
- P&L total e por instância

### 2. **Instances (Instâncias)**
- Gerenciar múltiplas instâncias do Hummingbot
- Ver status e estatísticas de cada bot
- Iniciar/Parar bots remotamente
- Configurar novas instâncias

### 3. **Strategies (Estratégias)**
- Visualizar estratégias ativas
- Monitorar performance de cada estratégia
- Comparar diferentes configurações
- Backtesting e otimização

### 4. **Performance Analytics**
- Gráficos de P&L ao longo do tempo
- Análise de win rate
- Volume de trading
- Sharpe ratio e métricas avançadas
- Drawdown analysis

### 5. **Order Management**
- Ver todas as ordens ativas
- Histórico de ordens executadas
- Cancelar ordens em massa
- Filtros por exchange/par

### 6. **Market Data**
- Visualização de order books
- Gráficos de preço em tempo real
- Análise de spread
- Volume e liquidez

### 7. **Backtesting**
- Testar estratégias com dados históricos
- Otimizar parâmetros
- Comparar diferentes configurações
- Gerar relatórios detalhados

### 8. **Settings (Configurações)**
- Configurar credenciais de exchanges
- Gerenciar API keys
- Configurar MQTT broker
- Personalizar dashboard

---

## 🔧 Estrutura de Arquivos

```
C:\github\hummingbot\dashboard\
├── docker-compose.yml          # Configuração Docker
├── credentials.yml             # Credenciais (não commitar!)
├── data/                       # Dados persistentes
│   ├── backtesting/           # Resultados de backtests
│   ├── configs/               # Configurações salvas
│   └── logs/                  # Logs do dashboard
├── pages/                     # Páginas do Streamlit
│   ├── 1_instances.py
│   ├── 2_strategies.py
│   ├── 3_performance.py
│   └── ...
└── utils/                     # Utilitários e helpers
```

---

## 🔐 Configurando Credenciais

### Criar arquivo credentials.yml

```yaml
# C:\github\hummingbot\dashboard\credentials.yml

mqtt:
  host: localhost
  port: 1883
  username: admin
  password: admin123

exchanges:
  binance:
    api_key: "sua_api_key"
    api_secret: "sua_secret_key"
  
  coinbase:
    api_key: "sua_api_key"
    api_secret: "sua_secret_key"
    passphrase: "sua_passphrase"

# Telegram notifications (opcional)
telegram:
  token: "seu_bot_token"
  chat_id: "seu_chat_id"
```

**⚠️ IMPORTANTE:** Nunca faça commit de `credentials.yml`!

---

## 📊 Conectar Múltiplas Instâncias

### Cenário: 3 Bots de Trading

**Bot 1 - Binance BTC/USDT:**
```powershell
docker run -it --name hummingbot-btc `
  -p 8888:8888 `
  -v ${PWD}/hummingbot_files/bot1:/conf `
  hummingbot/hummingbot:latest
```

**Bot 2 - Binance ETH/USDT:**
```powershell
docker run -it --name hummingbot-eth `
  -p 8889:8888 `
  -v ${PWD}/hummingbot_files/bot2:/conf `
  hummingbot/hummingbot:latest
```

**Bot 3 - Coinbase:**
```powershell
docker run -it --name hummingbot-coinbase `
  -p 8890:8888 `
  -v ${PWD}/hummingbot_files/bot3:/conf `
  hummingbot/hummingbot:latest
```

Todos aparecerão no Dashboard se configurados com o mesmo MQTT broker.

---

## 📈 Backtesting com Dashboard

### 1. Preparar Dados Históricos

```powershell
# Baixar dados de mercado
cd C:\github\hummingbot\dashboard
docker-compose exec dashboard python utils/download_candles.py --exchange binance --pair BTC-USDT --start 2024-01-01 --end 2024-12-31
```

### 2. Configurar Estratégia

No Dashboard, vá em **Backtesting** > **New Backtest**:
- Escolha estratégia (Pure Market Making, Avellaneda, etc.)
- Configure parâmetros
- Selecione período
- Execute

### 3. Analisar Resultados

O Dashboard mostrará:
- P&L total e por período
- Win rate
- Max drawdown
- Sharpe ratio
- Número de trades
- Gráficos detalhados

---

## 🎨 Personalizando o Dashboard

### Modificar docker-compose.yml

```yaml
version: "3.9"

services:
  dashboard:
    image: hummingbot/dashboard:latest
    container_name: hummingbot-dashboard
    ports:
      - "8501:8501"    # Dashboard web
      - "1883:1883"    # MQTT broker
    volumes:
      - ./data:/home/dashboard/data
      - ./credentials.yml:/home/dashboard/credentials.yml
    environment:
      - STREAMLIT_SERVER_PORT=8501
      - STREAMLIT_SERVER_ADDRESS=0.0.0.0
      - MQTT_HOST=localhost
      - MQTT_PORT=1883
    restart: unless-stopped
```

### Alterar Porta do Dashboard

```yaml
ports:
  - "8080:8501"  # Acessar em http://localhost:8080
```

---

## 🔔 Configurar Notificações

### Telegram

1. Crie um bot no Telegram com @BotFather
2. Obtenha o token do bot
3. Obtenha seu chat_id
4. Configure em `credentials.yml`:

```yaml
telegram:
  token: "123456789:ABCdefGHIjklMNOpqrsTUVwxyz"
  chat_id: "987654321"
  
  # Configurar alertas
  alerts:
    - type: pnl_threshold
      value: -100  # Alerta se P&L < -100 USDT
    - type: balance_low
      value: 50    # Alerta se balance < 50 USDT
    - type: order_filled
      enabled: true
```

### Email

```yaml
email:
  smtp_host: smtp.gmail.com
  smtp_port: 587
  username: seu_email@gmail.com
  password: sua_senha_app
  to: destino@example.com
```

---

## 🛠️ Troubleshooting

### Dashboard não inicia

```powershell
# Ver logs
docker-compose logs

# Reiniciar
docker-compose restart

# Rebuild
docker-compose up --build
```

### Hummingbot não conecta ao Dashboard

1. Verificar se MQTT broker está rodando:
```powershell
docker-compose ps
```

2. Testar conexão MQTT:
```powershell
# Instalar mosquitto client
docker run -it --rm eclipse-mosquitto mosquitto_sub -h host.docker.internal -p 1883 -t test
```

3. Verificar configuração no Hummingbot:
```bash
config mqtt_bridge
```

### Dashboard lento

1. Reduzir frequência de atualização:
   - Settings > Update Interval > 5000ms

2. Limpar cache:
   - Settings > Clear Cache

3. Aumentar recursos do Docker:
   - Docker Desktop > Settings > Resources
   - Aumentar Memory/CPU

---

## 📊 Métricas Disponíveis

### Performance Metrics
- **Total P&L:** Lucro/Prejuízo total
- **ROI:** Return on Investment
- **Win Rate:** % de trades lucrativos
- **Sharpe Ratio:** Retorno ajustado ao risco
- **Max Drawdown:** Maior queda de equity
- **Profit Factor:** Lucros / Prejuízos

### Trading Metrics
- **Total Trades:** Número de trades executados
- **Avg Trade Duration:** Duração média de trades
- **Trades per Day:** Frequência de trading
- **Volume Traded:** Volume total negociado

### Risk Metrics
- **Volatility:** Volatilidade dos retornos
- **Value at Risk (VaR):** Perda máxima esperada
- **Max Position Size:** Maior posição aberta
- **Avg Spread Captured:** Spread médio capturado

---

## 🚀 Features Avançadas

### 1. Strategy Optimizer

Otimizar parâmetros automaticamente:
- Grid search
- Bayesian optimization
- Walk-forward analysis

### 2. Multi-Exchange Arbitrage

Monitorar oportunidades de arbitragem:
- Cross-exchange spreads
- Triangular arbitrage
- Funding rate arbitrage

### 3. Portfolio Management

Gerenciar múltiplos pares e exchanges:
- Rebalancing automático
- Risk allocation
- Correlation analysis

### 4. Custom Scripts

Executar scripts Python personalizados:
- Custom indicators
- Advanced strategies
- Automated reporting

---

## 📚 Recursos Adicionais

### Documentação Oficial
- GitHub: https://github.com/hummingbot/dashboard
- Docs: https://docs.hummingbot.org/dashboard/

### Comunidade
- Discord: https://discord.gg/hummingbot
- Forum: https://community.hummingbot.org/

### Tutoriais
- YouTube: https://www.youtube.com/c/HummingbotIO
- Blog: https://blog.hummingbot.org/

---

## ✅ Checklist de Configuração

- [ ] Dashboard instalado e rodando
- [ ] MQTT broker configurado
- [ ] Hummingbot conectado ao dashboard
- [ ] Credenciais de exchanges configuradas
- [ ] Notificações configuradas (opcional)
- [ ] Primeira instância visível no dashboard
- [ ] Backtesting testado
- [ ] Performance metrics funcionando
- [ ] Backup de configurações feito

---

## 🔄 Atualizando o Dashboard

```powershell
cd C:\github\hummingbot\dashboard

# Parar dashboard
docker-compose down

# Atualizar código
git pull origin main

# Atualizar imagem Docker
docker-compose pull

# Reiniciar
docker-compose up -d
```

---

## 💾 Backup e Restauração

### Backup
```powershell
# Backup de dados
cd C:\github\hummingbot\dashboard
Copy-Item -Recurse data data_backup_$(Get-Date -Format 'yyyyMMdd')

# Backup de credenciais
Copy-Item credentials.yml credentials_backup.yml
```

### Restauração
```powershell
# Restaurar dados
Copy-Item -Recurse data_backup_20260114 data

# Restaurar credenciais
Copy-Item credentials_backup.yml credentials.yml
```

---

**Status:** ✅ Dashboard instalado e pronto para uso!
**Acesso:** http://localhost:8501
**Documentação completa:** https://docs.hummingbot.org/dashboard/
