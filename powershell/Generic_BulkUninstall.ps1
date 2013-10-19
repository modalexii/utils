# The function below expects to be passed an array, from which it reads a
# human-meaningful program name to display to the user (and capture in the
# transcript), the binary used to uninstall, and the parameters to pass. 
# It then iterates through a multidimensional array of software to remove,
# calling Uninstall() on each element

Function Uninstall($AppArray) {
    $Name = $AppArray[0]
    $UninstallBin = $AppArray[1]
    $Args = $AppArray[2]
    "   [-] Uninstalling unneeded software `"$Name`""
    $proc = (Start-Process -FilePath "$UninstallBin" -ArgumentList "$Args" -NoNewWindow -Wait -PassThru)
    if ($proc.ExitCode -ne 0 -and $proc.ExitCode -ne 3010) {
        # Exit 3010 = required reboot was suppressed
        Write-Error "$Name uninstall failed!"
    }
}

$UndesirableSoftware = @(
    # [0] = Display Name of package, e.g. 'Microsoft Silverlight'
    # [1] = Path to executable (or bare command in %PATH%) that runs the uninstall, e.g. 'msiexec.exe'
    # [2] = Args/Params to pass to the executable specified in [2]
    ,@('Adobe Acrobat X', 'msiexec.exe', '/x {AC76BA86-1033-F400-BA7E-000000000005} /norestart /qn')
    ,@('Adobe ActiveX', "C:\Windows\System32\Macromed\Flash\flashutil<ver>_activex.exe", ' /uninstall')
    ,@('Cyberlink PowerDVD', 'C:\<snip>\setup.exe', '/z-uninstall /s')
    ,@('Roxio Creator LJ', 'msiexec.exe', '/x {FE51662F-D8F6-43B5-99D9-D4894AF00F83} /norestart /qn')
    ,@('Windows Live Suite', 'C:\Program Files\Windows Live\installer\wlarp.exe', ' /remove:all /q')
    ,@('Microsoft Silverlight', 'msiexec.exe', '/x {89F4137D-6C26-4A84-BDB8-2E5A4BB71E00} /norestart /qn')
)

foreach ($Package in $UndesirableSoftware) {
    Uninstall $Package
}
