;The global Name/Handlers for controls

global EditWindowContextDialog_
global iEditWindowContextDialog
global EditWindowContextDialog_ContextName_TextBox
global EditWindowContextDialog_Title_TextBox
global EditWindowContextDialog_ClassName_TextBox
global EditWindowContextDialog_Code_TextBox
global EditWindowContextDialog_StatusBar

global EditWindowContextDialog_EditButton
global EditWindowContextDialog_SelectProgramButton
global EditWindowContextDialog_ReloadButton
         
global EditWindowContextDialog_OkButton
global EditWindowContextDialog_CancelButton
global EditWindowContextDialog_CodeBox
global EditWindowContextDialog_RunButton
global EditWindowContextDialog_FindWindowButton
global hEditWindowContextDialog_CodeBox

global EditWindowContextDialog_ControlName_TextBox
global EditWindowContextDialog_ControlText_TextBox

global EditWindowContextDialog_SepLine1
global EditWindowContextDialog_SepLine2
global EditWindowContextDialog_Width
global EditWindowContextDialog_Height

global WindowContextLink1

global EditWindowContextDialog_Enabled

Class EditWindowContextDialog
{
    m_TVItem :=
	
	static m_TimeStamp :=
	static m_OldCode :=
	m_FoundWindow :=
	m_hWnd :=
	m_FlashTime :=
	m_JustShown :=
	ShowModal()
	{
		gEditing := true
		;disable the main ui window
		;Winset, Disable,, Hot Key Speak
		;show myself
		last:=a_defaultgui
		Gui, EditWindowContextDialog_:Default
		arr:= ReadWindowPos("WindowContextEditUI")
		X:=arr["X"]
		Y:=arr["Y"]
		Width:=arr["Width"]
		Height:=arr["Height"]
		this.m_JustShown := 10
		Gui, Show , x%X% y%Y% w%Width% h%Height% , Edit Window Context
		hWindowContextWindow := WinExist("Edit Window Context")
		this.m_hWnd := hWindowContextWindow
		MoveWindow(this.m_hWnd,X, Y, Width, Height, 1)
		
		Gui, +OwnDialogs
		WinSet, Top, , Edit Context
		
		;sleep ,100
		
		;send, {tab}{tab}{tab}{tab}{tab}
		Gui, %last%:Default
		
		SetOwner(hWindowContextWindow,hMainUIWindow)
		EnableWindow(hMainUIWindow,0)
		EnableWindow(hDebugWindow,1)
		
		;MySleep(1000)
		
		;MySleep(2000)
		;hwnd := this.m_hWnd
		;WinGetPos, X, Y, Width, Height, ahk_id %hwnd%
		;iEditWindowContextDialog.OnDoneResize(Width, Height)
		
		;
	}

	;creates the GUI Window
	__New(TVItem, ContextName, Title, ClassName, Code, ControlName, ControlText, Disabled)
	{

		this.m_FoundWindow := -1
		Menu, tray, Icon , %WindowContextUIIconFile%
        this.m_TVItem := TVItem
		;set EditWindowContextDialog_ as target for setting things up
		last:=a_defaultgui
		Gui, EditWindowContextDialog_:Default
		;allow resize
		Gui, +resize +OwnDialogs -MinimizeBox
		Gui, +MinSize600x500
		Gui, Color, %WindowBackColor%
		;Label on top of treeview

        PanelWidth := 440
        PanelHeight := 300
        LabelsWidth := 80


		Gui, Font, c%HeaderFontColor% w%HeaderFontWeight% s%HeaderFontSize%, %HeaderFontName%
		;Label on top of treeview	
		Gui, Add, Text, section x10 , Window Context

		FindWindowIco := A_ScriptDir . "\Graphics\Icons\FindWindow.ico"
		Gui, Add, Picture, x300 yp w%LinkIconSize% h-1 vEditWindowContextDialog_FindWindowButton gEditWindowContextDialog_FindWindowButton HWNDhEditWindowContextDialog_FindWindowButton, %FindWindowIco%
		
		HelpIco := A_ScriptDir . "\Graphics\Icons\Help.ico"
		Gui, Add, Picture, x+m  w%LinkIconSize% h-1 vWindowContextLink1 gWindowContextLink1 HWNDhWindowContextLink1, %HelpIco%
		
		SepLine := A_ScriptDir . "\Graphics\Images\sepline.png"
		Gui, Add, Picture, section x20 w400 vEditWindowContextDialog_SepLine1, %SepLine%

		buf:="  "

		Gui, Font, c%LabelFontColor% w%LabelFontWeight% s%LabelFontSize%, %LabelFontName%
        Gui, Add, Text, r1 -wrap section x20, Name:%buf%


        Gui, Add, Text, r1 -wrap , Window Title:%buf%
        Gui, Add, Text, r1 -wrap , Window Class:%buf%
		Gui, Add, Text, r1 -wrap , Control Name:%buf%
		Gui, Add, Text, r1 -wrap , Control Text:%buf%
		Gui, Add, Text, r1 -wrap , %buf%
		Gui, Add, Text, r1 -wrap , Code:%buf%
        


		Gui, Color,, %TextBoxBackColor%
		Gui, Font, c%TextBoxFontColor% w%TextBoxFontWeight% s%TextBoxFontSize%, %TextBoxFontName%
		Gui, Add, Edit, section ys r1 -wrap w400 vEditWindowContextDialog_ContextName_TextBox, %ContextName%
        Gui, Add, Edit, r1 -wrap w400 vEditWindowContextDialog_Title_TextBox, %Title%
		Gui, Add, Edit, r1 -wrap w400 vEditWindowContextDialog_ClassName_TextBox, %ClassName%
		Gui, Add, Edit, r1 -wrap w400 vEditWindowContextDialog_ControlName_TextBox, %ControlName%
		Gui, Add, Edit, r1 -wrap w400 vEditWindowContextDialog_ControlText_TextBox, %ControlText%
        
		chk := "checked"
		if(Disabled)
		{
			chk := ""
		}
		Gui, Font, c%LabelFontColor% w%LabelFontWeight% s%LabelFontSize%, %LabelFontName%
		Gui,Add,Checkbox,vEditWindowContextDialog_Enabled %chk% xs,Enabled

		Gui, Color,, %CodeBoxBackColor%
		Gui, Font, c%CodeBoxFontColor% w%CodeBoxFontWeight% s%CodeBoxFontSize%, %CodeBoxFontName%
        Gui, Add, Edit, w316 r10 -Wrap vEditWindowContextDialog_Code_TextBox hwndhEditWindowContextDialog_CodeBox, %Code%

		
        
		
		Gui, Color,, %ButtonBackColor%
		Gui, Font, c%ButtonFontColor% w%ButtonFontWeight% s%ButtonFontSize%, %ButtonFontName%
        
        ;t:=" Find Window "
		;Gui, Add, Button, vEditWindowContextDialog_FindWindowButton gEditWindowContextDialog_FindWindowButton, %t%
        ;t:=" Run "
		;Gui, Add, Button, vEditWindowContextDialog_RunButton gEditWindowContextDialog_RunButton, %t%
		;t:=" Edit "
		;Gui, Add, Button, x+m vEditWindowContextDialog_EditButton gEditWindowContextDialog_EditButton, %t%
		;Gui, Add, Button, x+m vEditWindowContextDialog_SelectProgramButton gEditWindowContextDialog_SelectProgramButton, ...
		;t:=" Reload "
		;Gui, Add, Button, x+m vEditWindowContextDialog_ReloadButton gEditWindowContextDialog_ReloadButton, %t%

		RunIco := A_ScriptDir . "\Graphics\Icons\RunCode.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditWindowContextDialog_RunButton gEditWindowContextDialog_RunButton HWNDhEditWindowContextDialog_RunButton, %RunIco%

		EditIco := A_ScriptDir . "\Graphics\Icons\EditCode.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditWindowContextDialog_EditButton gEditWindowContextDialog_EditButton HWNDhEditWindowContextDialog_EditButton, %EditIco%

		EllipsisIco := A_ScriptDir . "\Graphics\Icons\Ellipsis.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditWindowContextDialog_SelectProgramButton gEditWindowContextDialog_SelectProgramButton HWNDhEditWindowContextDialog_SelectProgramButton, %EllipsisIco%

		ReloadIco := A_ScriptDir . "\Graphics\Icons\Reload.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vEditWindowContextDialog_ReloadButton gEditWindowContextDialog_ReloadButton HWNDhEditWindowContextDialog_ReloadButton, %ReloadIco%

		Gui, Add, Picture, section x20 w400 vEditWindowContextDialog_SepLine2, %SepLine%

		t:="  OK  "
        Gui, Add, Button, ys +Default vEditWindowContextDialog_OkButton gEditWindowContextDialog_OkButton, %t%
		t:=" Cancel "
        Gui, Add, Button, ys +Cancel  vEditWindowContextDialog_CancelButton gEditWindowContextDialog_CancelButton, %t%



		;Status Bar
		Gui, Font, c%StatusFontColor% w%StatusFontWeight% s%StatusFontSize%, %StatusFontName%
		t := "Window Contexts are like Contexts but based on the Active Window."
		Gui, Add, Text, section xs R1 vEditWindowContextDialog_StatusBar , %t%

		;reset the default
		Gui, %last%:Default
        iEditWindowContextDialog := this

		iEditWindowContextDialog.PrepWatching()
		SetHilite(hEditWindowContextDialog_CodeBox)
		
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
        GuiControlGet, EditWindowContextDialog_ContextName_TextBox 
		if(!StringHelper.IsValidName(EditWindowContextDialog_ContextName_TextBox))
		{
			MsgBox , 4160 , Edit Window Context Name, That Window Context Name is not Valid! `nExample Names: AName, AName01, A_Name, A_Name_01
			return
		}
		RootExe := FindFirstItem.FindRootExe(this.m_TVItem)
		item := FindFirstItem.FindMatchingWindowContextName(EditWindowContextDialog_ContextName_TextBox,RootExe)
		if(item && item != this.m_TVItem)
		{
			MsgBox , 4160 , Edit Window Context Name, That Name is already taken for that Program!
			return
		}
		GuiControlGet, EditWindowContextDialog_Title_TextBox 
		GuiControlGet, EditWindowContextDialog_ClassName_TextBox 
		GuiControlGet, EditWindowContextDialog_Code_TextBox 
		GuiControlGet, EditWindowContextDialog_ControlName_TextBox 
		GuiControlGet, EditWindowContextDialog_ControlText_TextBox 
		GuiControlGet, EditWindowContextDialog_Enabled
        MainUITreeview_Control_Instance.OnChangeWindowContextItem(this.m_TVItem
						,EditWindowContextDialog_ContextName_TextBox
						,EditWindowContextDialog_Title_TextBox
						,EditWindowContextDialog_ClassName_TextBox
						,EditWindowContextDialog_Code_TextBox
						,EditWindowContextDialog_ControlName_TextBox
						,EditWindowContextDialog_ControlText_TextBox
						,!EditWindowContextDialog_Enabled)

		this.OnGUIClose()
		return
	}
	;GUI Close event
	OnGUIClose()
	{
		SaveWindowPos(this.m_hWnd, "WindowContextEditUI")
		Menu, tray, Icon , %MainUIIconFile%
        ;Winset, Enable,, Hot Key Speak
		;WinActivate, Hot Key Speak
		EnableWindow(hMainUIWindow,1)
		ShowWindow(hMainUIWindow,5)
		
		;Destroy this dialog
		last:=a_defaultgui
		Gui, EditWindowContextDialog_:Default
		Gui, Destroy  
		;cleanup
		iEditWindowContextDialog := 0
		Gui, %last%:Default
		SetTimer, EditWindowContextDialog_MonitorFileChange, Off
		SetTimer, EditWindowContextDialog_FindWindowTimer, Off
		FileDelete %A_MyDocuments%\HotKeySpeak\temp\tmp.js
		gEditing := false
		RemoveHilite(hEditWindowContextDialog_CodeBox)
	}
	OnRunCode()
	{
		
		last:=a_defaultgui
		Gui, EditWindowContextDialog_:Default
		GuiControlGet, EditWindowContextDialog_Code_TextBox
		Gui, %last%:Default
		
		;Interpreter.Eval(EditWindowContextDialog_Code_TextBox)
		;Interpreter.Exec(EditWindowContextDialog_Code_TextBox)
		jsRunner := Interpreter
		if(EventManager.m_current_process_extra_data)
		{
			
			jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
		}
		jsRunner.Exec(EditWindowContextDialog_Code_TextBox)
		
	}
	PrepWatching()
	{
		last:=a_defaultgui
		Gui, EditWindowContextDialog_:Default
		GuiControlGet, EditWindowContextDialog_Code_TextBox
		Gui, %last%:Default

		FileCreateDir, %A_MyDocuments%\HotKeySpeak\temp
		FileDelete %A_MyDocuments%\HotKeySpeak\temp\tmp.js
		FileAppend, %EditWindowContextDialog_Code_TextBox%, %A_MyDocuments%\HotKeySpeak\temp\tmp.js

		FileGetTime, OutputVar, %A_MyDocuments%\HotKeySpeak\temp\tmp.js
		iEditWindowContextDialog.m_TimeStamp := OutputVar
		SetTimer , EditWindowContextDialog_MonitorFileChange, 1000
		iEditWindowContextDialog.m_OldCode := EditWindowContextDialog_Code_TextBox
	}
	DetectCodeChanges()
	{
		FileGetTime, OutputVar,%A_MyDocuments%\HotKeySpeak\temp\tmp.js
		if(iEditWindowContextDialog.m_TimeStamp != OutputVar)
		{
			iEditWindowContextDialog.m_TimeStamp := OutputVar
			EditWindowContextDialog_ReloadButton()
		}
		else
		{
			last:=a_defaultgui
			Gui, EditWindowContextDialog_:Default
			GuiControlGet, EditWindowContextDialog_Code_TextBox
			Gui, %last%:Default
			
			if(!(iEditWindowContextDialog.m_OldCode==EditWindowContextDialog_Code_TextBox))
			{
				iEditWindowContextDialog.PrepWatching()
			}
		}
	}
	;Window Resize event
	OnResize(Width, Height)
	{
		
		EditWindowContextDialog_Width := Width
		EditWindowContextDialog_Height := Height
		SetTimer, EditWindowContextDialog_DoneResize, 200
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
		Gui, EditWindowContextDialog_:Default
		GuiControlGet, StatusPos,Pos, EditWindowContextDialog_StatusBar
		GuiControlGet, CancelPos,Pos, EditWindowContextDialog_CancelButton
		GuiControlGet, OKPos,Pos, EditWindowContextDialog_OkButton
		GuiControlGet, RunPos,Pos, EditWindowContextDialog_RunButton
		GuiControlGet, FindWinPos,Pos, EditWindowContextDialog_FindWindowButton
		GuiControlGet, EditPos,Pos, EditWindowContextDialog_EditButton
		GuiControlGet, SelectProgPos,Pos, EditWindowContextDialog_SelectProgramButton
		GuiControlGet, ReloadPos,Pos, EditWindowContextDialog_ReloadButton

		;GuiControlGet, CNPos,Pos, EditWindowContextDialog_ContextName_TextBox
		;GuiControlGet, HKPos,Pos, EditWindowContextDialog_ClassName_TextBox
		;GuiControlGet, SpkPos,Pos, EditWindowContextDialog_Title_TextBox
		GuiControlGet, CodePos,Pos, EditWindowContextDialog_Code_TextBox
		
		GuiControlGet, WindowContextLink1Pos,Pos, WindowContextLink1
		
		GuiControl, MoveDraw, EditWindowContextDialog_StatusBar, % "X0 Y" . (Height - StatusPosH)
		GuiControl, MoveDraw, EditWindowContextDialog_CancelButton, % "X" . (Width-CancelPosW-sep-sep) . " Y" . (Height - StatusPosH - CancelPosH - sep)
		GuiControl, MoveDraw, EditWindowContextDialog_OkButton, % " X" . (Width-CancelPosW-sep-sep-OKPosW-sep) . " Y" . (Height - StatusPosH - OKPosH - sep)
		GuiControl, MoveDraw, EditWindowContextDialog_SepLine2, % "Y" . (Height - StatusPosH - OKPosH - sep - sep) . " W" . (Width - 40)
		GuiControl, MoveDraw, EditWindowContextDialog_ReloadButton, % "X" . (Width - sep - sep - ReloadPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, MoveDraw, EditWindowContextDialog_SelectProgramButton, % "X" . (Width - sep - sep - ReloadPosW-sep-SelectProgPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, MoveDraw, EditWindowContextDialog_EditButton, % "X" . (Width - sep - sep - sep/2 - ReloadPosW-sep-SelectProgPosW - EditPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, MoveDraw, EditWindowContextDialog_RunButton, % "X" . (Width - sep - sep - sep/2 -sep - ReloadPosW-sep-SelectProgPosW - EditPosW - RunPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		
		GuiControl, MoveDraw, EditWindowContextDialog_Code_TextBox, % "W" . (Width-CodePosX-sep-sep) . " H" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep - sep - CodePosY)
		GuiControl, MoveDraw, EditWindowContextDialog_ControlName_TextBox, % "W" . (Width-CodePosX-sep-sep)
		GuiControl, MoveDraw, EditWindowContextDialog_ControlText_TextBox, % "W" . (Width-CodePosX-sep-sep)
		GuiControl, MoveDraw, EditWindowContextDialog_Title_TextBox, % "W" . (Width-CodePosX-sep-sep)
		GuiControl, MoveDraw, EditWindowContextDialog_ClassName_TextBox, % "W" . (Width-CodePosX-sep-sep)
		GuiControl, MoveDraw, EditWindowContextDialog_ContextName_TextBox, % "W" . (Width-CodePosX-sep-sep)

		GuiControl, MoveDraw, WindowContextLink1, % "X" . (Width-WindowContextLink1PosW-sep-sep)

		GuiControl, MoveDraw, EditWindowContextDialog_FindWindowButton, % "X" . (Width-WindowContextLink1PosW-sep-sep-FindWinPosW-sep)

		GuiControl, MoveDraw, EditWindowContextDialog_SepLine1, % " W" . (Width - 40)
		
		
		Gui, %last%:Default



		return
	}
	OnFindWindowStart()
	{
		this.m_hWnd := WinExist()
		this.m_FlashTime := 0
		this.m_FoundWindow := -1
	}
	OnFindWindowTimer()
	{
		if(this.m_FlashTime == 0)
		{
			DllCall( "FlashWindow", UInt, this.m_hWnd, Int,True )
		}
		this.m_FlashTime += 100
		if(this.m_FlashTime >= 500)
		{
			this.m_FlashTime := 0
		}
		if(GetKeyState("LControl" , "P"))
		{
			if(!ProcessMonitor.IsWindowMine())
			{
				this.m_FoundWindow := ProcessMonitor.GetActiveWindowhWnd()
				last:=a_defaultgui
				Gui, EditWindowContextDialog_:Default

				Title:=ProcessMonitor.GetActiveWindowTitle()
				ClassName:=ProcessMonitor.GetActiveWindowClassName()
				ControlName:=ProcessMonitor.GetActiveControlName()
				ControlText:=ProcessMonitor.GetActiveControlText()
				GuiControl,,EditWindowContextDialog_Title_TextBox,%Title%
				GuiControl,,EditWindowContextDialog_ClassName_TextBox,%ClassName%
				GuiControl,,EditWindowContextDialog_ControlName_TextBox,%ControlName%
				GuiControl,,EditWindowContextDialog_ControlText_TextBox,%ControlText%

				Gui, %last%:Default
			}
			hwnd := this.m_hWnd
			WinActivate , ahk_id %hwnd%
			SetTimer, EditWindowContextDialog_FindWindowTimer, Off
			DllCall( "FlashWindow", UInt, this.m_hWnd, Int,false )

			;last:=a_defaultgui
			;Gui, MainUIWindow_:Default
			;TV_Modify(this.m_TVItem,"Select")
			;Gui, %last%:Default
		}
	}
}


;All events dispatched to the class function

EditWindowContextDialog_OkButton()
{
    return iEditWindowContextDialog.OnOKPressed()
}
EditWindowContextDialog_CancelButton()
{
    return iEditWindowContextDialog.OnGuiClose()
}
EditWindowContextDialog_GuiClose()
{  
    return iEditWindowContextDialog.OnGuiClose()
}
;Escape dialog
EditWindowContextDialog_GuiEscape()
{  
	return iEditWindowContextDialog.OnGuiClose()
}
;Run Button
EditWindowContextDialog_RunButton()
{
	return iEditWindowContextDialog.OnRunCode()
}

EditWindowContextDialog_EditButton()
{
	iEditWindowContextDialog.PrepWatching()
	ed:= ScriptEditor
	try
	{
		Run, "%ed%" "%A_MyDocuments%\HotKeySpeak\temp\tmp.js"
	}
	catch
	{
		EditWindowContextDialog_SelectProgramButton()
	}
}
EditWindowContextDialog_ReloadButton()
{
	last:=a_defaultgui
	FileRead, OutputVar, %A_MyDocuments%\HotKeySpeak\temp\tmp.js
	Gui, EditWindowContextDialog_:Default
	GuiControl,,EditWindowContextDialog_Code_TextBox,%OutputVar%
	Gui, %last%:Default
	iEditWindowContextDialog.m_OldCode := OutputVar
}

EditWindowContextDialog_SelectProgramButton()
{
	ed:= ScriptEditor
	SelectedFile := ed
	FileSelectFile, SelectedFile, 3, %ed%, Select Editor To Use, Program Files (*.exe)
	if(SelectedFile)
	{
		ScriptEditor := SelectedFile 
	}
}
EditWindowContextDialog_MonitorFileChange()
{
	iEditWindowContextDialog.DetectCodeChanges()
}

EditWindowContextDialog_GuiSize(GuiHwnd, EventInfo, Width, Height)
{
	; The window has been minimized.  No action needed.
	if(EventInfo <> 1)
	{
		iEditWindowContextDialog.OnResize(Width, Height)	
	}
	return
}

EditWindowContextDialog_FindWindowButton()
{
	iEditWindowContextDialog.OnFindWindowStart()
	MsgBox , 4160 , Find Window, Click the Window or Control then tap LEFT CTRL to get the search field data!`n`nRemember the fields can be set to find a specific window or control or act in a more generalized sense. Fields that are Blank or contain * allow anything and RegEx filters are allowed so you don't need to stick with the exact data you got.`n`nPress OK to Start!
	SetTimer, EditWindowContextDialog_FindWindowTimer, 100
}
EditWindowContextDialog_FindWindowTimer()
{
	iEditWindowContextDialog.OnFindWindowTimer()
}
WindowContextLink1()
{
	ControlGet, SelText, Selected,,,ahk_id %hEditWindowContextDialog_CodeBox% 
	if(SelText!="")
	{
		DoHelp("WindowContext&Code=Coding" . SelText)
	}
	else
	{
		DoHelp("WindowContext")
	}
}
return
EditWindowContextDialog_DoneResize:
{

	iEditWindowContextDialog.OnDoneResize(EditWindowContextDialog_Width, EditWindowContextDialog_Height)
	SetTimer, EditWindowContextDialog_DoneResize, Off
}
return

#IfWinActive , Edit Window Context
F1::
WindowContextLink1()
#if
return