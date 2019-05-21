##Install-PackageProvider -Name NuGet -Force -ForceBootstrap
##Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
##Update-Module -Force -Confirm:$False
##Install-Module -Name PSFTP -Force
Start-Transcript -path D:\Backup\GrafitusaOficial\Enviar\log\$(Get-Date -UFormat "log_%Y-%m-%d.log") -Append
$startTime = (Get-Date)
Write-Host "#############################################################################"
Write-Host ""
Write-Host ""
$dir = "D:\Backup\GrafitusaOficial\"
$filter = "*.bak"
$latest = Get-ChildItem -Path $dir -Filter $filter | Sort-Object LastAccessTime -Descending | Select-Object -First 1
$sourcefiles = "D:\Backup\GrafitusaOficial\$latest.name"
$zipedfilename = "D:\Backup\GrafitusaOficial\Enviar\$([io.path]::GetFileNameWithoutExtension($latest.name)).zip"
Compress-Archive -Path $dir$latest -CompressionLevel Optimal -DestinationPath $zipedfilename -Force

Import-Module PSFTP 
$FTPServer = 'ftp.address'
$FTPUsername = 'username'
$FTPPassword = 'senha'
$FTPSecurePassword = ConvertTo-SecureString -String $FTPPassword -asPlainText -Force
$FTPCredential = New-Object System.Management.Automation.PSCredential($FTPUsername,$FTPSecurePassword)

Set-FTPConnection -Credentials $FTPCredential -Server $FTPServer -Session MySession -UsePassive 
$Session = Get-FTPConnection -Session MySession 

Add-FTPItem -Session $Session -LocalPath $zipedfilename -Path "/BACKUP/" 
Remove-Item –path $zipedfilename -Force
$endTime = (Get-Date)
$ElapsedTime = $endTime-$startTime
'Duration: {0:mm} min {0:ss} sec' -f $ElapsedTime
Write-Host ""
Write-Host ""
Write-Host "#############################################################################"
Write-Host ""
Write-Host ""
Stop-Transcript
