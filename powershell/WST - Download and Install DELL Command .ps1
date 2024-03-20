$MyApp = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Dell Command | Update"}
$MyApp.Uninstall()

if (-not (Test-Path "C:\tmp")) {
    # Se não existe, cria a pasta
    New-Item -ItemType Directory -Path "C:\tmp" | Out-Null
    Write-Host "Pasta 'tmp' criada com sucesso!"
} else {
    Write-Host "A pasta 'tmp' já existe."
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36"
$Path = "C:\tmp\Dell-Command.EXE"
$URL = 'https://dl.dell.com/FOLDER11201586M/1/Dell-Command-Update-Windows-Universal-Application_0XNVX_WIN_5.2.0_A00.EXE'
Invoke-WebRequest -Uri $URL -OutFile $Path -ErrorAction SilentlyContinue -WebSession $session -Headers @{
 "method"="POST"
  "authority"="www.dell.com"
  "scheme"="https"
  "path"="/support/home/en-us/product-support/servicetag/14m1dh2/overview"
  "sec-ch-ua"="`" Not A;Brand`";v=`"99`", `"Chromium`";v=`"99`", `"Google Chrome`";v=`"99`""
  "sec-ch-ua-mobile"="?0"
  "sec-ch-ua-platform"="`"Windows`""
  "upgrade-insecure-requests"="1"
  "accept"="text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
  "sec-fetch-site"="none"
  "sec-fetch-mode"="navigate"
  "sec-fetch-user"="?1"
  "sec-fetch-dest"="document"
  "accept-encoding"="gzip, deflate, br"
  "accept-language"="en-US,en;q=0.9"
} | Write-Progress -Activity "Downloading file" -Status "Progress"
Start-Process -Wait -FilePath $Path -Argument "/s" -PassThru
