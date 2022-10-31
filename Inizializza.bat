@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

mkdir temp
cd temp
echo Inizializzazione in corso...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/microsoft/winget-cli/releases/download/v1.0.11692/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle', 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle')
powershell -Command "Invoke-WebRequest https://github.com/microsoft/winget-cli/releases/download/v1.3.2691/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
powershell Add-AppPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
cls
echo 1) Si
echo 2) No
choice /C 12 /M "Vuoi installare Libre Office?"
IF ERRORLEVEL 2 GOTO No
IF ERRORLEVEL 1 GOTO Si


:Si
cls
winget install -e --verbose-logs --id TheDocumentFoundation.LibreOffice
cls
GOTO End
:No
GOTO End

:End

cls
echo 1) Si
echo 2) No
choice /C 12 /M "Vuoi installare Chrome?"
IF ERRORLEVEL 2 GOTO No
IF ERRORLEVEL 1 GOTO Si


:Si
winget install -e --verbose-logs --id Google.Chrome
cls
GOTO End
:No
GOTO End

:End

cls
echo 1) Si
echo 2) No
choice /C 12 /M "Vuoi installare Acrobat?"
IF ERRORLEVEL 2 GOTO No
IF ERRORLEVEL 1 GOTO Si


:Si
winget install -e --verbose-logs --id Adobe.Acrobat.Reader.64-bit
cls
GOTO End
:No
GOTO End

:End

cls
echo 1) Si
echo 2) No
choice /C 12 /M "Vuoi installare Firefox?"
IF ERRORLEVEL 2 GOTO No
IF ERRORLEVEL 1 GOTO Si


:Si
winget install -e --verbose-logs --id Mozilla.Firefox
cls
GOTO End
:No
GOTO End

:End


echo=Premi un tasto qualsiasi per chiudere.
pause >nul
