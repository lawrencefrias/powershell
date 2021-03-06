$credentials = Read-Host -Prompt 'User Principal Name'
Write-Output "Getting the Exchange Online cmdlets"
    
Connect-EXOPSSession -UserPrincipalName $credentials

$mailboxes = Get-Mailbox -ResultSize Unlimited
$domains = Get-AcceptedDomain
  
foreach ($mailbox in $mailboxes) {
  
    $forwardingSMTPAddress = $null
    Write-Host "Checking forwarding for $($mailbox.displayname) - $($mailbox.primarysmtpaddress)"
    $forwardingSMTPAddress = $mailbox.forwardingsmtpaddress
    $externalRecipient = $null
    if ($forwardingSMTPAddress) {
        $email = ($forwardingSMTPAddress -split "SMTP:")[1]
        $domain = ($email -split "@")[1]
        if ($domains.DomainName -notcontains $domain) {
            $externalRecipient = $email
        }
  
        if ($externalRecipient) {
            Write-Host "$($mailbox.displayname) - $($mailbox.primarysmtpaddress) forwards to $externalRecipient" -ForegroundColor Yellow
  
            $forwardHash = $null
            $forwardHash = [ordered]@{
                PrimarySmtpAddress = $mailbox.PrimarySmtpAddress
                DisplayName        = $mailbox.DisplayName
                ExternalRecipient  = $externalRecipient
            }
            $ruleObject = New-Object PSObject -Property $forwardHash
            $ruleObject | Export-Csv C:\temp\ExternalForward.csv -NoTypeInformation -Append
        }
    }
}