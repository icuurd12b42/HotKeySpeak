; unfortunately AHK does not have extra data abilities for treview items... so this does that
; This is the 7th re-write of the whole damned structure.... 
; I removed the create/new arguments as it created incomprehensible code in the long run making management and bug fixing a pain.
; The treeview item's extra data is contained in an object instance 
; The instance holds more information than a treeview item can
; The instance is linked with a treeview item index, the treeview item index is stored in the instance
; The instance also has a linked list ability, so the tree representation can be held in both
;    the treeview and the extra data structure, however GROUPS are not retained in the linked list
;    in order to make the live search as streamlined as possible for the context system
; The treeview itself is looped through to save the structure, preserving the tree structure INCLUDING the group structure
; The loading reconstructs the treeview in similar fashion as though the user created items one at a time
; A secondary array holds references to the instances as well, this array also has the GROUP items, but is a flat
;    storage which allows fast looping to find items based of the tree item index, used while editing the treeview

;enum type setup for item types
Class TV_TYPES
{
	static NONE := 0
	static APPS := 1
	static EXE := 2
	static COMMAND := 3
	static CONTEXT := 4
	static GROUP := 5
	static WINDOWCONTEXT := 6
    static FILERESOURCE := 7
}

	
global gFastRefItems

TVType_CreateFromDom(dom_element, type, tv_parent)
{
	text := dom_element.getAttribute("text")
	ret := 0
	if(type == TV_TYPES.CONTEXT)
	{
		ret := New TVContextItem(text,0,tv_parent,TV_ICONS.CONTEXT)
		gFastRefItems[ret.GetContextName()] := ret
		
	}
	else if(type == TV_TYPES.APPS)
	{
		ret := New TVAppsRootItem(text,0,tv_parent,TV_ICONS.APPS)
	}
	else if(type == TV_TYPES.EXE)
	{
		ret := New TVExeItem(text,0,"",tv_parent,TV_ICONS.NOICON)
		global gFastRefItems := ret.m_FastRefItems
		
	}
	else if(type == TV_TYPES.COMMAND)
	{
		ret := New TVCommandItem(text,0,tv_parent,TV_ICONS.COMMAND)
		gFastRefItems[ret.GetCommandName()] := ret
		
	}
	else if(type == TV_TYPES.GROUP)
	{
		ret := New TVGroupItem(text,0,tv_parent,TV_ICONS.GROUP)
	}
	else if(type == TV_TYPES.WINDOWCONTEXT)
	{
		ret := New TVWindowContextItem(text,0,tv_parent,TV_ICONS.WINDOWCONTEXT)
		gFastRefItems[ret.GetContextName()] := ret
	}
	else if(type == TV_TYPES.FILERESOURCE)
	{
		ret := New TVFileItem(text,0,tv_parent,TV_ICONS.FILE)
	}
	else if(type == TV_TYPES.NONE)
	{
		ret := New TVItemData(text,0,tv_parent,TV_ICONS.ERROR)
	}
	ret.FromDOM(dom_element)
	return ret
}
FixTextForIni(text)
{
	t := text
	t:= StrReplace(t, chr(13), "</r>")
	t:= StrReplace(t, chr(10), "</n>")
	;t:= StrReplace(t, chr(34), "</q>")
	return t
}
UnfixTextForIni(text)
{
	t := text
	t:= StrReplace(t, "</r>", chr(13))
	t:= StrReplace(t, "</n>", chr(10))
	;t:= StrReplace(t, "</q>", chr(34))
	return t
}
Class TVItemData
{
	m_ItemText := ;The text that matches the treeview item text. useful to cancel a treeview item edit
	m_TreeviewItemIndex := ;The treeview item index for this instance
	m_TreeviewParentIndex := ;The treeview parent index for this instance
	m_TreeviewIconIndex := ;The treeview parent index for this instance
	m_Type := ;The type
	m_GroupType := ;the type of group this is under 
	m_Disabled := ;item is disabled
	__New(ItemText:="",TreeviewItemIndex:=0,TreviewParentIndex:=0,TVIconIndex:="")
	{
		this.TVItemDataInit(ItemText,TreeviewItemIndex,TreviewParentIndex,TVIconIndex) 
	}
	TVItemDataInit(ItemText,TreeviewItemIndex,TreviewParentIndex,TVIconIndex)
	{
		this.SetType(TV_TYPES.NONE)
		this.SetItemText(ItemText)
		this.SetTreeviewItemIndex(TreeviewItemIndex)
		this.SetTreeviewParentIndex(TreviewParentIndex)
		this.SetTreeviewIconIndex(TVIconIndex)
		this.SetGroupType(TV_TYPES.NONE)
		this.SetDisabled(0)
	}
	SetDisabled(Disabled)
	{
		this.m_Disabled := Disabled
	}
	GetDisabled()
	{
		return this.m_Disabled
	}
	GetItemText()
	{
		return this.m_ItemText
	}
	SetItemText(ItemText)
	{
		this.m_ItemText := ItemText
	}
	GetTreeviewItemText()
	{
		return this.GetItemText()
	}
	GetTreeviewItemIndex()
	{
		return this.m_TreeviewItemIndex
	}
	
	SetTreeviewItemIndex(TreeviewItemIndex)
	{
		this.m_TreeviewItemIndex := TreeviewItemIndex
	}
	GetTreeviewParentIndex()
	{
		return this.m_TreeviewParentIndex
	}
	SetTreeviewParentIndex(TreeviewParentIndex)
	{
		this.m_TreeviewParentIndex := TreeviewParentIndex
	}
	GetTreeviewIconIndex()
	{
		return this.m_TreeviewIconIndex
	}
	SetTreeviewIconIndex(TreeviewIconIndex)
	{
		this.m_TreeviewIconIndex := TreeviewIconIndex
	}
	GetType()
	{
		return this.m_Type
	}
	SetType(Type)
	{
		this.m_Type := Type
	}
	GetGroupType()
	{
		return this.m_GroupType
	}
	SetGroupType(GroupType)
	{
		this.m_GroupType := GroupType
	}

	ToDOM(DOM,Element)
	{
		Debug.WriteStack("Storing: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		Element.setAttribute("text",this.GetItemText())
		Element.setAttribute("type",this.GetType())
		Element.setAttribute("grouptype",this.GetGroupType())
		Element.setAttribute("disabled",this.GetDisabled())
	}
	FromDOM(Element)
	{
		Debug.WriteStack("Loading: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		;these are already set
		;this.SetItemText(Element.getAttribute("text"))
		;this.SetType(Element.getAttribute("type"))
		this.SetGroupType(Element.getAttribute("grouptype"))
		this.SetDisabled(Element.getAttribute("disabled"))
		
	}
}
Class TVAppsRootItem extends TVItemData
{
	__New(ItemText:="",TreeviewItemIndex:=0,TreviewParentIndex:=0,TVIconIndex:="")
	{
		this.TVAppsRootItemInit(ItemText,TreeviewItemIndex,TreviewParentIndex,TVIconIndex) 
	}
	TVAppsRootItemInit(ItemText,TreeviewItemIndex,TreviewParentIndex,TVIconIndex)
	{
		this.TVItemDataInit(ItemText,TreeviewItemIndex,TreviewParentIndex,TVIconIndex)
		this.SetType(TV_TYPES.APPS)
		this.SetGroupType(TV_TYPES.APPS)
	}
	ToDOM(DOM,Element)
	{
		Debug.WriteStack("Storing: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		Element.setAttribute("text",this.GetItemText())
		Element.setAttribute("type",this.GetType())
		Element.setAttribute("grouptype",this.GetGroupType())
		Element.setAttribute("disabled",this.GetDisabled())
	}
	FromDOM(Element)
	{
		Debug.WriteStack("Loading: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		;these are already set
		;this.SetItemText(Element.getAttribute("text"))
		;this.SetType(Element.getAttribute("type"))
		this.SetGroupType(Element.getAttribute("grouptype"))
		this.SetDisabled(Element.getAttribute("disabled"))
	}
}
Class TVExeItem extends TVItemData
{
	m_ExeFile :=
	m_SpeechGrammarDOM :=
	m_SpeechGrammar :=
	m_Code :=
	m_Interpreter :=
	m_HotKeysArray := ;this is a LIST of hotkeys from the sub sub items
	m_FastRefItems :=
	m_AppName :=
	__New(ExeName:="", ExeFile:="",TreeviewItemIndex:=0,TreviewParentIndex:=0,TVIconIndex:="",Code:="",AppName:="")
	{
		this.TVExeItemInit(ExeName, ExeFile,TreeviewItemIndex,TreviewParentIndex,TVIconIndex,Code,AppName) 
	}
	TVExeItemInit(ExeName, ExeFile,TreeviewItemIndex,TreviewParentIndex,TVIconIndex,Code,AppName:="")
	{
		this.TVItemDataInit(ExeName,TreeviewItemIndex,TreviewParentIndex,TVIconIndex)
		this.SetType(TV_TYPES.EXE)
		this.SetGroupType(TV_TYPES.EXE)
		this.SetExeFile(ExeFile)
		this.SetCode(Code)
		this.SetSpeechGrammarDom(0)
		this.SetSpeechGrammar(0)
		this.m_AppName := AppName
		if(AppName == "")
		{
			this.m_AppName := ExeName
		}
		this.m_Interpreter := New Interpreter
		this.m_HotKeysArray := []
		this.m_InContextHotKeys := []
		this.m_FastRefItems :=[]
	}
	SetAppName(AppName)
	{
		this.m_AppName := AppName
	}
	GetAppName()
	{	
		return this.m_AppName
	}
	GetTreeviewItemText()
	{
		return this.GetAppName()
	}
	GetHotKeysArray()
	{
		return this.m_HotKeysArray
	}
	GetInterpreter()
	{
		return this.m_Interpreter
	}
	SetCode(Code)
	{
		this.m_Code:=Code
	}
	GetCode()
	{
		return this.m_Code
	}
	DisableSpeechRuleName(RuleName)
	{
		Debug.WriteStackPushPop("DisableSpeechRuleName",Debug.ErrLevelCore)
		if(this.m_SpeechGrammar)
		{
			Debug.WriteStackPushPop("Disabling SAPI Grammar Rule " . RuleName . " for: " . this.GetExeName(),Debug.ErrLevelCoreInfo)
			try
			{
				this.m_SpeechGrammar.CmdSetRuleState( RuleName, SpeechRuleState.SGDSInactive)
			}
			catch e
			{
				Debug.WriteNL("",Debug.ErrLevelImportant)
				Debug.WriteNL("-----------------",Debug.ErrLevelImportant)
				Debug.WriteNL("The speech grammar failed to Deactivate Grammar.",Debug.ErrLevelImportant)
				Debug.WriteNL("Details:", Debug.ErrLevelImportant)
				Debug.WriteNL(e.Extra,Debug.ErrLevelImportant)
				Debug.WriteNL(SAPIDecodeErrorFromExceptionString(e.Message),Debug.ErrLevelImportant)
				Debug.WriteNL("-----------------",Debug.ErrLevelImportant)
				Debug.WriteNL("",Debug.ErrLevelImportant)
				this.m_SpeechGrammar := 0
			}
		}
	}
	EnableSpeechRuleName(RuleName)
	{
		Debug.WriteStackPushPop("EnableSpeechRuleName",Debug.ErrLevelCore)
		if(this.m_SpeechGrammar)
		{
			Debug.WriteStackPushPop("Enabling SAPI Grammar Rule " . RuleName . " for: " . this.GetExeName(),Debug.ErrLevelCoreInfo)
			try
			{
				this.m_SpeechGrammar.CmdSetRuleState( RuleName, SpeechRuleState.SGDSActive)
			}
			catch e
			{
				Debug.WriteNL("",Debug.ErrLevelImportant)
				Debug.WriteNL("-----------------",Debug.ErrLevelImportant)
				Debug.WriteNL("The speech grammar failed to Activate Grammar.",Debug.ErrLevelImportant)
				Debug.WriteNL("Details:", Debug.ErrLevelImportant)
				Debug.WriteNL(e.Extra,Debug.ErrLevelImportant)
				Debug.WriteNL(SAPIDecodeErrorFromExceptionString(e.Message),Debug.ErrLevelImportant)
				Debug.WriteNL("-----------------",Debug.ErrLevelImportant)
				Debug.WriteNL("",Debug.ErrLevelImportant)
				this.m_SpeechGrammar := 0
			}
		}
	}
	DisableSpeech()
	{
		Debug.WriteStackPushPop("DisableSpeech",Debug.ErrLevelCore)
		if(this.m_SpeechGrammar)
		{
			Debug.WriteStackPushPop("Disabling SAPI Grammar for: " . this.GetExeName(),Debug.ErrLevelCoreInfo)
			try
			{
				;this.m_SpeechGrammar.CmdSetRuleIdState( 0, SpeechRuleState.SGDSInactive)
				this.m_SpeechGrammar.CmdSetRuleState( "", SpeechRuleState.SGDSInactive)
			}
			catch e
			{
				Debug.WriteNL("",Debug.ErrLevelImportant)
				Debug.WriteNL("-----------------",Debug.ErrLevelImportant)
				Debug.WriteNL("The speech grammar failed to Deactivate Grammar.",Debug.ErrLevelImportant)
				Debug.WriteNL("Details:", Debug.ErrLevelImportant)
				Debug.WriteNL(e.Extra,Debug.ErrLevelImportant)
				Debug.WriteNL(SAPIDecodeErrorFromExceptionString(e.Message),Debug.ErrLevelImportant)
				Debug.WriteNL("-----------------",Debug.ErrLevelImportant)
				Debug.WriteNL("",Debug.ErrLevelImportant)
				this.m_SpeechGrammar := 0
			}
		}
	}
	SetDictationMode()
	{
		Debug.WriteStackPushPop("SetDictationMode",Debug.ErrLevelCore)
		this.m_SpeechGrammar.DictationSetState(SpeechRuleState.SGDSActive)
	}
	StopDictationMode()
	{
		Debug.WriteStackPushPop("SetDictationMode",Debug.ErrLevelCore)
		this.m_SpeechGrammar.DictationSetState(SpeechRuleState.SGDSInactive )
	}
	EnableSpeech()
	{
		Debug.WriteStackPushPop("EnableSpeech",Debug.ErrLevelCore)
		if(this.m_SpeechGrammar)
		{
			Debug.WriteStackPushPop("Enabling SAPI Grammar for: " . this.GetExeName(),Debug.ErrLevelCoreInfo)
			try
			{
				;this.m_SpeechGrammar.CmdSetRuleIdState( 0, SpeechRuleState.SGDSActive)
				this.m_SpeechGrammar.CmdSetRuleState( "MAIN", SpeechRuleState.SGDSActive)
			}
			catch e
			{
				Debug.WriteNL("",Debug.ErrLevelImportant)
				Debug.WriteNL("-----------------",Debug.ErrLevelImportant)
				Debug.WriteNL("The speech grammar failed to Activate Grammar.",Debug.ErrLevelImportant)
				Debug.WriteNL("Details:", Debug.ErrLevelImportant)
				Debug.WriteNL(e.Extra,Debug.ErrLevelImportant)
				Debug.WriteNL(SAPIDecodeErrorFromExceptionString(e.Message),Debug.ErrLevelImportant)
				Debug.WriteNL("-----------------",Debug.ErrLevelImportant)
				Debug.WriteNL("",Debug.ErrLevelImportant)
				this.m_SpeechGrammar := 0
			}
		}
	}
	SetSpeechGrammarDom(SpeechGrammarDOM)
	{
		Debug.WriteStackPushPop("SetSpeechGrammarDom()",Debug.ErrLevelCore)
		this.m_SpeechGrammarDOM := SpeechGrammarDOM
		if(this.m_SpeechGrammarDOM)
		{
			
			Debug.WriteStackPushPop("Adding SAPI Grammar for: " . this.GetExeName(),Debug.ErrLevelCoreInfo)
			path:= A_MyDocuments . "\HotKeySpeak\Temp\ProgramGrammar"
            FileCreateDir, %path%
			Filename := path . "\" . this.GetExeName() . ".xml"
			Try 
    		{
				this.SaveGrammarDOM(Filename)
			
				this.m_SpeechGrammar := gRC.CreateGrammar()
				this.m_SpeechGrammar.CmdLoadFromFile(Filename, SpeechLoadOption.SLODynamic)
				this.m_SpeechGrammar.CmdSetRuleIdState( 0, SpeechRuleState.SGDSInactive)
				
			}
			catch e
			{
				Debug.WriteNL("",Debug.ErrLevelImportant)
				Debug.WriteNL("-----------------",Debug.ErrLevelImportant)
				Debug.WriteNL("The speech grammar failed to Load.",Debug.ErrLevelImportant)
				Debug.WriteNL("For Program: " . this.GetExeFile(), Debug.ErrLevelImportant)
				Debug.WriteNL("File: " . Filename, Debug.ErrLevelImportant)
				Debug.WriteNL("Details:", Debug.ErrLevelImportant)
				Debug.WriteNL(e.Extra,Debug.ErrLevelImportant)
				Debug.WriteNL(SAPIDecodeErrorFromExceptionString(e.Message),Debug.ErrLevelImportant)
				Debug.WriteNL("-----------------",Debug.ErrLevelImportant)
				Debug.WriteNL("",Debug.ErrLevelImportant)
				this.m_SpeechGrammar := 0
				Debug.MsgBox("Failed to load speech grammar for " . this.GetExeFile() . "`n`nThere may have been unforeseen problems with the grammar definition. `nCheck the Speak Text for the Command and Context items.`nAlso check for Duplicate Action Names!")
			}
		}
		
	}
	GetSpeechGrammarDom()
	{
		return this.m_SpeechGrammarDOM
	}
	SetSpeechGrammar(SpeechGrammar)
	{
		this.m_SpeechGrammar := SpeechGrammar
	}
	GetSpeechGrammar()
	{
		return this.m_SpeechGrammar
	}

	SaveGrammarDOM(filename)
    {
		if(FileExist(filename))
        {
			FileDelete, %filename%
		}
		element := this.m_SpeechGrammarDOM
		txt := element.firstChild.xml
		FileAppend, %txt%, %filename%
		
		
    }
	GetExeFile()
	{
		return this.m_ExeFile
	}
	SetExeFile(ExeFile)
	{
		this.m_ExeFile := ExeFile
		SplitPath, ExeFile , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		this.SetExeName(OutFileName)
		
	}
    GetExeName()
	{
		return this.GetItemText()
	}
	SetExeName(ExeFile)
	{
		this.SetItemText(ExeFile)
	}

	
	ToDOM(DOM,Element)
	{
		Debug.WriteStack("Storing: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		Element.setAttribute("text",this.GetExeName())
		Element.setAttribute("type",this.GetType())
		Element.setAttribute("grouptype",this.GetGroupType())
		Element.setAttribute("disabled",this.GetDisabled())
		Element.setAttribute("path",this.GetExeFile())
		Element.setAttribute("appname",this.GetAppName())
		Code := DOM.CreateElement("Code")
		Code.text := this.GetCode()
		Element.appendChild(Code)
	}
	FromDOM(Element)
	{
		Debug.WriteStack("Loading: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		;these are already set
		;this.SetItemText(Element.getAttribute("text"))
		;this.SetType(Element.getAttribute("type"))
		this.SetGroupType(Element.getAttribute("grouptype"))
		this.SetExeFile(Element.getAttribute("path"))
		this.SetAppName(Element.getAttribute("appname"))
		this.SetDisabled(Element.getAttribute("disabled"))
		if("" . this.GetAppName() == "")
		{
			this.SetAppName(this.GetItemText())
		}
		;need to do icon
		ExeFile := this.GetExeFile()
		Debug.WriteStack("Loading Icon For: " . ExeFile, Debug.ErrLevelCoreInfo)
		this.SetTreeviewIconIndex(MainUIWindow.m_Icons.LoadImage(ExeFile, 1))
		
		Code := Element.selectSingleNode("Code")
		this.SetCode(Code.Text)
	}
	
}
Class TVGroupItem extends TVItemData
{
	__New(GroupName:="",TreeviewItemIndex:=0,TreviewParentIndex:=0,TVIconIndex:="")
	{
		this.TVGroupItemInit(GroupName,TreeviewItemIndex,TreviewParentIndex,TVIconIndex) 
	}
	TVGroupItemInit(GroupName,TreeviewItemIndex,TreviewParentIndex,TVIconIndex)
	{
		this.TVItemDataInit(GroupName,TreeviewItemIndex,TreviewParentIndex,TVIconIndex)
		this.SetType(TV_TYPES.GROUP)
		this.SetGroupType(TV_TYPES.GROUP)
	}
	GetGroupName()
	{
		return this.GetItemText()
	}
	SetGroupName(GroupName)
	{
		this.SetItemText(GroupName)
	}
	
	ToDOM(DOM,Element)
	{
		Debug.WriteStack("Storing: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		Element.setAttribute("text",this.GetGroupName())
		Element.setAttribute("type",this.GetType())
		Element.setAttribute("grouptype",this.GetGroupType())
		Element.setAttribute("disabled",this.GetDisabled())

	}
	FromDOM(Element)
	{
		Debug.WriteStack("Loading: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		;these are already set
		;this.SetItemText(Element.getAttribute("text"))
		;this.SetType(Element.getAttribute("type"))
		this.SetGroupType(Element.getAttribute("grouptype"))
		this.SetDisabled(Element.getAttribute("disabled"))
	}
	
}
Class TVCommandItem extends TVItemData
{
	m_SpeakText :=
	m_HotKeys :=
	m_Code :=
	m_ParentHotKeysArray :=
	m_RootHotKeysArray := 
	m_SpeakArray :=
	__New(CommandName:="",TreeviewItemIndex:=0,TreviewParentIndex:=0,TVIconIndex:="",SpeakText:="", HotKeys:="", Code:="")
	{
		this.TVCommandItemInit(CommandName,TreeviewItemIndex,TreviewParentIndex,TVIconIndex,SpeakText, HotKeys, Code) 
	}
	TVCommandItemInit(CommandName,TreeviewItemIndex,TreviewParentIndex,TVIconIndex,SpeakText, HotKeys, Code)
	{
		this.TVItemDataInit(CommandName,TreeviewItemIndex,TreviewParentIndex,TVIconIndex)
		this.SetType(TV_TYPES.COMMAND)
		this.SetGroupType(TV_TYPES.COMMAND)
		this.SetSpeakText(SpeakText)
		this.SetHotKeys(HotKeys)
		this.SetCode(Code)
		this.m_ParentHotKeysArray := 0
		this.m_RootHotKeysArray := 0
	}
	GetRootHotKeysArray()
	{
		return this.m_RootHotKeysArray
	}
	GetParentHotKeysArray()
	{
		return this.m_ParentHotKeysArray
	}
	GetTreeviewItemText()
	{
		return this.GetCommandName() . " (" . this.GetHotKeys() . ")(" . this.GetSpeakText() . ")"
	}
	GetCommandName()
	{
		return this.GetItemText()
	}
	SetCommandName(CommandName)
	{
		this.SetItemText(CommandName)
	}
	GetSpeakText()
	{
		return this.m_SpeakText
	}
	SetSpeakText(SpeakText)
	{
		this.m_SpeakText := SpeakText
		this.m_SpeakArray :=StrSplit(SpeakText, "|")
	}
	GetHotKeys()
	{
		return this.m_HotKeys
	}
	SetHotKeys(HotKeys)
	{
		this.m_HotKeys := HotKeys
	}
	GetCode()
	{
		return this.m_Code
	}
	SetCode(Code)
	{
		
		this.m_Code := Code
	}

	
	ToDOM(DOM,Element)
	{
		Debug.WriteStack("Storing: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		Element.setAttribute("text",this.GetCommandName())
		Element.setAttribute("type",this.GetType())
		Element.setAttribute("grouptype",this.GetGroupType())
		Element.setAttribute("disabled",this.GetDisabled())
		SpeakText := DOM.CreateElement("SpeakText")
		SpeakText.text := this.GetSpeakText()
		Element.appendChild(SpeakText)
		HotKeys := DOM.CreateElement("HotKeys")
		HotKeys.text := this.GetHotKeys()
		Element.appendChild(HotKeys)
		Code := DOM.CreateElement("Code")
		Code.text := this.GetCode()
		Element.appendChild(Code)
	}
	FromDOM(Element)
	{
		Debug.WriteStack("Loading: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		;these are already set
		;this.SetItemText(Element.getAttribute("text"))
		;this.SetType(Element.getAttribute("type"))
		this.SetGroupType(Element.getAttribute("grouptype"))
		this.SetDisabled(Element.getAttribute("disabled"))
		SpeakText := Element.selectSingleNode("SpeakText")
		HotKeys := Element.selectSingleNode("HotKeys")
		Code := Element.selectSingleNode("Code")

		this.SetSpeakText(SpeakText.Text)
		this.SetHotKeys(HotKeys.Text)
		this.SetCode(Code.Text)
	}
	
}

Class TVContextItem extends TVCommandItem
{
	m_HotKeysArray:=
	__New(ContextName:="",TreeviewItemIndex:=0,TreviewParentIndex:=0,TVIconIndex:="",SpeakText:="", HotKeys:="", Code:="")
	{
		this.TVContextItemInit(ContextName,TreeviewItemIndex,TreviewParentIndex,TVIconIndex,SpeakText, HotKeys, Code) 
	}
	TVContextItemInit(ContextName,TreeviewItemIndex,TreviewParentIndex,TVIconIndex,SpeakText, HotKeys, Code)
	{
		this.TVCommandItemInit(ContextName,TreeviewItemIndex,TreviewParentIndex,TVIconIndex,SpeakText, HotKeys, Code)
		this.SetType(TV_TYPES.CONTEXT)
		this.SetGroupType(TV_TYPES.CONTEXT)
		this.m_HotKeysArray := []
	}
	GetTreeviewItemText()
	{
		return this.GetContextName() . " (" . this.GetHotKeys() . ")(" . this.GetSpeakText() . ")"
	}
	GetContextName()
	{
		return this.GetCommandName()
	}
	SetContextName(ContextName)
	{
		this.SetCommandName(ContextName)
	}
	GetHotKeysArray()
	{
		return this.m_HotKeysArray
	}
	
	ToDOM(DOM,Element)
	{
		Debug.WriteStack("Storing: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		Element.setAttribute("text",this.GetContextName())
		Element.setAttribute("type",this.GetType())
		Element.setAttribute("grouptype",this.GetGroupType())
		Element.setAttribute("disabled",this.GetDisabled())
		SpeakText := DOM.CreateElement("SpeakText")
		SpeakText.text := this.GetSpeakText()
		Element.appendChild(SpeakText)
		HotKeys := DOM.CreateElement("HotKeys")
		HotKeys.text := this.GetHotKeys()
		Element.appendChild(HotKeys)
		Code := DOM.CreateElement("Code")
		Code.text := this.GetCode()
		Element.appendChild(Code)
	}
	FromDOM(Element)
	{
		Debug.WriteStack("Loading: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		;these are already set
		;this.SetItemText(Element.getAttribute("text"))
		;this.SetType(Element.getAttribute("type"))
		this.SetGroupType(Element.getAttribute("grouptype"))
		this.SetDisabled(Element.getAttribute("disabled"))
		SpeakText := Element.selectSingleNode("SpeakText")
		HotKeys := Element.selectSingleNode("HotKeys")
		Code := Element.selectSingleNode("Code")

		this.SetSpeakText(SpeakText.Text)
		this.SetHotKeys(HotKeys.Text)
		this.SetCode(Code.Text)
	}
	
}

Class TVWindowContextItem extends TVItemData
{
	m_Title :=
	m_ClassName :=
	m_ControlName :=
	m_ControlText :=
	m_Code :=
	m_HotKeysArray := 
	m_RootHotKeysArray :=
	__New(WindowContextName:="",TreeviewItemIndex:=0,TreviewParentIndex:=0,TVIconIndex:="",Title:="", ClassName:="", Code:="", ControlName:="", ControlText:="")
	{
		this.TVWindowContextItemInit(WindowContextName,TreeviewItemIndex,TreviewParentIndex,TVIconIndex,Title, ClassName, Code, ControlName, ControlText) 
	}
	TVWindowContextItemInit(WindowContextName,TreeviewItemIndex,TreviewParentIndex,TVIconIndex,Title, ClassName, Code, ControlName, ControlText) 
	{
		this.TVItemDataInit(WindowContextName,TreeviewItemIndex,TreviewParentIndex,TVIconIndex)
		this.SetType(TV_TYPES.WINDOWCONTEXT)
		this.SetGroupType(TV_TYPES.WINDOWCONTEXT)
		this.SetTitle(Title)
		this.SetClassName(ClassName)
		this.SetControlName(ControlName)
		this.SetControlText(ControlText)
		this.SetCode(Code)
		this.m_HotKeysArray := []
		this.m_RootKeysArray := 0
	}
	GetParentHotKeysArray()
	{
		return 0
	}
	GetRootHotKeysArray()
	{
		return this.m_RootHotKeysArray
	}
	GetHotKeysArray()
	{
		return this.m_HotKeysArray
	}
	GetContextName()
	{
		return this.GetItemText()
	}
	SetContextName(WindowContextName)
	{
		this.SetItemText(WindowContextName)
	}
	GetTitle()
	{
		return this.m_Title
	}
	SetTitle(Title)
	{
		this.m_Title := Title
	}
	GetClassName()
	{
		return this.m_ClassName
	}
	SetClassName(ClassName)
	{
		this.m_ClassName := ClassName
	}
	GetCode()
	{
		return this.m_Code
	}
	GetTreeviewItemText()
	{
		return this.GetContextName() . " (" . this.GetTitle() . ")(" . this.GetClassName() . ")(" . this.GetControlName() . ")(" . this.GetControlText() . ")"
	}
	SetCode(Code)
	{
		this.m_Code := Code
	}
	GetControlText()
	{
		return this.m_ControlText
	}
	SetControlText(ControlText)
	{
		this.m_ControlText := ControlText
	}
	GetControlName()
	{
		return this.m_ControlName
	}
	SetControlName(ControlName)
	{
		this.m_ControlName := ControlName
	}
	
	ToDOM(DOM,Element)
	{
		Debug.WriteStack("Storing: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		Element.setAttribute("text",this.GetContextName())
		Element.setAttribute("type",this.GetType())
		Element.setAttribute("grouptype",this.GetGroupType())
		Element.setAttribute("disabled",this.GetDisabled())
		Title := DOM.CreateElement("Title")
		Title.text := this.GetTitle()
		Element.appendChild(Title)
		ClassName := DOM.CreateElement("ClassName")
		ClassName.text := this.GetClassName()
		Element.appendChild(ClassName)
		ControlName := DOM.CreateElement("ControlName")
		ControlName.text := this.GetControlName()
		Element.appendChild(ControlName)
		ControlText := DOM.CreateElement("ControlText")
		ControlText.text := this.GetControlText()
		Element.appendChild(ControlText)
		Code := DOM.CreateElement("Code")
		Code.text := this.GetCode()
		Element.appendChild(Code)
	}
	FromDOM(Element)
	{
		Debug.WriteStack("Loading: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		;these are already set
		;this.SetItemText(Element.getAttribute("text"))
		;this.SetType(Element.getAttribute("type"))
		this.SetGroupType(Element.getAttribute("grouptype"))
		this.SetDisabled(Element.getAttribute("disabled"))

		Title := Element.selectSingleNode("Title")
		ClassName := Element.selectSingleNode("ClassName")
		ControlName := Element.selectSingleNode("ControlName")
		ControlText := Element.selectSingleNode("ControlText")
		Code := Element.selectSingleNode("Code")

		this.SetTitle(Title.Text)
		this.SetClassName(ClassName.Text)
		this.SetControlName(ControlName.Text)
		this.SetControlText(ControlText.Text)
		this.SetCode(Code.Text)
	}
	
}

Class TVFileItem extends TVItemData
{
	m_FileName :=
	m_Base64Code :=
	__New(FileName:="", TreeviewItemIndex:=0,TreviewParentIndex:=0,TVIconIndex:="",Base64Code:="")
	{
		this.TVFileItemInit(FileName, TreeviewItemIndex,TreviewParentIndex,TVIconIndex,Base64Code) 
	}
	TVFileItemInit(FileName,TreeviewItemIndex,TreviewParentIndex,TVIconIndex,Base64Code)
	{
		this.TVItemDataInit(FileName,TreeviewItemIndex,TreviewParentIndex,TVIconIndex)
		this.SetType(TV_TYPES.FILERESOURCE)
		this.SetGroupType(TV_TYPES.FILERESOURCE)
		this.SetFileName(FileName)
		this.SetBase64Code(Base64Code)
	}
	SetBase64Code(Base64Code)
	{
		this.m_Base64Code:=Base64Code
	}
	GetBase64Code()
	{
		return this.m_Base64Code
	}
	
	GetFileName()
	{
		return this.m_FileName
	}
	SetFileName(FileName)
	{
		this.m_FileName := FileName
		this.SetItemText(FileName)
	}
	
	ToDOM(DOM,Element)
	{
		Debug.WriteStack("Storing: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		Element.setAttribute("text",this.GetFileName())
		Element.setAttribute("type",this.GetType())
		Element.setAttribute("grouptype",this.GetGroupType())
		Element.setAttribute("disabled",this.GetDisabled())
		Code := DOM.CreateElement("Base64Code")
		Code.text := this.GetBase64Code()
		Element.appendChild(Code)
	}
	FromDOM(Element)
	{
		Debug.WriteStack("Loading: " . this.GetItemText(), Debug.ErrLevelCoreInfo)
		;these are already set
		this.SetFileName(Element.getAttribute("text"))
		;this.SetType(Element.getAttribute("type"))
		this.SetGroupType(Element.getAttribute("grouptype"))
		this.SetDisabled(Element.getAttribute("disabled"))
		Code := Element.selectSingleNode("Base64Code")
		this.SetBase64Code(Code.Text)
	}
}