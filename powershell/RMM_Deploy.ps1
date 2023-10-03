param ($rmmuri)

if (Test-Path "C:\Program Files\TacticalAgent\novormm.txt" -PathType Leaf) {
	Write-Warning "Maquina já tem o RMM instalado na Ultima Versão!"
} else {
	if (Test-Path "C:\Program Files\TacticalAgent" -PathType Container) {
		Write-Warning "Removendo Instalação Anterior do RMM"
		$unis = Start-Process "C:\Program Files\TacticalAgent\unins000.exe" -ArgumentList '/VERYSILENT' -PassThru
		Wait-Process -InputObject $unis
		if ($unis.ExitCode -ne 0) {
			Write-Warning "$_ Falha na desinstalação do RMM com o codigo: $($proc.ExitCode)"
			exit $unis.ExitCode
		}
		Write-Warning "Iniciando o Download do RMM"
		Invoke-WebRequest $rmmuri -OutFile ( New-Item -Path "c:\ProgramData\TacticalRMM\temp\trmminstall.exe" -Force )
		Write-Warning "Iniciando o Deployment do RMM"
		$proc = Start-Process c:\ProgramData\TacticalRMM\temp\trmminstall.exe -ArgumentList '-silent' -PassThru
		Wait-Process -InputObject $proc
		if ($proc.ExitCode -ne 0) {
			Write-Warning "$_ Falha na instalação com o codigo: $($proc.ExitCode)"
		}
		Remove-Item -Path "c:\ProgramData\TacticalRMM\temp\trmminstall.exe" -Force
  		New-Item "C:\Program Files\TacticalAgent\novormm.txt"
	} else {
		Write-Warning "Iniciando o Download do RMM"
		Invoke-WebRequest $rmmuri -OutFile ( New-Item -Path "c:\ProgramData\TacticalRMM\temp\trmminstall.exe" -Force )
		Write-Warning "Iniciando o Deployment do RMM"
		$proc = Start-Process c:\ProgramData\TacticalRMM\temp\trmminstall.exe -ArgumentList '-silent' -PassThru
		Wait-Process -InputObject $proc

		if ($proc.ExitCode -ne 0) {
			Write-Warning "$_ Falha na instalação com o codigo: $($proc.ExitCode)"
		}
		Remove-Item -Path "c:\ProgramData\TacticalRMM\temp\trmminstall.exe" -Force
  		New-Item "C:\Program Files\TacticalAgent\novormm.txt"
	}
}
