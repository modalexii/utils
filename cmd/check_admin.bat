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