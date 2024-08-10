@echo off
set "ahkPath=d:\Program Files\AutoHotkey"
set "ahkExe=%ahkPath%\AutoHotkeyA32.exe"
set "projPath=%USERPROFILE%\Documents\HotKeySpeak"
set "projFile=%projPath%\HotKeySpeak.ahk"

cd /d "%projPath%"

"%ahkExe%" "%projFile%"
if %ERRORLEVEL% equ 0 (
    echo Success: The script "%projFile%" ran successfully.
) else (
    echo Error: The script "%projFile%" failed with error code %ERRORLEVEL%.
)

pause