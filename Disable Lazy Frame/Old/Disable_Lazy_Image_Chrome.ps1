$old='enabled_labs_experiments":['
$new='enabled_labs_experiments":["enable-lazy-image-loading@3",'

(Get-Content $env:LOCALAPPDATA"\Google\Chrome\User Data\Local State") | ForEach-Object {$_.replace($old, $new)} | Set-Content $env:LOCALAPPDATA"\Google\Chrome\User Data\Local State"