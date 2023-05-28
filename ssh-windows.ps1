try {
    $username = $env:USERNAME
    $ip = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -notlike '*Loopback*' }).IPAddress

    $sshCapability = Get-WindowsCapability -Online | Where-Object { $_.Name -like 'OpenSSH.Server*' }

    if ($sshCapability -and $sshCapability.State -eq "Installed") {
        Write-Host "OpenSSH Server is already installed."
    } else {
        Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 -ErrorAction Stop
        Write-Host "OpenSSH Server installed successfully!"
    }
    Start-Service sshd

    $sshService = Get-Service -Name sshd

    Write-Host "User: $username"
    Write-Host "IP: $ip"
    Write-Host "SSH Status: $($sshService.Status)"
} catch {
    Write-Host "Error installing or starting OpenSSH Server: $_"
}
