$Certs = Get-ChildItem cert:\CurrentUser\My\
If ($Certs) {
	$Certs | ForEach {
        "Removing $($_.Subject)"
   		$Store = Get-Item $_.PSParentPath
    	$Store.Open('ReadWrite')
    	$Store.Remove($_)
    	$Store.Close()
	}
}
