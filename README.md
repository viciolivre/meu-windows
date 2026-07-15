# meu-windows: Automatizador de Instalação para Windows

Este projeto contém um script de automação (`.bat`) para configurar um ambiente atualizado em uma nova instalação do Windows. Ele utiliza o **Gerenciador de Pacotes do Windows (`winget`)** para instalar seus aplicativos favoritos, habilita o **Windows Sandbox** e configura o **Subsistema do Windows para Linux (WSL)**.

O objetivo é simplificar e acelerar o processo de setup de uma nova máquina, garantindo que todas as ferramentas essenciais sejam instaladas de forma consistente e automática.

## ✨ Funcionalidades

- ✅ **Configuração Inicial:** Verifica se o Windows Sandbox e o WSL já estão habilitados antes de tentar instalá-los, evitando passos desnecessários.
- 🐧 **WSL:** Garante que o WSL esteja disponível e, se necessário, executa a instalação automaticamente.
- 📦 **Instalação em Lote:** Lê uma lista de aplicativos de um arquivo `apps.csv` e faz a instalação.
- 🔄 **Atualização Inteligente do CSV:** Se o arquivo `apps.csv` já existir, o script pergunta se deseja atualizar com a versão mais recente da nuvem; se a resposta for negativa, mantém o arquivo local.
- 👀 **Revisão Antes da Instalação:** Antes de instalar os aplicativos, o script pode abrir o arquivo `apps.csv` no Bloco de Notas e aguardar até que ele seja fechado, permitindo ajustes antes de prosseguir.
- 🔧 **Fácil de Personalizar:** Basta editar o arquivo `apps.csv` para adicionar ou remover os aplicativos que você deseja instalar.

## 🚀 Como Usar

1. **Execute o comando abaixo para instalar o script:**

   ```sh
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/nettaskjr/apps-winget/main/install.bat" -OutFile "install.bat"; Start-Process -FilePath ".\install.bat" -Verb RunAs
   ```
2. **Responda as perguntas**

   1. `Deseja atualizar com a versão mais recente? (S/N):`. Você poderá manter uma versão pessoal do arquivo de aplicativos, neste caso responda N para esta pergunta.
   2. `Deseja revisar o arquivo apps.csv antes de instalar? (S/N):`. Neste caso você poderá validar a lista de arquivos antes de instalar, seja uma nova baixada ou aquela que já está local
3. Veja abaixo como o arquivo é estruturado

   O arquivo`apps.csv` controla quais aplicativos são instalados. O formato é simples: a primeira coluna é um nome amigável (usado para exibição no console) e a segunda é o **ID exato** do pacote `winget`.

**A primeira linha (cabeçalho) é ignorada pelo script.**

### Exemplo de `apps.csv`:

```csv
Nome,WingetId,Descricao
Google Chrome,Google.Chrome,Navegador de Interne
Visual Studio Code,Microsoft.VisualStudioCode,IDE para programadores
7-Zip,7zip.7zip,Compactador
Docker Desktop,Docker.DockerDesktop,Aplicativo para Docker
PowerToys,Microsoft.PowerToys,Ferramentas de apoio para o SO
```

## 📋 Pré-requisitos

- Windows 10 (versão 2004 ou superior) ou Windows 11.
- Acesso de **Administrador** para executar o script.
- Gerenciador de Pacotes do Windows (winget) instalado (geralmente já vem com as versões mais recentes do Windows).

---

*Este projeto é ideal para desenvolvedores, profissionais de TI ou qualquer pessoa que precise configurar múltiplos computadores Windows com um conjunto padronizado de softwares.*
