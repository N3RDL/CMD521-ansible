#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Basic WinRM setup for Ansible Windows management.
.DESCRIPTION
    Enables WinRM with Basic auth and opens firewall for Ansible connection.
.NOTES
    Run as Administrator on the target Windows machine.
#>

Write-Host "=== WinRM Setup for Ansible ===" -ForegroundColor Cyan

# Enable PSRemoting
Write-Host "[1/4] Enabling PSRemoting..." -ForegroundColor Yellow
Enable-PSRemoting -Force -SkipNetworkProfileCheck

# Enable Basic auth
Write-Host "[2/4] Enabling Basic authentication..." -ForegroundColor Yellow
Set-Item WSMan:\localhost\Service\Auth\Basic -Value $true

# Allow unencrypted connections (NTLM)
Write-Host "[3/4] Allowing unencrypted connections..." -ForegroundColor Yellow
Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value $true

# Open firewall port 5986 (HTTPS)
Write-Host "[4/4] Configuring firewall..." -ForegroundColor Yellow
$ruleName = "WinRM HTTPS (Ansible)"
$existing = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
if (-not $existing) {
    New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Protocol TCP -LocalPort 5986 -Action Allow
    Write-Host "  Firewall rule created: $ruleName" -ForegroundColor Green
} else {
    Write-Host "  Firewall rule already exists: $ruleName" -ForegroundColor DarkYellow
}

# Verify
Write-Host "`n=== Verification ===" -ForegroundColor Cyan
Write-Host "WinRM service status:"
Get-Service WinRM | Format-Table Status, Name, DisplayName -AutoSize

Write-Host "Listeners:"
winrm enumerate winrm/config/listener

Write-Host "Done! Test with:" -ForegroundColor Green
Write-Host "  ansible windows -i inventory/production/hosts -m ping --ask-vault-pass" -ForegroundColor White
