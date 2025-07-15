<#
.SYNOPSIS
Adds a new alias to all Microsoft 365 Groups in Exchange Online with a specified domain.

.DESCRIPTION
This script connects to Exchange Online and iterates through all Microsoft 365 Groups (Unified Groups).
For each group, it adds a new SMTP alias based on the existing alias but with a new domain suffix (e.g., @firma.pl).

.EXAMPLE
.\exo.Add-M365GroupAlias.ps1

This will add a new alias with the domain "@domain.com" to all existing Microsoft 365 Groups.

.NOTES
Author: Bartłomiej Tybura
Version: 1.0
Date: 2025-07-16
#>

# Import Exchange Online module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline

# Retrieve all Microsoft 365 Groups
$Groups = Get-UnifiedGroup -ResultSize Unlimited

# Iterate through each group
foreach ($Group in $Groups) {
    # Extract current primary SMTP address
    $CurrentEmailAddress = $Group.PrimarySmtpAddress

    # Get the prefix before @
    $AliasPrefix = $CurrentEmailAddress.Split('@')[0]

    # Construct new alias
    $NewAlias = $AliasPrefix + "@domain.com"

    # Add alias to the group
    Set-UnifiedGroup -Identity $Group.Identity -EmailAddresses @{Add="smtp:$NewAlias"}

    Write-Host "Added alias $NewAlias to group $($Group.DisplayName)."
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline
