;The global Name/Handlers for controls

global EditGroupDialog_
global iEditGroupDialog
global EditGroupDialog_GroupName_TextBox
global EditGroupDialog_StatusBar

        
global EditGroupDialog_OkButton
global EditGroupDialog_CancelButton

global EditGroupDialog_SepLine1
global EditGroupDialog_SepLine2
global EditGroupDialog_Width
global EditGroupDialog_Height

global GroupLink1

global EditGroupDialog_Enabled

Class EditGroupDialog
{
    m_TVItem :=
	static m_TimeStamp :=
	static m_OldCode :=
	m_hWnd :=
	m_JustShown :=
	ShowModal()
	{
		gEditing := true
		;disable the main ui window
		Winset, Disable,, Hot Key Speak
		;show myself
		last:=a_defaultgui
		Gui, EditGroupDialog_:Default
		
		;Gui, Show , w500 h200, Edit Group
		;iEditGroupDialog.OnDoneResize(500, 200)
		arr:= ReadWindowPos("GroupEditUI")
		X:=arr["X"]
		Y:=arr["Y"]
		Width:=arr["Width"]
		Height:=arr["Height"]
		this.m_JustShown := 10
		Gui, Show , x%X% y%Y% w%Width% h%Height% , Edit Group
		hGroupWindow := WinExist("Edit Group")
		this.m_hWnd := hGroupWindow
		MoveWindow(this.m_hWnd,X, Y, Width, Height, 1)


		Gui, +OwnDialogs +OwnDialogs -MinimizeBox
		WinSet, Top, , Edit Group
		
		;sleep ,100
		;send, {tab}{tab}
		Gui, %last%:Default
		
		SetOwner(hGroupWindow,hMainUIWindow)
		EnableWindow(hMainUIWindow,0)
		EnableWindow(hDebugWindow,1)
	}

	;creates the GUI Window
	__New(TVItem, GroupName, Disabled)
	{
		Menu, tray, Icon , %GroupsUIIconFile%
        this.m_TVItem := TVItem
		;set EditGroupDialog_ as target for setting things up
		last:=a_defaultgui
		Gui, EditGroupDialog_:Default
		;allow resize
		Gui, +resize
		Gui, +MinSize500x220
		Gui, Color, %WindowBackColor%
		;Label on top of treeview

        PanelWidth := 440
        PanelHeight := 325
        LabelsWidth := 80

		Gui, Font, c%HeaderFontColor% w%HeaderFontWeight% s%HeaderFontSize%, %HeaderFontName%
		;Label on top of treeview	
		Gui, Add, Text, section x10 , Group
		

		HelpIco := A_ScriptDir . "\Graphics\Icons\Help.ico"
		Gui, Add, Picture, x300 yp w%LinkIconSize% h-1 vGroupLink1 gGroupLink1 HWNDhGroupLink1, %HelpIco%

 		SepLine := A_ScriptDir . "\Graphics\Images\sepline.png"
		Gui, Add, Picture, section x20 w400 vEditGroupDialog_SepLine1, %SepLine%

		buf:="  "
		Gui, Font, c%LabelFontColor% w%LabelFontWeight% s%LabelFontSize%, %LabelFontName%
        Gui, Add, Text, r1 -wrap section x20, Name:%buf%
		Gui, Add, Text, r1 -wrap, %buf%

		Gui, Color,, %TextBoxBackColor%
		Gui, Font, c%TextBoxFontColor% w%TextBoxFontWeight% s%TextBoxFontSize%, %TextBoxFontName%
		Gui, Add, Edit, section ys r1 -wrap w400 vEditGroupDialog_GroupName_TextBox, %GroupName%

		chk := "checked"
		if(Disabled)
		{
			chk := ""
		}
		Gui, Font, c%LabelFontColor% w%LabelFontWeight% s%LabelFontSize%, %LabelFontName%
		Gui,Add,Checkbox,vEditGroupDialog_Enabled %chk% xs,Enabled
            
		
		Gui, Color,, %ButtonBackColor%
		Gui, Font, c%ButtonFontColor% w%ButtonFontWeight% s%ButtonFontSize%, %ButtonFontName%
     
	 	Gui, Add, Picture, section x20 w400 vEditGroupDialog_SepLine2, %SepLine%

		t:="  OK  "
        Gui, Add, Button, ys +Default vEditGroupDialog_OkButton gEditGroupDialog_OkButton, %t%
		t:=" Cancel "
        Gui, Add, Button, ys +Cancel  vEditGroupDialog_CancelButton gEditGroupDialog_CancelButton, %t%



		;Status Bar
		Gui, Font, c%StatusFontColor% w%StatusFontWeight% s%StatusFontSize%, %StatusFontName%
		t := " Groups allow you to classify items."
		Gui, Add, Text, section xs R1 vEditGroupDialog_StatusBar , %t%

		;reset the default
		Gui, %last%:Default
        iEditGroupDialog := this

		iEditGroupDialog.PrepWatching()
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
        GuiControlGet, EditGroupDialog_GroupName_TextBox 
		if(!StringHelper.IsValidName(EditGroupDialog_GroupName_TextBox))
		{
			MsgBox , 4160 , Edit Group Name, That Group Name is not Valid! `nExample Names: AName, AName01, A_Name, A_Name_01
			return
		}
		;Duplicate group names are allowed
		;item:=MainUITreeview_Control_Instance.ItemNameOnBranch(this.m_TVItem, EditGroupDialog_GroupName_TextBox,true)
		;if(item && item != this.m_TVItem)
		;{
		;	MsgBox , 4160 , Edit Group Name, That Name is already taken on that Branch!
		;	return
		;}
		GuiControlGet, EditGroupDialog_Enabled
		MainUITreeview_Control_Instance.OnChangeGroupItem(this.m_TVItem
						,EditGroupDialog_GroupName_TextBox
						,!EditGroupDialog_Enabled)

		this.OnGUIClose()
		return
	}
	;GUI Close event
	OnGUIClose()
	{
		SaveWindowPos(this.m_hWnd, "GroupEditUI")
		Menu, tray, Icon , %MainUIIconFile%
		;Winset, Enable,, Hot Key Speak
		;WinActivate, Hot Key Speak
		EnableWindow(hMainUIWindow,1)
		ShowWindow(hMainUIWindow,5)
		
		;Destroy this dialog
		last:=a_defaultgui
		Gui, EditGroupDialog_:Default
		Gui, Destroy  
		;cleanup
		iEditGroupDialog := 0
		Gui, %last%:Default
		gEditing := false
	}
	
	;Window Resize event
	OnResize(Width, Height)
	{
		
		EditGroupDialog_Width := Width
		EditGroupDialog_Height := Height
		SetTimer, EditGroupDialog_DoneResize, 200
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
		Gui, EditGroupDialog_:Default
		GuiControlGet, StatusPos,Pos, EditGroupDialog_StatusBar
		GuiControlGet, CancelPos,Pos, EditGroupDialog_CancelButton
		GuiControlGet, OKPos,Pos, EditGroupDialog_OkButton
		
		GuiControlGet, CNPos,Pos, EditGroupDialog_GroupName_TextBox
		
		GuiControlGet, GroupLink1Pos,Pos, GroupLink1
		
		GuiControl, MoveDraw, EditGroupDialog_StatusBar, % "X0 Y" . (Height - StatusPosH)
		GuiControl, MoveDraw, EditGroupDialog_CancelButton, % "X" . (Width-CancelPosW-sep-sep) . " Y" . (Height - StatusPosH - CancelPosH - sep)
		GuiControl, MoveDraw, EditGroupDialog_OkButton, % " X" . (Width-CancelPosW-sep-sep-OKPosW-sep) . " Y" . (Height - StatusPosH - OKPosH - sep)
		GuiControl, MoveDraw, EditGroupDialog_SepLine2, % "Y" . (Height - StatusPosH - OKPosH - sep - sep) . " W" . (Width - 40)
		GuiControl, MoveDraw, EditGroupDialog_GroupName_TextBox, % "W" . (Width-CNPosX-sep-sep)

		GuiControl, MoveDraw, GroupLink1, % "X" . (Width-GroupLink1PosW-sep-sep)

		GuiControl, MoveDraw, EditGroupDialog_SepLine1, % " W" . (Width - 40)

		Gui, %last%:Default
		return
	}
}


;All events dispatched to the class function

EditGroupDialog_OkButton()
{
    return iEditGroupDialog.OnOKPressed()
}
EditGroupDialog_CancelButton()
{
    return iEditGroupDialog.OnGuiClose()
}
EditGroupDialog_GuiClose()
{  
    return iEditGroupDialog.OnGuiClose()
}
;Escape dialog
EditGroupDialog_GuiEscape()
{  
	return iEditGroupDialog.OnGuiClose()
}


EditGroupDialog_GuiSize(GuiHwnd, EventInfo, Width, Height)
{
	; The window has been minimized.  No action needed.
	if(EventInfo <> 1)
	{
		iEditGroupDialog.OnResize(Width, Height)	
	}
	return
}
GroupLink1()
{
	DoHelp("GroupUI")
}
return
EditGroupDialog_DoneResize:
{

	iEditGroupDialog.OnDoneResize(EditGroupDialog_Width, EditGroupDialog_Height)
	SetTimer, EditGroupDialog_DoneResize, Off
}
return

#IfWinActive , Edit Group
F1::
GroupLink1()
#if
return