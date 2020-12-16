$GooglePolicyObj = $null
$GooglePolicyObj = Get-ItemProperty -Path HKCU:\SOFTWARE\Policies\Google\Chrome -Name "UserDataDir"
$GoogleUserDir = $env:LOCALAPPDATA + "\Google\Chrome\User Data"
if ($GooglePolicyObj -ne $null) {
    $GoogleUserDir = $GooglePolicyObj.UserDataDir -replace "\$\{documents\}", [Environment]::GetFolderPath("MyDocuments")
}
$jsonPath = $GoogleUserDir + "\Local State"
if (![System.IO.File]::Exists($jsonPath)) {
    Write-Host ($jsonPath + " does not exist, strange")
    return
}
Write-Host ("Local State .json location: " + $jsonPath)
$jsonRaw = Get-Content -Raw -Path ($jsonPath)
$jsonRaw = $jsonRaw -replace "`"`":", "`"ReplaceBackToEmpty684`":"
$json = $jsonRaw | ConvertFrom-Json
if ($json.browser -eq $null) {
    # Create browser boject with, enabled_labs_experiments object
    $browser = New-Object PSObject
    $browser | add-member -NotePropertyName enabled_labs_experiments -NotePropertyValue "-"
    $browser.enabled_labs_experiments = @("enable-lazy-frame-loading@3")
    $json | add-member -NotePropertyName browser -NotePropertyValue $browser
} else {
    if ($json.browser.enabled_labs_experiments -eq $null) {
        # Create enabled_labs_experiments object
        $json.browser | add-member -NotePropertyName enabled_labs_experiments -NotePropertyValue "-"
        $json.browser.enabled_labs_experiments = @("enable-lazy-frame-loading@3")
    } else {
        # Patch existing enabled_labs_experiments object
        if (($json.browser.enabled_labs_experiments.GetType()).BaseType.ToString() -eq "System.Array") {
            if ($json.browser.enabled_labs_experiments.Contains("enable-lazy-frame-loading@3")) {
                "Lazy Frame loading already Disabled"
            } else {
                if (($json.browser.enabled_labs_experiments.GetType()).BaseType.ToString() -eq "System.Array") {
                    # Patch occlusion
                    # Add to array
                    $json.browser.enabled_labs_experiments += "enable-lazy-frame-loading@3"
                } 
            }
        } else {
            # Patch occlusion
            $json.browser.enabled_labs_experiments = @("enable-lazy-frame-loading@3")
        }
    }
}

Copy-Item $jsonPath ($jsonPath+".bak") -Force

$jsonRaw = $json | convertto-json -Compress -depth 100
$jsonRaw -replace "`"ReplaceBackToEmpty684`":", "`"`":" | out-file $jsonPath -Encoding utf8