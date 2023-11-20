 powershell Set-ExecutionPolicy -ExecutionPolicy Unrestricted
 if not exist c:\ProgramData\TacticalRMM\temp md c:\ProgramData\TacticalRMM\temp
 powershell Invoke-WebRequest "https://raw.githubusercontent.com/tpozzi/my.scripts/master/powershell/RMM_Deploy.ps1" -Outfile c:\ProgramData\TacticalRMM\temp\RMM_Deploy.ps1 -ErrorAction SilentlyContinue
 powershell -Command "& {c:\ProgramData\TacticalRMM\temp\RMM_Deploy.ps1 -rmmuri 'https://api.msp.madeinformatica.com.br/clients/724ed690-604b-4c5c-9f3f-9e209e585bb2/deploy/' }"
