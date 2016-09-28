@echo off

:: Internactive script to start and then stop a persistent full packet capture
:: on windows 8+. Indended use is remote troubleshooting - messages are written 
:: for non-technical users.

set tracefile=C:%HOMEPATH%\Desktop\PacketCaptureForKyle.etl
set cabfile=%tracefile:.etl=.cab%

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Please run this script by right-clicking it and choosing
    echo "Run as administrator". If a "User Account Control" popup appears
    echo after you do this, please then click "Yes".
    echo.
    echo Exiting
    pause
    exit 1
)

netsh trace show status | findstr Running >nul 2>&1
if %errorlevel% neq 0 goto start_pcap
goto stop_pcap

:start_pcap
echo Consent to network traffic recording:
echo.
echo While only very small specific bits of network traffic will be viewed for
echo troubleshooting, all website names, site content, file transfers, and so on
echo will be recorded. If you do not consent, close this window now, otherwise
pause
echo Starting packet capture (this may take a few seconds)...
netsh trace start capture=yes report=yes filemode=append traceFile=%tracefile% >nul
echo.
echo OK!
echo Use your computer as your normally would. After the problem occours at least
echo once, stop network traffic recording by running this script again.
echo.
pause
exit 0

:stop_pcap
echo Stopping packet capture (this may take a minute or two)...
netsh trace stop
del %tracefile%
echo.
echo OK!
echo Please send the following file:
echo   %cabfile%
echo (^^ it may be too large to email, in which case use Google Drive or Dropbox)
echo.
pause
exit 0