# Powershell_Modules
Workshop space for powershell modules


# Current Module goals:

### Get-User-Info 
Use Graph to pull user information including: Name, Email, Department, Job title, manager and Id(Graph)

**Sample input:**

`Get-User-Info -Username 'John.Smith'`

**Sample Output::**

    DisplayName: John Smith
    Mail: John.Smith@Company.com
    Job Title: Manager
    Id: xxxxx-xxxxx-xxxxx-xxxxx
   
    Manager Information:

    Manager: Frank Johnson
    Id: xxxxx-xxxxx-xxxxx-xxxxx

### Update-MgManager
Use graph to update manager by simply entering username and manager username.



### Get-Email-User-List
Use Graph to get list of users in an Email. Working to ensure this encompasses all Email type options.