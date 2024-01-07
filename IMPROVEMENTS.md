### Get-QMgUser

***Ideas and improvements:***

*Add different search parameters instead of only Mail*~~
    ~~*Display name -like*~~ *Added -find parameter*

*Fix -CustomParameters for result returns -- See issues*


### Update-MgManager


### Get-User-Info 

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