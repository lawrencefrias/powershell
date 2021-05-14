# Must be connected to Office 365 tenant

# Get all tilray.ca mailbox users and their addresses. Export to CSV. 
$mailboxArray = Get-Mailbox -resultsize unlimited | Where-Object {$_.AccountDisabled -eq $false -and $_.IsShared -eq $false} | select-object userprincipalname,alias,@{Name="EmailAddresses";Expression={$_.EmailAddresses | Where-Object {$_ -LIKE "SMTP:*"}}}

#Declare users with @tilray.ca AND WITH @tilray.com addresses array.
$needsCutover = New-Object System.Collections.Generic.List[System.Object]

#Declare users with @tilray.ca AND WITHOUT @tilray.com array
$needsComAddress = New-Object System.Collections.Generic.List[System.Object]

#Declare users who are cut over
$completedUsers = New-Object System.Collections.Generic.List[System.Object]

#Iterate through all mailboxes
foreach($i in $mailboxArray)
{
	#Iterate through all email addresses for each mailbox
	foreach($j in $i.EmailAddresses)
	{
		#Write the name of users with @tilray.com emails that are already cut over
		if($j -like "*@tilray.com" -and $i.UserPrincipalName -like "*@tilray.com"){
			$completedUsers.Add($i.UserPrincipalName)
			break
		}
		#Write the name of users with @tilray.com emails but not already cut over
		if($j -like "*@tilray.com" -and $i.UserPrincipalName -notlike "*@tilray.com"){
			$needsCutover.Add($i.UserPrincipalName)
			break
		}
		#Write the name of users with @tilray.ca emails but without @tilray.com emails
		if($j -like "*@tilray.ca" -and $j -notlike "*@tilray.com"){
			$needsComAddress.Add($i.UserPrincipalName)
			break
		}
	}
}

$completedUsers | ForEach {[PSCustomObject]@{Email = $_}} | Export-Csv "C:\Users\danny.klatt\Desktop\CA to COM Migration\CompletedCutOver.csv" -NoTypeInformation
$needsCutover | ForEach {[PSCustomObject]@{Email = $_}} | Export-Csv "C:\Users\danny.klatt\Desktop\CA to COM Migration\ToCutOver.csv" -NoTypeInformation
$needsComAddress | ForEach {[PSCustomObject]@{Email = $_}} | Export-Csv "C:\Users\danny.klatt\Desktop\CA to COM Migration\ToCutOverNeedsComAddress.csv" -NoTypeInformation

