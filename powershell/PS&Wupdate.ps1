$TestHKU=($(Get-PSDrive -Name HKU).name) 2>$null
if ($TestHKU -eq "HKU") {echo "Drive ready"} else {New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS}
$Path1 = "HKU:\S-1-5-18\Software\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate"
$Name1 = "DisableWindowsUpdateAccess"
$Value1 = "0x0"

If (!(Test-Path $Path1)) {
    New-Item -Path $Path1 -Force | Out-Null
    New-ItemProperty -Path $Path1 -Name $Name1 -Value $Value1 -PropertyType DWORD -Force | Out-Null
}

Else {
    New-ItemProperty -Path $Path1 -Name $Name1 -Value $Value1 -PropertyType DWORD -Force | Out-Null
}
###https://lokna.no/?p=2132
###https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc
###https://superuser.com/questions/462425/can-i-invoke-windows-update-from-the-command-line
###https://social.technet.microsoft.com/Forums/windows/en-US/c18a95b4-2235-49e8-a1b2-fb47bd0111ab/run-windows-update-from-commandline-manually-cause-update-check?forum=win10itprogeneral
Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -AddServiceFlag 7 -Confirm:$false
Install-Module PSWindowsUpdate -Force -Confirm:$false
$OutputFileLocation = "C:\Windows\temp\getupdate.log"
Write-Host "This will go into getupdate.log"
Get-WindowsUpdate -AcceptAll -Confirm:$false | Out-File -FilePath $OutputFileLocation ; cat $OutputFileLocation

$OutputFileLocation = "C:\Windows\temp\installupdate.log"
Write-Host "This will go into installupdate.log"
Install-WindowsUpdate -AcceptAll -IgnoreReboot -Confirm:$false | Out-File -FilePath $OutputFileLocation ; cat $OutputFileLocation
