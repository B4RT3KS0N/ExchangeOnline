<#
.SYNOPSIS
Enables SMTP client authentication for the Exchange Online tenant.

.DESCRIPTION
This script connects to Exchange Online and enables SMTP client authentication by setting the relevant tenant-wide configuration flag.
Enabling SMTP client authentication may be required for legacy devices and applications such as multifunction printers (MFPs), scanners, fax machines, or applications that send emails via SMTP AUTH. These devices often do not support modern authentication methods like OAuth 2.0 and require basic authentication over SMTP.
This setting ensures that such devices can continue sending emails via authenticated SMTP (smtp.office365.com:587).

.EXAMPLE
.\exo.Enable-SMTPAuth.ps1

.NOTES
Author: Bartłomiej Tybura
Version: 1.0
Date: 2025-07-16
#>

# Import Exchange Online module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline

# Enable SMTP client authentication
Set-TransportConfig -SmtpClientAuthenticationDisabled $false

# Display current SMTP client authentication setting
Get-TransportConfig | Format-List SmtpClientAuthenticationDisabled

# Disconnect session
Disconnect-ExchangeOnline
