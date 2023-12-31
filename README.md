# Powershell_Modules
Workshop space for powershell modules


# Current Module goals:

### Get-User-Info 
Use Graph to pull user information including: Name, Email, Department, Job title, manager and Id(Graph)

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

*Add switch -includeAll to get all information from user, not just what is provided above.*

*add -includeManager switch for more information on manager.*


### Update-MgManager
Use graph to update manager by simply entering username and manager username.


### Get-Email-User-List
Use Graph to get list of users in an Email. Working to ensure this encompasses all Email type options.
