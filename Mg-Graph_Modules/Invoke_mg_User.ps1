<#Requires Powsershell 7.0(?)+#>
function Connect-Now() {
    $token = Read-Host "Please provide Access Token" -AsSecureString
    Write-Host ...Connecting to Graph...
    Connect-MgGraph -AccessToken $token
    Get-MgContext

}

function Get-MgUser-Invoke() {
    param([string]$Mail, [string]$DisplayName, [string]$CustomParameter, [switch]$nocls, [switch]$less, [string]$find)
    #Get UserID for user
    if ($Mail) {
        #Use -mail to search for user using entire Email address.
        $user = invoke-mggraphrequest -method GET -Uri "/v1.0/users?`$filter=mail eq '$Mail'" 
        $userID = $user.value.id
    }
    if ($DisplayName) {
        #This search method uses StartsWith Displayname filter parameter. This will only work well if you have a user with a somewhat unique name.
        $user = invoke-mggraphrequest -method GET -Uri "/v1.0/users?`$filter=startsWith(displayName,'$displayName')" 
        $userID = $user.value.id
    }
    if ($find) {
        #This is the best method to use if you have a user with a very common name. Then you can get anothere more unique identifier to locate them.
        $userList = invoke-mggraphrequest -method GET -Uri "/v1.0/users?`$filter=startsWith(displayName,'$find')?`$select=displayName, mail, id"
        $userList = $userList.value | Select-Object displayName, mail, id
        return $userList
    }
    #Set Manager Info
    $managerID = invoke-mggraphrequest -method GET  -Uri "/v1.0/users/{$userID}/manager?`$select=id" | Select-Object -ExpandProperty Id
    $managerInfo = invoke-mggraphrequest -method GET  -Uri "/v1.0/users/{$managerID}?`$select=displayName,mail,jobTitle,department,id,employeeid" `
    | Select-Object displayName, mail, jobTitle, department, employeeid, Id | Format-List
    #select portion of Employee

    #Currently in beta mode. Can only use one parameter at this time.
    if ($customParameter) {
        $userInfo = invoke-mggraphrequest -method GET  -Uri "/v1.0/users/{$userID}?`$select=$customParameter"
        $userinfo | Select-Object
    }
    else {
        $userInfo = invoke-mggraphrequest -method GET  -Uri "/v1.0/users/{$userID}?`$select=displayName,employeeID,id,mail,department,jobTitle" `
        | select-object displayName, employeeID, id, mail, department, jobTitle  `
        | Format-List displayName, mail, jobTitle, department, id, employeeID 
    }
    ####################
    ## Output Section ##
    ####################
    if ($less) {
        Write-Output "User Info" $userInfo
    }
    else {
        Write-Output "User Info" $userInfo "Manager Info" $managerInfo

    }
}

function Update-QMgUser() {
    param(
        [Parameter(Mandatory, Position = 0)][string]$Mail,
        [Parameter(Mandatory, Position = 1)][string][string]$Parameter,
        [Parameter(Mandatory, Position = 2)][string][string]$newValue,
        [Parameter(Position = 3)][string]$Parameter2,
        [Parameter(Position = 4)][string]$newValue2,
        [Parameter(Position = 5)][string]$Parameter3,
        [Parameter(Position = 6)][string]$newValue3,
        [Parameter(Position = 7)][string]$Parameter4,
        [Parameter(Position = 8)][string]$newValue4
    )
    $body = @{"$Parameter" = "$newValue" }
    $body2 = @{"$Parameter2" = "$newValue2" }
    $body3 = @{"$Parameter3" = "$newValue3" }
    $body4 = @{"$Parameter4" = "$newValue4" }
    Write-Host "Before Update"
    Write-Host ":::::::::::::::::::"
    if ($parameter2) {
        Get-MgUser-Invoke $mail -less
        $userID = invoke-mggraphrequest -method GET  -Uri "/v1.0/users?`$filter=mail eq '$mail'" | Select-Object -ExpandProperty value | Select-Object -ExpandProperty id
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body2
        return Get-MgUser-Invoke $mail -less
    }
    if ($parameter3) {
        Get-MgUser-Invoke $mail -less
        $userID = invoke-mggraphrequest -method GET  -Uri "/v1.0/users?`$filter=mail eq '$mail'" | Select-Object -ExpandProperty value | Select-Object -ExpandProperty id
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body2
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body3
        return Get-MgUser-Invoke $mail -less
    }
    if ($parameter4) {
        Get-MgUser-Invoke $mail -less
        $userID = invoke-mggraphrequest -method GET  -Uri "/v1.0/users?`$filter=mail eq '$mail'" | Select-Object -ExpandProperty value | Select-Object -ExpandProperty id
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body2
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body3
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body4
        return Get-MgUser-Invoke $mail -less
    }

    Get-MgUser-Invoke $mail -less
    $userID = invoke-mggraphrequest -method GET  -Uri "/v1.0/users?`$filter=mail eq '$mail'" | Select-Object -ExpandProperty value | Select-Object -ExpandProperty id
    Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body
    Write-Host "Updated information"
    Write-Host ":::::::::::::::::::"
    return Get-MgUser-Invoke $mail -less
}


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
            Update-QMgUser -mail $mail -parameter $paramater -newValue $value
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
            Update-QMgUser -mail $mail -parameter $paramater -newValue $value `
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
            Update-QMgUser -mail $mail -parameter $paramater -newValue $value `
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
            Update-QMgUser -mail $mail -parameter $paramater -newValue $value `
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