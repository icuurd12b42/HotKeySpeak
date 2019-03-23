;the structure of the array held in the the exe item
;the array element are:
;[
;[type,command,hot key or context array, context array],
;[type,command,hot key or context array, context array],
;...
;]
;Context array is the same structure. it's recursive
;[TV_TYPES.COMMAND,"COMMANDNAME","F1"])
;[TV_TYPES.CONTEXT,"CONTEXTNAME","F2",ContextArray])
;[TV_TYPES.WINDOWCONTEXT,"CONTEXTNAME",ContextArray])


class HotKeySystem
{
    m_PrimaryHotKeysArray := ;the array under the current context
    m_SecondaryHotKeysArray := ;the array at the context level
    m_TerciaryHotKeysArray := ;the root array for the exe/window context
    m_process_extra_data :=
    m_old_process_extra_data :=
    m_old_extra_data :=
    Init()
    {
        HotKeySystem.m_PrimaryHotKeysArray := 0
        HotKeySystem.m_SecondaryHotKeysArray := 0
        HotKeySystem.m_TerciaryHotKeysArray := 0
        HotKeySystem.m_process_extra_data := 0
        HotKeySystem.m_old_extra_data:=0
        HotKeySystem.m_old_process_extra_data:=0
        
        EventManager.AddHandler(HotKeySystem)
    }
    SetupHotKey(KeyName, ONOFF)
    {
        if(KeyName == "") 
            return
        Debug.WriteStackPushPop("HotKeySystem.SetupHotKey() " . KeyName . " " . ONOFF,Debug.ErrLevelCore)
        Try {
            Hotkey, %KeyName%, HotKeyHandler, %ONOFF%
        }
        catch e
        {
            Debug.WriteStackPop("Failed to register Hot Key " . KeyName, Debug.ErrCodingInfo)
        }
    }
    
    ;Deactivate the hot keys in array without recursion to only deactivate what's in context
    SetupHotKeysFromArray(Array, ONOFF)
    {
        if(Array == 0) 
            return
        Debug.WriteStackPush("HotKeySystem.SetupHotKeysFromArray() Start",Debug.ErrLevelCore)
        for each, element in Array
        {
            if(element[1] == TV_TYPES.CONTEXT || element[1] == TV_TYPES.COMMAND)
            {
                HotKeySystem.SetupHotKey(element[3], ONOFF)
            }
        }
        Debug.WriteStackPop("HotKeySystem.SetupHotKeysFromArray() End",Debug.ErrLevelCore)
    }
    FindItemNameByHotKeyInArray(zeHotKey, Array)
    {
        if(Array == 0) 
        {
            return ""
        }
        if (zeHotKey == "")
        {
            return ""
        }
        ret := ""
        Debug.WriteStackPush("HotKeySystem.FindContextInArray() Start",Debug.ErrLevelCore)
        for each, element in Array
        {
            if(element[3] == zeHotKey)
            {
                ret := element[2]
                break
            }
        }
        Debug.WriteStackPop("HotKeySystem.FindContextInArray() End",Debug.ErrLevelCore)
        return ret
    }
    FindItemNameByHotKey(zeHotKey)
    {
        if (zeHotKey == "")
        {
            return ""
        }
        Debug.WriteStackPush("HotKeySystem.FindItemNameByHotKey() Start",Debug.ErrLevelCore)
        ret := ""
        Array := [HotKeySystem.m_PrimaryHotKeysArray,HotKeySystem.m_SecondaryHotKeysArray,HotKeySystem.m_TerciaryHotKeysArray]
        for each, element in Array
        {
            ret :=  HotKeySystem.FindItemNameByHotKeyInArray(zeHotKey, element)
            if(ret != "")
            {
                break
            }
           
        }
        Array := 0
        Debug.WriteStackPop("HotKeySystem.FindItemNameByHotKey() End",Debug.ErrLevelCore)
        return ret
    }
    ;event manager notification
    OnProcessActivate(extra_data)
    {
        HotKeySystem.m_old_process_extra_data := extra_data
        ;if(gHKDisabled)
        ;{
        ;    return
        ;}
        ;extra data is a exe item, can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
        HotKeySystem.m_PrimaryHotKeysArray := 0
        HotKeySystem.m_SecondaryHotKeysArray := 0
        HotKeySystem.m_TerciaryHotKeysArray := 0
        HotKeySystem.m_process_extra_data := 0
        if(extra_data)
        {
            ;activate the root/main hot keys
            
            HotKeySystem.m_TerciaryHotKeysArray := extra_data.GetHotKeysArray()
            HotKeySystem.SetupHotKeysFromArray(HotKeySystem.m_TerciaryHotKeysArray,"ON")
        }
        HotKeySystem.m_process_extra_data := extra_data
    }
    ;event manager notification
    OnProcessDeactivate(extra_data)
    {
        
        ;extra data is a exe item, can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
        
        HotKeySystem.SetupHotKeysFromArray(HotKeySystem.m_PrimaryHotKeysArray,"OFF")
        HotKeySystem.SetupHotKeysFromArray(HotKeySystem.m_SecondaryHotKeysArray,"OFF")
        HotKeySystem.SetupHotKeysFromArray(HotKeySystem.m_TerciaryHotKeysArray,"OFF")
        HotKeySystem.m_PrimaryHotKeysArray := 0
        HotKeySystem.m_SecondaryHotKeysArray := 0
        HotKeySystem.m_TerciaryHotKeysArray := 0
        HotKeySystem.m_process_extra_data := 0
    }
    ;event manager notification
    OnItemActivate(extra_data)
    {
        HotKeySystem.m_old_extra_data := extra_data
        ;if(gHKDisabled)
        ;{
        ;    return
        ;}
        ;extra data is a command, context or window context, can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
        if(extra_data)
        {
            type := extra_data.GetType()
            If(type == TV_TYPES.COMMAND )
            {
                HotKeySystem.m_PrimaryHotKeysArray := extra_data.GetParentHotKeysArray()
                HotKeySystem.m_SecondaryHotKeysArray := extra_data.m_ParentParentHotKeysArray
                HotKeySystem.m_TerciaryHotKeysArray := extra_data.GetRootHotKeysArray()
                
                HotKeySystem.SetupHotKeysFromArray(HotKeySystem.m_TerciaryHotKeysArray,"ON")
                HotKeySystem.SetupHotKeysFromArray(HotKeySystem.m_SecondaryHotKeysArray,"ON")
                HotKeySystem.SetupHotKeysFromArray(HotKeySystem.m_PrimaryHotKeysArray,"ON")
            }
            else If(type == TV_TYPES.CONTEXT)
            {
                HotKeySystem.m_PrimaryHotKeysArray := extra_data.GetHotKeysArray()
                HotKeySystem.m_SecondaryHotKeysArray := extra_data.GetParentHotKeysArray()
                HotKeySystem.m_TerciaryHotKeysArray := extra_data.GetRootHotKeysArray()
                
                HotKeySystem.SetupHotKeysFromArray(HotKeySystem.m_TerciaryHotKeysArray,"ON")
                HotKeySystem.SetupHotKeysFromArray(HotKeySystem.m_SecondaryHotKeysArray,"ON")
                HotKeySystem.SetupHotKeysFromArray(HotKeySystem.m_PrimaryHotKeysArray,"ON")
                
                
            }
            else if(type == TV_TYPES.WINDOWCONTEXT)
            {
                HotKeySystem.m_PrimaryHotKeysArray := extra_data.GetHotKeysArray()
                HotKeySystem.m_SecondaryHotKeysArray := 0
                HotKeySystem.m_TerciaryHotKeysArray := 0
                HotKeySystem.SetupHotKeysFromArray(HotKeySystem.m_PrimaryHotKeysArray,"ON")
            }
            else if(type == TV_TYPES.EXE)
            {
                HotKeySystem.m_PrimaryHotKeysArray := extra_data.GetHotKeysArray()
                HotKeySystem.m_SecondaryHotKeysArray := 0
                HotKeySystem.m_TerciaryHotKeysArray := 0
                HotKeySystem.SetupHotKeysFromArray(HotKeySystem.m_PrimaryHotKeysArray,"ON")
            }
        }
        else
        {
            HotKeySystem.m_PrimaryHotKeysArray := 0
            HotKeySystem.m_SecondaryHotKeysArray := 0
            HotKeySystem.m_TerciaryHotKeysArray := 0
        }
    }
    ;event manager notification
    OnItemDeactivate(extra_data)
    {
        
        ;extra data is a command, context or window context, , can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
        ;deactivate the context portion of the array
        
        HotKeySystem.SetupHotKeysFromArray(HotKeySystem.m_PrimaryHotKeysArray,"OFF")
        HotKeySystem.SetupHotKeysFromArray(HotKeySystem.m_SecondaryHotKeysArray,"OFF")
        HotKeySystem.SetupHotKeysFromArray(HotKeySystem.m_TerciaryHotKeysArray,"OFF")
        HotKeySystem.m_PrimaryHotKeysArray := 0
        HotKeySystem.m_SecondaryHotKeysArray := 0
        HotKeySystem.m_TerciaryHotKeysArray := 0
        
    }
    ;event manager notification
    OnTimer()
    {
        ;Called every n millisecs by the singleton EventManager Timer
    }
}

HotKeyHandler()
{
    if(HotKeySystem.m_process_extra_data)
    {
        ContextName := HotKeySystem.FindItemNameByHotKey(A_ThisHotkey)
        if(ContextName!="" && !gEditing && !Recognition.IsDictating() && !Recognition.m_TurnDictationOn)
        {
            ;send g
            TVHelper.IgnoreDisabled(True)
            tvitem:=FindFirstItem.FindMatchingContextName(ContextName,HotKeySystem.m_process_extra_data.GetTreeviewItemIndex())

            ;Calling the function that loops through all monitors breaks shit over time, possibly on other Manager ot even this hot key manager is the cause. who knows
            ;EventManager.SetActiveItem(TVHelper.ToExtraData(tvitem))

            ;so basically we do the interpreter and the treeview notification only... the same way the loop does in the SetActiveItem func...
            InterpreterHandler.OnItemDeactivate(EventManager.m_current_item_extra_data)
            TVItemSelectorHandler.OnItemDeactivate(EventManager.m_current_item_extra_data)
            EventManager.m_current_item_extra_data := TVHelper.ToExtraData(tvitem)
            TVItemSelectorHandler.OnItemActivate(EventManager.m_current_item_extra_data)
            InterpreterHandler.OnItemActivate(EventManager.m_current_item_extra_data)

            TVHelper.IgnoreDisabled(False)
        }
        if(gEditing)
        {
            send, %A_ThisHotkey%
        }
    }
}




class LoadMainTreeViewKeycode
{
    m_WhatsAValidBranch :=
    m_WhatsAValidAddItem :=
    m_Last_exe_extra_data :=
    m_last_hk_arrays := 
    m_last_hk_array :=
    m_last_root_array :=
    m_last_root_arrays :=
    m_last_parent_hk_array := 
    Load(StartBranch)
    {
        HotKeySystem.OnItemDeactivate(0)
        Debug.WriteStackPush("LoadMainTreeViewKeycode Load Start",Debug.ErrLevelCore)
        ThisInst := New LoadMainTreeViewKeycode()
        
        ThisInst.m_Last_exe_extra_data := 0
        ThisInst.m_last_hk_arrays := []
        ThisInst.m_last_hk_array := 0
        ThisInst.m_last_root_array := 0
        this.m_last_parent_hk_array := 0
        ThisInst.m_last_root_arrays := []
        
        ThisInst.m_WhatsAValidBranch := [TV_TYPES.APPS,TV_TYPES.EXE,TV_TYPES.CONTEXT,TV_TYPES.GROUP,TV_TYPES.WINDOWCONTEXT]
        ThisInst.m_WhatsAValidAddItem := [TV_TYPES.FILERESOURCE,TV_TYPES.APPS,TV_TYPES.EXE,TV_TYPES.COMMAND,TV_TYPES.CONTEXT,TV_TYPES.GROUP,TV_TYPES.WINDOWCONTEXT]

        TVHelper.recurse_filter(StartBranch, ThisInst.m_WhatsAValidAddItem, ThisInst.m_WhatsAValidBranch, ThisInst)
        
        ThisInst := 0
        Debug.WriteStackPop("LoadMainTreeViewKeycode Load End",Debug.ErrLevelCore)
    }
    ;TVHelper.recurse_filter notifications
    OnAdd(extra_data,type,tvitem)
    {
        Debug.WriteStack("LoadMainTreeViewKeycode OnAdd",Debug.ErrLevelCore)
        if(type == TV_TYPES.EXE)
        {
            extra_data.m_HotKeysArray := []
            this.m_last_hk_array := extra_data.GetHotKeysArray()
            this.m_last_root_array := this.m_last_hk_array
            this.m_last_parent_hk_array := 0
        }
        else if(type == TV_TYPES.COMMAND)
        {
            extra_data.m_ParentParentHotKeysArray := this.m_last_parent_hk_array
            extra_data.m_ParentHotKeysArray := this.m_last_hk_array
            extra_data.m_RootHotKeysArray := this.m_last_root_array
            this.m_last_hk_array.push([TV_TYPES.COMMAND,extra_data.GetCommandName(),extra_data.GetHotKeys()])
        }
        else if(type == TV_TYPES.CONTEXT)
        {
            this.m_last_parent_hk_array := this.m_last_hk_array
            extra_data.m_ParentHotKeysArray := this.m_last_hk_array
            extra_data.m_RootHotKeysArray := this.m_last_root_array
            extra_data.m_HotKeysArray := []
            newArr := extra_data.GetHotKeysArray()
            this.m_last_hk_array.push([TV_TYPES.CONTEXT,extra_data.GetContextName(),extra_data.GetHotKeys(),newArr])
            this.m_last_hk_arrays.push(this.m_last_hk_array)
            this.m_last_hk_array := newArr
            
        }
        else if(type == TV_TYPES.WINDOWCONTEXT)
        {
            this.m_last_parent_hk_array := 0
            extra_data.m_RootHotKeysArray := this.m_last_root_array
            extra_data.m_HotKeysArray := []
            newArr := extra_data.GetHotKeysArray()
            this.m_last_hk_array.push([TV_TYPES.WINDOWCONTEXT,extra_data.GetContextName(),newArr])
            this.m_last_hk_arrays.push(this.m_last_hk_array)
            this.m_last_hk_array := newArr

            this.m_last_root_arrays.push(this.m_last_root_array)
            this.m_last_root_array := newArr ;it's fine the root switched to the context's hk array
        }
    }
    OnRecurse(extra_data,type,tvitem)
    {
        ;
    }
    OnDecurse(extra_data,type,tvitem)
    {
        Debug.WriteStack("LoadMainTreeViewKeycode  OnDecurse",Debug.ErrLevelCore)
        if(type == TV_TYPES.EXE)
        {
            this.m_last_hk_array := 0
            this.m_last_parent_hk_array := 0
        }
        else if(type == TV_TYPES.CONTEXT)
        {
            this.m_last_hk_array := this.m_last_hk_arrays.pop()
            this.m_last_parent_hk_array := this.m_last_hk_array
        }
        else if(type == TV_TYPES.WINDOWCONTEXT)
        {
            this.m_last_hk_array := this.m_last_hk_arrays.pop()
            this.m_last_root_array := this.m_last_root_arrays.pop()
            this.m_last_parent_hk_array := this.m_last_hk_array
        }
    }
}