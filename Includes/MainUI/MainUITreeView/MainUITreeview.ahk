global gSampleCode 

;The treeview control name and instance
global MainUITreeview_Control
global MainUITreeview_Control_Instance
global gFileChanged := false

Class MainUITreeview
{
	m_TVExtraData :=
	m_RightClickMenu :=
	m_RootAppsItem :=
	m_Loading :=
	m_LastItemSelected :=
	m_CopyFromTVItem := 
	m_CopyFrom_extra_data := 0
	m_IsCut := 0
	__New(IconsResource)
	{
		this.m_CopyFromTVItem :=0
		this.m_CopyFrom_extra_data :=0
		this.m_IsCut := 0
		gFileChanged := false
		this.m_LastItemSelected := 0
		m_Loading:=False
		this.m_RightClickMenu := New MainUITVRCMenu()
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
		this.m_TVExtraData := new Dictionary()
		Gui, Font, c%TreeViewFontColor% w%TreeViewFontWeight% s%TreeViewFontSize%, %TreeViewFontName%
		Gui, Add, TreeView, hwndhTreeview -HScroll background%TreeViewBackColor% vMainUITreeview_Control gMainUITreeview_Control x0  ImageList%IconsResource%
		MainUITreeview_Control_Instance := this
		Gui, Add, Button, ys +Default w80 gMainUITreeview_ENTERButton, ENTER
		GuiControl, Hide, ENTER
		LinkUseDefaultColor(hTreeview,0)
		Gui, %last%:Default

gSampleCode=
(
//calling function as it's being declared
(function() {
    try //Try to do this...
    {
        Send("Hello");
    }
    catch(e) //catch error
    {
    }
})();
)
	}
	UpdateLiveData(extra_data, DoAll:=false)
	{
		rootexe := 0
		if(!DoAll)
		{
			;rootexe:=FindFirstItem.FindRootExe(extra_data.GetTreeviewItemIndex())
		}
		
		LoadMainTreeViewKeycode.Load(rootexe)
	}
	ItemAddFinalize(extra_data)
	{
		Debug.WriteStackPushPop("ItemAddFinalize()",Debug.ErrLevelCore)
		TVItemParent :=TVHelper.GetSelectedItem()
		extra_data.SetTreeviewParentIndex(TVItemParent)

		ItemText := extra_data.GetTreeviewItemText()
		TVItem := TVHelper.AddItem(ItemText, TVItemParent, extra_data.GetTreeviewIconIndex())
		extra_data.SetTreeviewItemIndex(TVItem)
		
		this.m_TVExtraData.SetItem(TVItem, extra_data)

		TVHelper.SelectItem(TVItem)
		TVHelper.SortBranch(extra_data.GetTreeviewParentIndex())

		Debug.WriteStackPushPop("ItemAddFinalize() Adding: " . ItemText, Debug.ErrLevelCoreInfo)
	}
	OnAddFileResourceItem()
	{
		Debug.WriteStackPushPop("OnAddFileResourceItem()",Debug.ErrLevelCore)
		FileSelectFile, SelectedFile, 3, , Select Editor To Use, All Files (*.*)
		if(SelectedFile)
		{
			SplitPath, SelectedFile , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
			foundItem := FindFirstItem.FindMatchingResourceName(OutFileName,FindFirstItem.FindRootExe(this.m_LastItemSelected))
			if(foundItem)
			{
				MsgBox, 8228, Hot Key Speak , This resource (%OutFileName%) Already Exists!
				TVHelper.SelectItem(foundItem)
			}
			else
			{

				Try
				{
					File := SelectedFile
					FileGetSize, Size, %File%
					FileRead, Bin, *c %File%
					Base64enc( Base64Code, Bin, Size )

					gFileChanged:=true
					TVHelper.SelectItem(this.m_LastItemSelected)
					extra_data := New TVFileItem(OutFileName, 0, 0, TV_ICONS.FILE,Base64Code)
					this.ItemAddFinalize(extra_data)
					;MsgBox % Clipboard := PNGDATA
				}
				catch e
				{
					m:=e.Message
					MsgBox, 8228, Hot Key Speak , Failed to add file (%OutFileName%)!`n%m%
				}
			}
		}
	}
	OnDeleteFileResourceItem(extra_data)
	{
		Debug.WriteStackPushPop("OnDeleteFileResourceItem()",Debug.ErrLevelCore)
		Filename := extra_data.GetFileName()
		MsgBox, 8228, Hot Key Speak , Delete this resource (%Filename%) from Hot Key Speak? `n`nAre you Sure?
		IfMsgBox, No
		{
			return
		}
		gFileChanged:=true
		Debug.WriteStackPushPop("OnDeleteFileResourceItem() Removing: " . Filename, Debug.ErrLevelCoreInfo)
		TVItem := extra_data.GetTreeviewItemIndex()
		DeleteTVBranch.Delete(TVItem)
	}
	AddExeItem(ExeFile,TVIconIndex,AppName:="",Code:=-1)
	{
		Debug.WriteStackPushPop("AddExeItem()",Debug.ErrLevelCore)
		if(Code == -1)
		{
			Code := "" ;gSampleCode
		}
		SplitPath, ExeFile , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		foundItem := FindFirstItem.FindMatchingExeItem(OutFileName)
		if(foundItem)
		{
			TVHelper.SelectItem(foundItem)
		}
		else
		{
			gFileChanged:=true
			TVHelper.SelectItem(this.m_LastItemSelected)
			extra_data := New TVExeItem(OutFileName, ExeFile, 0, 0, TVIconIndex,Code,AppName)
			this.ItemAddFinalize(extra_data)
			this.UpdateLiveData(extra_data)
		}
	
	}
	AddWinAppItem(AppTitle)
	{
		Debug.WriteStackPushPop("AddWindowsApp()",Debug.ErrLevelCore)
		;this is always called with the Windows App Exe selelcted
		;RootExe := FindFirstItem.FindRootExe(TVHelper.GetSelectedItem())
		WinContextName := StringHelper.RemoveWhiteChars(AppTitle)
		foundItem := FindFirstItem.FindMatchingWindowContextName(WinContextName,TVHelper.GetSelectedItem())
		if(foundItem)
		{
			TVHelper.SelectItem(foundItem)
		}
		else
		{
			this.OnAddWindowContextItem(WinContextName,AppTitle)
		}
	
	}
	OnEditExeItem(extra_data)
	{
		
		Debug.WriteStackPushPop("OnEditExeItem()",Debug.ErrLevelCore)
		TVItem := extra_data.GetTreeviewItemIndex()
		ExeFile := extra_data.GetExeFile()
		Code := extra_data.GetCode()
		AppName := extra_data.GetAppName()
		Disabled := extra_data.GetDisabled()
		t:=New EditExeDialog(TVItem, ExeFile, Code, AppName,Disabled)
		t.ShowModal()
	}
	OnChangeExeItem(TVItem,ExeFile,Code,AppName,Disabled)
	{
		gFileChanged:=true
		Debug.WriteStackPushPop("OnChangeExeItem()",Debug.ErrLevelCore)
		extra_data := this.m_TVExtraData.GetItem(TVItem)
		extra_data.SetExeFile(ExeFile)
		extra_data.SetCode(Code)
		extra_data.SetAppName(AppName)
		extra_data.SetDisabled(Disabled)
		
		TVHelper.SetItemText(extra_data.GetTreeviewItemIndex(),extra_data.GetTreeviewItemText())
		TVHelper.SortBranch(extra_data.GetTreeviewParentIndex())
	}
	OnDeleteExeItem(extra_data)
	{
		Debug.WriteStackPushPop("OnDeleteExeItem()",Debug.ErrLevelCore)
		exeName := extra_data.GetExeName()
		MsgBox, 8228, Hot Key Speak , Delete this program (%exeName%) from Hot Key Speak? `n`nAre you Sure?
		IfMsgBox, No
		{
			return
		}
		gFileChanged:=true
		Debug.WriteStackPushPop("OnDeleteExeItem() Removing: " . exeName, Debug.ErrLevelCoreInfo)
		TVItem := extra_data.GetTreeviewItemIndex()
		DeleteTVBranch.Delete(TVItem)
		this.UpdateLiveData(extra_data,true)
		
	}
	OnAddGroupItem(gname:="Group")
	{
		gFileChanged:=true
		Debug.WriteStackPushPop("OnAddGroupItem()",Debug.ErrLevelCore)
		ParentItem := TVHelper.GetSelectedItem()
		parent_extra_data := this.m_TVExtraData.GetItem(ParentItem)
		extra_data := New TVGroupItem(gname, 0, 0, TV_ICONS.GROUP)
		extra_data.SetGroupType(parent_extra_data.GetGroupType())
		this.ItemAddFinalize(extra_data)
	}
	OnChangeGroupItem(TVItem,GroupName,Disabled)
	{
		gFileChanged:=true
		Debug.WriteStackPushPop("OnChangeGroupItem()",Debug.ErrLevelCore)
		extra_data := this.m_TVExtraData.GetItem(TVItem)
		extra_data.SetGroupName(GroupName)
		extra_data.SetDisabled(Disabled)
		TVHelper.SetItemText(extra_data.GetTreeviewItemIndex(),extra_data.GetTreeviewItemText())
		TVHelper.SortBranch(extra_data.GetTreeviewParentIndex())
	}
	OnEditGroupItem(extra_data)
	{
		Debug.WriteStackPushPop("OnEditGroupItem()",Debug.ErrLevelCore)
		TVItem := extra_data.GetTreeviewItemIndex()
		GroupName := extra_data.GetGroupName()
		Disabled := extra_data.GetDisabled()
		t:=New EditGroupDialog(TVItem,GroupName,Disabled)
		t.ShowModal()
	}
	OnDeleteGroupItem(extra_data)
	{
		Debug.WriteStackPushPop("OnDeleteGroupItem()",Debug.ErrLevelCore)
		GroupName := extra_data.GetGroupName()
		MsgBox, 8228, Hot Key Speak , Delete this Group (%GroupName%) and all items it contains? `n`nAre you Sure?
		IfMsgBox, No
		{
			return
		}
		gFileChanged:=true
		
		TVItem := extra_data.GetTreeviewItemIndex()
		DeleteTVBranch.Delete(TVItem)
		this.UpdateLiveData(extra_data,true)
	}
	OnAddContextItem(cname:="Context",SpeakText:="Type The Sentence Here|Two if you need to",HotKeys := "",Code := -1)
	{
		if(code == -1)
		{
			code := "" ;gSampleCode
		}
		gFileChanged:=true
		Debug.WriteStackPushPop("OnAddContextItem()",Debug.ErrLevelCore)
		TemplateName := cname
		ct := 1
		FinalName := TemplateName . ct
		RootExe := FindFirstItem.FindRootExe(TVHelper.GetSelectedItem())
		while(FindFirstItem.FindMatchingContextName(FinalName,RootExe))
		{
			ct++
			FinalName := TemplateName . ct
		}
		extra_data := New TVContextItem(FinalName, 0, 0, TV_ICONS.CONTEXT, SpeakText, HotKeys, Code)
		this.ItemAddFinalize(extra_data)
		this.UpdateLiveData(extra_data)
	}
	OnChangeContextItem(TVItem, ContextName, SpeakText, HotKeys, Code,Disabled)
	{
		gFileChanged:=true
		Debug.WriteStackPushPop("OnChangeContextItem()",Debug.ErrLevelCore)
		extra_data := this.m_TVExtraData.GetItem(TVItem)
		extra_data.SetContextName(ContextName)
		extra_data.SetSpeakText(SpeakText)
		extra_data.SetHotKeys(HotKeys)
		extra_data.SetCode(Code)
		extra_data.SetDisabled(Disabled)
		TVHelper.SetItemText(extra_data.GetTreeviewItemIndex(),extra_data.GetTreeviewItemText())
		TVHelper.SortBranch(extra_data.GetTreeviewParentIndex())
		this.UpdateLiveData(extra_data)
	}
	OnEditContextItem(extra_data)
	{
		Debug.WriteStackPushPop("OnEditContextItem()",Debug.ErrLevelCore)
		TVItem := extra_data.GetTreeviewItemIndex()
		ContextName := extra_data.GetContextName()
		SpeakText := extra_data.GetSpeakText()
		HotKeys := extra_data.GetHotKeys()
		Code := extra_data.GetCode()
		Disabled := extra_data.GetDisabled()
		t:=New EditContextDialog(TVItem, ContextName, SpeakText, HotKeys, Code,Disabled)
		t.ShowModal()
	}
	OnDeleteContextItem(extra_data)
	{
		Debug.WriteStackPushPop("OnDeleteContextItem()",Debug.ErrLevelCore)
		ContextName := extra_data.GetContextName()
		MsgBox, 8228, Hot Key Speak , Delete this Context (%ContextName%) and all items it contains? `n`nAre you Sure?
		IfMsgBox, No
		{
			return
		}
		gFileChanged:=true
		
		TVItem := extra_data.GetTreeviewItemIndex()
		DeleteTVBranch.Delete(TVItem)
		this.UpdateLiveData(extra_data,true)
	}
	OnAddWindowContextItem(cname:="Window",Title:="*",ClassName := "*",Code := -1,ControlName:="*",ControlText:="*")
	{
		if(code == -1)
		{
			code := "" ;gSampleCode
		}
		gFileChanged:=true
		Debug.WriteStackPushPop("OnAddWindowContextItem()",Debug.ErrLevelCore)
		TemplateName := cname
		FinalName := cname
		ct := 1
		if(cname == "Window")
		{
		    FinalName := TemplateName . ct
		}
		RootExe := FindFirstItem.FindRootExe(TVHelper.GetSelectedItem())
		while(FindFirstItem.FindMatchingWindowContextName(FinalName,RootExe))
		{
			ct++
			FinalName := TemplateName . ct
		}
		extra_data := New TVWindowContextItem(FinalName, 0, 0, TV_ICONS.WINDOWCONTEXT, Title, ClassName, Code, ControlName, ControlText)
		this.ItemAddFinalize(extra_data)
		this.UpdateLiveData(extra_data)
	}
	OnChangeWindowContextItem(TVItem, ContextName, Title, ClassName, Code, ControlName, ControlText,Disabled)
	{
		gFileChanged:=true
		Debug.WriteStackPushPop("OnChangeWindowContextItem()",Debug.ErrLevelCore)
		extra_data := this.m_TVExtraData.GetItem(TVItem)
		extra_data.SetContextName(ContextName)
		extra_data.SetTitle(Title)
		extra_data.SetClassName(ClassName)
		extra_data.SetCode(Code)
		extra_data.SetControlName(ControlName)
		extra_data.SetControlText(ControlText)
		extra_data.SetDisabled(Disabled)
		TVHelper.SetItemText(extra_data.GetTreeviewItemIndex(),extra_data.GetTreeviewItemText())
		TVHelper.SortBranch(extra_data.GetTreeviewParentIndex())
		this.UpdateLiveData(extra_data)
	}
	OnEditWindowContextItem(extra_data)
	{
		Debug.WriteStackPushPop("OnEditWindowContextItem()",Debug.ErrLevelCore)
		TVItem := extra_data.GetTreeviewItemIndex()
		ContextName := extra_data.GetContextName()
		Title := extra_data.GetTitle()
		ClassName := extra_data.GetClassName()
		Code := extra_data.GetCode()
		ControlName := extra_data.GetControlName()
		Controltext := extra_data.GetControltext()
		Disabled := extra_data.GetDisabled()
		t:=New EditWindowContextDialog(TVItem, ContextName, Title, ClassName, Code, ControlName, ControlText,Disabled)
		t.ShowModal()
	}
	OnEditFileResourceItem(extra_data)
	{
		FileSelectFile, SelectedFile, S 26, , Type or Select File Name to Extract the File Resource to, All Files (*.*)
		if(SelectedFile)
		{
			Try {
                        
                        file := SelectedFile
                        if(FileExist(file))
                        {
                            ret := File ;if fail to delete return existing anyway
                            FileDelete %file%
                            
                        }
                        ;Create the file off the items base64 data
                        Base64Data := extra_data.GetBase64Code()
                        
                        Bytes := Base64Dec( BIN, Base64Data )
                        
                        VarZ_Save( BIN, Bytes, file )
                        
                        VarSetcapacity( Base64Data, 0 )
                        
                        VarSetcapacity( BIN, 0 )
						SplitPath, file, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
						explorerpath := "explorer /select," file
						Run, %explorerpath%

                    }
                    Catch e
                    {
                        Debug.WriteStackPushPop("Exception Writing File " . file, Debug.ErrLevelImportant)
                    }
		}
	}
	OnDeleteWindowContextItem(extra_data)
	{
		Debug.WriteStackPushPop("OnDeleteWindowContextItem()",Debug.ErrLevelCore)
		ContextName := extra_data.GetContextName()
		MsgBox, 8228, Hot Key Speak , Delete this Window Context (%ContextName%) and all items it contains? `n`nAre you Sure?
		IfMsgBox, No
		{
			return
		}
		gFileChanged:=true
		TVItem := extra_data.GetTreeviewItemIndex()
		DeleteTVBranch.Delete(TVItem)
		this.UpdateLiveData(extra_data,true)
	}
	OnAddCommandItem( cname := "Command",SpeakText := "Type The Sentence Here|Two if you need to",HotKeys := "",Code := -1)
	{
		if(code == -1)
		{
			code := gSampleCode
		}
		gFileChanged:=true
		Debug.WriteStackPushPop("OnAddCommandItem()",Debug.ErrLevelCore)
		TemplateName := cname
		ct := 1
		FinalName := TemplateName . ct
		RootExe := FindFirstItem.FindRootExe(TVHelper.GetSelectedItem())
		while(FindFirstItem.FindMatchingCommandName(FinalName,RootExe))
		{
			ct++
			FinalName := TemplateName . ct
		}
		extra_data := New TVCommandItem(FinalName, 0, 0, TV_ICONS.COMMAND, SpeakText, HotKeys, Code)
		this.ItemAddFinalize(extra_data)
		this.UpdateLiveData(extra_data)
	}
	OnChangeCommandItem(TVItem, CommandName, SpeakText, HotKeys, Code,Disabled)
	{
		gFileChanged:=true
		Debug.WriteStackPushPop("OnChangeCommandItem()",Debug.ErrLevelCore)
		extra_data := this.m_TVExtraData.GetItem(TVItem)
		extra_data.SetCommandName(CommandName)
		extra_data.SetSpeakText(SpeakText)
		extra_data.SetHotKeys(HotKeys)
		extra_data.SetCode(Code)
		extra_data.SetDisabled(Disabled)
		TVHelper.SetItemText(extra_data.GetTreeviewItemIndex(),extra_data.GetTreeviewItemText())
		TVHelper.SortBranch(extra_data.GetTreeviewParentIndex())
		this.UpdateLiveData(extra_data)
	}
	OnEditCommandItem(extra_data)
	{
		
		Debug.WriteStackPushPop("OnEditCommandItem()",Debug.ErrLevelCore)
		TVItem := extra_data.GetTreeviewItemIndex()
		CommandName := extra_data.GetCommandName()
		SpeakText := extra_data.GetSpeakText()
		HotKeys := extra_data.GetHotKeys()
		Code := extra_data.GetCode()
		Disabled := extra_data.GetDisabled()
		t:=New EditCommandDialog(TVItem, CommandName, SpeakText, HotKeys, Code,Disabled)
		t.ShowModal()
	}
	OnDeleteCommandItem(extra_data)
	{
		Debug.WriteStackPushPop("OnDeleteCommandItem()",Debug.ErrLevelCore)
		CommandName := extra_data.GetCommandName()
		MsgBox, 8228, Hot Key Speak , Delete this Command (%CommandName%) and all items it contains? `n`nAre you Sure?
		IfMsgBox, No
		{
			return
		}
		gFileChanged:=true
		
		TVItem := extra_data.GetTreeviewItemIndex()
		DeleteTVBranch.Delete(TVItem)
		this.UpdateLiveData(extra_data,true)
	}
	OnResize(Width, Height)
	{
		Debug.WriteStackPushPop("OnResize()",Debug.ErrLevelCore)
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
		GuiControlGet, StatusPos,Pos, MainUIStatusBar_Control
		GuiControlGet, TreePosPos,Pos, MainUITreeview_Control
		GuiControl, Move, MainUIStatusBar_Control, % "X0 Y" . (Height - StatusPosH)
		GuiControl, Move, MainUITreeview_Control, % "H" . (Height - TreePosPosY - StatusPosH) . " W" . (Width)
		Gui, %last%:Default
	}
	OnControlEvent()
	{
		if(A_GuiEvent = "DoubleClick")
		{
			this.OnEditItem()
		}
		else if(A_GuiEvent = "S")
		{
			if(GetKeyState("ctrl", "P"))
			{
				KeyWait, ctrl

				extra_data := TVHelper.ToExtraData(TVHelper.GetSelectedItem())
				EventManager.SetActiveData(extra_data)

			}
		}
	}
	GetHandle()
	{
		Debug.WriteStackPushPop("GetHandle()",Debug.ErrLevelCore)
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
		GuiControlGet, OutputVar, Hwnd, MainUITreeview_Control
		Gui, %last%:Default
		return OutputVar
	}
	OnRightClick(EventInfo,X, Y)
	{
		Debug.WriteStackPushPop("OnRightClick()",Debug.ErrLevelCore)
		;Right click on control
		If(EventInfo) ; and TV_GetSelection())
		{
			TVHelper.SelectItem(EventInfo) 
			this.OnItemRightClick(EventInfo,X, Y)
		}
	}
	OnItemRightClick(Item,X,Y)
	{
		Debug.WriteStackPushPop("OnItemRightClick()",Debug.ErrLevelCore)
		this.m_LastItemSelected := Item

		;right click on an item
		extra_data := this.m_TVExtraData.GetItem(Item)
		this.m_RightClickMenu.SetContext(extra_data.GetType(),extra_data.GetGroupType(),Item,extra_data)
		this.m_RightClickMenu.Show(X,Y)
	}
	OnEditItem()
	{
		Debug.WriteStackPushPop("OnEditItem()",Debug.ErrLevelCore)
		TVItem :=TVHelper.GetSelectedItem()
		this.m_LastItemSelected := TVItem
		if(TVItem)
		{
			extra_data := this.m_TVExtraData.GetItem(TVItem)
			ThisType := extra_data.GetType()
			if( ThisType = TV_TYPES.GROUP)
			{
				this.OnEditGroupItem(extra_data)
			}
			else if( ThisType = TV_TYPES.EXE)
			{
				this.OnEditExeItem(extra_data)
			}
			else if( ThisType = TV_TYPES.COMMAND)
			{
				this.OnEditCommandItem(extra_data)
			}
			else if( ThisType = TV_TYPES.CONTEXT)
			{
				this.OnEditContextItem(extra_data)
			}
			else if( ThisType = TV_TYPES.WINDOWCONTEXT)
			{
				this.OnEditWindowContextItem(extra_data)
			}
			else if( ThisType = TV_TYPES.FILERESOURCE)
			{
				this.OnEditFileResourceItem(extra_data)
			}
		}
	}
	OnDeleteItem()
	{
		Debug.WriteStackPushPop("OnDeleteItem()",Debug.ErrLevelCore)
		TVItem :=TVHelper.GetSelectedItem()
		if(TVItem)
		{
			extra_data := this.m_TVExtraData.GetItem(TVItem)
			ThisType := extra_data.GetType()
			if( ThisType = TV_TYPES.EXE)
			{
				this.OnDeleteExeItem(extra_data)
			}
			else if( ThisType = TV_TYPES.GROUP)
			{
				this.OnDeleteGroupItem(extra_data)
			}
			else if( ThisType = TV_TYPES.COMMAND)
			{
				this.OnDeleteCommandItem(extra_data)
			}
			else if( ThisType = TV_TYPES.CONTEXT)
			{
				this.OnDeleteContextItem(extra_data)
			}
			else if( ThisType = TV_TYPES.WINDOWCONTEXT)
			{
				this.OnDeleteWindowContextItem(extra_data)
			}
			else if( ThisType = TV_TYPES.FILERESOURCE)
			{
				this.OnDeleteFileResourceItem(extra_data)
			}
		}
		
	}
	OnSpacePressedItem()
	{
		Debug.WriteStackPushPop("OnSpacePressedItem()",Debug.ErrLevelCore)
		TVItem :=TVHelper.GetSelectedItem()
		if(TVItem)
		{
			extra_data := this.m_TVExtraData.GetItem(TVItem)
			Type := extra_data.GetType()
			if(Type = TV_TYPES.COMMAND)
			{
				this.OnEditItem()
			}
			else
			{
				if(TVHelper.IsExpanded(TVItem))
				{
					TVHelper.CollapseItem(TVItem)
				}
				else
				{
					TVHelper.ExpandItem(TVItem)
				}
			}
		}
	}
	OnCtrlSpacePressedItem()
	{
		Debug.WriteStackPushPop("OnCtrlSpacePressedItem()",Debug.ErrLevelCore)
		TVItem :=TVHelper.GetSelectedItem()
		if(TVItem)
		{
			extra_data := this.m_TVExtraData.GetItem(TVItem)
			Type := extra_data.GetType()
			if(Type = TV_TYPES.COMMAND)
			{
				this.OnEditItem()
			}
			else
			{
				this.OnItemRightClick(TVItem,100,100)
			}
		}
	}
	SaveTree()
	{
		if(gFileChanged)
		{
			Debug.WriteStackPushPop("SaveTree()",Debug.ErrLevelCore)
			BackupOldFile.Backup()
			SaveMainTreeView.Save(A_MyDocuments . "\HotKeySpeak\SaveFolder\treeview.xml",0)
			SaveMainTreeViewSpeech.Save(A_MyDocuments . "\HotKeySpeak\SaveFolder\speech.xml",0)
			gFileChanged := False
		}
		
	}
	LoadTree()
	{
		Debug.WriteStackPushPop("LoadTree()",Debug.ErrLevelCore)
		try
		{
				tvfile := A_MyDocuments . "\HotKeySpeak\SaveFolder\treeview.xml"
				if(!FileExist(tvfile))
				{
					BackupFile := A_ScriptDir . "\SaveFolder\BlankBackup\treeview.xml"
					if(!FileExist(BackupFile))
					{
						Debug.WriteStackPushPop("File Not Exists " . BackupFile, Debug.ErrLevelCore)
					}
					else
					{
						FileCreateDir, %A_MyDocuments%\HotKeySpeak
						FileCreateDir, %A_MyDocuments%\HotKeySpeak\SaveFolder
						FileCopy, %BackupFile%, %tvfile%, true
					}
				}

				speechfile := A_MyDocuments . "\HotKeySpeak\SaveFolder\speech.xml"
				if(!FileExist(speechfile))
				{
					BackupFile := A_ScriptDir . "\SaveFolder\BlankBackup\speech.xml"
					
					if(!FileExist(BackupFile))
					{
						Debug.WriteStackPushPop("File Not Exists " . BackupFile, Debug.ErrLevelCore)
					}
					else
					{
						FileCreateDir, %A_MyDocuments%\HotKeySpeak
						FileCreateDir, %A_MyDocuments%\HotKeySpeak\SaveFolder
						FileCopy, %BackupFile%, %speechfile%, true
					}
				}
				
				LoadMainTreeView.Load(tvfile,0)
				MainTreeviewSpeech.Load(speechfile)
				LoadMainTreeViewKeycode.Load(0)
				LoadMainTreeRuleNames.Load(0)
				

		}
        catch e
        {
            Debug.WriteStackPop("LoadTree() Failed " . e.Message, 100)
        }
	}
	OnCopy()
	{
		this.m_IsCut :=0
		this.m_CopyFromTVItem :=0
		this.m_CopyFrom_extra_data :=0
		TVItem :=TVHelper.GetSelectedItem()
		if(TVItem)
		{
			extra_data := this.m_TVExtraData.GetItem(TVItem)
			if(extra_data)
			{
				this.m_CopyFromTVItem := TVItem
				this.m_CopyFrom_extra_data := extra_data
			}
		}
	}
	OnCut()
	{
		this.m_IsCut :=0
		this.m_CopyFromTVItem :=0
		this.m_CopyFrom_extra_data :=0
		TVItem :=TVHelper.GetSelectedItem()
		if(TVItem)
		{
			extra_data := this.m_TVExtraData.GetItem(TVItem)
			if(extra_data)
			{
				this.m_CopyFromTVItem := TVItem
				this.m_CopyFrom_extra_data := extra_data
				this.m_IsCut :=1
			}
		}
	}
	OnPaste()
	{
		TVParentItem:=TVHelper.GetSelectedItem()
		TVHelper.SetItemParent(this.m_CopyFromTVItem,TVParentItem)
		TVHelper.SortBranch(TVParentItem)
		if(this.m_IsCut)
		{
			DeleteTVBranch.Delete(this.m_CopyFromTVItem)
			this.m_IsCut :=0
			this.m_CopyFromTVItem :=0
			this.m_CopyFrom_extra_data :=0
		}
		TVHelper.SelectItem(TVParentItem)
		gFileChanged:=true
	}
	OnSaveToFile()
	{
		TVItem :=TVHelper.GetSelectedItem()
		extra_data := TVHelper.ToExtraData(TVItem)
		if(extra_data)
		{
			type := extra_data.GetType()
			if(type == TV_TYPES.EXE)
			{
				filter := "Single Program Type (*.exehks)"
				ext := "exehks"
			}
			else if(type == TV_TYPES.APPS)
			{
				filter := "Program List Type (*.appshks)"
				ext := "appshks"
			}
			else if(type == TV_TYPES.GROUP && extra_data.GetGroupType() == TV_TYPES.APPS)
			{
				filter := "Program List Type (*.exehks)"
				ext := "exehks"
			}
			else
			{
				filter := "Simple Type (*.simphks)"
				ext := "simphks"
			}
			StartPath := A_MyDocuments . "\HotKeySpeak\SaveFolder"
			FileSelectFile, Filename , s2, %StartPath%, Save to File, %Filter%
			if(Filename)
			{
				SplitPath, Filename , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
			
				if(OutExtension != ext)
				{
					MsgBox , 4160 , Save to File, The file extention will be changed to .%ext%
				}
				FixedFilename := OutDir . "\" . OutNameNoExt . "." . ext
				GoodToGo := true
				if(FileExist(FixedFilename))
				{
					DisplayableFile := StrReplace(FixedFilename, "\","\ ")
					MsgBox , 4164 , Save to File, Overwrite existing file?`n%DisplayableFile% 
					IfMsgBox, No
            		{
						GoodToGo := false
					}
				}
				if(GoodToGo)
				{
					SaveMainTreeView.Save(FixedFilename,TVItem)
				}
			}
		}
	}
	OnLoadFromFile(fn:="")
	{
		TVItem :=TVHelper.GetSelectedItem()
		extra_data := TVHelper.ToExtraData(TVItem)
		if(extra_data = )
		{
			return
		}
		
		GoodToGo := true
		Filename := fn	
		if(fn=="")
		{
			filter := "Hot Key Speak Files (*.*hks)"
			StartPath := A_MyDocuments . "\HotKeySpeak\SaveFolder"
			FileSelectFile, Filename , s1, %StartPath%, Load From File, %Filter%
		}
		else
		{
			DisplayableFile := StrReplace(fn, "\","\ ")
			MsgBox , 4164 , Import File, Do you wish to import the file you just clicked?`n%DisplayableFile% 
			IfMsgBox, No
			{
				return
			}
		}
		if(Filename)
		{
			SplitPath, Filename , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		
			if(!TVHelper.IsValInArrCI(OutExtension,["exehks","appshks","simphks"]))
			{
				MsgBox , 4160 , Load From File, The file extention is not recognized
				return
			}
			if(!FileExist(Filename))
			{
				DisplayableFile := StrReplace(Filename, "\","\ ")
				MsgBox , 4160 , Load From File, The file does not exist!`n%DisplayableFile% 
				return
			}
			type := extra_data.GetType()
			if(type == TV_TYPES.EXE)
			{
				if(OutExtension != "simphks")
				{
					MsgBox , 4160 , Load From File, Can't load that file on that item... Incompatible Data!
					return
				}
				
			}
			else if(extra_data.GetGroupType() == TV_TYPES.APPS)
			{
				if(OutExtension == "simphks")
				{
					if(fn=="")
					{
						MsgBox , 4160 , Load From File, You will need to add this file via right click
					}
					else
					{
						MsgBox , 4160 , Load From File, Can't load that file on that item... Incompatible Data!
					}
					return
				}
			}
			else
			{
				if(OutExtension != "simphks")
				{
					MsgBox , 4160 , Load From File, Can't load that file on that item... Incompatible Data!
					return
				}
			}
			if(GoodToGo)
			{
				LoadMainTreeView.Load(Filename,TVItem)
				RepairGroupTypes.Repair(TVItem)
				TVHelper.SortBranch(TVItem)
				TVHelper.SelectItem(TVItem)
				gFileChanged:=true
			}
		}
	}
	OnResolveIssues()
	{
		TVItem :=TVHelper.GetSelectedItem()
		Debug.Show()
		Debug.WriteClear("")
		Debug.WriteNL("")
		Debug.WriteNL("")
		Debug.WriteNL("Scan for Issues...")
		Debug.WriteNL("")
		Debug.WriteNL("If a line with >Item(N) appears, click the line and Press Enter to View")
		Debug.WriteNL("")
		Debug.WriteNL("")
		Debug.WriteNL("Repairing Group Types")
		Debug.WriteNL("")
		RepairGroupTypes.Repair(TVItem,1)
		Debug.WriteNL("")
		Debug.WriteNL("")
		Debug.WriteNL("Scanning For Duplicate Action Names")
		Debug.WriteNL("")
		ScanActionsForDuplicates.Scan(TVItem)
		Debug.WriteNL("")
		Debug.WriteNL("")
		Debug.WriteNL("Scanning For Duplicate Function Names")
		Debug.WriteNL("")
		ScanActionCodesForDuplicateFunctions.Scan(TVItem)
		Debug.WriteNL("")
		Debug.WriteNL("")
		Debug.WriteNL("Done!")
		Debug.WriteNL("")
		
        
		
	}
}
;Event handler for the treeview
MainUITreeview_Control()
{
	MainUITreeview_Control_Instance.OnControlEvent()
}

MainUITreeview_ENTERButton()
{
	MainUITreeview_Control_Instance.OnSpacePressedItem()
}

return
#IfWinActive, Hot Key Speak
F2::MainUITreeview_Control_Instance.OnEditItem()
#if
return

;ctrl+space edit
#IfWinActive, Hot Key Speak
^enter::MainUITreeview_Control_Instance.OnCtrlSpacePressedItem()
#if
return

#IfWinActive, Hot Key Speak
del::
if(GetActiveWindow()==hMainUIWindow)
	MainUITreeview_Control_Instance.OnDeleteItem()
else
	send, {del}
#if
return