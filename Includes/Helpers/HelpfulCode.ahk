LinkUseDefaultColor(hLink, Use := True) {
   VarSetCapacity(LITEM, 4278, 0)            ; 16 + (MAX_LINKID_TEXT * 2) + (L_MAX_URL_LENGTH * 2)
   NumPut(0x03, LITEM, "UInt")               ; LIF_ITEMINDEX (0x01) | LIF_STATE (0x02)
   NumPut(Use ? 0x10 : 0, LITEM, 8, "UInt")  ; ? LIS_DEFAULTCOLORS : 0
   NumPut(0x10, LITEM, 12, "UInt")           ; LIS_DEFAULTCOLORS
   While DllCall("SendMessage", "Ptr", hLink, "UInt", 0x0702, "Ptr", 0, "Ptr", &LITEM, "UInt") ; LM_SETITEM
      NumPut(A_Index, LITEM, 4, "Int")
   GuiControl, +Redraw, %hLink%
}

SetSysLinkColor(hLink, color := "")  {
   static WM_USER := 0x400, LM_SETITEM := WM_USER + 0x302
        , LIF_ITEMINDEX := 0x1, LIF_STATE := 0x2
        , LIS_DEFAULTCOLORS := 0x10
        , L_MAX_URL_LENGTH := 2048 + 32 + 3, MAX_LINKID_TEXT := 48
        
   if (color != "")  {
      hGui := DllCall("GetParent", Ptr, hLink, Ptr)
      Gui, %hGui%: Font, c%color%
      GuiControl, %hGui%: Font, %hLink%
   }
   VarSetCapacity(LITEM, 4*4 + (MAX_LINKID_TEXT + L_MAX_URL_LENGTH)*2, 0)
   NumPut(LIF_ITEMINDEX | LIF_STATE, LITEM)
   NumPut(LIS_DEFAULTCOLORS, LITEM, 8)
   NumPut(LIS_DEFAULTCOLORS, LITEM, 12)
   while DllCall("SendMessage", Ptr, hLink, UInt, LM_SETITEM, Ptr, 0, Ptr, &LITEM)
      NumPut(A_Index, LITEM, 4, "UInt")
}

SetParent(hChild,hParent)
{
    r:=DllCall("SetParent", "UInt", hChild, "UInt", hParent, "UInt")
    
}

SetOwner(hwnd, newOwner) {

    static GWL_HWNDPARENT := -8
    r:=0
    if A_PtrSize = 8

        DllCall("SetWindowLongPtr", "ptr", hwnd, "int", GWL_HWNDPARENT, "ptr", newOwner)

    else

        DllCall("SetWindowLong", "int", hwnd, "int", GWL_HWNDPARENT, "int", newOwner)

}
EnableWindow(hWnd,enable)
{
    DllCall("EnableWindow", "int", hWnd, "int", enable)
}
IsIconic(hWnd)
{
    return DllCall("IsIconic", "int", hWnd)
}
ShowWindow(hWnd,nCmdShow)
{
    ;https://msdn.microsoft.com/en-us/library/windows/desktop/ms633548(v=vs.85).aspx
    DllCall("ShowWindow", "int", hWnd, "int", nCmdShow)
}
MoveWindow(hWnd,X, Y, nWidth, nHeight, bRepaint)
{
    DllCall("MoveWindow", "int", hWnd, "int", X, "int", Y, "int", nWidth, "int", nHeight, "int", bRepaint)
}
GetActiveWindow()
{
    ;;HWND WINAPI GetActiveWindow(void);
    return DllCall("GetActiveWindow")
}
ReadIni(Filename, Section, Key , Default)
{
    IniRead, OutputVar, %Filename%, %Section%, %Key% , %Default%
    return OutputVar
}
WriteIni(Filename, Section, Key , Value)
{
    IniWrite, %Value%, %Filename%, %Section%, %Key%
}
SaveWindowPos(hwnd, iniSection)
{
    if(IsIconic(hwnd))
    {
        return
    }
    WinGetPos, X, Y, Width, Height, ahk_id %hwnd%
    WriteIni("Settings.ini", iniSection, "X" , X)
    WriteIni("Settings.ini", iniSection, "Y" , Y)
    WriteIni("Settings.ini", iniSection, "Width" , Width)
    WriteIni("Settings.ini", iniSection, "Height" , Height)
}
ReadWindowPos(iniSection)
{
    X:=ReadIni("Settings.ini", iniSection, "X" , "200")+0
    Y:=ReadIni("Settings.ini", iniSection, "Y" , "200")+0
    Width:=ReadIni("Settings.ini", iniSection, "Width" , 600)+0
    Height:=ReadIni("Settings.ini", iniSection, "Height" , 400)+0

    
    minw := SysGet(28)
    minh := SysGet(29)
    scrw := SysGet(78)
    scrh := SysGet(79)
    Width := clamp(Width,minw,scrw)
    Height := clamp(Height,minh,scrh)
    X:=clamp(X,0,scrw-4)
    Y:=clamp(Y,0,scrh-4)
    return {X: X, Y: Y, Width: Width, Height: Height}
}
clamp(val,min,max)
{
    v := val
    if(v<min)
        v:=min
    if(v>max)
        v:=max
    return v
}
SysGet(command)
{
    SysGet, OutputVar, %command%
    return OutputVar
}

SetForegroundWindow(hWnd){
    DllCall("SetForegroundWindow", "int", hWnd)
}

FlashWindow(hWnd,Flash)
{
    DllCall( "FlashWindow", "UInt", hWnd, "Int",Flash )
}
GetTickCount()
{
    ;DWORD WINAPI GetTickCount(void);
    return DllCall("GetTickCount")
}

ValToHexStr(val)
{
    numbers := "0123456789ABCDEF"
    num := val
    ret := ""
    while(num)
    {
        digit := Mod(num, 16)
        ret := SubStr(numbers, digit+1, 1) . ret
        num := floor(num >> 4)
       
    }
    return ret
}
Max(v1,v2)
{
    if(v1<v2)
    {
        return v2
    }
    return v1
}
Min(v1,v2)
{
    if(v1<v2)
    {
        return v1
    }
    return v2
}
EBSelectAll(hWnd)
{
    DllCall( "SendMessage", "UInt", hWnd, "Uint", 0x00B1,"Int",0,"Int",-1 )
    
}

GetWindowLong(hWnd,nIndex)
{
    return DllCall("GetWindowLong", "UInt", hWnd, "Int", nIndex)
}
SetWindowLong(hWnd,nIndex, Value)
{
    return DllCall("GetWindowLong", "UInt", hWnd, "Int", nIndex, "Int", Value)
}



CreateSolidBrush(hexColor)
{
    ;MyOutputDebug("BRUSH: " . DllCall("CreateSolidBrush", "UInt", hexColor))
    return DllCall("CreateSolidBrush", "UInt", hexColor)
}
SetClassLong(hWnd,nIndex, Value)
{
    return DllCall("SetClassLong", "UInt", hWnd, "Int", nIndex, "Int", Value)
}
SetWindowBackgroundColor(hwnd,Color)
{
    ;MyOutputDebug("OldVal: " . SetClassLong(hwnd, -10, CreateSolidBrush(Color)))
    ;MyOutputDebug("OldVal2: " . SetClassLong(hwnd, -10, CreateSolidBrush(Color)))
}
EraseWindowBackground(hWnd)
{
    DllCall("InvalidateRect", "UInt", hWnd, "Int", 0, "Int", 1)
  
}
FreeSyntaxModule()
{
    if(tmcSyntaxhModule != 0)
    {
        DllCall("FreeLibrary", "Ptr", tmcSyntaxhModule)
    }
}


InitSyntaxModule()
{
    tmcSyntaxhModule := DllCall("LoadLibrary", "Str", "tmcsyntaxEB.dll", "Ptr")
    ;MyOutputDebug("hModule: " . tmcSyntaxhModule)
    if(tmcSyntaxhModule != 0)
    {
        tmcRemoveHilite  := DllCall("GetProcAddress", Ptr, tmcSyntaxhModule, AStr, "TMC_SEB_RemoveHilite", "Ptr")
        tmcFuncSetHilite := DllCall("GetProcAddress", Ptr, tmcSyntaxhModule, AStr, "TMC_SEB_SetHilite", "Ptr")
        tmcLoadLanguage := DllCall("GetProcAddress", Ptr, tmcSyntaxhModule, AStr, "TMC_SEB_LoadLanguage", "Ptr")
        tmcCleanupSEB := DllCall("GetProcAddress", Ptr, tmcSyntaxhModule, AStr, "TMC_SEB_CleanUp", "Ptr")
        
        tmcGetSelectedLanguage := DllCall("GetProcAddress", Ptr, tmcSyntaxhModule, AStr, "TMC_SEB_GetSelectedLanguage", "Ptr")
        ;if(LoadLanguageFn != 0)
        ;{
            ;LanguageName := "HKS + JScript"
            ;LanguageFile := "HKS-JScript-Syntax.txt"
            ;DllCall(LoadLanguageFn, "AStr",LanguageName, "AStr", LanguageFile)
            LoadAllLanguageFiles()
            ;t := GetSelectedLanguage()
            ;MsgBox, , "Test", %t%
            ;MyOutputDebug("Lang Set: " . GetSelectedLanguage())
        ;}
    }
}
SetHilite(hWnd)
{
    LanguageName := CodeBoxSyntax
    if(tmcFuncSetHilite != 0)
    {
        DllCall(tmcFuncSetHilite, "UInt", hWnd, "AStr", LanguageName, "UInt", LineNumberBackColor, "UInt", LineNumberColor)
    }
}

RemoveHilite(hWnd)
{
    CodeBoxSyntax := GetSelectedLanguage()
    if(tmcFuncRemoveHilite != 0)
    {
        DllCall(tmcFuncRemoveHilite, "UInt", hWnd)
    }
}

CleanupHilite()
{
    if(tmcCleanupSEB != 0)
    {
        DllCall(tmcCleanupSEB)
    }
}

GetSelectedLanguage()
{
    if(tmcGetSelectedLanguage != 0)
    {
        return DllCall(tmcGetSelectedLanguage,AStr)

    }
    return ""
}
LoadLanguageFile(LanguageName,LanguageFile)
{
    if(tmcLoadLanguage != 0)
    {
        return DllCall(tmcLoadLanguage,"AStr",LanguageName, "AStr", LanguageFile)

    }
}
LoadAllLanguageFiles()
{
    Loop, Files, %A_ScriptDir%\SyntaxEBLangFiles\*.*, R
    {
         ;MsgBox, 4, , Filename = %A_LoopFileFullPath%`n`nContinue?
         SplitPath, A_LoopFileFullPath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
         LoadLanguageFile(OutNameNoExt,A_LoopFileFullPath)
    }
}