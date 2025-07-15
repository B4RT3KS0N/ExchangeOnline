<#
.SYNOPSIS
This script enables automatic acceptance of external meeting invitations for a resource calendar
and configures the visibility of meeting subjects.

.DESCRIPTION
The script:
1. Connects to Exchange Online.
2. Lists all mailboxes of type EquipmentMailbox (optional step).
3. Enables automatic processing of external meeting invitations for a specified resource mailbox.
4. Configures the mailbox to show both the meeting organizer and the subject in the calendar.

.PARAMETER ResourceMailbox
The email address of the resource mailbox to configure.

.EXAMPLE
.\exo.Set-ResourceCalendarProcessing.ps1 -ResourceMailbox "resource@example.com"

.NOTES
Author: Bartłomiej Tybura
Version: 1.0
Date: 2025-07-15
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$ResourceMailbox
)

# Connect to Exchange Online
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

# Optional: List existing resource mailboxes for reference
Get-Mailbox -RecipientTypeDetails EquipmentMailbox | Select-Object Name,PrimarySMTPAddress

# Check current external meeting processing settings
Get-Mailbox $ResourceMailbox | Get-CalendarProcessing | Select-Object Identity, ProcessExternalMeetingMessages

# Enable processing of external meeting requests
Set-CalendarProcessing -Identity $ResourceMailbox -ProcessExternalMeetingMessages $true -Verbose

# Configure visibility of meeting subject and organizer
Set-CalendarProcessing -Identity $ResourceMailbox -DeleteSubject $false -AddOrganizerToSubject $false -Verbose

# Confirmation output
Write-Output "Resource mailbox '$ResourceMailbox' has been successfully configured."

#Disconnect from Exchange Online
Disconnect-ExchangeOnline
