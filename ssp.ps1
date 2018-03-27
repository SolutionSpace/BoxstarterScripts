
#Update Explorer settings
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions -EnableShowFullPathInTitleBar

#Install programs
cinst sysinternals
cinst sublimetext2
cinst notepadplusplus.install
cinst firefox
cinst googlechrome
cinst 7zip.install
cinst nitroreader.install

#Set Copenhagen Timezone
tzutil.exe /s 'Romance Standard Time'

#Install-WindowsUpdate