$ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem
$ComputerSystem.JoinDomainOrWorkgroup( "DOEHRSWG" )
