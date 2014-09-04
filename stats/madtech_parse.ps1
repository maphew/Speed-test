# TheMadTechnician, http://stackoverflow.com/a/25653062/14420
$Record = ""
Get-Content Input_data_colons.txt |     Where{$_ -match "([^:]*):\s*?(\S.*)"}|Foreach{
    if($Matches[1] -eq "Source"){
        $Record
        $Record = [PSCustomObject]@{'Source'=$Matches[2].trim()}
    }else{
        $Record | Add-Member $Matches[1] $Matches[2].trim()
    }
}|?{![string]::IsNullOrEmpty($_)} | Export-Csv madtech_parse_output.csv -NoTypeInformation
$Record | Export-Csv madtech_parse_output.csv -NoTypeInformation -Append
