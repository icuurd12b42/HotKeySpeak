class GlobalEventHandler
{
    m_OldAllowSapiKeyPausing :=
    m_OldSapiPausingKey :=
    m_OldHKAllowKeyPausing :=
    m_OldHKPausingKey :=
    m_ForceReset :=

    Init()
    {
        this.m_OldAllowSapiKeyPausing := -1
        this.m_OldSapiPausingKey := ""
        this.m_OldHKAllowKeyPausing := -1
        this.m_OldHKPausingKey := ""
        this.m_ForceReset := false
        EventManager.AddHandler(GlobalEventHandler)
    }
    ForceReset()
    {
        this.m_ForceReset := true
    }
    SetupHotKey(KeyName, ONOFF)
    {
        if(KeyName == "") 
            return
        Debug.WriteStackPushPop("GlobalEventHandler.SetupHotKey() " . KeyName . " " . ONOFF,Debug.ErrLevelCore)
        Try {
            Hotkey, %KeyName%, GlobalHotKeyHandler, %ONOFF%
        }
        catch e
        {
            Debug.WriteStackPop("Failed to register Global Hot Key " . KeyName, Debug.ErrCodingInfo)
        }
    }
    
    
    ;event manager notification
    OnProcessActivate(extra_data)
    {
        
    }
    ;event manager notification
    OnProcessDeactivate(extra_data)
    {
        
        
    }
    ;event manager notification
    OnItemActivate(extra_data)
    {
        
    }
    ;event manager notification
    OnItemDeactivate(extra_data)
    {
        
        
        
    }
    ;event manager notification
    OnTimer()
    {
        ;Called every n millisecs by the singleton EventManager Timer
        if(this.m_OldAllowSapiKeyPausing != gAllowSapiKeyPausing || this.m_OldSapiPausingKey != gSapiPausingKey || this.m_ForceReset)
        {
            this.SetupHotKey(this.m_OldSapiPausingKey, "OFF")
            this.m_OldAllowSapiKeyPausing := gAllowSapiKeyPausing
            this.m_OldSapiPausingKey := gSapiPausingKey
            if(this.m_OldAllowSapiKeyPausing)
            {
                this.SetupHotKey(this.m_OldSapiPausingKey, "ON")
            }
        }
        if(this.m_OldHKAllowKeyPausing != gHKAllowKeyPausing || this.m_OldHKPausingKey != gHKPausingKey || this.m_ForceReset)
        {
            this.SetupHotKey(this.m_OldHKPausingKey, "OFF")
            this.m_OldHKAllowKeyPausing := gHKAllowKeyPausing
            this.m_OldHKPausingKey := gHKPausingKey
            if(this.m_OldHKAllowKeyPausing)
            {
                this.SetupHotKey(this.m_OldHKPausingKey, "ON")
            }
        }
        OldHold := gSapiHold
        gSapiHold := false
        if(gAllowSapiHoldKey)
        {
            checktype := 0
            if(gSapiHoldOnDownOrOnUp == 0)
            {
                checktype := 1
            }
            if(GetKeyState(gSapiHoldKey,"P") == checktype)
            {
                gSapiHold := true
            }

            ;;;Debug.WriteStackPushPop(gSapiHold . " is " . gSapiHold)
            if(OldHold != gSapiHold)
            {
                if(gSapiHold)
                {
                    Debug.WriteStackPop("Voice Recognition is Suspended", Debug.ErrLevelUsefulInfo)
                }
                else
                {
                    Debug.WriteStackPop("Voice Recognition is Resumed", Debug.ErrLevelUsefulInfo)
                }
            }

        }
        this.m_ForceReset := false
    }
}

GlobalHotKeyHandler()
{
    
    zeHotKey := A_ThisHotkey
    extra_data := TVHelper.ToExtraData(TVHelper.GetSelectedItem())
    text := extra_data.GetItemText()
    ;MyOutputDebugAlways("Mine: " .  ProcessMonitor.IsWindowMine() . " Module Handle " . text)
    if(ProcessMonitor.IsWindowMine() || (text != "Applications and Games" && text != "ApplicationFrameHost.exe" ))
    {
        ;MyOutputDebug("DoingIt")
        if(zeHotKey == gHKPausingKey)
        {
            gHKDisabled := !gHKDisabled
            if(gHKDisabled)
            {
                VoiceAgent.Say("Hot Keys are Disabled")
                Debug.WriteStackPop("Hot Keys are Disabled", Debug.ErrLevelUsefulInfo)
                HotKeySystem.OnItemDeactivate(0)
                
            }
            else
            {
                VoiceAgent.Say("Hot Keys are Enabled")
                Debug.WriteStackPop("Hot Keys are Enabled", Debug.ErrLevelUsefulInfo)
                HotKeySystem.OnItemActivate(0)
            }
            if(gHKDisabled)
            {
                HotKeySystem.OnProcessDeactivate(0)
            }
            Else
            {
                
                HotKeySystem.OnProcessActivate(HotKeySystem.m_old_process_extra_data)
                HotKeySystem.OnItemActivate(HotKeySystem.m_old_extra_data)

            }
        }
        else if(zeHotKey == gSapiPausingKey)
        {
            gSAPIPaused := !gSAPIPaused
            if(gSAPIPaused)
            {
                VoiceAgent.Say("Voice Recognition is Enabled")
                Debug.WriteStackPop("Voice Recognition is Enabled", Debug.ErrLevelUsefulInfo)
            }
            else
            {
                VoiceAgent.Say("Voice Recognition is Disabled")
                Debug.WriteStackPop("Voice Recognition is Disabled", Debug.ErrLevelUsefulInfo)
            }
        }
    }
    send, {%zeHotKey%} ;pass through
    
}