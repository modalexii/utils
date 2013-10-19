# Note that querying gwmi Win32_Product "reconfigures" all apps to match the MSI defalts
# This is a huge bummer, but if removing Out-of-Box software, doesn't matter

$UndesirableSoftware = @(
    # Product names exactly as returned by GWMI Win32_Product
    ,"Adobe Air"
    ,"Adobe Reader 9.1"
    ,"Acrobat.com"
    # more...
)

$ShortcutPaths = @(
    ,"C:\Users\Default\Desktop"
    ,"C:\Users\Public\Desktop"
    ,"C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
)

# Generate list of software, look for undesirable software in that list, remove as found
$InstalledSoftware = Get-WmiObject -Class Win32_Product
foreach ($Package in $InstalledSoftware) {
    $Name = $Package.Name
    if ($UndesirableSoftware -contains $Name) {
        "   [-] Uninstalling `"$Name`""
        $Package.Uninstall() | Out-Null
        # Try to clean up shortcuts, if they exist
        foreach ($Path in $ShortcutPaths) {
            Try {
                Remove-Item "$Path\$Name*" -Recurse -Force -ErrorAction Stop
            } Catch {
                # Item not found - this is what we wanted anyway, 
                # so remove the error from the error array
                $Error.RemoveRange(0,1) | Out-Null
            }
        }
    }
}
