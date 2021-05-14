# Import required modules
import-module activedirectory

$credential = Get-Credential

# Declare environment variables
$test = $true
$requiresAccounts = "y"
#$requiresAccounts = Read-Host -prompt "Does this user require computer and email accounts? (Y/N)"

$progress = ""

if ($requiresAccounts.ToLower() -eq "y"){
    
    $user = @{}

    if ($test = $true){
        $user['FirstName'] = "Daniel"
        $user['LastName'] = "Dickinson"
        $user['DisplayName'] = $user['FirstName'] + " " + $user['LastName']
        $user['JobTitle'] = "Network/Systems Analyst"
        $user['Location'] = "CA01" # Turn this in to a dropdown when there is a GUI
        $user['StartDate'] = "2018-01-01"
        $user['Department'] = "Information Technology" # Turn this in to a dropdown when there is a GUI
        # Valid Departments: Administration, Clinical Research, Executive, Facilities, Finance, Health & Safety, Information Systems, Information Technology, Legal, Marketing, Operations, Patient Services, Project Management, Quality Assurance, Research & Development, Sales, Security, Warehouse
        $user['Supervisor'] = "Steve Chan"
        $user['UserPrincipalName'] = ($user['DisplayName'] -replace " ", ".").ToLower()
        $user['MobilePhone'] = "555.555.5555"
        $user['OfficePhone'] = "555.555.5555"
        $user['Company'] = "Tilray" # Turn this in to a dropdown when there is a GUI
    } else {
        # Create account in Tilray.local Active Directory
        $user['FirstName'] = Read-Host -prompt "Input first name. Example: Danny "
        $user['LastName'] = Read-Host -prompt "Input last name. Example: Klatt"
        $user['DisplayName'] = $user['FirstName'] + " " + $user['LastName']
        $user['JobTitle'] = Read-Host -prompt "Input job title. Example: Network/Systems Analyst"
        $user['Location'] = Read-Host -prompt "Location. Example: CA01" # Turn this in to a dropdown when there is a GUI
        $user['StartDate'] = Read-Host -prompt "Start date. yyyy-mm-dd"
        $user['Department'] = Read-Host -prompt "Department. Example: Information Technology" # Turn this in to a dropdown when there is a GUI
        # Valid Departments: Administration, Clinical Research, Executive, Facilities, Finance, Health & Safety, Information Systems, Information Technology, Legal, Marketing, Operations, Patient Services, Project Management, Quality Assurance, Research & Development, Sales, Security, Warehouse
        $user['Supervisor'] = Read-Host -prompt "Supervisor: Example: Steve Chan"
        $user['UserPrincipalName'] = ($user['DisplayName'] -replace " ", ".").ToLower()
        $user['MobilePhone'] = Read-Host -prompt "Mobile phone. Example: 555.555.5555"
        $user['OfficePhone'] = Read-Host -prompt "Office phone. Example: 555.555.5555"
        $user['Company'] = Read-Host -prompt "Which company do they work for? Example: Tilray" # Turn this in to a dropdown when there is a GUI
    }

    # Instantiate scoped variables
    $user['Office'] = ""
    $user['StreetAddress'] = ""
    $user['City'] = ""
    $user['Province'] = ""
    $user['PostalCode'] = ""
    $user['Country'] = ""
    $user['Groups'] = New-Object System.Collections.Generic.List[System.Object]
    $user['DistributionLists'] = New-Object System.Collections.Generic.List[System.Object]
    $user['OULocation'] = ""

    # Set user information based on location
    if ($user['Location'].ToUpper() -eq "CA01") {
        # Set user site attributes
        $user['Office'] = "CA01"
        $user['StreetAddress'] = "1100 Maughan Road"
        $user['City'] = "Nanaimo"
        $user['Province'] = "BC"
        $user['PostalCode'] = "V9X 1J2"
        $user['Country'] = "CA"

        # Set default site permissions
        $user['Groups'].Add("CA01R Users")
        
        # Set OU to add user to.
        $user['OULocation'] = "Nanaimo"

    } elseif ($user['Location'].ToUpper() -eq "CA02") {
        $user['Office'] = "CA02"
        $user['StreetAddress'] = "B1 - 495 Wellington Street W"
        $user['City'] = "Toronto"
        $user['Province'] = "ON"
        $user['PostalCode'] = "M5V 1G1"
        $user['Country'] = "CA"
    } elseif ($user['Location'].ToUpper() -eq "CA03") {
        $user['Office'] = "CA03"
        $user['StreetAddress'] = "4376 LaSalle Line"
        $user['City'] = "Petrolia"
        $user['Province'] = "ON"
        $user['PostalCode'] = "N0N 1R0"
        $user['Country'] = "CA"
    } elseif ($user['Location'].ToUpper() -eq "CA04") {
        $user['Office'] = "CA04"
        $user['StreetAddress'] = "300 Sovereign Road"
        $user['City'] = "London"
        $user['Province'] = "ON"
        $user['PostalCode'] = "N6M 1B3"
        $user['Country'] = "CA"

        # Set default site permissions
        $user['Groups'].Add("CA04R Users")
        
        # Set OU to add user to.
        $user['OULocation'] = "TR04"

    } elseif ($user['Location'].ToUpper() -eq "US05") {
        $user['Office'] = "US05"
        $user['StreetAddress'] = "2701 Eastlake Ave E, Third Floor"
        $user['City'] = "Seattle"
        $user['Province'] = "WA"
        $user['PostalCode'] = "98102"
        $user['Country'] = "US"
    } elseif ($user['Location'].ToUpper() -eq "AU01") {
        $user['Office'] = "AU01"
        $user['StreetAddress'] = "Level 36 Gateway Tower, 1 Macquarie Place"
        $user['City'] = "Sydney"
        $user['Province'] = "NSW"
        $user['PostalCode'] = "2000"
        $user['Country'] = "Australia"
    } elseif ($user['Location'].ToUpper() -eq "DE01") {
        $user['Office'] = "DE01"
        $user['StreetAddress'] = "Potsdamer Platz, Kemperplatz 1, entrance A, 8th floor"
        $user['City'] = "Berlin"
        $user['Province'] = "BE"
        $user['PostalCode'] = "10785"
        $user['Country'] = "DE"
    } elseif ($user['Location'].ToUpper() -eq "PT01") {
        $user['Office'] = "PT01"
        $user['StreetAddress'] = "Parque Tecnológico de Cantanhede Nucleo 04, Lote 02"
        $user['City'] = "Cantanhede"
        $user['Province'] = ""
        $user['PostalCode'] = "3060-197"
        $user['Country'] = "PT"
    }

    $user['Email'] = ""

    # Set email based on company 
    if ($user['Company'].toLower() -eq "tilray") {
        $user['Email'] = $user['UserPrincipalName'] + "@tilray.com"
    }

	
	
    # Specify generic distribution groups to add user to
    $user['DistributionLists'].Add("CA00@tilray.ca")
    $user['DistributionLists'].Add("CA01@tilray.ca")

    # Set password to secure string for AD
    $user['ADPassword'] = 'P@ssword1234'
    $user['ADPassword'] = ConvertTo-SecureString $user['ADPassword'] –asplaintext –force 
    

    # Build OU path based on location for AD 
    $user['OUPath'] = "OU="+$user['Department'] + ",OU=" + $user['OULocation'] + ",DC=Tilray,DC=Local"

    # Export all user attributes to terminal
    $progress = ($user | Format-Table | Out-String)

    # Create the user in AD with all stuff. 
    #New-ADUser -Name $user['DisplayName'] -City $user['City'] -Company $user['Company'] -Country $user['Country'] -Department $user['Department'] -Description $user['JobTitle'] -DisplayName $user['DisplayName'] -EmailAddress $user['Email'] -GivenName $user['FirstName'] -Surname $user['LastName'] -Manager ($user['Supervisor'] -replace " ", ".").ToLower() -AccountPassword $user['ADPassword'] -SamAccountName $user['UserPrincipalName'] -Office $user['Office'] -StreetAddress $user['StreetAddress'] -State $user['Province'] -PostalCode $user['PostalCode'] -Title $user['JobTitle'] -MobilePhone $user['MobilePhone'] -OfficePhone $user['OfficePhone'] -OtherAttributes @{'wWWHomePage'="www.tilray.com"} -Path $user['OUPath'] -Enabled $true
    $progress += "Created user in on-prem AD"

    # Create account in Tilray.com Azure Active Directory with email using Office 365
    foreach($group in $user['Groups']){
        Add-ADGroupMember -Identity $group -Member $user['UserPrincipalName']
        $progress += "Added to AD group: $group"
    }

    # Connect to Azure AD 
    Connect-AzureAD -Credential $credential

    # Create user account in Azure AD 
    $user['O365Password'] = "Abcd@%6531"
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $user['O365Password']

    # Update displayname for GAL 
    $user['DisplayName'] = $user['DisplayName'] + " (" + $user['Company'] + ")"

    # Create the user in AzureAD/Office365
    #New-AzureADUser -PasswordProfile $PasswordProfile -AccountEnabled $true  -City $user['City'] -Country $user['Country'] -Department $user['Department'] -DisplayName $user['DisplayName'] -GivenName $user['FirstName']  -JobTitle $user['JobTitle'] -Mobile $user['MobilePhone'] -PhysicalDeliveryOfficeName $user['Office'] -PostalCode $user['PostalCode'] -ShowInAddressList $true -State $user['Province'] -StreetAddress $user['StreetAddress'] -Surname $user['LastName'] -TelephoneNumber $user['OfficePhone'] -UserPrincipalName $user['Email'] -MailNickName $user['UserPrincipalName'] -UsageLocation $user['Country']
    $progress += "Created user in Azure AD and Office 365"

    # Apply License (Office 365 Enterprise E3)
    $license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
    $licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
    $license.SkuId = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value "ENTERPRISEPACK" -EQ).SkuID
    $licenses.AddLicenses = $license
    Set-AzureADUserLicense -ObjectId $user['Email'] -AssignedLicenses $licenses
    $progress += "Applied E3 License in Office 365"

    # Add to Office 365 Distribution groups
    # NOTE: Has to be done using office 365 connection as you can't add a user to an offic 365 distribution group through Azure AD. Microsoft has mentioned this might come in the future, but there is nothing at the time of writing this. 
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $credential -Authentication Basic -AllowRedirection
    Import-PSSession $Session

    # Add user to specified distribution groups
    foreach($dl in $user['DistributionLists']){ 
        Add-DistributionGroupMember -Identity $dl -Member $user['Email']
        $progress += "Added to Office365 distribution list $dl"
    }

    # Clean up Office365 session
    Remove-PSSession $Session

    write-host $progress

} else {
    write-host "No action required, nothing has been done."
}