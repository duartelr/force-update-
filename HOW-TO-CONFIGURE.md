⚙️ How to Configure – Enterprise Update Automation
Este guia descreve como configurar o script auto-update-enterprise.ps1 em uma máquina Windows.

📋 1. Pré-requisitos
-Windows 10/11 ou Windows Server
-PowerShell 5.1+
-Winget instalado
-Acesso administrativo local
-Conta de e-mail corporativa com SMTP habilitado
📁 2. Estrutura de Diretórios
Criar a pasta base:

#no powerShell#
mkdir C:\Scripts

Copiar o arquivo:
auto-update-enterprise.ps1
para:
C:\Scripts\
🔐 3. Configurar Credencial de E-mail (OBRIGATÓRIO)
Execute uma vez:
# no PowerShell #
$Cred = Get-Credential
$Cred | Export-Clixml -Path "C:\Scripts\mailcred.xml"
Informe:

Usuário: updates@empresa.com

Senha: senha ou senha de aplicativo

⚠️ O arquivo mailcred.xml fica criptografado e só funciona na máquina onde foi criado.

✏️ 4. Ajustar Parâmetros no Script
Editar dentro do script:
# no PowerShell #
-From "updates@empresa.com"
-To "seuemail@empresa.com"
-SmtpServer "smtp.office365.com"
Altere para os valores corretos do seu ambiente.

▶️ 5. Teste Manual
Executar:
# no PowerShell #
powershell -ExecutionPolicy Bypass -File C:\Scripts\auto-update-enterprise.ps1


Verifique:

Criação de log em C:\Scripts\logs

Recebimento do e-mail

Execução do Windows Update

Execução do Winget

⏰ 6. Criar Tarefa Agendada
Executar como administrador:
# no CMD #
schtasks /create /tn "EnterpriseAutoUpdate" ^
/tr "powershell -ExecutionPolicy Bypass -File C:\Scripts\auto-update-enterprise.ps1" ^
/sc weekly /d SUN /st 20:00 /ru SYSTEM
Para testar imediatamente:

schtasks /run /tn "EnterpriseAutoUpdate"
📊 7. Monitoramento
O sistema enviará:

✅ Email de SUCCESS

❌ Email de FAILED

📎 Log completo em anexo

Recomendado criar regra no Outlook para organizar relatórios automaticamente.

🔄 8. Boas Práticas
Testar sempre em máquina piloto antes de implantar em massa

Revisar logs semanalmente

Validar necessidade de reboot
