<#
.SYNOPSIS
Adds an alias to each mailbox with a new domain, based on the existing primary SMTP address.

.DESCRIPTION
This script connects to Exchange Online and iterates through all mailboxes.  
For each mailbox, it adds a new alias in the format user@firma.pl if it does not already exist.

.EXAMPLE
.\Add-MailAlias.ps1
The script connects to Exchange Online and adds aliases to all mailboxes.

.NOTES
Author: Bartłomiej Tybura
Version: 1.0
Date: 2025-07-15
#>

# Import Exchange Online PowerShell Module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online (insert the correct UPN when running)
Connect-ExchangeOnline -UserPrincipalName "user@domain.com"

# Retrieve all mailboxes
$Mailboxes = Get-Mailbox -ResultSize Unlimited

# Iterate through each mailbox
foreach ($Mailbox in $Mailboxes) {
    $CurrentEmailAddress = $Mailbox.PrimarySmtpAddress
    $AliasPrefix = $CurrentEmailAddress.Split('@')[0]
    $NewAlias = $AliasPrefix + "@domain.com"

    if (-not ($Mailbox.EmailAddresses -contains "smtp:$NewAlias")) {
        Set-Mailbox -Identity $Mailbox.Identity -EmailAddresses @{Add="smtp:$NewAlias"}
        Write-Host "Alias $NewAlias has been added to mailbox $($Mailbox.DisplayName)." -ForegroundColor Green
    } else {
        Write-Host "Alias $NewAlias already exists for mailbox $($Mailbox.DisplayName)." -ForegroundColor Yellow
    }
}

# Disconnect Exchange Online session
Disconnect-ExchangeOnline
