Class EventManager
{
    static m_HookedHandlers:=
    static m_current_process_extra_data :=
    static m_current_item_extra_data :=
    Init()
    {
        EventManager.m_HookedHandlers := []
        EventManager.m_current_process_extra_data := 0
        EventManager.m_current_item_extra_data := 0
        SetTimer, EventManager_OnTimer, %gUpdateTimer%
    }
    AddHandler(Handler)
    {
        EventManager.m_HookedHandlers.push(Handler)
    }
    OnTimer()
    {
        if(gExit)
        {
            return
        }
        for each, handler in EventManager.m_HookedHandlers
        {
            handler.OnTimer()
        }
        
    }
    SetActiveData(extra_data)
    {
        if(!gReady)
        {
            return
        }
        type := extra_data.GetType()
        if(type == TV_TYPES.EXE)
        {
            EventManager.SetActiveProcess(extra_data)
        }
        Else if(type == TV_TYPES.COMMAND || type == TV_TYPES.CONTEXT || type == TV_TYPES.WINDOWCONTEXT  )
        {
            EventManager.SetActiveItem(extra_data)
        }
        ;Else
        ;{
        ;    EventManager.SetActiveProcess(0)
        ;    EventManager.SetActiveItem(0)
        ;}
    }
    SetActiveProcess(extra_data)
    {
        Debug.WriteStackPush("SetActiveProcess() Start",Debug.ErrLevelCore)
        if(gExit)
        {
            return
        }
        for each, handler in EventManager.m_HookedHandlers
        {
            handler.OnProcessDeactivate(EventManager.m_current_process_extra_data)
        }
        
        EventManager.m_current_process_extra_data := extra_data
        ;if(!ProcessMonitor.IsWindowMine() && !gEditing)
        {
        for each, handler in EventManager.m_HookedHandlers
        {
            handler.OnProcessActivate(EventManager.m_current_process_extra_data)
        }
        }
        Debug.WriteStackPop("SetActiveProcess() End",Debug.ErrLevelCore)
    }
    SetActiveItem(extra_data)
    {
        Debug.WriteStackPush("SetActiveItem() Start",Debug.ErrLevelCore)
        if(gExit)
        {
            return
        }
        for each, handler in EventManager.m_HookedHandlers
        {
            handler.OnItemDeactivate(EventManager.m_current_item_extra_data)
        }
        
        EventManager.m_current_item_extra_data := extra_data
        for each, handler in EventManager.m_HookedHandlers
        {
            handler.OnItemActivate(EventManager.m_current_item_extra_data)
        }
        Debug.WriteStackPop("SetActiveItem() End",Debug.ErrLevelCore)
    }
}

EventManager_OnTimer()
{
    EventManager.OnTimer()
}