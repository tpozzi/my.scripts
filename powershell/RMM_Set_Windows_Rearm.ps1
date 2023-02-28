$error.clear()
function Get-InfoRearm {
	try 
	{
		$tmp=(($(cscript $Env:SystemRoot\system32\slmgr.vbs -dli | Select-String "dia").ToString()).Split("(")[2]).Split(" ")[0]
		
	}
	catch 
	{ 
		$InfoRearm=0
		$host.SetShouldExit($InfoRearm)
		Write-Output "Servidor Não Precisa de Rearm"
		exit 0
	}
	if (!$error) {
		$string = (($(cscript $Env:SystemRoot\system32\slmgr.vbs -dli | Select-String "dia").ToString()).Split("(")[2]).Split(" ")[0]
		$culture = Get-Culture
		if (([decimal]::Parse($string, $culture) -lt 5)) {
			$code = 180-[decimal]::Parse($string, $culture)
			$InfoRearm = 1
			$host.SetShouldExit($InfoRearm)
			Write-Output "Servidor Precisa de Rearm"
		}else{
		    $InfoRearm=0
		    Write-Output "Servidor Ainda Não Precisa de Rearm"
		    exit 0
		}
	}
}

function Set-Rearm {
	$(cscript $Env:SystemRoot\system32\slmgr.vbs -rearm)
}

function Set-RestartComputer {
	shutdown -r -t [decimal]::round(((Get-Date).AddDays(1).Date.AddHours(5) - (Get-Date)).TotalSeconds)
}

Get-InfoRearm
 if ( $InfoRearm -eq 1 ) {
	 Set-Rearm
	 Write-Output "Rearm Setado"
	 Set-RestartComputer
	 Write-Output "Reboot para as 5AM foi agendado"
	 exit0
 }
