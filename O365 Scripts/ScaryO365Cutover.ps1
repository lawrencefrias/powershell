# Must be connected to Office 365 tenant

# Get all mailbox users and their addresses. Export to CSV. 
$mailboxArray = Get-Mailbox -resultsize unlimited| select-object userprincipalname,alias,@{Name="EmailAddresses";Expression={$_.EmailAddresses | Where-Object {$_ -LIKE "SMTP:*"}}} | where-object -property userprincipalname -eq "danny.klatt@domain.ca"
write-host $mailboxArray

#Iterate through all mailboxes
foreach($i in $mailboxArray)
{
	#Iterate through all email addresses for each mailbox
	foreach($j in $i.EmailAddresses)
	{
		#Write the name of users with @domain.com emails but not already cut over
		if($j -like "*@domain.com" -and $i.UserPrincipalName -notlike "@domain.com"){
			write-host "if1"
			$currentEmail = $i.UserPrincipalName
			$comEmail = $currentEmail.replace("domain.ca", "domain.com")
			Set-Mailbox $currentEmail -WindowsEmailAddress $comEmail
			Set-MsolUserPrincipalName -NewUserPrincipalName $comEmail -UserPrincipalName $currentEmail
			break
		}
		#Write the name of users with @domain.ca emails but without @domain.com emails
		if($j -like "*@domain.ca" -and $j -notlike "@domain.com"){
			# Add a .com email to all accounts with a .ca email based on their existing .ca email
			write-host "if2"
			$currentEmail = $i.UserPrincipalName
			$comEmail = $currentEmail.replace("domain.ca", "domain.com")
			Set-Mailbox $currentEmail -EmailAddresses @{Add="$comEmail"}
			Set-Mailbox $currentEmail -WindowsEmailAddress $comEmail
			Set-MsolUserPrincipalName -NewUserPrincipalName $comEmail -UserPrincipalName $currentEmail
			break
		}
	}
}