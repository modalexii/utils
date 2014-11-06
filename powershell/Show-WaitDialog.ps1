<#

Displays a dialog
Meant to be started and killed by another script - will run forever

Example of launching and killing dialog from Powershell:

Function Show-WaitDialog() {
    # Display the waiting dialog forever
    # Return the Dialog's process object

    $SilentPSArgs = @(
        ,"-NoProfile"
        ,"-NonInteractive"
        ,"-NoLogo"
        ,"-ExecutionPolicy Unrestricted"
        ," -File `"$ScriptPath\Loader.ps1`""
    ) 
    $WaitDialog = (
        Start powershell.exe -ArgumentList $SilentPSArgs -PassThru -NoNewWindow
    )

    return $WaitDialog
}

$WaitDialog = Show-WaitDialog
# Do whatever...
Stop-Process $WaitDialog.Id

#>

$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

Add-Type -AssemblyName System.Windows.Forms 
$Form = New-Object system.Windows.Forms.Form
$Form.Text = "Hang in there baby!"
$Form.BackColor = "White"
$Form.MinimizeBox = $False
$Form.MaximizeBox = $False 
$Form.SizeGripStyle = "Hide"
$Form.ShowInTaskbar = $False
$Form.StartPosition = "CenterScreen"

$Icon = New-Object system.drawing.icon ("$ScriptPath\SOME-IMAGE.ico")
$Form.Icon = $Icon 

$Form.Width = 300
$Form.Height = 76

# Waiting Gif
$File = "$ScriptPath\loader.gif"
$PictureBox = New-Object Windows.Forms.PictureBox
$PictureBox.Width = 32
$PictureBox.Height = 32
$PictureBox.Location = New-Object System.Drawing.Size(0,3)
$PictureBox.Image = [System.Drawing.Image]::Fromfile($File)
$Form.Controls.Add($PictureBox)

# Text
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "
            Please stand by while we do some things...
"
$Label.AutoSize = $True
$Form.Controls.Add($Label)

$Form.Add_Shown({$Form.Activate()})
$Form.ShowDialog()
