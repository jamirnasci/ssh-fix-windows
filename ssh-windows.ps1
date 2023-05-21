$logo = @"
 ___  ___  _  _        ___  _      
/ __|/ __|| || |      | __|(_)__ __
\__ \\__ \| __ |      | _| | |\ \ /
|___/|___/|_||_|      |_|  |_|/_\_\
by jamir
"@

Write-Host "$logo"

try {
    $username = $env:USERNAME
    $ip = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -notlike '*Loopback*' }).IPAddress

    # Verifica se o servidor OpenSSH já está instalado
    $sshCapability = Get-WindowsCapability -Online | Where-Object { $_.Name -like 'OpenSSH.Server*' }

    if ($sshCapability -and $sshCapability.State -eq "Installed") {
        Write-Host "OpenSSH Server is already installed."
    } else {
        # Adiciona o servidor OpenSSH
        Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 -ErrorAction Stop
        Write-Host "OpenSSH Server installed successfully!"
    }

    # Inicializa o serviço SSH
    Start-Service sshd

    # Obtém o status do serviço SSH
    $sshService = Get-Service -Name sshd

    Write-Host "User: $username"
    Write-Host "IP: $ip"
    Write-Host "SSH Status: $($sshService.Status)"
} catch {
    Write-Host "Error installing or starting OpenSSH Server: $_"
}
