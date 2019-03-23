;The global Name/Handlers for controls

global OptionsDialog_
global iOptionsDialog
global OptionsDialog_OptionsName_TextBox
global OptionsDialog_StatusBar

        
global OptionsDialog_OkButton
global OptionsDialog_CancelButton

global OptionsDialog_SepLine1
global OptionsDialog_SepLine2
global OptionsDialog_SepLine3
global OptionsDialog_SepLine4
global OptionsDialog_SepLine5
global OptionsDialog_SepLine6
global Options_DebugDD
global Options_DebugLogFile
global OptionsDialog_Width
global OptionsDialog_Height


global OptionsSAPIButton

global Options_VoiceDD
global Options_VoiceVolume
global OptionsLink1

global OptionsMaxErrSlider
global OptionsThresholdSlider
global OptionsConfText

global OptionsErrPMText

global OptionsRight1Text
global OptionsRight2Text
global OptionsRight3Text
global OptionsRight4Text
global OptionsRight5Text
global OptionsRight6Text
global OptionsEnableSAPI
global OptionsSapiEnableHoldCheck
global OptionsSapiHoldKeyEB
global OptionsSapiHoldIsLabel
global OptionsSapiHoldUpOrDownDD
global OptionsIgnoreIssuesCheck
global OptionsSAPILive
global OptionsHotKeyPauseCheck
global OptionsHotKeyToggleKeyEB
global OptionsSapiPauseCheck
global OptionsSapiToggleKeyEB

global OptionsHKEnabled
global OptionsTempFolder
global Options_VoiceRate
Class OptionsDialog
{
    m_hWnd :=
	m_JustShown :=
	ShowModal()
	{
		gEditing := true
		;disable the main ui window
		Winset, Disable,, Hot Key Speak
		;show myself
		last:=a_defaultgui
		Gui, OptionsDialog_:Default
		
		
		arr:= ReadWindowPos("OptionsUI")
		X:=arr["X"]
		Y:=arr["Y"]
		Width:=arr["Width"]
		Height:=arr["Height"]
		this.m_JustShown := 10
		Gui, Show , x%X% y%Y% autosize , Hot Key Speak Options
		hOptionsWindow := WinExist("Hot Key Speak Options")
		this.m_hWnd := hOptionsWindow
		;MoveWindow(this.m_hWnd,X, Y, Width, Height, 1)


		Gui, +OwnDialogs
		WinSet, Top, , Options
		
		;sleep ,100
		;send, {tab}{tab}
		Gui, %last%:Default
		
		SetOwner(hOptionsWindow,hMainUIWindow)
		EnableWindow(hMainUIWindow,0)
		EnableWindow(hDebugWindow,1)
	}

	;creates the GUI Window
	__New()
	{
		iOptionsDialog := this
		Menu, tray, Icon , %OptionsUIIconFile%
        ;set OptionsDialog_ as target for setting things up
		last:=a_defaultgui
		Gui, OptionsDialog_:Default
		;allow resize
		Gui, -resize +OwnDialogs -MinimizeBox
		;Gui, +MinSize500x200
		Gui, Color, %WindowBackColor%
		;Label on top of treeview

        PanelWidth := 440
        PanelHeight := 325
        LabelsWidth := 80

		Gui, Font, c%HeaderFontColor% w%HeaderFontWeight% s%HeaderFontSize%, %HeaderFontName%
		;Label on top of treeview	
		Gui, Add, Text, section x10 , Options

		HelpIco := A_ScriptDir . "\Graphics\Icons\Help.ico"
		Gui, Add, Picture, x300 yp w%LinkIconSize% h-1 vOptionsLink1 gOptionsLink1 HWNDhOptionsLink1, %HelpIco%

 		SepLine := A_ScriptDir . "\Graphics\Images\sepline.png"
		Gui, Add, Picture, section x20 w400 vOptionsDialog_SepLine1, %SepLine%

		buf:="  "
		Gui, Font, c%LabelFontColor% w%LabelFontWeight% s%LabelFontSize%, %LabelFontName%
    ;HotKeys Option
		Gui, Add, Text, r1 -wrap section x20, HotKeys%buf%
			check := ""
			if(!gHKDisabled)
			{
				check := "checked"
			}
			Gui, Add, Checkbox, %check% x40 vOptionsHKEnabled, Enable Keyboard Hot Keys
	
    ;Hot Key Pause
		check := ""
		if(gHKAllowKeyPausing)
		{
			check := "checked"
		}
		Gui, Add, Checkbox, %check% x360 yp vOptionsHotKeyPauseCheck, Toggle With

		GuiControlGet, zePos,Pos, OptionsHotKeyPauseCheck

		Gui, Add, Edit, r1 -wrap xp+%zePosW% yp-3  w80 vOptionsHotKeyToggleKeyEB, %gHKPausingKey%

		GuiControlGet, zePos,Pos, OptionsHotKeyToggleKeyEB
        zePosW += 3
		Gui, Add, Text, r1 -wrap xp+%zePosW% yp+3, Key

		Gui, Add, Picture, section x20 w400 vOptionsDialog_SepLine2, %SepLine%

	;SAPI Enabled and Mode
		Gui, Add, Text, r1 -wrap section x20, Speech Recognition%buf%
		
			check := ""
			if(!gSAPIPaused)
			{
				check := "checked"
			}
			Gui, Add, Checkbox, %check% x40 vOptionsEnableSAPI, Enable Speech Recognition

	;Sapi Pause
		check := ""
		if(gAllowSapiKeyPausing)
		{
			check := "checked"
		}
		Gui, Add, Checkbox, %check% x360 yp vOptionsSapiPauseCheck, Toggle With

		GuiControlGet, zePos,Pos, OptionsSapiPauseCheck

		Gui, Add, Edit, r1 -wrap xp+%zePosW% yp-3  w80 vOptionsSapiToggleKeyEB, %gSapiPausingKey%

		GuiControlGet, zePos,Pos, OptionsSapiToggleKeyEB
        zePosW += 3
		Gui, Add, Text, r1 -wrap xp+%zePosW% yp+3, Key
			
			check := ""
			if(gSAPILiveRecognition)
			{
				check := "checked"
			}
			Gui, Add, Radio, %check% x60 vOptionsSAPILive, Recognize as I Speak (Faster, Less Accurate)
			check := ""
			if(!gSAPILiveRecognition)
			{
				check := "checked"
			}
			Gui, Add, Radio, %check% x60, Recognize When I Stop Speaking (Slower, More Accurate)

	;SAPI Hold Key
		check := ""

		if(gAllowSapiHoldKey)
		{
			check := "checked"
		}
		Gui, Add, Checkbox, %check% x40 vOptionsSapiEnableHoldCheck, Hold when

		GuiControlGet, zePos,Pos, OptionsSapiEnableHoldCheck

		Gui, Add, Edit, r1 -wrap xp+%zePosW% yp-3  w80 vOptionsSapiHoldKeyEB, %gSapiHoldKey%

		GuiControlGet, zePos,Pos, OptionsSapiHoldKeyEB
        zePosW += 3
		Gui, Add, Text, r1 -wrap xp+%zePosW% yp+3 vOptionsSapiHoldIsLabel, is

		GuiControlGet, zePos,Pos, OptionsSapiHoldIsLabel
        zePosW += 3

		v:=gSapiHoldOnDownOrOnUp+1
		Gui, Add, DropDownList, xp+%zePosW% yp-3 w80 AltSubmit  vOptionsSapiHoldUpOrDownDD Choose%v%, Down|Up

        GuiControlGet, zePos,Pos, OptionsSapiHoldUpOrDownDD
        zePosW += 3
		Gui, Add, Text, r1 -wrap xp+%zePosW% yp+3, (Discord Push To Talk Mirror)

		Gui, Add, Picture, section x20 w400 vOptionsDialog_SepLine3, %SepLine%
		

	;SAPI Options
		buf2:=" "
		Gui, Add, Text, r1 -wrap section x20, Speech Refinements %buf%

		check := ""
		if(gSAPIIgnoreProblem)
		{
			check := "checked"
		}
		Gui, Add, Checkbox, %check% vOptionsIgnoreIssuesCheck x40, Ignore Noise Issues
 
		v1:= "" . floor(gSAPIMaxErrorCount)
		v2:= "" . floor(clamp(gSAPIErrorAvg,0,30))
		v3:= "" . floor(gSAPIMinThreshold * 100) . "%"
		v4:= "" . floor(gSAPIConfidenceAvg * 100) . "%"
		Gui,Add,Text, x0 y0 w50 vOptionsRight1Text, %v1%
		Gui,Add,Text, x0 y0 w50 vOptionsRight3Text, %v3%
		

		;Min errors per minutes
			val := floor(gSAPIMaxErrorCount)
			txt := "Errors/Minute (Tolerance/Avg):"
			Gui, Add, Text, r1 -wrap section x40 vOptionsErrPMText, %txt%%buf2%
			
			Gui, Add, Slider, x60 Buddy2OptionsRight1Text Range0-30 AltSubmit TickInterval3 vOptionsMaxErrSlider gOptionsMaxErrSlider, %gSAPIMaxErrorCount%
			GuiControlGet, zePos,Pos, OptionsMaxErrSlider
			zePosX+=8
			zePosW-=16
			xxx:=zePosX	
			avg := clamp(gSAPIErrorAvg,0,30)
			avgMaxed := clamp(gSAPIErrorAvg,0,gSAPIMaxErrorCount)
			red := floor(avgMaxed/gSAPIMaxErrorCount * 0xFF)
			green := floor((1-avgMaxed/gSAPIMaxErrorCount) * 0xFF)
			;red := 0xFF ;0xFF
			;green := 0x00 ;0xFF
			blue := 0x00
			col := (red << 16) + (green << 8) + blue
			
			col := ValToHexStr(col)
			
			
			Gui, Add, Progress, Range0-30 x%zePosX% w%zePosW% h4 y+m c%col%, %avg% ;vMyProgress
			

			GuiControlGet, zePos,Pos, OptionsRight1Text

			hh:=zePosH/2

			Gui,Add,Text, x%zePosX%+m yp-%hh% w%zePosW% vOptionsRight2Text, %v2%

		

		;CONFIDENCE LEVEL
			val := floor(gSAPIMinThreshold * 100)
			val2 := floor(gSAPIConfidenceAvg * 100)
			txt := "Confidence (Threshold/Avg): "
			Gui, Add, Text, r1 x360 -wrap section ys vOptionsConfText, %txt%%buf2%

			
			Gui, Add, Slider, xp+20 y+m Buddy2OptionsRight3Text Range0-100 AltSubmit TickInterval10 vOptionsThresholdSlider gOptionsThresholdSlider, %val%
			GuiControlGet, zePos,Pos, OptionsThresholdSlider

			zePosX+=8
			zePosW-=16

			avg := clamp(gSAPIConfidenceAvg,0,1)
			avgMaxed := clamp(gSAPIConfidenceAvg,0,gSAPIMinThreshold)
			lval := (avgMaxed/gSAPIMinThreshold) ** 8
			
			red := floor((1- lval) * 0xFF)
			green := floor((lval) * 0xFF)
			;red := 0xFF ;0xFF
			;green := 0x00 ;0xFF
			blue := 0x00
			col := (red << 16) + (green << 8) + blue
			
			col := ValToHexStr(col)

			val := avg * 100
			Gui, Add, Progress, Range0-100 x%zePosX% w%zePosW% h4 y+m c%col%, %val% ;vMyProgress
			
			GuiControlGet, zePos,Pos, OptionsRight3Text

			hh:=zePosH/2

			Gui,Add,Text, x%zePosX%+m yp-%hh% w%zePosW% vOptionsRight4Text, %v4%

		
		
		;SetSysLinkColor(hLink,LinkFontColor)
		static StartText
		txt :="You may want to "
		Gui, Add, Text, r1 -wrap section x%xxx% vStartText, %txt%
		GuiControlGet, zePos,Pos, StartText
		static LinkText
		Gui, Add, Link, xp+%zePosW% yp hwndhLink vLinkText gOptionsSAPIButton, <a>Train MS SAPI</a>
		GuiControlGet, zePos,Pos, LinkText
		txt :=" to reduce errors and fix issues"
		Gui, Add, Text, xp+%zePosW% yp -wrap , %txt%
		
		Gui, Add, Picture, section x20 w400 vOptionsDialog_SepLine4, %SepLine%

	;Text To Speech 
		Gui, Add, Text, r1 -wrap section x20, Text to Speech%buf%
		

		v5 := VoiceAgent.GetSpeakRate()
		v6 := VoiceAgent.GetSpeakVolume()
		percent:="%"
		Gui,Add,Text, x0 y0 w50 vOptionsRight5Text, %v5%
		Gui,Add,Text, x0 y0 w50 vOptionsRight6Text, %v6%%percent%

		Gui, Add, Text, r1 -wrap section x40, Speak Rate:%buf2%
		
		Gui, Add, Slider, xp+20 y+m Range-10-10 AltSubmit Buddy2OptionsRight5Text TickInterval2 vOptions_VoiceRate gOptions_VoiceRate, %v5%


		Gui, Add, Text, r1 -wrap section x360 ys, Voice Volume:%buf2%
		
		Gui, Add, Slider, xp+20 y+m Range0-100 AltSubmit Buddy2OptionsRight6Text TickInterval10 vOptions_VoiceVolume gOptions_VoiceVolume, %v6%

		Gui, Add, Text, r1 -wrap section x40, Voice:%buf2%
		arr := VoiceAgent.GetVoicesDescriptions()
		VoiceOptions := "OFF"
		for each, element in arr
		{
			VoiceOptions.="|" . element
		}
		v:=1
		if(1==VoiceAgent.m_VoiceEnabled)
		{

			v := VoiceAgent.GetVoiceIndex() + 2
		}
		Gui, Add, DropDownList, x200 yp AltSubmit vOptions_VoiceDD Choose%v%, %VoiceOptions%
		
		Gui, Add, Picture, section x20 vOptionsDialog_SepLine5, %SepLine%
		
	;Debug Console
		Gui, Add, Text, r1 -wrap section x20, Debug Console
		Gui, Add, Text, r1 -wrap section x40, Debug Level:%buf2%
		
		;Gui, Font, c%TextBoxFontColor% w%TextBoxFontWeight% s%TextBoxFontSize%, %TextBoxFontName%
		;Gui, Color,, %TextBoxBackColor%
		v:=Debug.GetDebugLevel()+1
		Gui, Add, DropDownList, section x200 ys AltSubmit  vOptions_DebugDD Choose%v%, Everything (Trace)|Core Information|Core Warnings|Useful Information|Coder Information|Critical Information

		check := ""
		if(Debug.GetLogToFile())
		{
			check := "checked"
		}
		Gui, Add, Checkbox, %check% vOptions_DebugLogFile x200 y+m, Log To%buf2%
		GuiControlGet, zePos,Pos, Options_DebugLogFile
		xx:= zePosX+zePosW
		Gui, Add, Link, x%xx% yp hwndhLink2 gOptionsTempFolder, <a>Temp Folder</a>
		Gui, Add, Link, x500 yp hwndhLink3 gOptionsDebugButton, <a>Open Console</a>
		
		




		SetSysLinkColor(hLink,LinkFontColor)
		SetSysLinkColor(hLink2,LinkFontColor)
		SetSysLinkColor(hLink3,LinkFontColor)

		;Gui, Color,, %TextBoxBackColor%
		;Gui, Font, c%TextBoxFontColor% w%TextBoxFontWeight% s%TextBoxFontSize%, %TextBoxFontName%
		;Gui, Add, Edit, section ys r1 -wrap w400 , %OptionsName%
            
		
		Gui, Color,, %ButtonBackColor%
		Gui, Font, c%ButtonFontColor% w%ButtonFontWeight% s%ButtonFontSize%, %ButtonFontName%
     
	 	Gui, Add, Picture, section x20 w400 vOptionsDialog_SepLine6, %SepLine%

		t:="  OK  "
        Gui, Add, Button, ys +Default vOptionsDialog_OkButton gOptionsDialog_OkButton, %t%
		t:=" Cancel "
        Gui, Add, Button, ys +Cancel  vOptionsDialog_CancelButton gOptionsDialog_CancelButton, %t%



		;Status Bar
		Gui, Font, c%StatusFontColor% w%StatusFontWeight% s%StatusFontSize%, %StatusFontName%
		t := "Setup the options to your liking."
		Gui, Add, Text, section xs R1 vOptionsDialog_StatusBar , %t%

		;reset the default
		Gui, %last%:Default
        

		iOptionsDialog.PrepWatching()
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
        ;GuiControlGet, OptionsDialog_OptionsName_TextBox 
		;if(!StringHelper.IsValidName(OptionsDialog_OptionsName_TextBox))
		;{
		;	MsgBox , 4160 , Edit Options Name, That Options Name is not Valid! `nExample Names: AName, AName01, A_Name, A_Name_01
		;	return
		;}
		;Duplicate Options names are allowed
		;item:=MainUITreeview_Control_Instance.ItemNameOnBranch(this.m_TVItem, OptionsDialog_OptionsName_TextBox,true)
		;if(item && item != this.m_TVItem)
		;{
		;	MsgBox , 4160 , Edit Options Name, That Name is already taken on that Branch!
		;	return
		;}
        last:=a_defaultgui
		
		Gui, OptionsDialog_:Default
		GuiControlGet, OptionsMaxErrSlider 
		gSAPIMaxErrorCount := OptionsMaxErrSlider

		GuiControlGet, OptionsThresholdSlider
		gSAPIMinThreshold:= (OptionsThresholdSlider+0) /100

		GuiControlGet, OptionsIgnoreIssuesCheck
		gSAPIIgnoreProblem := OptionsIgnoreIssuesCheck

		GuiControlGet, OptionsEnableSAPI
		gSAPIPaused := !OptionsEnableSAPI


		GuiControlGet, OptionsSapiPauseCheck
		gAllowSapiKeyPausing := OptionsSapiPauseCheck
		GuiControlGet, OptionsSapiToggleKeyEB
		gSapiPausingKey := OptionsSapiToggleKeyEB

		GuiControlGet, OptionsSapiEnableHoldCheck
		gAllowSapiHoldKey := OptionsSapiEnableHoldCheck
		GuiControlGet, OptionsSapiHoldKeyEB
		gSapiHoldKey := OptionsSapiHoldKeyEB

		GuiControlGet, OptionsSapiHoldUpOrDownDD
		gSapiHoldOnDownOrOnUp := OptionsSapiHoldUpOrDownDD-1
		
		

    	
		GuiControlGet, OptionsSAPILive
		gSAPILiveRecognition := OptionsSAPILive

		GuiControlGet,Options_DebugDD
		Debug.SetDebugLevel(Options_DebugDD-1)


		GuiControlGet,Options_DebugLogFile
		Debug.SetLogToFile(Options_DebugLogFile)

		GuiControlGet, OptionsHotKeyPauseCheck
		gHKAllowKeyPausing := OptionsHotKeyPauseCheck
		GuiControlGet, OptionsHotKeyToggleKeyEB
		gHKPausingKey := OptionsHotKeyToggleKeyEB

		GuiControlGet, OptionsHKEnabled
		gHKDisabled := !OptionsHKEnabled
		if(gHKDisabled)
		{
			;HotKeySystem.OnProcessDeactivate(0)
			HotKeySystem.OnItemDeactivate(0)
		}
		Else
		{
			
			;HotKeySystem.OnProcessActivate(HotKeySystem.m_old_process_extra_data)
			;HotKeySystem.OnItemActivate(HotKeySystem.m_old_extra_data)
			HotKeySystem.OnItemActivate(0)
		}

		GuiControlGet,Options_VoiceDD
		if(Options_VoiceDD == 1)
		{
			VoiceAgent.m_VoiceEnabled := 0
		}
		Else
		{
			VoiceAgent.m_VoiceEnabled := 1
			VoiceAgent.SetVoiceIndex(Options_VoiceDD-2)
		}

		GuiControlGet,Options_VoiceRate
		VoiceAgent.SetSpeakRate(Options_VoiceRate+0)
		GuiControlGet,Options_VoiceVolume
		VoiceAgent.SetSpeakVolume(Options_VoiceVolume+0)



		gSAPIConfidenceAvg := gSAPIMinThreshold
		gSAPIWarnedError := false
		gErrorEvents := []

		if(gAllowSapiKeyPausing)
		{
			hk:=gSapiPausingKey
			try
			{
				Hotkey, %hk%, TestHotKeyStub, On
				Hotkey, %hk%, TestHotKeyStub, Off
			}
			catch e 
			{
				Debug.MsgBox("The Speech Recognition Toggle Key is not valid!")
				return
			}
		}
		if(gAllowSapiHoldKey)
		{
			hk:=gSapiHoldKey
			try
			{
				Hotkey, %hk%, TestHotKeyStub, On
				Hotkey, %hk%, TestHotKeyStub, Off
			}
			catch e 
			{
				Debug.MsgBox("The Speech Recognition Hold Key is not valid!")
				return
			}
		}
		
		if(gHKAllowKeyPausing)
		{
			hk:=gHKPausingKey
			try
			{
				Hotkey, %hk%, TestHotKeyStub, On
				Hotkey, %hk%, TestHotKeyStub, Off
			}
			catch e 
			{
				Debug.MsgBox("The Hot Keys Toggle Key is not valid!")
				return
			}
		}
		Gui, %last%:Default

		this.OnGUIClose()
		return
	}
	;GUI Close event
	OnGUIClose()
	{
		SaveWindowPos(this.m_hWnd, "OptionsUI")
		Menu, tray, Icon , %MainUIIconFile%
		;Winset, Enable,, Hot Key Speak
		;WinActivate, Hot Key Speak
		EnableWindow(hMainUIWindow,1)
		ShowWindow(hMainUIWindow,5)
		
		;Destroy this dialog
		last:=a_defaultgui
		Gui, OptionsDialog_:Default
		Gui, Destroy  
		;cleanup
		iOptionsDialog := 0
		Gui, %last%:Default
		gEditing := false
		GlobalEventHandler.ForceReset()
	}
	
	;Window Resize event
	OnResize(Width, Height)
	{
		
		OptionsDialog_Width := Width
		OptionsDialog_Height := Height
		SetTimer, OptionsDialog_DoneResize, 200
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
		Gui, OptionsDialog_:Default
		GuiControlGet, StatusPos,Pos, OptionsDialog_StatusBar
		if(!StatusPosW)
		{
			Gui, %last%:Default
			return
		}
		GuiControlGet, CancelPos,Pos, OptionsDialog_CancelButton
		GuiControlGet, OKPos,Pos, OptionsDialog_OkButton
		
		GuiControlGet, CNPos,Pos, OptionsDialog_OptionsName_TextBox
		
		GuiControlGet, OptionsLink1Pos,Pos, OptionsLink1

		
		
		GuiControl, MoveDraw, OptionsDialog_StatusBar, % "X0 Y" . (Height - StatusPosH)
		GuiControl, MoveDraw, OptionsDialog_CancelButton, % "X" . (Width-CancelPosW-sep-sep) . " Y" . (Height - StatusPosH - CancelPosH - sep)
		GuiControl, MoveDraw, OptionsDialog_OkButton, % " X" . (Width-sep-sep-OKPosW-CancelPosW-sep) . " Y" . (Height - StatusPosH - OKPosH - sep)
		;GuiControl, Move, OptionsDialog_OptionsName_TextBox, % "W" . (Width-CNPosX-sep-sep)


		GuiControl, Move, OptionsLink1, % "X" . (Width-OptionsLink1PosW-sep-sep)

		GuiControl, Move, OptionsDialog_SepLine1, % " W" . (Width - 40)
		GuiControl, Move, OptionsDialog_SepLine2, % " W" . (Width - 40)
		GuiControl, Move, OptionsDialog_SepLine3, % " W" . (Width - 40)
		GuiControl, Move, OptionsDialog_SepLine4, % " W" . (Width - 40)
		GuiControl, Move, OptionsDialog_SepLine5, % " W" . (Width - 40)
		GuiControl, Move, OptionsDialog_SepLine6, % " W" . (Width - 40)

		GuiControlGet, zePos, Pos, Options_VoiceDD
		GuiControl, Move, Options_VoiceDD, % " W" . (Width - zePosX - 20)
		;GuiControlGet, zePos, Pos, Options_VoiceVolume
		;GuiControl, Move, Options_VoiceVolume, % " W" . (Width - zePosX - 20)

		GuiControlGet, zePos, Pos, Options_DebugDD
		GuiControl, Move, Options_DebugDD, % " W" . (Width - zePosX - 20)
		Gui, %last%:Default
		return
	}
}


;All events dispatched to the class function

OptionsDialog_OkButton()
{
    return iOptionsDialog.OnOKPressed()
}
OptionsDialog_CancelButton()
{
    return iOptionsDialog.OnGuiClose()
}
OptionsDialog_GuiClose()
{  
    return iOptionsDialog.OnGuiClose()
}
;Escape dialog
OptionsDialog_GuiEscape()
{  
	return iOptionsDialog.OnGuiClose()
}


OptionsDialog_GuiSize(GuiHwnd, EventInfo, Width, Height)
{
	; The window has been minimized.  No action needed.
	if(EventInfo <> 1)
	{
		iOptionsDialog.OnResize(Width, Height)	
	}
	return
}


Options_VoiceRate()
{
	last:=a_defaultgui
	Gui, OptionsDialog_:Default
	
	GuiControlGet, Options_VoiceRate
	txt := Options_VoiceRate
	GuiControl, Text, OptionsRight5Text, %txt%
	

	Gui, %last%:Default
}
Options_VoiceVolume()
{
	last:=a_defaultgui
	Gui, OptionsDialog_:Default
	
	GuiControlGet, Options_VoiceVolume
	txt := Options_VoiceVolume . "%"
	GuiControl, Text, OptionsRight6Text, %txt%
	

	Gui, %last%:Default
}
OptionsMaxErrSlider()
{
	last:=a_defaultgui
	Gui, OptionsDialog_:Default
	
	GuiControlGet, OptionsMaxErrSlider
	txt := OptionsMaxErrSlider
	GuiControl, Text, OptionsRight1Text, %txt%
	

	Gui, %last%:Default
}
OptionsThresholdSlider()
{
	last:=a_defaultgui
	Gui, OptionsDialog_:Default
	
	GuiControlGet, OptionsThresholdSlider
	val2 := floor(gSAPIConfidenceAvg * 100)
	txt := OptionsThresholdSlider . "%"
	GuiControl, Text, OptionsRight3Text, %txt%
	

	Gui, %last%:Default
}

SAPIExist()
{
    ;Looks for SAPI processes by processname
    WinGet, all, list
    Loop, %all%
    {
        Try
        {
            ;get the path
            WinGet, PPath, ProcessPath, % "ahk_id " all%A_Index%
            
            SplitPath, PPath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
            ;check if not in listview already
            if(OutNameNoExt = "SPEECHUXWIZ") ;one of it's setup window, they run in a different program
            {
				if(ProcessMonitor.IsWindowMine())
				{
					WinGet, hWnd, ID, % "ahk_id " all%A_Index%
					ShowWindow(hWnd,9)
					SetForegroundWindow(hWnd)
					FlashWindow(hWnd,true)
				}
                return true
            }
            if(OutNameNoExt = "SAPISVR") ;the main user interface that kills itself launching any setup window, silly beast
            {
                if(ProcessMonitor.IsWindowMine())
				{
					WinGet, hWnd, ID, % "ahk_id " all%A_Index%
					ShowWindow(hWnd,9)
					SetForegroundWindow(hWnd)
					FlashWindow(hWnd,true)
				}
                return true
            }
		}		
	}
    return false
}


OptionsSAPIButton()
{
	Debug.MsgBox("Use MS Speech Recognition to Setup your Microphone and Train the Speech Recognition. Press OK to Launch")
	Run, c:\windows\speech\common\sapisvr.exe -SpeechUX, , , PID
	gSAPITraining := true
	Sleep, 1000
    ;while(WinExist("ahk_class MS:SpeechTopLevel"))
    while(SAPIExist() && gEditing)
    {
        Sleep, 1000
    }
	Debug.MsgBox("If you made Changes to the Microphone Settings you will need to restart the program.")
	gSAPITraining := false
	
}

OptionsLink1()
{
	DoHelp("OptionsWindow")
}
OptionsDebugButton()
{
	Debug.Show()
	Debug.WriteNL("",1000)
	Debug.WriteNL("Press Enter and Type Help or ?",1000)
}
OptionsTempFolder()
{
	explorerpath:= "explorer /e," . A_MyDocuments . "\HotKeySpeak\temp"
	Run, %explorerpath%
}
return
OptionsDialog_DoneResize:
{

	iOptionsDialog.OnDoneResize(OptionsDialog_Width, OptionsDialog_Height)
	SetTimer, OptionsDialog_DoneResize, Off
}
return
