# TheMadTechnician, http://stackoverflow.com/a/25653062/14420
$Record = ""
Get-Content Input_data.txt | Where{$_ -match "([^=]*)=\s*?(\S.*)"}|Foreach{
    if($Matches[1] -eq "Source"){
        $Record
        $Record = [PSCustomObject]@{'Source'=$Matches[2].trim()}
    }else{
        Add-Member -InputObject $Record -MemberType NoteProperty -Name $Matches[1] -Value $Matches[2].trim()
    }
}|?{![string]::IsNullOrEmpty($_)} | Export-Csv "%~n0_result.csv" -NoTypeInformation
$Record | Export-Csv "%~n0_result.csv" -NoTypeInformation -Append

