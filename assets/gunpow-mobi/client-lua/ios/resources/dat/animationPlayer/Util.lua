
local function splitStr(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t, i = {}, 1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

local setmetatableindex_
setmetatableindex_ = function(t, index)
    if type(t) == "userdata" then
        local peer = tolua.getpeer(t)
        if not peer then
            peer = {}
            tolua.setpeer(t, peer)
        end
        setmetatableindex_(peer, index)
    else
        local mt = getmetatable(t)
        if not mt then mt = {} end
        if not mt.__index then
            mt.__index = index
            setmetatable(t, mt)
        elseif mt.__index ~= index then
            setmetatableindex_(mt, index)
        end
    end
end
setmetatableindex = setmetatableindex_

function luaClass(classname, super)
    local cls = {__cname = classname}
    local superType = type(super) 
    if superType == "function" then 
        cls.__create = super
    elseif superType == "table" then  
		cls.super = super
    end

    cls.__index = cls
    setmetatable(cls, {__index = cls.super})
    if not cls.ctor then
        --默认构造函数
        cls.ctor = function() end
    end
    cls.new = function(...)
        local instance
        if cls.__create then
            instance = cls.__create(...)
        else
            instance = {}
        end
        setmetatableindex(instance, cls)
        instance.class = cls
        instance:ctor(...)
        return instance
    end
    cls.create = function(_, ...)
        return cls.new(...)
    end
    return cls
end


rawset(_G, "luaClass", luaClass)
rawset(_G, "splitStr", splitStr)