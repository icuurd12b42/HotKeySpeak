
if(A_IsCompiled)
{
    if (! A_IsAdmin)
    {
        runAdmin := ReadIni("Settings.ini","MAINOPTIONS","RunAsAdmin", "0")+0
        setupRegistry := ReadIni("Settings.ini","MAINOPTIONS","SetupRegistry", "1") +0
        if(1==setupRegistry)
        {
            MsgBox, 262148, , First Time Running Hot Key Script!`n`nI would like to run as Administrator (This First Run) in order to setup the files association which makes sharing and installing new scripts easier.`n`nI will only ask this once. If you say No and change your mind later, you can change the SetupRegistry entry to 1 in the Settings.ini
            IfMsgBox, Yes
            {
                setupRegistry:=0
                WriteIni("Settings.ini","MAINOPTIONS","SetupRegistry", setupRegistry)
                MsgBox, 262148, , While on the Subject...`n`nWould you like to Always run Hot Key Script as Administrator?`n`nThis enables low level features which allow the program to emulate sending keys without the result being mixed with your inputs and interfere with the intended outcome. This is Preferable for gaming.`n`nIf you change your mind later you can change the RunAsAdmin entry to 1 (On) or 0 (Off) in the Settings.ini
                IfMsgBox, Yes
                {
                    runAdmin := 1
                    WriteIni("Settings.ini","MAINOPTIONS","RunAsAdmin", runAdmin)
                }
                DllCall("shell32\ShellExecuteA", uint, 0, str, "RunAs", str, A_ScriptDir . "\HotKeySpeak.exe"
                    , str, "", str, A_ScriptDir, int, 1)
                ExitApp
                return
            }
            else
            {
                setupRegistry := 0
            }
        }
        if(1==runAdmin)
        {
            DllCall("shell32\ShellExecuteA", uint, 0, str, "RunAs", str, A_ScriptDir . "\HotKeySpeak.exe"
                    , str, "", str, A_ScriptDir, int, 1)
            ExitApp
            return
        }
        WriteIni("Settings.ini","MAINOPTIONS","RunAsAdmin", runAdmin)
        WriteIni("Settings.ini","MAINOPTIONS","SetupRegistry", setupRegistry)
    }
}

/*
Debug.WriteNL(A_ComputerName)
Debug.WriteNL(A_UserName)
Loop, HKLM, System\MountedDevices ; faster registry read method

If mac := A_LoopRegName

	Break

RegExMatch(mac, ".*-(.*)}", mac)
Debug.WriteNL(mac)
Debug.WriteNL(SHA("Hello"))
*/


SetRegistry()
{
    /*
        [HKEY_CLASSES_ROOT\.ow]
    @="ObiWanFile"

    [HKEY_CLASSES_ROOT\ObiWanFile]
    @="ObiWan Custom Format"

    [HKEY_CLASSES_ROOT\ObiWanFile\DefaultIcon]
    @="C:\\Program Files\\ObiWan\\SpecialScript\\SpecialScript.exe,1"

    [HKEY_CLASSES_ROOT\ObiWanFile\shell\open]
    @="Open File"

    [HKEY_CLASSES_ROOT\ObiWanFile\shell\open\command]
    @=""C:\\Program Files\\ObiWan\\SpecialScript\\SpecialScript.exe" "%1""
    */
    ;RegWrite, REG_SZ, HKCR, .000, , HotKeySpeakShareFile

    extention := ".exehks"
    RegWrite, REG_SZ, HKEY_CLASSES_ROOT\%extention% , , HotKeySpeakShareFile
    extention := ".appshks"
    RegWrite, REG_SZ, HKEY_CLASSES_ROOT\%extention% , , HotKeySpeakShareFile
    extention := ".simphks"
    RegWrite, REG_SZ, HKEY_CLASSES_ROOT\%extention% , , HotKeySpeakShareFile

    RegWrite, REG_SZ, HKEY_CLASSES_ROOT\HotKeySpeakShareFile , , Hot Key Speak Share File
    exefile:=A_ScriptDir . "\HotKeySpeak.exe"
    icofile:=A_ScriptDir . "\Graphics\Icons\IconForSharedFiles.ico"
    RegWrite, REG_SZ, HKEY_CLASSES_ROOT\HotKeySpeakShareFile\DefaultIcon , , %icofile%
    RegWrite, REG_SZ, HKEY_CLASSES_ROOT\HotKeySpeakShareFile\shell\open , , "Open File"
    percent1 := "%1"
    RegWrite, REG_SZ, HKEY_CLASSES_ROOT\HotKeySpeakShareFile\shell\open\command , , %exefile% "%percent1%"
                    
}
SetRegistry()

