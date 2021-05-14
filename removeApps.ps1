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



reg add HKLM\SOFTWARE\Policies\Microsoft\WindowsStore \t REG_DWORD \v RemoveWindowsStore \d 1 \f