;The statusbar control name and instance 
global MainUIStatusBar_Control
global MainUIStatusBar_Control_Instance

;The Class wrapper
Class MainUIStatusBar
{
	__New(StartText)
	{
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
		Gui, Font, c%StatusFontColor% w%StatusFontWeight% s%StatusFontSize%, %StatusFontName%
		t := "" . StartText
		Gui, Add, Text, section xs R1 w1000 vMainUIStatusBar_Control, %t%
		MainUIStatusBar_Control_Instance = this
		Gui, %last%:Default
	}
	
}
