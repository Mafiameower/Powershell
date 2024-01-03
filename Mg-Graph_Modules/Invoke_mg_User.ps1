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
        $user = invoke-mggraphrequest -method GET -Uri "/v1.0/users?`$filter=mail eq '$Mail'" 
        $userID = $user.value.id
    }
    if ($DisplayName) {
        $user = invoke-mggraphrequest -method GET -Uri "/v1.0/users?`$filter=startsWith(displayName,'$displayName')" 
        $userID = $user.value.id
    }
    if ($find) {
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

