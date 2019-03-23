
TimersHandler()
{
	jsRunner := Interpreter
	if(EventManager.m_current_process_extra_data)
	{
		jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
	}
	For key, value in jsRunner.m_Timers
    {
		if(value[1])
		{
        	
			if(jsRunner.m_TimerAt>=value[3])
			{
				;-val is run once
				if(value[2]<0)
				{
					;VoiceAgent.Say("Reset")
					value[1] := 0
				}
				else
				{
					value[3] := jsRunner.m_TimerAt+value[2]
				}
				jsRunner.Exec(key)
				
			}
		}

    }
	;if(Mod(jsRunner.m_TimerAt,1000)==0)
	;	Debug.WriteNL(jsRunner.m_TimerAt)
	jsRunner.m_TimerAt+=33
}
Class Interpreter
{
    m_Js :=
	m_Timers :=
	m_TimerAt :=
	m_MyObjectsFuncs := []
	__New()
	{
		
		this.Init()
	}
	
    Init()
    {
		this.m_Timers := []
		this.m_TimerAt := 0
		SetTimer, TimersHandler, 33
        try  ; Attempts to create control
		{
			this.m_Js := new ActiveScript("JScript")
            ;My Objects
			;this.m_Js.AddObject("Debug", ComDispatch0(Debug))
			this.m_Js.AddObject("HKS", ComDispatch0(HKS))

			
			;https://autohotkey.com/boards/viewtopic.php?t=27321
			;AHK Commands may require a wrapper
			;AHK functions
			this.m_Js.AddObject("KeyWaitAll", Func("KeyWaitAll"))
			this.m_Js.AddObject("NumGet", Func("NumGet"))
			this.m_Js.AddObject("Abs", Func("Abs"))
			this.m_Js.AddObject("ACos", Func("ACos"))
			this.m_Js.AddObject("Asc", Func("Asc"))
			this.m_Js.AddObject("ASin", Func("ASin"))
			this.m_Js.AddObject("ATan", Func("ATan"))
			this.m_Js.AddObject("Ceil", Func("Ceil"))
			this.m_Js.AddObject("Chr", Func("Chr"))
			this.m_Js.AddObject("Cos", Func("Cos"))
			/*
			this.m_Js.AddObject("DllCall", Func("DllCall"))
			*/
			this.m_Js.AddObject("Exp", Func("Exp"))
			this.m_Js.AddObject("FileExist", Func("FileExist"))
			this.m_Js.AddObject("Floor", Func("Floor"))
			this.m_Js.AddObject("GetKeyState", Func("GetKeyState"))
			this.m_Js.AddObject("IL_Add", Func("IL_Add"))
			this.m_Js.AddObject("IL_Create", Func("IL_Create"))
			this.m_Js.AddObject("IL_Destroy", Func("IL_Destroy"))
			this.m_Js.AddObject("InStr", Func("InStr"))
			this.m_Js.AddObject("IsFunc", Func("IsFunc"))
			this.m_Js.AddObject("IsLabel", Func("IsLabel"))
			this.m_Js.AddObject("Ln", Func("Ln"))
			this.m_Js.AddObject("Log", Func("Log"))
			this.m_Js.AddObject("LV_Add", Func("LV_Add"))
			this.m_Js.AddObject("LV_Delete", Func("LV_Delete"))
			this.m_Js.AddObject("LV_DeleteCol", Func("LV_DeleteCol"))
			this.m_Js.AddObject("LV_GetCount", Func("LV_GetCount"))
			this.m_Js.AddObject("LV_GetNext", Func("LV_GetNext"))
			this.m_Js.AddObject("LV_GetText", Func("LV_GetText"))
			this.m_Js.AddObject("LV_Insert", Func("LV_Insert"))
			this.m_Js.AddObject("LV_InsertCol", Func("LV_InsertCol"))
			this.m_Js.AddObject("LV_Modify", Func("LV_Modify"))
			this.m_Js.AddObject("LV_ModifyCol", Func("LV_ModifyCol"))
			this.m_Js.AddObject("LV_SetImageList", Func("LV_SetImageList"))
			this.m_Js.AddObject("Mod", Func("Mod"))
			this.m_Js.AddObject("RegExMatch", Func("RegExMatch"))
			this.m_Js.AddObject("RegExReplace", Func("RegExReplace"))
			this.m_Js.AddObject("Round", Func("Round"))
			this.m_Js.AddObject("SB_SetIcon", Func("SB_SetIcon"))
			this.m_Js.AddObject("SB_SetParts", Func("SB_SetParts"))
			this.m_Js.AddObject("SB_SetText", Func("SB_SetText"))
			this.m_Js.AddObject("Sin", Func("Sin"))
			this.m_Js.AddObject("Sqrt", Func("Sqrt"))
			this.m_Js.AddObject("StrLen", Func("StrLen"))
			this.m_Js.AddObject("SubStr", Func("SubStr"))
			this.m_Js.AddObject("Tan", Func("Tan"))
			
			
			this.m_Js.AddObject("SetTimer", Func("MySetTimer"))
			this.m_Js.AddObject("TimerExists", Func("TimerExists"))
			this.m_Js.AddObject("TimerClearAll", Func("TimerClearAll"))
			this.m_Js.AddObject("TimerTimeLeft", Func("TimerTimeLeft"))

			this.m_Js.AddObject("TV_Add", Func("TV_Add"))
			this.m_Js.AddObject("TV_Delete", Func("TV_Delete"))
			this.m_Js.AddObject("TV_Get", Func("TV_Get"))
			this.m_Js.AddObject("TV_GetChild", Func("TV_GetChild"))
			this.m_Js.AddObject("TV_GetCount", Func("TV_GetCount"))
			this.m_Js.AddObject("TV_GetNext", Func("TV_GetNext"))
			this.m_Js.AddObject("TV_GetParent", Func("TV_GetParent"))
			this.m_Js.AddObject("TV_GetPrev", Func("TV_GetPrev"))
			this.m_Js.AddObject("TV_GetSelection", Func("TV_GetSelection"))
			this.m_Js.AddObject("TV_GetText", Func("TV_GetText"))
			this.m_Js.AddObject("TV_Modify", Func("TV_Modify"))
			this.m_Js.AddObject("VarSetCapacity", Func("VarSetCapacity"))
			this.m_Js.AddObject("WinActive", Func("WinActive"))
			this.m_Js.AddObject("WinExist", Func("WinExist"))
            
			/*
			this.m_Js.AddObject("ComObj", Func("ComObj"))
			this.m_Js.AddObject("ComObjActive", Func("ComObjActive"))
			this.m_Js.AddObject("ComObjArray", Func("ComObjArray"))
			this.m_Js.AddObject("ComObjConnect", Func("ComObjConnect"))
			this.m_Js.AddObject("ComObjCreate", Func("ComObjCreate"))
			this.m_Js.AddObject("ComObject", Func("ComObject"))
			this.m_Js.AddObject("ComObjEnwrap", Func("ComObjEnwrap"))
			this.m_Js.AddObject("ComObjError", Func("ComObjError"))
			this.m_Js.AddObject("ComObjFlags", Func("ComObjFlags"))
			this.m_Js.AddObject("ComObjGet", Func("ComObjGet"))
			this.m_Js.AddObject("ComObjMissing", Func("ComObjMissing"))
			this.m_Js.AddObject("ComObjParameter", Func("ComObjParameter"))
			this.m_Js.AddObject("ComObjQuery", Func("ComObjQuery"))
			this.m_Js.AddObject("ComObjRetVal", Func("ComObjRetVal"))
			this.m_Js.AddObject("ComObjType", Func("ComObjType"))
			this.m_Js.AddObject("ComObjUnwrap", Func("ComObjUnwrap"))
			this.m_Js.AddObject("ComObjValue", Func("ComObjValue"))
			this.m_Js.AddObject("FileOpen", Func("FileOpen"))
			*/

			this.m_Js.AddObject("Format", Func("Format"))
			this.m_Js.AddObject("GetKeyName", Func("GetKeyName"))
			this.m_Js.AddObject("GetKeySC", Func("GetKeySC"))
			this.m_Js.AddObject("GetKeyVK", Func("GetKeyVK"))
			this.m_Js.AddObject("IsByRef", Func("IsByRef"))
			this.m_Js.AddObject("IsObject", Func("IsObject"))
			this.m_Js.AddObject("LoadPicture", Func("LoadPicture"))
			this.m_Js.AddObject("LTrim", Func("LTrim"))
			this.m_Js.AddObject("MenuGetHandle", Func("MenuGetHandle"))
			this.m_Js.AddObject("MenuGetName", Func("MenuGetName"))
			/*
			this.m_Js.AddObject("ObjAddRef", Func("ObjAddRef"))
			this.m_Js.AddObject("ObjBindMethod", Func("ObjBindMethod"))
			this.m_Js.AddObject("ObjRawSet", Func("ObjRawSet"))
			this.m_Js.AddObject("ObjRelease", Func("ObjRelease"))
			this.m_Js.AddObject("OnClipboardChange", Func("OnClipboardChange"))
			*/
			this.m_Js.AddObject("Ord", Func("Ord"))
			this.m_Js.AddObject("RTrim", Func("RTrim"))
			this.m_Js.AddObject("StrGet", Func("StrGet"))
			this.m_Js.AddObject("StrPut", Func("StrPut"))
			this.m_Js.AddObject("StrReplace", Func("StrReplace"))
			this.m_Js.AddObject("StrSplit", Func("StrSplit"))
			this.m_Js.AddObject("Trim", Func("Trim"))


			
			this.m_Js.AddObject("BlockInput", Func("MyBlockInput"))
			this.m_Js.AddObject("Click", Func("MyClick"))
			this.m_Js.AddObject("ClipWait", Func("MyClipWait"))
			this.m_Js.AddObject("Control", Func("MyControl"))
			this.m_Js.AddObject("ControlClick", Func("MyControlClick"))
			this.m_Js.AddObject("ControlFocus", Func("MyControlFocus"))
			this.m_Js.AddObject("ControlGet", Func("MyControlGet"))
			this.m_Js.AddObject("ControlGetFocus", Func("MyControlGetFocus"))
			this.m_Js.AddObject("ControlGetPos", Func("MyControlGetPos"))
			this.m_Js.AddObject("ControlGetText", Func("MyControlGetText"))
			this.m_Js.AddObject("ControlMove", Func("MyControlMove"))
			this.m_Js.AddObject("ControlSend", Func("MyControlSend"))
			this.m_Js.AddObject("ControlSendRaw", Func("MyControlSendRaw"))
			this.m_Js.AddObject("ControlSetText", Func("MyControlSetText"))
			this.m_Js.AddObject("CoordMode", Func("MyCoordMode"))
			this.m_Js.AddObject("Critical", Func("MyCritical"))
			this.m_Js.AddObject("DetectHiddenText", Func("MyDetectHiddenText"))
			this.m_Js.AddObject("DetectHiddenWindows", Func("MyDetectHiddenWindows"))
			
			this.m_Js.AddObject("FormatTime", Func("MyFormatTime"))
			

			this.m_Js.AddObject("GroupActivate", Func("MyGroupActivate"))
			this.m_Js.AddObject("GroupAdd", Func("MyGroupAdd"))
			this.m_Js.AddObject("GroupClose", Func("MyGroupClose"))
			this.m_Js.AddObject("GroupDeactivate", Func("MyGroupDeactivate"))
			this.m_Js.AddObject("Gui", Func("MyGui"))
			this.m_Js.AddObject("GuiControl", Func("MyGuiControl"))
			this.m_Js.AddObject("GuiControlGet", Func("MyGuiControlGet"))
			this.m_Js.AddObject("Hotkey", Func("MyHotkey"))
			this.m_Js.AddObject("ImageSearch", Func("MyImageSearch"))
			this.m_Js.AddObject("IniDelete", Func("MyIniDelete"))
			this.m_Js.AddObject("IniRead", Func("MyIniRead"))
			this.m_Js.AddObject("IniWrite", Func("MyIniWrite"))

			this.m_Js.AddObject("InputBox", Func("MyInputBox"))
			
			this.m_Js.AddObject("KeyWait", Func("MyKeyWait"))
			
			this.m_Js.AddObject("Menu", Func("MyMenu"))
			this.m_Js.AddObject("MouseClick", Func("MyMouseClick"))
			this.m_Js.AddObject("MouseClickDrag", Func("MyMouseClickDrag"))
			this.m_Js.AddObject("MouseGetPos", Func("MyMouseGetPos"))
			this.m_Js.AddObject("MouseMove", Func("MyMouseMove"))
			this.m_Js.AddObject("MsgBox", Func("MyMsgBox"))
			
			this.m_Js.AddObject("OutputDebug", Func("MyOutputDebug"))
			
			this.m_Js.AddObject("PixelGetColor", Func("MyPixelGetColor"))
			this.m_Js.AddObject("PixelSearch", Func("MyPixelSearch"))
			this.m_Js.AddObject("PostMessage", Func("MyPostMessage"))
			this.m_Js.AddObject("Process", Func("MyProcess"))
			this.m_Js.AddObject("Progress", Func("MyProgress"))
			this.m_Js.AddObject("Random", Func("MyRandom"))
			this.m_Js.AddObject("RegRead", Func("MyRegRead"))
			
			
			this.m_Js.AddObject("Run", Func("MyRun"))
			
			this.m_Js.AddObject("RunWait", Func("MyRunWait"))
			this.m_Js.AddObject("Send", Func("MySend"))
			this.m_Js.AddObject("SendEvent", Func("MySendEvent"))
			this.m_Js.AddObject("SendInput", Func("MySendInput"))
			;this.m_Js.AddObject("SendMessageGet", Func("MySendMessageGet"))
			this.m_Js.AddObject("SendMessage", Func("MySendMessageSet"))
			this.m_Js.AddObject("SendMode", Func("MySendMode"))
			this.m_Js.AddObject("SendPlay", Func("MySendPlay"))
			this.m_Js.AddObject("SendRaw", Func("MySendRaw"))
			
			this.m_Js.AddObject("SetCapsLockState", Func("MySetCapsLockState"))
			this.m_Js.AddObject("SetControlDelay", Func("MySetControlDelay"))
			this.m_Js.AddObject("SetDefaultMouseSpeed", Func("MySetDefaultMouseSpeed"))
			this.m_Js.AddObject("SetEnv", Func("MySetEnv"))
			this.m_Js.AddObject("SetFormat", Func("MySetFormat"))
			this.m_Js.AddObject("SetKeyDelay", Func("MySetKeyDelay"))
			this.m_Js.AddObject("SetMouseDelay", Func("MySetMouseDelay"))
			this.m_Js.AddObject("SetNumLockState", Func("MySetNumLockState"))
			this.m_Js.AddObject("SetScrollLockState", Func("MySetScrollLockState"))
			this.m_Js.AddObject("SetStoreCapslockMode", Func("MySetStoreCapslockMode"))
			
			this.m_Js.AddObject("SetTitleMatchMode", Func("MySetTitleMatchMode"))
			this.m_Js.AddObject("SetWinDelay", Func("MySetWinDelay"))
			
			
			this.m_Js.AddObject("Sleep", Func("MySleep"))
			
			this.m_Js.AddObject("SoundBeep", Func("MySoundBeep"))
			this.m_Js.AddObject("SoundGet", Func("MySoundGet"))
			this.m_Js.AddObject("SoundGetWaveVolume", Func("MySoundGetWaveVolume"))
			this.m_Js.AddObject("SoundPlay", Func("MySoundPlay"))
			this.m_Js.AddObject("SoundSet", Func("MySoundSet"))
			this.m_Js.AddObject("SoundSetWaveVolume", Func("MySoundSetWaveVolume"))
			this.m_Js.AddObject("SplashImage", Func("MySplashImage"))
			this.m_Js.AddObject("SplashTextOff", Func("MySplashTextOff"))
			this.m_Js.AddObject("SplashTextOn", Func("MySplashTextOn"))
			this.m_Js.AddObject("SplitPath", Func("MySplitPath"))
			this.m_Js.AddObject("StatusBarGetText", Func("MyStatusBarGetText"))
			this.m_Js.AddObject("StatusBarWait", Func("MyStatusBarWait"))
			this.m_Js.AddObject("StringGetPos", Func("MyStringGetPos"))
			this.m_Js.AddObject("StringLeft", Func("MyStringLeft"))
			this.m_Js.AddObject("StringLen", Func("MyStringLen"))
			this.m_Js.AddObject("StringLower", Func("MyStringLower"))
			this.m_Js.AddObject("StringMid", Func("MyStringMid"))
			this.m_Js.AddObject("StringReplace", Func("MyStringReplace"))
			this.m_Js.AddObject("StringRight", Func("MyStringRight"))
			this.m_Js.AddObject("StringSplit", Func("MyStringSplit"))
			this.m_Js.AddObject("StringTrimLeft", Func("MyStringTrimLeft"))
			this.m_Js.AddObject("StringTrimRight", Func("MyStringTrimRight"))
			this.m_Js.AddObject("StringUpper", Func("MyStringUpper"))
			this.m_Js.AddObject("Suspend", Func("MySuspend"))
			this.m_Js.AddObject("SysGet", Func("MySysGet"))
			
			this.m_Js.AddObject("ToolTip", Func("MyToolTip"))
			this.m_Js.AddObject("Transform", Func("MyTransform"))
			this.m_Js.AddObject("TrayTip", Func("MyTrayTip"))
			
			
			this.m_Js.AddObject("WinActivate", Func("MyWinActivate"))
			this.m_Js.AddObject("WinActivateBottom", Func("MyWinActivateBottom"))
			this.m_Js.AddObject("WinClose", Func("MyWinClose"))
			this.m_Js.AddObject("WinGet", Func("MyWinGet"))
			this.m_Js.AddObject("WinGetActiveStats", Func("MyWinGetActiveStats"))
			this.m_Js.AddObject("WinGetActiveTitle", Func("MyWinGetActiveTitle"))
			this.m_Js.AddObject("WinGetClass", Func("MyWinGetClass"))
			this.m_Js.AddObject("WinGetPos", Func("MyWinGetPos"))
			this.m_Js.AddObject("WinGetText", Func("MyWinGetText"))
			this.m_Js.AddObject("WinGetTitle", Func("MyWinGetTitle"))
			this.m_Js.AddObject("WinHide", Func("MyWinHide"))
			this.m_Js.AddObject("WinKill", Func("MyWinKill"))
			this.m_Js.AddObject("WinMaximize", Func("MyWinMaximize"))
			this.m_Js.AddObject("WinMenuSelectItem", Func("MyWinMenuSelectItem"))
			this.m_Js.AddObject("WinMinimize", Func("MyWinMinimize"))
			this.m_Js.AddObject("WinMinimizeAll", Func("MyWinMinimizeAll"))
			this.m_Js.AddObject("WinMinimizeAllUndo", Func("MyWinMinimizeAllUndo"))
			this.m_Js.AddObject("WinMove", Func("MyWinMove"))
			this.m_Js.AddObject("WinRestore", Func("MyWinRestore"))
			this.m_Js.AddObject("WinSet", Func("MyWinSet"))
			this.m_Js.AddObject("WinSetTitle", Func("MyWinSetTitle"))
			this.m_Js.AddObject("WinShow", Func("MyWinShow"))
			this.m_Js.AddObject("WinWait", Func("MyWinWait"))
			this.m_Js.AddObject("WinWaitActive", Func("MyWinWaitActive"))
			this.m_Js.AddObject("WinWaitClose", Func("MyWinWaitClose"))
			this.m_Js.AddObject("WinWaitNotActive", Func("MyWinWaitNotActive"))
			
			this.m_Js.AddObject("SendLevel", Func("MySendLevel"))
			
			this.m_Js.AddObject("SetBuiltInVar", Func("SetBuiltInVar"))
			this.m_Js.AddObject("GetBuiltInVar", Func("GetBuiltInVar"))

		}
		catch e  ; Handles the first error/exception raised by the block above.
		{
            w := e.What
            m := e.Message
			ex := e.Extra
			Debug.WriteNL(e.What,Debug.ErrCodingInfo)
            Debug.WriteNL(e.Extra,Debug.ErrCodingInfo)
            Debug.WriteNL(e.Message,Debug.ErrCodingInfo)
			MsgBox, 262144, JScript Creation Exception, %w% %ex% %m%
			return
		}
    }
    Exec(Code)
    {
		
		try  ; Attempts to execute code.
		{
			this.m_Js.Exec(Code)
		}
		catch e  ; Handles the first error/exception raised by the block above.
		{
			Process:=EventManager.m_current_process_extra_data.GetItemText()
			ActionName:=EventManager.m_current_item_extra_data.GetItemText()
			if(!ActionName)
			{
				ActionName := Process
			}
			stack :=Debug.GetStack()
			m := e.Message
			decoded := DecodeActiveScriptMessage(m)
			Debug.WriteNL("",Debug.ErrCodingInfo)
			Debug.WriteNL("-------------",Debug.ErrCodingInfo)
			Debug.WriteNL("Active Script Exception",Debug.ErrCodingInfo)
			Debug.WriteNL("Process: " . Process, Debug.ErrCodingInfo)
			Debug.WriteNL("Action: " . ActionName, Debug.ErrCodingInfo)
			Debug.WriteNL("Error Code: " decoded["ErrorCode"],Debug.ErrCodingInfo)
			Debug.WriteNL("Source: " decoded["Source"],Debug.ErrCodingInfo)
			Debug.WriteNL("Description: " decoded["Description"],Debug.ErrCodingInfo)
			Debug.WriteNL("Line: " decoded["Line"],Debug.ErrCodingInfo)
			Debug.WriteNL("Column: " decoded["Column"],Debug.ErrCodingInfo)
			Debug.WriteNL("LineText: " decoded["LineText"],Debug.ErrCodingInfo)
			Debug.SetStack(5+(decoded["Column"])/2)
			Debug.WriteStack("^",Debug.ErrCodingInfo)
			Debug.SetStack(stack)

			Debug.WriteNL("-------------",Debug.ErrCodingInfo)
			Debug.WriteNL("",Debug.ErrCodingInfo)
			if(ProcessMonitor.IsWindowMine())
			{
				MsgBox, 262144, Active Script Exception, %m%
			}
			
		}
    }
	Eval(Code)
    {
		return ;useless
		try  ; Attempts to execute code.
		{
			this.m_Js.Eval(Code)
		}
		catch e  ; Handles the first error/exception raised by the block above.
		{
			Process:=EventManager.m_current_process_extra_data.GetItemText()
			ActionName:=EventManager.m_current_item_extra_data.GetItemText()
			if(!ActionName)
			{
				ActionName := Process
			}
			stack :=Debug.GetStack()
			m := e.Message
			decoded := DecodeActiveScriptMessage(m)
			Debug.WriteNL("",Debug.ErrCodingInfo)
			Debug.WriteNL("-------------",Debug.ErrCodingInfo)
			Debug.WriteNL("Active Script Exception",Debug.ErrCodingInfo)
			Debug.WriteNL("Process: " . Process, Debug.ErrCodingInfo)
			Debug.WriteNL("Action: " . ActionName, Debug.ErrCodingInfo)
			Debug.WriteNL("Error Code: " decoded["ErrorCode"],Debug.ErrCodingInfo)
			Debug.WriteNL("Source: " decoded["Source"],Debug.ErrCodingInfo)
			Debug.WriteNL("Description: " decoded["Description"],Debug.ErrCodingInfo)
			Debug.WriteNL("Line: " decoded["Line"],Debug.ErrCodingInfo)
			Debug.WriteNL("Column: " decoded["Column"],Debug.ErrCodingInfo)
			Debug.WriteNL("LineText: " decoded["LineText"],Debug.ErrCodingInfo)
			Debug.SetStack(5+(decoded["Column"])/2)
			Debug.WriteStack("^",Debug.ErrCodingInfo)
			Debug.SetStack(stack)

			Debug.WriteNL("-------------",Debug.ErrCodingInfo)
			Debug.WriteNL("",Debug.ErrCodingInfo)
			if(ProcessMonitor.IsWindowMine())
			{
				MsgBox, 262144, Active Script Exception, %m%
			}
		}
    }
}

DecodeActiveScriptMessage(Text)
{
	Arr := ["","","","","",""]
	arrat :=1
	pos := InStr(Text,"0x")
	ln := StrLen(Text)
	;Debug.MsgBox("LENGTH: " . ln)
	loop, %ln%
	{
		c := SubStr(Text, pos ,1)
		a := asc(c)
		if(a==9)
		{
			Arr[arrat] := ""
			
		}
		else if(a==10)
		{
			arrat++
		}
		else
		{
			Arr[arrat] := Arr[arrat] . c
		}
		pos++
		
	}
	return {ErrorCode: Arr[1], Source: Arr[2], Description: Arr[3], Line: Arr[4], Column: Arr[5], LineText:  Arr[6]}
	
}



