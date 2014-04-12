Exactly like valinna shutdown options, but suspends running VMWare Workstation VMs as well.

To use:

1) Place this entire folder anywhere on the system, e.g., C:\Program Files\System32

2) Edit the shortcut in this directory (Right-click "Shutdown Options.lnk" and select "Properties")

3) Change the "Start In" field to the full path to this directory, e.g. "C:\Program Files\System32\ShutdownOptions"

4) Copy/Paste or Drag 'n' Drop the shortcut to the taskbar, start menu, or wherever you would like it to be



Advanced:

If creating your own short cut, be sure to run the power.ps1 file as follows:

Powershell.exe -Sta -WindowTtyle Hidden -ExecutionPolicy Unrestricted -File "power.ps1"

("-Sta" is critical)
