$Alias = Read-Host "Type the name of the E-mail address that you are looking for "
 
# Exchange Online infrastructure
 
$SoftDeleted = Get-Mailbox -SoftDeletedMailbox | Where {$_.EmailAddresses -like "*$Alias"}
$UnifiedGroups = Get-UnifiedGroup | Where {$_.EmailAddresses -like "*$Alias"}
$AllRecipients = Get-Recipient -ResultSize unlimited| Where {$_.EmailAddresses -like "*$Alias"}
if ($SoftDeleted -eq $null)
{
write-host "The E-mail address $Alias, is not a Soft Deleted Exchange Online mailbox"
}
Else
{
write-host --------------------------------------------------------
write-host "The E-mail address $Alias, belong to Unified Group"
write-host Recipient display name is- $AllRecipients.DisplayName
write-host Recipient E-mail addresses are - $AllRecipients.EmailAddresses
write-host Recipient Type is - $AllRecipients.RecipientType
write-host -------------------------------------------------------
}
 
if ($UnifiedGroups -eq $null)
{
write-host "The E-mail address $Alias, is not a Unified Group"
}
Else
{
belong to Soft Deleted Exchange Online  mailbox
}
 
if ($AllRecipients -eq $null)
{
write-host "The E-mail address $Alias, is not Exchange Online recipient "
}
 
Else
{
write-host --------------------------------------------------------
write-host "The E-mail address $Alias, belong to Exchange Online Recipient"
write-host Recipient display name is- $AllRecipients.DisplayName
write-host Recipient E-mail addresses are - $AllRecipients.EmailAddresses
write-host Recipient Type is - $AllRecipients.RecipientType
write-host -------------------------------------------------------
}