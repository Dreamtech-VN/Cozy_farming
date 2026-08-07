--EventDispatcher.lua
--@brief    事件处理lua
--@date     2015/02/28
--@note     xxxx
EventDispatcher = {}
 
function EventDispatcher:New( )    
    local NewObj = setmetatable( {}, { __index = EventDispatcher } )
    -- 对象成员初始化
    NewObj.mEventTable = {}
    
    return NewObj
end
 
-- 添加
function EventDispatcher:Add(EventName, Func, Object, UserData )
 
    self.mEventTable[ EventName ] = self.mEventTable[ EventName ] or {}
    
    local Event = self.mEventTable[ EventName ]
    
    if not Object then
        Object = "_StaticFunc"
    end
    
    Event[Object] = Event[Object] or {}
    local ObjectEvent = Event[Object]
 
    ObjectEvent[Func] = UserData or true
    
end
 
-- 派发
function EventDispatcher:Dispatch(EventName, ... )
 
    --assert( EventName )
    
    local Event = self.mEventTable[ EventName ]
    if not Event then
        return
    end
    
    for Object,ObjectFunc in pairs( Event ) do
        
        if Object == "_StaticFunc" then
                
            for Func, UserData in pairs( ObjectFunc ) do
                self:PreInvoke( EventName, Func, nil, UserData, ... )    
            end
            
        else
        
            for Func, UserData in pairs( ObjectFunc ) do
                self:PreInvoke( EventName, Func, Object, UserData, ... )
            end
        
        end
 
    end
 
end

function EventDispatcher:PreInvoke( EventName, Func, Object, UserData, ... )
    if Object then
        Func( Object, ... )
    else
        Func( EventName, ... )
    end
 
end
 
-- 回调是否存在
function EventDispatcher:Exist(EventName )
    --assert( EventName )
    local Event = self.mEventTable[ EventName ]
    
    if not Event then
        return false
    end
    
    -- 需要遍历下map, 可能有事件名存在, 但是没有任何回调的
    for Object,ObjectFunc in pairs( Event ) do
    
        for Func, _ in pairs( ObjectFunc ) do
            -- 居然有一个
            return true
        end
    
    end
    
    
    return false
    
end
 
-- 清除
function EventDispatcher:Remove(EventName, Func, Object )
    --assert( Func )
    --WZLog("EventDispatcher:Remove",EventName)
    local Event = self.mEventTable[ EventName ]
    
    if not Event then
        return
    end
    
    if not Object then
        Object = "_StaticFunc"
    end
    
    
    local ObjectEvent = Event[Object]
    --WZLog("EventDispatcher:Remove II",self:Exist(EventName))
    if not ObjectEvent then
        return
    end
    
    ObjectEvent[Func] = nil
    --WZLog("EventDispatcher:Remove IV",self:Exist(EventName))
        
end
 
-- 清除对象的所有回调
function EventDispatcher:RemoveObjectAllFunc(EventName, Object )
    --assert( Object )
    --全部清理
    if not EventName then
        for key,event in pairs(self.mEventTable) do
            if Event then
                for Object,ObjectFunc in pairs( Event ) do
                    ObjectFunc = nil
                end
            end
            Event = nil
        end

        self.mEventTable = nil

        return
    end
    
    --单个清理
    local Event = self.mEventTable[ EventName ]
    
    if not Event then
        return
    end
    
    Event[Object] = nil
 
end
