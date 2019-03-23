;Main Treeview Helper Functions
class TVHelper
{
    static m_Break := 0
    static m_IgnoreDisabled := False
    IgnoreDisabled(Ignore)
    {
        TVHelper.m_IgnoreDisabled := Ignore
    }
    SetBreak(vbreak)
    {
        TVHelper.m_Break := vbreak
    }
    ClearArray(Arr)
    {
        l := Arr.Length
        while(l)
        {
            Arr[l] := 0
            Arr.Pop()
            l--
        }
        return 0
    }
    IsValInArr(Val, Arr)
    {
        for each, item in Arr
        {
            if(item == Val)
            {
                return true
            }
        }
        return false
    }
    IsValInArrCI(Val, Arr) ;case insentitive
    {
        for each, item in Arr
        {
            if(item = Val)
            {
                return true
            }
        }
        return false
    }
    recurse_filter(TVParentID, FilterTypes:=0, GroupFilterTypes:=0, callbackClass:=0, Arr:=0)
    {
        ;Recurses through the Main TV looking to items of extra data type listed in the array of Type FilterTypes
        ;If the item type is a group it recurses to dig in the structure
        ;Returns an array of item extra data, since it had to grab it while searching
        ;If the FilterTypes is 0 or ommited, no filter is used
        ;GroupFilterTypes specifies an array of types that constitutes a group, like TV_TYPES.GROUP and TV_TYPES.WINDOWCONTEXT
        ;   if ommited or 0 every node is traversed if it has children
        ;callbackClass is a class with a OnAdd, OnRecurse and OnDecurse function that takes extra_data as parameter. These are call for each node added and recursed
        ;   it is optional, you can use the array but loose the structural context if you do, if a class is passed the aray will be empty
        ;example call, get all items of type APPS and CONTEXT
        ;arr := recurse_filter(ParItem,[TV_TYPES.APPS, TV_TYPES.CONTEXT],[TV_TYPES.GROUP])
        ;example call, get all items and receive a callback
        ;recurse_filter(ParItem,0,0, myCallbackFunc)

        Debug.WriteStackPush("recurse_filter Start",Debug.ErrLevelCore)
        Ret := 0
        DoOnce:=False
        if(Arr==0) ;root call, set the gui context
        {
            TVHelper.m_Break := false
            last:=a_defaultgui
            Gui, MainUIWindow_:Default
            Ret := []
        }
        Else
        {
            Ret := arr
        }

        
        ThisTVItem:=TV_GetChild(TVParentID)
		if(Arr==0 && TVParentID!=0)
        {
            ;did not start from the root, process item by iteself, and it's children only
            ThisTVItem := TVParentID
            DoOnce := true
        }
        Debug.WriteStackPush("while(ThisTVItem) Start",Debug.ErrLevelCore)
        while(ThisTVItem && !TVHelper.m_Break)
		{
            
            extra_data := MainUITreeview_Control_Instance.m_TVExtraData.GetItem(ThisTVItem)
            TheType:=extra_data.GetType()
            pushed := false
            if(!FilterTypes)
            {
                pushed := true
            }
            else if(TVHelper.IsValInArr(TheType,FilterTypes))
            {
                pushed := true
            }
            if(pushed)
            {
                DoIT :=true
                if(TVHelper.m_IgnoreDisabled)
                {
                    DoIT := !extra_data.GetDisabled()
                }
                if(DoIt)
                {
                    Debug.WriteStack("Pushed",Debug.ErrLevelCore)
                    if( callbackClass )
                    {
                        callbackClass.OnAdd(extra_data,TheType,ThisTVItem) 
                    }
                    else
                    {
                        Ret.push(extra_data)
                    }
                }
                
            }
            HasChild := (TV_GetChild(ThisTVItem))
            Recurse := False
            if(!GroupFilterTypes && HasChild)
            {
                Recurse := True
            }
            else if(TVHelper.IsValInArr(TheType,GroupFilterTypes) && HasChild)
            {
                Recurse := True
            }
            if(Recurse)
            {
                DoIT :=true
                if(TVHelper.m_IgnoreDisabled)
                {
                    DoIT := !extra_data.GetDisabled()
                }
                if(DoIt)
                {
                    Debug.WriteStackPush("Children Start",Debug.ErrLevelCore)
                    if( callbackClass )
                    {
                        callbackClass.OnRecurse(extra_data,TheType,ThisTVItem) 
                    }
                    TVHelper.recurse_filter(ThisTVItem, FilterTypes, GroupFilterTypes, callbackClass, Ret)
                    if( callbackClass )
                    {
                        callbackClass.OnDecurse(extra_data,TheType,ThisTVItem)
                    }
                    Debug.WriteStackPop("Children End",Debug.ErrLevelCore)
                }
            }
            ThisTVItem := TV_GetNext(ThisTVItem) 
            if(DoOnce)
            {
                ;no looping through siblings
                ThisTVItem :=0
            }
		}
        Debug.WriteStackPop("While End",Debug.ErrLevelCore)
        Debug.WriteStackPop("recurse_filter End",Debug.ErrLevelCore)
        if(Arr==0) ;root call, set the gui context
        {
            Gui, %last%:Default
            return ret
        }
    }
    
    ;these select and expand/de expand items
    SelectItem(TVItem)
	{
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
		TV_Modify(TVItem,"+Expand")
		TV_Modify(TVItem,"Select")
        TV_Modify(TVItem,"Vis")
		Gui, %last%:Default
	}
	DeselectItem(TVItem)
	{
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
		TV_Modify(TVItem,"-Expand")
		Gui, %last%:Default
	}
    GetSelectedItem()
	{
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
        ret := TV_GetSelection()
		Gui, %last%:Default
        return ret
	}
    IsExpanded(TVItem)
	{
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
        ret := TV_Get(TVItem, "Expand")
		Gui, %last%:Default
        return ret
	}
    ExpandItem(TVItem)
    {
        last:=a_defaultgui
		Gui, MainUIWindow_:Default
        TV_Modify(TVItem,"+Expand")
        Gui, %last%:Default
    }
    CollapseItem(TVItem)
    {
        last:=a_defaultgui
		Gui, MainUIWindow_:Default
        TV_Modify(TVItem,"-Expand")
        Gui, %last%:Default
    }
    BranchDisabled(TVItem)
    {
        if(TVItem == 0)
        {
            return false
        }
        else if(TVHelper.ToExtraData(TVItem).GetDisabled())
        {
            return True
        }
        else
        {
            return TVHelper.BranchDisabled(TVHelper.GetParent(TVItem))
        }
    }
    CollapseToRoot(TVItem)
    {
        last:=a_defaultgui
		Gui, MainUIWindow_:Default
        ti := TVItem
        while(ti)
        {
            TV_Modify(ti,"-Expand")
            ti := TV_GetParent(ti)
        }
        Gui, %last%:Default
    }
    FindUpTree(SearchItem,StartFromItem)
    {
        last:=a_defaultgui
		Gui, MainUIWindow_:Default
        ti := StartFromItem
        found:=false
        while(ti)
        {
            if(ti == SearchItem)
            {
                found := true
                break
            }
            ti := TV_GetParent(ti)
        }
        Gui, %last%:Default
        return found
    }
    GetParent(TVItem)
    {
        last:=a_defaultgui
		Gui, MainUIWindow_:Default
        TVParent:=TV_GetParent(TVItem)
        Gui, %last%:Default
        return TVParent
    }
    AddItem(Text,TVItemParent,Icon)
	{
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
        ret := TV_Add(Text, TVItemParent, Icon)
		Gui, %last%:Default
        return ret
	}
    SetItemText(TVItem,Text)
	{
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
        TV_Modify(TVItem,,Text)
		Gui, %last%:Default
        
	}
    SortBranch(TVBranch)
	{
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
        TV_Modify(TVBranch,"Sort")
		Gui, %last%:Default
	}
    SetItemParent(TVItem,TVParent)
	{
		last:=a_defaultgui
		Gui, MainUIWindow_:Default
        SaveMainTreeView.Save(A_MyDocuments . "\HotKeySpeak\temp\copyfrom.xml",TVItem)
        LoadMainTreeView.Load(A_MyDocuments . "\HotKeySpeak\temp\copyfrom.xml",TVParent)
        RepairGroupTypes.Repair(TVParent)
		Gui, %last%:Default
	}
    DisableDraw() ; this is used to disable the draw for a moment, it re anables after 100 ms
    {
        ;I needed a way to disable the draw from many operation that could overlap
        ;and reanable it when done... which proved to be difficult when multiple codes were
        ;operating on disabling then re-eanbling the draw. this sortof solves that 
        last:=a_defaultgui
		Gui, MainUIWindow_:Default
		GuiControl, -Redraw, MainUITreeview_Control
		Gui, %last%:Default
        SetTimer, TVHelper_ReEnableRedraw, OFF
        SetTimer, TVHelper_ReEnableRedraw, Delete
        SetTimer, TVHelper_ReEnableRedraw,100
    }
    ToExtraData(TVItem)
    {
        return MainUITreeview_Control_Instance.m_TVExtraData.GetItem(TVItem)
    }
    Redraw()
    {
        last:=a_defaultgui
		Gui, MainUIWindow_:Default
        GuiControl, +Redraw, MainUITreeview_Control
		Gui, %last%:Default
    }
}

TVHelper_ReEnableRedraw()
{
    last:=a_defaultgui
    Gui, MainUIWindow_:Default
    GuiControl, +Redraw, MainUITreeview_Control
    Gui, %last%:Default
    SetTimer, TVHelper_ReEnableRedraw, OFF
    SetTimer, TVHelper_ReEnableRedraw, Delete
}


class DeleteTVBranch
{
    Delete(TVBranch)
    {
        last:=a_defaultgui
        Gui, MainUIWindow_:Default
        Debug.WriteStackPush("DeleteBranche Delete Start",Debug.ErrLevelCore)

        ThisInst := New DeleteTVBranch()
        TVHelper.recurse_filter(TVBranch, 0, 0, ThisInst)

        MainUITreeview_Control_Instance.m_TVExtraData.DeleteItem(TVBranch)
        
        TVprevitem := TV_GetPrev(TVBranch)
		TVnextitem := TV_GetNext(TVBranch)
		TVparitem := TV_GetParent(TVBranch)
		TV_Delete(TVBranch)
		
		if(TVnextitem)
		{
			TV_Modify(TVnextitem,"Select")
		}
		else if(TVprevitem)
		{
			TV_Modify(TVprevitem,"Select")
		}
		else if(TVparitem)
		{
			TV_Modify(TVparitem,"Select")
		}
        Debug.WriteStackPushPop("Delete Item: " . TVBranch , Debug.ErrLevelCoreInfo)
        Gui, %last%:Default
        Debug.WriteStackPop("DeleteBranche Delete End",Debug.ErrLevelCore)
    }
    ;TVHelper.recurse_filter notifications
    OnAdd(extra_data,type,tvitem)
    {
        Debug.WriteStackPushPop("Delete Item: " . tvitem , Debug.ErrLevelCoreInfo)
        MainUITreeview_Control_Instance.m_TVExtraData.DeleteItem(tvitem)
    }
    OnRecurse(extra_data,type,tvitem)
    {
        
    }
    OnDecurse(extra_data,type,tvitem)
    {
        
    }
}


Class FindFirstItem
{
    m_ItemIndex := 0
    m_TextToFind := ""
    m_Sentence := ""
    m_FindExe :=
    __New(TextToFind)
    {
        this.m_ItemIndex := 0
        this.m_TextToFind := TextToFind
        this.m_Sentence := 0
        this.m_FindExe := false
    }
    FindMatchingExeItem(Text)
    {
        Debug.WriteStackPush("FindMatchingExeItem Start",Debug.ErrLevelCore)
        ThisInst := New FindFirstItem(text)
        ThisInst.m_FindExe:=true
        TVHelper.recurse_filter(MainUITreeview_Control_Instance.m_RootAppsItem, [TV_TYPES.EXE], [TV_TYPES.APPS,TV_TYPES.GROUP], ThisInst)
        ret := ThisInst.m_ItemIndex
        ThisInst := 0
        Debug.WriteStackPop("FindMatchingExeItem Return " . ret, Debug.ErrLevelCore)
        return ret
    }
    FindMatchingSpeechEnableItem(TVItemStart,Text)
    {
        Debug.WriteStackPush("FindMatchingSpeechEnableItem Start",Debug.ErrLevelCore)
        ThisInst := New FindFirstItem(text)
        TVHelper.recurse_filter(TVItemStart, [TV_TYPES.COMMAND,TV_TYPES.CONTEXT], [V_TYPES.EXE,TV_TYPES.GROUP, TV_TYPES.CONTEXT, TV_TYPES.WINDOWCONTEXT], ThisInst)
        ret := ThisInst.m_ItemIndex
        ThisInst := 0
        Debug.WriteStackPop("FindMatchingSpeechEnableItem Return " . ret,Debug.ErrLevelCore)
        return ret
    }
    OnAdd(extra_data,type,tvitem)
    {
        if(this.m_FindExe)
        {
            txt := extra_data.GetExeName()
            
        }
        else
        {
            txt := extra_data.GetItemText()
        }
        Debug.WriteStackPushPop("FindMatchingItem Check Item (" . tvitem . ") " . txt . " == " . this.m_TextToFind . "?",Debug.ErrLevelCore)
        if(txt = this.m_TextToFind)
        {
            Debug.WriteStackPushPop("FindMatchingItem Found", Debug.ErrLevelCoreInfo)
            this.m_ItemIndex := tvitem
            TVHelper.SetBreak(true)
            if(this.m_Sentence)
            {
                if(0==TVHelper.IsValInArr(this.m_Sentence, StrSplit(extra_data.GetSpeakText(),"|")))
                {
                    this.m_ItemIndex := 0
                }
            }
        }
    }
    OnRecurse(extra_data,type,tvitem)
    {
    }
    OnDecurse(extra_data,type,tvitem)
    {
    }
    FindRootExe(StartItem)
    {
        last:=a_defaultgui
        Gui, MainUIWindow_:Default
        Debug.WriteStackPush("FindRootExe Start",Debug.ErrLevelCore)
        ret:=0
        tvAt:=StartItem
        while(tvAt)
        {
            extra_data := MainUITreeview_Control_Instance.m_TVExtraData.GetItem(tvAt)
            Debug.WriteStackPushPop("FindRootExe Continue " . tvAt,Debug.ErrLevelCore)
            if(extra_data.GetType() == TV_TYPES.EXE)
            {
                Debug.WriteStackPushPop("FindRootExe Break " . tvAt,Debug.ErrLevelCore)
                ret := tvAt
                break
            }
            tvAt := TV_GetParent(tvAt)
        }
        Gui, %last%:Default
        Debug.WriteStackPop("FindRootExe Returns: " . ret,Debug.ErrLevelCore)
        return ret
    }
    FindRootContext(StartItem)
    {
        last:=a_defaultgui
        Gui, MainUIWindow_:Default
        Debug.WriteStackPush("FindRootContext Start",Debug.ErrLevelCore)
        ret:=0
        tvAt:=StartItem
        while(tvAt)
        {
            extra_data := MainUITreeview_Control_Instance.m_TVExtraData.GetItem(tvAt)
            type := extra_data.GetType()
            if(type == TV_TYPES.CONTEXT || type == TV_TYPES.WINDOWCONTEXT)
            {
                ret := tvAt
                break
            }
            tvAt := TV_GetParent(tvAt)
        }
        Gui, %last%:Default
        Debug.WriteStackPop("FindRootContext Returns: " . ret,Debug.ErrLevelCore)
        return ret
    }
    ;This is used for finding items that cannot have the same name, basically anything mapped to a SAPI rule uses these
    ;Basically go through all items in all things that allow sub items and locate a command, a context or a window context
    FindMatchingContextName(Name,RootExeItem)
    {
        Debug.WriteStackPush("FindMatchingContextName Start: " . Name,Debug.ErrLevelCore)
        ThisInst := New FindFirstItem(Name)
        TVHelper.recurse_filter(RootExeItem, [TV_TYPES.COMMAND,TV_TYPES.CONTEXT,TV_TYPES.WINDOWCONTEXT], [TV_TYPES.EXE,TV_TYPES.GROUP,TV_TYPES.CONTEXT,TV_TYPES.WINDOWCONTEXT], ThisInst)
        ret := ThisInst.m_ItemIndex
        ThisInst := 0
        Debug.WriteStackPop("FindMatchingContextName Return " . ret,Debug.ErrLevelCore)
        return ret
    }
    FindMatchingResourceName(Name,RootExeItem)
    {
        Debug.WriteStackPush("FindMatchingResourceName Start: " . Name . " ID " . RootExeItem,Debug.ErrLevelCore)
        ThisInst := New FindFirstItem(Name)
        TVHelper.recurse_filter(RootExeItem, [TV_TYPES.FILERESOURCE], [TV_TYPES.EXE,TV_TYPES.GROUP], ThisInst)
        ret := ThisInst.m_ItemIndex
        ThisInst := 0
        Debug.WriteStackPop("FindMatchingResourceName Return " . ret,Debug.ErrLevelCore)
        return ret
    }
    FindMatchingCommandOrCommandContextName(Name,RootExeItem)
    {
        Debug.WriteStackPush("FindMatchingContextName Start: " . Name,Debug.ErrLevelCore)
        ThisInst := New FindFirstItem(Name)
        TVHelper.recurse_filter(RootExeItem, [TV_TYPES.COMMAND,TV_TYPES.CONTEXT], [TV_TYPES.EXE,TV_TYPES.GROUP,TV_TYPES.CONTEXT,TV_TYPES.WINDOWCONTEXT], ThisInst)
        ret := ThisInst.m_ItemIndex
        ThisInst := 0
        Debug.WriteStackPop("FindMatchingContextName Return " . ret,Debug.ErrLevelCore)
        return ret
    }
    FindMatchingCommandName(Name,RootExeItem)
    {
        return FindFirstItem.FindMatchingContextName(Name,RootExeItem)
    }
    FindMatchingWindowContextName(Name,RootExeItem)
    {
        return FindFirstItem.FindMatchingContextName(Name,RootExeItem)
    }
    FindMatchingContextNameAndSentence(Name,Sentence,RootExeItem)
    {
        Debug.WriteStackPush("FindMatchingContextName Start: " . Name,Debug.ErrLevelCore)
        ThisInst := New FindFirstItem(Name)
        ThisInst.m_Sentence := Sentence
        TVHelper.recurse_filter(RootExeItem, [TV_TYPES.COMMAND,TV_TYPES.CONTEXT,TV_TYPES.WINDOWCONTEXT], [TV_TYPES.EXE,TV_TYPES.GROUP,TV_TYPES.CONTEXT,TV_TYPES.WINDOWCONTEXT], ThisInst)
        ret := ThisInst.m_ItemIndex
        ThisInst := 0
        Debug.WriteStackPop("FindMatchingContextName Return " . ret,Debug.ErrLevelCore)
        return ret
    }
}

Class RepairGroupTypes
{
    static m_show_report :=0
    Repair(StartIndex, show_report:=0)
    {
        Debug.WriteStackPush("RepairGroupTypes Start",Debug.ErrLevelCore)
        ThisInst := New RepairGroupTypes()
        ThisInst.m_show_report := show_report
        TVHelper.recurse_filter(StartIndex, [TV_TYPES.GROUP], [TV_TYPES.APPS, TV_TYPES.EXE, TV_TYPES.GROUP,TV_TYPES.CONTEXT,TV_TYPES.WINDOWCONTEXT], ThisInst)
        ThisInst := 0
        Debug.WriteStackPop("RepairGroupTypes End ",Debug.ErrLevelCore)
        
    }
    OnAdd(extra_data,type,tvitem)
    {
        TVParent := TVHelper.GetParent(tvitem)
        if(TVParent)
        {
            parent_extra_data := TVHelper.ToExtraData(TVParent)
            if(parent_extra_data)
            {
                if(parent_extra_data.GetGroupType() != extra_data.GetGroupType())
                {
                    Debug.WriteStackPushPop("RepairGroupTypes Reparing: " . tvitem, Debug.ErrLevelCore)
                    if(this.m_show_report)
                    {
                        Debug.WriteNL(">Item(" . tvitem . ") Group: '" . extra_data.GetItemText() . "' Repared!")
                    }
                    extra_data.SetGroupType(parent_extra_data.GetGroupType())
                }
            }
        }
    }
    OnRecurse(extra_data,type,tvitem)
    {
    }
    OnDecurse(extra_data,type,tvitem)
    {
    }
}


Class ScanActionsForDuplicates
{
    static m_ActionNames :=
    Scan(StartIndex)
    {
        Debug.WriteStackPush("RepairGroupTypes Start",Debug.ErrLevelCore)
        ThisInst := New ScanActionsForDuplicates()
        ThisInst.m_ActionNames := []
        TVHelper.recurse_filter(StartIndex, [TV_TYPES.FILERESOURCE,TV_TYPES.COMMAND,TV_TYPES.CONTEXT,TV_TYPES.WINDOWCONTEXT], [TV_TYPES.APPS, TV_TYPES.EXE, TV_TYPES.GROUP,TV_TYPES.CONTEXT,TV_TYPES.WINDOWCONTEXT], ThisInst)
        hisInst := 0
        ThisInst.m_ActionNames := 0
        Debug.WriteStackPop("RepairGroupTypes End ",Debug.ErrLevelCore)
        
    }
    OnAdd(extra_data,type,tvitem)
    {
        actionname := ""
        if(type == TV_TYPES.COMMAND)
        {
            actionname := extra_data.GetCommandName()
        }
        else if(type == TV_TYPES.CONTEXT)
        {
            actionname := extra_data.GetContextName()
        }
        else if(type == TV_TYPES.WINDOWCONTEXT)
        {
            actionname := extra_data.GetContextName()
        }
        else if(type == TV_TYPES.FILERESOURCE)
        {
            actionname := extra_data.GetFileName()
        }
        if(TVHelper.IsValInArr(actionname, this.m_ActionNames))
        {
            Debug.WriteNL(">Item(" . tvitem . ") Action: '" . actionname . "' is a Duplicate Name!")
        }
        else
        {
            this.m_ActionNames.Push(actionname)
        }
    }
    OnRecurse(extra_data,type,tvitem)
    {
    }
    OnDecurse(extra_data,type,tvitem)
    {
    }
}

class ScanActionCodesForDuplicateFunctions
{
    static m_FunctionNames :=
    static m_RefActions :=
    Scan(StartIndex)
    {
        Debug.WriteStackPush("ScanActionCodesForDuplicateFunctions Start",Debug.ErrLevelCore)
        ThisInst := New ScanActionCodesForDuplicateFunctions()
        ThisInst.m_FunctionNames := []
        ThisInst.m_RefActions:= []
        TVHelper.recurse_filter(StartIndex, [TV_TYPES.EXE,TV_TYPES.COMMAND,TV_TYPES.CONTEXT,TV_TYPES.WINDOWCONTEXT], [TV_TYPES.APPS, TV_TYPES.EXE, TV_TYPES.GROUP,TV_TYPES.CONTEXT,TV_TYPES.WINDOWCONTEXT], ThisInst)
        ret := ThisInst.m_FirstFound
        ThisInst := 0
        ThisInst.m_FunctionNames := 0
        ThisInst.m_RefActions := 0
        Debug.WriteStackPop("ScanActionCodesForDuplicateFunctions End ",Debug.ErrLevelCore)
        
    }
    OnAdd(extra_data,type,tvitem)
    {
        Code := extra_data.GetCode()
        Functions := this.ParseCode(code)

        if(type == TV_TYPES.COMMAND)
        {
            actionname := extra_data.GetCommandName()
        }
        else if(type == TV_TYPES.CONTEXT)
        {
            actionname := extra_data.GetContextName()
        }
        else if(type == TV_TYPES.WINDOWCONTEXT)
        {
            actionname := extra_data.GetContextName()
        }
        else if(type == TV_TYPES.EXE)
        {
            actionname := extra_data.GetExeName()
        }


        for each, item in Functions
        {
            if(TVHelper.IsValInArrCI(item, this.m_FunctionNames))
            {
                if(("" . item) != "")
                {
                    Debug.WriteNL(">Item(" . tvitem . ") Function: '" . item . "' in Action: '" . actionname . "' was previously defined in Action '" . this.m_RefActions[item] . "'!")
                }
            }
            else
            {
                this.m_FunctionNames.Push(item)
                this.m_RefActions[item] := actionname
            }
        }
    }
    OnRecurse(extra_data,type,tvitem)
    {
    }
    OnDecurse(extra_data,type,tvitem)
    {
    }
    

    ParseCode(code)
    {
        this.m_Code := StrReplace(code, chr(13) . chr(10) , chr(10))
        this.m_at := 1
        c:= this.ReadToFirstValidByte()
        strippedcode :=""
        while(c)
        {
            if(c == " " || c == chr(9))
            {
                strippedcode .= " "
                c:=this.SkipWhiteSpace()
            }
            else if(c == chr(10))
            {
                strippedcode .= " "
                c:=this.SkipWhiteSpace()
            }
            else if(c == chr(13))
            {
                strippedcode .= " "
                c:=this.SkipWhiteSpace()
            }
            else if(c == "(")
            {
                strippedcode .= " "
                c:=this.SkipWhiteSpace()
            }
            else if(c == ")")
            {
                c:=this.SkipWhiteSpace()
            }
            else if(c=="/" && (this.PeekAhead() == "/" || this.PeekAhead() == "*"))
            {
                this.DoComment()
                c:=this.NextChar()
            }
            else if (c =="{")
            {
                this.DoBraces()
                c:=this.NextChar()
            }
            else 
            {
                strippedcode .= c
                c:=this.NextChar()
            }
        }
        functions := []
        Words := StrSplit(strippedcode," ")
        at:=1
        for each, item in Words
        {
            if(item == "function")
            {
                
                if(Words[at-1] == "=")
                {
                    functions.Push(Words[at-2])
                    
                }
                else
                {
                    functions.Push(Words[at+1])
                    
                }
            }
            at++
        }
        this.m_Code := ""
        return functions
        
    }
    NextChar()
    {
        c := SubStr(this.m_Code, this.m_at,1)
        this.m_at++
        return c
    }
    ReadToEOL()
    {
        while(1)
        {
            c:=this.NextChar()
            if(("" . c) == "")
            {
                break
            }
            else if(c==chr(10))
            {
                break
            }
        }
    }
    ReadToEOMLC()
    {
        while(1)
        {
            c:=this.NextChar()
            if(("" . c) == "")
            {
                break
            }
            else if(c=="*" && this.PeekAhead() == "/")
            {
                this.NextChar()
                break
                
            }
        }
    }
    DoComment()
    {
        c:=this.NextChar()
        if(c=="/")
        {
            this.ReadToEOL()
        }
        else if(c=="*")
        {
            this.ReadToEOMLC()
        }
    }
    IsAlpha(c)
    {
        static chars := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return InStr(chars, c)
    }
    PeekAhead()
    {
        return SubStr(this.m_Code, this.m_at,1)
    }
    ReadToFirstValidByte()
    {
        while(1)
        {
            c := this.NextChar()
            if(("" . c) == "")
            {
                return c
            }
            else if(c=="/" && (this.PeekAhead() == "/" || this.PeekAhead() == "*"))
            {
                this.DoComment()
            }
            else if(this.IsAlpha(c))
            {
               return c
            }
        }
    }
    DoBraces()
    {
        while(1)
        {
            c := this.NextChar()
            if(("" . c) == "")
            {
                return c
            }
            else if(c=="/" && (this.PeekAhead() == "/" || this.PeekAhead() == "*"))
            {
                this.DoComment()
                
            }
            else if(c == "{")
            {
                
               this.DoBraces()
               
            }
            else if(c == "}")
            {
                return
            }
        }
    }
    SkipWhiteSpace()
    {
        while(1)
        {
            c:=this.NextChar()
            if(c == " " || c == chr(9) || c == chr(10) || c == chr(13))
            {
            }
            else
            {
                return c
            }
        }
    }
}