# Powershell_Modules
Workshop space for powershell modules

# Current functions created

### Get-User-Info 
Use Graph(Get-MgUser) to pull user information including: Name, Email, Department, Job title, manager and Id(Graph)

**Sample input:**

    Get-User-Info -Username 'John.Smith'

**Sample Output::**

    DisplayName : John Smith
    Mail        : John.Smith@Company.com
    JobTitle    : Computer Technician
    Department  : IT
    Id          : xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

    Manager Info:
    DisplayName : Mark Johnson 
    Mail        : Mark.Johnson@Company.com
    JobTitle    : Manager
    Department  : IT
    Id          : xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx


** *Ideas and improvements:* **


~~*Add switch -includeAll to get all information from user, not just what is provided above.*~~ **DONE!**

*add -includeManager switch for more information on manager.* 
    Maybe can use -No manager instead.

### Update-MgManager
Use graph(Update-MgUserManager) to update manager by simply entering username and manager username.

### Get-Email-User-List
Use Graph to get list of users in an Email. Working to ensure this encompasses all Email type options.

# Current Modules to create:

### New-MgUserCreation
help assist in user creation, might not be needed. Have not investigated yet.(12/31(30))


## Added Invoke_mg_User.ps1
###  This utilizes Invoke-MgRequest instead of using get-mguser/update-mgUser. Add more info later.


##  Added 12-29.ps1. Will likely remove soon.



# Further projects:
*Create a csv based user update script using invoke-mgGraph and PATCH API calls.*
