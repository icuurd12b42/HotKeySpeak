;DebugHelper.ahk
global DebugWindow_TextBox_Control
global hDebugWindow_TextBox_Control
global DebugWindow_


Class Debug
{
	static ErrLevelCore := 0
	static ErrLevelCoreInfo := 1
	static ErrLevelCoreErrors := 2
	static ErrLevelUsefulInfo := 3
	static ErrCodingInfo := 4
	static ErrLevelImportant := 5
	

	static m_WindowOn := false
	static m_stack:=0
	static m_DebugLevel:=5
	static m_LogToFile :=false
	m_hWnd := 
	MsgBox(Text)
	{
		MsgBox, 262144, Hot Key Speak, %Text%
	}
	InitDebugWindow()
	{
		global ConsoleUIIconFile := "Graphics\Icons\Console.ico"
		Menu, tray, Icon , %ConsoleUIIconFile%
		last:=a_defaultgui
		this.m_WindowOn := true
		;this.m_stack := 0
		;this.m_DebugLevel:=5
		this.m_MaxSize := 1024*1024
		Gui, DebugWindow_:Default
		
		;allow resize
		Gui, +resize
		
		;Gui, Color, 000000, 000022
		;Gui, Font, q5 cAAAAAA s11,Courier New
		Gui, Color, 000000, %DebugBackColor%
		Gui, Font, c%DebugFontColor% w%DebugFontWeight% s%DebugFontSize%, %DebugFontName%

		Gui, Add, Edit, -Wrap +HScroll x0 y0 W400 H400 hwndhDebugWindow_TextBox_Control vDebugWindow_TextBox_Control 
		
		;Gui, Show, , Debug Console
		

		arr:= ReadWindowPos("DebugUI")
		X:=arr["X"]
		Y:=arr["Y"]
		Width:=arr["Width"]
		Height:=arr["Height"]
		this.m_JustShown := 10
		Gui, Show , x%X% y%Y% w%Width% h%Height% , Hot Key Speak Debug Console
		hDebugWindow := WinExist("Hot Key Speak Debug Console")
		
		this.m_hWnd := hDebugWindow
		ShowWindow(hMainUIWindow,9)
		MoveWindow(this.m_hWnd,X, Y, Width, Height, 1)
		
		WinSet, Top, , Hot Key Speak Debug Console
		WinSet, Top, , Hot Key Speak
		Gui, %last%:Default
		;hDebugWindow := WinExist("A")
		;this.m_hWnd := hDebugWindow
		SetOwner(hDebugWindow,hMainUIWindow)


		FileCreateDir, %A_MyDocuments%\HotKeySpeak\temp
	}
	Show()
	{
		if(!this.m_WindowOn)
		{
			this.InitDebugWindow()
		}
		EnableWindow(this.m_hWnd,1)
		last:=a_defaultgui
		Gui, DebugWindow_:Default
		Gui, Show, , Hot Key Speak Debug Console
		WinSet, Top, , Hot Key Speak Debug Console
		WinActivate, Hot Key Speak Debug Console
		hDebugWindow := WinExist("Hot Key Speak Debug Console")
		
		this.m_hWnd := hDebugWindow
		SetOwner(hDebugWindow,hMainUIWindow)
		Gui, %last%:Default
	}
	ArrayToText(Array)
	{
		t := "["
		ct := 1
		try
		{

			for index, numitems in Array ; Enumeration is the recommended approach in most cases.
			{
				if(ct > 1)
				{
					t .= ","
				}
				if( IsObject(index) )
				{
					t .= this.ArrayToText(index)
				}
				else
				{
					t .= index
				}
				
				ct++
				
			}
			t .= "]"
			return t
		}
		catch
		{
			return "{object}"
		}
	}
	WriteAny(Text, DebugLevel:=5)
	{
		if(DebugLevel<this.GetDebugLevel())
		{
			return
		}
		if(!this.m_WindowOn)
		{
			this.InitDebugWindow()
		}
		EnableWindow(this.m_hWnd,1)
		t := Text
		if(IsObject(t))
		{
			t := this.ArrayToText(t)
		}
		this._AppendText(hDebugWindow_TextBox_Control,t)
		this._AppendFile(t)
	}
	;basic write functions
	Write(Text, DebugLevel:=5)
	{
		if(DebugLevel<this.GetDebugLevel())
		{
			return
		}
		if(!this.m_WindowOn)
		{
			this.InitDebugWindow()
		}
		EnableWindow(this.m_hWnd,1)
		this._AppendText(hDebugWindow_TextBox_Control,Text)
		this._AppendFile(Text)
	}
	WriteNL(Text := "", DebugLevel:=5)
	{
		if(DebugLevel<this.GetDebugLevel())
		{
			return
		}
		this.Write(Text . chr(13) . chr(10),DebugLevel)
	}
	WriteSP(Text := "", DebugLevel:=5)
	{
		if(DebugLevel<this.GetDebugLevel())
		{
			return
		}
		this.Write(Text . " ",DebugLevel)
	}
	WriteClear(Text := "", DebugLevel:=5)
	{
		if(DebugLevel<this.GetDebugLevel())
		{
			return
		}
		this._SetText(hDebugWindow_TextBox_Control,Text)
	}
	;The Max Size of the content, before the output is cleared
	GetMaxSize()
	{
		return this.m_MaxSize
	}
	SetMaxSize(MaxSize)
	{
		this.m_MaxSize := MaxSize
	}
	;DebugLevel, setting the debug level to 0,1,2,.... commands now take a Debug Level, 0 being default. 
	;the write calls will show if above or equal to the debug level
	;If you WriteNL at debug level 2 and the debug level is 1, meaning out every message of level 1 and above
	;the message will log to the output window
	;Debug Level 0 is considered System Level, log every call
	;One could have a debug level of 3 for useful things
	;2 for more information
	;1 for things like try catch failures
	;0 to log everything your program does
	SetDebugLevel(DebugLevel)
	{
		this.m_DebugLevel := DebugLevel
	}
	GetDebugLevel()
	{
		return this.m_DebugLevel
	}
	;Stack write function to indent/un-intend, each function returns the stack position if you need to reset after a break call for example
	GetStack()
	{
		return this.m_stack
	}
	GetLogToFile()
	{
		return this.m_LogToFile
	}
	SetLogToFile(LogToFile)
	{
		this.m_LogToFile := LogToFile
	}
	SetStack(Level)
	{
		this.m_stack :=level
		return this.m_stack
	}
	ClearStack()
	{
		this.m_stack := 0
		return this.m_stack
	}
	IncStack()
	{
		this.m_stack ++
		return this.GetStack()
	}
	DecStack()
	{
		this.m_stack --
		return this.GetStack()
	}

	WriteStackPush(Text, DebugLevel:=5)
	{
		if(DebugLevel<this.GetDebugLevel())
		{
			return this.IncStack()
		}
		this.WriteStack(Text,DebugLevel)
		this.IncStack()
		return this.GetStack()
	}
	WriteStackPop(Text, DebugLevel:=5)
	{
		if(DebugLevel<this.GetDebugLevel())
		{
			return this.DecStack()
		}
		this.DecStack()
		this.WriteStack(Text)
		return this.GetStack()
	}
	WriteStackPushPop(Text, DebugLevel:=5)
	{
		this.WriteStackPush(Text, DebugLevel)
		this.DecStack()
		return this.GetStack()
	}
	WriteStackClear(Text, DebugLevel:=5)
	{
		if(DebugLevel<this.GetDebugLevel())
		{
			return this.ClearStack()
		}
		this.ClearStack()
		this.WriteStack(Text,DebugLevel)
		return this.GetStack()
	}
	WriteStackClearTo(Text,Level, DebugLevel:=5)
	{
		if(DebugLevel<this.GetDebugLevel())
		{
			return this.SetStack(Level)
		}
		this.SetStack(Level)
		this.WriteStack(Text,DebugLevel)
		return this.GetStack()
	}
	WriteStack(Text, DebugLevel:=5)
	{
		if(DebugLevel<this.GetDebugLevel())
		{
			return this.GetStack()
		}
		ct := this.m_stack
		str :=""
		loop, %ct%
		{
			str.="  "
		}
		this.Write(str,DebugLevel)
		this.WriteNL(Text,DebugLevel)
		return this.GetStack()
	}
	
	_AppendText(hEdit, Text) 
	{
		len := DllCall( "GetWindowTextLength", UInt, hEdit)
		if(len>this.GetMaxSize())
		{
			blanktxt :=""
			;this._SetText(hEdit,"")
			SendMessage, 0x00B1, 0, len/2,, ahk_id %hEdit% ;EM_SETSEL
			SendMessage, 0x00C2, False, &blanktxt,, ahk_id %hEdit% ;EM_REPLACESEL
			len := DllCall( "GetWindowTextLength", UInt, hEdit)
		}
		;this.DisableDraw(hEdit)
		;SendMessage, 0x000E, 0, 0,, ahk_id %hEdit% ;WM_GETTEXTLENGTH
		;SendMessage, 0x00B1, ErrorLevel, ErrorLevel,, ahk_id %hEdit% ;EM_SETSEL
		SendMessage, 0x00B1, len, len,, ahk_id %hEdit% ;EM_SETSEL
		SendMessage, 0x00C2, False, &Text,, ahk_id %hEdit% ;EM_REPLACESEL
	}
	_AppendFile(text)
	{
		if(this.m_LogToFile)
		{
			FileAppend, %text%, %A_MyDocuments%\HotKeySpeak\temp\debug.log
		}
	}
	_SetText(hEdit,Text)
	{
		SendMessage, 0x000C, False, &Text,, ahk_id %hEdit% ;EM_SETTEX
	}
	CloseOutput()
	{
		SaveWindowPos(this.m_hWnd, "DebugUI")
		last:=a_defaultgui
		Gui, DebugWindow_:Default
		Gui, Destroy
		Gui, %last%:Default	
		hDebugWindow :=0
		this.m_WindowOn := false
	}
	FormatPrintClass(obj,prefix)
	{
		str := Debug.ArrayToText(obj)
		str := StrReplace(str, "[__Class" , "")
		str := StrReplace(str, ",__Init" , "")
		str := StrReplace(str, "]" , "")
		;;str := StrReplace(str, "," , chr(13) . chr(10) . prefix)
		str := StrReplace(str, "," , "," . prefix)
		arr := StrSplit(str, ",")
		for each, entry in arr
		{
			;if(IsObject(entry))
			{
				Debug.WriteNL(entry)
			}
		}
		
	}
	
	OnEnter()
	{
		last:=a_defaultgui
		Gui, DebugWindow_:Default
		GuiControlGet, DebugWindow_TextBox_Control
		LastText := ""
		oldclip := Clipboard
		ControlGet, LastText, CurrentLine,,,ahk_id %hDebugWindow_TextBox_Control% 
		ControlSend, , {home}+{end}^c{end}, ahk_id %hDebugWindow_TextBox_Control%
		LastText := Clipboard
		Clipboard := oldclip
		;OutputDebug, %LastText% 
		;Debug.MsgBox(LastText)
		;LastText:=substr(DebugWindow_TextBox_Control,inStr(DebugWindow_TextBox_Control,"`n",,0)+1)

		DoCaret:=true
		;Output Window Commands
		if(LastText = ">Close")
		{
			DoCaret := false
			this.CloseOutput()
			
		}
		else if(LastText = ">Help" || LastText = ">?")
		{
			this.WriteNL("",100000)
			this.WriteNL("Commands:",100000)
			this.WriteNL("    >Clear",100000)
			this.WriteNL("          - Clears the screen",100000)
			this.WriteNL("    >Close",100000)
			this.WriteNL("          - Closes the console",100000)
			this.WriteNL("    >Exit",100000)
			this.WriteNL("          - Terminates the program",100000)
			this.WriteNL("    >Restart",100000)
			this.WriteNL("          - Restarts the program",100000)
			this.WriteNL("    >Help",100000)
			this.WriteNL("    >?",100000)
			this.WriteNL("          - Shows this information",100000)
			this.WriteNL("    >Level n",100000)
			this.WriteNL("          - Where n (optional) is 0 to 5",100000)
			this.WriteNL("          - Sets the Debug Level. 0-all, 1-Core Info, 2-Core Warnings",100000)
			this.WriteNL("          - 3-Useful Information, 4-Coder Info, 5-Important Info Only",100000)
			this.WriteNL("          - Level by itself returns the current Debug Level",100000)
			this.WriteNL("    >Item(N)",100000)
			this.WriteNL("          - Where N is a Treeview Item",100000)
			this.WriteNL("          - Shows the item in the treeview. Used by the Scan For Issues system",100000)
			this.WriteNL("    >List",100000)
			this.WriteNL("          - Lists all AHK functions and Objects available",100000)
			this.WriteNL("    >Print expression",100000)
			this.WriteNL("    >? expression",100000)
			this.WriteNL("          - Where expression is a js expression that returns a value",100000)
			this.WriteNL("          - Prints out the result of an expression",100000)
			this.WriteNL("          - Executes in context of the current code session",100000)
			this.WriteNL("          - Useful to debug variables",100000)
			this.WriteNL("          - eg: Print MyVar",100000)
			this.WriteNL("          - eg: Print WinExist(""Untitled - Notepad"")",100000)
			this.WriteNL("    >expression",100000)
			this.WriteNL("          - Where expression is a js expression",100000)
			this.WriteNL("          - Code on the fly",100000)
			this.WriteNL("          - Executes in context of the current code session",100000)
			this.WriteNL("          - Useful to test out ideas or modify values in your code",100000)
			this.WriteNL("          - eg: var t = ""Hello"";",100000)
			;this.WriteNL("    >BREAK/PAUSE KEY",100000)
			;this.WriteNL("          - By itself, not ctrl+break, just break/pause key",100000)
			;this.WriteNL("          - Stops the script execution",100000)
			this.WriteNL("    >ENTER KEY",100000)
			this.WriteNL("          - Pressing ENTER on any line that starts with > will try to execute ",100000)
			this.WriteNL("            the line based on the content right of the >",100000)
			
			
			
		}
		else if(LastText = ">Exit")
		{
			DoCaret := false
			ExitApp
		}
		else if(LastText = ">Restart")
		{
			DoCaret := false
			MainLink3()
		}
		else if(LastText = ">Clear")
		{
			DoCaret := false
			this.WriteClear("",100000)
		}
		else if(LastText = ">level 0") ;I'll be lazy
		{
			this.SetDebugLevel(0)
			this.WriteNL("",100000)
			this.WriteNL("debug level -> 0",100000)
			
		}
		else if(LastText = ">level 1") ;I'll be lazy
		{
			this.SetDebugLevel(1)
			this.WriteNL("",100000)
			this.WriteNL("debug level -> 1",100000)
			
		}
		else if(LastText = ">level 2") ;I'll be lazy
		{
			this.SetDebugLevel(2)
			this.WriteNL("",100000)
			this.WriteNL("debug level -> 2",100000)
			
		}
		else if(LastText = ">level 3") ;I'll be lazy
		{
			this.SetDebugLevel(3)
			this.WriteNL("",100000)
			this.WriteNL("debug level -> 3",100000)
			
		}
		else if(LastText = ">level 4") ;I'll be lazy
		{
			this.SetDebugLevel(4)
			this.WriteNL("",100000)
			this.WriteNL("debug level -> 4",100000)
			
		}
		else if(LastText = ">level 5") ;I'll be lazy
		{
			this.SetDebugLevel(5)
			this.WriteNL("",100000)
			this.WriteNL("debug level -> 5",100000)
			
		}
		else if(LastText = ">level") ;I'll be lazy
		{
			this.WriteNL("",100000)
			this.WriteNL("debug level is " . this.GetDebugLevel(),100000)
			
		}
		else if(LastText = ">list")
		{
			jsRunner := Interpreter
			if(EventManager.m_current_process_extra_data)
			{
				jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
			}
			Debug.WriteNL("",1000)
			for each, item in jsRunner.m_Js.m_Scripts
			{
				Debug.WriteNL(item)
			}
			Debug.FormatPrintClass(HKS.Action,"HKS.Action.")
			Debug.FormatPrintClass(HKS.Debug,"HKS.Debug.")
			Debug.FormatPrintClass(HKS.Mouse,"HKS.Mouse.")
			Debug.FormatPrintClass(HKS.Mouse.Direct,"HKS.Mouse.Direct.")
			Debug.FormatPrintClass(HKS.Mouse.Pix,"HKS.Mouse.Pix.")
			Debug.FormatPrintClass(HKS.Mouse.UV,"HKS.Mouse.UV.")
			Debug.FormatPrintClass(HKS.Process,"HKS.Process.")
			Debug.FormatPrintClass(HKS.Recognition,"HKS.Recognition.")
			Debug.FormatPrintClass(HKS.Resource,"HKS.Resource.")
			Debug.FormatPrintClass(HKS.VoiceAgent,"HKS.VoiceAgent.")
			Debug.FormatPrintClass(HKS.WinAPI.KB,"HKS.WinAPI.KB.")
			Debug.FormatPrintClass(HKS.WinAPI.Mouse,"HKS.WinAPI.Mouse.")
			Debug.FormatPrintClass(HKS.WinAPI.Win,"HKS.WinAPI.Win.")
			Debug.WriteNL()
			Debug.WriteNL("Refrain for using non documented functions...")

		}
		else if(SubStr(LastText,1,6)=">print")
		{
			code := SubStr(LastText,7)
			jsRunner := Interpreter
			if(EventManager.m_current_process_extra_data)
			{
				jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
			}
			Debug.WriteNL("",1000)
			jsRunner.Exec("HKS.Debug.WriteAny(" . Code . ",1000);")
		}
		else if(SubStr(LastText,1,2)=">?")
		{
			code := SubStr(LastText,3)
			jsRunner := Interpreter
			if(EventManager.m_current_process_extra_data)
			{
				;Debug.MsgBox("Using Exe Interpreter")
				jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
			}
			Debug.WriteNL("",1000)
			jsRunner.Exec("HKS.Debug.WriteAny(" . Code . ",1000);")
		}
		else if(SubStr(LastText,1,6)=">Item(")
		{
			if(gEditing == false)
			{
				arr := StrSplit(SubStr(LastText,7),")")
				item := arr[1]
				if(item!="") 
				{
					TVHelper.SelectItem(item+0)
					MainUITreeview_Control_Instance.OnEditItem()
				}
			}
			DoCaret := false

		}
		else if(SubStr(LastText,1,1)=">")
		{
			code := SubStr(LastText,2)
			if(code!="") 
			{
				
				jsRunner := Interpreter
				if(EventManager.m_current_process_extra_data)
				{
					jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
				}
				
				jsRunner.Exec(Code)
			}
		}
		if(DoCaret)
		{
			;Force the caret to be on the last line, add a > prompt. For commands, a first enter is needed to get to the prompt
			send, ^{end}{enter}>
		}
		Gui, %last%:Default	
	}
	OnCtrlBreak()
	{
		
		jsRunner := Interpreter
		if(EventManager.m_current_process_extra_data)
		{
			jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
		}
		
		jsRunner.Exec("throw new Error(""Program Halted! Console BREAK Detected"");")
		Debug.MsgBox(jsRunner.InterruptScriptThread(0xFFFFFFFF,0,0))
		jsRunner.m_Timers := []
		jsRunner.m_TimerAt := 0
	}
	BreakPoint(Name = "")
	{
		jsRunner := Interpreter
		if(EventManager.m_current_process_extra_data)
		{
			jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
		}
		
		
		MyOutputDebugAlways("BREAK POINT " + Name)
		MyOutputDebugAlways("Close Console When Done!")
		MyOutputDebugAlways(">")
		while(WinExist("Hot Key Speak Debug Console"))
		{
			Sleep, 1000
		}
		
	}

}

;Window Resize event
DebugWindow_GuiSize(GuiHwnd, EventInfo, Width, Height)
{
	; The window has been minimized.  No action needed.
	if(EventInfo <> 1)
	{
		last:=a_defaultgui
		Gui, DebugWindow_:Default
		GuiControl, Move, DebugWindow_TextBox_Control, % "H" . (Height) . " W" . (Width)
		Gui, %last%:Default	
	}
	return
}
DebugWindow_GuiClose()
{
	Debug.CloseOutput()
}
DebugWindow_GuiEscape()
{
	Debug.CloseOutput()
}



return
#IfWinActive , Hot Key Speak Debug Console
enter::
Debug.OnEnter()
#if
return

#IfWinActive , Hot Key Speak Debug Console
pause::
Debug.OnCtrlBreak()
#if
return

