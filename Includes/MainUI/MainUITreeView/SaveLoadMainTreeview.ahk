Class LoadMainTreeView
{
    m_LastItem := 
    m_LastBranch := 
    m_xDoc :=
    m_Branches:=
    m_WhatsAValidBranch :=
    m_WhatsAValidAddItem :=
    
    Load(Filename, TVBranch)
    {
        Debug.WriteStackPush("LoadMainTreeView Load Start",Debug.ErrLevelCore)
        ThisInst := New LoadMainTreeView() 
        last:=a_defaultgui
        Gui, MainUIWindow_:Default

        
        ThisInst.m_FastRefItems:=0
        ThisInst.m_Branches :=[]
        ThisInst.m_Branches.Push(TVBranch)
        ThisInst.m_LastBranch := TVBranch
        ThisInst.m_LastItem := TVBranch

        ThisInst.m_WhatsAValidBranch := [TV_TYPES.APPS,TV_TYPES.EXE,TV_TYPES.CONTEXT,TV_TYPES.GROUP,TV_TYPES.WINDOWCONTEXT]
        ThisInst.m_WhatsAValidAddItem := [TV_TYPES.FILERESOURCE,TV_TYPES.APPS,TV_TYPES.EXE,TV_TYPES.COMMAND,TV_TYPES.CONTEXT,TV_TYPES.GROUP,TV_TYPES.WINDOWCONTEXT]

        ThisInst.m_xDoc := New_DOMDocument()
        if(!ThisInst.m_xDoc.load(Filename))
        {
            
            Stack:=Debug.ClearStack()
            xPE := ThisInst.m_xDoc.parseError()
            Debug.WriteNL("",Debug.ErrLevelImportant)
            Debug.WriteNL("ERROR",Debug.ErrLevelImportant)
            Debug.WriteNL("The document failed to load.",Debug.ErrLevelImportant)
            Debug.WriteNL("File: " . Filename, Debug.ErrLevelImportant)
            Debug.WriteNL("due the following error.",Debug.ErrLevelImportant)
            Debug.WriteNL("Error #: " . xPE.errorCode() . " : " .  xPE.reason,Debug.ErrLevelImportant)
            Debug.WriteNL("Position In File:" . xPE.filepos,Debug.ErrLevelImportant)
            Debug.WriteNL("Line #: " . xPE.Line,Debug.ErrLevelImportant)
            Debug.WriteNL("Line Position:" . xPE.linepos,Debug.ErrLevelImportant)
            Debug.WriteNL("Source Text:" . xPE.srcText,Debug.ErrLevelImportant)
            Debug.SetStack(xPE.linepos/2 + 6,Debug.ErrLevelImportant) ;lets see where using the debug stack which tabs with 2 spaces per pos
            Debug.WriteStack("^",Debug.ErrLevelImportant)
            Debug.WriteNL("Document URL:" . xPE.url,Debug.ErrLevelImportant)
            Debug.WriteNL("",Debug.ErrLevelImportant)
            Debug.SetStack(Stack)
            Debug.MsgBox("Failed to load file: " . Filename)
           
        }
        Else
        {
            ;No sense adding a recurse array since elements (the list of element) are not valid but need recursion so handled in the OnRecurse
            MTVDOMHLP.recurse_filter(ThisInst.m_xDoc,ThisInst.m_WhatsAValidAddItem,0,ThisInst)
        }
        Debug.WriteStackPop("LoadMainTreeView Load End",Debug.ErrLevelCore)
        ThisInst.m_xDoc := 0
        ThisInst := 0
        Gui, %last%:Default
    }
    ;MTVDOMHLP.recurse_filter notifications
    OnAdd(dom_element,type)
    {
        ;special case for loading another root when one is there already
        if(type == TV_TYPES.APPS)
        {
            if(MainUITreeview_Control_Instance.m_RootAppsItem)
            {
                this.m_LastItem :=MainUITreeview_Control_Instance.m_RootAppsItem
                return
            }
        }
        TVHelper.DisableDraw()
        ;Debug.WriteNL("",Debug.ErrLevelCore)
        ;Debug.WriteNL("OnAdd",Debug.ErrLevelCore)
        Debug.WriteStackPushPop("OnAdd Type: " . type . " Using Parent " . this.m_LastBranch,Debug.ErrLevelCore)
        extra_data := TVType_CreateFromDom(dom_element, type, this.m_LastBranch)
        this.m_LastItem := TV_Add(extra_data.GetTreeviewItemText(), this.m_LastBranch, extra_data.GetTreeviewIconIndex())
        extra_data.SetTreeviewItemIndex(this.m_LastItem)
        MainUITreeview_Control_Instance.m_TVExtraData.SetItem(this.m_LastItem,extra_data)

        if(type == TV_TYPES.APPS)
        {
            MainUITreeview_Control_Instance.m_RootAppsItem := this.m_LastItem
        }
        

    }
    OnRecurse(dom_element,type)
    {
        Debug.WriteStackPushPop("OnRecurse Type: " . type , Debug.ErrLevelCore)
        if(MTVDOMHLP.IsValInArr(type,this.m_WhatsAValidBranch))
        {
            this.m_LastBranch := this.m_LastItem
            this.m_Branches.Push(this.m_LastBranch)
            Debug.WriteStackPushPop("OnRecurse: New Parent Is " . this.m_LastBranch,Debug.ErrLevelCore)
        }

    }
    OnDecurse(dom_element,type)
    {
        Debug.WriteStackPushPop("OnDecurse Type: " . type , Debug.ErrLevelCore)
        if(MTVDOMHLP.IsValInArr(type,this.m_WhatsAValidBranch))
        {
            this.m_Branches.Pop()
            this.m_LastItem := this.m_Branches[this.m_Branches.MaxIndex()]
            this.m_LastBranch := this.m_LastItem
            Debug.WriteStackPushPop("OnDECURSE: New Parent Is " . this.m_LastBranch,Debug.ErrLevelCore)
        }
        
    }
}



Class SaveMainTreeView
{
    m_LastItem := 
    m_LastBranch := 
    m_xDoc :=
    Save(Filename, TVBranch)
    {
        Debug.WriteStackPush("SaveMainTreeView Save Start",Debug.ErrLevelCore)
        ThisInst := New SaveMainTreeView()

        ThisInst.m_xDoc := New_DOMDocument()
        ThisInst.m_LastBranch := ThisInst.m_xDoc
        elements := ThisInst.m_xDoc.CreateElement("elements")
        ThisInst.m_LastBranch.appendChild(elements)
        ThisInst.m_LastItem := elements
        ThisInst.m_LastBranch := ThisInst.m_LastItem
        
        TVHelper.recurse_filter(TVBranch, 0, 0, ThisInst)
        try
        {
            ThisInst.m_xDoc.save(Filename)
        }
        catch e
        {
            Debug.WriteNL("",Debug.ErrLevelImportant)
            Debug.WriteNL("-----------------",Debug.ErrLevelImportant)
            Debug.WriteNL("The DOM Document failed to save.",Debug.ErrLevelImportant)
            Debug.WriteNL("File: " . Filename, Debug.ErrLevelImportant)
            Debug.WriteNL("Details:", Debug.ErrLevelImportant)
            Debug.WriteNL(e.Extra,Debug.ErrLevelImportant)
            Debug.WriteNL(DOMDecodeErrorFromExceptionString(e.Message),Debug.ErrLevelImportant)
            Debug.WriteNL("-----------------",Debug.ErrLevelImportant)
            Debug.WriteNL("",Debug.ErrLevelImportant)
            Debug.MsgBox("Failed to save file: " . Filename)
        }
        ThisInst.m_xDoc := 0
        ThisInst := 0
        Debug.WriteStackPop("SaveMainTreeView Save End",Debug.ErrLevelCore)
    }
    ;TVHelper.recurse_filter notifications
    OnAdd(extra_data,type,tvitem)
    {
        Debug.WriteStack("SaveMainTreeView OnAdd",Debug.ErrLevelCore)
        element := this.m_xDoc.CreateElement("element")
        extra_data.ToDOM(this.m_xDoc,element)
        ;element.setAttribute("text",extra_data.GetItemText())
        ;element.setAttribute("type",extra_data.GetType())
        this.m_LastBranch.appendChild(element)
        this.m_LastItem := element
    }
    OnRecurse(extra_data,type,tvitem)
    {
        this.m_LastBranch := this.m_LastItem
        Debug.WriteStack("SaveMainTreeView OnRecurse",Debug.ErrLevelCore)
        elements := this.m_xDoc.CreateElement("elements")
        this.m_LastBranch.appendChild(elements)
        this.m_LastItem := elements
        this.m_LastBranch := this.m_LastItem
    }
    OnDecurse(extra_data,type,tvitem)
    {
        Debug.WriteStack("SaveMainTreeView OnDecurse",Debug.ErrLevelCore)
        this.m_LastBranch := this.m_LastBranch.parentNode ;pop to elements
        this.m_LastBranch := this.m_LastBranch.parentNode ;pop to element
        this.m_LastItem := this.m_LastBranch
    }
}


class BackupOldFile
{
    Backup()
    {
        FormatTime, OutputVar , , dddd, MMMM dd, yyyy, hh-mm-ss tt
        
        BackupsFolder := A_MyDocuments . "\HotKeySpeak\SaveFolder\Backups\" . OutputVar
        SourceTreeview := A_MyDocuments . "\HotKeySpeak\SaveFolder\treeview.xml"
        SourceSpeech := A_MyDocuments . "\HotKeySpeak\SaveFolder\speech.xml"
        try
        {
            ;destfile := BackupsFolder . "\treeview.xml"
            FileCreateDir, %BackupsFolder%
            FileCopy, %SourceTreeview%, %BackupsFolder%
            FileCopy, %SourceSpeech%, %BackupsFolder%
            ;A_MyDocuments . "\HotKeySpeak\SaveFolder\treeview.xml"
        }
        catch e
        {
            Debug.WriteNL("", Debug.ErrLevelImportant)
            Debug.WriteNL("ERROR:", Debug.ErrLevelImportant)
            Debug.WriteNL("Failed to Backup File to folder:", Debug.ErrLevelImportant)
            Debug.WriteNL(BackupsFolder, Debug.ErrLevelImportant)
            Debug.WriteNL("Details:", Debug.ErrLevelImportant)
            Debug.WriteNL(e.What,Debug.ErrLevelImportant)
            Debug.WriteNL(e.Extra,Debug.ErrLevelImportant)
            Debug.WriteNL(e.Message,Debug.ErrLevelImportant)
            Debug.WriteNL("", Debug.ErrLevelImportant)
            Debug.MsgBox("Failed to Backup File to folder: " . BackupsFolder)
        }
    }
}

Class SaveMainTreeViewSpeech
{
    m_xDoc :=
    m_WhatsAValidBranch :=
    m_WhatsAValidAddItem :=
    m_AllProgramsList := 
    m_LastProgramSection := 
    m_LastRuleSection :=
    m_LastRuleList := 
    m_LastRuleSections :=
    m_LastRuleLists := 
    m_LastGrammarSection :=
    Save(Filename, TVBranch)
    {
        Debug.WriteStackPush("SaveMainTreeViewSpeech Save Start",Debug.ErrLevelCore)
        ThisInst := New SaveMainTreeViewSpeech()
        ThisInst.m_AllProgramsList := 0
        ThisInst.m_LastProgramSection := 0
        ThisInst.m_LastRuleSection := 0
        ThisInst.m_LastGrammarSection := 0
        ThisInst.m_LastRuleList := 0

        ThisInst.m_LastRuleSections :=[]
        ThisInst.m_LastRuleLists :=[]

        ThisInst.m_WhatsAValidBranch := [TV_TYPES.APPS,TV_TYPES.EXE,TV_TYPES.CONTEXT,TV_TYPES.GROUP,TV_TYPES.WINDOWCONTEXT]
        ThisInst.m_WhatsAValidAddItem := [TV_TYPES.EXE,TV_TYPES.COMMAND,TV_TYPES.CONTEXT,TV_TYPES.WINDOWCONTEXT]
        
        ThisInst.m_xDoc := New_DOMDocument()
        ThisInst.m_LastBranch := ThisInst.m_xDoc
        ThisInst.m_AllProgramsList := ThisInst.m_xDoc.CreateElement("programs")
        ThisInst.m_LastBranch.appendChild(ThisInst.m_AllProgramsList)
        ThisInst.m_LastItem := ThisInst.m_ProgramsList
        ThisInst.m_LastBranch := ThisInst.m_LastItem
        
        TVHelper.recurse_filter(TVBranch, ThisInst.m_WhatsAValidAddItem, ThisInst.m_WhatsAValidBranch, ThisInst)
        try
        {
            ThisInst.m_xDoc.save(Filename)
        }
        catch e
        {
            Debug.WriteNL("",Debug.ErrLevelImportant)
            Debug.WriteNL("-----------------",Debug.ErrLevelImportant)
            Debug.WriteNL("The DOM Document failed to save.",Debug.ErrLevelImportant)
            Debug.WriteNL("File: " . Filename, Debug.ErrLevelImportant)
            Debug.WriteNL("Details:", Debug.ErrLevelImportant)
            Debug.WriteNL(e.Extra,Debug.ErrLevelImportant)
            Debug.WriteNL(DOMDecodeErrorFromExceptionString(e.Message),Debug.ErrLevelImportant)
            Debug.WriteNL("-----------------",Debug.ErrLevelImportant)
            Debug.WriteNL("",Debug.ErrLevelImportant)
            Debug.MsgBox("Failed to save file: " . Filename)
        }
        ThisInst.m_xDoc := 0
        ThisInst := 0
        Debug.WriteStackPop("SaveMainTreeViewSpeech Save End",Debug.ErrLevelCore)
        
    }
    ;TVHelper.recurse_filter notifications
    OnAdd(extra_data,type,tvitem)
    {
        Debug.WriteStack("SaveMainTreeViewSpeech OnAdd",Debug.ErrLevelCore)
        if(type == TV_TYPES.COMMAND)
        {
            this.OnAddCommand(extra_data)
        }
        /*
        element := this.m_xDoc.CreateElement("element")
        this.m_LastBranch.appendChild(element)
        this.m_LastItem := element
        */
    }
    OnRecurse(extra_data,type,tvitem)
    {
        Debug.WriteStack("SaveMainTreeViewSpeech OnRecurse",Debug.ErrLevelCore)
        
        if(type == TV_TYPES.CONTEXT)
        {
            this.OnRecurseContext(extra_data)
        }
        else if(type == TV_TYPES.WINDOWCONTEXT)
        {
            this.OnRecurseContextWindow(extra_data)
        }
        else if(type == TV_TYPES.EXE)
        {
            this.OnRecurseProgram(extra_data)
        }
        /*
        this.m_LastBranch := this.m_LastItem
        Debug.WriteStack("SaveMainTreeView OnRecurse",Debug.ErrLevelCore)
        elements := this.m_xDoc.CreateElement("elements")
        this.m_LastBranch.appendChild(elements)
        this.m_LastItem := elements
        this.m_LastBranch := this.m_LastItem
        */
    }
    OnDecurse(extra_data,type,tvitem)
    {
        Debug.WriteStack("SaveMainTreeViewSpeech OnDecurse",Debug.ErrLevelCore)
        if(type == TV_TYPES.CONTEXT)
        {
            this.OnDecurseContext(extra_data)
        }
        else if(type == TV_TYPES.WINDOWCONTEXT)
        {
            this.OnDecurseContextWindow(extra_data)
        }
        else if(type == TV_TYPES.EXE)
        {
            this.OnDecurseProgram(extra_data)
        }
        /*
        this.m_LastBranch := this.m_LastBranch.parentNode ;pop to elements
        this.m_LastBranch := this.m_LastBranch.parentNode ;pop to element
        this.m_LastItem := this.m_LastBranch
        */
    }
    OnRecurseProgram(extra_data)
    {
        Debug.WriteStack("SaveMainTreeViewSpeech OnRecurseProgram",Debug.ErrLevelCore)
        /*
        make these entries
        <program name="app">
            <GRAMMAR LANGID="409">
                <RULE NAME="MAIN" TOPLEVEL="ACTIVE" EXPORT="0">
                    <L>
                        <RULEREF NAME="TEST"/>
                        <RULEREF NAME="POWER"/>
                        <RULEREF NAME="RELOAD"/>
                        <RULEREF NAME="SWITCH"/>
                        <RULEREF NAME="ATTACK"/>
                        <RULEREF NAME="PROTECT"/>
                        <RULEREF NAME="EVASIVE"/>
                        <RULEREF NAME="RETREAT"/>
                    </L>
                    <O>
                        <RULEREF NAME="MAIN"/>
                    </O>
                </RULE>
            </GRAMMAR>
        </program>
        */

        ;<program name="app">
        this.m_LastProgramSection := this.m_xDoc.CreateElement("program")
        this.m_LastProgramSection.setAttribute("name",extra_data.GetExeName())
        this.m_AllProgramsList.appendChild(this.m_LastProgramSection)
          this.m_LastGrammarSection := this.m_xDoc.CreateElement("GRAMMAR")
          this.m_LastGrammarSection.setAttribute("LANGID","409")
          this.m_LastProgramSection.appendChild(this.m_LastGrammarSection)

            ;<RULE NAME="MAIN" TOPLEVEL="ACTIVE" EXPORT="0">
            this.m_LastRuleSection := this.m_xDoc.CreateElement("RULE")
            this.m_LastRuleSection.setAttribute("NAME","MAIN")
            this.m_LastRuleSection.setAttribute("TOPLEVEL","ACTIVE")
            this.m_LastRuleSection.setAttribute("EXPORT","0")
            this.m_LastGrammarSection.appendChild(this.m_LastRuleSection)
                ;<O><WILDCARD/></O>
                o := this.m_xDoc.CreateElement("O")
                this.m_LastRuleSection.appendChild(O)
                w:=this.m_xDoc.CreateElement("WILDCARD")
                o.appendChild(w)
                ;w:=this.m_xDoc.CreateElement("WILDCARD")
                ;this.m_LastRuleSection.appendChild(w)

                ;<L>
                this.m_LastRuleList := this.m_xDoc.CreateElement("L")
                this.m_LastRuleSection.appendChild(this.m_LastRuleList)
                ;leave empty for now, children will fill this
                ;</L>

                ;<O><WILDCARD/></O>
                o := this.m_xDoc.CreateElement("O")
                this.m_LastRuleSection.appendChild(O)
                w:=this.m_xDoc.CreateElement("WILDCARD")
                o.appendChild(w)
                ;w:=this.m_xDoc.CreateElement("WILDCARD")
                ;this.m_LastRuleSection.appendChild(w)

                ;<O>
                o := this.m_xDoc.CreateElement("O")
                this.m_LastRuleSection.appendChild(o)

                    ;<RULEREF NAME="MAIN"/>
                    recursive_rule := this.m_xDoc.CreateElement("RULEREF")
                    recursive_rule.setAttribute("NAME","MAIN")
                    o.appendChild(recursive_rule)
                ;</O>

            ;</RULE>
        ;</program>
        this.m_LastRuleSections.Push(this.m_LastRuleSection)
        this.m_LastRuleLists.Push(this.m_LastRuleList)
    }
    OnDecurseProgram(extra_data)
    {
        Debug.WriteStack("SaveMainTreeViewSpeech OnDecurseProgram",Debug.ErrLevelCore)
        
        this.m_LastRuleSection := this.m_LastRuleSections.Pop()
        this.m_LastRuleList := this.m_LastRuleLists.Pop()

        ;remove rule if nothing was added to the command choice list
        if(!this.m_LastRuleList.hasChildNodes)
        {
            this.m_LastGrammarSection.removeChild(this.m_LastRuleSection)
            Debug.WriteStackPushPop("SaveMainTreeViewSpeech OnDecurseProgram No Main Rule", Debug.ErrLevelCoreInfo)
        }
        ;remove program if nothing was added to to it
        if(!this.m_LastGrammarSection.hasChildNodes)
        {
            this.m_AllProgramsList.removeChild(this.m_LastProgramSection)
            Debug.WriteStackPushPop("SaveMainTreeViewSpeech OnDecurseProgram No Rules Created", Debug.ErrLevelCoreInfo)
        }
        ;the root, reset
        this.m_LastProgramSection := 0
        this.m_LastGrammarSection := 0
        this.m_LastRuleSection := 0
        this.m_LastRuleList := 0
        this.m_LastRuleSections :=[]
        this.m_LastRuleLists :=[]
    }
    SplitSpokenCommand(extra_data)
    {
        Debug.WriteStack("SaveMainTreeViewSpeech SplitSpokenCommand",Debug.ErrLevelCore)
        Array := StrSplit(extra_data.GetSpeakText(), "|")
        FinalArray := []
        ;errcount := 0
        ;someitems := false
        Debug.WriteStack("For Each Item",Debug.ErrLevelCore)
        For each, item in Array
        {
            Debug.WriteStack(item,Debug.ErrLevelCore)
            someitems := true
            item := StringHelper.LeadTrim(item)
            if(item != "")
            {
                FinalArray.Push(item)
            }
        }
        if(FinalArray.Length() == 0) 
        {
            Debug.WriteStack("FAIL",Debug.ErrLevelCore)
            Debug.WriteStack("SaveMainTreeViewSpeech SplitSpokenCommand Invalid Commands", Debug.ErrLevelCoreErrors)
            Return 0
        }
        return FinalArray
    }
    AddPlusToAllWords(Text)
    {
        Array := StrSplit(text, " ")
        FinalWord := ""
        For each, word in Array
        {
            Debug.WriteStack(word,Debug.ErrLevelCore)
            someitems := true
            word := StringHelper.LeadTrim(word)
            if(word != "")
            {
                FinalWord .= " +" . word
            }
        }
        FinalWord := StringHelper.LeadTrim(FinalWord)
        Debug.WriteStack(FinalWord,Debug.ErrLevelCore)
        return FinalWord
    }
    OnAddCommand(extra_data)
    {
        Debug.WriteStack("SaveMainTreeViewSpeech OnAddCommand",Debug.ErrLevelCore)

        ;the speak text come in the form of Say Something One|Say Something Two|Say Something Three
        
        Array := this.SplitSpokenCommand(extra_data)
        if (Array == 0)
        {
            return
        }
        /*
        <RULE NAME="COMMANDNAME" TOPLEVEL="INACTIVE" EXPORT="0">
            <L>
                <P PROPNAME="COMMANDNAME"> +COMMANDTEXT</P>
                <P PROPNAME="COMMANDNAME"> +COMMANDTEXT</P>
            </L>
        </RULE>
        */
        ;<RULE NAME="COMMANDNAME" TOPLEVEL="INACTIVE" EXPORT="0">
        CommandName := extra_data.GetCommandName()
        Debug.WriteStack("Adding Rule: " . CommandName,Debug.ErrLevelCore)
        rule := this.m_xDoc.CreateElement("RULE")
        rule.setAttribute("NAME",CommandName)
        rule.setAttribute("TOPLEVEL","INACTIVE")
        rule.setAttribute("EXPORT","0")

        
            ;<L>
            l := this.m_xDoc.CreateElement("L")
            rule.appendChild(l)
                ;<P PROPNAME="COMMANDNAME"> +COMMANDTEXT</P>
                for each, item in Array
                {
                    Debug.WriteStackPushPop("Adding Choice: " . CommandName . " Text: " . item, Debug.ErrLevelCoreInfo)
                    p:=this.m_xDoc.CreateElement("P")
                    p.setAttribute("PROPNAME", CommandName)
                    p.text := this.AddPlusToAllWords(item)
                    l.appendChild(p)
                }
            ;</L>
        ;</RULE>
        ;Now add the RULE to the sapi program rules section
        this.m_LastGrammarSection.appendChild(rule)

        ;now that we added the rule to the definition file, add is as a callable command of the last rule set
        /*
        <L>
            <RULEREF NAME="COMMANDNAME"/>
            ....
        </L>
        */
        rulref := this.m_xDoc.CreateElement("RULEREF")
        rulref.setAttribute("NAME",CommandName)
        this.m_LastRuleList.appendChild(rulref)

    }
    OnRecurseContext(extra_data)
    {
        Debug.WriteStack("SaveMainTreeViewSpeech OnRecurseContext",Debug.ErrLevelCore)
        ;The Command Context is split into 2 rules
        ;the words list enabling the command context
        /*
        <RULE NAME="COMMANDCONTEXTNAME_OTIONS" TOPLEVEL="INACTIVE" EXPORT="1">
            <L>
                <P PROPNAME="COMMANDCONTEXTNAME_OTIONS">+Perform +Option</P>
                <P PROPNAME="COMMANDCONTEXTNAME_OTIONS">+Do +Option</P>
                <P PROPNAME="COMMANDCONTEXTNAME_OTIONS">+Run +Option</P>
            </L>
            <RULEREF NAME="COMMANDCONTEXTNAME_OTIONS_OTIONS"/>
        </RULE>
        ;Which is inserted in the Last Rule List in the
        <L>
            <RULEREF NAME="COMMANDNAME"/>
            ....
        </L>
        section 

        ;and a repeatable recursive secondary set of rules, that is set as the "Last Rule added" so that items under it insert into this STUB as the OnAddCommand Does
        /*
        <RULE NAME="COMMANDCONTEXTNAME_OTIONS_OTIONS" TOPLEVEL="INACTIVE" EXPORT="0">
            <L>
                <RULEREF NAME="ANITEMUNDERTHISCONTEXT"/>
                <RULEREF NAME="ANITEMUNDERTHISCONTEXT"/>
                <RULEREF NAME="ANITEMUNDERTHISCONTEXT"/>
                ...
            </L>
            <O>
                <RULEREF NAME="COMMANDCONTEXTNAME_OTIONS_OTIONS"/>
            </O>
        </RULE>
        */
        
        RuleName := extra_data.GetContextName() . "_OPTIONS"
        ;so we to the _OPPTIONS here
        ;<RULE NAME="COMMANDCONTEXTNAME_OTIONS_OTIONS" TOPLEVEL="INACTIVE" EXPORT="0">
        this.m_LastRuleSection := this.m_xDoc.CreateElement("RULE")
        this.m_LastRuleSection.setAttribute("NAME",RuleName)
        this.m_LastRuleSection.setAttribute("TOPLEVEL","INACTIVE")
        this.m_LastRuleSection.setAttribute("EXPORT","0")
        this.m_LastGrammarSection.appendChild(this.m_LastRuleSection)
        
         ;<O><WILDCARD/></O>
                o := this.m_xDoc.CreateElement("O")
                this.m_LastRuleSection.appendChild(O)
                w:=this.m_xDoc.CreateElement("WILDCARD")
                o.appendChild(w)
                ;w:=this.m_xDoc.CreateElement("WILDCARD")
                ;this.m_LastRuleSection.appendChild(w)

            ;<L>
            this.m_LastRuleList := this.m_xDoc.CreateElement("L")
            this.m_LastRuleSection.appendChild(this.m_LastRuleList)
            ;leave empty for now, children will fill this
            ;</L>

                ;<O><WILDCARD/></O>
                o := this.m_xDoc.CreateElement("O")
                this.m_LastRuleSection.appendChild(O)
                w:=this.m_xDoc.CreateElement("WILDCARD")
                o.appendChild(w)
                ;w:=this.m_xDoc.CreateElement("WILDCARD")
                ;this.m_LastRuleSection.appendChild(w)

            ;<O>
            o := this.m_xDoc.CreateElement("O")
            this.m_LastRuleSection.appendChild(o)
                l := this.m_xDoc.CreateElement("L")
                o.appendChild(L)

                ;<RULEREF NAME="MAIN"/>
                recursive_rule := this.m_xDoc.CreateElement("RULEREF")
                recursive_rule.setAttribute("NAME","MAIN")
                l.appendChild(recursive_rule)

                ;<RULEREF NAME="_OPTIONS"/>
                recursive_rule := this.m_xDoc.CreateElement("RULEREF")
                recursive_rule.setAttribute("NAME",RuleName)
                l.appendChild(recursive_rule)
                

               

                this.m_LastRuleSection.appendChild(o)
            ;</O>

        ;</RULE>
        this.m_LastRuleSections.Push(this.m_LastRuleSection)
        this.m_LastRuleLists.Push(this.m_LastRuleList)
    }
    OnDecurseContext(extra_data)
    {
        Debug.WriteStack("SaveMainTreeViewSpeech OnDecurseContext",Debug.ErrLevelCore)
        
        this.m_LastRuleSection := this.m_LastRuleSections.Pop()
        this.m_LastRuleList := this.m_LastRuleLists.Pop()

        ;remove rule if nothing was added to the command choice list
        if(!this.m_LastRuleList.hasChildNodes)
        {
            this.m_LastGrammarSection.removeChild(this.m_LastRuleSection)
            Debug.WriteStackPushPop("Command Context Has No Sub Items, Removing", Debug.ErrLevelCoreInfo)
            this.m_LastRuleSection := this.m_LastRuleSections[this.m_LastRuleSections.MaxIndex()]
            this.m_LastRuleList := this.m_LastRuleLists[this.m_LastRuleLists.MaxIndex()]
            return
        }
        ;now deal with this, like a command
        /*
        <RULE NAME="COMMANDCONTEXTNAME_OTIONS" TOPLEVEL="INACTIVE" EXPORT="1">
        
            <L>
                <P PROPNAME="COMMANDCONTEXTNAME_OTIONS">+Perform +Option</P>
                <P PROPNAME="COMMANDCONTEXTNAME_OTIONS">+Do +Option</P>
                <P PROPNAME="COMMANDCONTEXTNAME_OTIONS">+Run +Option</P>
            </L>
            <RULEREF NAME="COMMANDCONTEXTNAME_OTIONS"/>
        </RULE>
        */
        Array := this.SplitSpokenCommand(extra_data)
        if (Array == 0)
        {
            this.m_LastRuleSection := this.m_LastRuleSections[this.m_LastRuleSections.MaxIndex()]
            this.m_LastRuleList := this.m_LastRuleLists[this.m_LastRuleLists.MaxIndex()]
            return
        }
        ;<RULE NAME="COMMANDNAME" TOPLEVEL="INACTIVE" EXPORT="0">
        CommandName := extra_data.GetContextName()
        Debug.WriteStack("Adding Rule: " . CommandName,Debug.ErrLevelCore)
        rule := this.m_xDoc.CreateElement("RULE")
        rule.setAttribute("NAME",CommandName)
        rule.setAttribute("TOPLEVEL","INACTIVE")
        rule.setAttribute("EXPORT","0")
            ;<L>
            l := this.m_xDoc.CreateElement("L")
            rule.appendChild(l)
                ;<P PROPNAME="COMMANDNAME"> +COMMANDTEXT</P>
                for each, item in Array
                {
                    Debug.WriteStackPushPop("Adding Choice: " . CommandName . " Text: " . item, Debug.ErrLevelCoreInfo)
                    p:=this.m_xDoc.CreateElement("P")
                    p.setAttribute("PROPNAME", CommandName)
                    p.text := this.AddPlusToAllWords(item)
                    l.appendChild(p)
                }
            ;</L>
            ;<O>
            o := this.m_xDoc.CreateElement("O")
            rule.appendChild(o)
                ;<RULEREF NAME="COMMANDCONTEXTNAME_OTIONS"/>
                options_rule_ref := this.m_xDoc.CreateElement("RULEREF")
                options_rule_ref.setAttribute("NAME", CommandName . "_OPTIONS")
                o.appendChild(options_rule_ref)
            ;</O>
        ;</RULE>
        ;Now add the RULE to the sapi program rules section
        this.m_LastGrammarSection.appendChild(rule)

        ;now that we added the rule to the definition file, add is as a callable command of the last rule set
        /*
        <L>
            <RULEREF NAME="COMMANDNAME"/>
            ....
        </L>
        */

        this.m_LastRuleSection := this.m_LastRuleSections[this.m_LastRuleSections.MaxIndex()]
        this.m_LastRuleList := this.m_LastRuleLists[this.m_LastRuleLists.MaxIndex()]
        rulref := this.m_xDoc.CreateElement("RULEREF")
        rulref.setAttribute("NAME",CommandName)
        this.m_LastRuleList.appendChild(rulref)
    }
    OnRecurseContextWindow(extra_data)
    {
        Debug.WriteStack("SaveMainTreeViewSpeech OnRecurseContextWindow",Debug.ErrLevelCore)
        ;The Context Window like the command context exect it does not have a rule for itself
        ;as it's only reachable when the window gets focus, so like the command context it has a _OPTIONS
        ;that will be enabled when the window activates
        ;the words list enabling the command context
        /*
        <RULE NAME="WINDOWCONTEXTNAME_OTIONS" TOPLEVEL="INACTIVE" EXPORT="0">
            <L>
                <RULEREF NAME="ANITEMUNDERTHISCONTEXT"/>
                <RULEREF NAME="ANITEMUNDERTHISCONTEXT"/>
                <RULEREF NAME="ANITEMUNDERTHISCONTEXT"/>
                ...
            </L>
            <O>
                <RULEREF NAME="COMMANDCONTEXTNAME_OTIONS_OTIONS"/>
            </O>
        </RULE>
        */
        
        RuleName := extra_data.GetContextName() . "_OPTIONS"
        ;so we to the _OPPTIONS here
        ;<RULE NAME="COMMANDCONTEXTNAME_OTIONS_OTIONS" TOPLEVEL="INACTIVE" EXPORT="0">
        this.m_LastRuleSection := this.m_xDoc.CreateElement("RULE")
        this.m_LastRuleSection.setAttribute("NAME",RuleName)
        this.m_LastRuleSection.setAttribute("TOPLEVEL","INACTIVE")
        this.m_LastRuleSection.setAttribute("EXPORT","0")
        this.m_LastGrammarSection.appendChild(this.m_LastRuleSection)
            ;<L>
            this.m_LastRuleList := this.m_xDoc.CreateElement("L")
            this.m_LastRuleSection.appendChild(this.m_LastRuleList)
            ;leave empty for now, children will fill this
            ;</L>

            ;<O>
            o := this.m_xDoc.CreateElement("O")
            this.m_LastRuleSection.appendChild(o)

                ;<RULEREF NAME="MAIN"/>
                recursive_rule := this.m_xDoc.CreateElement("RULEREF")
                recursive_rule.setAttribute("NAME",RuleName)
                o.appendChild(recursive_rule)
            ;</O>

        ;</RULE>
        this.m_LastRuleSections.Push(this.m_LastRuleSection)
        this.m_LastRuleLists.Push(this.m_LastRuleList)
    }
    OnDecurseContextWindow(extra_data)
    {
        Debug.WriteStack("SaveMainTreeViewSpeech OnDecurseContextWindow",Debug.ErrLevelCore)
        
        this.m_LastRuleSection := this.m_LastRuleSections.Pop()
        this.m_LastRuleList := this.m_LastRuleLists.Pop()

        ;remove rule if nothing was added to the command choice list
        if(!this.m_LastRuleList.hasChildNodes)
        {
            this.m_LastGrammarSection.removeChild(this.m_LastRuleSection)
            Debug.WriteStackPushPop("Command Context Has No Sub Items, Removing", Debug.ErrLevelCoreInfo)
            this.m_LastRuleSection := this.m_LastRuleSections[this.m_LastRuleSections.MaxIndex()]
            this.m_LastRuleList := this.m_LastRuleLists[this.m_LastRuleLists.MaxIndex()]
            return
        }
        
        ;and simply pop out nothing else to do
        this.m_LastRuleSection := this.m_LastRuleSections[this.m_LastRuleSections.MaxIndex()]
        this.m_LastRuleList := this.m_LastRuleLists[this.m_LastRuleLists.MaxIndex()]

    }
}

Class MainTreeviewSpeech
{
    static m_xDoc := 
    Load(Filename)
    {
        Debug.WriteStackPush("MainTreeViewSpeech Load Start",Debug.ErrLevelCore)
        ThisInst := New MainTreeviewSpeech() 
        last:=a_defaultgui
        Gui, MainUIWindow_:Default

        MainTreeviewSpeech.m_xDoc := New_DOMDocument()
        if(!MainTreeviewSpeech.m_xDoc.load(Filename))
        {
            
            Stack:=Debug.ClearStack()
            xPE := MainTreeviewSpeech.m_xDoc.parseError()
            Debug.WriteNL("",Debug.ErrLevelImportant)
            Debug.WriteNL("ERROR",Debug.ErrLevelImportant)
            Debug.WriteNL("The document failed to load.",Debug.ErrLevelImportant)
            Debug.WriteNL("File: " . Filename, Debug.ErrLevelImportant)
            Debug.WriteNL("due the following error.",Debug.ErrLevelImportant)
            Debug.WriteNL("Error #: " . xPE.errorCode() . " : " .  xPE.reason,Debug.ErrLevelImportant)
            Debug.WriteNL("Position In File:" . xPE.filepos,Debug.ErrLevelImportant)
            Debug.WriteNL("Line #: " . xPE.Line,Debug.ErrLevelImportant)
            Debug.WriteNL("Line Position:" . xPE.linepos,Debug.ErrLevelImportant)
            Debug.WriteNL("Source Text:" . xPE.srcText,Debug.ErrLevelImportant)
            Debug.SetStack(xPE.linepos/2 + 6,Debug.ErrLevelImportant) ;lets see where using the debug stack which tabs with 2 spaces per pos
            Debug.WriteStack("^",Debug.ErrLevelImportant)
            Debug.WriteNL("Document URL:" . xPE.url,Debug.ErrLevelImportant)
            Debug.WriteNL("",Debug.ErrLevelImportant)
            Debug.SetStack(Stack)
            Debug.MsgBox("Failed to load file: " . Filename)
           
        }
        Else
        {
            ;recurse from root 0 so enter apps main root + groups and and all exes under those
            TVHelper.recurse_filter(0,[TV_TYPES.EXE],[TV_TYPES.APPS,TV_TYPES.GROUP],ThisInst)
        }
        Debug.WriteStackPop("MainTreeViewSpeech Load End",Debug.ErrLevelCore)

        Gui, %last%:Default
    }
    FindGrammarElement(ExeName)
    {
        Debug.WriteStackPushPop("MainTreeviewSpeech FindGrammarElement for " . ExeName,Debug.ErrLevelCore)
        ;Nodes := MainTreeviewSpeech.m_xDoc.selectSingleNode("elements");
        
        root := MainTreeviewSpeech.m_xDoc.documentElement
        Nodes := root.childNodes
        ct := Nodes.length
        Debug.WriteStackPushPop("Nodes.length " . ct,Debug.ErrLevelCore)
        Loop, %ct%
        {
            
            xNode := Nodes.Item(A_Index-1) ;A_Index 1->n to item(0->(n-1))
            
            ;If xNode.nodeType = NODE_TEXT Then
             Debug.WriteStackPushPop("At index of " . A_Index . " Is " . xNode.getAttribute("name") . "==" . ExeName,Debug.ErrLevelCore)
            if(xNode.getAttribute("name") == ExeName)
            {
                Debug.WriteStack("Found Speech Node for exe:" . ExeName,Debug.ErrLevelCore)
                return xNode
            } ;End If
           
        } ;Next xNode
         return 0
    }
    
    OnAdd(extra_data,type,tvitem)
    {
        Debug.WriteStack("MainTreeviewSpeech OnAdd",Debug.ErrLevelCore)
        extra_data.SetSpeechGrammarDom(MainTreeviewSpeech.FindGrammarElement(extra_data.GetExeName()))

    }
    OnRecurse(extra_data,type,tvitem)
    {
        Debug.WriteStack("MainTreeviewSpeech OnRecurse",Debug.ErrLevelCore)
    }
    OnDecurse(extra_data,type,tvitem)
    {
        Debug.WriteStack("MainTreeviewSpeech OnDecurse",Debug.ErrLevelCore)
    }
}



