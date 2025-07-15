<#
.SYNOPSIS
Disables automatic calendar display of Microsoft 365 Groups in the classic Outlook application.

.DESCRIPTION
This script disables the automatic showing of Microsoft 365 Groups calendars in the classic Outlook client by setting the `HiddenFromExchangeClientsEnabled` property to `$true`.  
This prevents the calendars of M365 Groups from appearing automatically in users' Outlook profile.

.EXAMPLE
.\exo.Disable-M365GroupsCalendarAutoShow.ps1

.NOTES
Author: Bartłomiej Tybura
Version: 1.0
Date: 2025-07-16
#>

Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline

# Retrieve all Microsoft 365 Groups
$groups = Get-UnifiedGroup -ResultSize Unlimited

# Iterate through all groups and hide them from Exchange clients
foreach ($group in $groups) {
    Set-UnifiedGroup -Identity $group.Identity -HiddenFromExchangeClientsEnabled:$true
    Get-UnifiedGroup -Identity $group.Identity | Select-Object DisplayName, HiddenFromExchangeClientsEnabled
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline
