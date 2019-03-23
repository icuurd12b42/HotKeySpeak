Class TV_ICONS
{
	static ERROR := "Icon1"
	static APPS := "Icon2"
	static GROUP := "Icon3"
	static COMMAND := "Icon4"
	static CONTEXT := "Icon5"
	static WINDOWCONTEXT := "Icon6"
	static NOICON := "Icon7"
	static FILE := "Icon8"
	static EDITEXE := "Icon9"
	static WIN10APP := "Icon10"
}
global MainUIIconFile :=
global ProcessUIIconFile :=
global GroupsUIIconFile :=
global ContextUIIconFile :=
global CommandUIIconFile :=
global ExeUIIconFile :=
global WindowContextUIIconFile :=
global OptionsUIIconFile :=
global ConsoleUIIconFile :=
Class MainUIIcons
{
	m_ImageList :=
	m_ImageCount :=
	__New()
	{
		Debug.WriteStackPush("MainUIIcons __New",Debug.ErrLevelCore)
		this.m_ImageCount := 0
		this.m_ImageList := IL_Create(10,10,TreeViewLargeIcons)
		this.LoadAPPIcons()
		Debug.WriteStackPop("MainUIIcons __New",Debug.ErrLevelCore)
	}
	GetImageList()
	{
		return this.m_ImageList
	}
	LoadAPPIcons()
	{
		Debug.WriteStackPush("MainUIIcons.LoadAPPIcons Start",Debug.ErrLevelCore)
		MainUIIconFile := "Graphics\Icons\HotKeySpeak.ico"
		ProcessUIIconFile := "Graphics\Icons\Applications.ico"
		GroupsUIIconFile := "Graphics\Icons\Groups.ico"
		ContextUIIconFile := "Graphics\Icons\context.ico"
		CommandUIIconFile := "Graphics\Icons\Command.ico"
		WindowContextUIIconFile := "Graphics\Icons\Window.ico"
		ExeUIIconFile := "Graphics\Icons\EditExe.ico"
		OptionsUIIconFile := "Graphics\Icons\Options.ico"
		ConsoleUIIconFile := "Graphics\Icons\Console.ico"

		this.LoadImage("Graphics\Icons\Error.ico",1)
		this.LoadImage("Graphics\Icons\Applications.ico",1)
		this.LoadImage("Graphics\Icons\Groups.ico",1)
		this.LoadImage("Graphics\Icons\Command.ico",1)
		this.LoadImage("Graphics\Icons\Context.ico",1)
		this.LoadImage("Graphics\Icons\Window.ico",1)
		this.LoadImage("Graphics\Icons\noicon.ico",1)
		this.LoadImage("Graphics\Icons\File.ico",1)
		this.LoadImage("Graphics\Icons\EditExe.ico",1)
		this.LoadImage("Graphics\Icons\Windows10App.ico",1)
		
		Loop 15  ; Load the ImageList with some standard system icons.
		{
			this.LoadImage( "shell32.dll", A_Index)
		}
		Debug.WriteStackPop("MainUIIcons.LoadAPPIcons End",Debug.ErrLevelCore)
	}
	LoadImage(filename, icon_index_in_file)
	{
		Debug.WriteStackPush("MainUIIcons.LoadImage(" . filename . "," . icon_index_in_file . ")",Debug.ErrLevelCore)
		;load the icon from exe or ico file
		hicon := LoadPicture(filename, "Icon" . icon_index_in_file)
		
		
		;if not failed loading
		if(hicon <> 0)
		{
			IL_Add(this.m_ImageList, filename, icon_index_in_file)
			this.m_ImageCount := this.m_ImageCount + 1
			icon := "Icon" . this.m_ImageCount
			Debug.WriteStackPop("MainUIIcons.LoadImage() Success " . icon, Debug.ErrLevelCoreInfo,Debug.ErrLevelCore)
			return icon
		}
		else
		{
			Debug.WriteStackPop("MainUIIcons.LoadImage(" . filename . "," . icon_index_in_file . ") Failed", Debug.ErrLevelCoreErrors)
			if(InStr(filename, "WindowsApps"))
			{
				return TV_ICONS.WIN10APP
			}
			else if (InStr(filename, "SystemApps"))
			{
				return TV_ICONS.WIN10APP
			}
			else if (InStr(filename, "ApplicationFrameHost"))
			{
				return TV_ICONS.WIN10APP
			}
			else if (InStr(filename, "ApplicationFrameHost"))
			{
				return TV_ICONS.WIN10APP
			}
			else if (InStr(filename, "\Windows\"))
			{
				return TV_ICONS.WIN10APP
			}
			else
			{
				return TV_ICONS.NOICON
			}
		}
		
		
	}
	
}