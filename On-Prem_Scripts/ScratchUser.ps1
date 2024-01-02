#############################
#                           #
#   Author: Quinten Doty    #
#      7/26/2023            #
#      Version 1.00         #
#                           #
#############################
#Will have to update line below to contain company domain in two places. Marked with #+= lines.
<#This script will make a new user, mirror the person that you tell it to, enable user and set EmployeeID.
Items this script will mirror:
OU Distinguished path
Groups
Title
Office
Description
Department
Company
Manager
This does not loop and you have to launch for each new hire.
#>

#gather variables
$firstName = Read-Host "First name?: "
$lastName = Read-Host "Last name?: "
$name = ($firstName + " " + $lastName)
$UserID = Read-Host "What is UserID? Do not include domain."
$password = Read-Host "What is the new users password?: " -AsSecureString
$eeid = Read-Host "What is users EmployeeID? (Dont forget the E or CW): "
$mirror = Read-host "Username without domain of person to be mirrored: "

$newUser = $UserID

########################################################
$mirrorName = Get-ADUser $mirror -properties name | Select-Object -ExpandProperty name
$mirrorOU = Get-ADUser $mirror -properties * | Select-Object -ExpandProperty distinguishedname
$path = $mirrorOU.trimStart('CN=' + $mirrorName + ',')
########################################################


<#FOR REVIEW
if ($UserID.Length -ge 21)
{
$sam = $userid.Length # This will be a number.
$samCut = $sam-20 #This is to gather how many characters to cut off the end of Sam account Name.
$samID = $userid.Substring(0, $userid.length -$samcut)
}
#>
#Will have to update below line to contain company domain in two places.
#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=
New-ADUser -GivenName $firstName -Surname $lastName -SamAccountName $UserID -EmailAddress "$userID@COMPANY.com" -AccountPassword $password -EmployeeID $eeid -name $name -DisplayName $name -UserPrincipalName:"$userid@COMPANY.com"
#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=#+=
Write-Output "Waiting 5 seconds before enabling account"
Start-Sleep -Seconds 5
Enable-ADAccount $UserID

$newUserPath = Get-ADUser $UserID -properties * | Select-Object -ExpandProperty distinguishedname

Move-ADObject -Identity $newUserPath -TargetPath $path


Write-Output "waiting 10 seconds before continuing"
Start-Sleep -Seconds 10

#Gather and set groups
get-aduser -Identity $mirror -Properties memberof | select-object -ExpandProperty memberof | add-adgroupmember -members $newUser
Write-Output "Groups set"

#Set EmployeeID
Set-ADUser -Identity $newuser -EmployeeID $eeid
Write-Output "Set EmployeeID"

#Gather and set title
$title = get-aduser $mirror -properties title | select-object -ExpandProperty title
set-aduser -Identity $newUser -Title $title
Write-Output "Set Title"

#Gather and set office
$office = get-aduser $mirror -properties Office | select-object -ExpandProperty Office
set-aduser -Identity $newUser -Office $office
Write-Output "Set Office"

#Gather and set description
$description = get-aduser $mirror -properties description | select-object -ExpandProperty description
set-aduser -Identity $newuser -Description $description
Write-Output "Set Description"

#Gather and set department
$department = get-aduser $mirror -properties department | select-object -ExpandProperty department
set-aduser -Identity $newuser -department $department
Write-Output "Set Department"

#Gather and set Company
$company = get-aduser $mirror -properties company | select-object -ExpandProperty company
set-aduser -Identity $newuser -company $company
Write-Output "Set Company"

#Gather and set Manager
$manager = get-aduser $mirror -properties manager | select-object -ExpandProperty manager
set-aduser -Identity $newuser -manager $manager
Write-Output "Set Manager"