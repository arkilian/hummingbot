@echo off
REM Script para ativar o Hummingbot rapidamente no Windows

cd /d "C:\github\hummingbot\hummingbot-app\hummingbot"

echo.
echo ========================================
echo Ativando Ambiente Virtual Hummingbot
echo ========================================
echo.

call .\venv\Scripts\activate.bat

echo.
echo ========================================
echo Bem-vindo ao Hummingbot!
echo ========================================
echo.
echo Comandos úteis:
echo   hummingbot --version      Ver versão
echo   hummingbot                Iniciar o bot
echo   hummingbot --help         Ver opções
echo.
echo Para sair: deactivate
echo.
