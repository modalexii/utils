$Shell = New-Object -ComObject Shell.Application
$Recycler = $Shell.NameSpace(0xa)
$Recycler.Items() | ForEach {
    Remove-Item "$($_.Path)" -Recurse -Force
}
