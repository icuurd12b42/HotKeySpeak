;Main Treeview Helper Functions
class MTVDOMHLP
{
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
    recurse_filter(DOMParentID, FilterTypes:=0, GroupFilterTypes:=0, callbackClass:=0, Arr:=0)
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
        if(Arr==0) ;root call, set the gui context
        {
            Ret := []
        }
        Else
        {
            Ret := arr
        }

        dom_element:=DOMParentID.firstChild
		
        Debug.WriteStackPush("while(dom_element) Start",Debug.ErrLevelCore)
		while(dom_element)
		{
            TheType := TV_TYPES.None
            if(dom_element.attributes.length)
            {
                TheType := dom_element.getAttribute("type") + 0
                debug.WriteStack(dom_element.getAttribute("text"),Debug.ErrLevelCore)
            }
            debug.WriteStack(dom_element.nodeName,Debug.ErrLevelCore)
            
            pushed := false
            if(!FilterTypes)
            {
                pushed := true
            }
            else if(MTVDOMHLP.IsValInArr(TheType,FilterTypes))
            {
                pushed := true
            }
            if(pushed)
            {
                Debug.WriteStack("Pushed",Debug.ErrLevelCore)
                if( callbackClass )
                {
                    callbackClass.OnAdd(dom_element,TheType) 
                }
                else
                {
                    Ret.push(dom_element)
                }
                
            }
            HasChild := dom_element.hasChildNodes
            Recurse := False
            if(!GroupFilterTypes && HasChild)
            {
                Recurse := True
            }
            else if(MTVDOMHLP.IsValInArr(TheType,GroupFilterTypes) && HasChild)
            {
                Recurse := True
            }
            if(Recurse)
            {
                Debug.WriteStackPush("Children Start",Debug.ErrLevelCore)
                if( callbackClass )
                {
                    callbackClass.OnRecurse(dom_element,TheType) 
                }
                MTVDOMHLP.recurse_filter(dom_element, FilterTypes, GroupFilterTypes, callbackClass, Ret)
                if( callbackClass )
                {
                    callbackClass.OnDecurse(dom_element,TheType)
                }
                Debug.WriteStackPop("Children End",Debug.ErrLevelCore)
            }
            dom_element := dom_element.nextSibling
            
		}
        Debug.WriteStackPop("While End",Debug.ErrLevelCore)
        Debug.WriteStackPop("recurse_filter End",Debug.ErrLevelCore)
        if(Arr==0) ;root call
        {
            return ret
        }
    }
   
}
