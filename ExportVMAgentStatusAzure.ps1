$date = Get-Date -UFormat "%m-%d-%Y"
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\AzureMMAAgentStatus_$($date).csv"

if(Test-Path $oFile){
	Remove-Item $oFile -Force
}

"SubscriptionName,VMName,ResourceGroupName,OSType,VMPowerStatus,WorkspaceId,WorkspaceName" | Out-File $oFile -Append -Encoding ASCII
Get-AzSubscription | ForEach-Object{
	$subscriptionId = $subscriptionName = ""
	$subscriptionId = $_.SubscriptionId
	$subscriptionName = $_.Name
	Set-AzContext -SubscriptionId $subscriptionId
    Get-AzResourceGroup | ForEach-Object{
        $rgName = $_.ResourceGroupName
        Get-AzVM -ResourceGroupName $rgName | ForEach-Object{
            $mmaExtensionDetails = $vmName = $osType = $vmStatusDetails = $linuxMMAExtensionDetails = $workspaceName = $workspaceId = $windowsMMAExtensionDetails = $linuxOMSExtensionDetails = $OMSExtensionDetails = ''
            $VMStatusDetail = "Powered On"
            $vmName = $_.Name
            $osType = $_.StorageProfile.OsDisk.OsType
            $vmStatusDetails = Get-AzVM -ResourceGroupName $rgName -Name $vmName -Status
            foreach ($VMStatus in $vmStatusDetails.Statuses)
            { 
                if($VMStatus.Code.CompareTo("PowerState/deallocated") -eq 0)
                {
                    $VMStatusDetail = $VMStatus.DisplayStatus
                }
            }
            $mmaExtensionDetails = Get-AzVMExtension -ResourceGroupName $rgName -Name MicrosoftMonitoringAgent -VMName $vmName -ErrorAction "SilentlyContinue"
            $windowsMMAExtensionDetails = Get-AzVMExtension -ResourceGroupName $rgName -Name windowsMMAAgent -VMName $vmName -ErrorAction "SilentlyContinue"
            $linuxMMAExtensionDetails = Get-AzVMExtension -ResourceGroupName $rgName -Name linuxMMAAgent -VMName $vmName -ErrorAction "SilentlyContinue"
            $linuxOMSExtensionDetails = Get-AzVMExtension -ResourceGroupName $rgName -Name OmsAgentForLinux -VMName $vmName -ErrorAction "SilentlyContinue"
            $OMSExtensionDetails = Get-AzVMExtension -ResourceGroupName $rgName -Name 'OMS.Monitoring' -VMName $vmName -ErrorAction "SilentlyContinue"
            #MicrosoftMonitoringAgent OMS.Monitoring
            if(!([string]::IsNullOrEmpty($mmaExtensionDetails))){
                $workspaceId = $mmaExtensionDetails.PublicSettings | ConvertFrom-Json | Select-Object workspaceId -ExpandProperty workspaceId
                $workspaceName = Get-AzOperationalInsightsWorkspace | Where-Object{$_.CustomerId -eq $workspaceId} | Select-Object Name -ExpandProperty Name
            }
            #windowsMMAAgent
            if(!([string]::IsNullOrEmpty($windowsMMAExtensionDetails))){
                $workspaceId = $windowsMMAExtensionDetails.PublicSettings | ConvertFrom-Json | Select-Object workspaceId -ExpandProperty workspaceId
                $workspaceName = Get-AzOperationalInsightsWorkspace | Where-Object{$_.CustomerId -eq $workspaceId} | Select-Object Name -ExpandProperty Name
            }
            #linuxMMAAgent OmsAgentForLinux
            if(!([string]::IsNullOrEmpty($linuxMMAExtensionDetails))){
                $workspaceId = $linuxMMAExtensionDetails.PublicSettings | ConvertFrom-Json | Select-Object workspaceId -ExpandProperty workspaceId
                $workspaceName = Get-AzOperationalInsightsWorkspace | Where-Object{$_.CustomerId -eq $workspaceId} | Select-Object Name -ExpandProperty Name
            }
            #OmsAgentForLinux
            if(!([string]::IsNullOrEmpty($linuxOMSExtensionDetails))){
                $workspaceId = $linuxOMSExtensionDetails.PublicSettings | ConvertFrom-Json | Select-Object workspaceId -ExpandProperty workspaceId
                $workspaceName = Get-AzOperationalInsightsWorkspace | Where-Object{$_.CustomerId -eq $workspaceId} | Select-Object Name -ExpandProperty Name
            }
            #OmsAgentForLinux
            if(!([string]::IsNullOrEmpty($OMSExtensionDetails))){
                $workspaceId = $OMSExtensionDetails.PublicSettings | ConvertFrom-Json | Select-Object workspaceId -ExpandProperty workspaceId
                $workspaceName = Get-AzOperationalInsightsWorkspace | Where-Object{$_.CustomerId -eq $workspaceId} | Select-Object Name -ExpandProperty Name
            }
            "$subscriptionName,$vmName,$rgName,$osType,$VMStatusDetail,$workspaceId,$workspaceName"  | Out-File $oFile -Append -Encoding ASCII
        }
    }
}