<#
.SYNOPSIS
Assigns Full Access permissions to the same mailboxes where the source user already has Full Access.

.DESCRIPTION
This script retrieves all mailboxes where the source user has Full Access permissions and grants the same permissions to the target user, excluding the source user's own mailbox.

.PARAMETER SourceUser
The user whose Full Access permissions will be copied.

.PARAMETER TargetUser
The user who will receive Full Access permissions to the same mailboxes.

.EXAMPLE
.\Grant-FullAccessToSameMailboxes.ps1 -SourceUser "user1@domain.com" -TargetUser "user2@domain.com"

.NOTES
Author: Bartłomiej Tybura
Version: 1.0
Date: 
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$SourceUser,

    [Parameter(Mandatory = $true)]
    [string]$TargetUser
)

# Connect to Exchange Online
Connect-ExchangeOnline

# Retrieve mailboxes where SourceUser has FullAccess
$MailboxPermissions = Get-Mailbox | ForEach-Object {
    $Mailbox = $_
    Get-MailboxPermission -Identity $Mailbox.Identity | Where-Object {
        $_.User -like $SourceUser -and $_.AccessRights -contains "FullAccess"
    }
} 

foreach ($Permission in $MailboxPermissions) {
    # Exclude the SourceUser's own mailbox
    if ($Permission.Identity -ne $SourceUser) {
        Write-Host "Granting FullAccess for $($Permission.Identity) to $TargetUser" -ForegroundColor Yellow
        Add-MailboxPermission -Identity $Permission.Identity -User $TargetUser -AccessRights FullAccess -InheritanceType All
    }
}

# Disconnect session
Disconnect-ExchangeOnline
