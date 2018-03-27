#import script
$success = $false
while (-not $success)
{
	try 
	{
		(New-Object System.Net.WebClient).DownloadFile("https://app.assembla.com/spaces/boxstarter-scripts/subversion/source/HEAD/SolutionSpace.ps1?_format=raw", "$env:TEMP\SolutionSpace.ps1")
		$success = $true
	}
	catch {} 
}
. "$env:TEMP\SolutionSpace.ps1"

#Update Explorer settings
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions -EnableShowFullPathInTitleBar

#Install programs
cinst sysinternals
cinst sublimetext2
cinst notepadplusplus.install
cinst firefox
cinst googlechrome
cinst jdk7
cinst 7zip.install
cinst nitroreader.install

#Set Copenhagen Timezone
tzutil.exe /s 'Romance Standard Time'

Disable-JavaAutoupdate

Set-JavaSecurity 'MEDIUM'

Add-JavaSecurityException 'http://*.uponor.local'

Enable-IEFavoriteBar

Add-IEFavoriteLink "Uponor" "ERP RICEF" "http://u2erp-config.uponor.local/OA_HTML/AppsLogin"

Add-IntranetSite "uponor.local" "http"

Disable-WindowsUpdate