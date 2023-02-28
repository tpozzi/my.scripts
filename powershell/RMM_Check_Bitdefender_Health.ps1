Function Test-CommandExists

{
	Param ($command)

	$oldPreference = $ErrorActionPreference

	$ErrorActionPreference = "stop"

	try {if(Get-Command $command){"$command exists"}}

	Catch {
		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
		Install-Module -Name BitdefenderHealth -Force -AllowClobber -Verbose
	}

	Finally {$ErrorActionPreference=$oldPreference}

} #end function test-CommandExists

Test-CommandExists Test-Service

#ValueFromPipeline = $true
#ValueFromPipelineByPropertyName = $true
$BitdefenderProcessName = 'epsecurityservice'
$BitdefenderInstallationPath = 'C:\Program Files\Bitdefender\Endpoint Security\epsecurityservice.exe'

	
function Test-BitdefenderProcess-new {
	param (
		[string]$BitdefenderProcessName
	)

	try {
		$BitdefenderProcess = Get-Process -Name $BitdefenderProcessName -ErrorAction Stop
		if ($BitdefenderProcess) {
			$IsBitdefenderProcessRunning = $true
			$IsBitdefenderProcessRunning
		}
		
	}
	catch [Microsoft.PowerShell.Commands.ProcessCommandException] {
		Write-Warning "Unable to find process $BitdefenderProcessName"
		$IsBitdefenderProcessRunning = $false
		$IsBitdefenderProcessRunning
	}
	catch {
		Write-Warning $_.Exception.Message
		$IsBitdefenderProcessRunning = $false
		$IsBitdefenderProcessRunning
	}
	
}


function Test-BitdefenderInstallationPath {
	param (
		[string]$BitdefenderInstallationPath
	)

	$IsBitdefenderInstalled = Test-Path -Path $BitdefenderInstallationPath
	if (!($IsBitdefenderInstalled)) {
		Write-Warning "Unable to find $BitdefenderInstallationPath on $env:COMPUTERNAME"
	}
	$IsBitdefenderInstalled

}




# Is Bitdefender Installed
Write-Verbose -Message "Check if Bitdefender is installed at $BitdefenderInstallationPath."
$IsBitdefenderInstalled = Test-BitdefenderInstallationPath $BitdefenderInstallationPath

if ($IsBitdefenderInstalled) {
	# Is Bitdefender Running
	Write-Verbose -Message "Check if $BitdefenderProcessName is running."
	$IsBitdefenderProcessRunning = Test-BitdefenderProcess-new $BitdefenderProcessName

	# Is Bitdefender Security Service configured
	$BitdefenderSecurityServiceName = 'EPSecurityService'
	Write-Verbose -Message "Check Bitdefender service $BitdefenderSecurityServiceName"
	$BitdefenderService = Test-Service $BitdefenderSecurityServiceName
	$IsBitdefenderServiceHealthy = $BitdefenderService.ServiceExists -and $BitdefenderService.IsRunning -and $BitdefenderService.IsAutomatic

	# Is Bitdefender up to date
	Write-Verbose "Bitdefender signature date: $BitdefenderSignatureDate"
	$BitdefenderUpdateFileData = Get-BitdefenderUpdateFileData -ErrorAction SilentlyContinue

	
}
else {
	$IsBitdefenderProcessRunning = $false
	$IsBitdefenderServiceHealthy = $false
}



# Creating Object
$BitdefenderStatusProperties = [ordered]@{
	IsBitdefenderInstalled          = $IsBitdefenderInstalled
	IsBitdefenderProcessRunning     = $IsBitdefenderProcessRunning
	IsBitdefenderServiceHealthy     = $IsBitdefenderServiceHealthy
	IsBitdefenderHealthy            = $IsBitdefenderInstalled -and $IsBitdefenderProcessRunning -and $IsBitdefenderServiceHealthy
	IsServiceExists					= $BitdefenderService.ServiceExists
	IsServiceIsRunning				= $BitdefenderService.IsRunning
	IsServiceIsAutomatic			= $BitdefenderService.IsAutomatic
	SignatureVersion                = $BitdefenderUpdateFileData.Version
	SignatureNumber                 = $BitdefenderUpdateFileData.'Signature Number'
	SignatureUpdateTime             = $BitdefenderUpdateFileData.'Update time'

}
$BitdefenderStatus = New-Object -TypeName PSCustomObject -Property $BitdefenderStatusProperties
$BitdefenderStatus

$everythinisok = $IsBitdefenderInstalled -and $IsBitdefenderProcessRunning -and $IsBitdefenderServiceHealthy -and $IsBitdefenderInstalled -and $IsBitdefenderProcessRunning -and $IsBitdefenderServiceHealthy
if ($everythinisok -eq $true) { 
	exit 0
}else{
	exit 1
}
