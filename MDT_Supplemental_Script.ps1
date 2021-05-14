# Set the DPI to 96 to enforce 100% screen magnification instead of the default 150%
    cd 'HKCU:\Control Panel\Desktop'
    Set-ItemProperty -Path . -Name LogPixels -Value 96
    Set-ItemProperty -Path . -Name Win8DpiScaling -Value 1


# Disable the windows store
    reg add HKLM\SOFTWARE\Policies\Microsoft\WindowsStore /t REG_DWORD /v RemoveWindowsStore /d 1 /f

# Remove default windows applications windows 8/8.1/10
    Get-AppxPackage Microsoft.Windows.ParentalControls | Remove-AppxPackage
    Get-AppxPackage Windows.ContactSupport | Remove-AppxPackage
    Get-AppxPackage Microsoft.Xbox* | Remove-AppxPackage
    Get-AppxPackage microsoft.windowscommunicationsapps | Remove-AppxPackage # Mail and Calendar
    Get-AppxPackage Microsoft.WindowsCamera | Remove-AppxPackage
    Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage
    Get-AppxPackage Microsoft.Zune* | Remove-AppxPackage
    Get-AppxPackage Microsoft.WindowsPhone | Remove-AppxPackage # Phone Companion
    Get-AppxPackage Microsoft.WindowsMaps | Remove-AppxPackage
    Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage
    Get-AppxPackage Microsoft.Office.Sway | Remove-AppxPackage
    Get-AppxPackage Microsoft.Appconnector | Remove-AppxPackage
    Get-AppxPackage Microsoft.WindowsFeedback* | Remove-AppxPackage
    Get-AppxPackage Microsoft.Windows.FeatureOnDemand.InsiderHub | Remove-AppxPackage
    Get-AppxPackage Microsoft.Windows.Cortana | Remove-AppxPackage
    Get-AppxPackage Microsoft.People | Remove-AppxPackage
    Get-AppxPackage Microsoft.Bing* | Remove-AppxPackage # Money, Sports, News, Finance and Weather
    Get-AppxPackage Microsoft.Getstarted | Remove-AppxPackage
    Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage
    Get-AppxPackage Microsoft.WindowsSoundRecorder | Remove-AppxPackage
    Get-AppxPackage Microsoft.3DBuilder | Remove-AppxPackage
    Get-AppxPackage Microsoft.Messaging | Remove-AppxPackage
    Get-AppxPackage Microsoft.CommsPhone | Remove-AppxPackage
    Get-AppxPackage Microsoft.Advertising.Xaml | Remove-AppxPackage
    Get-AppxPackage Microsoft.Windows.SecondaryTileExperience | Remove-AppxPackage
    Get-AppxPackage Microsoft.Windows.ParentalControls | Remove-AppxPackage
    Get-AppxPackage Microsoft.Windows.ContentDeliveryManager | Remove-AppxPackage
    Get-AppxPackage Microsoft.Windows.CloudExperienceHost | Remove-AppxPackage
    Get-AppxPackage Microsoft.Windows.ShellExperienceHost | Remove-AppxPackage
    Get-AppxPackage Microsoft.BioEnrollment | Remove-AppxPackage
    Get-AppxPackage Microsoft.OneConnect | Remove-AppxPackage
    Get-AppxPackage *Twitter* | Remove-AppxPackage
    Get-AppxPackage king.com.CandyCrushSodaSaga | Remove-AppxPackage
    Get-AppxPackage flaregamesGmbH.RoyalRevolt2 | Remove-AppxPackage
    Get-AppxPackage *Netflix | Remove-AppxPackage
    Get-AppxPackage Facebook.Facebook | Remove-AppxPackage
    Get-AppxPackage Microsoft.MinecraftUWP | Remove-AppxPackage
    Get-AppxPackage *MarchofEmpires | Remove-AppxPackage
    Get-AppxPackage Microsoft.WindowsStore | Remove-AppxPackage
    get-appxpackage *edge* | Remove-AppxPackage

# Function to remove pinned applications
function Set-PinnedApplication 
{ 
       [CmdletBinding()] 
       param( 
      [Parameter(Mandatory=$true)][string]$Action,  
      [Parameter(Mandatory=$true)][string]$FilePath 
       ) 
       if(-not (test-path $FilePath)) {  
           throw "FilePath does not exist."   
    } 
    
       function InvokeVerb { 
           param([string]$FilePath,$verb) 
        $verb = $verb.Replace("&","") 
        $path= split-path $FilePath 
        $shell=new-object -com "Shell.Application"  
        $folder=$shell.Namespace($path)    
        $item = $folder.Parsename((split-path $FilePath -leaf)) 
        $itemVerb = $item.Verbs() | ? {$_.Name.Replace("&","") -eq $verb} 
        if($itemVerb -eq $null){ 
            throw "Verb $verb not found."             
        } else { 
            $itemVerb.DoIt() 
        } 
            
       } 
    function GetVerb { 
        param([int]$verbId) 
        try { 
            $t = [type]"CosmosKey.Util.MuiHelper" 
        } catch { 
            $def = [Text.StringBuilder]"" 
            [void]$def.AppendLine('[DllImport("user32.dll")]') 
            [void]$def.AppendLine('public static extern int LoadString(IntPtr h,uint id, System.Text.StringBuilder sb,int maxBuffer);') 
            [void]$def.AppendLine('[DllImport("kernel32.dll")]') 
            [void]$def.AppendLine('public static extern IntPtr LoadLibrary(string s);') 
            add-type -MemberDefinition $def.ToString() -name MuiHelper -namespace CosmosKey.Util             
        } 
        if($global:CosmosKey_Utils_MuiHelper_Shell32 -eq $null){         
            $global:CosmosKey_Utils_MuiHelper_Shell32 = [CosmosKey.Util.MuiHelper]::LoadLibrary("shell32.dll") 
        } 
        $maxVerbLength=255 
        $verbBuilder = new-object Text.StringBuilder "",$maxVerbLength 
        [void][CosmosKey.Util.MuiHelper]::LoadString($CosmosKey_Utils_MuiHelper_Shell32,$verbId,$verbBuilder,$maxVerbLength) 
        return $verbBuilder.ToString() 
    } 
 
    $verbs = @{  
        "PintoStartMenu"=5381 
        "UnpinfromStartMenu"=5382 
        "PintoTaskbar"=5386 
        "UnpinfromTaskbar"=5387 
    } 
        
    if($verbs.$Action -eq $null){ 
           Throw "Action $action not supported`nSupported actions are:`n`tPintoStartMenu`n`tUnpinfromStartMenu`n`tPintoTaskbar`n`tUnpinfromTaskbar" 
    } 
    InvokeVerb -FilePath $FilePath -Verb $(GetVerb -VerbId $verbs.$action) 
}

# Remove windows store from task bar
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Store.lnk")
$Shortcut.TargetPath = "C:\Windows\WinStore\WinStore.htm"
$Shortcut.Save()
#Set-PinnedApplication -Action PintoTaskbar -FilePath "$env:USERPROFILE\Store.lnk"
Set-PinnedApplication -Action UnPinFromTaskbar -FilePath "$env:USERPROFILE\Store.lnk"
Remove-Item $env:USERPROFILE\Store.lnk

# Remove Internet Explorer from task bar
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Internet Explorer.lnk")
$Shortcut.TargetPath = "C:\Program Files\Internet Explorer\iexplore.exe"
$Shortcut.Save()
#Set-PinnedApplication -Action PintoTaskbar -FilePath "$env:USERPROFILE\Internet Explorer.lnk"
Set-PinnedApplication -Action UnPinFromTaskbar -FilePath "$env:USERPROFILE\Internet Explorer.lnk"
Remove-Item "$env:USERPROFILE\Internet Explorer.lnk"

$path= "C:\Program Files\Microsoft Office\root\Office16\"

if (Test-Path $path) {

    # Create a microsoft office shortcuts folder
    New-Item -ItemType Directory -Force -Path "$env:Public\Desktop\Microsoft Office 2016\"

    # Create Excel shortcut
    $TargetFile = "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE"
    $ShortcutFile = "$env:Public\Desktop\Microsoft Office 2016\Excel.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.Save()

    # Create Outlook shortcut
    $TargetFile = "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE"
    $ShortcutFile = "$env:Public\Desktop\Microsoft Office 2016\Outlook.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.Save()

    # Create Word shortcut
    $TargetFile = "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"
    $ShortcutFile = "$env:Public\Desktop\Microsoft Office 2016\Word.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.Save()

    # Create Skype/Lync shortcut
    $TargetFile = "C:\Program Files\Microsoft Office\root\Office16\lync.EXE"
    $ShortcutFile = "$env:Public\Desktop\Microsoft Office 2016\Skype.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.Save()

    # Create Powerpoint shortcut
    $TargetFile = "C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE"
    $ShortcutFile = "$env:Public\Desktop\Microsoft Office 2016\PowerPoint.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.Save()

    # Create Powerpoint shortcut
    $TargetFile = "C:\Program Files\Microsoft Office\root\Office16\ONENOTE.EXE"
    $ShortcutFile = "$env:Public\Desktop\Microsoft Office 2016\OneNote.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.Save()

    # Create Access shortcut
    $TargetFile = "C:\Program Files\Microsoft Office\root\Office16\MSACCESS.EXE"
    $ShortcutFile = "$env:Public\Desktop\Microsoft Office 2016\Access.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.Save()

    # Create OneDrive shortcut
    $TargetFile = "C:\Program Files\Microsoft Office\root\Office16\GROOVE.EXE"
    $ShortcutFile = "$env:Public\Desktop\Microsoft Office 2016\OneDrive.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.Save()
}