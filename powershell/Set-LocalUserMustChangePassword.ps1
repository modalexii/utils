$UserWMI = Get-WmiObject -Class Win32_UserAccount -Filter "name='SomeLocalUserName'"
$UserWMI.PasswordExpires = $True
$UserWMI.Put()
$NTU.PasswordExpired = 1
$NTU.SetInfo()
