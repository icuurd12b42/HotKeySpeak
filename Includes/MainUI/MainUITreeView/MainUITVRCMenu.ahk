

global MainUITVRCMenu_mnu

Class MainUITVRCMenu
{
	__New()
	{

		Menu, MainUITVRCMenu_mnu, Add, Add Application, OnTVRCMenuAddApplication
		Menu, MainUITVRCMenu_mnu, Add, Add Command, OnTVRCMenuAddCommand
		Menu, MainUITVRCMenu_mnu, Add, Add Context, OnTVRCMenuAddContext
		Menu, MainUITVRCMenu_mnu, Add, Add Window Context, OnTVRCMenuAddWindowContext
		Menu, MainUITVRCMenu_mnu, Add
		Menu, MainUITVRCMenu_mnu, Add, Add Group, OnTVRCMenuAddGroup
		Menu, MainUITVRCMenu_mnu, Add, Add Resource, OnTVRCMenuAddResource
		Menu, MainUITVRCMenu_mnu, Add
		Menu, MainUITVRCMenu_mnu, Add, Edit, OnTVRCMenuEdit
		Menu, MainUITVRCMenu_mnu, Add
		Menu, MainUITVRCMenu_mnu, Add, Cut (Prep for Move), OnTVRCMenuCut
		Menu, MainUITVRCMenu_mnu, Add, Copy (Prep for Clone), OnTVRCMenuCopy
		Menu, MainUITVRCMenu_mnu, Add, Paste (Copy/Move To), OnTVRCMenuPaste
		;Menu, MainUITVRCMenu_mnu, Add, Paste (Disobey Context), OnTVRCMenuPaste
		Menu, MainUITVRCMenu_mnu, Add
		Menu, MainUITVRCMenu_mnu, Add, Save to File, OnTVRCSaveToFile
		Menu, MainUITVRCMenu_mnu, Add, Load From File, OnTVRCLoadFromFile
		Menu, MainUITVRCMenu_mnu, Add
		Menu, MainUITVRCMenu_mnu, Add, Scan For Issues, OnTVRCResolveIssues
		Menu, MainUITVRCMenu_mnu, Add
		Menu, MainUITVRCMenu_mnu, Add, Delete, OnTVRCMenuDelete

		
		
	}
	Show(X,Y)
	{
		PopUpMenuFix.ShowPopUp("MainUITVRCMenu_mnu", X, Y)
	}
	SetContext(ItemType,GroupType, SelTVItem, SelExtraData)
	{
		PasteEnabled := false
		IsGroup := False
		if(MainUITreeview_Control_Instance.m_CopyFromTVItem)
		{
			found:=TVHelper.FindUpTree(MainUITreeview_Control_Instance.m_CopyFromTVItem,SelTVItem)
			
				
			if(!found)
			{
				from_extra_data := MainUITreeview_Control_Instance.m_CopyFrom_extra_data
				to_extra_data := SelExtraData
				from_type := from_extra_data.GetGroupType()
				to_type := SelExtraData.GetGroupType()
				if(from_type == TV_TYPES.APPS)
				{
					PasteEnabled := to_type == TV_TYPES.APPS
				}
				else if(from_type == TV_TYPES.EXE)
				{
					PasteEnabled := to_type == TV_TYPES.APPS
				}
				else if(from_type == TV_TYPES.COMMAND)
				{
					PasteEnabled := TVHelper.IsValInArr(to_type, [TV_TYPES.EXE,TV_TYPES.CONTEXT,TV_TYPES.WINDOWCONTEXT])
				}
				else if(from_type == TV_TYPES.CONTEXT)
				{
					PasteEnabled := TVHelper.IsValInArr(to_type, [TV_TYPES.EXE,TV_TYPES.CONTEXT,TV_TYPES.WINDOWCONTEXT])
				}
				else if(from_type == TV_TYPES.WINDOWCONTEXT)
				{
					PasteEnabled := TVHelper.IsValInArr(to_type, [TV_TYPES.EXE])
				}
				else if(from_type == TV_TYPES.FILERESOURCE)
				{
					PasteEnabled := TVHelper.IsValInArr(to_type, [TV_TYPES.EXE])
				}
				if(PasteEnabled==false && from_extra_data.GetType() == TV_TYPES.GROUP)
				{
					if(to_type == from_type)
					{
						PasteEnabled := true
					}
					IsGroup := (from_type != TV_TYPES.APPS && from_type != TV_TYPES.EXE)
				}
				if(PasteEnabled==true && from_extra_data.GetType() == TV_TYPES.GROUP)
				{
					if(to_type == TV_TYPES.APPS && (from_type != TV_TYPES.APPS && from_type != TV_TYPES.EXE))
					{
						PasteEnabled := false
					}
					IsGroup := false
				}
			}
		}
		PasteEnabledOption = Disable
		PasteDisobeyEnabledOption = Disable
		if(PasteEnabled)
		{
			PasteEnabledOption = Enable
		}
		/*
		else
		{
			if(IsGroup)
			{
				PasteDisobeyEnabledOption = Enable 
			}
		}
		*/
		Menu, MainUITVRCMenu_mnu, Disable, Add Application
		Menu, MainUITVRCMenu_mnu, Disable, Add Command
		Menu, MainUITVRCMenu_mnu, Disable, Add Context
		Menu, MainUITVRCMenu_mnu, Disable, Add Window Context
		Menu, MainUITVRCMenu_mnu, Disable, Add Group
		Menu, MainUITVRCMenu_mnu, Disable, Add Resource
		
		Menu, MainUITVRCMenu_mnu, Disable, Edit
		
		Menu, MainUITVRCMenu_mnu, Disable, Cut (Prep for Move)
		Menu, MainUITVRCMenu_mnu, Disable, Copy (Prep for Clone)
		Menu, MainUITVRCMenu_mnu, Disable, Paste (Copy/Move To)
		;Menu, MainUITVRCMenu_mnu, Disable, Paste (Disobey Context)
		
		Menu, MainUITVRCMenu_mnu, Disable, Save to File
		Menu, MainUITVRCMenu_mnu, Disable, Load From File

		Menu, MainUITVRCMenu_mnu, Disable, Scan For Issues
		
		Menu, MainUITVRCMenu_mnu, Disable, Delete

		if(ItemType = TV_TYPES.APPS)
		{
			Menu, MainUITVRCMenu_mnu, Enable, Add Application
			Menu, MainUITVRCMenu_mnu, Default, Add Application
			Menu, MainUITVRCMenu_mnu, Enable, Add Group
			;Menu, MainUITVRCMenu_mnu, Enable, Cut (Prep for Move)
			;Menu, MainUITVRCMenu_mnu, Enable, Copy (Prep for Clone)
			Menu, MainUITVRCMenu_mnu, %PasteEnabledOption%, Paste (Copy/Move To)
			;Menu, MainUITVRCMenu_mnu, %PasteDisobeyEnabledOption%, Paste (Disobey Context)
			Menu, MainUITVRCMenu_mnu, Enable, Save to File
			Menu, MainUITVRCMenu_mnu, Enable, Load From File
			
		}
		else if(ItemType = TV_TYPES.FILERESOURCE)
		{
			Menu, MainUITVRCMenu_mnu, Enable, Cut (Prep for Move)
			Menu, MainUITVRCMenu_mnu, Enable, Copy (Prep for Clone)
			Menu, MainUITVRCMenu_mnu, Enable, Save to File
		    Menu, MainUITVRCMenu_mnu, Enable, Edit
			Menu, MainUITVRCMenu_mnu, Default, Edit
			Menu, MainUITVRCMenu_mnu, Enable, Delete
		}
		else if(ItemType = TV_TYPES.EXE)
		{
			Menu, MainUITVRCMenu_mnu, Enable, Add Command
			Menu, MainUITVRCMenu_mnu, Default, Add Command
			Menu, MainUITVRCMenu_mnu, Enable, Add Context
			Menu, MainUITVRCMenu_mnu, Enable, Add Window Context
			Menu, MainUITVRCMenu_mnu, Enable, Add Group
			Menu, MainUITVRCMenu_mnu, Enable, Add Resource
			Menu, MainUITVRCMenu_mnu, Enable, Delete
			Menu, MainUITVRCMenu_mnu, Enable, Edit
			Menu, MainUITVRCMenu_mnu, Enable, Cut (Prep for Move)
			Menu, MainUITVRCMenu_mnu, Enable, Copy (Prep for Clone)
			Menu, MainUITVRCMenu_mnu, Enable, Save to File
			Menu, MainUITVRCMenu_mnu, Enable, Load From File
			Menu, MainUITVRCMenu_mnu, %PasteEnabledOption%, Paste (Copy/Move To)
			;Menu, MainUITVRCMenu_mnu, %PasteDisobeyEnabledOption%, Paste (Disobey Context)
			Menu, MainUITVRCMenu_mnu, Enable, Scan For Issues
		}
		else if(ItemType = TV_TYPES.COMMAND)
		{
			Menu, MainUITVRCMenu_mnu, Enable, Delete
			Menu, MainUITVRCMenu_mnu, Enable, Edit
			Menu, MainUITVRCMenu_mnu, Default, Edit
			Menu, MainUITVRCMenu_mnu, Enable, Cut (Prep for Move)
			Menu, MainUITVRCMenu_mnu, Enable, Copy (Prep for Clone)
			Menu, MainUITVRCMenu_mnu, Enable, Save to File
		}
		else if(ItemType = TV_TYPES.CONTEXT)
		{
			Menu, MainUITVRCMenu_mnu, Enable, Add Command
			Menu, MainUITVRCMenu_mnu, Enable, Add Context
			Menu, MainUITVRCMenu_mnu, Enable, Add Group
			Menu, MainUITVRCMenu_mnu, Enable, Delete
			Menu, MainUITVRCMenu_mnu, Enable, Edit
			Menu, MainUITVRCMenu_mnu, Default, Edit
			Menu, MainUITVRCMenu_mnu, Enable, Cut (Prep for Move)
			Menu, MainUITVRCMenu_mnu, Enable, Copy (Prep for Clone)
			Menu, MainUITVRCMenu_mnu, Enable, Save to File
			Menu, MainUITVRCMenu_mnu, Enable, Load From File
			Menu, MainUITVRCMenu_mnu, %PasteEnabledOption%, Paste (Copy/Move To)
			;Menu, MainUITVRCMenu_mnu, %PasteDisobeyEnabledOption%, Paste (Disobey Context)
		}
		else if(ItemType = TV_TYPES.WINDOWCONTEXT)
		{
			Menu, MainUITVRCMenu_mnu, Enable, Add Command
			Menu, MainUITVRCMenu_mnu, Enable, Add Context
			Menu, MainUITVRCMenu_mnu, Enable, Add Group
			Menu, MainUITVRCMenu_mnu, Enable, Delete
			Menu, MainUITVRCMenu_mnu, Enable, Edit
			Menu, MainUITVRCMenu_mnu, Default, Add Command
			Menu, MainUITVRCMenu_mnu, Enable, Cut (Prep for Move)
			Menu, MainUITVRCMenu_mnu, Enable, Copy (Prep for Clone)
			Menu, MainUITVRCMenu_mnu, Enable, Save to File
			Menu, MainUITVRCMenu_mnu, Enable, Load From File
			Menu, MainUITVRCMenu_mnu, %PasteEnabledOption%, Paste (Copy/Move To)
			;Menu, MainUITVRCMenu_mnu, %PasteDisobeyEnabledOption%, Paste (Disobey Context)
		}
		else if(ItemType = TV_TYPES.GROUP)
		{
			Menu, MainUITVRCMenu_mnu, Enable, Add Group
			Menu, MainUITVRCMenu_mnu, Enable, Delete
			Menu, MainUITVRCMenu_mnu, Enable, Edit
			Menu, MainUITVRCMenu_mnu, Default, Edit
			Menu, MainUITVRCMenu_mnu, Enable, Cut (Prep for Move)
			Menu, MainUITVRCMenu_mnu, Enable, Copy (Prep for Clone)
			Menu, MainUITVRCMenu_mnu, Enable, Save to File
			Menu, MainUITVRCMenu_mnu, Enable, Load From File
			Menu, MainUITVRCMenu_mnu, %PasteEnabledOption%, Paste (Copy/Move To)
			;Menu, MainUITVRCMenu_mnu, %PasteDisobeyEnabledOption%, Paste (Disobey Context)

			if(GroupType = TV_TYPES.EXE)
			{
				Menu, MainUITVRCMenu_mnu, Enable, Add Command
				Menu, MainUITVRCMenu_mnu, Enable, Add Context
				Menu, MainUITVRCMenu_mnu, Enable, Add Resource
				Menu, MainUITVRCMenu_mnu, Enable, Add Window Context
			}
			else if(GroupType = TV_TYPES.APPS)
			{
				Menu, MainUITVRCMenu_mnu, Enable, Add Application
				Menu, MainUITVRCMenu_mnu, Default, Add Application
				Menu, MainUITVRCMenu_mnu, Enable, Add Group
			}
			if(GroupType = TV_TYPES.CONTEXT)
			{
				Menu, MainUITVRCMenu_mnu, Enable, Add Command
				Menu, MainUITVRCMenu_mnu, Enable, Add Context
			}
			if(GroupType = TV_TYPES.WINDOWCONTEXT)
			{
				Menu, MainUITVRCMenu_mnu, Enable, Add Command
				Menu, MainUITVRCMenu_mnu, Enable, Add Context
			}
			
		}
	}
}
OnTVRCMenuAddApplication()
{
	ListProcessDialog.Create(MainUIWindow)
	ListProcessDialog.ShowModal(hMainUIWindow)
}
OnTVRCMenuAddCommand()
{
	MainUITreeview_Control_Instance.OnAddCommandItem()
}
OnTVRCMenuAddContext()
{
	MainUITreeview_Control_Instance.OnAddContextItem()
}
OnTVRCMenuAddWindowContext()
{
	MainUITreeview_Control_Instance.OnAddWindowContextItem()
}
OnTVRCMenuAddGroup()
{
	MainUITreeview_Control_Instance.OnAddGroupItem()
}
OnTVRCMenuAddResource()
{
	MainUITreeview_Control_Instance.OnAddFileResourceItem()
}
OnTVRCMenuEdit()
{
	MainUITreeview_Control_Instance.OnEditItem()
	
}
OnTVRCMenuDelete()
{
	MainUITreeview_Control_Instance.OnDeleteItem()
}

OnTVRCMenuCopy()
{
	MainUITreeview_Control_Instance.OnCopy()
}

OnTVRCMenuPaste()
{
	MainUITreeview_Control_Instance.OnPaste()
}

OnTVRCMenuCut()
{
	MainUITreeview_Control_Instance.OnCut()
}

OnTVRCResolveIssues()
{
	MainUITreeview_Control_Instance.OnResolveIssues()
}

OnTVRCSaveToFile()
{
	MainUITreeview_Control_Instance.OnSaveToFile()
}

OnTVRCLoadFromFile()
{
	MainUITreeview_Control_Instance.OnLoadFromFile()
}
