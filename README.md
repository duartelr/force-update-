🛡️ Windows Automated Update Management
Automação de atualizações do Windows e aplicativos corporativos utilizando PowerShell, PSWindowsUpdate e Winget, com execução agendada e geração de logs locais para auditoria.
----------------------------------------------------------------------------------------------------------------------------------------------------------------
📌 Visão Geral
Este projeto foi desenvolvido para eliminar o processo manual de atualização máquina por máquina, garantindo:

Correção contínua de vulnerabilidades (CVEs)

Padronização das atualizações

Redução de esforço operacional

Registro de logs para controle e auditoria

A solução é leve, de baixo custo e não depende de WSUS ou ferramentas pagas.
----------------------------------------------------------------------------------------------------------------------------------------------------------------

🏗️ Arquitetura da Solução
A automação é composta por:

Script PowerShell

Instala e executa atualizações do Windows

Atualiza aplicativos via Winget

Gera logs detalhados

Agendador de Tarefas do Windows

Executa o script periodicamente

Roda mesmo sem usuário logado

Executa com privilégios elevados (SYSTEM)
----------------------------------------------------------------------------------------------------------------------------------------------------------------
⚙️ Requisitos
Windows 10 / 11 ou Windows Server

PowerShell 5.1+

Winget instalado

Acesso administrativo na máquina
----------------------------------------------------------------------------------------------------------------------------------------------------------------

📁 Estrutura do Projeto:
/Scripts
    auto-update.ps1

/logs
    update-YYYY-MM-DD_HH-mm.txt

----------------------------------------------------------------------------------------------------------------------------------------------------------------
🚀 Instalação
1️⃣ Criar diretório
mkdir C:\Scripts
2️⃣ Salvar o script 
(Salvar o arquivo auto-update.ps1 dentro de: C:\Scripts\)
3️⃣ Criar tarefa agendada
Executar como administrador: (cmd)
schtasks /create /tn "AutoUpdateSemanal" ^
/tr "powershell -ExecutionPolicy Bypass -File C:\Scripts\auto-update.ps1" ^
/sc weekly /d SUN /st 20:00 /ru SYSTEM

----------------------------------------------------------------------------------------------------------------------------------------------------------------
📊 Logs
Os logs são armazenados em:
    C:\Scripts\logs\
    Contêm:

Data e hora da execução

Atualizações encontradas

Status da instalação

Possíveis erros
----------------------------------------------------------------------------------------------------------------------------------------------------------------
🔐 Segurança
Executa com privilégio SYSTEM

Pode ser adaptado para envio de webhook

Pode ser integrado com monitoramento centralizado
----------------------------------------------------------------------------------------------------------------------------------------------------------------
🧩 Melhorias Futuras
Envio de status via webhook

Dashboard centralizado

Verificação de versão antes da execução

Controle de reboot automatizado

Integração com ferramentas RMM
----------------------------------------------------------------------------------------------------------------------------------------------------------------
🎯 Objetivo Estratégico
Transformar o processo de atualização de um modelo reativo e manual para um modelo automatizado, auditável e escalável.
