#Declaracão de Variaveis.
$filetxt = "C:\AD-Log\AD-Log-britodm.txt"
$filezip = "C:\AD-Log\AD-Log-britodm.zip"
$emailfrom = "ti.relatorios@pimpolho.com.br"
$emailto = "ti.relatorios@pimpolho.com.br"
$smtpserver = "pimpolho-com-br.mail.protection.outlook.com"

#Função para pegar os ultimos 7 dia de log no Event Viewer relacionados aso erros 4776, 4723, 4724.
function Get-Relatorio{
	$logdate=$(get-date (Get-Date).AddDays(-7) -UFormat "%d/%m/%Y 00:00:00")
	$eventlog = Get-EventLog -LogName Security -After $logdate
	#$relatorio=$(Get-EventLog -LogName Security -After $logdate | Where-Object { $_.InstanceID -match 4776 -or $_.InstanceID -match 4723 -or $_.InstanceID -match 4724} | select InstanceId,Message,TimeGenerated)
	$relatorio=$($eventlog | ?{$_.EventID -eq 4723 -or $_.EventID -eq 4724 -or $_.EventID -eq 4776 } | Select @{Name="Event ID";Expression={$_.InstanceID}},@{Name="UserName";Expression={$_.ReplacementStrings[1]}},@{Name="Host";Expression={$_.ReplacementStrings[2]}},@{Name="Time";Expression={$_.TimeGenerated}} | Where-Object { $_.UserName -notmatch "BRI-*" -and $_.UserName -notmatch '^[0-9]+'} | Where {$_.UserName -ne ""})
	Write-Output "`tRelatório Login sem Sucesso e Alteração de senha (EventIDs 4723, 4724, 4776)"
	Write-Output ("")
	Write-Output "EventID 4723 - Tentativa de mudança de senha"
	Write-Output "EventID 4724 - Tentativa de reset de senha"
	Write-Output "EventID 4776 - Tentativa de validação de credenciais"
	Write-Output ("")
	$usern=""
	$datat=""
	$n=0
	foreach ($i in $relatorio) {	
		if (($usern -ne $i.UserName) -and ($datat -ne $i.Time)){
			$i
			$n++
		}
		$usern=$i.UserName
		$datat=$i.Time
	}
#	$relatorio | fl
	Write-Output ("")
	Write-Output ("Este Relatório tem $n Entradas")	
}

#Chamando a Função Get-Relatorio.
#Get-Relatorio | Out-File -FilePath $filetxt -Force -Append # Envia Output para o $filecsv.
Get-Relatorio | Out-File -FilePath $filetxt -Force # Envia Output para o $filecsv.

#Compacta Arquivo txt em zip.
#Compress-Archive -Path $filetxt -CompressionLevel Optimal -DestinationPath $filezip

#Envia Email com Relatório anexado.
#Send-MailMessage -To $emailto -from $emailfrom -Subject 'Relatorio Semanal do AD - BritoDM' -Body "Relatorio de tentativas de acesso e troca de senha do dominio britodm em anexo" -Attachments $filezip -smtpserver $smtpserver -Port 25
Send-MailMessage -To $emailto -from $emailfrom -Subject 'Relatorio Semanal do AD - BritoDM' -Body "Relatorio de tentativas de acesso e troca de senha do dominio britodm em anexo" -Attachments $filetxt -smtpserver $smtpserver -Port 25

#Deleta Arquivo compactado
#Remove-Item $filezip -Force
