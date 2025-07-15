<#
.SYNOPSIS
Adds an additional alias to all distribution groups in Exchange Online with a new domain suffix.

.DESCRIPTION
This script connects to Exchange Online and adds a new alias to each distribution group using the same alias prefix 
but replacing the domain with 'domain.com'. This is useful during domain migrations or rebranding processes.

.EXAMPLE
.\exo.Add-Alias-To-DistributionGroups.ps1

Adds an alias with the 'domain.com' domain to all distribution groups.

.NOTES
Author: Bartłomiej Tybura
Version: 1.0
Date: 

#>

# Import Exchange Online PowerShell module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline

# Retrieve all distribution groups
$DistributionGroups = Get-DistributionGroup -ResultSize Unlimited

foreach ($Group in $DistributionGroups) {
    # Extract current email address prefix
    $CurrentEmailAddress = $Group.PrimarySmtpAddress
    $AliasPrefix = $CurrentEmailAddress.Split('@')[0]

    # Build new alias
    $NewAlias = $AliasPrefix + "@domain.com"

    # Add new alias to the group
    Set-DistributionGroup -Identity $Group.Identity -EmailAddresses @{Add="$NewAlias"}

    Write-Host "Added alias $NewAlias to group $($Group.DisplayName)."
}

# Disconnect Exchange Online session
Disconnect-ExchangeOnline
