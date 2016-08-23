Function Convert-ToNixText($TextFile) {
    # get the contents and replace line breaks by U+000A
    $contents = [IO.File]::ReadAllText($TextFile) -replace "`r`n?", "`n"
    # create UTF-8 encoding without signature
    $UTF8 = New-Object System.Text.UTF8Encoding $false
    # write the text back
    [IO.File]::WriteAllText($TextFile, $Contents, $UTF8)
}