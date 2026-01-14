# 🐳 Instalação do Hummingbot via Docker (Recomendado)

## ⚠️ Problema com Compilação no Windows

A instalação direta no Windows está falhando devido a:
- **Compilador C++ antigo** (MSVC 2017 sem suporte adequado a C++17)
- **Dependências de compilação** complexas (Cython extensions)

## ✅ Solução Recomendada: Docker

Docker é o método **oficial e recomendado** pelo Hummingbot para Windows. Vantagens:

✅ Sem problemas de compilação  
✅ Ambiente isolado e seguro  
✅ Fácil atualização  
✅ Mesma configuração em todos os sistemas  
✅ Não requer Visual Studio Build Tools

---

## 📋 Pré-requisitos

1. **Docker Desktop para Windows**
   - Download: https://www.docker.com/products/docker-desktop
   - Instale e reinicie o computador se solicitado

2. **Verificar instalação:**
   ```powershell
   docker --version
   docker-compose --version
   ```

---

## 🚀 Instalação Rápida com Docker

### Método 1: Usando Docker Run (Simples)

```powershell
# Navegar até a pasta do projeto
cd C:\github\hummingbot\hummingbot-app

# Criar pasta para dados persistentes
mkdir hummingbot_files

# Executar Hummingbot
docker run -it `
  --name hummingbot-instance `
  --mount "type=bind,source=$(pwd)/hummingbot_files,destination=/conf" `
  --network=host `
  hummingbot/hummingbot:latest
```

### Método 2: Usando Docker Compose (Recomendado)

1. **Criar arquivo docker-compose.yml:**

```yaml
version: "3.9"

services:
  hummingbot:
    image: hummingbot/hummingbot:latest
    container_name: hummingbot
    stdin_open: true
    tty: true
    volumes:
      - ./hummingbot_files/conf:/conf
      - ./hummingbot_files/logs:/logs
      - ./hummingbot_files/data:/data
      - ./hummingbot_files/scripts:/scripts
    environment:
      - CONFIG_PASSWORD=${CONFIG_PASSWORD}
    networks:
      - hummingbot-net

networks:
  hummingbot-net:
    driver: bridge
```

2. **Iniciar o container:**

```powershell
cd C:\github\hummingbot\hummingbot-app
docker-compose up -d
```

3. **Conectar ao Hummingbot:**

```powershell
docker attach hummingbot
```

---

## 🎮 Comandos Úteis do Docker

### Gerenciar Container

```powershell
# Iniciar container
docker start hummingbot-instance

# Parar container
docker stop hummingbot-instance

# Conectar ao container em execução
docker attach hummingbot-instance

# Desconectar sem parar (Ctrl+P, Ctrl+Q)

# Ver logs
docker logs hummingbot-instance

# Remover container
docker rm hummingbot-instance
```

### Atualizar Hummingbot

```powershell
# Parar container
docker stop hummingbot-instance

# Baixar versão mais recente
docker pull hummingbot/hummingbot:latest

# Remover container antigo (dados ficam salvos)
docker rm hummingbot-instance

# Criar novo container com imagem atualizada
docker run -it `
  --name hummingbot-instance `
  --mount "type=bind,source=$(pwd)/hummingbot_files,destination=/conf" `
  hummingbot/hummingbot:latest
```

---

## 📂 Estrutura de Pastas

```
C:\github\hummingbot\hummingbot-app\
├── docker-compose.yml          (configuração Docker)
├── hummingbot_files/           (dados persistentes)
│   ├── conf/                   (configurações e credenciais)
│   ├── logs/                   (arquivos de log)
│   ├── data/                   (dados históricos)
│   └── scripts/                (estratégias personalizadas)
```

Seus dados ficam salvos em `hummingbot_files/` mesmo se deletar o container.

---

## 🔐 Configuração Inicial

Quando iniciar o Hummingbot pela primeira vez:

1. **Criar senha:**
   ```
   Enter your new password: ********
   Please reenter your password: ********
   ```

2. **Escolher connector (exchange):**
   ```
   What is your preferred connector? >>> binance
   ```

3. **Inserir API keys:**
   ```
   Enter your Binance API key >>> [sua_api_key]
   Enter your Binance secret key >>> [sua_secret_key]
   ```

4. **Configurar estratégia:**
   ```
   What is your market making strategy? >>> pure_market_making
   ```

---

## 🛠️ Desenvolvimento com Docker

### Montar código local (para desenvolvimento):

```powershell
docker run -it `
  --name hummingbot-dev `
  --mount "type=bind,source=C:\github\hummingbot\hummingbot-app\hummingbot,destination=/hummingbot" `
  --mount "type=bind,source=$(pwd)/hummingbot_files,destination=/conf" `
  hummingbot/hummingbot:latest
```

### Usar imagem de desenvolvimento:

```powershell
docker run -it `
  --name hummingbot-dev `
  hummingbot/hummingbot:development
```

---

## 🆘 Troubleshooting Docker

### Container não inicia

```powershell
# Ver logs de erro
docker logs hummingbot-instance

# Verificar status
docker ps -a

# Reiniciar Docker Desktop
```

### Permissões de arquivo

```powershell
# Windows: Compartilhar drive com Docker
# Docker Desktop → Settings → Resources → File Sharing
```

### Porta já em uso

```powershell
# Ver processos usando porta
netstat -ano | findstr :8080

# Mudar porta no docker-compose.yml
ports:
  - "8081:8080"
```

---

## 📊 Monitoramento

### Dashboard Web (opcional)

```yaml
# Adicionar ao docker-compose.yml
services:
  hummingbot:
    # ... configuração existente
    ports:
      - "8888:8888"
```

Acesse: http://localhost:8888

---

## 🔄 Alternativas de Instalação

### 1. Docker (Recomendado) ✅
- Mais fácil e confiável
- Sem problemas de compilação
- Isolamento de ambiente

### 2. WSL2 (Windows Subsystem for Linux)
```powershell
# Instalar WSL2
wsl --install

# Dentro do WSL (Ubuntu):
sudo apt-get update
sudo apt-get install -y build-essential
git clone https://github.com/hummingbot/hummingbot.git
cd hummingbot
./install
```

### 3. Instalação Nativa Windows (Problemática)
- Requer Visual Studio 2019+ Build Tools
- Requer configuração manual de C++17
- Pode ter problemas de compilação
- **NÃO RECOMENDADO**

---

## 📚 Recursos

- **Docker Hub:** https://hub.docker.com/r/hummingbot/hummingbot
- **Documentação Docker:** https://docs.hummingbot.org/installation/docker/
- **FAQ:** https://docs.hummingbot.org/faq/
- **Discord:** https://discord.gg/hummingbot

---

## ✅ Checklist de Instalação Docker

- [ ] Docker Desktop instalado
- [ ] Pasta `hummingbot_files` criada
- [ ] docker-compose.yml configurado
- [ ] Container iniciado com sucesso
- [ ] Hummingbot rodando
- [ ] Senha configurada
- [ ] API keys inseridas
- [ ] Estratégia configurada
- [ ] Paper trading testado

---

**Recomendação Final:** Use Docker! É muito mais simples e confiável no Windows. 🚀
