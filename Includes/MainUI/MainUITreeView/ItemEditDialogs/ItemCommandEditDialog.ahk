;The global Name/Handlers for controls

global EditCommandDialog_
global iEditCommandDialog
global EditCommandDialog_CommandName_TextBox
global EditCommandDialog_SpeakText_TextBox
global EditCommandDialog_HotKeys_TextBox
global EditCommandDialog_Code_TextBox
global EditCommandDialog_StatusBar

global EditCommandDialog_EditButton
global EditCommandDialog_SelectProgramButton
global EditCommandDialog_ReloadButton
         
global EditCommandDialog_OkButton
global EditCommandDialog_CancelButton
global EditCommandDialog_CodeBox
global EditCommandDialog_RunButton
global hEditCommandDialog_CodeBox

global EditCommandDialog_SepLine1
global EditCommandDialog_SepLine2
global EditCommandDialog_Width
global EditCommandDialog_Height
global CommandLink1

global EditCommandDialogRecordBut
global hEditCommandDialogRecordBut
global EditCommandDialogRecordingBut
global hEditCommandDialog_HotKeys_TextBox

global EditCommandDialog_Enabled

;spellling mistake
Class EditCommandDialog
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
		;Winset, Disable,, Hot Key Speak
		;show myself
		last:=a_defaultgui
		Gui, EditCommandDialog_:Default
		

		arr:= ReadWindowPos("CommandEditUI")
		X:=arr["X"]
		Y:=arr["Y"]
		Width:=arr["Width"]
		Height:=arr["Height"]
		this.m_JustShown := 10
		Gui, Show , x%X% y%Y% w%Width% h%Height% , Edit Command Action
		hCommandWindow := WinExist("Edit Command Action")
		this.m_hWnd := hCommandWindow
		MoveWindow(this.m_hWnd,X, Y, Width, Height, 1)


		Gui, +OwnDialogs
		WinSet, Top, , Edit Command Action
		
		;sleep ,100
		;send, {tab}{tab}{tab}{tab}{tab}
		Gui, %last%:Default
		SetOwner(hCommandWindow,hMainUIWindow)
		EnableWindow(hMainUIWindow,0)
		EnableWindow(hDebugWindow,1)
		
		
	}

	;creates the GUI Window
	__New(TVItem, CommandName, SpeakText, HotKeys, Code, Disabled)
	{
		this.m_OldSpeakText := SpeakText
		Menu, tray, Icon , %CommandUIIconFile%
		this.m_TVItem := TVItem
		;set EditCommandDialog_ as target for setting things up
		last:=a_defaultgui
		Gui, EditCommandDialog_:Default
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
		Gui, Add, Text, section x10 , Command Action

		HelpIco := A_ScriptDir . "\Graphics\Icons\Help.ico"
		Gui, Add, Picture, x300 yp w%LinkIconSize% h-1 vCommandLink1 gCommandLink1 HWNDhCommandLink1, %HelpIco%


		SepLine := A_ScriptDir . "\Graphics\Images\sepline.png"
		Gui, Add, Picture, section x20 w400 vEditCommandDialog_SepLine1, %SepLine%
		buf:="  "

		Gui, Font, c%LabelFontColor% w%LabelFontWeight% s%LabelFontSize%, %LabelFontName%
        Gui, Add, Text, r1 -wrap section x20 y+m, Name:%buf%


        Gui, Add, Text, r1 -wrap , Hot Key:%buf%
        Gui, Add, Text, r1 -wrap , Spoken Words:%buf%
		Gui, Add, Text, r1 -wrap , %buf%
        Gui, Add, Text, r1 -wrap , Code:%buf%
        


		Gui, Color,, %TextBoxBackColor%
		Gui, Font, c%TextBoxFontColor% w%TextBoxFontWeight% s%TextBoxFontSize%, %TextBoxFontName%
		Gui, Add, Edit, section ys r1 -wrap w400 vEditCommandDialog_CommandName_TextBox, %CommandName%
        Gui, Add, Edit, r1 -wrap hwndhEditCommandDialog_HotKeys_TextBox w400 vEditCommandDialog_HotKeys_TextBox, %HotKeys%
		

		GuiControlGet, zePos,Pos, EditCommandDialog_HotKeys_TextBox
		xxx := zePosX+zePosW + 8
		RecordIco := A_ScriptDir . "\Graphics\Icons\RecordOff.ico"
		Gui, Add, Picture, x%xxx% yp w%zePosH% h-1 vEditCommandDialogRecordBut gEditCommandDialogRecordBut HWNDhEditCommandDialogRecordBut, %RecordIco%
		RecordingIco := A_ScriptDir . "\Graphics\Icons\RecordOn.ico"
		Gui, Add, Picture, x%xxx% yp w%zePosH% h-1 +Hidden vEditCommandDialogRecordingBut gEditCommandDialogRecordingBut HWNDhEditCommandDialogRecordingBut, %RecordingIco%

        Gui, Add, Edit, r1 xs -wrap w400 vEditCommandDialog_SpeakText_TextBox, %SpeakText%


		chk := "checked"
		if(Disabled)
		{
			chk := ""
		}
		Gui, Font, c%LabelFontColor% w%LabelFontWeight% s%LabelFontSize%, %LabelFontName%
		Gui,Add,Checkbox,vEditCommandDialog_Enabled %chk% xs,Enabled


		Gui, Color,, %CodeBoxBackColor%
		Gui, Font, c%CodeBoxFontColor% w%CodeBoxFontWeight% s%CodeBoxFontSize%, %CodeBoxFontName%
        Gui, Add, Edit, w316 r10 -Wrap vEditCommandDialog_Code_TextBox hwndhEditCommandDialog_CodeBox, %Code%
		
		Gui, Color,, %ButtonBackColor%
		Gui, Font, c%ButtonFontColor% w%ButtonFontWeight% s%ButtonFontSize%, %ButtonFontName%
         
        RunIco := A_ScriptDir . "\Graphics\Icons\RunCode.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditCommandDialog_RunButton gEditCommandDialog_RunButton HWNDhEditCommandDialog_RunButton, %RunIco%

		EditIco := A_ScriptDir . "\Graphics\Icons\EditCode.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditCommandDialog_EditButton gEditCommandDialog_EditButton HWNDhEditCommandDialog_EditButton, %EditIco%

		EllipsisIco := A_ScriptDir . "\Graphics\Icons\Ellipsis.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditCommandDialog_SelectProgramButton gEditCommandDialog_SelectProgramButton HWNDhEditCommandDialog_SelectProgramButton, %EllipsisIco%

		ReloadIco := A_ScriptDir . "\Graphics\Icons\Reload.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditCommandDialog_ReloadButton gEditCommandDialog_ReloadButton HWNDhEditCommandDialog_ReloadButton, %ReloadIco%

		Gui, Add, Picture, section x20 w400 vEditCommandDialog_SepLine2, %SepLine%

		t:="  OK  "
        Gui, Add, Button, ys +Default vEditCommandDialog_OkButton gEditCommandDialog_OkButton, %t%
		t:=" Cancel "
        Gui, Add, Button, ys +Cancel  vEditCommandDialog_CancelButton gEditCommandDialog_CancelButton, %t%



		;Status Bar
		Gui, Font, c%StatusFontColor% w%StatusFontWeight% s%StatusFontSize%, %StatusFontName%
		t := " Commands have code ran by spoken words/sentence or by hot key."
		Gui, Add, Text, section xs R1 vEditCommandDialog_StatusBar , %t%

		;reset the default
		Gui, %last%:Default
        iEditCommandDialog := this

		iEditCommandDialog.PrepWatching()
		SetHilite(hEditCommandDialog_CodeBox)
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
        GuiControlGet, EditCommandDialog_CommandName_TextBox
		if(!StringHelper.IsValidName(EditCommandDialog_CommandName_TextBox))
		{
			MsgBox , 4160 , Edit Command Name, That Command Name is not Valid! `nExample Names: AName, AName01, A_Name, A_Name_01
			return
		}
		RootExe := FindFirstItem.FindRootExe(this.m_TVItem)
		item := FindFirstItem.FindMatchingCommandName(EditCommandDialog_CommandName_TextBox,RootExe)
		if(item && item != this.m_TVItem)
		{
			MsgBox , 4160 , Edit Command Name, That Name is already taken for that Program!
			return
		}
		GuiControlGet, EditCommandDialog_SpeakText_TextBox 
		GuiControlGet, EditCommandDialog_HotKeys_TextBox 
		if(EditCommandDialog_HotKeys_TextBox!="")
		{
			hk:=EditCommandDialog_HotKeys_TextBox
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
		GuiControlGet, EditCommandDialog_Code_TextBox 
		GuiControlGet, EditCommandDialog_Enabled
        MainUITreeview_Control_Instance.OnChangeCommandItem(this.m_TVItem
						,EditCommandDialog_CommandName_TextBox
						,EditCommandDialog_SpeakText_TextBox
						,EditCommandDialog_HotKeys_TextBox
						,EditCommandDialog_Code_TextBox
						,!EditCommandDialog_Enabled)


		if(this.m_OldSpeakText!=EditCommandDialog_SpeakText_TextBox)
		{
			MsgBox , 4160 , Edit Program, The Speech Recognition Grammar for this Command will be updated on restart. 
		}

		this.OnGUIClose()
		return
	}
	;GUI Close event
	OnGUIClose()
	{
		hKeyGrabCtrl :=0
		SaveWindowPos(this.m_hWnd, "CommandEditUI")
		Menu, tray, Icon , %MainUIIconFile%
        ;Winset, Enable,, Hot Key Speak
		EnableWindow(hMainUIWindow,1)
		ShowWindow(hMainUIWindow,5)
		;WinActivate, Hot Key Speak
		
		;Destroy this dialog
		last:=a_defaultgui
		Gui, EditCommandDialog_:Default
		Gui, Destroy  
		;cleanup
		iEditCommandDialog := 0
		Gui, %last%:Default
		SetTimer, EditCommandDialog_MonitorFileChange, Off
		FileDelete %A_MyDocuments%\HotKeySpeak\temp\tmp.js
		gEditing := false
		RemoveHilite(hEditCommandDialog_CodeBox)
	}
	OnRunCode()
	{
		
		last:=a_defaultgui
		Gui, EditCommandDialog_:Default
		GuiControlGet, EditCommandDialog_Code_TextBox
		Gui, %last%:Default
		
		;Interpreter.Eval(EditCommandDialog_Code_TextBox)
		;Interpreter.Exec(EditCommandDialog_Code_TextBox)
		jsRunner := Interpreter
		if(EventManager.m_current_process_extra_data)
		{
			
			jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
		}
		jsRunner.Exec(EditCommandDialog_Code_TextBox)
		
		
	}
	PrepWatching()
	{
		last:=a_defaultgui
		Gui, EditCommandDialog_:Default
		GuiControlGet, EditCommandDialog_Code_TextBox
		Gui, %last%:Default

		FileCreateDir, %A_MyDocuments%\HotKeySpeak\temp

		FileDelete %A_MyDocuments%\HotKeySpeak\temp\tmp.js
		FileAppend, %EditCommandDialog_Code_TextBox%, %A_MyDocuments%\HotKeySpeak\temp\tmp.js

		FileGetTime, OutputVar, %A_MyDocuments%\HotKeySpeak\temp\tmp.js
		iEditCommandDialog.m_TimeStamp := OutputVar
		SetTimer , EditCommandDialog_MonitorFileChange, 1000
		iEditCommandDialog.m_OldCode := EditCommandDialog_Code_TextBox
	}
	DetectCodeChanges()
	{
		FileGetTime, OutputVar,%A_MyDocuments%\HotKeySpeak\temp\tmp.js
		if(iEditCommandDialog.m_TimeStamp != OutputVar)
		{
			iEditCommandDialog.m_TimeStamp := OutputVar
			EditCommandDialog_ReloadButton()
		}
		else
		{
			last:=a_defaultgui
			Gui, EditCommandDialog_:Default
			GuiControlGet, EditCommandDialog_Code_TextBox
			Gui, %last%:Default
			
			if(!(iEditCommandDialog.m_OldCode==EditCommandDialog_Code_TextBox))
			{
				iEditCommandDialog.PrepWatching()
			}
		}
	}
	;Window Resize event
	OnResize(Width, Height)
	{
		
		EditCommandDialog_Width := Width
		EditCommandDialog_Height := Height
		SetTimer, EditCommandDialog_DoneResize, 200
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
		Gui, EditCommandDialog_:Default
		GuiControlGet, StatusPos,Pos, EditCommandDialog_StatusBar
		GuiControlGet, CancelPos,Pos, EditCommandDialog_CancelButton
		GuiControlGet, OKPos,Pos, EditCommandDialog_OkButton
		GuiControlGet, RunPos,Pos, EditCommandDialog_RunButton
		GuiControlGet, EditPos,Pos, EditCommandDialog_EditButton
		GuiControlGet, SelectProgPos,Pos, EditCommandDialog_SelectProgramButton
		GuiControlGet, ReloadPos,Pos, EditCommandDialog_ReloadButton

		GuiControlGet, CommandLink1Pos,Pos, CommandLink1

		;GuiControlGet, CNPos,Pos, EditCommandDialog_CommandName_TextBox
		;GuiControlGet, HKPos,Pos, EditCommandDialog_HotKeys_TextBox
		;GuiControlGet, SpkPos,Pos, EditCommandDialog_SpeakText_TextBox
		GuiControlGet, CodePos,Pos, EditCommandDialog_Code_TextBox
		GuiControlGet, RecPos,Pos, EditCommandDialogRecordBut
		
		GuiControl, MoveDraw, EditCommandDialog_StatusBar, % "X0 Y" . (Height - StatusPosH)
		GuiControl, MoveDraw, EditCommandDialog_CancelButton, % "X" . (Width-CancelPosW-sep-sep) . " Y" . (Height - StatusPosH - CancelPosH - sep)
		GuiControl, MoveDraw, EditCommandDialog_OkButton, % " X" . (Width-CancelPosW-sep-sep-OKPosW-sep) . " Y" . (Height - StatusPosH - OKPosH - sep)
		GuiControl, MoveDraw, EditCommandDialog_SepLine2, % "Y" . (Height - StatusPosH - OKPosH - sep - sep) . " W" . (Width - 40)
		GuiControl, MoveDraw, EditCommandDialog_ReloadButton, % "X" . (Width - sep - sep - ReloadPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, MoveDraw, EditCommandDialog_SelectProgramButton, % "X" . (Width - sep - sep - ReloadPosW-sep-SelectProgPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, MoveDraw, EditCommandDialog_EditButton, % "X" . (Width - sep - sep - sep/2 - ReloadPosW-sep-SelectProgPosW - EditPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, MoveDraw, EditCommandDialog_RunButton, % "X" . (Width - sep - sep - sep/2 -sep - ReloadPosW-sep-SelectProgPosW - EditPosW - RunPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)

		GuiControl, MoveDraw, EditCommandDialog_Code_TextBox, % "W" . (Width-CodePosX-sep-sep) . " H" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep - sep - CodePosY)
		GuiControl, MoveDraw, EditCommandDialog_SpeakText_TextBox, % "W" . (Width-CodePosX-sep-sep)
		GuiControl, MoveDraw, EditCommandDialogRecordBut, % "X" . (Width-RecPosW-sep-sep)
		GuiControl, MoveDraw, EditCommandDialogRecordingBut, % "X" . (Width-RecPosW-sep-sep)
		GuiControl, MoveDraw, EditCommandDialog_HotKeys_TextBox, % "W" . (Width-CodePosX-sep-sep-sep-RecPosW)
		GuiControl, MoveDraw, EditCommandDialog_CommandName_TextBox, % "W" . (Width-CodePosX-sep-sep)

		GuiControl, MoveDraw, CommandLink1, % "X" . (Width-CommandLink1PosW-sep-sep)

		GuiControl, MoveDraw, EditCommandDialog_SepLine1, % " W" . (Width - 40)

		Gui, %last%:Default
		return
	}
}


;All events dispatched to the class function

EditCommandDialog_OkButton()
{
    return iEditCommandDialog.OnOKPressed()
}
EditCommandDialog_CancelButton()
{
    return iEditCommandDialog.OnGuiClose()
}
EditCommandDialog_GuiClose()
{  
    return iEditCommandDialog.OnGuiClose()
}
;Escape dialog
EditCommandDialog_GuiEscape()
{  
	return iEditCommandDialog.OnGuiClose()
}
;Run Button
EditCommandDialog_RunButton()
{
	return iEditCommandDialog.OnRunCode()
}

EditCommandDialog_EditButton()
{
	iEditCommandDialog.PrepWatching()
	ed:= ScriptEditor
	try
	{
		Run, "%ed%" "%A_MyDocuments%\HotKeySpeak\temp\tmp.js"
	}
	catch
	{
		EditCommandDialog_SelectProgramButton()
	}
}
EditCommandDialog_ReloadButton()
{
	last:=a_defaultgui
	FileRead, OutputVar, %A_MyDocuments%\HotKeySpeak\temp\tmp.js
	Gui, EditCommandDialog_:Default
	GuiControl,,EditCommandDialog_Code_TextBox,%OutputVar%
	Gui, %last%:Default
	iEditCommandDialog.m_OldCode := OutputVar
}

EditCommandDialog_SelectProgramButton()
{
	ed:= ScriptEditor
	SelectedFile := ed
	FileSelectFile, SelectedFile, 3, %ed%, Select Editor To Use, Program Files (*.exe)
	if(SelectedFile)
	{
		ScriptEditor := SelectedFile 
	}
}
EditCommandDialog_MonitorFileChange()
{
	iEditCommandDialog.DetectCodeChanges()
	
}

EditCommandDialog_GuiSize(GuiHwnd, EventInfo, Width, Height)
{
	; The window has been minimized.  No action needed.
	if(EventInfo <> 1)
	{
		iEditCommandDialog.OnResize(Width, Height)	
	}
	return
}
CommandLink1()
{
	ControlGet, SelText, Selected,,,ahk_id %hEditCommandDialog_CodeBox% 
	if(SelText!="")
	{
		DoHelp("Command&Code=Coding" . SelText)
	}
	else
	{
		DoHelp("Command")
	}
}

EditCommandDialogRecordBut()
{
	GuiControl, +Hidden, EditCommandDialogRecordBut
	GuiControl, -Hidden, EditCommandDialogRecordingBut
	GuiControl, Focus, EditCommandDialog_HotKeys_TextBox
	EBSelectAll(hEditCommandDialog_HotKeys_TextBox)
	hKeyGrabCtrl := hEditCommandDialog_HotKeys_TextBox
}
EditCommandDialogRecordingBut()
{
	GuiControl, -Hidden, EditCommandDialogRecordBut
	GuiControl, +Hidden, EditCommandDialogRecordingBut
	hKeyGrabCtrl := 0
}
return
EditCommandDialog_DoneResize:
{

	iEditCommandDialog.OnDoneResize(EditCommandDialog_Width, EditCommandDialog_Height)
	SetTimer, EditCommandDialog_DoneResize, Off
}
return
#IfWinActive , Edit Command Action
F1::
CommandLink1()
#if
return