@echo off
set "ahkPath=d:\Program Files\AutoHotkey"
set "ahkComp=%ahkPath%\Compiler\Ahk2Exe.exe"
set "BinType=%ahkPath%\Compiler\ANSI 32-bit.bin"

set "projPath=%USERPROFILE%\Documents\HotKeySpeak"
set "srcFile=%projPath%\HotKeySpeak.ahk"
set "outFile=%projPath%\HotKeySpeak.exe"
set "IconFile=%projPath%\Graphics\Icons\HotKeySpeak.ico"

echo AHK Compiler: %ahkComp%
echo Bin Type: %BinType%
echo Project Path: %projPath%
echo Source File: %srcFile%
echo Output File: %outFile%
echo Icon File: %IconFile%

cd /d "%projPath%"

"%ahkComp%" /in "%srcFile%" /out "%outFile%" /icon "%IconFile%" /bin "%BinType%" /mpress 0

if %ERRORLEVEL% equ 0 (
    echo Script compiled successfully!
) else (
    echo Error: Compilation failed!
)
pause