# Powershell
Workshop space for powershell.

## How to use

The ultimate plan will be to create modules.
To utilize the functionality, you can execute the .ps1 file using a PowerShell window. Follow the steps below:

1. Start by downloading the .ps1 file.
1. Open a PowerShell window and navigate to the directory where the file is located (e.g., cd C:\temp).
1. Execute the file using the following command :

    .\Invoke_mg_user.ps1

Once executed, you will be able to utilize the functions within the .ps1 file. However, please note that you will need to repeat these steps every time you open a new PowerShell window.

If there are specific functions that you frequently use, we recommend copying those functions into your $profile location. This will allow you to easily access them without needing to repeat the aforementioned steps.


**The first module has been created. I will provide detailed instructions on how to get this set up on your system ASAP.**


## Current functions created

### Get-QMgUser
Use Graph(Invoke-MgGraphRequest) to GET user information including: Name, Email, Department, Job title, manager and Id(Graph)

**Sample Input using -Mail:**
````powershell
Get-QMgUser -mail John.Smith@Company.com
````
*Must contain entire Email for this to work correctly.*

**Sample Output:**

    User Info

    displayName : John Smith
    mail        : John.Smith@Company.com
    jobTitle    : IT
    department  : Technology
    id          : xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    employeeId  : 1

    Manager Info

    displayName : Mark Johnson
    mail        : Mark.Johnson@Company.com
    id          : xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    employeeID  : 2

**Sample input using -Find:**

````powershell
Get-QMgUser -Find John
````
*Uses 'startsWith' filter parameter to locate users using displayname. Must begin with first name, as displayName cannot be filtered using 'contains' parameter*

**Sample output:**

    displayName      mail                                    id
    -----------      ----                                    --
    John Smith       John.Smith@Company.com                  xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    John Doe         john.doe@Company.com                    xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    John Johnson     john.Johnson@Company.com               xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

***Ideas and improvements:***

*Add different search parameters instead of only Mail*~~
    ~~*Display name -like*~~ *Added -find parameter*

*Fix -CustomParameters for result returns -- See issues*

### Update-MgManager
Use graph(Update-MgUserManager) to update manager by simply entering username and manager username.

### Get-Email-User-List
Use Graph to get list of users in an Email. Working to ensure this encompasses all Email type options.


### Get-User-Info 
Use Graph(Get-MgUser) to pull user information including: Name, Email, Department, Job title, manager and Id(Graph)

**Sample input:**
````powershell
Get-User-Info -Username John.Smith
````
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


***Ideas and improvements:***


~~*Add switch -includeAll to get all information from user, not just what is provided above.*~~ **DONE!**

*add -includeManager switch for more information on manager.* 
    Maybe can use -No manager instead.


# Further projects:

### New-MgUserCreation

Help assist in user creation, might not be needed. Have not investigated yet.(12/31(30))

<br>
<br>

#### ~~Find User script using MG Graph. Use to find a list of users with same name so you can get the correct users info.~~

-See -find under Get-QMgUser.


#### **Light to-do's:**

*WARNING: Some imported command names contain one or more of the following restricted characters: # , ( ) {{ }} [ ] & - / \ $ ^ ; : " ' < > | ? @ ` * % + = ~*
*create commands to correct this*

*Write an import script that will copy module to all module folders.*

*Add details about all functions in readme.md*

````powershell
$env:psmodulepath -split ';'
````

~~*Create a csv based user update script using invoke-mgGraph and PATCH API calls.*~~
- ~~Finished, would like to fully flesh this out to allow more than one parameter to be updated at a time. Should be an easy update.~~ **DONE!**
- ~~Need to add parameter for CSV file location~~ **DONE!**
- ~~Need to add logging file and log file parameter.~~ **DONE!**

*Update UpdateUserTitleManagerfromCSV V2.ps1 - Have this contain parameter for Company name. Add as Variable.*

*Same for scratch user and Email domain.*




Ignore:

    Added 12-29.ps1. Will likely remove soon.
    Added Password_Generator.ps1
    Added Invoke_mg_User.ps1
    This utilizes Invoke-MgRequest instead of using get-mguser/update-mgUser. Add more info later.