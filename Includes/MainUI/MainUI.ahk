global MainLink1
global MainLink2
global MainLink3
global MainLink4
global MainLink5

global SaveLink
global RestartLink
global gDoHand := false
MainUI_Start()
{
	MainUIWindow.Create()
	MainUIWindow.Show()
	
	

	;SetOwner(hMainUIWindow,gMainContainerhWnd)
	;WinSet, style, -0xC00000, ahk_id %hMainUIWindow%
	;WinSet, style, +0x40000000, ahk_id %hMainUIWindow%
	;SetParent(hMainUIWindow,gMainContainerhWnd)
	;MoveWindow(hMainUIWindow,0, 0, 600, 400, 1)
	;send, {tab}{tab}{tab}{tab}{tab}
	gExit := false
	gEditing := false
}

;The MainUI_ window reference name
global MainUIWindow_
;the class wrapper
Class MainUIWindow
{
	gReady:=False
	static m_TV :=
	static m_SB :=
	;static m_PM :=
	static m_Icons :=
	m_hWnd := 
	Create()
	{
		
		this.m_Icons := New MainUIIcons()
		Menu, tray, Icon , %MainUIIconFile%,1,1
		
		;set MainUIWindow_ as target for setting things up
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
		
		;allow resize
		Gui, +resize
		Gui, Color, %WindowBackColor%


		


		
		Gui, Font, c%HeaderFontColor% w%HeaderFontWeight% s%HeaderFontSize%, %HeaderFontName%
		;Label on top of treeview	
		Gui, Add, Text, section x10 , Loaded Setup

		Gui, Font, c%LinkFontColor% w%LinkFontWeight% s%LinkFontSize%, %LinkFontName%

		HelpIco := A_ScriptDir . "\Graphics\Icons\Help.ico"
		OptionsIco := A_ScriptDir . "\Graphics\Icons\Options.ico"
		SupportIco := A_ScriptDir . "\Graphics\Icons\Support.ico"
		SaveIco := A_ScriptDir . "\Graphics\Icons\Save.ico"
		ReloadIco := A_ScriptDir . "\Graphics\Icons\Reload.ico"
		Gui, Add, Picture, x300 yp w%LinkIconSize% h-1 vMainLink1 gMainLink1 HWNDhMainLink1, %OptionsIco%
		Gui, Add, Picture, x+m  w%LinkIconSize% h-1 vMainLink2 gMainLink2 HWNDhMainLink2, %SaveIco%
		Gui, Add, Picture, x+m  w%LinkIconSize% h-1 vMainLink3 gMainLink3 HWNDhMainLink3, %ReloadIco%
		Gui, Add, Picture, x+m  w%LinkIconSize% h-1 vMainLink4 gMainLink4 HWNDhMainLink4, %SupportIco%
		Gui, Add, Picture, x+m  w%LinkIconSize% h-1 vMainLink5 gMainLink5 HWNDhMainLink5, %HelpIco%
		
		;Gui, Add, Link, hwndhLink1 vMainLink1 xp+200  ys, <a href="Help\Help.html">Options</a>
		;Gui, Add, Link, hwndhLink2 vMainLink2 x+m , <a href="Help\Help.html">Help</a>
		;Gui, Add, Link, hwndhLink3 vMainLink3 x+m, <a href="https://autohotkey.com/docs/AutoHotkey.htm">Support</a>
		;Gui, Add, Link, hwndhLink4 vMainLink4 gSaveLink x+m, <a>Save</a>
		;Gui, Add, Link, hwndhLink5 vMainLink5 gRestartLink x+m, <a>Restart</a>

		;LinkUseDefaultColor(hLink1)
		;LinkUseDefaultColor(hLink2)
		;LinkUseDefaultColor(hLink3)
		;LinkUseDefaultColor(hLink4)
		;LinkUseDefaultColor(hLink5)
		Gui, %last%:Default
		
		;
		;hIcon := DllCall("LoadImage", uint, 0
		;			, str, "Graphics\Icons\HotKeySpeak.ico"  ; Icon filename (this file may contain multiple icons).
		;			, uint, 1  ; Type of image: IMAGE_ICON
		;			, int, 128, int, 128  ; Desired width and height of image (helps LoadImage decide which icon is best).
		;			, uint, 0x10)  ; Flags: LR_LOADFROMFILE
		;SendMessage, 0x80, 0, hIcon  ; 0x80 is WM_SETICON; and 1 means ICON_BIG (vs. 0 for ICON_SMALL).
		;Gui, Show , w400 h400, Hot Key Speak
		;Gui, Destroy 
		this.m_TV := New MainUITreeview(this.m_Icons.GetImageList())
		
		;Status Bar
		this.m_SB := New MainUIStatusBar(" Right Click to Add Items. Expand (Enter). Edit (F2, Ctrl+Enter). Delete (Del). Emulate (Ctrl+Click).")
		
		;SAPIInitialSetup()
		SpeechToTextHandler.InitSAPI()
		this.m_TV.LoadTree()
		;this.m_PM := New ProcessMonitor(this.m_TV)
		gReady:=true
		EventManager.Init()

		ProcessMonitor.Init(this.m_TV)
		HotKeySystem.Init()
		SpeechToTextHandler.Init()
		TVItemSelectorHandler.Init(this.m_TV.m_RootAppsItem)
		InterpreterHandler.Init()
		GlobalEventHandler.Init()
		VoiceAgent.Init()

		
	}
	Show()
	{
		
		

		arr:= ReadWindowPos("MainUI")
		X:=arr["X"]
		Y:=arr["Y"]
		Width:=arr["Width"]
		Height:=arr["Height"]
		this.m_JustShown := 10
		Gui, MainUIWindow_:Show , x%X% y%Y% w%Width% h%Height% , Hot Key Speak
		
		this.m_hWnd := WinExist("Hot Key Speak")
		hMainUIWindow := this.m_hWnd

		MoveWindow(this.m_hWnd,X, Y, Width, Height, 1)


		;WinSet, Top, , Hot Key Speak
		;DllCall( "RegisterShellHookWindow", UInt, WinExist("Hot Key Speak") )
		
	}
	AddProcess(ExeFilename,AppName:="")
	{
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
		ico := this.m_Icons.LoadImage(ExeFilename, 1)
		this.m_TVIAppRoot := MainUIWindow.m_TV.AddExeItem(ExeFilename,ico,AppName)
		Gui, %last%:Default
	}
	AddWinAppProcess(AppName)
	{
		MainUIWindow.m_TV.AddWinAppItem(AppName)
	}
	OnResize(Width, Height)
	{
		this.m_TV.OnResize(Width, Height)
		
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
		GuiControlGet, MainLink1Pos,Pos, MainLink1
		GuiControlGet, MainLink2Pos,Pos, MainLink2
		GuiControlGet, MainLink3Pos,Pos, MainLink3
		GuiControlGet, MainLink4Pos,Pos, MainLink4
		GuiControlGet, MainLink5Pos,Pos, MainLink5

		sep := 5
		Pos := Width

		Pos -= MainLink5PosW
		Pos -= sep
		GuiControl, Move, MainLink5, % "X" . Pos
		Pos -= MainLink4PosW
		Pos -= sep
		GuiControl, Move, MainLink4, % "X" . Pos
		Pos -= MainLink3PosW
		Pos -= sep
		GuiControl, Move, MainLink3, % "X" . Pos
		Pos -= MainLink2PosW
		Pos -= sep
		GuiControl, Move, MainLink2, % "X" . Pos
		Pos -= MainLink1PosW
		Pos -= sep
		GuiControl, Move, MainLink1, % "X" . Pos

		GuiControl, +Redraw, MainLink5
		GuiControl, +Redraw, MainLink4
		GuiControl, +Redraw, MainLink3
		GuiControl, +Redraw, MainLink2
		GuiControl, +Redraw, MainLink1
		/*
		;GuiControlGet, CNPos,Pos, EditWindowContextDialog_ContextName_TextBox
		;GuiControlGet, HKPos,Pos, EditWindowContextDialog_ClassName_TextBox
		;GuiControlGet, SpkPos,Pos, EditWindowContextDialog_Title_TextBox
		GuiControlGet, CodePos,Pos, EditWindowContextDialog_Code_TextBox
		
		
		GuiControl, MoveDraw, EditWindowContextDialog_StatusBar, % "X0 Y" . (Height - StatusPosH)
		GuiControl, MoveDraw, EditWindowContextDialog_CancelButton, % "X" . (Width-CancelPosW-sep-sep) . " Y" . (Height - StatusPosH - CancelPosH - sep)
		GuiControl, MoveDraw, EditWindowContextDialog_OkButton, % " X" . (Width-CancelPosW-sep-sep-OKPosW-sep) . " Y" . (Height - StatusPosH - OKPosH - sep)
		GuiControl, Move, EditWindowContextDialog_Panel, % "X" . (sep) . " Y0 W" . (Width - sep - sep) . " H" .  (Height - StatusPosH - CancelPosH - sep - sep)
		GuiControl, Move, EditWindowContextDialog_ReloadButton, % "X" . (Width - sep - sep - ReloadPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, Move, EditWindowContextDialog_SelectProgramButton, % "X" . (Width - sep - sep - ReloadPosW-sep-SelectProgPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, Move, EditWindowContextDialog_EditButton, % "X" . (Width - sep - sep - sep/2 - ReloadPosW-sep-SelectProgPosW - EditPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, Move, EditWindowContextDialog_RunButton, % "X" . (Width - sep - sep - sep/2 -sep - ReloadPosW-sep-SelectProgPosW - EditPosW - RunPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)
		GuiControl, Move, EditWindowContextDialog_FindWindowButton, % "X" . (Width - sep - sep - sep/2 - sep  - sep - ReloadPosW-sep-SelectProgPosW - EditPosW - RunPosW - FindWinPosW) . " Y" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep)

		GuiControl, Move, EditWindowContextDialog_Code_TextBox, % "W" . (Width-CodePosX-sep-sep) . " H" . (Height - StatusPosH - CancelPosH - ReloadPosH - sep - sep - sep - sep - CodePosY)
		GuiControl, Move, EditWindowContextDialog_ControlName_TextBox, % "W" . (Width-CodePosX-sep-sep)
		GuiControl, Move, EditWindowContextDialog_ControlText_TextBox, % "W" . (Width-CodePosX-sep-sep)
		GuiControl, Move, EditWindowContextDialog_Title_TextBox, % "W" . (Width-CodePosX-sep-sep)
		GuiControl, Move, EditWindowContextDialog_ClassName_TextBox, % "W" . (Width-CodePosX-sep-sep)
		GuiControl, Move, EditWindowContextDialog_ContextName_TextBox, % "W" . (Width-CodePosX-sep-sep)

		*/

		
		
		Gui, %last%:Default
	}
	OnClose()
	{
		ShowWindow(this.m_hWnd,9)
		SaveWindowPos(this.m_hWnd, "MainUI")
		gExit := true
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
		this.m_TV.SaveTree()
		Gui, Destroy  
		Gui, %last%:Default
		
		ExitApp
	}
	OnCtrlRightClick(GuiHwnd, CtrlHwnd, EventInfo, IsRightClick, X, Y)
	{
		;if Treeview Handle
		if (CtrlHwnd == this.m_TV.GetHandle())
		{
			this.m_TV.OnRightClick(EventInfo,X,Y)
		}
		return
	}
}

;Window Resize event
MainUIWindow_GuiSize(GuiHwnd, EventInfo, Width, Height)
{
	; The window has been minimized.  No action needed.
	if(EventInfo <> 1)
	{
		MainUIWindow.OnResize(Width, Height)	
	}
	return
}
;GUI Close Event
MainUIWindow_GuiClose()
{
	MainUIWindow.OnClose()	
}
;Right Click Controls with mouse event
MainUIWindow_GuiContextMenu(GuiHwnd, CtrlHwnd, EventInfo, IsRightClick, X, Y)
{
	MainUIWindow.OnCtrlRightClick(GuiHwnd, CtrlHwnd, EventInfo, IsRightClick, X, Y)
	
}
MainLink1()
{
	if(WinExist("Hot Key Speak Options"))
	{
		return
	}
	o := New OptionsDialog()
	o.ShowModal()
	
}
MainLink2()
{
	MainUIWindow.m_TV.SaveTree()
	FlashWindow(hMainUIWindow,true)
}
MainLink3()
{
	SaveWindowPos(hMainUIWindow, "MainUI")
	Cleanup(0,0)
	MainUIWindow.m_TV.SaveTree()
	Reload
	Sleep , 5000
}
MainLink4()
{
	run, https://github.com/icuurd12b42/HotKeySpeak/graphs/community
}
MainLink5()
{
	DoHelp("MainUI")
}
DebugConsoleHelp()
{

	ControlGet, SelText, Selected,,,ahk_id %hDebugWindow_TextBox_Control% 
	
	if(SelText!="")
	{
		DoHelp("DebugConsole&Code=Coding" . SelText)
	}
	else
	{
		DoHelp("DebugConsole")
	}

	
}
#IfWinActive , Hot Key Speak Debug Console
F1::
DebugConsoleHelp()
#if
return
#IfWinActive , Hot Key Speak Options
F1::
OptionsLink1()
#if
return
#IfWinActive , Hot Key Speak
F1::
MainLink5()
#if
return