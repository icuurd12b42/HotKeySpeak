
global gDoHand :=0

global hMainLink1 := 0
global hMainLink2 := 0
global hMainLink3 := 0
global hMainLink4 := 0
global hMainLink5 := 0

global hCommandLink1:= 0
global hEditCommandDialog_ReloadButton := 0
global hEditCommandDialog_EditButton:= 0
global hEditCommandDialog_RunButton := 0
global hEditCommandDialog_SelectProgramButton := 0

global hContextLink1:= 0
global hEditContextDialog_ReloadButton := 0
global hEditContextDialog_EditButton:= 0
global hEditContextDialog_RunButton := 0
global hEditContextDialog_SelectProgramButton := 0

global hExeLink1:= 0
global hEditExeDialog_SelectExeProgramButton := 0
global hEditExeDialog_ReloadButton := 0
global hEditExeDialog_EditButton:= 0
global hEditExeDialog_RunButton := 0
global hEditExeDialog_SelectProgramButton := 0

global hGroupLink1:= 0

global hWindowContextLink1:= 0
global hEditWindowContextDialog_ReloadButton := 0
global hEditWindowContextDialog_EditButton:= 0
global hEditWindowContextDialog_RunButton := 0
global hEditWindowContextDialog_SelectProgramButton := 0
global hEditWindowContextDialog_FindWindowButton := 0

global hProcessLink1 := 0
global hListProcessDialog_ChoseFileButton := 0
global hListProcessDialog_FindWindowButton := 0

global hEditCommandDialogRecordBut :=0
global hEditCommandDialogRecordingBut:=0

global hEditContextDialogRecordBut :=0
global hEditContextDialogRecordingBut:=0
global hOptionsLink1 := 0

global gSettingKeys := 0
global gKeysString := ""
global gLastKey := 0
global hKeyGrabCtrl := 0

OnMessage(0x20,  "WM_SETCURSOR")
OnMessage(0x200, "WM_MOUSEMOVE")
OnMessage( 0x0100, "WM_KEYDOWN" ) 
OnMessage( 0x0102, "WM_KEYDOWN" ) ; 0x100 to 0x108
OnMessage( 0x0103, "WM_KEYDOWN" ) ; 0x100 to 0x108
OnMessage( 0x0104, "WM_KEYDOWN" ) ; 0x100 to 0x108
OnMessage( 0x0105, "WM_KEYDOWN" ) ; 0x100 to 0x108
OnMessage( 0x0106, "WM_KEYDOWN" ) ; 0x100 to 0x108
OnMessage( 0x0107, "WM_KEYDOWN" ) ; 0x100 to 0x108
OnMessage( 0x0108, "WM_KEYDOWN" ) ; 0x100 to 0x108
OnMessage( 0x0101, "WM_KEYUP" ) 


WM_MOUSEMOVE(wParam,lParam, msg, hwnd){
	
    ;static hCurs:=DllCall("LoadCursor","UInt",0,"Int",32649,"UInt") ;IDC_HAND
	
    if (msg = 0x200) ; WM_MOUSEMOVE
    {
        HandControls := []
        HandControls.push(hMainLink1)
        HandControls.push(hMainLink2)
        HandControls.push(hMainLink3)
        HandControls.push(hMainLink4)
        HandControls.push(hMainLink5)

        HandControls.push(hCommandLink1)
        HandControls.push(hEditCommandDialog_ReloadButton)
        HandControls.push(hEditCommandDialog_EditButton)
        HandControls.push(hEditCommandDialog_RunButton)
        HandControls.push(hEditCommandDialog_SelectProgramButton)
        HandControls.push(hEditCommandDialogRecordBut)
        HandControls.push(hEditCommandDialogRecordingBut)
        

        HandControls.push(hContextLink1)
        HandControls.push(hEditContextDialog_ReloadButton)
        HandControls.push(hEditContextDialog_EditButton)
        HandControls.push(hEditContextDialog_RunButton)
        HandControls.push(hEditContextDialog_SelectProgramButton)
        HandControls.push(hEditContextDialogRecordBut)
        HandControls.push(hEditContextDialogRecordingBut)


        HandControls.push(hExeLink1)
        HandControls.push(hEditExeDialog_SelectExeProgramButton)
        HandControls.push(hEditExeDialog_ReloadButton)
        HandControls.push(hEditExeDialog_EditButton)
        HandControls.push(hEditExeDialog_RunButton)
        HandControls.push(hEditExeDialog_SelectProgramButton)

        HandControls.push(hGroupLink1)

        HandControls.push(hWindowContextLink1)
        HandControls.push(hEditWindowContextDialog_ReloadButton)
        HandControls.push(hEditWindowContextDialog_EditButton)
        HandControls.push(hEditWindowContextDialog_RunButton)
        HandControls.push(hEditWindowContextDialog_SelectProgramButton)
        HandControls.push(hEditWindowContextDialog_FindWindowButton)

        HandControls.push(hProcessLink1)
        HandControls.push(hListProcessDialog_ChoseFileButton)
        HandControls.push(hListProcessDialog_FindWindowButton)

        HandControls.push(hOptionsLink1)

		;gDoHand := false
        MouseGetPos, , , ,hctrl,2
		
        If TVHelper.IsValInArr(hctrl,HandControls) ; put here the name of the control.
		{
            gDoHand :=1
            HandControls :=0
			return
        	;DllCall("SetCursor","UInt",hCurs)
        	;Return 1
		}
        HandControls :=0
		;Return 0
		
    }
	gDoHand -= 1
	if(gDoHand<0)
	{
		gDoHand := 0
	}
}


;This is the proper place to set the cursor
WM_SETCURSOR(wParam, lParam)
{
  HitTest := lParam & 0xFFFF
  if (HitTest = 1 && gDoHand != 0)
  {
	  	static hCurs:=DllCall("LoadCursor","UInt",0,"Int",32649,"UInt") ;IDC_HAND
    	DllCall("SetCursor", "ptr", hCurs)
    	return true  ;Do not do further cursor processing (ie: skip default behavior)
  }
  ;Else, let the system handle it
}

global gSuspendKeyRecording := 0
LParamKeyCodeToString(lParam)
{
    code := (lParam>>16) & 0xFF
    if(code>0 && code<=KeyCodeMap.Length())
    {
        return KeyCodeMap[code]
    }
    SetFormat, Integer, Hex
    ret := "SC" . SubStr((((lParam>>16) & 0xFF)+0xF000),-2)
    SetFormat, Integer, D
    return ret
}
WM_KEYDOWN(wParam,lParam, msg, hwnd)
{
    if(gSuspendKeyRecording)
    {
        return 0
    }
    if(hwnd == hKeyGrabCtrl) ;change this to the right code
    {
        
        if(gSettingKeys == 0)
        {
            gSettingKeys := 1
            gKeysString := ""
            GuiControl,, %hKeyGrabCtrl%, %gKeysString%
        }
        code := (lParam>>16) & 0xFF
        if(code != gLastKey)
        {
            zePlus:=" + "
            if(gKeysString == "") 
            {
                zePlus := ""
            }
            gKeysString .= zePlus . LParamKeyCodeToString(lParam)
            gLastKey := code
            GuiControl,, %hKeyGrabCtrl%, %gKeysString%
            EBSelectAll(hwnd)
            
        }
        return 0
    }
    Else
    {
        gSettingKeys == 0
        gLastKey :=0
        gKeysString := ""
    }
}

WM_KEYUP(wParam,lParam, msg, hwnd)
{
    if(gSuspendKeyRecording)
    {
        return 0
    }
    if(hwnd == hKeyGrabCtrl) ;change this to the right code
    {

        gSettingKeys := 0
        gLastKey :=0
        FinalString := ToHotKeySpecs(gKeysString)
        GuiControl,, %hKeyGrabCtrl%, %FinalString%
        EBSelectAll(hwnd)
        return 0
    }
    Else
    {
        gSettingKeys == 0
        gLastKey :=0
        gKeysString := ""
    }
}
ToHotKeySpecs(String)
{
    gSuspendKeyRecording := true
    SetTimer, SuspendedRecording, -500
    ;#	Win (Windows logo key). In v1.0.48.01+, for Windows Vista and later, hotkeys that include the Windows key (e.g. #a) will wait for the Windows key to be released before sending any text containing an "L" keystroke. This prevents usages of Send within such a hotkey from locking the PC. This behavior applies to all sending modes except SendPlay (which doesn't need it) and blind mode.
    ;!	Alt
    ;^	Control
    ;+	Shift
    ret := String
    ret := StrReplace(ret,"Ctrl + ","^")
    ret := StrReplace(ret,"Alt + ","!")
    ret := StrReplace(ret,"Shift + ","+")
    ret := StrReplace(ret,"Win + ","#")
    ret := StrReplace(ret," + ","&")
    ;ret := StrReplace(ret,"&"," & ")
    ;;arr := StrSplit(ret,"&")
    try
    {
        Hotkey, %ret%, TestHotKeyStub, On
        Hotkey, %ret%, TestHotKeyStub, Off
    }
    catch e 
    {
        Debug.MsgBox("That key combination is not valid!")
        gSuspendKeyRecording := true
        SetTimer, SuspendedRecording, -500
        return String
    }
    
    return ret
}
TestHotKeyStub()
{
}
SuspendedRecording()
{
    gSuspendKeyRecording:=false
}



global KeyCodeMap := "Esc"
KeyCodeMap .= ",1"
KeyCodeMap .= ",2"
KeyCodeMap .= ",3"
KeyCodeMap .= ",4"
KeyCodeMap .= ",5"
KeyCodeMap .= ",6"
KeyCodeMap .= ",7"
KeyCodeMap .= ",8"
KeyCodeMap .= ",9"
KeyCodeMap .= ",0"
KeyCodeMap .= ",SC00C"
KeyCodeMap .= ",SC00D"
KeyCodeMap .= ",Backspace"
KeyCodeMap .= ",Tab"
KeyCodeMap .= ",Q"
KeyCodeMap .= ",W"
KeyCodeMap .= ",E"
KeyCodeMap .= ",R"
KeyCodeMap .= ",T"
KeyCodeMap .= ",Y"
KeyCodeMap .= ",U"
KeyCodeMap .= ",I"
KeyCodeMap .= ",O"
KeyCodeMap .= ",P"
KeyCodeMap .= ",SC01A"
KeyCodeMap .= ",SC01B"
KeyCodeMap .= ",Enter"
KeyCodeMap .= ",Ctrl"
KeyCodeMap .= ",A"
KeyCodeMap .= ",S"
KeyCodeMap .= ",D"
KeyCodeMap .= ",F"
KeyCodeMap .= ",G"
KeyCodeMap .= ",H"
KeyCodeMap .= ",J"
KeyCodeMap .= ",K"
KeyCodeMap .= ",L"
KeyCodeMap .= ",SC027"
KeyCodeMap .= ",SC028"
KeyCodeMap .= ",SC029"
KeyCodeMap .= ",Shift"
KeyCodeMap .= ",SC02B"
KeyCodeMap .= ",Z"
KeyCodeMap .= ",X"
KeyCodeMap .= ",C"
KeyCodeMap .= ",V"
KeyCodeMap .= ",B"
KeyCodeMap .= ",N"
KeyCodeMap .= ",M"
KeyCodeMap .= ",SC033"
KeyCodeMap .= ",SC034"
KeyCodeMap .= ",Devide"
KeyCodeMap .= ",Shift"
KeyCodeMap .= ",Multiply"
KeyCodeMap .= ",Alt"
KeyCodeMap .= ",Space"
KeyCodeMap .= ",CapsLock"
KeyCodeMap .= ",F1"
KeyCodeMap .= ",F2"
KeyCodeMap .= ",F3"
KeyCodeMap .= ",F4"
KeyCodeMap .= ",F5"
KeyCodeMap .= ",F6"
KeyCodeMap .= ",F7"
KeyCodeMap .= ",F8"
KeyCodeMap .= ",F9"
KeyCodeMap .= ",F10"
KeyCodeMap .= ",NumLock"
KeyCodeMap .= ",ScrollLock"
KeyCodeMap .= ",Home"
KeyCodeMap .= ",Up"
KeyCodeMap .= ",PgUp"
KeyCodeMap .= ",Subtract"
KeyCodeMap .= ",Left"
KeyCodeMap .= ",SC04C"
KeyCodeMap .= ",Right"
KeyCodeMap .= ",Add"
KeyCodeMap .= ",End"
KeyCodeMap .= ",Down"
KeyCodeMap .= ",PgDn"
KeyCodeMap .= ",Ins"
KeyCodeMap .= ",Del"
KeyCodeMap .= ",SC054"
KeyCodeMap .= ",SC055"
KeyCodeMap .= ",SC056"
KeyCodeMap .= ",F11"
KeyCodeMap .= ",F12"
KeyCodeMap .= ",SC059"
KeyCodeMap .= ",SC05A"
KeyCodeMap .= ",Win"
KeyCodeMap .= ",Win"
KeyCodeMap .= ",SC05D"
KeyCodeMap .= ",SC05E"
KeyCodeMap .= ",SC05F"
KeyCodeMap .= ",SC060"
KeyCodeMap .= ",SC061"
KeyCodeMap .= ",SC062"
KeyCodeMap .= ",SC063"
KeyCodeMap .= ",SC064"
KeyCodeMap .= ",SC065"
KeyCodeMap .= ",SC066"
KeyCodeMap .= ",SC067"
KeyCodeMap .= ",SC068"
KeyCodeMap .= ",SC069"
KeyCodeMap .= ",SC06A"
KeyCodeMap .= ",SC06B"
KeyCodeMap .= ",SC06C"
KeyCodeMap .= ",SC06D"
KeyCodeMap .= ",SC06E"
KeyCodeMap .= ",SC06F"
KeyCodeMap .= ",SC070"
KeyCodeMap .= ",SC071"
KeyCodeMap .= ",SC072"
KeyCodeMap .= ",SC073"
KeyCodeMap .= ",SC074"
KeyCodeMap .= ",SC075"
KeyCodeMap .= ",SC076"
KeyCodeMap .= ",SC077"
KeyCodeMap .= ",SC078"
KeyCodeMap .= ",SC079"
KeyCodeMap .= ",SC07A"
KeyCodeMap .= ",SC07B"
KeyCodeMap .= ",SC07C"
KeyCodeMap .= ",SC07D"
KeyCodeMap .= ",SC07E"
KeyCodeMap .= ",SC07F"
KeyCodeMap .= ",SC080"
KeyCodeMap .= ",SC081"
KeyCodeMap .= ",SC082"
KeyCodeMap .= ",SC083"
KeyCodeMap .= ",SC084"
KeyCodeMap .= ",SC085"
KeyCodeMap .= ",SC086"
KeyCodeMap .= ",SC087"
KeyCodeMap .= ",SC088"
KeyCodeMap .= ",SC089"
KeyCodeMap .= ",SC08A"
KeyCodeMap .= ",SC08B"
KeyCodeMap .= ",SC08C"
KeyCodeMap .= ",SC08D"
KeyCodeMap .= ",SC08E"
KeyCodeMap .= ",SC08F"
KeyCodeMap .= ",SC090"
KeyCodeMap .= ",SC091"
KeyCodeMap .= ",SC092"
KeyCodeMap .= ",SC093"
KeyCodeMap .= ",SC094"
KeyCodeMap .= ",SC095"
KeyCodeMap .= ",SC096"
KeyCodeMap .= ",SC097"
KeyCodeMap .= ",SC098"
KeyCodeMap .= ",SC099"
KeyCodeMap .= ",SC09A"
KeyCodeMap .= ",SC09B"
KeyCodeMap .= ",SC09C"
KeyCodeMap .= ",SC09D"
KeyCodeMap .= ",SC09E"
KeyCodeMap .= ",SC09F"

KeyCodeMap := StrSplit(KeyCodeMap,",")
