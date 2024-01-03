
$csv = Import-Csv "C:\temp\UserUpdateInvokeTest.csv"

foreach ($user in $csv){

$mail = $user.Mail
$paramater = $user.Parameter
$value = $user.Value

Update-MgUser-Invoke -mail $mail -parameter $paramater -newValue $value

Write-Host "$mail has had the parameter $paramater updated to $value"
}