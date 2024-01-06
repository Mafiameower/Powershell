function Update-Users-Invoke-WithCSV() {
<#
CSV Format:
can be made, but must contain headers using parameter to value naming convention.

Example one:
mail, parameter, value
jsmith@company.com,jobTitle,Service Desk Analyst

Example two:
mail, parameter, value, parameter2, value2, parameter3, value3
jsmith@company.com,jobTitle,Service Desk Analyst,department,Technology,employeeId,1
#>
    param(
        [string]$csvFile, [string]$outFile, [int]$parameterCount
    )
    #Import CSV
    $csv = Import-Csv $csvFile

    if ($parameterCount = 1) {
        foreach ($user in $csv) {
            $mail = $user.Mail
            $paramater = $user.parameter
            $value = $user.Value
            Update-MgUser-Invoke -mail $mail -parameter $paramater -newValue $value
            Write-Host "$mail has had the parameter $paramater updated to $value" >>  $outFile
        }
    }
    if ($parameterCount = 2) {
        foreach ($user in $csv) {
            $mail = $user.Mail
            $paramater = $user.parameter
            $value = $user.Value
            $parameter2 = $user.parameter2
            $value2 = $user.Value2
            Update-MgUser-Invoke -mail $mail -parameter $paramater -newValue $value `
            -Parameter2 $parameter2 -newValue2 $value2
            Write-Host "$mail has had the parameter $paramater updated to $value" >>  $outFile
            Write-Host "$mail has had the parameter $paramater2 updated to $value2" >>  $outFile
        }
    }
    if ($parameterCount = 3) {
        foreach ($user in $csv) {
            $mail = $user.Mail
            $paramater = $user.parameter
            $value = $user.Value
            $parameter2 = $user.parameter2
            $value2 = $user.Value2
            $parameter3 = $user.parameter3
            $value3 = $user.Value3
            Update-MgUser-Invoke -mail $mail -parameter $paramater -newValue $value `
            -Parameter2 $parameter2 -newValue2 $value2 `
            -Parameter3 $parameter3 -newValue3 $value3
            Write-Host "$mail has had the parameter $paramater updated to $value" >>  $outFile
            Write-Host "$mail has had the parameter $paramater2 updated to $value2" >>  $outFile 
            Write-Host "$mail has had the parameter $paramater3 updated to $value3" >>  $outFile 
        }
    }
    if ($parameterCount = 4) {
        foreach ($user in $csv) {
            $mail = $user.Mail
            $paramater = $user.parameter
            $value = $user.Value
            $parameter2 = $user.parameter2
            $value2 = $user.Value2
            $parameter3 = $user.parameter3
            $value3 = $user.Value3
            $parameter4 = $user.parameter4
            $value4 = $user.Value4
            Update-MgUser-Invoke -mail $mail -parameter $paramater -newValue $value `
            -Parameter2 $parameter2 -newValue2 $value2 `
            -Parameter3 $parameter3 -newValue3 $value3 `
            -Parameter4 $parameter4 -newValue4 $value4

            Write-Host "$mail has had the parameter $paramater updated to $value" >>  $outFile
            Write-Host "$mail has had the parameter $paramater2 updated to $value2" >>  $outFile 
            Write-Host "$mail has had the parameter $paramater3 updated to $value3" >>  $outFile 
            Write-Host "$mail has had the parameter $paramater4 updated to $value4" >>  $outFile 
        }
    }

}