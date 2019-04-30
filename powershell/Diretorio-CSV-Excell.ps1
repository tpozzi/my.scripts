function ConvertTo-MultiArray
{
    param (
        $InputObject,
        [switch]$Headers = $true
    )
    begin
    {
        $Objects = @()
        [ref]$Array = [ref]$null
    }
    process
    {
        $Objects += $InputObject
    }
    end
    {
        $Properties = $Objects[0].PSObject.Properties | ForEach-Object{ $_.Name }
        $Array.Value = New-Object 'object[,]' ($Objects.Count + 1), $Properties.Count
        $ColumnNumber = 0
        if ($Headers)
        {
            $Properties | ForEach-Object{
				if ($_ -eq $Null) {
					$Array.Value[0, $ColumnNumber] = " "
				}else{
				$Array.Value[0, $ColumnNumber] = $_.ToString()
				}
            $ColumnNumber++
            }
            $RowNumber = 1
        }
        else
        {
            $RowNumber = 0
        }
        $Objects | ForEach-Object{
            $Item = $_
            $ColumnNumber = 0
            $Properties | ForEach-Object{
                if ($Item.($_) -eq $null)
                {
                    $Array.Value[$RowNumber, $ColumnNumber] = ""
                }
                else
                {
                    $Array.Value[$RowNumber, $ColumnNumber] = $Item.($_).ToString()
                }
                $ColumnNumber++
            }
            $RowNumber++
        }
        $Array
    }
}

Function Create-ExcelDocument {
#Param(
#    $CSVPath = ".\Reports", ## Soruce CSV Folder
#    $XLOutput= "X:\Study Materials\SCRIPTS\Get-Report\Get-Report\final_report.xlsx" ## Output file name
#)
$CSVPath="C:\Multiconecta\Relatorios"
$XLOutput="C:\Multiconecta\Relatorios\Relatorio_Compartilhamento.xlsx"
$csvFiles = Get-ChildItem ("$CSVPath\*") -Include *.csv | Sort-Object -Property @{Expression = {$_.CreationTime- $_.LastWriteTime}; Descending = $true}
$Excel = New-Object -ComObject excel.application
$Excel.visible = $True
$Excel.sheetsInNewWorkbook = $csvFiles.Count
$workbooks = $excel.Workbooks.Add()
$CSVSheet = 1
 
	Foreach ($CSV in $Csvfiles) {
		$worksheets = $workbooks.worksheets
		$CSVFullPath = $CSV.FullName
		$SheetName = ($CSV.name -split "\.")[0]
		$worksheet = $worksheets.Item($CSVSheet)
		$worksheet.Name = $SheetName
		$CsvContents = Import-Csv $CSVFullPath -Delimiter `t
		if ($CsvContents -eq $null){
			continue
		}else{
			$MultiArray = (ConvertTo-MultiArray -InputObject $CsvContents).Value
			$StartRowNum = 1
			$StartColumnNum = 1
			$EndRowNum = $CsvContents.Count + 1
			$EndColumnNum = ($CsvContents | Get-Member | Where-Object { $_.MemberType -eq 'NoteProperty' }).Count
			$Range = $worksheet.Range($worksheet.Cells($StartRowNum, $StartColumnNum), $worksheet.Cells($EndRowNum, $EndColumnNum))
			$Range.Value2 = $MultiArray
			$worksheet.UsedRange.EntireColumn.AutoFit()
			$worksheet.CellFormat.ShrinkToFit
			 
		}
		$CSVSheet++
 
    }
}
Create-ExcelDocument