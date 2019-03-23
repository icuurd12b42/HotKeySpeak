


class HKS
{
    Debug {
        get {
            return Debug
        }
    }
    Process {
        get {
            return ProcessMonitor
        }
    }
    Resource {
        get {
            return Resource
        }
    }
    VoiceAgent {
        get {
            return VoiceAgent
        }
    }
    Recognition {
        get {
            return Recognition
        }
    }
    Action {
        get {
            return Action
        }
    }
    Mouse {
        get {
            return Mouse
        }
    }
    MouseUV {
        get {
            return MouseUV
        }
    }
    MouseDirect {
        get {
            Return MouseDirect
        }
    }
    WinAPI {
        get {
            return WinAPIWrapper
        }
    }
    ColorUV {
        get
        {
            return ColorUV
        }
    }
}

Class Resource
{
    Fetch(ResourceName:="")
    {
        Debug.WriteStackPushPop("Resource.Fetch() " . ResourceName,Debug.ErrLevelCore)
        ;Returns a file for the specified resource name from the tree TV_ITEM.FILERESOURCE
        ret := ""
        RootTVItem:=0
        ;Find the exe root
        root_extra_data := ProcessMonitor.m_root_exe_extra_data
        if(!root_extra_data || ProcessMonitor.IsWindowMine())
        {
            Debug.WriteStackPushPop("Resource.Fetch() Test Mode Detected",Debug.ErrLevelCore)
            RootTVItem := FindFirstItem.FindRootExe(MainUITreeview_Control_Instance.m_LastItemSelected)
            if(RootTVItem)
            {
                root_extra_data := TVHelper.ToExtraData(RootTVItem)
            }
        }
        Else
        {
            RootTVItem := root_extra_data.GetTreeviewItemIndex()
        }
        if(RootTVItem)
        {
            ;Find the resource type
            TVItem := FindFirstItem.FindMatchingResourceName(ResourceName,RootTVItem)
            if(TVItem)
            {
                ;Item data
                extra_data := TVHelper.ToExtraData(TVItem)
                file:=""
                if(extra_data)
                {
                    Try {
                        ;Create a folder for the files for that exe
                        path:= A_MyDocuments . "\HotKeySpeak\temp\ProgramData\" . root_extra_data.GetExeName()
                        FileCreateDir, %path%
                        
                        file := path . "\" . ResourceName
                        Debug.WriteStackPushPop("Resource.Fetch() TargetFile: " . file,Debug.ErrLevelCore)
                        if(FileExist(file))
                        {
                            ret := File ;if fail to delete return existing anyway
                            FileDelete %file%
                            
                        }
                        ;Create the file off the items base64 data
                        Base64Data := extra_data.GetBase64Code()
                        
                        Bytes := Base64Dec( BIN, Base64Data )
                        
                        Debug.WriteStackPushPop("Resource.Fetch() Num Bytes: " . Bytes,Debug.ErrLevelCore)
                        VarZ_Save( BIN, Bytes, file )
                        
                        VarSetcapacity( Base64Data, 0 )
                        
                        VarSetcapacity( BIN, 0 )
                        
                        ;return the filename
                        ret := File
                    }
                    Catch e
                    {
                        Debug.WriteStackPushPop("Exception Fetching File " . file, Debug.ErrLevelCoreErrors)
                    }
                }
            }
        }
        if(ret == "")
        {
            Debug.WriteStackPushPop("Resource.Fetch() Failed", Debug.ErrLevelCoreErrors)
        }
        return, ret
        
    }
}

;can run any command, context and window context code but not root exe code
Class Action
{
    Activate(ActionName)
    {
        Debug.WriteStackPushPop("Action.Activate() " . ActionName,Debug.ErrLevelCore)
        ;Find the specified action and runs it
        ret := ""
        RootTVItem:=0
        ;Find the exe root
        root_extra_data := ProcessMonitor.m_root_exe_extra_data
        if(!root_extra_data || ProcessMonitor.IsWindowMine())
        {
            Debug.WriteStackPushPop("Action.Activate() Test Mode Detected",Debug.ErrLevelCore)
            RootTVItem := FindFirstItem.FindRootExe(MainUITreeview_Control_Instance.m_LastItemSelected)
            if(RootTVItem)
            {
                root_extra_data := TVHelper.ToExtraData(RootTVItem)
            }
        }
        Else
        {
            RootTVItem := root_extra_data.GetTreeviewItemIndex()
        }
        if(RootTVItem)
        {
            ;Find the resource type
            TVHelper.IgnoreDisabled(true)
            TVItem := FindFirstItem.FindMatchingCommandOrCommandContextName(ActionName,RootTVItem)
            if(TVItem)
            {
                ;Item data
                extra_data := TVHelper.ToExtraData(TVItem)
                EventManager.SetActiveItem(extra_data)
                
            }
        }
    }
    Run(ActionName)
    {
        Debug.WriteStackPushPop("Action.Run() " . ActionName,Debug.ErrLevelCore)
        ;Find the specified action and runs it
        ret := ""
        RootTVItem:=0
        ;Find the exe root
        root_extra_data := ProcessMonitor.m_root_exe_extra_data
        if(!root_extra_data || ProcessMonitor.IsWindowMine())
        {
            Debug.WriteStackPushPop("Action.Run() Test Mode Detected",Debug.ErrLevelCore)
            RootTVItem := FindFirstItem.FindRootExe(MainUITreeview_Control_Instance.m_LastItemSelected)
            if(RootTVItem)
            {
                root_extra_data := TVHelper.ToExtraData(RootTVItem)
            }
        }
        Else
        {
            RootTVItem := root_extra_data.GetTreeviewItemIndex()
        }
        if(RootTVItem)
        {
            ;Find the resource type
            TVHelper.IgnoreDisabled(false)
            TVItem := FindFirstItem.FindMatchingContextName(ActionName,RootTVItem)
            if(TVItem)
            {
                ;Item data
                extra_data := TVHelper.ToExtraData(TVItem)
                file:=""
                if(extra_data)
                {
                    Try {
                        Code:=extra_data.GetCode()
                        if(code!="")
                        {
                            Runner:=root_extra_data.GetInterpreter()
                            Runner.Exec(Code)
                        }
                    }
                    Catch e
                    {
                        Debug.WriteStackPushPop("Exception Running Action " . ActionName, Debug.ErrLevelCoreErrors)
                    }
                }
            }
        }
    }
}

Class Mouse 
{
    m_OldCapture := 0
    UV {
        get
        {
            return MouseUV
        }
    }
    Pix {
        get
        {
            return MousePix
        }
    }
    Direct {
        get
        {
            return MouseDirect
        }
    }
    
    StopDetect()
    {
        Mouse.m_OldCapture := DllCall("GetCapture")
        DllCall("ReleaseCapture")
    }
    StartDetect()
    {
        DllCall("SetCapture", "UInt", Mouse.m_OldCapture) ; ProcessMonitor.GetActiveWindowhWnd())
    }

    cosIt(deg)
    {
        return, (cos(this.DegToRad(deg)))
    }
    sinIt(deg)
    {
        return, (-sin(this.DegToRad(deg)))
    }
    DegToRad(deg)
    {
        static pi := 3.14159265358979323846
        return, deg * pi / 180
    }

    MyMouseMove(x,y,speed,relative)
    {
        xx := x
        yy := y
        
        MouseGetPos, mX, mY
        if(relative!="")
        {
            xx+=mX 
            yy+=mY 

        }
        dx := mX-xx
        dy := mY-yy
        if(speed==0)
        {
            MouseMove, mX-dx, mY-dy, 0
            return
        }
        ct := speed
        dx/=ct
        dy/=ct
        loop, %ct%
        {
            sleep 16
            mX-=dx
            mY-=dy
            MouseMove, mX, mY, 0
        }
    }

    activeMonitorInfo( ByRef X, ByRef Y, ByRef Width,  ByRef  Height  )
    { ; retrieves the size of the monitor, the mouse is on
        
        
        MouseGetPos, mouseX , mouseY
        SysGet, monCount, MonitorCount
        Loop %monCount%
        { 	
            SysGet, curMon, Monitor, %a_index%
            if ( mouseX >= curMonLeft and mouseX <= curMonRight and mouseY >= curMonTop and mouseY <= curMonBottom )
                {
                    X      := curMonTop
                    y      := curMonLeft
                    Height := curMonBottom - curMonTop
                    Width  := curMonRight  - curMonLeft
                    
                    return
                }
        }
        
    }
}
Class MouseUV ; a mouse class that is uv bassed in context with the active process or the display
{
    MoveOnWindow(u,v,speed:=0,relative:="")
    {
        CoordMode, Mouse, Window
        hWnd := ProcessMonitor.GetActiveWindowhWnd()
        if(hWnd == 0 || IsIconic(hWnd))
        {
            ;MouseUV.MoveOnScreen(u,v,speed)
            return
        }
        WinGetPos, X, Y, Width, Height, ahk_id %hWnd%
        ; not needed, look at coord mod above
        ;mx := X + u * Width
        ;my := Y + v * Height
        mx := u * Width
        my := v * Height
        Mouse.MyMouseMove(mx,my,speed,relative)
    }
    MoveOnScreen(u,v,speed:=0,relative:="")
    {
        CoordMode, Mouse, Screen
        Mouse.activeMonitorInfo( X , Y ,  Width , Height   )
        mx := X + u * Width
        my := Y + v * Height
        Mouse.MyMouseMove(mx,my,speed,relative)
    }
    MoveInDirectionWindow(Degree, Distance, speed:=0)
    {
        u := Mouse.cosIt(Degree) * Distance
        v := Mouse.sinIt(Degree) * Distance
        MouseUV.MoveOnWindow(u,v,speed,"R")
    }
    MoveInDirectionScreen(Degree, Distance, speed:=0)
    {
        u := Mouse.cosIt(Degree) * Distance
        v := Mouse.sinIt(Degree) * Distance
        MouseUV.MoveOnScreen(u,v,speed,"R")
    }
}
Class ColorUV ; a color get class that is uv bassed in context with the active process or the display
{
    ColorOnWindow(u,v,Options:="")
    {
        CoordMode, Mouse, Window
        hWnd := ProcessMonitor.GetActiveWindowhWnd()
        if(hWnd == 0 || IsIconic(hWnd))
        {
            ;MouseUV.MoveOnScreen(u,v,speed)
            return 0x0
        }
        WinGetPos, X, Y, Width, Height, ahk_id %hWnd%
        ; not needed, look at coord mod above
        ;mx := X + u * Width
        ;my := Y + v * Height
        mx := u * Width
        my := v * Height
        return ColorUV.PixelGetColor(mx,my,Options)
    }
    ColorOnScreen(u,v,Options:="")
    {
        CoordMode, Mouse, Screen
        Mouse.activeMonitorInfo( X , Y ,  Width , Height   )
        mx := X + u * Width
        my := Y + v * Height
        return ColorUV.PixelGetColor(mx,my,Options)
    }
    PixelGetColor(X,Y,Options:="")
    {
        OutputVar := 0x0
        if(Options = "")
        {
            PixelGetColor, OutputVar, X, Y
        }
        else
        {
            PixelGetColor, OutputVar, X, Y , Options
        }
        return OutputVar
    }
    
}
Class MousePix ; a mouse class that is pixel bassed in context with the active process or the display
{
    MoveOnWindow(xx,yy,speed:=0,relative:="")
    {
        CoordMode, Mouse, Window
        hWnd := ProcessMonitor.GetActiveWindowhWnd()
        if(hWnd == 0 || IsIconic(hWnd))
        {
            ;MouseUV.MoveOnScreen(u,v,speed)
            return
        }
        WinGetPos, X, Y, Width, Height, ahk_id %hWnd%
        ; not needed, look at coord mod above
        ;mx := X + u * Width
        ;my := Y + v * Height
        mx := xx ; u * Width
        my := yy ; v * Height
        Mouse.MyMouseMove(mx,my,speed,relative)
    }
    MoveOnScreen(xx,yy,speed:=0,relative:="")
    {
        CoordMode, Mouse, Screen
        Mouse.activeMonitorInfo( X , Y ,  Width , Height   )
        mx := X + xx ;u * Width
        my := Y + yy ;v * Height
        Mouse.MyMouseMove(mx,my,speed,relative)
    }
    MoveInDirectionWindow(Degree, Distance, speed:=0)
    {
        xx := Mouse.cosIt(Degree) * Distance
        yy := Mouse.sinIt(Degree) * Distance
        MousePix.MoveOnWindow(xx,yy,speed,"R")
    }
    MoveInDirectionScreen(Degree, Distance, speed:=0)
    {
        xx := Mouse.cosIt(Degree) * Distance
        yy := Mouse.sinIt(Degree) * Distance
        MousePix.MoveOnScreen(xx,yy,speed,"R")
    }
}


Class MouseDirect 
{
    MoveByXYVector(xAmount,yAmount, numrepeat)
    {
        loop, %numrepeat%
        {
            DllCall("mouse_event", "UInt", 0x0001, "Int", xAmount, "Int", yAmount, "UInt", 0, "UPtr", 0)    ; MOUSEEVENTF_MOVE = 0x0001
            sleep 16
        }
    }
    MoveInDirection(angle, amount, numrepeat)
    {
        xAmount := Mouse.cosIt(angle) * amount
        yAmount := Mouse.sinIt(angle) * amount
        MouseDirect.MoveByXYVector(xAmount,yAmount, numrepeat)
    }
}