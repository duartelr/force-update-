# ==========================================
# Windows Enterprise Update Automation v2.0
# ==========================================
#🔔 IMPORTANTE ANTES DE TESTAR
#Você precisa criar a credencial na máquina:$Cred = Get-Credential
#$Cred | Export-Clixml -Path "C:\Scripts\mailcred.xml"

$BasePath = "C:\Scripts"
$LogPath = "$BasePath\logs"

if (!(Test-Path $LogPath)) {
    New-Item -ItemType Directory -Path $LogPath -Force | Out-Null
}

$LogFile = "$LogPath\update-$(Get-Date -Format 'yyyy-MM-dd_HH-mm').log"

function Write-Log {
    param ([string]$Message)
    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$Time - $Message" | Out-File -Append -FilePath $LogFile
}

Write-Log "===== INICIO DA EXECUÇÃO ====="
$Computer = $env:COMPUTERNAME
$Global:UpdateStatus = "SUCCESS"

# =========================
# WINDOWS UPDATE (API Nativa)
# =========================

try {
    Write-Log "Iniciando Windows Update via API nativa"

    $UpdateSession = New-Object -ComObject Microsoft.Update.Session
    $UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
    $UpdateSearcher.ServerSelection = 2

    $SearchResult = $UpdateSearcher.Search("IsInstalled=0")

    if ($SearchResult.Updates.Count -gt 0) {

        Write-Log "$($SearchResult.Updates.Count) atualizações encontradas"

        $UpdatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl

        foreach ($Update in $SearchResult.Updates) {
            Write-Log "Selecionando: $($Update.Title)"
            $UpdatesToInstall.Add($Update) | Out-Null
        }

        $Downloader = $UpdateSession.CreateUpdateDownloader()
        $Downloader.Updates = $UpdatesToInstall
        $Downloader.Download()

        $Installer = $UpdateSession.CreateUpdateInstaller()
        $Installer.Updates = $UpdatesToInstall
        $InstallationResult = $Installer.Install()

        Write-Log "Resultado da instalação: $($InstallationResult.ResultCode)"

        if ($InstallationResult.RebootRequired) {
            Write-Log "Reboot necessário"
        }
    }
    else {
        Write-Log "Nenhuma atualização pendente"
    }

}
catch {
    Write-Log "ERRO no Windows Update: $_"
    $Global:UpdateStatus = "FAILED"
}

# =========================
# WINGET UPDATE
# =========================

try {
    Write-Log "Iniciando atualização de aplicativos via Winget"

    $WingetOutput = winget upgrade --all --silent --accept-package-agreements --accept-source-agreements
    $WingetOutput | Out-File -Append -FilePath $LogFile

    Write-Log "Winget finalizado"
}
catch {
    Write-Log "ERRO no Winget: $_"
    $Global:UpdateStatus = "FAILED"
}

Write-Log "Status final: $Global:UpdateStatus"

# =========================
# ENVIO DE EMAIL CORPORATIVO
# =========================

try {
    Write-Log "Preparando envio de email"

    $Cred = Import-Clixml -Path "C:\Scripts\mailcred.xml"

    $EmailBody = @"
Relatório de Atualização

Computador: $Computer
Data: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Status: $Global:UpdateStatus

Verifique o log em anexo para detalhes.
"@

    Send-MailMessage `
        -From "updates@empresa.com" `
        -To "seuemail@empresa.com" `
        -Subject "[$Global:UpdateStatus] Update Report - $Computer" `
        -Body $EmailBody `
        -SmtpServer "smtp.office365.com" `
        -Port 587 `
        -UseSsl `
        -Credential $Cred `
        -Attachments $LogFile

    Write-Log "Email enviado com sucesso"
}
catch {
    Write-Log "ERRO ao enviar email: $_"
}

Write-Log "===== FIM DA EXECUÇÃO ====="


#🔔 IMPORTANTE ANTES DE TESTAR
#Você precisa criar a credencial na máquina:$Cred = Get-Credential
#$Cred | Export-Clixml -Path "C:\Scripts\mailcred.xml"
