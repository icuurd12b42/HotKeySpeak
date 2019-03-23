;The global Name/Handlers for controls

global EditContextDialog_
global iEditContextDialog
global EditContextDialog_ContextName_TextBox
global EditContextDialog_SpeakText_TextBox
global EditContextDialog_HotKeys_TextBox
global EditContextDialog_Code_TextBox
global EditContextDialog_StatusBar

global EditContextDialog_EditButton
global EditContextDialog_SelectProgramButton
global EditContextDialog_ReloadButton
         
global EditContextDialog_OkButton
global EditContextDialog_CancelButton
global EditContextDialog_CodeBox
global EditContextDialog_RunButton
global hEditContextDialog_CodeBox

global EditContextDialog_SepLine1
global EditContextDialog_SepLine2
global EditContextDialog_Width
global EditContextDialog_Height
global ContextLink1

global EditContextDialogRecordBut
global hEditContextDialogRecordBut
global EditContextDialogRecordingBut
global hEditContextDialog_HotKeys_TextBox

global EditContextDialog_Enabled

Class EditContextDialog
{
    m_TVItem :=
	static m_TimeStamp :=
	static m_OldCode :=
	m_OldSpeakText :=
	m_hWnd :=
	m_JustShown :=
	ShowModal()
	{
		gEditing := true
		;disable the main ui window
		Winset, Disable,, Hot Key Speak
		;show myself
		last:=a_defaultgui
		Gui, EditContextDialog_:Default
		
		;Gui, Show , w600 h400, Edit Context
		;iEditContextDialog.OnDoneResize(600, 400)

		arr:= ReadWindowPos("ContextEditUI")
		X:=arr["X"]
		Y:=arr["Y"]
		Width:=arr["Width"]
		Height:=arr["Height"]
		this.m_JustShown := 10
		Gui, Show , x%X% y%Y% w%Width% h%Height% , Edit Command Context
		hContextWindow := WinExist("Edit Command Context")
		this.m_hWnd := hContextWindow
		MoveWindow(this.m_hWnd,X, Y, Width, Height, 1)


		Gui, +OwnDialogs
		WinSet, Top, , Edit Command Context
		
		;sleep ,100
		;send, {tab}{tab}{tab}{tab}{tab}
		Gui, %last%:Default
		
		SetOwner(hContextWindow,hMainUIWindow)
		EnableWindow(hMainUIWindow,0)
		EnableWindow(hDebugWindow,1)
	}

	;creates the GUI Window
	__New(TVItem, ContextName, SpeakText, HotKeys, Code, Disabled)
	{
		this.m_OldSpeakText := SpeakText
		Menu, tray, Icon , %ContextUIIconFile%
        this.m_TVItem := TVItem
		;set EditContextDialog_ as target for setting things up
		last:=a_defaultgui
		Gui, EditContextDialog_:Default
		;allow resize
		Gui, +resize +OwnDialogs -MinimizeBox
		Gui, +MinSize600x400
		Gui, Color, %WindowBackColor%
		;Label on top of treeview

        PanelWidth := 440
        PanelHeight := 300
        LabelsWidth := 80


		Gui, Font, c%HeaderFontColor% w%HeaderFontWeight% s%HeaderFontSize%, %HeaderFontName%
		;Label on top of treeview	
		Gui, Add, Text, section x10 , Command Context

		HelpIco := A_ScriptDir . "\Graphics\Icons\Help.ico"
		Gui, Add, Picture, x300 yp w%LinkIconSize% h-1 vContextLink1 gContextLink1 HWNDhContextLink1, %HelpIco%


		SepLine := A_ScriptDir . "\Graphics\Images\sepline.png"
		Gui, Add, Picture, section x20 w400 vEditContextDialog_SepLine1, %SepLine%

		buf:="  "


		Gui, Font, c%LabelFontColor% w%LabelFontWeight% s%LabelFontSize%, %LabelFontName%
        Gui, Add, Text, r1 -wrap section x20 y+m, Name:%buf%


        Gui, Add, Text, r1 -wrap , Hot Key:%buf%
        Gui, Add, Text, r1 -wrap , Spoken Words:%buf%
		Gui, Add, Text, r1 -wrap , %buf%
        Gui, Add, Text, r1 -wrap , Code:%buf%
        


		Gui, Color,, %TextBoxBackColor%
		Gui, Font, c%TextBoxFontColor% w%TextBoxFontWeight% s%TextBoxFontSize%, %TextBoxFontName%
		Gui, Add, Edit, section ys r1 -wrap w400 vEditContextDialog_ContextName_TextBox, %ContextName%
        Gui, Add, Edit, r1 -wrap hwndhEditContextDialog_HotKeys_TextBox w400 vEditContextDialog_HotKeys_TextBox, %HotKeys%

		GuiControlGet, zePos,Pos, EditContextDialog_HotKeys_TextBox
		xxx := zePosX+zePosW + 8
		RecordIco := A_ScriptDir . "\Graphics\Icons\RecordOff.ico"
		Gui, Add, Picture, x%xxx% yp w%zePosH% h-1 vEditContextDialogRecordBut gEditContextDialogRecordBut HWNDhEditContextDialogRecordBut, %RecordIco%
		RecordingIco := A_ScriptDir . "\Graphics\Icons\RecordOn.ico"
		Gui, Add, Picture, x%xxx% yp w%zePosH% h-1 +Hidden vEditContextDialogRecordingBut gEditContextDialogRecordingBut HWNDhEditContextDialogRecordingBut, %RecordingIco%

        Gui, Add, Edit, r1 xs -wrap w400 vEditContextDialog_SpeakText_TextBox, %SpeakText%

		chk := "checked"
		if(Disabled)
		{
			chk := ""
		}
		Gui, Font, c%LabelFontColor% w%LabelFontWeight% s%LabelFontSize%, %LabelFontName%
		Gui,Add,Checkbox,vEditContextDialog_Enabled %chk% xs,Enabled

		Gui, Color,, %CodeBoxBackColor%
		Gui, Font, c%CodeBoxFontColor% w%CodeBoxFontWeight% s%CodeBoxFontSize%, %CodeBoxFontName%
        Gui, Add, Edit, w316 r10 -Wrap vEditContextDialog_Code_TextBox hwndhEditContextDialog_CodeBox, %Code%
		
		Gui, Color,, %ButtonBackColor%
		Gui, Font, c%ButtonFontColor% w%ButtonFontWeight% s%ButtonFontSize%, %ButtonFontName%
        
		RunIco := A_ScriptDir . "\Graphics\Icons\RunCode.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditContextDialog_RunButton gEditContextDialog_RunButton HWNDhEditContextDialog_RunButton, %RunIco%

		EditIco := A_ScriptDir . "\Graphics\Icons\EditCode.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditContextDialog_EditButton gEditContextDialog_EditButton HWNDhEditContextDialog_EditButton, %EditIco%

		EllipsisIco := A_ScriptDir . "\Graphics\Icons\Ellipsis.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditContextDialog_SelectProgramButton gEditContextDialog_SelectProgramButton HWNDhEditContextDialog_SelectProgramButton, %EllipsisIco%

		ReloadIco := A_ScriptDir . "\Graphics\Icons\Reload.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditContextDialog_ReloadButton gEditContextDialog_ReloadButton HWNDhEditContextDialog_ReloadButton, %ReloadIco%

		Gui, Add, Picture, section x20 w400 vEditContextDialog_SepLine2, %SepLine%

		t:="  OK  "
        Gui, Add, Button, ys +Default vEditContextDialog_OkButton gEditContextDialog_OkButton, %t%
		t:=" Cancel "
        Gui, Add, Button, ys +Cancel  vEditContextDialog_CancelButton gEditContextDialog_CancelButton, %t%



		;Status Bar
		Gui, Font, c%StatusFontColor% w%StatusFontWeight% s%StatusFontSize%, %StatusFontName%
		t := "Command Contexts are Command Actions that also limit the next actions to items listed under them."
		Gui, Add, Text, section xs R1 vEditContextDialog_StatusBar , %t%

		;reset the default
		Gui, %last%:Default
        iEditContextDialog := this

		iEditContextDialog.PrepWatching()
		SetHilite(hEditContextDialog_CodeBox)
		
	}
	;Window Resize event
	OnGuiSize(GuiHwnd, EventInfo, Width, Height)
	{
        return
	}
	;OK Button 
	OnOKPressed()
	{
        ;Tell the treeview
        GuiControlGet, EditContextDialog_ContextName_TextBox 
		if(!StringHelper.IsValidName(EditContextDialog_ContextName_TextBox))
		{
			MsgBox , 4160 , Edit Context Name, That Context Name is not Valid! `nExample Names: AName, AName01, A_Name, A_Name_01
			return
		}
		RootExe := FindFirstItem.FindRootExe(this.m_TVItem)
		item := FindFirstItem.FindMatchingContextName(EditContextDialog_ContextName_TextBox,RootExe)
		if(item && item != this.m_TVItem)
		{
			MsgBox , 4160 , Edit Context Name, That Name is already taken for that Program!
			return
		}
		GuiControlGet, EditContextDialog_SpeakText_TextBox 
		GuiControlGet, EditContextDialog_HotKeys_TextBox 

		if(EditContextDialog_HotKeys_TextBox!="")
		{
			hk:=EditContextDialog_HotKeys_TextBox
			try
			{
				Hotkey, %hk%, TestHotKeyStub, On
				Hotkey, %hk%, TestHotKeyStub, Off
			}
			catch e 
			{
				Debug.MsgBox("That key combination is not valid!")
				return
			}
		}

		GuiControlGet, EditContextDialog_Code_TextBox
		GuiControlGet, EditContextDialog_Enabled 
        MainUITreeview_Control_Instance.OnChangeContextItem(this.m_TVItem
						,EditContextDialog_ContextName_TextBox
						,EditContextDialog_SpeakText_TextBox
						,EditContextDialog_HotKeys_TextBox
						,EditContextDialog_Code_TextBox
						,!EditContextDialog_Enabled)

		if(this.m_OldSpeakText!=EditContextDialog_SpeakText_TextBox)
		{
			MsgBox , 4160 , Edit Program, The Speech Recognition Grammar for this Context will be updated on restart. 
		}

		this.OnGUIClose()
		return
	}
	;GUI Close event
	OnGUIClose()
	{
		hKeyGrabCtrl :=0
		SaveWindowPos(this.m_hWnd, "ContextEditUI")
		Menu, tray, Icon , %MainUIIconFile%
        ;Winset, Enable,, Hot Key Speak
		;WinActivate, Hot Key Speak
		EnableWindow(hMainUIWindow,1)
		ShowWindow(hMainUIWindow,5)
		;Destroy this dialog
		last:=a_defaultgui
		Gui, EditContextDialog_:Default
		Gui, Destroy  
		;cleanup
		iEditContextDialog := 0
		Gui, %last%:Default
		SetTimer, EditContextDialog_MonitorFileChange, Off
		FileDelete %A_MyDocuments%\HotKeySpeak\temp\tmp.js
		gEditing := false
		RemoveHilite(hEditContextDialog_CodeBox)
	}
	OnRunCode()
	{
		
		last:=a_defaultgui
		Gui, EditContextDialog_:Default
		GuiControlGet, EditContextDialog_Code_TextBox
		Gui, %last%:Default
		
		;Interpreter.Eval(EditContextDialog_Code_TextBox)
		;Interpreter.Exec(EditContextDialog_Code_TextBox)
		jsRunner := Interpreter
		if(EventManager.m_current_process_extra_data)
		{
			
			jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
		}
		jsRunner.Exec(EditContextDialog_Code_TextBox)
		
		
	}
	PrepWatching()
	{
		last:=a_defaultgui
		Gui, EditContextDialog_:Default
		GuiControlGet, EditContextDialog_Code_TextBox
		Gui, %last%:Default

		FileCreateDir, %A_MyDocuments%\HotKeySpeak\temp
		FileDelete %A_MyDocuments%\HotKeySpeak\temp\tmp.js
		FileAppend, %EditContextDialog_Code_TextBox%, %A_MyDocuments%\HotKeySpeak\temp\tmp.js

		FileGetTime, OutputVar, %A_MyDocuments%\HotKeySpeak\temp\tmp.js
		iEditContextDialog.m_TimeStamp := OutputVar
		SetTimer , EditContextDialog_MonitorFileChange, 1000
		iEditContextDialog.m_OldCode := EditContextDialog_Code_TextBox
	}
	DetectCodeChanges()
	{
		FileGetTime, OutputVar, %A_MyDocuments%\HotKeySpeak\temp\tmp.js
		if(iEditContextDialog.m_TimeStamp != OutputVar)
		{
			iEditContextDialog.m_TimeStamp := OutputVar
			EditContextDialog_ReloadButton()
		}
		else
		{
			last:=a_defaultgui
			Gui, EditContextDialog_:Default
			GuiControlGet, EditContextDialog_Code_TextBox
			Gui, %last%:Default
			
			if(!(iEditContextDialog.m_OldCode==EditContextDialog_Code_TextBox))
			{
				iEditContextDialog.PrepWatching()
			}
		}
	}
	;Window Resize event
	OnResize(Width, Height)
	{
		
		EditContextDialog_Width := Width
		EditContextDialog_Height := Height
		SetTimer, EditContextDialog_DoneResize, 200
		if(this.m_JustShown > 0)
		{
			this.OnDoneResize(Width, Height)
			this.m_JustShown -= 1
		}
	}
	OnDoneResize(Width, Height)
	{
		
		sep :=10

		last:=a_defaultgui
		Gui, EditContextDialog_:Default
		GuiControlGet, StatusPos,Pos, EditContextDialog_StatusBar
		GuiControlGet, CancelPos,Pos, EditContextDialog_CancelButton
		GuiControlGet, OKPos,Pos, EditContextDialog_OkButton
		GuiControlGet, RunPos,Pos, EditContextDialog_RunButton
		GuiControlGet, EditPos,Pos, EditContextDialog_EditButton
		GuiControlGet, SelectProgPos,Pos, EditContextDialog_SelectProgramButton
		GuiControlGet, ReloadPos,Pos, EditContextDialog_ReloadButton

		;GuiControlGet, CNPos,Pos, EditContextDialog_ContextName_TextBox
		;GuiControlGet, HKPos,Pos, EditContextDialog_HotKeys_TextBox
		;GuiControlGet, SpkPos,Pos, EditContextDialog_SpeakText_TextBox
		GuiControlGet, CodePos,Pos, EditContextDialog_Code_TextBox
		GuiControlGet, RecPos,Pos, EditContextDialogRecordBut
		
		GuiControlGet, ContextLink1Pos,Pos, ContextLink1

		GuiControl, MoveDraw, EditContextDialog_StatusBar, % "X0 Y" . (Height - StatusPosH)
		GuiControl, MoveDraw, EditContextDialog_CancelButton, % "X" . (Width-CancelPosW-sep-sep) . " Y" . (Height - StatusPosH - CancelPosH - sep)
		GuiControl, MoveDraw, EditContextDialog_OkButton, % " X" . (Width-CancelPosW-sep-sep-OKPosW-sep) . " Y" . (Height - StatusPosH - OKPosH - sep)
		GuiControl, MoveDraw, EditContextDialog_SepLine2, % "Y" . (Height - StatusPosH - OKPosH - sep - sep) . " W" . (Width - 40)
		GuiControl, MoveDraw, EditContextDialog_ReloadButton, % "X" . (Width - sep - sep - ReloadPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, MoveDraw, EditContextDialog_SelectProgramButton, % "X" . (Width - sep - sep - ReloadPosW-sep-SelectProgPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, MoveDraw, EditContextDialog_EditButton, % "X" . (Width - sep - sep - sep/2 - ReloadPosW-sep-SelectProgPosW - EditPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, MoveDraw, EditContextDialog_RunButton, % "X" . (Width - sep - sep - sep/2 -sep - ReloadPosW-sep-SelectProgPosW - EditPosW - RunPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)

		GuiControl, MoveDraw, EditContextDialog_Code_TextBox, % "W" . (Width-CodePosX-sep-sep) . " H" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep - sep - CodePosY)
		GuiControl, MoveDraw, EditContextDialog_SpeakText_TextBox, % "W" . (Width-CodePosX-sep-sep)
		GuiControl, MoveDraw, EditContextDialogRecordBut, % "X" . (Width-RecPosW-sep-sep)
		GuiControl, MoveDraw, EditContextDialogRecordingBut, % "X" . (Width-RecPosW-sep-sep)
		GuiControl, MoveDraw, EditContextDialog_HotKeys_TextBox, % "W" . (Width-CodePosX-sep-sep-sep-RecPosW)
		GuiControl, MoveDraw, EditContextDialog_ContextName_TextBox, % "W" . (Width-CodePosX-sep-sep)

		GuiControl, MoveDraw, ContextLink1, % "X" . (Width-ContextLink1PosW-sep-sep)

		GuiControl, MoveDraw, EditContextDialog_SepLine1, % " W" . (Width - 40)
		
		Gui, %last%:Default



		return
	}
}


;All events dispatched to the class function

EditContextDialog_OkButton()
{
    return iEditContextDialog.OnOKPressed()
}
EditContextDialog_CancelButton()
{
    return iEditContextDialog.OnGuiClose()
}
EditContextDialog_GuiClose()
{  
    return iEditContextDialog.OnGuiClose()
}
;Escape dialog
EditContextDialog_GuiEscape()
{  
	return iEditContextDialog.OnGuiClose()
}
;Run Button
EditContextDialog_RunButton()
{
	return iEditContextDialog.OnRunCode()
}

EditContextDialog_EditButton()
{
	iEditContextDialog.PrepWatching()
	ed:= ScriptEditor
	try
	{
		Run, "%ed%" "%A_MyDocuments%\HotKeySpeak\temp\tmp.js"
	}
	catch
	{
		EditContextDialog_SelectProgramButton()
	}
}
EditContextDialog_ReloadButton()
{
	last:=a_defaultgui
	FileRead, OutputVar, %A_MyDocuments%\HotKeySpeak\temp\tmp.js
	Gui, EditContextDialog_:Default
	GuiControl,,EditContextDialog_Code_TextBox,%OutputVar%
	Gui, %last%:Default
	iEditContextDialog.m_OldCode := OutputVar
}

EditContextDialog_SelectProgramButton()
{
	ed:= ScriptEditor
	SelectedFile := ed
	FileSelectFile, SelectedFile, 3, %ed%, Select Editor To Use, Program Files (*.exe)
	if(SelectedFile)
	{
		ScriptEditor := SelectedFile 
	}
}
EditContextDialog_MonitorFileChange()
{
	iEditContextDialog.DetectCodeChanges()
	
}

EditContextDialog_GuiSize(GuiHwnd, EventInfo, Width, Height)
{
	; The window has been minimized.  No action needed.
	if(EventInfo <> 1)
	{
		iEditContextDialog.OnResize(Width, Height)	
	}
	return
}

ContextLink1()
{
	ControlGet, SelText, Selected,,,ahk_id %hEditContextDialog_CodeBox% 
	if(SelText!="")
	{
		DoHelp("Context&Code=Coding" . SelText)
	}
	else
	{
		DoHelp("Context")
	}
}

EditContextDialogRecordBut()
{
	GuiControl, +Hidden, EditContextDialogRecordBut
	GuiControl, -Hidden, EditContextDialogRecordingBut
	GuiControl, Focus, EditContextDialog_HotKeys_TextBox
	EBSelectAll(hEditContextDialog_HotKeys_TextBox)
	hKeyGrabCtrl := hEditContextDialog_HotKeys_TextBox
}
EditContextDialogRecordingBut()
{
	GuiControl, -Hidden, EditContextDialogRecordBut
	GuiControl, +Hidden, EditContextDialogRecordingBut
	hKeyGrabCtrl := 0
}
return
EditContextDialog_DoneResize:
{

	iEditContextDialog.OnDoneResize(EditContextDialog_Width, EditContextDialog_Height)
	SetTimer, EditContextDialog_DoneResize, Off
}
return
#IfWinActive , Edit Command Context
F1::
ContextLink1()
#if
return


