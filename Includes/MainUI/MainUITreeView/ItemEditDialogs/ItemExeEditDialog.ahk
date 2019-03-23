;The global Name/Handlers for controls

global EditExeDialog_
global iEditExeDialog
global EditExeDialog_AppName_TextBox
global EditExeDialog_ExeFile_TextBox
global EditExeDialog_Code_TextBox
global EditExeDialog_StatusBar

global EditExeDialog_EditButton
global EditExeDialog_SelectProgramButton
global EditExeDialog_SelectExeProgramButton
global EditExeDialog_ReloadButton
         
global EditExeDialog_OkButton
global EditExeDialog_CancelButton
global EditExeDialog_CodeBox
global EditExeDialog_RunButton

global EditExeDialog_SepLine1
global EditExeDialog_SepLine2
global EditExeDialog_Width
global EditExeDialog_Height
global EditExeDialog_Enabled
global hEditExeDialog_CodeBox
global ExeLink1

Class EditExeDialog
{
    m_TVItem :=
	static m_TimeStamp :=
	static m_OldCode :=
	m_OldFilename :=
	static m_hWnd :=
	m_JustShown :=
	ShowModal()
	{
		gEditing := true
		;disable the main ui window
		Winset, Disable,, Hot Key Speak
		;show myself
		last:=a_defaultgui
		Gui, EditExeDialog_:Default
		
		arr:= ReadWindowPos("ExeEditUI")
		X:=arr["X"]
		Y:=arr["Y"]
		Width:=arr["Width"]
		Height:=arr["Height"]
		this.m_JustShown := 10
		Gui, Show , x%X% y%Y% w%Width% h%Height% , Edit Application
		hWindow := WinExist("Edit Application")
		this.m_hWnd := hWindow
		;SetWindowBackgroundColor(hWindow, 0)
		;EraseWindowBackground(hWindow)
		MoveWindow(this.m_hWnd,X, Y, Width, Height, 1)


		Gui, +OwnDialogs
		WinSet, Top, , Edit Application
		
		;sleep ,100
		;send, {tab}{tab}{tab}{tab}
		Gui, %last%:Default
		EditExeDialog.m_hWnd:=this.m_hWnd
		SetOwner(EditExeDialog.m_hWnd,hMainUIWindow)
		EnableWindow(hMainUIWindow,0)
		EnableWindow(hDebugWindow,1)
	}

	;creates the GUI Window
	__New(TVItem, ExeFile, Code, AppName, Disabled)
	{
		iEditExeDialog := this
		this.m_OldFilename:=ExeFile
		Menu, tray, Icon , %ExeUIIconFile%
		this.m_TVItem := TVItem
		;set EditExeDialog_ as target for setting things up
		last:=a_defaultgui
		Gui, EditExeDialog_:Default
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
		Gui, Add, Text, section x10 , Application

		HelpIco := A_ScriptDir . "\Graphics\Icons\Help.ico"
		Gui, Add, Picture, x300 yp w%LinkIconSize% h-1 vExeLink1 gExeLink1 HWNDhExeLink1, %HelpIco%


		SepLine := A_ScriptDir . "\Graphics\Images\sepline.png"
		Gui, Add, Picture, section x20 w400 vEditExeDialog_SepLine1, %SepLine%

		buf:="  "

		Gui, Font, c%LabelFontColor% w%LabelFontWeight% s%LabelFontSize%, %LabelFontName%
        Gui, Add, Text, r1 -wrap section x20 y+m, Name:%buf%
		Gui, Add, Text, r1 -wrap , Program File:%buf%
		Gui, Add, Text, r1 -wrap , %buf%
        Gui, Add, Text, r1 -wrap , Code:%buf%
        


		Gui, Color,, %TextBoxBackColor%
		Gui, Font, c%TextBoxFontColor% w%TextBoxFontWeight% s%TextBoxFontSize%, %TextBoxFontName%
		Gui, Add, Edit, section ys r1 -wrap w400 vEditExeDialog_AppName_TextBox, %AppName%
		Gui, Add, Edit, r1 -wrap w400 vEditExeDialog_ExeFile_TextBox, %ExeFile%

		;Gui, Color,, %ButtonBackColor%
		;Gui, Font, c%ButtonFontColor% w%ButtonFontWeight% s%ButtonFontSize%, %ButtonFontName%
		;Gui, Add, Button, x+m yp vEditExeDialog_SelectExeProgramButton gEditExeDialog_SelectExeProgramButton, ...
		GuiControlGet, zePos,Pos, EditExeDialog_ExeFile_TextBox
		xxx := zePosX+zePosW + 8

		EllipsisIco := A_ScriptDir . "\Graphics\Icons\Ellipsis.ico"
		Gui, Add, Picture, x%xxx% yp w%zePosH% h-1 vEditExeDialog_SelectExeProgramButton gEditExeDialog_SelectExeProgramButton HWNDhEditExeDialog_SelectExeProgramButton, %EllipsisIco%

		chk := "checked"
		if(Disabled)
		{
			chk := ""
		}
		Gui, Font, c%LabelFontColor% w%LabelFontWeight% s%LabelFontSize%, %LabelFontName%
		Gui,Add,Checkbox,vEditExeDialog_Enabled %chk% xs,Enabled

		Gui, Color,, %TextBoxBackColor%
		Gui, Font, c%TextBoxFontColor% w%TextBoxFontWeight% s%TextBoxFontSize%, %TextBoxFontName%
        
		Gui, Color,, %CodeBoxBackColor%
		Gui, Font, c%CodeBoxFontColor% w%CodeBoxFontWeight% s%CodeBoxFontSize%, %CodeBoxFontName%
        Gui, Add, Edit, w316 xs r10 -Wrap vEditExeDialog_Code_TextBox hwndhEditExeDialog_CodeBox, %Code%

		
        
		
		Gui, Color, , %ButtonBackColor%
		Gui, Font, c%ButtonFontColor% w%ButtonFontWeight% s%ButtonFontSize%, %ButtonFontName%
        
		RunIco := A_ScriptDir . "\Graphics\Icons\RunCode.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditExeDialog_RunButton gEditExeDialog_RunButton HWNDhEditExeDialog_RunButton, %RunIco%

		EditIco := A_ScriptDir . "\Graphics\Icons\EditCode.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditExeDialog_EditButton gEditExeDialog_EditButton HWNDhEditExeDialog_EditButton, %EditIco%

		EllipsisIco := A_ScriptDir . "\Graphics\Icons\Ellipsis.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditExeDialog_SelectProgramButton gEditExeDialog_SelectProgramButton HWNDhEditExeDialog_SelectProgramButton, %EllipsisIco%

		ReloadIco := A_ScriptDir . "\Graphics\Icons\Reload.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditExeDialog_ReloadButton gEditExeDialog_ReloadButton HWNDhEditExeDialog_ReloadButton, %ReloadIco%

		Gui, Add, Picture, section x20 w400 vEditExeDialog_SepLine2, %SepLine%

		t:="  OK  "
        Gui, Add, Button, ys +Default vEditExeDialog_OkButton gEditExeDialog_OkButton, %t%
		t:=" Cancel "
        Gui, Add, Button, ys +Cancel  vEditExeDialog_CancelButton gEditExeDialog_CancelButton, %t%



		;Status Bar
		Gui, Font, c%StatusFontColor% w%StatusFontWeight% s%StatusFontSize%, %StatusFontName%
		t := " Applications have code that runs when activated. Use it to set your globals."
		Gui, Add, Text, section xs R1 vEditExeDialog_StatusBar , %t%

		;reset the default
		Gui, %last%:Default
        

		iEditExeDialog.PrepWatching()
		
		SetHilite(hEditExeDialog_CodeBox)
		
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
        GuiControlGet, EditExeDialog_ExeFile_TextBox
		
		SplitPath, EditExeDialog_ExeFile_TextBox , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		
		foundItem := FindFirstItem.FindMatchingExeItem(OutFileName)
		if(foundItem && foundItem != this.m_TVItem)
		{
			MsgBox , 4160 , Edit Application, That Application Exists Already! `nNo Duplicates Allowed.
			return
		}
		
		isWin10 := false
		if(InStr(EditExeDialog_ExeFile_TextBox, "WindowsApps"))
		{
			isWin10 := true
		}
		else if (InStr(EditExeDialog_ExeFile_TextBox, "SystemApps"))
		{
			isWin10 := true
		}
		else if (InStr(EditExeDialog_ExeFile_TextBox, "ApplicationFrameHost"))
		{
			isWin10 := true
		}
		else if (InStr(EditExeDialog_ExeFile_TextBox, "ApplicationFrameHost"))
		{
			isWin10 := true
		}
		else if (InStr(EditExeDialog_ExeFile_TextBox, "\Windows\"))
		{
			isWin10 := true
		}

		if(!FileExist(EditExeDialog_ExeFile_TextBox))
		{
			if(isWin10)
			{
				MsgBox , 4160 , Edit Application, That Application File Does Not Exist!`n%EditExeDialog_ExeFile_TextBox%`n`nThough It looks like a Windows 10 App where validation is not possible due the access rights for such file.`nThe Error will be ignored...
			}
			else
			{
				MsgBox , 4160 , Edit Application, That Application File Does Not Exist! `n%EditExeDialog_ExeFile_TextBox%
				return
			}
			
		}
		if(this.m_OldFilename!=EditExeDialog_ExeFile_TextBox)
		{
			MsgBox , 4160 , Edit Application, The Icon for this Application will be updated on restart.
		}
		GuiControlGet, EditExeDialog_Code_TextBox 
		GuiControlGet, EditExeDialog_AppName_TextBox
		GuiControlGet, EditExeDialog_Enabled
        MainUITreeview_Control_Instance.OnChangeExeItem(this.m_TVItem
						,EditExeDialog_ExeFile_TextBox
						,EditExeDialog_Code_TextBox
						,EditExeDialog_AppName_TextBox
						,!EditExeDialog_Enabled)


		this.OnGUIClose()
		return
	}
	;GUI Close event
	OnGUIClose()
	{
		SaveWindowPos(this.m_hWnd, "ExeEditUI")
		Menu, tray, Icon , %MainUIIconFile%
        ;Winset, Enable,, Hot Key Speak
		;WinActivate, Hot Key Speak
		EnableWindow(hMainUIWindow,1)
		ShowWindow(hMainUIWindow,5)
		;Destroy this dialog
		last:=a_defaultgui
		Gui, EditExeDialog_:Default
		Gui, Destroy  
		;cleanup
		iEditExeDialog := 0
		Gui, %last%:Default
		SetTimer, EditExeDialog_MonitorFileChange, Off
		FileDelete %A_MyDocuments%\HotKeySpeak\temp\tmp.js
		gEditing := false
		RemoveHilite(hEditExeDialog_CodeBox)
	}
	OnRunCode()
	{
		
		last:=a_defaultgui
		Gui, EditExeDialog_:Default
		GuiControlGet, EditExeDialog_Code_TextBox
		Gui, %last%:Default
		
		;Interpreter.Eval(EditExeDialog_Code_TextBox)
		;Interpreter.Exec(EditExeDialog_Code_TextBox)
		jsRunner := Interpreter
		if(EventManager.m_current_process_extra_data)
		{
			
			jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
		}
		jsRunner.Exec(EditExeDialog_Code_TextBox)
		
		
	}
	PrepWatching()
	{
		last:=a_defaultgui
		Gui, EditExeDialog_:Default
		GuiControlGet, EditExeDialog_Code_TextBox
		Gui, %last%:Default

		FileCreateDir, %A_MyDocuments%\HotKeySpeak\temp

		FileDelete %A_MyDocuments%\HotKeySpeak\temp\tmp.js
		FileAppend, %EditExeDialog_Code_TextBox%, %A_MyDocuments%\HotKeySpeak\temp\tmp.js

		FileGetTime, OutputVar, %A_MyDocuments%\HotKeySpeak\temp\tmp.js

		iEditExeDialog.m_TimeStamp := OutputVar
		
		SetTimer , EditExeDialog_MonitorFileChange, 1000
		iEditExeDialog.m_OldCode := EditExeDialog_Code_TextBox
	}
	DetectCodeChanges()
	{
		FileGetTime, OutputVar,%A_MyDocuments%\HotKeySpeak\temp\tmp.js
		if(iEditExeDialog.m_TimeStamp != OutputVar)
		{
			iEditExeDialog.m_TimeStamp := OutputVar
			EditExeDialog_ReloadButton()
		}
		else
		{
			last:=a_defaultgui
			Gui, EditExeDialog_:Default
			GuiControlGet, EditExeDialog_Code_TextBox
			Gui, %last%:Default
			
			if(!(iEditExeDialog.m_OldCode==EditExeDialog_Code_TextBox))
			{
				iEditExeDialog.PrepWatching()
			}
		}
	}
	;Window Resize event
	OnResize(Width, Height)
	{
		
		EditExeDialog_Width := Width
		EditExeDialog_Height := Height
		SetTimer, EditExeDialog_DoneResize, 200
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
		Gui, EditExeDialog_:Default
		GuiControlGet, StatusPos,Pos, EditExeDialog_StatusBar
		GuiControlGet, CancelPos,Pos, EditExeDialog_CancelButton
		GuiControlGet, OKPos,Pos, EditExeDialog_OkButton
		GuiControlGet, RunPos,Pos, EditExeDialog_RunButton
		GuiControlGet, EditPos,Pos, EditExeDialog_EditButton
		GuiControlGet, SelectProgPos,Pos, EditExeDialog_SelectProgramButton
		GuiControlGet, SelectExeProgPos,Pos, EditExeDialog_SelectExeProgramButton
		;SelectExeProgPosW :=0
		GuiControlGet, ReloadPos,Pos, EditExeDialog_ReloadButton

		GuiControlGet, CodePos,Pos, EditExeDialog_Code_TextBox
		
		GuiControlGet, ExeLink1Pos,Pos, ExeLink1
		
		GuiControl, MoveDraw, EditExeDialog_StatusBar, % "X0 Y" . (Height - StatusPosH)
		GuiControl, MoveDraw, EditExeDialog_CancelButton, % "X" . (Width-CancelPosW-sep-sep) . " Y" . (Height - StatusPosH - CancelPosH - sep)
		GuiControl, MoveDraw, EditExeDialog_OkButton, % " X" . (Width-CancelPosW-sep-sep-OKPosW-sep) . " Y" . (Height - StatusPosH - OKPosH - sep)
		GuiControl, MoveDraw, EditExeDialog_SepLine2, % "Y" . (Height - StatusPosH - OKPosH - sep - sep) . " W" . (Width - 40)
		GuiControl, MoveDraw, EditExeDialog_ReloadButton, % "X" . (Width - sep - sep - ReloadPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, MoveDraw, EditExeDialog_SelectProgramButton, % "X" . (Width - sep - sep - ReloadPosW-sep-SelectProgPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, MoveDraw, EditExeDialog_EditButton, % "X" . (Width - sep - sep - sep/2 - ReloadPosW-sep-SelectProgPosW - EditPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, MoveDraw, EditExeDialog_RunButton, % "X" . (Width - sep - sep - sep/2 -sep - ReloadPosW-sep-SelectProgPosW - EditPosW - RunPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)

		GuiControl, MoveDraw, EditExeDialog_SelectExeProgramButton, % "X" . (Width -sep -sep - SelectExeProgPosW)
		GuiControl, MoveDraw, EditExeDialog_Code_TextBox, % "W" . (Width-CodePosX-sep-sep) . " H" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep - sep - CodePosY)
		GuiControl, MoveDraw, EditExeDialog_ExeFile_TextBox, % "W" . (Width-CodePosX-sep-sep-sep - SelectExeProgPosW)
		GuiControl, MoveDraw, EditExeDialog_AppName_TextBox, % "W" . (Width-CodePosX-sep-sep-sep - SelectExeProgPosW)

		GuiControl, MoveDraw, ExeLink1, % "X" . (Width-ExeLink1PosW-sep-sep)

		GuiControl, MoveDraw, EditExeDialog_SepLine1, % " W" . (Width - 40)

		Gui, %last%:Default
		return
	}
	AddProcess(ExeFilename,AppName:="")
	{
		if(AppName == "Windows Apps")
		{
			Debug.MsgBox("Can't perform this action! Selected Process is a Windows App!`n`nUse the Windows Apps item in the treeview for Windows Apps Management")
		}
		else
		{

			last:=a_defaultgui
			Gui, EditExeDialog_:Default
			GuiControl,,EditExeDialog_ExeFile_TextBox,%ExeFilename%
			aname := AppName
			if(aname == "")
			{
				SplitPath, ExeFilename , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
				aname := OutFileName
			}
			GuiControl,,EditExeDialog_AppName_TextBox,%aname%
			Gui, %last%:Default
		}
	}
	AddWinAppProcess(AppName)
	{
		
	}
}


;All events dispatched to the class function

EditExeDialog_OkButton()
{
    return iEditExeDialog.OnOKPressed()
}
EditExeDialog_CancelButton()
{
    return iEditExeDialog.OnGuiClose()
}
EditExeDialog_GuiClose()
{  
    return iEditExeDialog.OnGuiClose()
}
;Escape dialog
EditExeDialog_GuiEscape()
{  
	return iEditExeDialog.OnGuiClose()
}
;Run Button
EditExeDialog_RunButton()
{
	return iEditExeDialog.OnRunCode()
}

EditExeDialog_EditButton()
{
	iEditExeDialog.PrepWatching()
	ed:= ScriptEditor
	try
	{
		Run, "%ed%" "%A_MyDocuments%\HotKeySpeak\temp\tmp.js"
	}
	catch
	{
		EditExeDialog_SelectProgramButton()
	}
}
EditExeDialog_ReloadButton()
{
	last:=a_defaultgui
	FileRead, OutputVar,%A_MyDocuments%\HotKeySpeak\temp\tmp.js
	Gui, EditExeDialog_:Default
	GuiControl,,EditExeDialog_Code_TextBox,%OutputVar%
	Gui, %last%:Default
	iEditExeDialog.m_OldCode := OutputVar
	
}

EditExeDialog_SelectProgramButton()
{
	ed:= ScriptEditor
	SelectedFile := ed
	FileSelectFile, SelectedFile, 3, %ed%, Select Editor To Use, Program Files (*.exe)
	if(SelectedFile)
	{
		ScriptEditor := SelectedFile 
	}
}
EditExeDialog_SelectExeProgramButton()
{
	ListProcessDialog.Create(iEditExeDialog)
	ListProcessDialog.ShowModal(EditExeDialog.m_hWnd)
}

EditExeDialog_MonitorFileChange()
{
	iEditExeDialog.DetectCodeChanges()
}

EditExeDialog_GuiSize(GuiHwnd, EventInfo, Width, Height)
{
	; The window has been minimized.  No action needed.
	if(EventInfo <> 1)
	{
		iEditExeDialog.OnResize(Width, Height)	
	}
	return
}

ExeLink1()
{
	ControlGet, SelText, Selected,,,ahk_id %hEditExeDialog_CodeBox% 
	if(SelText!="")
	{
		DoHelp("Exe&Code=Coding" . SelText)
	}
	else
	{
		DoHelp("Exe")
	}
}
return
EditExeDialog_DoneResize:
{

	iEditExeDialog.OnDoneResize(EditExeDialog_Width, EditExeDialog_Height)
	SetTimer, EditExeDialog_DoneResize, Off
}
return

return
#IfWinActive , Edit Application
F1::
ExeLink1()
#if
return