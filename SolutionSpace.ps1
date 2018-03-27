#Util
function Replace-InFile
{
	param([String] $File, [String] $Find, [String] $Replace, [bool] $AppendIfNotFound = $False)
	$Contains = $False
	(Get-Content ($File)) | Foreach-Object {if ($_ -match $Find) { $Contains = $True}; $_ -replace $Find, $Replace} | Set-Content ($File)
	if ($AppendIfNotFound -and (-not $Contains))
	{
		Add-Content $File $Replace
	}
}

function Remove-InFile
{
	param([String] $File, [String] $Find)
	(Get-Content ($File)) | Foreach-Object {if (-not ($_ -match $Find)) { $_ }} | Set-Content ($File)
}

function Disable-JavaAutoupdate
{
	Write-Output "Disabling Java AutoUpdate"
	try
	{
		if (Test-Path 'HKLM:\SOFTWARE\WOW6432Node\JavaSoft\Java Update\Policy')
		{
			Set-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\JavaSoft\Java Update\Policy' -Name 'EnableJavaUpdate' -Value 0
			Remove-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run' -Name 'SunJavaUpdateSched'
		}
		if (Test-Path 'HKLM:\SOFTWARE\JavaSoft\Java Update\Policy')
		{
			Set-ItemProperty -Path 'HKLM:\SOFTWARE\JavaSoft\Java Update\Policy' -Name 'EnableJavaUpdate' -Value 0
			Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'SunJavaUpdateSched'
		}
		Write-Output "Java AutoUpdate successfully disabled"
	}
	catch 
	{
		Write-Output "ERROR disabling Java AutoUpdate"
	}
}

function Set-JavaSecurity
{
	param([ValidateSet(,'MEDIUM','HIGH','VERY_HIGH')] [String] $Level)
	Write-Output "Changing Java Security Settings to $Level"
	try 
	{
		#TODO: also in $env:USERPROFILE\AppData\LocalLow\Sun\Java\Deployment\deployment.properties
		if ("$Level" = 'HIGH')
		{
			Remove-ItemProperty -Path 'HKCU:\Software\AppDataLow\Software\JavaSoft\DeploymentProperties' -Name 'deployment.security.level'
			Remove-InFile "$env:USERPROFILE\AppData\LocalLow\Sun\Java\Deployment\deployment.properties" '^deployment.security.level*$'
		}
		else
		{
			Set-ItemProperty -Path 'HKCU:\Software\AppDataLow\Software\JavaSoft\DeploymentProperties' -Name 'deployment.security.level' -Value $Level -Force
			Replace-InFile "$env:USERPROFILE\AppData\LocalLow\Sun\Java\Deployment\deployment.properties" '^deployment.security.level*$' "deployment.security.level=$Level" $True
		}
		Write-Output "Java Security Settings successfully changed"
	}
	catch 
	{
		Write-Output "ERROR changing Java Security Settings"
	}
}

function Add-JavaSecurityException
{
	param([String] $Site)
	$File = "$env:USERPROFILE\AppData\LocalLow\Sun\Java\Deployment\security\exception.sites"
	if (-not (Test-Path "$File"))
	{
		New-Item "$File" -type file
	}
	if ((Get-Content "$File" | %{$_ -match "$Site"}) -contains $True)
	{
		Write-Output "Security Exception already exists"
	}
	else
	{
		try
		{
			Add-Content "$File" "$Site`r`n"
			Write-Output "Security Exception added"
		}
		catch
		{
			Write-Output "ERROR while adding security exception"
		}
	}
}

function Enable-IEFavoriteBar
{
	Write-Output "Enabling IE Favorite bar"
	try 
	{
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\MINIE' -Name 'LinksBandEnabled' -Value '1'
		Write-Output "IE Favorite bar enabled"
	}
	catch
	{
		Write-Output "ERROR enabling IE Favorite bar"
	}
}

function Add-IEFavoriteLink
{
	param([String] $Folder, [String] $Name, [String] $Url)
	
	$Favfolder = "$env:USERPROFILE\Favorites\Links\$Folder"
	$Favfile = "$Favfolder\$Name.url"
	if (-not (Test-Path "$Favfolder"))
	{
		New-Item $Favfolder -type directory
	}
	New-Item "$Favfile" -type file -force
	Add-Content "$Favfile" "[InternetShortcut]`nURL=$Url"
}

function Add-IntranetSite
{
	param([String] $Site, [ValidateSet('http','https')] [String] $Protocol)
	$Key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\$Site"
	if (-not (Test-Path "$Key"))
	{
		New-Item "$Key" -type container
	}
	try
	{
		Set-ItemProperty -Path "$Key" -Name "$Protocol" -Value '1'
	}
	catch
	{
		Write-Output "ERROR adding intranet site $Site"
	}
}

function Add-SiteLogin
{
	params([String] $Server, [String] $User, [String] $Password)
	
	#TODO: loop
	(New-Object System.Net.WebClient).DownloadFile("https://app.assembla.com/spaces/boxstarter-scripts/subversion/source/HEAD/CredMan.ps1?_format=raw", "$env:TEMP\CredMan.ps1")
	. "$env:TEMP\CredMan.ps1" -AddCred -Target "$Server" -User "$User" -Password "$Password" -Comment "Added By SolutionSpace.ps1"
}

function Disable-WindowsUpdate
{
	Stop-Service "wuauserv" -force
	Set-Service -Name "wuauserv" -StartupType "Disabled"
}

function Enable-PasswordSuggestion
{
	try
	{
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete" -Name "AutoSuggest" -Value 'yes'
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "Use FormSuggest" -Value 'yes'
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "FormSuggest Passwords" -Value 'yes'
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "FormSuggest PW Ask" -Value 'yes'
	}
	catch
	{
		Write-Output "ERROR enabling Password Suggestion"
	}
}