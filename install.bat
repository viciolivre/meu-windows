@echo off
cls  
:: Habilita a expansão de variável atrasada para uso em loops
setlocal enabledelayedexpansion

:: Como o script deve ser executado como admin, alteramos o diretório de trabalho para a pasta do script
cd /d "%~dp0"

:: Define a página de código para UTF-8 para evitar problemas com caracteres especiais
chcp 65001

echo ""
echo =======================================
echo  CONFIGURAÇÕES INICIAIS
echo =======================================

echo.
echo [1/3] Verificando o Windows Sandbox...
for /f "tokens=*" %%A in ('powershell.exe -NoProfile -Command "(Get-WindowsOptionalFeature -Online -FeatureName 'Containers-DisposableClientVM').State" 2^>nul') do set "sandbox_estado=%%A"
if /I "!sandbox_estado!"=="Enabled" (
    echo O Windows Sandbox ja esta habilitado.
) else (
    echo Ativando o Windows Sandbox...
    Dism.exe /online /Enable-Feature /FeatureName:Containers-DisposableClientVM /all /NoRestart
)

echo.
echo [2/3] Verificando o WSL...
where wsl.exe >nul 2>&1
if not errorlevel 1 (
    wsl.exe --status >nul 2>&1
    if not errorlevel 1 (
        echo O WSL ja esta instalado e habilitado.
    ) else (
        echo Instalando WSL...
        wsl --install
    )
) else (
    echo Instalando WSL...
    wsl --install
)

echo.
echo [3/3] Atualizando todos os pacotes Winget...
winget upgrade --all --silent --accept-source-agreements --accept-package-agreements

echo.
echo =======================================
echo  INSTALANDO APLICATIVOS
echo =======================================

:: Testa se o arquivo apps.csv existe e pergunta ao usuário se deseja atualizar
set "baixar_apps=1"
if exist "apps.csv" (
    echo.
    set /p "resposta=O arquivo apps.csv ja existe. Deseja atualizar com a versão mais recente? (S/N): "
    if /I "!resposta!"=="S" (
        set "baixar_apps=1"
    ) else (
        set "baixar_apps=0"
    )
)

if "!baixar_apps!"=="1" (
    echo Baixando o arquivo de aplicativos...
    :: Usamos -Command para garantir que o comando seja executado pelo PowerShell e não interpretado pelo CMD.
    powershell.exe -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/nettaskjr/apps-winget/main/apps.csv' -OutFile 'apps.csv'"
) else (
    echo Mantendo o arquivo existente em: %~dp0apps.csv
)

echo.
set /p "revisar_lista=Deseja revisar o arquivo apps.csv antes de instalar? (S/N): "
if /I "!revisar_lista!"=="S" (
    echo Abrindo o arquivo para revisão...
    start "" /wait notepad.exe "%~dp0apps.csv"
    echo Continuando apos a revisão do arquivo.
) else (
    echo Prosseguindo com a instalação.
)

:: Lendo e executando o arquivo de aplicativos, descartando a primeira linha (cabeçalho)
:: As configurações importantes foram movidas diretamente para este script.
for /f "skip=1 tokens=1,2 delims=," %%A in (apps.csv) do (
    set "coluna1=%%A"
    set "coluna2=%%B"
    echo.
    echo ---------------------------------------
    echo Instalando: !coluna1!
    winget install --id=!coluna2! -h --accept-source-agreements --accept-package-agreements
)

echo.
echo =======================================
echo  Script concluído!
echo =======================================
endlocal

pause


