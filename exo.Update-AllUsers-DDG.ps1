<#
.SYNOPSIS
Updates the dynamic distribution group for all users except shared, room, equipment mailboxes, and excludes certain patterns.

.DESCRIPTION
This script connects to Exchange Online and updates a dynamic distribution group to include only active user mailboxes that do not match specific naming patterns or attributes.

.EXAMPLE
.\exo.Update-AllUsers-DDG.ps1
#>

Connect-ExchangeOnline

$Filter = {(DisplayName -notlike 'DisplayName*') -and (PrimarySmtpAddress -notlike 'ext*') -and (ExchangeUserAccountControl -ne 'AccountDisabled') -and (RecipientType -eq 'UserMailbox') -and (RecipientTypeDetails -ne 'SharedMailbox') -and (RecipientTypeDetails -ne 'RoomMailbox') -and (RecipientTypeDetails -ne 'EquipmentMailbox') -and (CustomAttribute1 -ne 'CustomAttributeExample')}

Set-DynamicDistributionGroup -Identity "AllUsers" -DisplayName "All Users" -PrimarySmtpAddress AllUsers@domain.com -RecipientFilter $Filter

Get-DynamicDistributionGroupMember -Identity AllUsers@domain.com | Select Name, PrimarySmtpAddress | Format-Table

Disconnect-ExchangeOnline
