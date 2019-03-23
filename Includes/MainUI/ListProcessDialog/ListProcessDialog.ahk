;This hybrid mix of global and class is weird, but here's a reminder
; ListProcessDialog is the class name, used to set-up and preform actions
; ListProcessDialog_ is the Window Name
; ListProcessDialog_ControlName is the name convention for the controls that need to receive events
;    vListProcessDialog_ControlName and gListProcessDialog_ControlName and ListProcessDialog_ControlName() for the event handling
;The global Name/Handlers for controls
global ListProcessDialog_ListView :=
global ListProcessDialog_StatusBar :=
global ListProcessDialog_ChoseFileButton :=
global ListProcessDialog_
global ListProcessDialog_FindWindowButton
global ProcessLink1
;Class ListProcessDialog
;   Creates and show a Process Viewer window
;   Calls the MainUI function to add a new App to it's list on double click and closes
;
Class ListProcessDialog
{
	static Icons :=
	static m_LastItem :=0
	static m_FoundWindow :=
	static m_hWnd :=
	static m_FlashTime :=
	static m_Target :=
	static m_Owner :=
	
    ShowModal(Owner)
	{
		gEditing := true
		ListProcessDialog.m_FlashTime:=0
		ListProcessDialog.m_FoundWindow := -1
		;disable the main ui window


		arr:= ReadWindowPos("ListProcessUI")
		X:=arr["X"]
		Y:=arr["Y"]
		Width:=arr["Width"]
		Height:=arr["Height"]
		this.m_JustShown := 10
		Gui, ListProcessDialog_:Show , x%X% y%Y% w%Width% h%Height% , Select Application From Running Processes
		hProcessWindow := WinExist("Select Application From Running Processes")
		this.m_hWnd := hProcessWindow
		MoveWindow(this.m_hWnd,X, Y, Width, Height, 1)

		WinSet, Top, , Select Application From Running Processes
		Gui, ListProcessDialog_:+OwnDialogs
		ListProcessDialog.m_LastItem :=0
		;sleep, 200
		;send,{down}{down}{down}

		SetOwner(hProcessWindow,Owner)
		EnableWindow(Owner,0)
		this.m_Owner := Owner
		sleep 100
		send {down}
	}

	;creates the Main GUI Window
	Create(Target)
	{
		ListProcessDialog.m_Target := Target
		Menu, tray, Icon , %ProcessUIIconFile%
		ListProcessDialog.m_LastItem :=0
		;set ListProcessDialog_ as target for setting things up
		last:=a_defaultgui
		Gui, ListProcessDialog_:Default
		;allow resize

		Gui, +resize +OwnDialogs -MinimizeBox
		
		Gui, Color, %WindowBackColor%

		;Label on top of treeview	
		Gui, Font, c%HeaderFontColor% w%HeaderFontWeight% s%HeaderFontSize%, %HeaderFontName%
		Gui, Add, Text, section x10 , Running Processes:


		Gui, Color,, %ButtonBackColor%
		Gui, Font, c%ButtonFontColor% w%ButtonFontWeight% s%ButtonFontSize%, %ButtonFontName%
		txt := " File... "
		t:=" Find Window "
		;Gui, Add, Button, ys+300 vListProcessDialog_FindWindowButton gListProcessDialog_FindWindowButton, %t%
		;Gui, Add, Button, ys+400 vListProcessDialog_ChoseFileButton gListProcessDialog_ChoseFileButton, %txt%
		FindWindowIco := A_ScriptDir . "\Graphics\Icons\FindWindow.ico"
		Gui, Add, Picture, x300 yp w%LinkIconSize% h-1 vListProcessDialog_FindWindowButton gListProcessDialog_FindWindowButton HWNDhListProcessDialog_FindWindowButton, %FindWindowIco%
		
		EllipsisIco := A_ScriptDir . "\Graphics\Icons\Ellipsis.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vListProcessDialog_ChoseFileButton gListProcessDialog_ChoseFileButton HWNDhListProcessDialog_ChoseFileButton, %EllipsisIco%

		HelpIco := A_ScriptDir . "\Graphics\Icons\Help.ico"
		Gui, Add, Picture, x+m w%LinkIconSize% h-1 vProcessLink1 gProcessLink1 HWNDhProcessLink1, %HelpIco%

		
		;the icons list to use in the treeview
		ListProcessDialog.Icons := IL_Create(10,10,ListViewLargeIcons)

		
		;stub icons
		;from dll or exe
		;Loop 10  ; Load the ImageList with some standard system icons.
		;	IL_Add(ListProcessDialog.Icons, "shell32.dll", A_Index)
		;from ico file
		;IL_Add(ListProcessDialog.Icons, "Graphics\HotKeySpeak.ico", 2) 
		
		;listview
		; Create the ListView with two columns, Name and Size:
		Gui, Font, c%ListViewFontColor% w%ListViewFontWeight% s%ListViewFontSize%, %ListViewFontName%
		Gui, Add, ListView, background%ListViewBackColor% x0 r20 w700 -hdr -Multi AltSubmit -HScroll vListProcessDialog_ListView gListProcessDialog_ListView, Window|Application|Path
		
		Gui, Add, Button, y+m +Default w80 h10 gListProcessDialog_ENTERButton, ENTER
	    GuiControl, Hide, ENTER
		LV_SetImageList(ListProcessDialog.Icons,1)
		
		;Gather a list of all processes path
		WinGet, all, list
		;loop through list
		ImageIndex := 1
		Colors := "red,green,blue"
		
				
		Loop, %all%
		{
			Try
			{
				;get the path
				WinGet, PPath, ProcessPath, % "ahk_id " all%A_Index%
				WinGet, hwnd, ID, % "ahk_id " all%A_Index%

				;PID:=A_Index
				;hwnd := WinActive("ahk_id " . PID)
				;WinGetClass, title , ahk_id %hwnd%
				WinGetTitle, title, ahk_id %hwnd%
				Array := StrSplit(title , "-")
				title := StringHelper.LeadTrim(Array[Array.MaxIndex()])
				;Array := StrSplit(title , chr("0x2014"))
				;title := Array[Array.MaxIndex()]

				;get component parts of the path
				SplitPath, PPath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
				if(title ="")
				{
					title :=OutNameNoExt
				}
				;check if not in listview already
				;if(ListProcessDialog.Find(OutFileName) == 0)
				if(ListProcessDialog.Find(title) == 0)
				{
					;load the icon from exe
					hicon := LoadPicture(PPath, "Icon1")
					
					;if not failed loading
					;if(hicon <> 0)
					{
						;add icon. reload it in image since the documented HICON method fails
						;IL_Add(ListProcessDialog.Icons, HICON:%hicon%) ;compile fail yet document sais it should work
						if(hicon == 0)
						{
							if(InStr(PPath, "WindowsApps"))
							{
								IL_Add(ListProcessDialog.Icons, "Graphics\Icons\Windows10App.ico", 1)
							}
							else if (InStr(PPath, "SystemApps"))
							{
								IL_Add(ListProcessDialog.Icons, "Graphics\Icons\Windows10App.ico", 1)
							}
							else if (InStr(PPath, "ApplicationFrameHost"))
							{
								IL_Add(ListProcessDialog.Icons, "Graphics\Icons\Windows10App.ico", 1)
							}
							else if (InStr(PPath, "ApplicationFrameHost"))
							{
								IL_Add(ListProcessDialog.Icons, "Graphics\Icons\Windows10App.ico", 1)
							}
							else if (InStr(PPath, "\Windows\"))
							{
								IL_Add(ListProcessDialog.Icons, "Graphics\Icons\Windows10App.ico", 1)
							}
							else
							{
								IL_Add(ListProcessDialog.Icons, "Graphics\Icons\noicon.ico", 1)
							}
						}
						else
						{
							IL_Add(ListProcessDialog.Icons, PPath, 1)
						}
						;Add the treeview item
						
						LV_Add("Icon" . ImageIndex, title, OutFileName, OutDir)
						ImageIndex:=ImageIndex+1
					}
				}
			}
			catch e  ; Handles the first error/exception raised by the block above.
			{
				break
			}
		}
		
				
		LV_ModifyCol()  ; Auto-size each column to fit its contents.
		LV_ModifyCol(1,"Sort")
		LV_Modify(1, "+Select")
		
		Gui, Font, c%StatusFontColor% w%StatusFontWeight% s%StatusFontSize%, %StatusFontName%
		t := " Double Click on Application to add. Use File Browser to select from disk."
		Gui, Add, Text, section xs R1 W1000 vListProcessDialog_StatusBar , %t%
		
		;reset the default
		Gui, %last%:Default
	}
	;Finds if entry is in the listview
	Find(entry)
	{
		out := ""
		Loop % LV_GetCount()
		{
			;LV_GetText(RetrievedText, A_Index,2)
			LV_GetText(RetrievedText, A_Index,1)
			;Debug.WriteStackPushPop(RetrievedText . " == " . entry, Debug.ErrLevelImportant)
			if(RetrievedText = entry)
			{
				return 1
			}
			
		}
		return 0
	}
	;Window Resize event
	OnResize(Width, Height)
	{
		;last:=a_defaultgui
		;Gui, ListProcessDialog_:Default
		;GuiControl, Move, ListProcessDialog_ListView, % "H" . (Height - 58) . " W" . (Width)
		;Gui, %last%:Default


		last:=a_defaultgui
		Gui, ListProcessDialog_:Default
		GuiControlGet, StatusPos,Pos, ListProcessDialog_StatusBar
		GuiControlGet, TreePos,Pos, ListProcessDialog_ListView

		GuiControlGet, SelFilePos,Pos, ListProcessDialog_ChoseFileButton
		GuiControlGet, FindWinPos,Pos, ListProcessDialog_FindWindowButton
		GuiControlGet, ProcessLink1Pos,Pos, ProcessLink1

		GuiControl, Move, ListProcessDialog_StatusBar, % "X0 Y" . (Height - StatusPosH)
		GuiControl, Move, ListProcessDialog_ListView, % "H" . (Height - TreePosY - StatusPosH) . " W" . (Width)
		sep :=5
		GuiControl, Move, ProcessLink1, % "X" . (Width-ProcessLink1PosW - sep)
		
		GuiControl, Move, ListProcessDialog_ChoseFileButton, % "X" . (Width - SelFilePosW -sep - ProcessLink1PosW-sep)
		GuiControl, Move, ListProcessDialog_FindWindowButton, % "X" . (Width - SelFilePosW - sep - SelFilePosW -sep -ProcessLink1PosW-sep)
		

		GuiControl, +Redraw, ProcessLink1
		GuiControl, +Redraw, ListProcessDialog_ChoseFileButton
		GuiControl, +Redraw, ListProcessDialog_FindWindowButton

		Gui, %last%:Default



		return
	}
	;ListView events
	OnListViewEvents(Ev,LVItem)
	{
		if (Ev = "DoubleClick")
		{
			if(LVItem)
			{
				last:=a_defaultgui
				Gui, ListProcessDialog_:Default
				LV_GetText(ExeName, LVItem,2)  ; Get the text from the row's first field.
				LV_GetText(ExePath, LVItem,3)
				LV_GetText(AppName, LVItem,1)
				Gui, %last%:Default
				if("ApplicationFrameHost.exe" == ExeName || InStr(ExePath, "WindowsApps", false))
				{
					ListProcessDialog.m_Target.AddProcess("ApplicationFrameHost.exe", "Windows Apps")
					ListProcessDialog.m_Target.AddWinAppProcess(AppName)
				}
				else
				{
					ListProcessDialog.m_Target.AddProcess(ExePath . "\" . ExeName, AppName)
				}
				ListProcessDialog_GuiClose()
			}
			;ToolTip You double-clicked row number %A_EventInfo%. Text: "%RowText%"
		}
		return
	}
	;GUI Close event
	OnGUIClose()
	{
		SaveWindowPos(this.m_hWnd, "ListProcessUI")
		Menu, tray, Icon , %MainUIIconFile%

		EnableWindow(this.m_Owner,1)
		ShowWindow(this.m_Owner,5)
		if(this.m_Owner == hMainUIWindow)
		{
			gEditing := false
		}
		
		

		;Destruct the process viewer window
		last:=a_defaultgui
		Gui, ListProcessDialog_:Default
		Gui, Destroy  
		;cleanup
		ListProcessDialog_Listview := 0
		ListProcessDialog_StatusBar := 0
		ListProcessDialog.Icons := 0
		SetTimer, ListProcessDialog_FindWindowTimer, Off
		Gui, %last%:Default
		
		
	}
	OnFindWindowStart()
	{
		ListProcessDialog.m_hWnd := WinExist()
		ListProcessDialog.m_FlashTime := 0
		ListProcessDialog.m_FoundWindow := -1
	}
	OnFindWindowTimer()
	{
		if(ListProcessDialog.m_FlashTime == 0)
		{
			DllCall( "FlashWindow", UInt, ListProcessDialog.m_hWnd, Int,True )
		}
		ListProcessDialog.m_FlashTime += 100
		if(ListProcessDialog.m_FlashTime >= 500)
		{
			ListProcessDialog.m_FlashTime := 0
		}
		if(GetKeyState("LControl" , "P"))
		{
			if(!ProcessMonitor.IsWindowMine())
			{
				ListProcessDialog.m_FoundWindow := ProcessMonitor.GetActiveWindowhWnd()
				last:=a_defaultgui
				Gui, ListProcessDialog_:Default

				WindowTitle:=ProcessMonitor.GetActiveWindowTitle()
				FullPath:=ProcessMonitor.GetProcessPath()
				Gui, %last%:Default
				;ListProcessDialog.m_Target.AddProcess(FullPath)
				SplitPath, FullPath , ExeName, ExePath, OutExtension, OutNameNoExt, OutDrive
				if("ApplicationFrameHost.exe" == ExeName || InStr(FullPath, "WindowsApps", false))
				{
					ListProcessDialog.m_Target.AddProcess("ApplicationFrameHost.exe", "Windows Apps")
					ListProcessDialog.m_Target.AddWinAppProcess(WindowTitle)
				}
				else
				{
					ListProcessDialog.m_Target.AddProcess(ExePath . "\" . ExeName, WindowTitle)
				}

				DllCall( "FlashWindow", UInt, ListProcessDialog.m_hWnd, Int,false )
				ListProcessDialog.OnGuiClose()
				return
			}
			hwnd := ListProcessDialog.m_hWnd
			WinActivate , ahk_id %hwnd%
			SetTimer, ListProcessDialog_FindWindowTimer, Off
			DllCall( "FlashWindow", UInt, ListProcessDialog.m_hWnd, Int,false )

			;last:=a_defaultgui
			;Gui, MainUIWindow_:Default
			;TV_Modify(ListProcessDialog.m_TVItem,"Select")
			;Gui, %last%:Default
		}
	}
}


;All events dispatched to the class function

ListProcessDialog_GuiSize(GuiHwnd, EventInfo, Width, Height)
{
	; The window has been minimized.  No action needed.
	if(EventInfo <> 1)
	{
		ListProcessDialog.OnResize(Width, Height)	
	}
	return
}
ListProcessDialog_ListView()
{
	
	
	
	if A_GuiEvent = I
	{
		ListProcessDialog.m_LastItem := A_EventInfo
		
	}
	if A_GuiEvent = DoubleClick
	{
		return ListProcessDialog.OnListViewEvents("DoubleClick",ListProcessDialog.m_LastItem)
	}	
}

ListProcessDialog_GuiClose()
{  
	return ListProcessDialog.OnGuiClose()
}
ListProcessDialog_GuiEscape()
{  
	return ListProcessDialog.OnGuiClose()
}

ListProcessDialog_ENTERButton()
{
    ListProcessDialog.OnListViewEvents("DoubleClick",ListProcessDialog.m_LastItem)
}
ListProcessDialog_ChoseFileButton()
{
	
	FileSelectFile, SelectedFile, 3, , Select Application From File, Program Files (*.exe)
	if(SelectedFile)
	{
		;ListProcessDialog.m_Target.AddProcess(SelectedFile)
		SplitPath, SelectedFile , ExeName, ExePath, OutExtension, OutNameNoExt, OutDrive
		
		if("ApplicationFrameHost.exe" == ExeName || InStr(SelectedFile, "WindowsApps", false))
		{
			ListProcessDialog.m_Target.AddProcess("ApplicationFrameHost.exe", "Windows Apps")
			ListProcessDialog.m_Target.AddWinAppProcess(OutNameNoExt)
		}
		else
		{
			ListProcessDialog.m_Target.AddProcess(ExePath . "\" . ExeName, OutNameNoExt)
		}
		ListProcessDialog_GuiClose()
	}
}

ListProcessDialog_FindWindowButton()
{
	ListProcessDialog.OnFindWindowStart()
	MsgBox , 4160 , Find Window, Navigate to the Application on the Desktop you wish to add and tap the Left Ctrl on the Keyboard.`n`nPress OK to Start!
	SetTimer, ListProcessDialog_FindWindowTimer, 100
}

ListProcessDialog_FindWindowTimer()
{
	ListProcessDialog.OnFindWindowTimer()
}
ProcessLink1()
{
	DoHelp("ListProcess")
}

#IfWinActive , Select Application From Running Processes
F1::
ProcessLink1()
#if
return