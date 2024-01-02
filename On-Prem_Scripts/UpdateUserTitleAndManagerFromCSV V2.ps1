###########################
# Created by Quinten Doty #
#         8/1/23          #
#      Version 1.00       #
###########################

<#

The purpose of this script is to update job title and manager on every employee provided in a CSV by keying off the ADUC unique identifier "EmployeeID".
For this to work correctly you will have to isolate the EmployeeID for both the User and the manager.

The columns must be named as follows:
Worker,EmployeeID,JobTitle,ManagerOfWorker,ManagerEmployeeID,
Case probably does not matter, but I would stick with using same case.

Create a new CSV file from data in XLSX file with correct columns.

Import CSV to VM and place into C:\Temp. You will have to update $workers variable to the correct path.

Here is an example of a correct CSV:

Worker,EmployeeID,JobTitle,ManagerOfWorker,ManagerEmployeeID,
John Smith,E1234,Intern,Aaron Jones,E15407,
#>

# Import the AD module
Import-Module activedirectory

function QUpdate-Ad-UserInfo() {
    param([Parameter(Mandatory=$true)]
        [string]$csvFile)
    param([Parameter(Mandatory=$true)]
        [string]$logFile)
    # Store the data from csv in the $Workers variable
    $Workers = Import-csv $csvFile

    # Loop through each row in the CSV Sheet 
    foreach ($User in $Workers) {
        # Read data from each field in the row and assign data to a variable.
        $Name = $User.Worker
        $eeid = $User.EmployeeID
        $JobTitle = $User.JobTitle
        $Manager = $User.ManagerOfWorker
        $ManagerEEID = $user.ManagerEmployeeID

        #Get username of employee by searching EmployeeID. Set as variable $UserSamName.
        $UserSamName = Get-ADUser -Filter { employeeid -eq $eeid } | Select-Object -ExpandProperty samaccountname
        #Get manager distinguished name by searching EmployeeID and set to variable.
        $managerDistName = Get-ADUser -Filter { employeeid -eq $ManagerEEID } | Select-Object -ExpandProperty distinguishedName
        #Set new information in ADUC for Worker.
        Set-ADUser -Identity $UserSamName -manager $managerDistName -Title $JobTitle -description $JobTitle -Country "US" -Company "Company Name"

        Write-Output "$Name manager was updated to $Manager. Job title was updated to $JobTitle"
        "$Name manager was updated to $Manager. Job title and Description was updated to $JobTitle" >> $logFile
        Start-Sleep -Milliseconds 500
    }
}