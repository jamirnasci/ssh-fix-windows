$logo = @"
 ___  ___  _  _        ___                _           
/ __|/ __|| || |      | _ \ ___  ___ ___ | |__ __ ___ 
\__ \\__ \| __ |      |   // -_)(_-// _ \| |\ V // -_)
|___/|___/|_||_|      |_|_\\___|/__/\___/|_| \_/ \___|
by jamir
"@

Write-Host "$logo"

try {
    $username = $env:USERNAME
    $ip = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -notlike '*Loopback*' }).IPAddress

    # Verifica se o servidor OpenSSH já está instalado
    $sshCapability = Get-WindowsCapability -Online | Where-Object { $_.Name -like 'OpenSSH.Server*' }

    if ($sshCapability -and $sshCapability.State -eq "Installed") {
        Write-Host "OpenSSH Server já está instalado."
    } else {
        # Adiciona o servidor OpenSSH
        Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 -ErrorAction Stop
        Write-Host "OpenSSH Server instalado com sucesso!"
    }

    # Inicializa o serviço SSH
    Start-Service sshd

    # Obtém o status do serviço SSH
    $sshService = Get-Service -Name sshd

    Write-Host "Nome de usuário: $username"
    Write-Host "Endereço IP da máquina: $ip"
    Write-Host "Status do serviço SSH: $($sshService.Status)"
} catch {
    Write-Host "Erro ao instalar ou iniciar o OpenSSH Server: $_"
}
