TimerExists(label)
{
	jsRunner := Interpreter
	if(EventManager.m_current_process_extra_data)
	{
		jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
	}
	;tmr := SetTimer, EventManager_OnTimer, %gUpdateTimer%.m_Timers[label]
	tmr := jsRunner.m_Timers[label]
	if(tmr)
	{
		return 1
	}
	return 0
}
TimerClearAll()
{
	jsRunner := Interpreter
	if(EventManager.m_current_process_extra_data)
	{
		jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
	}
	jsRunner.m_Timers := []
	jsRunner.m_TimerAt := 0
}
TimerTimeLeft(label)
{
	jsRunner := Interpreter
	if(EventManager.m_current_process_extra_data)
	{
		jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
	}
	tmr := jsRunner.m_Timers[label]
	if(tmr)
	{
		if(tmr[1])
		{
			t:=Max(0, tmr[3] - jsRunner.m_TimerAt)
			;Debug.WriteNL(t . "," . tmr[1]  . "," . tmr[2]  . "," . tmr[3] )
			return t+0
		}
	}
	return 0
}
MySetTimer(Label,Period)
{
	if(Label="")
	{
		return
	}
	;SetTimer [, Label, Period|On|Off|Delete, Priority]
	jsRunner := Interpreter
	if(EventManager.m_current_process_extra_data)
	{
		jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
	}
	if(Period = "On")
	{
		old = jsRunner.m_Timers[label]
		if(old)
		{
			old[1] := 1
		}
	}
	else if (Period = "Off")
	{
		old := jsRunner.m_Timers[label]
		if(old)
		{
			old[1] := 0
			;Debug.MsgBox("Turning Off " . old[1])
			
		}
	}
	else if (Period = "Delete")
	{
		
		NewArray := []
		;MyOutputDebugAlways("MySetTimer Delete Request") 
		for index, element in jsRunner.m_Timers ; Enumeration is the recommended approach in most cases.
		{
			; Using "Loop", indices must be consecutive numbers from 1 to the number
			; of elements in the array (or they must be calculated within the loop).
			; MsgBox % "Element number " . A_Index . " is " . Array[A_Index]

			; Using "for", both the index (or "key") and its associated value
			; are provided, and the index can be *any* value of your choosing.
			
			;MyOutputDebugAlways("Element number " . index) ; . " is " . element)
			if(index == label)
			{
				;MyOutputDebugAlways("Deleting Element number " . index)
			}
			else
			{
				;NewArray.push(element) ;nope , dont work
				;MyOutputDebugAlways("Keeping Element number " . index . " " . element[1] . " " . element[2] . " " . element[3])
				NewArray["" . index] := [element[1], element[2], element[3]]
			}
		}
		jsRunner.m_Timers := NewArray

		/*
		old := jsRunner.m_Timers[label]
		if(old)
		{
			old[1] := 0
		}
		*/
	}
	else
	{
		t := jsRunner.m_TimerAt + Abs(Period)
		jsRunner.m_Timers[label] := [1,Period,t]
	}
}
MySend(Keys:="")
{
	if(ProcessMonitor.IsWindowMine())
	{
		Debug.Show()
	}
	Send, %Keys%
}

MySendMessageGet(Msg, wParam:="",lParam:="",Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="", Timeout:=5000)
{

	wParam := 0
	lParam := 0
	global rwParam :=wParam
	global rlParam :=lParam

	SendMessage, %Msg% , &rwParam, &rlParam, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%, %Timeout%

	return {wParam: &rwParam, lParam: &rlParam}
}
MySendMessageSet(Msg, wParam:="",lParam:="",Control:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="", Timeout:=5000)
{
	SendMessage, %Msg% , %wParam%, %lParam%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%, %Timeout%
}

MySleep(DelayInMilliseconds:="")
{
	Sleep, %DelayInMilliseconds%
}
KeyWaitAll()
{
	done := False
	while(!done)
	{
		done := True
		for each, item in KeyCodeMap
		{
			if(GetKeyState(item , "P"))
			{
				done := False
			}
		}
	} 
}
MyBlockInputEnds()
{
	SetTimer, MyBlockInputEnds, Off
	BlockInput OFF
}
MyBlockInput(Mode:="")
{
	if(A_IsAdmin)
	{
		if(Mode = "OFF")
		{
			BlockInput OFF
			SetTimer, MyBlockInputEnds, Off
		}
		else
		{
			BlockInput, %Mode%
			SetTimer, MyBlockInputEnds, -10000
			
		}
		
	}
	else 
	{
		KeyWaitAll()
	}
}
MyClick(a:="", b:="", c:="")
{
	Click, %a%, %b%, %c%
}
MyClipWait(a:="",b:="")
{
	ClipWait, %a%, %b%
}
MyControl(Cmd:="", Value:="", ctrl:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
	if(Cmd = "Check")
		Control,Check, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Uncheck")
		Control,Uncheck, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Enable")
		Control,Enable, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Disable")
		Control,Disable, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Show")
		Control,Show, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Hide")
		Control,Hide, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%

	if(Cmd = "Style")
		Control,Style, %Value%, %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%

	if(Cmd = "ExStyle")
		Control,ExStyle, %Value%, %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	
	if(Cmd = "ShowDropDown")
		Control,ShowDropDown, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "HideDropDown")
		Control,HideDropDown, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "TabLeft")
		Control,TabLeft, %Value%, %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%

	if(Cmd = "Add")
		Control,Add, %Value%, %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Delete")
		Control,Delete, %Value%, %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Choose")
		Control,Choose, %Value%, %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "ChooseString")
		Control,ChooseString, %Value%, %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "EditPaste")
		Control,EditPaste, %Value%, %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%

}

MyControlClick(ControlorPos:="", WinTitle:="", WinText:="", WhichButton:="", ClickCount:="", Options:="", ExcludeTitle:="", ExcludeText:="")
{
	ControlClick, %ControlorPos%, %WinTitle%, %WinText%, %WhichButton%, %ClickCount%, %Options%, %ExcludeTitle%, %ExcludeText%
}
MyControlFocus(Ctrl:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
	ControlFocus, %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
MyControlGet(Cmd:="", Value:="", Ctrl:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
	if(Cmd = "List")
		ControlGet, OutputVar, List, %Value%, %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Checked")
		ControlGet, OutputVar, Checked, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Enabled")
		ControlGet, OutputVar, Enabled, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Visible")
		ControlGet, OutputVar, Visible, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Tab")
		ControlGet, OutputVar, Tab, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "FindString")
		ControlGet, OutputVar, FindString, %Value%, %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Choice")
		ControlGet, OutputVar, Choice, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "LineCount")
		ControlGet, OutputVar, LineCount, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "CurrentLine")
		ControlGet, OutputVar, CurrentLine, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "CurrentCol")
		ControlGet, OutputVar, CurrentCol, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Line")
		ControlGet, OutputVar, Line, %Value%, %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Selected")
		ControlGet, OutputVar, Selected, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Style")
		ControlGet, OutputVar, Style, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "ExStyle")
		ControlGet, OutputVar, ExStyle, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	if(Cmd = "Hwnd")
		ControlGet, OutputVar, Hwnd, , %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	return OutputVar
}
MyControlGetFocus(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
	ControlGetFocus, OutputVar , %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	return OutputVar
}
MyControlGetPos(Ctrl:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
	ControlGetPos, X, Y, Width, Height, %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	return {X: X, Y: Y, Width: Width, Height: Height}
}
MyControlGetText(Ctrl:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
	ControlGetText, OutputVar, %Ctrl%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	return OutputVar
}
MyControlMove(Ctrl:="", X:="", Y:="", Width:="", Height:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
	ControlMove, %Ctrl%, %X%, %Y%, %Width%, %Height%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
MyControlSend( Ctrl:="", Keys:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
	ControlSend, %Ctrl%, %Keys%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
MyControlSendRaw(Ctrl:="", Keys:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
	ControlSendRaw, %Ctrl%, %Keys%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
MyControlSetText(Ctrl:="", NewText:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
	ControlSetText, %Ctrl%, %NewText%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
MyCoordMode(a:="",b:="")
{
	CoordMode, %a%, %b%
}
MyCritical(a:="")
{
	Critical, %a%
}
MyDetectHiddenText(a:="")
{
	DetectHiddenText, %a%
}
MyDetectHiddenWindows(a:="")
{
	DetectHiddenWindows, %a%
}
MyFormatTime(a:="",b:="")
{
	FormatTime, OutputVar , %a%, %b%
	return OutputVar
}

MyGroupActivate(a:="",b:="")
{
	GroupActivate, %a%, %b%
}
MyGroupAdd(GroupName:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
{
	GroupAdd, %GroupName%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
MyGroupClose(a:="",b:="")
{
	GroupClose, %a%, %b%
}
MyGroupDeactivate(a:="",b:="")
{
	GroupDeactivate, %a%, %b%
}
MyGui(a:="",b:="",c:="",d:="")
{
	Gui, %a%, %b%, %c%, %d%
}
MyGuiControl(a:="",b:="",c:="")
{
	GuiControl, %a%, %b%, %c%
}
MyGuiControlGet(a:="",b:="",c:="")
{
	GuiControlGet, OutputVar, %a%, %b%, %c%
	return OutputVar
}
MyHotkey(a:="",b:="",c:="")
{
	Hotkey, %a%, %b%, %c%
}
MyImageSearch(a:="",b:="",c:="",d:="",e:="")
{
	ImageSearch, OutputVarX, OutputVarY, %a%, %b%, %c%, %d%, %e%
	return {OutputVarX:OutputVarX, OutputVarY:OutputVarY}
}
MyIniDelete(Section:="", Key:="")
{
	Filename := A_MyDocuments . "\HotKeySpeak\SaveFolder\SharedIni.ini"
	IniDelete, %Filename%, %Section%, %Key%
}
MyIniRead(Section:="", Key:="" , Default:="")
{
	Filename := A_MyDocuments . "\HotKeySpeak\SaveFolder\SharedIni.ini"
	IniRead, OutputVar, %Filename%, %Section%, %Key%, %Default%
	return OutputVar
}
MyIniWrite(Section:="", Key:="", value:="")
{
	Filename := A_MyDocuments . "\HotKeySpeak\SaveFolder\SharedIni.ini"
	IniWrite, %value%, %Filename%, %Section%, %Key%
}

GetBuiltInVar(VarName)
{
	If(VarName = "A_Space") 
		return A_Space
	Else If(VarName = "A_Tab") 
		return A_Tab
	Else If(VarName = "A_Args") 
		return A_Args
	Else If(VarName = "A_WorkingDir") 
		return A_WorkingDir
	Else If(VarName = "A_ScriptDir") 
		return A_ScriptDir
	Else If(VarName = "A_ScriptName")
		return A_ScriptName
	Else If(VarName = "A_ScriptFullPath")
		return A_ScriptFullPath
	Else If(VarName = "A_ScriptHwnd")
		return A_ScriptHwnd
	Else If(VarName = "A_LineNumber")
		return A_LineNumber
	Else If(VarName = "A_LineFile")
		return A_LineFile
	Else If(VarName = "A_ThisFunc")
		return A_ThisFunc
	Else If(VarName = "A_ThisLabel")
		return A_ThisLabel
	Else If(VarName = "A_AhkVersion")
		return A_AhkVersion
	Else If(VarName = "A_AhkPath")
		return A_AhkPath
	Else If(VarName = "A_IsUnicode")
		return A_IsUnicode
	Else If(VarName = "A_IsCompiled")
		return A_IsCompiled
	Else If(VarName = "A_ExitReason")
		return A_ExitReason
	Else If(VarName = "A_YYYY")
		return A_YYYY
	Else If(VarName = "A_MM")
		return A_MM
	Else If(VarName = "A_DD")
		return A_DD
	Else If(VarName = "A_MMMM")
		return A_MMMM
	Else If(VarName = "A_MMM")
		return A_MMM
	Else If(VarName = "A_DDDD")
		return A_DDDD
	Else If(VarName = "A_DDD")
		return A_DDD
	Else If(VarName = "A_WDay")
		return A_WDay
	Else If(VarName = "A_YDay")
		return A_YDay
	Else If(VarName = "A_YWeek")
		return A_YWeek
	Else If(VarName = "A_Hour")
		return A_Hour
	Else If(VarName = "A_Min")
		return A_Min
	Else If(VarName = "A_Sec")
		return A_Sec
	Else If(VarName = "A_MSec")
		return A_MSec
	Else If(VarName = "A_Now")
		return A_Now
	Else If(VarName = "A_NowUTC")
		return A_NowUTC
	Else If(VarName = "A_TickCount")
		return A_TickCount
	Else If(VarName = "A_IsSuspended")
		return A_IsSuspended
	Else If(VarName = "A_IsPaused")
		return A_IsPaused
	Else If(VarName = "A_IsCritical")
		return A_IsCritical
	Else If(VarName = "A_BatchLines")
		return A_BatchLines
	Else If(VarName = "A_TitleMatchMode")
		return A_TitleMatchMode
	Else If(VarName = "A_TitleMatchModeSpeed")
		return A_TitleMatchModeSpeed
	Else If(VarName = "A_DetectHiddenWindows")
		return A_DetectHiddenWindows
	Else If(VarName = "A_DetectHiddenText")
		return A_DetectHiddenText
	Else If(VarName = "A_AutoTrim")
		return A_AutoTrim
	Else If(VarName = "A_StringCaseSense")
		return A_StringCaseSense
	Else If(VarName = "A_FileEncoding")
		return A_FileEncoding
	Else If(VarName = "A_FormatInteger")
		return A_FormatInteger
	Else If(VarName = "A_FormatFloat")
		return A_FormatFloat
	Else If(VarName = "A_SendMode")
		return A_SendMode
	Else If(VarName = "A_SendLevel")
		return A_SendLevel
	Else If(VarName = "A_StoreCapslockMode")
		return A_StoreCapslockMode
	Else If(VarName = "A_KeyDelay")
		return A_KeyDelay
	Else If(VarName = "A_KeyDuration")
		return A_KeyDuration
	Else If(VarName = "A_KeyDelayPlay")
		return A_KeyDelayPlay
	Else If(VarName = "A_KeyDurationPlay")
		return A_KeyDurationPlay
	Else If(VarName = "A_WinDelay")
		return A_WinDelay
	Else If(VarName = "A_ControlDelay")
		return A_ControlDelay
	Else If(VarName = "A_MouseDelay")
		return A_MouseDelay
	Else If(VarName = "A_MouseDelayPlay")
		return A_MouseDelayPlay
	Else If(VarName = "A_DefaultMouseSpeed")
		return A_DefaultMouseSpeed
	Else If(VarName = "A_CoordModeToolTip")
		return A_CoordModeToolTip
	Else If(VarName = "A_CoordModePixel")
		return A_CoordModePixel
	Else If(VarName = "A_CoordModeMouse")
		return A_CoordModeMouse
	Else If(VarName = "A_CoordModeCaret")
		return A_CoordModeCaret
	Else If(VarName = "A_CoordModeMenu")
		return A_CoordModeMenu
	Else If(VarName = "A_RegView")
		return A_RegView
	Else If(VarName = "A_IconHidden")
		return A_IconHidden
	Else If(VarName = "A_IconTip")
		return A_IconTip
	Else If(VarName = "A_IconFile")
		return A_IconFile
	Else If(VarName = "A_IconNumber")
		return A_IconNumber
	Else If(VarName = "A_TimeIdle")
		return A_TimeIdle
	Else If(VarName = "A_TimeIdlePhysical")
		return A_TimeIdlePhysical
	Else If(VarName = "A_DefaultGui")
		return A_DefaultGui
	Else If(VarName = "A_DefaultListView")
		return A_DefaultListView
	Else If(VarName = "A_DefaultTreeView")
		return A_DefaultTreeView
	Else If(VarName = "A_Gui")
		return A_Gui
	Else If(VarName = "A_GuiControl")
		return A_GuiControl
	Else If(VarName = "A_GuiWidth")
		return A_GuiWidth
	Else If(VarName = "A_GuiHeight")
		return A_GuiHeight
	Else If(VarName = "A_GuiX")
		return A_GuiX
	Else If(VarName = "A_GuiY")
		return A_GuiY
	Else If(VarName = "A_GuiEvent")
		return A_GuiEvent
	Else If(VarName = "A_GuiControlEvent")
		return A_GuiControlEvent	
	Else If(VarName = "A_EventInfo")
		return A_EventInfo	
	Else If(VarName = "A_ThisHotkey")
		return A_ThisHotkey
	Else If(VarName = "A_ThisMenuItem")
		return A_ThisMenuItem
	Else If(VarName = "A_ThisMenu")
		return A_ThisMenu
	Else If(VarName = "A_ThisMenuItemPos")
		return A_ThisMenuItemPos
	Else If(VarName = "A_ThisHotkey")
		return A_ThisHotkey	
	Else If(VarName = "A_ThisLabel")
		return A_ThisLabel
	Else If(VarName = "A_PriorHotkey")
		return A_PriorHotkey
	Else If(VarName = "A_PriorKey")
		return A_PriorKey
	Else If(VarName = "A_TimeSinceThisHotkey")
		return A_TimeSinceThisHotkey
	Else If(VarName = "A_TimeSincePriorHotkey")
		return A_TimeSincePriorHotkey
	Else If(VarName = "A_EndChar")
		return A_EndChar
	Else If(VarName = "ComSpec")
		return ComSpec
	Else If(VarName = "A_Temp")
		return A_Temp
	Else If(VarName = "A_OSType")
		return A_OSType
	Else If(VarName = "A_OSVersion")
		return A_OSVersion
	Else If(VarName = "A_Is64bitOS")
		return A_Is64bitOS
	Else If(VarName = "A_PtrSize")
		return A_PtrSize
	Else If(VarName = "A_Language")
		return A_Language
	Else If(VarName = "A_ComputerName")
		return A_ComputerName
	Else If(VarName = "A_UserName")
		return A_UserName
	Else If(VarName = "A_WinDir")
		return A_WinDir
	Else If(VarName = "A_ProgramFiles")
		return A_ProgramFiles
	Else If(VarName = "ProgramFiles")
		return ProgramFiles	
	Else If(VarName = "A_AppData")
		return A_AppData
	Else If(VarName = "A_AppDataCommon")
		return A_AppDataCommon
	Else If(VarName = "A_Desktop")
		return A_Desktop
	Else If(VarName = "A_DesktopCommon")
		return A_DesktopCommon
	Else If(VarName = "A_StartMenu")
		return A_StartMenu
	Else If(VarName = "A_StartMenuCommon")
		return A_StartMenuCommon
	Else If(VarName = "A_Programs")
		return A_Programs
	Else If(VarName = "A_ProgramsCommon")
		return A_ProgramsCommon
	Else If(VarName = "A_Startup")
		return A_Startup
	Else If(VarName = "A_StartupCommon")
		return A_StartupCommon
	Else If(VarName = "A_MyDocuments")
		return A_MyDocuments
	Else If(VarName = "A_IsAdmin")
		return A_IsAdmin	
	Else If(VarName = "A_ScreenWidth")
		return A_ScreenWidth
	Else If(VarName = "A_ScreenHeight")
		return A_ScreenHeight
	Else If(VarName = "A_ScreenDPI")
		return A_ScreenDPI
	Else If(VarName = "A_IPAddress1")
		return A_IPAddress1
	Else If(VarName = "A_Cursor")
		return A_Cursor	
	Else If(VarName = "A_CaretX")
		return A_CaretX
	Else If(VarName = "A_CaretY")
		return A_CaretY
	Else If(VarName = "A_CaretX")
		return A_CaretX
	Else If(VarName = "A_CaretY")
		return A_CaretY
	Else If(VarName = "Clipboard")
		return Clipboard
	Else If(VarName = "ClipboardAll")
		return ClipboardAll
	Else If(VarName = "ErrorLevel")
		return ErrorLevel
	Else If(VarName = "A_LastError")
		return A_LastError
	Else If(VarName = "A_Index")
		return A_Index
	Else If(VarName = "A_LoopFileName")
		return A_LoopFileName
	Else If(VarName = "A_LoopRegName")
		return A_LoopRegName
	Else If(VarName = "A_LoopReadLine")
		return A_LoopReadLine
	Else If(VarName = "A_LoopField")
		return A_LoopField
}
SetBuiltInVar(VarName, Value)
{
	t = 0 ;t=t was is used to comment out vars not settable
	If(VarName = "A_Space") 
		t=t ;A_Space = %Value%
	Else If(VarName = "A_Tab") 
		t=t ;A_Tab = %Value%
	Else If(VarName = "A_Args") 
		A_Args = %Value%
	Else If(VarName = "A_WorkingDir") 
		t=t ;A_WorkingDir = %Value%
	Else If(VarName = "A_ScriptDir") 
		t=t ;A_ScriptDir = %Value%
	Else If(VarName = "A_ScriptName")
		t=t ;A_ScriptName = %Value%
	Else If(VarName = "A_ScriptFullPath")
		t=t ;A_ScriptFullPath = %Value%
	Else If(VarName = "A_ScriptHwnd")
		t=t ;A_ScriptHwnd = %Value%
	Else If(VarName = "A_LineNumber")
		t=t ;A_LineNumber = %Value%
	Else If(VarName = "A_LineFile")
		t=t ;A_LineFile = %Value%
	Else If(VarName = "A_ThisFunc")
		t=t ;A_ThisFunc = %Value%
	Else If(VarName = "A_ThisLabel")
		t=t ;A_ThisLabel = %Value%
	Else If(VarName = "A_AhkVersion")
		t=t ;A_AhkVersion = %Value%
	Else If(VarName = "A_AhkPath")
		t=t ;A_AhkPath = %Value%
	Else If(VarName = "A_IsUnicode")
		t=t ;A_IsUnicode = %Value%
	Else If(VarName = "A_IsCompiled")
		t=t ;A_IsCompiled = %Value%
	Else If(VarName = "A_ExitReason")
		t=t ;A_ExitReason = %Value%
	Else If(VarName = "A_YYYY")
		t=t ;A_YYYY = %Value%
	Else If(VarName = "A_MM")
		t=t ;A_MM = %Value%
	Else If(VarName = "A_DD")
		t=t ;A_DD = %Value%
	Else If(VarName = "A_MMMM")
		t=t ;A_MMMM = %Value%
	Else If(VarName = "A_MMM")
		t=t ;A_MMM = %Value%
	Else If(VarName = "A_DDDD")
		t=t ;A_DDDD = %Value%
	Else If(VarName = "A_DDD")
		t=t ;A_DDD = %Value%
	Else If(VarName = "A_WDay")
		t=t ;A_WDay = %Value%
	Else If(VarName = "A_YDay")
		t=t ;A_YDay = %Value%
	Else If(VarName = "A_YWeek")
		t=t ;A_YWeek = %Value%
	Else If(VarName = "A_Hour")
		t=t ;A_Hour = %Value%
	Else If(VarName = "A_Min")
		t=t ;A_Min = %Value%
	Else If(VarName = "A_Sec")
		t=t ;A_Sec = %Value%
	Else If(VarName = "A_MSec")
		t=t ;A_MSec = %Value%
	Else If(VarName = "A_Now")
		t=t ;A_Now = %Value%
	Else If(VarName = "A_NowUTC")
		t=t ;A_NowUTC = %Value%
	Else If(VarName = "A_TickCount")
		t=t ;A_TickCount = %Value%
	Else If(VarName = "A_IsSuspended")
		t=t ;A_IsSuspended = %Value%
	Else If(VarName = "A_IsPaused")
		t=t ;A_IsPaused = %Value%
	Else If(VarName = "A_IsCritical")
		t=t ;A_IsCritical = %Value%
	Else If(VarName = "A_BatchLines")
		t=t ;A_BatchLines = %Value%
	Else If(VarName = "A_TitleMatchMode")
		t=t ;A_TitleMatchMode = %Value%
	Else If(VarName = "A_TitleMatchModeSpeed")
		t=t ;A_TitleMatchModeSpeed = %Value%
	Else If(VarName = "A_DetectHiddenWindows")
		t=t ;A_DetectHiddenWindows = %Value%
	Else If(VarName = "A_DetectHiddenText")
		t=t ;A_DetectHiddenText = %Value%
	Else If(VarName = "A_AutoTrim")
		t=t ;A_AutoTrim = %Value%
	Else If(VarName = "A_StringCaseSense")
		t=t ;A_StringCaseSense = %Value%
	Else If(VarName = "A_FileEncoding")
		t=t ;A_FileEncoding = %Value%
	Else If(VarName = "A_FormatInteger")
		t=t ;A_FormatInteger = %Value%
	Else If(VarName = "A_FormatFloat")
		t=t ;A_FormatFloat = %Value%
	Else If(VarName = "A_SendMode")
		t=t ;A_SendMode = %Value%
	Else If(VarName = "A_SendLevel")
		t=t ;A_SendLevel = %Value%
	Else If(VarName = "A_StoreCapslockMode")
		t=t ;A_StoreCapslockMode = %Value%
	Else If(VarName = "A_KeyDelay")
		t=t ;A_KeyDelay = %Value%
	Else If(VarName = "A_KeyDuration")
		t=t  ;A_KeyDuration = %Value%
	Else If(VarName = "A_KeyDelayPlay")
		t=t  ;A_KeyDelayPlay = %Value%
	Else If(VarName = "A_KeyDurationPlay")
		t=t  ;A_KeyDurationPlay = %Value%
	Else If(VarName = "A_WinDelay")
		t=t  ;A_WinDelay = %Value%
	Else If(VarName = "A_ControlDelay")
		t=t  ;A_ControlDelay = %Value%
	Else If(VarName = "A_MouseDelay")
		t=t  ;A_MouseDelay = %Value%
	Else If(VarName = "A_MouseDelayPlay")
		t=t  ;A_MouseDelayPlay = %Value%
	Else If(VarName = "A_DefaultMouseSpeed")
		t=t  ;A_DefaultMouseSpeed = %Value%
	Else If(VarName = "A_CoordModeToolTip")
		t=t  ;A_CoordModeToolTip = %Value%
	Else If(VarName = "A_CoordModePixel")
		t=t  ;A_CoordModePixel = %Value%
	Else If(VarName = "A_CoordModeMouse")
		t=t  ;A_CoordModeMouse = %Value%
	Else If(VarName = "A_CoordModeCaret")
		t=t  ;A_CoordModeCaret = %Value%
	Else If(VarName = "A_CoordModeMenu")
		t=t  ;A_CoordModeMenu = %Value%
	Else If(VarName = "A_RegView")
		t=t  ;A_RegView = %Value%
	Else If(VarName = "A_IconHidden")
		t=t  ;A_IconHidden = %Value%
	Else If(VarName = "A_IconTip")
		t=t  ;A_IconTip = %Value%
	Else If(VarName = "A_IconFile")
		t=t  ;A_IconFile = %Value%
	Else If(VarName = "A_IconNumber")
		t=t  ;A_IconNumber = %Value%
	Else If(VarName = "A_TimeIdle")
		t=t  ;A_TimeIdle = %Value%
	Else If(VarName = "A_TimeIdlePhysical")
		t=t  ;A_TimeIdlePhysical = %Value%
	Else If(VarName = "A_DefaultGui")
		t=t  ;A_DefaultGui = %Value%
	Else If(VarName = "A_DefaultListView")
		t=t  ;A_DefaultListView = %Value%
	Else If(VarName = "A_DefaultTreeView")
		t=t  ;A_DefaultTreeView = %Value%
	Else If(VarName = "A_Gui")
		t=t  ;A_Gui = %Value%
	Else If(VarName = "A_GuiControl")
		t=t  ;A_GuiControl = %Value%
	Else If(VarName = "A_GuiWidth")
		t=t  ;A_GuiWidth = %Value%
	Else If(VarName = "A_GuiHeight")
		t=t  ;A_GuiHeight = %Value%
	Else If(VarName = "A_GuiX")
		t=t  ;A_GuiX = %Value%
	Else If(VarName = "A_GuiY")
		t=t  ;A_GuiY = %Value%
	Else If(VarName = "A_GuiEvent")
		t=t  ;A_GuiEvent = %Value%
	Else If(VarName = "A_GuiControlEvent")
		t=t  ;A_GuiControlEvent	 = %Value%
	Else If(VarName = "A_EventInfo")
		t=t  ;A_EventInfo	 = %Value%
	Else If(VarName = "A_ThisHotkey")
		t=t  ;A_ThisHotkey = %Value%
	Else If(VarName = "A_ThisMenuItem")
		t=t  ;A_ThisMenuItem = %Value%
	Else If(VarName = "A_ThisMenu")
		t=t  ;A_ThisMenu = %Value%
	Else If(VarName = "A_ThisMenuItemPos")
		t=t  ;A_ThisMenuItemPos = %Value%
	Else If(VarName = "A_ThisHotkey")
		t=t  ;A_ThisHotkey	 = %Value%
	Else If(VarName = "A_ThisLabel")
		t=t  ;A_ThisLabel = %Value%
	Else If(VarName = "A_PriorHotkey")
		t=t  ;A_PriorHotkey = %Value%
	Else If(VarName = "A_PriorKey")
		t=t  ;A_PriorKey = %Value%
	Else If(VarName = "A_TimeSinceThisHotkey")
		t=t  ;A_TimeSinceThisHotkey = %Value%
	Else If(VarName = "A_TimeSincePriorHotkey")
		t=t  ;A_TimeSincePriorHotkey = %Value%
	Else If(VarName = "A_EndChar")
		t=t  ;A_EndChar = %Value%
	Else If(VarName = "ComSpec")
		t=t  ;ComSpec = %Value%
	Else If(VarName = "A_Temp")
		t=t  ;A_Temp = %Value%
	Else If(VarName = "A_OSType")
		t=t  ;A_OSType = %Value%
	Else If(VarName = "A_OSVersion")
		 t=t  ;A_OSVersion = %Value%
	Else If(VarName = "A_Is64bitOS")
		t=t  ;A_Is64bitOS = %Value%
	Else If(VarName = "A_PtrSize")
		t=t  ;A_PtrSize = %Value%
	Else If(VarName = "A_Language")
		t=t  ;A_Language = %Value%
	Else If(VarName = "A_ComputerName")
		t=t  ;A_ComputerName = %Value%
	Else If(VarName = "A_UserName")
		t=t  ;A_UserName = %Value%
	Else If(VarName = "A_WinDir")
		t=t  ;A_WinDir = %Value%
	Else If(VarName = "A_ProgramFiles")
		t=t  ;A_ProgramFiles = %Value%
	Else If(VarName = "ProgramFiles")
		t=t  ;ProgramFiles	 = %Value%
	Else If(VarName = "A_AppData")
		t=t  ;A_AppData = %Value%
	Else If(VarName = "A_AppDataCommon")
		t=t  ;A_AppDataCommon = %Value%
	Else If(VarName = "A_Desktop")
		t=t  ;A_Desktop = %Value%
	Else If(VarName = "A_DesktopCommon")
		t=t  ;A_DesktopCommon = %Value%
	Else If(VarName = "A_StartMenu")
		t=t  ;A_StartMenu = %Value%
	Else If(VarName = "A_StartMenuCommon")
		t=t  ;A_StartMenuCommon = %Value%
	Else If(VarName = "A_Programs")
		t=t  ;A_Programs = %Value%
	Else If(VarName = "A_ProgramsCommon")
		t=t  ;A_ProgramsCommon = %Value%
	Else If(VarName = "A_Startup")
		t=t  ;A_Startup = %Value%
	Else If(VarName = "A_StartupCommon")
		t=t  ;A_StartupCommon = %Value%
	Else If(VarName = "A_MyDocuments")
		t=t  ;A_MyDocuments = %Value%
	Else If(VarName = "A_IsAdmin")
		t=t  ;A_IsAdmin	 = %Value%
	Else If(VarName = "A_ScreenWidth")
		t=t  ;A_ScreenWidth = %Value%
	Else If(VarName = "A_ScreenHeight")
		t=t  ;A_ScreenHeight = %Value%
	Else If(VarName = "A_ScreenDPI")
		t=t  ;A_ScreenDPI = %Value%
	Else If(VarName = "A_IPAddress1")
		t=t  ;A_IPAddress1 = %Value%
	Else If(VarName = "A_Cursor")
		t=t  ;A_Cursor = %Value%
	Else If(VarName = "A_CaretX")
		t=t  ;A_CaretX = %Value%
	Else If(VarName = "A_CaretY")
		t=t  ;A_CaretY = %Value%
	Else If(VarName = "A_CaretX")
		t=t  ;A_CaretX = %Value%
	Else If(VarName = "A_CaretY")
		t=t  ;A_CaretY = %Value%
	Else If(VarName = "Clipboard")
		Clipboard = %Value%
	Else If(VarName = "ClipboardAll")
		t=t  ;ClipboardAll = %Value%
	Else If(VarName = "ErrorLevel")
		ErrorLevel = %Value%
	Else If(VarName = "A_LastError")
		t=t  ;A_LastError = %Value%
	Else If(VarName = "A_Index")
		 t=t  ;A_Index = %Value%
	Else If(VarName = "A_LoopFileName")
		t=t  ;A_LoopFileName = %Value%
	Else If(VarName = "A_LoopRegName")
		t=t  ;A_LoopRegName = %Value%
	Else If(VarName = "A_LoopReadLine")
		t=t  ;A_LoopReadLine = %Value%
	Else If(VarName = "A_LoopField")
		t=t  ;A_LoopField = %Value%
}
MyErrorLevel(t)
{
	r := t
	return GetBuiltInVar(t)
	;return ErrorLevel
}
MyInputBox(a:="",b:="",c:="",d:="",e:="",f:="",g:="",h:="",i:="",j:="")
{
	InputBox, OutputVar, %a%, %b%, %c%, %d%, %e%, %f%, %g%, , %i%, %j%
	return OutputVar
}

MyKeyWait(a:="",b:="")
{
	KeyWait, %a%, %b%
}
MyMenu(a:="",b:="",c:="",d:="",e:="")
{
	Menu, %a%, %b%, %c%, %d%, %e%
}
MyMouseClick(a:="",b:="",c:="",d:="",e:="",f:="",g:="")
{
	MouseClick, %a%, %b%, %c%, %d%, %e%, %f%, %g%
}
MyMouseClickDrag(a:="",b:="",c:="",d:="",e:="",f:="",g:="")
{
	MouseClickDrag, %a%, %b%, %c%, %d%, %e%, %f%, %g%
}
MyMouseGetPos(a:="")
{
	MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl, %a%
	return {OutputVarX: OutputVarX, OutputVarY: OutputVarY, OutputVarWin: OutputVarWin, OutputVarControl: OutputVarControl}
}
MyMouseMove(a:="",b:="",c:="",d:="")
{
	MouseMove, %a%, %b%, %c%, %d%
}
MyMsgBox(a:="",b:="",c:="",d:="")
{
	MsgBox, %a%, %b%, %c%, %d%
}

MyOutputDebugAlways(Text:="")
{
	Debug.WriteNL(Text, 1000)
	
}

MyOutputDebug(Text:="")
{
	Debug.WriteNL(Text,4) 
}

MyPixelGetColor(a:="",b:="",c:="")
{
	PixelGetColor, OutputVar, %a%, %b%, %c%
	return OutputVar
}
MyPixelSearch(a:="",b:="",c:="",d:="",e:="",f:="",g:="")
{
	PixelSearch, OutputVarX, OutputVarY, %a%, %b%, %c%, %d%, %e%, %f%, %g%
	return { OutputVarX: OutputVarX, OutputVarY: OutputVarY}
}
MyPostMessage(a:="",b:="",c:="",d:="",e:="",f:="",g:="",h:="")
{
	PostMessage, %a%, %b%, %c%, %d%, %e%, %f%, %g%, %h%
}
MyProcess(a:="",b:="",c:="")
{
	Process, %a%, %b%, %c%
}
MyProgress(a:="",b:="",c:="",d:="",e:="")
{
	Progress, %a%, %b%, %c%, %d%, %e%
}
MyRandom(a:="",b:="")
{
	Random, OutputVar, %a%, %b%
	return OutputVar 
}

MyRegRead(a:="",b:="",c:="")
{
	RegRead, OutputVar, %a%, %b%, %c%
	return OutputVar
}


MyRun(a:="",b:="",c:="")
{
	Run, %a%, %b%, %c%, OutputVarPID
	return OutputVarPID
}


MyRunWait(a:="",b:="",c:="")
{
	RunWait, %a%, %b%, %c%, OutputVarPID
	return OutputVarPID
}

MySendEvent(a:="")
{
	if(ProcessMonitor.IsWindowMine())
	{
		Debug.Show()
	}
	SendEvent, %a%
}
MySendInput(a:="")
{
	if(ProcessMonitor.IsWindowMine())
	{
		Debug.Show()
	}
	SendInput, %a%
}

MySendMode(a:="")
{
	SendMode, %a%
}
MySendPlay(a:="")
{
	if(ProcessMonitor.IsWindowMine())
	{
		Debug.Show()
	}
	SendPlay, %a%
}
MySendRaw(a:="")
{
	if(ProcessMonitor.IsWindowMine())
	{
		Debug.Show()
	}
	SendRaw, %a%
}

MySetCapsLockState(a:="")
{
	SetCapsLockState, %a%
}
MySetControlDelay(a:="")
{
	SetControlDelay, %a%
}
MySetDefaultMouseSpeed(a:="")
{
	SetDefaultMouseSpeed, %a%
}
MySetEnv(a:="",b:="")
{
	SetEnv, %a%, %b%
}
MySetFormat(a:="",b:="")
{
	SetFormat, %a%, %b%
}
MySetKeyDelay(a:="",b:="",c:="")
{
	SetKeyDelay, %a%, %b%, %c%
}
MySetMouseDelay(a:="",b:="")
{
	SetMouseDelay, %a%, %b%
}
MySetNumLockState(a:="")
{
	SetNumLockState, %a%
}
MySetScrollLockState(a:="")
{
	SetScrollLockState, %a%
}
MySetStoreCapslockMode(a:="")
{
	SetStoreCapslockMode, %a%
}

MySetTitleMatchMode(a:="")
{
	SetTitleMatchMode, %a%
}
MySetWinDelay(a:="")
{
	SetWinDelay, %a%
}

MySoundBeep(a:="",b:="")
{
	SoundBeep, %a%, %b%
}
MySoundGet(a:="",b:="",c:="")
{
	SoundGet, OutputVar, %a%, %b%, %c%
	return OutputVar
}
MySoundGetWaveVolume()
{
	SoundGetWaveVolume, OutputVar, %a%
	return OutputVar
}
MySoundPlay(a:="",b:="")
{
	SoundPlay, %a%, %b%
}
MySoundSet(a:="",b:="",c:="",d:="")
{
	SoundSet, %a%, %b%, %c%, %d%
}
MySoundSetWaveVolume(a:="",b:="")
{
	SoundSetWaveVolume, %a%, %b%
}
MySplashImage(a:="",b:="",c:="",d:="",e:="",f:="")
{
	SplashImage, %a%, %b%, %c%, %d%, %e%, %f%
}
MySplashTextOff()
{
	SplashTextOff
}
MySplashTextOn(a:="",b:="",c:="",d:="")
{
	SplashTextOn, %a%, %b%, %c%, %d%
}
MySplitPath(InputVar:="")
{
	SplitPath InputVar, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	return {OutFileName: OutFileName, OutDir: OutDir, OutExtension: OutExtension, OutNameNoExt: OutNameNoExt, OutDrive: OutDrive}
}
MyStatusBarGetText(a:="",b:="",c:="",d:="",e:="")
{
	StatusBarGetText, OutputVar, %a%, %b%, %c%, %d%, %e%
	return OutputVar 
}
MyStatusBarWait(a:="",b:="",c:="",d:="",e:="",f:="",g:="",h:="")
{
	StatusBarWait, %a%, %b%, %c%, %d%, %e%, %f%, %g%,%h%
}

MyStringGetPos(a:="",b:="",c:="",d:="")
{
	StringGetPos, OutputVar,%a%, %b%, %c%, %d%
	return OutputVar
}
MyStringLeft(a:="",b:="")
{
	StringLeft,  OutputVar, %a%, %b%
	return OutputVar
}
MyStringLen(a:="")
{
	StringLen, OutputVar, %a%
	return OutputVar
}
MyStringLower(a:="",b:="")
{
	StringLower, OutputVar, %a%, %b%
	return OutputVar
}
MyStringMid(a:="",b:="",c:="",d:="")
{
	StringMid, OutputVar,%a%, %b%, %c%, %d%
	return OutputVar 
}
MyStringReplace(a:="",b:="",c:="",d:="")
{
	StringReplace, OutputVar,%a%, %b%, %c%, %d%
	return OutputVar 
}
MyStringRight(a:="",b:="")
{
	StringRight, OutputVar, %a%, %b%
	return OutputVar
}
MyStringSplit(a:="",b:="",c:="")
{
	StringSplit, OutputVar,%a%, %b%, %c%
	return OutputVar 
}
MyStringTrimLeft(a:="",b:="")
{
	StringTrimLeft, OutputVar, %a%, %b%
	return OutputVar
}
MyStringTrimRight(a:="",b:="")
{
	StringTrimRight, OutputVar, %a%, %b%
	return OutputVar
}
MyStringUpper(a:="",b:="")
{
	StringUpper, OutputVar, %a%, %b%
	return OutputVar
}
MySuspend(a:="")
{
	Suspend, %a%
}
MySysGet(a:="",b:="")
{
	SysGet, OutputVar, %a%, %b%
	return OutputVar
}
MyToolTip(a:="",b:="",c:="",d:="")
{
	ToolTip, %a%, %b%, %c%, %d%
}
MyTransform(a:="",b:="",c:="")
{
	Transform, OutputVar,%a%, %b%, %c%
	return OutputVar 
}
MyTrayTip(a:="",b:="",c:="",d:="")
{
	TrayTip, %a%, %b%, %c%, %d%
}
MyWinActivate(a:="",b:="",c:="",d:="")
{
	WinActivate, %a%, %b%, %c%, %d%
}
MyWinActivateBottom(a:="",b:="",c:="",d:="")
{
	WinActivateBottom, %a%, %b%, %c%, %d%
}
MyWinClose(a:="",b:="",c:="",d:="",e:="")
{
	WinClose, %a%, %b%, %c%, %d%, %e%
}
MyWinGet(a:="",b:="",c:="",d:="",e:="")
{
	WinGet, OutputVar, %a%, %b%, %c%, %d%, %e%
	return OutputVar 
}
MyWinGetActiveStats()
{
	WinGetActiveStats, Title, Width, Height, X, Y
	return {Title: Title, Width: Width, Height: Height, X: X, Y: Y}
}
MyWinGetActiveTitle()
{
	WinGetActiveTitle, OutputVar
	return OutputVar 
}
MyWinGetClass(a:="",b:="",c:="",d:="")
{
	WinGetClass, OutputVar, %a%, %b%, %c%, %d%
	return OutputVar 
}
MyWinGetPos(a:="",b:="",c:="",d:="")
{
	WinGetPos, X, Y, Width, Height, %a%, %b%, %c%, %d%
	return {X: X, Y: Y, Width: Width, Height: Height}
}
MyWinGetText(a:="",b:="",c:="",d:="")
{
	WinGetText, OutputVar, %a%, %b%, %c%, %d%
	return OutputVar 
}
MyWinGetTitle(a:="",b:="",c:="",d:="")
{
	WinGetTitle, OutputVar, %a%, %b%, %c%, %d%
	return OutputVar 
}
MyWinHide(a:="",b:="",c:="",d:="")
{
	WinHide, %a%, %b%, %c%, %d%
}
MyWinKill(a:="",b:="",c:="",d:="",e:="")
{
	WinKill, %a%, %b%, %c%, %d%, %e%
}
MyWinMaximize(a:="",b:="",c:="",d:="")
{
	WinMaximize, %a%, %b%, %c%, %d%
}
MyWinMenuSelectItem(a:="",b:="",c:="",d:="",e:="",f:="",g:="",h:="",i:="",j:="",k:="")
{
	WinMenuSelectItem, %a%, %b%, %c%, %d%, %e%, %f%, %g%, %h%, %i%, %j%, %k%
}
MyWinMinimize(a:="",b:="",c:="",d:="")
{
	WinMinimize, %a%, %b%, %c%, %d%
}
MyWinMinimizeAll()
{
	WinMinimizeAll
}
MyWinMinimizeAllUndo()
{
	WinMinimizeAllUndo 
}
MyWinMove(a:="",b:="",c:="",d:="",e:="",f:="",g:="",h:="")
{
	WinMove, %a%, %b%, %c%, %d%, %e%, %f%, %g%, %h%
}
MyWinRestore(a:="",b:="",c:="",d:="")
{
	WinRestore, %a%, %b%, %c%, %d%
}
MyWinSet(a:="",b:="",c:="",d:="",e:="",f:="")
{
	WinSet, %a%, %b%, %c%, %d%, %e%, %f%
}
MyWinSetTitle(a:="",b:="",c:="",d:="",e:="")
{
	WinSetTitle, %a%, %b%, %c%, %d%, %e%
}
MyWinShow(a:="",b:="",c:="",d:="")
{
	WinShow, %a%, %b%, %c%, %d%
}
MyWinWait(a:="",b:="",c:="",d:="",e:="")
{
	WinWait, %a%, %b%, %c%, %d%, %e%
}
MyWinWaitActive(a:="",b:="",c:="",d:="",e:="")
{
	WinWaitActive, %a%, %b%, %c%, %d%, %e%
}
MyWinWaitClose(a:="",b:="",c:="",d:="",e:="")
{
	WinWaitClose, %a%, %b%, %c%, %d%, %e%
}
MyWinWaitNotActive(a:="",b:="",c:="",d:="",e:="")
{
	WinWaitNotActive, %a%, %b%, %c%, %d%, %e%
}

MySendLevel(a:="")
{
	SendLevel, %a%
}


