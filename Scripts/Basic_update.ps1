# ==========================================
# Windows Basic Auto Update Script
# by Lucas Duarte - Miti Soluções
# ==========================================
$BasePath = "C:\Scripts"
$LogPath = "$BasePath\log.txt"

if (!(Test-Path $BasePath)) {
    New-Item -ItemType Directory -Path $BasePath -Force | Out-Null
}

function Write-Log {
    param ([string]$Message)
    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$Time - $Message" | Out-File -Append -FilePath $LogPath -Encoding utf8
}

Write-Log "======================================="
Write-Log "INICIO DA EXECUÇÃO"

# =========================
# WINDOWS UPDATE
# =========================

try {
    Write-Log "Verificando atualizações do Windows..."

    $UpdateSession = New-Object -ComObject Microsoft.Update.Session
    $UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
    $SearchResult = $UpdateSearcher.Search("IsInstalled=0")

    if ($SearchResult.Updates.Count -gt 0) {

        Write-Log "$($SearchResult.Updates.Count) atualizações encontradas"

        $UpdatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl

        foreach ($Update in $SearchResult.Updates) {
            Write-Log "Instalando: $($Update.Title)"
            $UpdatesToInstall.Add($Update) | Out-Null
        }

        $Downloader = $UpdateSession.CreateUpdateDownloader()
        $Downloader.Updates = $UpdatesToInstall
        $Downloader.Download()

        $Installer = $UpdateSession.CreateUpdateInstaller()
        $Installer.Updates = $UpdatesToInstall
        $Result = $Installer.Install()

        Write-Log "Resultado Windows Update: $($Result.ResultCode)"

        if ($Result.RebootRequired) {
            Write-Log "Reboot necessário"
        }

    } else {
        Write-Log "Nenhuma atualização do Windows pendente"
    }

}
catch {
    Write-Log "ERRO Windows Update: $_"
}

# =========================
# WINGET UPDATE
# =========================

try {
    Write-Log "Verificando atualização de aplicativos via Winget..."

    $WingetOutput = winget upgrade --all --silent --accept-package-agreements --accept-source-agreements

    if ($WingetOutput) {
        $WingetOutput | Out-File -Append $LogPath
    }

    Write-Log "Winget finalizado"

}
catch {
    Write-Log "ERRO Winget: $_"
}
if ($Result -and $Result.RebootRequired) {

    Write-Log "Reboot necessário detectado."

    # Aviso visível para todos usuários logados
    msg * "ATUALIZAÇÃO CORPORATIVA: Seu computador será reiniciado em 10 minutos para concluir atualizações. Salve seu trabalho imediatamente."

    Write-Log "Aviso de reinício enviado ao usuário."

    # Reinício forçado em 10 minutos (600 segundos)
    shutdown /r /f /t 600 /c "Reinício automático obrigatório para concluir atualizações do sistema."

    Write-Log "Timer de reinício iniciado (10 minutos)."
}
Write-Log "FIM DA EXECUÇÃO"
Write-Log "Script desenvolvido por Lucas Duarte - Miti Soluções"
Write-Log "======================================="
Write-Log "FIM DA EXECUÇÃO"
Write-Log "======================================="
