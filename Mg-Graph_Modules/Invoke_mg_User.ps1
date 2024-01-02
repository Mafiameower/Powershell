function Get-MgUser-Invoke() {
    param([string]$mail, [string]$customParameter, [switch]$nocls, [switch]$less)
    #Get UserID for user
    $userID = invoke-mggraphrequest -method GET  -Uri "/v1.0/users?`$filter=mail eq '$mail'" | Select-Object -ExpandProperty value | Select-Object -ExpandProperty id
    #Set Manager Info
    $managerInfo = invoke-mggraphrequest -method GET  -Uri "/v1.0/users/{$userID}/manager?`$select=displayName,mail,id,employeeid" `
    | Select-Object displayName, mail, Id, employeeID `
    | format-list displayName, mail, Id, employeeID
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

function Update-MgUser-Invoke() {
    param(
        [Parameter(Mandatory)]
        [string]$mail, [string]$parameter, [string]$newValue
    )
    $body = @{"$parameter" = "$newValue" }
    Write-Host "Before Update"
    Write-Host ":::::::::::::::::::"
    Get-MgUser-Invoke $mail 
    $userID = invoke-mggraphrequest -method GET  -Uri "/v1.0/users?`$filter=mail eq '$mail'" | Select-Object -ExpandProperty value | Select-Object -ExpandProperty id
    Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body
    Write-Host "Updated information"
    Write-Host ":::::::::::::::::::"
    Get-MgUser-Invoke $mail
}

