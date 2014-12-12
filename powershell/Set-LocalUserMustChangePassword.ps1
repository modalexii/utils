$DOEHRSAdminUserWMI = Get-WmiObject -Class Win32_UserAccount -Filter "name='SomeLocalUserName'"
$DOEHRSAdminUserWMI.PasswordExpires = $True
$DOEHRSAdminUserWMI.Put()
$DOEHRSAdminNTU.PasswordExpired = 1
$DOEHRSAdminNTU.SetInfo()
