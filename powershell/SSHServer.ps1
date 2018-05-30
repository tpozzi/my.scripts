##Downloading Powershell SSH server instalator
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v7.6.1.0p1-Beta/OpenSSH-Win64.zip" -OutFile "C:\test\OpenSSH-Win64.zip"

##Unziping process
$shell = New-Object -ComObject shell.application
$zip = $shell.NameSpace("C:\test\OpenSSH-Win64.zip")
foreach ($item in $zip.items()) {
  $shell.Namespace("$Env:PROGRAMFILES").CopyHere($item)
}
mv $Env:PROGRAMFILES\OpenSSH-Win64 $Env:PROGRAMFILES\OpenSSH
##Installing the SSH server
(Get-Content $Env:PROGRAMFILES\OpenSSH\sshd_config_default).Replace('#PasswordAuthentication yes', 'PasswordAuthentication yes') | Out-File $Env:PROGRAMFILES\OpenSSH\sshd_config
powershell.exe -ExecutionPolicy Bypass -File $Env:PROGRAMFILES\OpenSSH\install-sshd.ps1
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
netsh advfirewall firewall add rule name=sshd dir=in action=allow protocol=TCP localport=22
net start sshd
Powershell.exe -ExecutionPolicy Bypass -Command '. $Env:PROGRAMFILES\OpenSSH\FixHostFilePermissions.ps1 -Confirm:$false'
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShellCommandOption -Value "/c" -PropertyType String -Force
