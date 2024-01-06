<#Requires Powsershell 7.0(?)+#>
<#
 .Synopsis
  Connects to Microsoft Graph using Connect-MgGraph -AccessToken.

 .Description
  This will ask you for your access token as a secured string and connect you to MG Graph with this token.

 .Parameter Token
  This will be the access token provided by Mg Graph. You can get one from Mg Graph Explorer.

 .Example
   # Once you call this command, it will prompt for an access Token. Once submitted, it will connect and
   # provide connection details.
   Connect-Now
#>
function Connect-Now() {
    $token = Read-Host "Please provide Access Token" -AsSecureString
    Write-Host ...Connecting to Graph...
    Connect-MgGraph -AccessToken $token
    Get-MgContext

}
Export-ModuleMember -Function Connect-Now

<#
 .Synopsis
  Gather user information using Invoke-MgGraphRequest

 .Description
  This will allow you to search for users and provide user information by using mulitple different search parameters. It will
  also provide information for the users manager.

 .Parameter Mail
  If you know the users entire Email address, the -Mail parameter will allow you to get user information by having just the email.

 .Parameter DisplayName
  If you have a user with a somewhat unique displayName, you can use the -DisplayName parameter to locate the user.

 .Parameter Find
  If you have a user with a non-unique display name, you can use -find to get a list of users with similar names

 .Parameter Less
  Using the -Less parameter will omit the manager information

 .Example
   # Once you call this command, it will prompt for an access Token. Once submitted, it will connect and
   # provide connection details.
   Get-QMgUser -Find John
#>
function Get-QMgUser() {
    param([string]$Mail, [string]$DisplayName, [string]$CustomParameter, [switch]$nocls, [switch]$less, [string]$Find)
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

Export-ModuleMember -Function Get-QMgUser

<#
 .Synopsis
  Connects to Microsoft Graph using Connect-MgGraph -AccessToken.

 .Description
  This will ask you for your access token as a secured string and connect you to MG Graph with this token.

 .Parameter Token
  This will be the access token provided by Mg Graph. You can get one from Mg Graph Explorer.

 .Example
   # Once you call this command, it will prompt for an access Token. Once submitted, it will connect and
   # provide connection details.
   Connect-Now
#>
function Connect-Now() {
    $token = Read-Host "Please provide Access Token" -AsSecureString
    Write-Host ...Connecting to Graph...
    Connect-MgGraph -AccessToken $token
    Get-MgContext

}
Export-ModuleMember -Function Connect-Now

<#
 .Synopsis
  Update user information using Invoke-MgGraphRequest

 .Description
  This will allow you to update user information with up to 4 parameters at one time.

 .Parameter Mail
  Users Email is what this keys updates off of. The users Email must be known to correctly use this function.

 .Parameter Parameter
  This indicates the first parameter that will be updated for the user. Ex. 'jobTitle'

 .Parameter NewValue
  This indicates the first value that will be updated for the user. Ex. 'Computer Engineer'

 .Parameter Parameter2
  This indicates the second parameter that will be updated for the user. Ex. 'department'

 .Parameter NewValue2
  This indicates the second value that will be updated for the user. Ex. 'Client Services'

 .Parameter Parameter3
  This indicates the third parameter that will be updated for the user. Ex. 'employeeId'

 .Parameter NewValue3
  This indicates the third value that will be updated for the user. Ex. '1234'

 .Parameter Parameter4
  This indicates the fourth parameter that will be updated for the user. Ex. ' Physical-Delivery-Office-Name'

 .Parameter NewValue4
  This indicates the fourth value that will be updated for the user. Ex. 'Corporate Office'

 .Example
   # Once you call this command, it will prompt for an access Token. Once submitted, it will connect and
   # provide connection details.
   Update-QMgUser -Mail John.Smith@Company.com -Parameter jobTitle -newValue 'Computer Engineer'
#>
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
        Get-QMgUser $mail -less
        $userID = invoke-mggraphrequest -method GET  -Uri "/v1.0/users?`$filter=mail eq '$mail'" | Select-Object -ExpandProperty value | Select-Object -ExpandProperty id
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body2
        return Get-QMgUser $mail -less
    }
    if ($parameter3) {
        Get-QMgUser $mail -less
        $userID = invoke-mggraphrequest -method GET  -Uri "/v1.0/users?`$filter=mail eq '$mail'" | Select-Object -ExpandProperty value | Select-Object -ExpandProperty id
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body2
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body3
        return Get-QMgUser $mail -less
    }
    if ($parameter4) {
        Get-QMgUser $mail -less
        $userID = invoke-mggraphrequest -method GET  -Uri "/v1.0/users?`$filter=mail eq '$mail'" | Select-Object -ExpandProperty value | Select-Object -ExpandProperty id
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body2
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body3
        Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body4
        return Get-QMgUser $mail -less
    }

    Get-QMgUser $mail -less
    $userID = invoke-mggraphrequest -method GET  -Uri "/v1.0/users?`$filter=mail eq '$mail'" | Select-Object -ExpandProperty value | Select-Object -ExpandProperty id
    Invoke-MgGraphRequest -Method PATCH -Uri "/v1.0/users/{$userID}" -Body $body
    Write-Host "Updated information"
    Write-Host ":::::::::::::::::::"
    return Get-QMgUser $mail -less
}
Export-ModuleMember -Function Update-QMgUser

<#
 .Synopsis
  Update multiple users using a csv. Interacts with users using Invoke-MgGraphRequest.

 .Description
  Update up to 4 parameters for multiple users within a csv at once. Here are two examples of csv formats:
  Example one:
  mail, parameter, value
  jsmith@company.com,jobTitle,Service Desk Analyst
    
  Example two:
  mail, parameter, value, parameter2, value2, parameter3, value3
  jsmith@company.com,jobTitle,Service Desk Analyst,department,Technology,employeeId,1

 .Parameter CsvFile
  This parameter should point to the csv file you want to use to update users information.
 .Parameter outFile
  This parameter is used to designate a log file for logging changes.

 .Parameter parameterCount
  This should indicate how many parameters you will be updating for each user. In a circumstance where some users are 
  updating parameters while other users are not, use the highest parameter count required.

 .Example
   # Here is an example of updating job titles for a department
   Update-QMgUserCSV -csvFile c:\temp\UserUpdate1_1_24.csv -OutFile c:\temp\UserUpdate1_1_24_Log.txt -parameterCount 1
#>
function Update-QMgUserCSV() {
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
Export-ModuleMember -Function Update-QMgUserCSV