Function Get-mgUserInfo() {
    param([string]$username, [switch]$noCLS, [switch]$includeAll, [string]$includeAllManager)
<#
    The purpose of this function is to get user information using Graph. This will also provide manager information.
    Insert users username with no domain to search.
#>
#Get all properties from user. Sort by 'Email like'
    $user = Get-MgUser -All -property * | Where-Object { $_.Mail -like "*$username*" } 
#Pull some info. Only details left is manager.
    $UserInfo = $user | select-object DisplayName, Mail, JobTitle, Department, Id
#Manager Block:
#Get Manager Id
    $userManagerID = Get-MgUserManager -UserId $user.id | select-object -expandproperty Id
#Get Manager info
    $userManager = get-mguser -UserId $userManagerID | select-object Displayname, Mail, JobTitle, Department, Id
####################
## Output Section ##
####################
    if ($noCLS) {#This should be empty.
    }
    else {Clear-Host}

    if ($includeAll) {
        "User Info"
        $User | select-object *
        "Manager Info:"
        $userManager }
    else {
    ''
    "User info:" 
    $userinfo 
    "Manager Info:"
    $userManager 
    ""}
}

#Update manager using Update-MgManager -Username john.Smith -NewManager Patty.Jones
function Update-MgManager() {
#require $Username and $NewManager as input.
param(
    [Parameter(Mandatory)]
    [string[]]$Username, [string[]]$NewManager    
    )
#Setting variables    
$user = Get-MgUser -All -property * | Where-Object { $_.Mail -like "*$username*" } 
$userManagerID = Get-MgUser -All -property * | Where-Object { $_.Mail -like "*$NewManager*" } | Select-Object -ExpandProperty Id
$UserManagerDisplayName = Get-MgUser -All -property * | Where-Object { $_.Mail -like "*$NewManager*" } | Select-Object -ExpandProperty DisplayName
#set manager for command
$NewManagerBodyParameter = @{
    "@odata.id"="https://graph.microsoft.com/v1.0/users/$userManagerID"
    }
#Command to set manager
Set-MgUserManagerByRef -UserId $user.id -BodyParameter $NewManagerBodyParameter
#Output results
Write-Host  $user.DisplayName`'s manager was updated to $UserManagerDisplayName
}

Function Get-Email-User-List($GroupName) {
    #Use to get list of users from a group using Get-MgGroup commands.
    #Must use full groupname at this time to get proper results. It will work as long as there are 
    #no other groups with similar names, but in larger environments, its best to just use full name.
    #Can be ran like Get-Email-User-List SalesandMarketing
    #Search for group using prompt, assigns ID to variable
    $GroupID = Get-MgGroup -filter "startsWith(Mail, '$GroupName')" | Select-Object -ExpandProperty Id
    #Use $GroupID Variable to get list of members, places member ID into variable.
    $members = Get-MgGroupMember -GroupId $GroupID -all | select-object -expandproperty Id
    #List each member information. 
    $GroupDisplayName = Get-MgGroup -groupid $GroupID -property displayName | Select-Object -ExpandProperty DisplayName
    write-host "Members of " $GroupDisplayName 
    $memberlist = @()
    foreach ($Id in $members) {
        $memberlist += get-mguser -UserId $Id -Property * | Select-Object DisplayName, Mail, JobTitle, Department

    }
    $memberlist
}