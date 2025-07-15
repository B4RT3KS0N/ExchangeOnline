<#
.SYNOPSIS
Enables MailTips notification for external recipients in Exchange Online.

.DESCRIPTION
This script connects to Exchange Online and enables the organization-wide MailTip that informs users when sending messages to external recipients.

.EXAMPLE
.\exo.Enable-ExternalMailTips.ps1

.NOTES
Author: Bartłomiej Tybura
Version: 1.0
Date: 2025-07-16
#>

# Import Exchange Online Management Module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline

# Display current MailTips-related organization configuration
Get-OrganizationConfig | Select-Object MailTips*

# Enable MailTip for external recipients
Set-OrganizationConfig -MailTipsExternalRecipientsTipsEnabled $true

# Disconnect from Exchange Online
Disconnect-ExchangeOnline
