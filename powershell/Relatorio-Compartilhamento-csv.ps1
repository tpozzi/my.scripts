function Get-SharedPermissions{
	$Share=Get-SmbShare | Where-Object {$_.Path -ne ''} | Select-Object Name,Path,Description |Where-Object {$_.Name -notlike "*$"}
	$ShareInfo = @{} 
	foreach ($i in $Share){
		$ShareAccess=Get-SmbShareAccess $i.Name | Select-Object AccountName,AccessRight | Where-Object {$_.AccountName -notlike "*Administradores" -and $_.AccountName -notlike "*SISTEMA" -and $_.AccountName -notlike "*Administrators" -and $_.AccountName -notlike "*SYSTEM"}
		$c=0
		foreach ($i2 in $ShareAccess){
			$ShareInfo.Add(($i.Name+$c),(@{"Name" = ($i.Name)
				"Path" = ($i.Path)
				"Description" = ($i.Description)
				"AccountName" = ($i2.AccountName)
				"AccessRight" = ($i2.AccessRight)
				}))
				$c++
		 }    
				
	}
	$itmp=""
	Write-Output ("Nome`tCaminho`tUsuário`tPermissão`tDescrição")
	foreach ($i in $($ShareInfo.Keys | Sort-Object)){
		foreach ($i2 in $Share.Name){
			if ($ShareInfo.$i.Name -eq $i2){
				if ($ShareInfo.$i.Name -eq "$itmp"){
					Write-Output ("`t"+"`t"+$ShareInfo.$i.AccountName+"`t"+$ShareInfo.$i.AccessRight+"`t")
					$itmp=$ShareInfo.$i.Name
				}else{
					Write-Output ($ShareInfo.$i.Name+"`t"+$ShareInfo.$i.Path+"`t"+$ShareInfo.$i.AccountName+"`t"+$ShareInfo.$i.AccessRight+"`t"+$ShareInfo.$i.Description)
					$itmp=$ShareInfo.$i.Name
				}
			}
		}
	}	
}

function Get-SecurityPermissions($PathDirectory){
	Write-Output ("Pasta/Subpasta`tUsuário`tPermissão")
	$RootAccess=Get-Acl -Path $PathDirectory | Select-Object PSPath,Access -ExpandProperty Access | Select-Object PSPath,IdentityReference,FileSystemRights | Where-Object {$_.FileSystemRights -notlike "-*" -and $_.FileSystemRights -notlike "2*" -and $_.IdentityReference -notlike "*Administradores" -and $_.IdentityReference -notlike "*SISTEMA" -and $_.IdentityReference -notlike "*Administrators" -and $_.IdentityReference -notlike "*SYSTEM"}
	foreach ($i in $RootAccess){
		if ($i.PSPath -eq "$itmp"){
			Write-Output ("`t"+$i.IdentityReference+"`t"+$i.FileSystemRights)
			$itmp=$i.PSPath
		}else{
			Write-Output ($($i.PSPath -split "::" | Where-Object {$_ -like "[a-z]:*"})+"`t"+$i.IdentityReference+"`t"+$i.FileSystemRights)
			$itmp=$i.PSPath
		}
	}
	$Access=Get-ChildItem -Directory $PathDirectory -recurse | Get-Acl | Select-Object PSPath,Access -ExpandProperty Access | Select-Object PSPath,IdentityReference,FileSystemRights  | Where-Object {$_.FileSystemRights -notlike "-*" -and $_.FileSystemRights -notlike "2*" -and $_.IdentityReference -notlike "*Administradores" -and $_.IdentityReference -notlike "*SISTEMA" -and $_.IdentityReference -notlike "*Administrators" -and $_.IdentityReference -notlike "*SYSTEM"}
	foreach ($i in $Access){
		if ($i.PSPath -eq "$itmp"){
			Write-Output ("`t"+$i.IdentityReference+"`t"+$i.FileSystemRights)
			$itmp=$i.PSPath
		}else{
			Write-Output ($($i.PSPath -split "::" | Where-Object {$_ -like "[a-z]:*"})+"`t"+$i.IdentityReference+"`t"+$i.FileSystemRights)
			$itmp=$i.PSPath
		}
	}
}
$TARGETDIR = 'C:\Multiconecta\Relatorios'
if(!(Test-Path -Path $TARGETDIR )){
    New-Item -ItemType directory -Path $TARGETDIR
}

Get-SharedPermissions | Out-File -FilePath C:\Multiconecta\Relatorios\Pastas_Compartilhadas.csv -Force

$ShareDir=Get-SmbShare | Where-Object {$_.Path -ne ''} | Select-Object Name,Path | Where-Object {$_.Name -notlike "*$" -and $_.Path -like "[a-z]:*"}
foreach ($SharedPath in $ShareDir){
	$filename = ("C:\Multiconecta\Relatorios\"+$SharedPath.Name+".csv")
	Get-SecurityPermissions -PathDirectory $SharedPath.Path | Out-File -FilePath $filename -Force
}
