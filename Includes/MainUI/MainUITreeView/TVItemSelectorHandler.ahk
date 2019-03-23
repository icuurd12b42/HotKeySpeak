class TVItemSelectorHandler
{
    static m_current_exe_tv_item :=
    static m_current_context_tv_item :=
    static m_current_tv_item :=
    static m_apps_root_tv_item := 
    Init(apps_root_item)
    {
        TVItemSelectorHandler.m_current_exe_tv_item := 0
        TVItemSelectorHandler.m_current_context_tv_item := 0
        TVItemSelectorHandler.m_apps_root_tv_item := MainUITreeview_Control_Instance.m_RootAppsItem ;apps_root_item
        TVItemSelectorHandler.m_current_exe_tv_item := apps_root_item
        EventManager.AddHandler(TVItemSelectorHandler)
    }
    ;event manager notification
    OnProcessActivate(extra_data)
    {
        Debug.WriteStackPushPop("TVItemSelectorHandler.OnProcessActivate()",Debug.ErrLevelCore)
        ;extra data is a exe item, can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
        
        if(extra_data)
        {
           TVItemSelectorHandler.m_current_exe_tv_item := extra_data.GetTreeviewItemIndex()
           TVItemSelectorHandler.m_current_tv_item := TVItemSelectorHandler.m_current_exe_tv_item
        }
        Else
        {
            TVItemSelectorHandler.m_current_tv_item := MainUITreeview_Control_Instance.m_RootAppsItem ;TVItemSelectorHandler.m_apps_root_tv_item
            TVItemSelectorHandler.m_current_exe_tv_item := TVItemSelectorHandler.m_current_tv_item
            
        }
        TVHelper.DisableDraw()
        TVHelper.SelectItem(TVItemSelectorHandler.m_current_tv_item)
        TVHelper.ExpandItem(TVItemSelectorHandler.m_current_tv_item)
    }
    ;event manager notification
    OnProcessDeactivate(extra_data)
    {

        Debug.WriteStackPushPop("TVItemSelectorHandler.OnProcessDeactivate()",Debug.ErrLevelCore)
        ;extra data is a exe item, can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
        ;if(extra_data)
        ;{
        ;   TVItemSelectorHandler.m_current_exe_tv_item := extra_data.GetTreeviewItemIndex()
        ;   TVItemSelectorHandler.m_current_tv_item := TVItemSelectorHandler.m_current_exe_tv_item
        ;}
        TVHelper.DisableDraw()
        TVHelper.CollapseToRoot(TVItemSelectorHandler.m_current_tv_item)
        ;TVHelper.DeselectItem(TVItemSelectorHandler.m_current_tv_item)
    }
    ;event manager notification
    OnItemActivate(extra_data)
    {

        Debug.WriteStackPushPop("TVItemSelectorHandler.OnItemActivate()",Debug.ErrLevelCore)
        ;extra data is a command, context or window context, can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
        if(extra_data)
        {
           TVItemSelectorHandler.m_current_context_tv_item := extra_data.GetTreeviewItemIndex()
           TVItemSelectorHandler.m_current_tv_item := TVItemSelectorHandler.m_current_context_tv_item
        }
        Else
        {
            TVItemSelectorHandler.m_current_tv_item := TVItemSelectorHandler.m_current_exe_tv_item
            TVItemSelectorHandler.m_current_context_tv_item := 0
            if(TVItemSelectorHandler.m_current_tv_item == 0)
            {
                TVItemSelectorHandler.m_current_tv_item := TVItemSelectorHandler.m_apps_root_tv_item
            }
        }

        TVHelper.DisableDraw()
        TVHelper.SelectItem(TVItemSelectorHandler.m_current_tv_item)
        TVHelper.ExpandItem(TVItemSelectorHandler.m_current_tv_item)
    }
    ;event manager notification
    OnItemDeactivate(extra_data)
    {

        Debug.WriteStackPushPop("TVItemSelectorHandler.OnItemDeactivate()",Debug.ErrLevelCore)
        ;extra data is a command, context or window context, , can be 0, can be the same as previoulsy activated one
        ;this class decides to be sure not to do things twice if same
        ;if(extra_data)
        ;{
        ;   TVItemSelectorHandler.m_current_context_tv_item := extra_data.GetTreeviewItemIndex()
        ;   TVItemSelectorHandler.m_current_tv_item := TVItemSelectorHandler.m_current_exe_tv_item
        ;}
        TVHelper.DisableDraw()
        TVHelper.DeselectItem(TVItemSelectorHandler.m_current_tv_item)
    }
    ;event manager notification
    OnTimer()
    {
        ;Called every n millisecs by the singleton EventManager Timer
    }
}