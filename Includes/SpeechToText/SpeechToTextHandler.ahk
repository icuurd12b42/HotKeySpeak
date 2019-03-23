global gRC ;global because is used in the exe item

global gInterupted := false
global gSAPIRunning
;errors over the last 30 seconds
global gErrorEvents
;maximum number of errors

Class Recognition
{
    static m_SentencesArray := []
    static m_CommandsArray := []
    static m_ConfidencesArray := []
    static m_Confidence := ""
    static m_CommandString := ""
    static m_DictationText := ""
    static m_IsDictating := false
    static m_OnDictateCodeToRun := ""
    static m_TurnDictationOn := false
    SetSentencesArray(SentencesArray)
    {
        Recognition.m_SentencesArray := SentencesArray
    }
    GetSentencesArray()
    {
        return Recognition.m_SentencesArray
    }

    SetConfidencesArray(ConfidencesArray)
    {
        Recognition.m_ConfidencesArray := ConfidencesArray
    }

    GetConfidencesArray()
    {
        return Recognition.m_ConfidencesArray
    }

    SetCommandsArray(CommandsArray)
    {
        Recognition.m_CommandsArray := CommandsArray
    }
    GetCommandsArray()
    {
        return Recognition.m_CommandsArray
    }

    SetConfidence(Confidence)
    {
        Recognition.m_Confidence := Confidence
    }
    GetConfidence()
    {
        return Recognition.m_Confidence
    }

    SetCommandString(CommandsString)
    {
        Recognition.m_CommandString := CommandsString
    }
    GetCommandString()
    {
        return Recognition.m_CommandString
    }

    SetDictationText(DictationText)
    {
        Recognition.m_DictationText := DictationText
    }
    GetDictationText()
    {
        return Recognition.m_DictationText
    }
    IsDictating()
    {
        return Recognition.m_IsDictating
    }
    SetDictating(Dictating)
    {
        Recognition.m_IsDictating := Dictating
    }
    StartDictating(code)
    {
        ;if (gInHypothesis)
        ;{
        ;    Recognition.SetDictating(False)
        ;    return
        ;}
        Recognition.m_TurnDictationOn := true
        Recognition.m_OnDictateCodeToRun := code

    }
    GetConfidenceThreshold()
    {
        return gSAPIMinThreshold
    }
}


global gLastSaid
global gSaidIndex
global gSAPIErrorAvg
global gSaidSomething
global gSAPIConfidenceAvg
class SpeechToTextHandler
{
    ;Event Handler handling
    m_PrimaryRule := ;the rule under current context
    m_SecondaryRule := ;the rule at the context level
    m_TerciaryRule := ;the root rule for the exe/window context
    m_process_extra_data :=
    gInterupted := 0
    ;SAPI
    m_Recognizer := 
    m_Category :=
    m_Token :=
    gLastSaid :=""
    gSaidIndex := 0
    Init()
    {
        gInterupted := 0
        SpeechToTextHandler.m_PrimaryRule := 0
        SpeechToTextHandler.m_SecondaryRule := 0
        SpeechToTextHandler.m_TerciaryRule := 0
        SpeechToTextHandler.m_process_extra_data := 0
        EventManager.AddHandler(SpeechToTextHandler)
    }
    InitSAPI()
    {
        try{
        
        global gSAPIRunning := false
        ;errors over the last 30 seconds
        global gErrorEvents := []
        ;maximum number of errors
        
        global gSAPIConfidenceAvg := gSAPIMinThreshold
        global gSAPIErrorAvg := 0
        global gSaidSomething := false
        
        gRC := New_SpInProcRecoContext("RC_")
        this.m_Recognizer := gRC.Recognizer()
        ;Dim Category As SpObjectTokenCategory
        this.m_Category := New_SpObjectTokenCategory()
        this.m_Category.SetId(SpeechStringConstants.SpeechCategoryAudioIn)
        ;Dim Token As SpObjectToken
        this.m_Token := New_SpObjectToken()
        this.m_Token.SetId(this.m_Category.Default())
        this.m_Recognizer.AudioInput := this.m_Token
        gSAPIRunning := true
        gWarnError := false
        }
        catch e
        {
            Debug.WriteNL("",Debug.ErrLevelImportant)
            Debug.WriteNL("Exception Setting Up Mic",Debug.ErrLevelImportant)
            Debug.WriteNL(e.message,Debug.ErrLevelImportant)
            Debug.WriteNL("Is Your Microphone Configured?",Debug.ErrLevelImportant)
        }
    }
    ;Deactivate/Activate the rule
    SetupRule(RuleName, ONOFF)
    {
        Debug.WriteStackPushPop("SpeechToTextHandler.SetupRule() Rule: " . RuleName . " set to " . ONOFF,Debug.ErrLevelCore)
        if(RuleName == 0) 
            return
        if(RuleName == "") 
            return
        
        if(ONOFF == "ON")
        {
            SpeechToTextHandler.m_process_extra_data.EnableSpeechRuleName(RuleName)
            
        }
        else
        {
            SpeechToTextHandler.m_process_extra_data.DisableSpeechRuleName(RuleName)
        }
        
    }
    
    ;event manager notification
    OnProcessActivate(extra_data)
    {
        Debug.WriteStackPushPop("SpeechToTextHandler.OnProcessActivate()",Debug.ErrLevelCore)
        ;extra data is a exe item, can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
        SpeechToTextHandler.m_process_extra_data := extra_data
        SpeechToTextHandler.m_PrimaryRule := 0
        SpeechToTextHandler.m_SecondaryRule := 0
        SpeechToTextHandler.m_TerciaryRule := 0
        SpeechToTextHandler.m_process_extra_data := extra_data
        if(extra_data)
        {
            Debug.WriteStackPushPop("SpeechToTextHandler.OnProcessActivate Rule: MAIN ON PROCESS: " . extra_data.GetExeName(),Debug.ErrLevelCore)
            SpeechToTextHandler.m_process_extra_data.EnableSpeech()
            SpeechToTextHandler.m_TerciaryRule := extra_data.m_RuleName
        }
    }
    ;event manager notification
    OnProcessDeactivate(extra_data)
    {
        Debug.WriteStackPushPop("SpeechToTextHandler.OnProcessDeactivate()",Debug.ErrLevelCore)
        ;extra data is a exe item, can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
        SpeechToTextHandler.m_process_extra_data := extra_data
        if(extra_data)
        {
            Debug.WriteStackPushPop("SpeechToTextHandler.OnProcessDeactivate Rule: MAIN OFF PROCESS: " . extra_data.GetExeName(),Debug.ErrLevelCore)
            SpeechToTextHandler.m_process_extra_data.DisableSpeech()
        }
        
        
    }
    ;event manager notification
    OnItemActivate(extra_data)
    {

        Debug.WriteStackPushPop("SpeechToTextHandler.OnItemActivate()",Debug.ErrLevelCore)
        ;extra data is a command, context or window context, can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
        if(extra_data)
        {
            type := extra_data.GetType()
            If(type == TV_TYPES.COMMAND )
            {
                SpeechToTextHandler.m_PrimaryHotKeysrule := extra_data.m_ParentParentRuleName
                SpeechToTextHandler.m_SecondaryHotKeysrule := extra_data.m_ParentRuleName
                SpeechToTextHandler.m_TerciaryHotKeysrule := extra_data.m_RootRuleName
                SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_SecondaryHotKeysrule,"ON")
                SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_TerciaryHotKeysrule,"ON")
            }
            else If(type == TV_TYPES.CONTEXT)
            {
                SpeechToTextHandler.m_PrimaryHotKeysrule := extra_data.m_RuleName
                SpeechToTextHandler.m_SecondaryHotKeysrule := extra_data.m_ParentRuleName
                SpeechToTextHandler.m_TerciaryHotKeysrule := extra_data.m_RootRuleName
                
                SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_PrimaryHotKeysrule,"ON")
                SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_SecondaryHotKeysrule,"ON")
                SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_TerciaryHotKeysrule,"ON")
                
            }
            else if(type == TV_TYPES.WINDOWCONTEXT)
            {
                SpeechToTextHandler.m_PrimaryHotKeysrule := 0
                SpeechToTextHandler.m_SecondaryHotKeysrule := 0
                SpeechToTextHandler.m_TerciaryHotKeysrule := extra_data.m_RuleName
                SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_TerciaryHotKeysrule,"ON")
            }
            else if(type == TV_TYPES.EXE)
            {
                SpeechToTextHandler.m_PrimaryHotKeysrule := 0
                SpeechToTextHandler.m_SecondaryHotKeysrule := 0
                SpeechToTextHandler.m_TerciaryHotKeysrule := extra_data.m_RuleName
                SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_TerciaryHotKeysrule,"ON")
            }
        }
        else
        {
            SpeechToTextHandler.m_PrimaryHotKeysrule := 0
            SpeechToTextHandler.m_SecondaryHotKeysrule := 0
            SpeechToTextHandler.m_TerciaryHotKeysrule := 0
        }
    }
    ;event manager notification
    OnItemDeactivate(extra_data)
    {
    return
        Debug.WriteStackPushPop("SpeechToTextHandler.OnItemDeactivate()",Debug.ErrLevelCore)
        ;extra data is a command, context or window context, , can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
        ;deactivate the context portion of the rule
        
        SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_PrimaryHotKeysrule,"OFF")
        SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_SecondaryHotKeysrule,"OFF")
        SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_TerciaryHotKeysrule,"OFF")
        SpeechToTextHandler.m_PrimaryHotKeysrule := 0
        SpeechToTextHandler.m_SecondaryHotKeysrule := 0
        SpeechToTextHandler.m_TerciaryHotKeysrule := 0
        
    }
    ;event manager notification
    OnTimer()
    {
        ;Called every n millisecs by the singleton EventManager Timer
    }
    ;RC_ event handling
    ;re-write this shit
    SelectSpokenItem(CommandsArray,SentencesArray,CommandsString, Confidence) ;Selects the item on the treeview that matches what recogniser found
    {
        if(Recognition.m_TurnDictationOn)
        {
            return
        }
        if(Recognition.IsDictating())
        {
            return
        }
 ;Debug.WriteNL("SelectSpokenItem: ")       
        if(Confidence<gSAPIMinThreshold)
        {
            Debug.WriteStackPushPop("SelectSpokenItem() Below Threshold..." .  Confidence, Debug.ErrLevelCoreInfo)
            return
        }
        if(gLastSaid == CommandsString)
        {
            Debug.WriteStackPushPop("SelectSpokenItem() Said That...",Debug.ErrLevelCore)
            ;MyOutputDebugAlways("SelectSpokenItem() Said That...")
            return
        }
        gLastSaid := CommandsString

        

        ;SayWhatIMean(Sentence)
        Debug.WriteStackPush("SelectSpokenItem() Start",Debug.ErrLevelCore)

        ;loop though each command
        sat := gSaidIndex
        ln := CommandsArray.Length()
        ct := ln - sat
        if(ln ==1)
        {
            ct := 1
        }
        loop, %ct%
        {
            sat++
            CommandName := CommandsArray[sat]
;Debug.WriteNL("Command: " . CommandName)
            Sentence := SentencesArray[sat]
            ;use the fast reference for unique command name
            extra_data := SpeechToTextHandler.m_process_extra_data.m_FastRefItems[CommandName]
            if(extra_data)
            {
                if(!TVHelper.BranchDisabled(extra_data.GetTreeviewItemIndex()))
                {
                    Debug.Writepushpop("Found Possible Command:" . CommandName,Debug.ErrLevelCoreInfo)
                    
                    if(TVHelper.IsValInArr(Sentence,extra_data.m_SpeakArray))
                    {
                        Debug.Writepushpop("Command Matches Text " . Sentence,Debug.ErrLevelCoreInfo)
                        gSaidIndex := sat
                        EventManager.SetActiveData(extra_data)
                        Debug.Writepushpop("Run: " . extra_data.GetItemText(), Sentence,Debug.ErrLevelCoreInfo)
                        TVHelper.Redraw()
                        MySleep(10)
                    }
                }
            }
        }
        
        Debug.WriteStackPop("SelectSpokenItem() End",Debug.ErrLevelCore)
    }
    AnalizeResults(StreamPosition,Result,ConfidenceThreshold)
    {
        
        if(Recognition.IsDictating())
        {
            Recognition.SetDictationText(Result.PhraseInfo.GetText())
        }
        ;Label2.Caption = "Rule Properties Found : " & Result.PhraseInfo.Properties.Count & vbCrLf
        ;For i = 0 To Result.PhraseInfo.Properties.Count - 1
        i:=0
        ict := Result.PhraseInfo.Properties.Count
        CommandsArray := []
        SentencesArray := []
        CommandsConfidence := []
        CommandsString := "" 
        Confidence := 1
        OldConfs := Recognition.GetConfidencesArray()
        OldConfsLen := OldConfs.Length()
        jct := 0
        Loop, %ict%
        {
            ;Label2.Caption = Label2.Caption & _
            ;    "Rules Name: " & Result.PhraseInfo.Properties.Item(i).Name
            theFirstElement := Result.PhraseInfo.Properties.Item(i).FirstElement
            theNumberOfElements := Result.PhraseInfo.Properties.Item(i).NumberOfElements

            theString := ""
            ;For j = 0 To theNumberOfElements - 1
            j := 0
            jct := theNumberOfElements
            CommandName:=Result.PhraseInfo.Properties.Item(i).Name
            CommandWordCount := jct
            SentenceString := ""
            
            CommandConfidence := 0
            loop, %jct%
            {
                try
                {
                    wordElement := Result.PhraseInfo.Elements(theFirstElement + j)
                    wordText := wordElement.DisplayText
                    wordConf := wordElement.EngineConfidence
                    ;if(wordConf<Confidence)
                    ;{
                    ;    Confidence := Confidence * (j+1) + wordConf
                    ;}
                    Confidence := (Confidence + wordConf * 4)/5
                    CommandConfidence += wordConf
                    gSAPIConfidenceAvg := (gSAPIConfidenceAvg *4 + Confidence)/5
                    ;wordTime := (wordElement.AudioTimeOffset + StreamPosition) * 0.0000001
                    wordTime := wordElement.AudioSizeTime * 0.0000001
                    SentenceString .= wordText ;. "(" . wordConf . ")" . "(" . wordTime . ")"
                    ;MyOutputDebugAlways(wordText . "(" . wordConf . ")")
                }
                j++
                if(j<jct)
                {
                    SentenceString .= " "
                }
            }
            
            CommandsArray.Push(CommandName)
            SentencesArray.Push(SentenceString)
            CommandsString .= SentenceString
            
            ;Next

            i++
            if(i<ict)
            {
                CommandsString .= "|"
            }
            CommandConfidence /= j
            ;keep maintain average confidence for that command
            if(i<= OldConfsLen)
            {
                if(OldConfs[i] < CommandConfidence)
                {
                    CommandConfidence := (OldConfs[i]  + CommandConfidence*2)/3
                }
            }
            CommandsConfidence.Push(CommandConfidence)
        }
        if(ict == 0 || jct == 0)
        {
            Confidence := 0
        }
       
        ;Next
        return {CommandsArray: CommandsArray, SentencesArray: SentencesArray, CommandsString: CommandsString, Confidence: Confidence, CommandsConfidence: CommandsConfidence}
    }
}


;Recog Stuff
AddErrorEvent(time)
{
    Debug.WriteNL("AddErrorEvent()",Debug.ErrLevelCore)
    if(gInterupted || gSAPITraining)
    {
        return
    }
    timeinsecs := GetTickCount() *.001 ;time * 0.00001
    Debug.WriteNL("TIme " . timeinsecs,Debug.ErrLevelCore)
    aminuteago :=  timeinsecs - 60
    gErrorEvents.Push(timeinsecs)
    if(gErrorEvents.Length())
    {
        event := gErrorEvents[1]
        Debug.WriteNL("FirstEvent " . event,Debug.ErrLevelCore)
        while(event && event < aminuteago)
        {
            Debug.WriteNL("Removing Error " . event,Debug.ErrLevelCore)
            gErrorEvents.RemoveAt(1)

            event := gErrorEvents[1]
        }
    }
    ;if(!gEditing)
    ;{
        if(gErrorEvents.Length())
        {
            gSAPIErrorAvg := (gSAPIErrorAvg + gErrorEvents.Length()) / 2
            
        }
    ;}
    if(gErrorEvents.Length() >= gSAPIMaxErrorCount && gSAPIWarnedError == false && gSAPIIgnoreProblem == false)
    {
        Debug.WriteNL("",Debug.ErrLevelImportant)
        Debug.WriteNL("There may be issues with your microphone",Debug.ErrLevelImportant)
        Debug.WriteNL("If it's muted, it can still produce noise but you can ignore it",Debug.ErrLevelImportant)
        Debug.WriteNL("If everything seems to be running fine you can ignore it",Debug.ErrLevelImportant)
        Debug.WriteNL("I suggest you set up your microphone with MS Speech Recogntion",Debug.ErrLevelImportant)
        gSAPIWarnedError:= true
    }
}


RC_Interference(StreamNumber, StreamPosition, Interference)
{
    Debug.WriteStackPushPop("RC_Interference()",Debug.ErrLevelCore)
    AddErrorEvent(StreamPosition)
}
RC_FalseRecognition(StreamNumber, StreamPosition, Result)
{
    Debug.WriteStackPushPop("RC_FalseRecognition()",Debug.ErrLevelCore)

    Recognition.SetSentencesArray([])
    Recognition.SetConfidencesArray([])
    Recognition.SetCommandsArray([])
    Recognition.SetConfidence(0)
    Recognition.SetCommandString("")
    Recognition.SetDictationText("")
    if(Recognition.IsDictating())
    {
        SpeechToTextHandler.m_process_extra_data.StopDictationMode()
        SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_PrimaryHotKeysrule,"ON")
        SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_SecondaryHotKeysrule,"ON")
        SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_TerciaryHotKeysrule,"ON")
    }
    Recognition.SetDictating(false)

    AddErrorEvent(StreamPosition)
}
global DictationSetInHypothesis = false
RC_Hypothesis(StreamNumber, StreamPosition, Result)
{
    gInHypothesis := true
    if(gSAPILiveRecognition)
    {
        Debug.WriteStackPushPop("RC_Hypothesis()",Debug.ErrLevelCore)
        if(gInterupted || gSAPITraining)
        {
            return
        }
        res := SpeechToTextHandler.AnalizeResults(StreamPosition,Result,gSAPIMinThreshold)
        
        if(gLastSaid != res["CommandsString"])
        {
            Recognition.SetSentencesArray(res["SentencesArray"])
            Recognition.SetCommandsArray(res["CommandsArray"])
            Recognition.SetConfidencesArray(res["CommandsConfidence"])
            Recognition.SetConfidence(res["Confidence"])
            Recognition.SetCommandString(res["CommandsString"])
        }
        
        if(Recognition.IsDictating())
        {
            
            jsRunner := Interpreter
            if(EventManager.m_current_process_extra_data)
            {
                jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
            }
            
            jsRunner.Exec(Recognition.m_OnDictateCodeToRun)
        }
        else
        {
            OldDictating := Recognition.IsDictating()
            SpeechToTextHandler.SelectSpokenItem(res["CommandsArray"],res["SentencesArray"],res["CommandsString"], res["Confidence"])
            if(OldDictating == false && Recognition.IsDictating() == true)
            {
                DictationSetInHypothesis := true
                ;Recognition.SetDictating(False)
            }
            else
            {
                DictationSetInHypothesis := false
            }
        }
    }
    gInHypothesis := false
}
RC_Recognition(StreamNumber, StreamPosition, RecognitionType, Result)
{
    Debug.WriteStackPushPop("RC_Recognition()",Debug.ErrLevelCore)
    if(gInterupted || gSAPITraining)
    {
        return
    }
    
    res := SpeechToTextHandler.AnalizeResults(StreamPosition,Result,gSAPIMinThreshold)
    if(gLastSaid != res["CommandsString"])
    {
        Recognition.SetSentencesArray(res["SentencesArray"])
        Recognition.SetCommandsArray(res["CommandsArray"])
        Recognition.SetConfidencesArray(res["CommandsConfidence"])
        Recognition.SetConfidence(res["Confidence"])
        Recognition.SetCommandString(res["CommandsString"])
    }
    if(Recognition.IsDictating() && DictationSetInHypothesis == false)
    {
        Recognition.SetDictating(false)
        SpeechToTextHandler.m_process_extra_data.StopDictationMode()
        SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_PrimaryHotKeysrule,"ON")
        SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_SecondaryHotKeysrule,"ON")
        SpeechToTextHandler.SetupRule(SpeechToTextHandler.m_TerciaryHotKeysrule,"ON")
        jsRunner := Interpreter
        if(EventManager.m_current_process_extra_data)
        {
            jsRunner := EventManager.m_current_process_extra_data.m_Interpreter
        }
        
        jsRunner.Exec(Recognition.m_OnDictateCodeToRun)
    }
    else
    {
        SpeechToTextHandler.SelectSpokenItem(res["CommandsArray"],res["SentencesArray"],res["CommandsString"], res["Confidence"])
    }

    if(Recognition.m_TurnDictationOn)
    {
        Recognition.SetDictating(True)
        Recognition.SetDictationText("")
        
        SpeechToTextHandler.m_process_extra_data.SetDictationMode()
    }
    Recognition.m_TurnDictationOn := false
    
}
RC_PhraseStart(StreamNumber, StreamPosition)
{
    gSaidSomething:=true
    gInterupted := gSAPIPaused || gSapiHold || gSAPITraining
    Recognition.SetSentencesArray([])
    Recognition.SetCommandsArray([])
    Recognition.SetConfidencesArray([])
    Recognition.SetConfidence(0)
    Recognition.SetCommandString("")
    Recognition.SetDictationText("")
    DictationSetInHypothesis := false  
    Debug.WriteStackPushPop("RC_PhraseStart()",Debug.ErrLevelCore)
    ;This happens when the user starts speaking, we can ready up here
    ;Debug.WriteStack("RC_PhraseStart()",Debug.ErrLevelCore)
    gLastSaid := ""
    gSaidIndex := 0
}
RC_SoundEnd(StreamNumber, StreamPosition)
{
    Debug.WriteStackPushPop("RC_SoundEnd()",Debug.ErrLevelCore)
    if(gSaidSomething==false)
    {
        AddErrorEvent(StreamPosition)
    }
    
}

;https://msdn.microsoft.com/en-us/library/ee125421(v=vs.85).aspx
RC_SoundStart(StreamNumber, StreamPosition)
{
    Debug.WriteStackPushPop("RC_SoundStart()",Debug.ErrLevelCore)
    gSaidSomething:=false
    
}
;Loading
class LoadMainTreeRuleNames
{
    m_WhatsAValidBranch :=
    m_WhatsAValidAddItem :=
    m_Last_exe_extra_data :=
    m_last_hk_rules := 
    m_last_hk_rule :=
    m_last_root_rule :=
    m_last_root_rules :=
    m_last_parent_hk_rule :=
    Load(StartBranch)
    {
        Debug.WriteStackPush("LoadMainTreeRuleNames Load Start",Debug.ErrLevelCore)
        ;SpeechToTextHandler.OnItemDeactivate(0)
        ThisInst := New LoadMainTreeRuleNames()
        ThisInst.m_Last_exe_extra_data := 0
        ThisInst.m_last_hk_rules := []
        ThisInst.m_last_hk_rule := 0
        ThisInst.m_last_root_rule := 0
        ThisInst.m_last_root_rules := []
        this.m_last_parent_hk_rule := 0
        ThisInst.m_WhatsAValidBranch := [TV_TYPES.APPS,TV_TYPES.EXE,TV_TYPES.CONTEXT,TV_TYPES.GROUP,TV_TYPES.WINDOWCONTEXT]
        ThisInst.m_WhatsAValidAddItem := [TV_TYPES.FILERESOURCE,TV_TYPES.APPS,TV_TYPES.EXE,TV_TYPES.COMMAND,TV_TYPES.CONTEXT,TV_TYPES.GROUP,TV_TYPES.WINDOWCONTEXT]
        TVHelper.IgnoreDisabled(True)
        TVHelper.recurse_filter(0, ThisInst.m_WhatsAValidAddItem, ThisInst.m_WhatsAValidBranch, ThisInst)
        TVHelper.IgnoreDisabled(False)
        ThisInst := 0
        Debug.WriteStackPop("LoadMainTreeRuleNames Load End",Debug.ErrLevelCore)
    }
    ;TVHelper.recurse_filter notifications
    OnAdd(extra_data,type,tvitem)
    {
        Debug.WriteStack("LoadMainTreeRuleNames OnAdd",Debug.ErrLevelCore)
        if(type == TV_TYPES.EXE)
        {
            extra_data.m_RuleName := "MAIN"
            this.m_last_hk_rule := extra_data.m_RuleName
            this.m_last_root_rule := this.m_last_hk_rule
        }
        else if(type == TV_TYPES.COMMAND)
        {
            extra_data.m_ParentParentRuleName := this.m_last_parent_hk_rule
            extra_data.m_ParentRuleName := this.m_last_hk_rule
            extra_data.m_RootRuleName := this.m_last_root_rule
        }
        else if(type == TV_TYPES.CONTEXT)
        {
            this.m_last_parent_hk_rule := this.m_last_hk_rule
            extra_data.m_ParentRuleName := this.m_last_hk_rule
            extra_data.m_RootRuleName := this.m_last_root_rule
            extra_data.m_RuleName := extra_data.GetContextName() . "_OPTIONS"
            this.m_last_hk_rules.push(this.m_last_hk_rule)
            this.m_last_hk_rule := extra_data.m_RuleName
        }
        else if(type == TV_TYPES.WINDOWCONTEXT)
        {
            extra_data.m_ParentRuleName := this.m_last_hk_rule
            extra_data.m_RootRuleName := this.m_last_root_rule
            extra_data.m_RuleName := extra_data.GetContextName() . "_OPTIONS"
            this.m_last_hk_rules.push(this.m_last_hk_rule)
            this.m_last_hk_rule := extra_data.m_RuleName
            
            this.m_last_root_rules.push(this.m_last_root_rule)
            this.m_last_root_rule := extra_data.m_RuleName
            this.m_last_parent_hk_rule := 0
        }
    }
    OnRecurse(extra_data,type,tvitem)
    {
        ;
    }
    OnDecurse(extra_data,type,tvitem)
    {
        Debug.WriteStack("LoadMainTreeRuleNames  OnDecurse",Debug.ErrLevelCore)
        if(type == TV_TYPES.EXE)
        {
            this.m_last_hk_rule := 0
            this.m_last_parent_hk_rule := 0
            
        }
        else if(type == TV_TYPES.CONTEXT)
        {
            this.m_last_hk_rule := this.m_last_hk_rules.pop()
            this.m_last_parent_hk_rule := this.m_last_hk_rule
        }
        else if(type == TV_TYPES.WINDOWCONTEXT)
        {
            this.m_last_hk_rule := this.m_last_hk_rules.pop()
            this.m_last_root_rule := this.m_last_root_rules.pop()
            this.m_last_parent_hk_rule := this.m_last_hk_rule
        }
    }
}

