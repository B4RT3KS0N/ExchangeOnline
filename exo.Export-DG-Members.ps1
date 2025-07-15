<#
.SYNOPSIS
Recursively exports all members of a given distribution group, including nested distribution groups, to a CSV file.

.DESCRIPTION
This script connects to Exchange Online, retrieves all members (users and nested groups) of the specified distribution group,
and exports the details (including parent group information) to a CSV file.

.PARAMETER DistributionGroupName
The name of the distribution group from which to start enumerating members.

.OUTPUTS
CSV file containing details about the members.

.EXAMPLE
.\exo.Export-DG-Members.ps1
Exports all members of the specified distribution group to a CSV file on the desktop.

.NOTES
Author: Bartłomiej Tybura
Version: 1.0
Date: 2025-07-16
#>

Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

# Recursive function to fetch members of distribution lists, including nested ones
function Get-DistributionGroupMembers {
    param (
        [string]$DistributionGroupName,
        [string]$ParentGroup = $null
    )

    $members = Get-DistributionGroupMember -Identity $DistributionGroupName -ResultSize Unlimited

    foreach ($member in $members) {
        if ($member.RecipientType -eq 'MailUniversalDistributionGroup' -or $member.RecipientType -eq 'MailUniversalSecurityGroup') {
            Get-DistributionGroupMembers -DistributionGroupName $member.Name -ParentGroup $DistributionGroupName
        } else {
            [PSCustomObject]@{
                "Distribution Group"            = $DistributionGroupName
                "Parent Distribution Group"     = $ParentGroup
                "User display name"             = $member.DisplayName
                "E-mail"                        = $member.PrimarySmtpAddress
                "Recipient type"                = $member.RecipientType
            }
        }
    }
}

$user = $Env:UserName
$distributionGroupName = "Sample-Group" # Change to desired group
$allMembers = Get-DistributionGroupMembers -DistributionGroupName $distributionGroupName
$allMembers | Export-Csv -Path "C:\Users\$user\Desktop\MembersList_$distributionGroupName.csv" -NoTypeInformation -Encoding UTF8

# Disconnect from EXO
Disconnect-ExchangeOnline
