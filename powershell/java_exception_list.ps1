$javafile = "$env:USERPROFILE\AppData\LocalLow\Sun\Java\Deployment\security\exception.sites"
$MyFile = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tpozzi/my.scripts/master/powershell/listaconectividadesocial.txt"

Add-Content $javafile "http://caixa.gov.br/"
foreach ($line in $Myfile.Content){
    Write-Host $line
     if (! (select-string -quiet $line $javafile)) {
            Add-Content $javafile $line
        }
    }
