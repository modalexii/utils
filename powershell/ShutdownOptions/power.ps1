# Display a window witgh Shutdown, Restart, LogOff and Cancel options

Add-Type -AssemblyName presentationframework

$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

#Build the GUI
[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window" Title="Select Shutdown Action" WindowStartupLocation = "CenterScreen"
    Width = "545" Height = "212" ShowInTaskbar = "False">
        <Canvas x:Name="Canvas">
        
            <Label x:Name = "HeadingLabel" Height = "23" Width = "546" Content = 'Select a Shutdown Action' Background = 'Orange' Canvas.Left = '0' Canvas.Top = '8'/> 
            
            <Button x:Name = "Shutdown" Height = "128" Width = "128" ToolTip = "Shutdown" Canvas.Left = '5' Canvas.Top = '38'>
                <Image Source = "$ScriptPath\shutdown.png" Stretch = "Fill"/>
            </Button>
            <Label x:Name = "ShutdownLabel" Height = "30" Width = "128" Content = 'Shutdown' Canvas.Left = '5' Canvas.Top = '166'/> 
                                          
            <Button x:Name = "Restart" Height = "128" Width = "128" ToolTip = "Restart" Canvas.Left = '135' Canvas.Top = '38'>
                <Image Source = "$ScriptPath\restart.png" Stretch = "Fill"/>
            </Button>
            <Label x:Name = "RestartLabel" Height = "30" Width = "128" Content = 'Restart' Canvas.Left = '135' Canvas.Top = '166'/> 
            
            <Button x:Name = "LogOff" Height = "128" Width = "128" ToolTip = "LogOff" Canvas.Left = '265' Canvas.Top = '38'>
                <Image Source = "$ScriptPath\logoff.png" Stretch = "Fill"/>
            </Button>
            <Label x:Name = "LogOffLabel" Height = "30" Width = "128" Content = 'LogOff' Canvas.Left = '265' Canvas.Top = '166'/> 
            
            <Button x:Name = "Cancel" Height = "128" Width = "128" ToolTip = "Cancel" Canvas.Left = '395' Canvas.Top = '38'>
                <Image Source = "$ScriptPath\cancel.png" Stretch = "Fill"/>
            </Button>
            <Label x:Name = "CancelLabel" Height = "30" Width = "128" Content = 'Cancel' Canvas.Left = '395' Canvas.Top = '166'/> 
            
        </Canvas>
</Window>
"@
 
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Window=[Windows.Markup.XamlReader]::Load( $reader )

$Window.WindowStyle = "None"

# Connect to Control
$Shutdown = $Window.FindName("Shutdown")
$Restart = $Window.FindName("Restart")
$LogOff = $Window.FindName("LogOff")
$Cancel = $Window.FindName("Cancel")
$Canvas = $Window.FindName("Canvas")
$HeadingLabel = $Window.FindName("HeadingLabel")
$ShutdownLabel = $Window.FindName("ShutdownLabel")
$RestartLabel = $Window.FindName("RestartLabel")
$LogOffLabel = $Window.FindName("LogOffLabel")
$CancelLabel = $Window.FindName("CancelLabel")

#Button click events
$Shutdown.Add_Click({
    $Window.Close()
    shutdown -s -t 1
    exit
})
$Restart.Add_Click({
    $Window.Close()
    shutdown -r -t 1
    exit
})
$LogOff.Add_Click({
    $Window.Close()
    logoff
    exit
})
$Cancel.Add_Click({
    $Window.Close()
    exit
})

# Label Properties
$HeadingLabel.HorizontalContentAlignment = 'Center'
$HeadingLabel.VerticalContentAlignment = 'Center'
$ShutdownLabel.HorizontalContentAlignment = 'Center'
$RestartLabel.HorizontalContentAlignment = 'Center'
$LogOffLabel.HorizontalContentAlignment = 'Center'
$CancelLabel.HorizontalContentAlignment = 'Center'
 
$Window.ShowDialog() | Out-Null