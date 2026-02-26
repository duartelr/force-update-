# ==============================
# Windows Automated Update Script by duarte
# ==============================

$BasePath = "C:\Scripts"
$LogPath = "$BasePath\logs"

if (!(Test-Path $LogPath)) {
    New-Item -ItemType Directory -Path $LogPath -Force | Out-Null
}

$LogFile = "$LogPath\update-$(Get-Date -Format 'yyyy-MM-dd_HH-mm').txt"

Start-Transcript -Path $LogFile -Append

Write-Output "===== INÍCIO DA EXECUÇÃO ====="
Write-Output "Data: $(Get-Date)"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (!(Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Install-PackageProvider -Name NuGet -Force
}

if (!(Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Install-Module PSWindowsUpdate -Force -Confirm:$false
}

Import-Module PSWindowsUpdate

Write-Output "Verificando atualizações do Windows..."
Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot

Write-Output "Atualizando aplicativos via Winget..."
winget upgrade --all --silent --accept-package-agreements --accept-source-agreements

Write-Output "===== FIM DA EXECUÇÃO ====="

Stop-Transcript
