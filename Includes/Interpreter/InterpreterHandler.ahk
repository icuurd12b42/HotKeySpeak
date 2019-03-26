Class InterpreterHandler
{
    m_root_exe_extra_data :=
    m_CurrentInterpreter := 
    Init()
    {
        Debug.WriteStackPush("InterpreterHandler Init Start",Debug.ErrLevelCore)
        InterpreterHandler.m_root_exe_extra_data := 0
        InterpreterHandler.m_CurrentInterpreter := 0
        EventManager.AddHandler(InterpreterHandler)
        Debug.WriteStackPop("InterpreterHandler Init End",Debug.ErrLevelCore)
    }
    ;event manager notification
    OnProcessActivate(extra_data)
    {
        Debug.WriteStackPushPop("InterpreterHandler.OnProcessActivate()",Debug.ErrLevelCore)
        ;extra data is a exe item, can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
        ;right now this class triggered this event but nonetheless re-grab this if 
        InterpreterHandler.m_root_exe_extra_data := extra_data
        if(InterpreterHandler.m_root_exe_extra_data)
        {
            InterpreterHandler.m_CurrentInterpreter := extra_data.GetInterpreter()
            InterpreterHandler.m_CurrentInterpreter.m_Timers :=[]
            InterpreterHandler.m_CurrentInterpreter.m_TimerAt :=0
            if(!ProcessMonitor.IsWindowMine())
            {
                code := extra_data.GetCode()
                if(code)
                {
                    Debug.WriteStackPushPop("InterpreterHandler.OnProcessActivate().RunCode",Debug.ErrLevelCore)
                    InterpreterHandler.m_CurrentInterpreter.Exec(code, TVHelper.GetSelectedItem())
                }
            }
            
        }
        ;clear the Main interpreter
        Interpreter.m_Timers :=[]
        Interpreter.m_TimerAt :=0
    }
    ;event manager notification
    OnProcessDeactivate(extra_data)
    {

        Debug.WriteStackPushPop("InterpreterHandler.OnProcessDeactivate()",Debug.ErrLevelCore)
        ;extra data is a exe item, can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
        ;right now this class triggered this event, still, nuke it untill we get the Activate
        if(InterpreterHandler.m_CurrentInterpreter)
        {
            InterpreterHandler.m_CurrentInterpreter.m_Timers :=[]
            InterpreterHandler.m_CurrentInterpreter.m_TimerAt :=0
        }
        ProcessMonitor.m_root_exe_extra_data := 0
        InterpreterHandler.m_CurrentInterpreter := 0
    }
    ;event manager notification
    OnItemActivate(extra_data)
    {

        Debug.WriteStackPushPop("InterpreterHandler.OnItemActivate()",Debug.ErrLevelCore)
        ;extra data is a command, context or window context, can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
        if(extra_data && InterpreterHandler.m_CurrentInterpreter)
        {
            type := extra_data.GetType()
            if(type == TV_TYPES.COMMAND || type == TV_TYPES.CONTEXT || type == TV_TYPES.WINDOWCONTEXT)
            {
                if(!ProcessMonitor.IsWindowMine())
                {
                    code := extra_data.GetCode()
                    if(code)
                    {
                        Debug.WriteStackPushPop("InterpreterHandler.OnItemActivate().RunCode",Debug.ErrLevelCore)
                        InterpreterHandler.m_CurrentInterpreter.Exec(code, TVHelper.GetSelectedItem())
                    }
                }
            }
        }
    }
    ;event manager notification
    OnItemDeactivate(extra_data)
    {
        ;extra data is a command, context or window context, , can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
    }
    ;event manager notification
    OnTimer()
    {
    }
}