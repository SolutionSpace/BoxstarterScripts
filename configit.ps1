##import script
#$success = $false
#while (-not $success)
#{
#	try 
#	{
#		(New-Object System.Net.WebClient).DownloadFile("https://app.assembla.com/spaces/boxstarter-scripts/subversion/source/HEAD/SolutionSpace.ps1?_format=raw", "$env:TEMP\SolutionSpace.ps1")
#		$success = $true
#	}
#	catch {} 
#}
#. "$env:TEMP\SolutionSpace.ps1"

#Update Explorer settings
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions -EnableShowFullPathInTitleBar

#Install programs
cinst sysinternals
cinst sublimetext2
cinst notepadplusplus.install
cinst firefox
cinst googlechrome
cinst 7zip.install

#Set Copenhagen Timezone
tzutil.exe /s 'Romance Standard Time'

#Set Danish keyboard layout
Set-WinUserLanguageList -LanguageList DA-DK