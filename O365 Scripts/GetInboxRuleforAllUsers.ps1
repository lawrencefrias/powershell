Get-ExoMailbox -ResultSize Unlimited |
Select-Object -ExpandProperty UserPrincipalName |
Foreach-Object {Get-InboxRule -Mailbox $_ |
Select-Object -Property MailboxOwnerID,Name,Enabled,From,Description,RedirectTo,ForwardTo} |
Export-Csv -path c:\temp\test.csv -NoTypeInformation