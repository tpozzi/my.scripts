##Install-PackageProvider -Name NuGet -Force -ForceBootstrap
##Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
##Update-Module -Force -Confirm:$False
##Install-Module -Name PSFTP -Force
function Copy-Files{
	$SFF = "D:\Senior\Sapiens\PedidosWEB\Saida\" 	#Source Folder Files
	$DFF = "C:\Scripts\FTP\tmp\"					#Destination Folder Files
	#Move File from Source to Destination
	Move-Item -Path $SFF*.txt -Destination $DFF
	#Rename from txt to xml 
	$ArrayFiles = $(Get-ChildItem -Path $DFF | Where-Object {$_.Extension -eq ".txt"}).BaseName
	ForEach ($file in $ArrayFiles) {
		$filenew = "$file.xml"
		Rename-Item $DFF$file.txt $DFF$filenew
	}
}

function Copy-to-FTP{
	Import-Module PSFTP 
	$dir = "C:\Scripts\FTP\tmp\"
	$filter = "*.xml"
	$sourcefiles = Get-ChildItem -Path $dir -Filter $filter
	$FTPServer = 'ftp.x.com.br'
	$FTPUsername = 'username'
	$FTPPassword = 'password'
	$FTPSecurePassword = ConvertTo-SecureString -String $FTPPassword -asPlainText -Force
	$FTPCredential = New-Object System.Management.Automation.PSCredential($FTPUsername,$FTPSecurePassword)
	Set-FTPConnection -Credentials $FTPCredential -Server $FTPServer -Session MySession -UsePassive 
	$Session = Get-FTPConnection -Session MySession 
	ForEach ($file in $sourcefiles) {
		Write-Host " Copiando arquivo $file.Name"
		Add-FTPItem -Session $Session -LocalPath $file.Name -Path "/production/" 
	}	
}

function Move-to-BKP{
	$SFF = "C:\Scripts\FTP\tmp\" 					#Source Folder Files
	$DFF = "C:\Scripts\FTP\bkp\"					#Destination Folder Files
	Move-Item $SFF $DFF
}
Start-Transcript -path C:\Scripts\FTP\log\$(Get-Date -UFormat "log_%Y-%m-%d.log") -Append
$startTime = (Get-Date)
Write-Host "#############################################################################"
Write-Host ""
Write-Host ""

Copy-Files

Copy-to-FTP

Move-to-BKP

$endTime = (Get-Date)
$ElapsedTime = $endTime-$startTime
'Duration: {0:mm} min {0:ss} sec' -f $ElapsedTime
Write-Host ""
Write-Host ""
Write-Host "#############################################################################"
Write-Host ""
Write-Host ""
Stop-Transcript
