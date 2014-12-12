@echo off

:: Execute the PS1 file with the same name as this batch file.

echo.
set filename=%~d0%~p0%~n0.ps1
 
if exist "%filename%" (
    PowerShell.exe -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Unrestricted -Command "& '%filename%'"
) else (
    echo Could not find %filename%. Confirm that the .ps1 has the same name as this .bat
    echo %filename%
)
