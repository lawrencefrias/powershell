# Script to connect VPN after connected to Internet and not on LAN
# Use at own risk
$InternetHost="8.8.8.8"
$LanHost="ccap-addc01.TILRAY.local"
$VPNName="VPN (Europe)"
$VPNUserName=""
$VPNPassword=""


While ($True)
{
# Loop until the InternetHost is reachable and we are connected to the internet
while (!(Test-connection $InternetHost -Count 1 -Quiet)) {
    sleep 1
    }
sleep 1
# Check if LanHost is reachable if so we are on the Lan if not we need to dial the VPN
If(!(Test-connection $LanHost -Count 2 -Quiet))
 {
 #Not on LAN OpenVPN
 $Arguments = -join("""$VPNName"""+" "+"""$VPNUserName"""+" "+"""$VPNpassword""")
 write $Arguments
 $RasDialResult = (Start-Process rasdial -NoNewWindow -ArgumentList "$Arguments" -PassThru -Wait).ExitCode
 $a = New-Object -comobject wscript.shell
 Write-Host $RasDialResult
 If($RasDialResult -eq 0) 
 # {   $b - $a.popup("VPN connected", 4,"",0)}
 {}
 else
    {$b - $a.popup("VPN failed to connect", 6,"",0)}
  }
else
{
#On LAN no need to dial VPN
 Write-Host "on Lan"}
}