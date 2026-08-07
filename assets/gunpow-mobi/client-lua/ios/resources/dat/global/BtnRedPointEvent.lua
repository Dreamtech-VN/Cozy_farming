--BtnRedPointEvent.lua
--@brief    按钮红点事件处理lua
--@date     2015/02/28
--@note     wwd

BtnRedPointEvent = {}

function BtnRedPointEvent:New(  )
	local newObj = setmetatable( {}, { __index = BtnRedPointEvent } )
	newObj.EventObjs = {}
	return newObj 
end

--@brief 注册监听事件
--@params  type 类型 
--@params  className 类名
--@params  wndBottomBarObj WndBottomBar的lua对象 
--@params  Direction 按钮方向   
function BtnRedPointEvent:regListener( typeName,className,wndBottomBarObj,Direction)
	self.EventObjs[className] = self.EventObjs[className] or {}
	local event = self.EventObjs[className] 
	event[typeName] = event[typeName] or {}
	local m_tObj = event[typeName]
	m_tObj.obj = wndBottomBarObj
	m_tObj.direction = Direction
	m_tObj.type = typeName
	m_tObj.name = className
end

--@brief 注册监听右边栏事件
function BtnRedPointEvent:regListenerBottomBar(className,wndBottomBarObj,Direction)
    WZLog("BtnRedPointEvent:regListenerBottomBar", tostring(className), tostring(wndBottomBarObj), tostring(Direction))
    GlobalGame:getBtnRedPointEvent():regListener("btnTask",className,wndBottomBarObj,Direction)
    GlobalGame:getBtnRedPointEvent():regListener("btnBag",className,wndBottomBarObj,Direction)
    GlobalGame:getBtnRedPointEvent():regListener("btnItem",className,wndBottomBarObj,Direction)
    GlobalGame:getBtnRedPointEvent():regListener("btnPet",className,wndBottomBarObj,Direction)
    GlobalGame:getBtnRedPointEvent():regListener("btnChat",className,wndBottomBarObj,Direction)
    GlobalGame:getBtnRedPointEvent():regListener("btnMount",className,wndBottomBarObj,Direction)

    GlobalGame:getBtnRedPointEvent():regListener("btnPractice_ExtendUp",className,wndBottomBarObj,Direction)

    GlobalGame:getBtnRedPointEvent():regListener("btnBless_ExtendUp",className,wndBottomBarObj,Direction)

    GlobalGame:getBtnRedPointEvent():regListener("btnCard_ExtendUp",className,wndBottomBarObj,Direction)

    GlobalGame:getBtnRedPointEvent():regListener("btnFriend",className,wndBottomBarObj,Direction)

    GlobalGame:getBtnRedPointEvent():regListener("btnRune",className,wndBottomBarObj,Direction)

    GlobalGame:getBtnRedPointEvent():regListener("btnFootMark",className,wndBottomBarObj,Direction)
end

--@brief 移除监听事件
--@params type 类型
function BtnRedPointEvent:unregListener(typeName,className)
	WZLog("BtnRedPointEvent:unregListener ====== ")
	local event = self.EventObjs[className] 
	if event == nil then return end
	event[typeName] = nil 
end

--@brief 分发监听事件
--@note  右侧下拉条按钮无需传参
function BtnRedPointEvent:dispatcher(typeName,bState)
	WZLog("BtnRedPointEvent:dispatcher0", tostring(typeName), tostring(bState))
	--if typeName~=nil then 
	--local event = self.EventObjs[typeName]
	if typeName == nil then 
		--WZLog("BtnRedPointEvent:dispatcher1", Serialize(self.EventObjs))
		for i,v in pairs (self.EventObjs) do
			for k,j in pairs (v) do
				if j.direction ~= nil then 
					WZLog("BtnRedPointEvent:dispatcher 1====== "..j.direction,i,k)
					WZLog("BtnRedPointEvent:dispatcher 2====== "..j.type,i,k)
					WZLog("BtnRedPointEvent:dispatcher 3====== "..j.name,i,k)
					if j.obj == nil or j.obj.m_root == nil then 
						WZLog("j.obj.m_root is nil ")
						break
					end 
					CacheCenter:updateRedPoint(j.direction,j.obj.m_root,j.type,6)
				end
			end
		end 
	elseif typeName == "Sign" or typeName == "GameActivity" or typeName == "WishWell" then
		local m_tTabInfo = self.EventObjs["WndOwnCity"]
		if m_tTabInfo == nil then 
			WZLog("BtnRedPointEvent:dispatcher m_tTabInfo is nil")
			return 
		end 
		local m_tData = m_tTabInfo[typeName]
		if m_tData == nil then 
			WZLog("BtnRedPointEvent:dispatcher m_tData is nil")
			return 
		end

        local bOpenState
        if typeName == "WishWell" then
            bOpenState = bState[2]
            bState = bState[1]
        end
		if bState then 
			if not m_tData.obj:getChildByTag(89) then
            	local spr_redPoint =  CCSprite:create("ui/common/common_icon_xiaodianzhui.png")
           	 	m_tData.obj:addChild(spr_redPoint,5,89)
            	spr_redPoint:setPosition(ccp(69,69))
       		end
		else 
			if m_tData.obj and m_tData.obj:getChildByTag(89) then
    			m_tData.obj:removeChildByTag(89,true)
    		end
		end

        if typeName == "WishWell" then
            WndOwnCity:updateWishWell(bOpenState)
        end
	end 
end
