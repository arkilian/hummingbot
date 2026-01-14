# Guia de Configuração do Hummingbot

## 🎯 Configuração Inicial

Após a instalação ser concluída, siga estes passos:

### 1. Ativar o Ambiente Virtual

**Windows (PowerShell):**
```powershell
cd "C:\github\hummingbot\hummingbot-app\hummingbot"
.\venv\Scripts\Activate.ps1
```

**Windows (CMD):**
```cmd
cd "C:\github\hummingbot\hummingbot-app\hummingbot"
.\venv\Scripts\activate.bat
```

**Linux/macOS:**
```bash
cd c/github/hummingbot/hummingbot-app/hummingbot
source ./venv/bin/activate
```

### 2. Iniciar o Hummingbot

```bash
hummingbot
```

Na primeira execução, você será solicitado a:
- **Criar uma senha:** Será usada para proteger suas configurações e API keys
- **Escolher connector:** Exchange que deseja usar (Binance, Coinbase, Kraken, etc.)
- **Configurar estratégia:** Selecionar estratégia de trading (Pure Market Making, etc.)

### 3. Configurar Manualmente (Opcional)

Para configurar manualmente:

```bash
hummingbot configure
```

## 📋 Estratégias Disponíveis

### V1 (Legacy - Monolíticas)
- **pure_market_making** - Market making puro
- **avellaneda_market_making** - Modelo matemático avançado
- **cross_exchange_market_making** - Arbitragem entre exchanges
- **liquidity_mining** - Provisão de liquidez

### V2 (Moderno - Recomendado)
- Controllers e Executors modulares
- Scripts Python personalizadas
- Mais flexível e testável

## 🔐 Gerenciamento de Credenciais

### Armazenar API Keys com Segurança

1. **No Hummingbot:**
```bash
hummingbot
```
Quando solicitado, insira suas API keys. Serão criptografadas e armazenadas localmente.

2. **Arquivo de Configuração:**
O Hummingbot armazena credenciais em:
```
~/.hummingbot/conf/
```

### Boas Práticas de Segurança

✅ **Faça:**
- Use API keys com permissões restringidas
- Ative 2FA na sua exchange
- Guarde senhas em local seguro
- Faça backup de configurações

❌ **Não faça:**
- Compartilhe API keys
- Commite credenciais ao git
- Use senhas fracas
- Deixe bot rodando sem monitoramento

## 🧪 Testes Antes de Trading Ao Vivo

### 1. Paper Trading (Simulação)

```bash
hummingbot --strategy pure_market_making --paper-trade
```

Executa a estratégia com preços reais mas sem fazer trades reais.

### 2. Backtesting

```bash
hummingbot --strategy pure_market_making --backtest
```

Testa a estratégia com dados históricos para validar performance.

### 3. Modo Debug

```bash
hummingbot --debug
```

Ativa logs detalhados para diagnóstico.

## 📊 Monitoramento

### Verificar Logs

Os logs são salvos em:
```
./logs/
```

Para monitorar em tempo real:
```bash
tail -f logs/hummingbot_logs.log
```

### Dashboard Web (se disponível)

Algumas versões incluem um dashboard em:
```
http://localhost:8888
```

## ⚙️ Arquivos de Configuração Importantes

```
~/.hummingbot/
├── conf/
│   ├── connectors/          # Configurações de exchange
│   ├── strategies/          # Configurações de estratégia
│   └── global_config.yml    # Configurações globais
├── logs/                    # Arquivos de log
├── data/                    # Dados históricos
└── wallet/                  # Informações de carteira (se aplicável)
```

## 🚀 Iniciando Seu Primeiro Bot

### Exemplo: Pure Market Making na Binance

1. **Ativar ambiente:**
```powershell
.\venv\Scripts\Activate.ps1
```

2. **Iniciar Hummingbot:**
```bash
hummingbot
```

3. **Configurar:**
- Senha: Digite uma senha forte
- Connector: Escolha "binance"
- Estratégia: Escolha "pure_market_making"
- Parâmetros:
  - Trading pair: BTC-USDT
  - Bid spread: 0.1%
  - Ask spread: 0.1%
  - Order amount: 0.001 BTC
  - Order refresh interval: 30s

4. **Importe API Keys da Binance:**
```
API Key: [sua_api_key]
Secret Key: [sua_secret_key]
```

5. **Escolha modo:**
- Paper Trade (simular)
- Live Trade (real)

## 📈 Ajustes de Performance

### Aumentar Velocidade de Refresh
```yaml
order_refresh_interval: 10  # segundos
```

### Aumentar Spread para Mais Lucro
```yaml
bid_spread: 0.5  # 0.5% bid
ask_spread: 0.5  # 0.5% ask
```

### Limitar Exposição
```yaml
order_amount: 0.01  # tamanho mínimo
max_order_age: 3600  # 1 hora máximo
```

## 🆘 Troubleshooting

### Erro: "Module not found"
```powershell
pip install -e . --no-build-isolation
```

### Erro: "API connection failed"
- Verifique API keys
- Verifique rede/firewall
- Verifique IP whitelist na exchange

### Erro: "Insufficient balance"
- Verifique saldo na exchange
- Verifique permissões de API

### Bot não coloca ordens
- Verifique se está em Paper Trading
- Verifique parâmetros de estratégia
- Verifique logs para detalhes

## 📚 Recursos Adicionais

- **Documentação:** https://hummingbot.org/docs/
- **GitHub:** https://github.com/hummingbot/hummingbot
- **Discord:** https://discord.gg/hummingbot
- **Tutorials:** https://www.youtube.com/c/HummingbotIO
- **Botcamp:** Cursos profissionais

## ✅ Checklist de Início

- [ ] Ambiente virtual ativado
- [ ] Hummingbot instalado com sucesso
- [ ] Versão verificada (`hummingbot --version`)
- [ ] API keys obtidas da exchange
- [ ] Configuração criada
- [ ] Paper trading testado
- [ ] Backtesting executado
- [ ] Modo live habilitado (com cuidado!)
- [ ] Monitoramento configurado
- [ ] Backup de configurações feito

---

**Pronto!** Seu Hummingbot está pronto para usar! 🚀
