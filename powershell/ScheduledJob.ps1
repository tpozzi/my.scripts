Unregister-ScheduledJob systemReboot
$server=$((Get-WmiObject -Class Win32_ComputerSystem -Property Name).Name)
register-ScheduledJob -Name systemReboot -ScriptBlock {Restart-Computer -ComputerName $server -Force} -Trigger (New-JobTrigger -Once -At "$((get-date).AddDays(1).Month)/$((get-date).AddDays(1).Day)/$((get-date).AddDays(1).Year) 3:00am") -ScheduledJobOption (New-ScheduledJobOption -RunElevated)
