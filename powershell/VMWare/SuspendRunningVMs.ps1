cmd /c "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe" list | ForEach {
	If (Test-Path -Path $_ -PathType Leaf) {
		Start-Process "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe" -ArgumentList "suspend `"$_`" soft" -NoNewWindow -PassThru -Wait
	}
}