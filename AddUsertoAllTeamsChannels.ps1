$TeamName=Read-Host Enter Teams name "(Case Sensitive)"
$email=Read-Host Enter Team member e-mail
      Write-Host Getting Channels list...
      $Count=0
      $GroupId=(Get-Team -DisplayName $TeamName).GroupId
      Get-TeamChannel -GroupId $GroupId | Foreach {
       $ChannelName=$_.DisplayName
       Write-Host -Activity "`n     Processed channel count: $Count "`n"  Currently Processing Channel: $ChannelName"
       Add-TeamChannelUser -GroupId $GroupId -DisplayName $ChannelName -user $email
       $Count++
       $MembershipType=$_.MembershipType
       $Result=@{'Teams Name'=$TeamName;'Channel Name'=$ChannelName;'Membership Type'=$MembershipType;'Description'=$Description}
       $Results= New-Object psobject -Property $Result
      }
