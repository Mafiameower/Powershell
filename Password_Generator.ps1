#Does not include i, l or I.
#Does not include 0, O or o
function Get-Pass(){
$count = 0
while ($count -lt 18) {
$letter = "A","a","B","b","C","c","D","d","E","e","F","f","G","g","H","h","J","j","K","k","L","M","m","N","n","P","p","Q","q","R","r","S","s","T","t","U","u","V","v","W","w","X","x","Y","y","Z","z" | Get-Random
$symbol = "$", "!", "@", "*", "&", "#", "+", "-", ".","/","?","^","_","|" | get-random
$number = "1","2","3","4","5","6","7","8","9" | Get-Random
$newcharacter = $letter, $symbol, $number | get-random
$password = $password+$newcharacter
$count = $count+1
}
cls
$password
Set-Clipboard $password
$password = $null
}