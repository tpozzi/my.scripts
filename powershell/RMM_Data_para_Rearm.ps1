$error.clear()
try 
{
    $tmp=(($(cscript $Env:SystemRoot\system32\slmgr.vbs -dli | Select-String "dia").ToString()).Split("(")[2]).Split(" ")[0]
    
}
catch 
{ 
    $exitcode=0
    $host.SetShouldExit($exitcode)
	 Write-Output $exitcode
    exit
}
if (!$error) {
    $string = (($(cscript $Env:SystemRoot\system32\slmgr.vbs -dli | Select-String "dia").ToString()).Split("(")[2]).Split(" ")[0]
    $culture = Get-Culture
    if ((180-[decimal]::Parse($string, $culture) -lt 165)) {
        $code = 180-[decimal]::Parse($string, $culture)
        $exitcode = 0
        $host.SetShouldExit($exitcode)
        Write-Output $code
        exit $exitcode
    }elseif((180-[decimal]::Parse($string, $culture) -ge 165) -and (180-[decimal]::Parse($string, $culture) -lt 170)){
        $code = 180-[decimal]::Parse($string, $culture)
        $exitcode = 1
        $host.SetShouldExit($exitcode)
        Write-Output $code
        exit $exitcode
    }elseif((180-[decimal]::Parse($string, $culture) -ge 170) -and (180-[decimal]::Parse($string, $culture) -lt 175)){
        $code = 180-[decimal]::Parse($string, $culture)
        $exitcode = 2
        $host.SetShouldExit($exitcode)
        Write-Output $code
        exit $exitcode
    }else{
        $code = 180-[decimal]::Parse($string, $culture)
        $exitcode = 3
        $host.SetShouldExit($exitcode)
        Write-Output $code
        exit $exitcode
    }
}
