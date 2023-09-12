@echo off

:: To reset folder view settings of all folders
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\Shell\BagMRU" /F
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags" /F

Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\ShellNoRoam\Bags" /F
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\ShellNoRoam\BagMRU" /F

Reg Delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /F
Reg Delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /F

Reg Delete "HKCU\SOFTWARE\Classes\Wow6432Node\Local Settings\Software\Microsoft\Windows\Shell\Bags" /F
Reg Delete "HKCU\SOFTWARE\Classes\Wow6432Node\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /F


:: To reset "Apply to Folders" views to default
REG Delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams\Defaults" /F


:: To reset size of details, navigation, preview panes to default
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer" /F


:: To kill and restart explorer
taskkill /f /im explorer.exe
start explorer.exe
