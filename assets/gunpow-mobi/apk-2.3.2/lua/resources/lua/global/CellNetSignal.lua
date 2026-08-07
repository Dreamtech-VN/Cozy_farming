--CellNetSignal.lua
--@brief	CellNetSignal的UI模块
--@date		2016/04/20
--@author	Tianxiang_Xu
--@note		网络延迟信号


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNetSignal:onEnter(element)
	self.m_root = element
    self.m_root:enableSchedule("setData", 1)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNetSignal:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
end

--@brief	点击信号显示tips
function CellNetSignal:onNet(element)
	WZLog("CellNetSignal:onNet", self.m_nIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --local elem = WZUIElement:luaTo(element:getParent())
    -- if elem then
    --     while WZUIWindow:luaTo(elem) == nil do
    --         if elem:getParent() == nil then break end
    --         elem = WZUIElement:luaTo(elem:getParent())
    --         if not elem then break end
    --     end
    --     if elem then
    --         local tParent = elem:getLuaObjectIndex()

    --         if tParent and tParent.m_root == WndOwnCity.m_root then
    --             WndItemInfo:showInfo(element,self.m_root,3,self.tip,false,ccp(60,-20))
    --         else
    --             WndItemInfo:showInfo(element,self.m_root,3,self.tip,false,ccp(80,-20))
    --         end
    --     else
    --         WndItemInfo:showInfo(element,self.m_root,3,self.tip,false,ccp(80,-20))
    --     end
    -- else
        WndItemInfo:showInfo(element,self.m_root,3,self.tip,false,ccp(80,-20))
    --end

    -- if self.m_nIndex == 1 then
	   -- WndItemInfo:showInfo(element,self.m_root,3,self.tip,false,ccp(-80,-20))
    -- else
    --    WndItemInfo:showInfo(element,self.m_root,3,self.tip,false,ccp(80,-20))
    -- end
end

--@brief    更新信息
--@param    nDelayTime： 网络延迟时间
function CellNetSignal:_update(nDelayTime)
    -- body
    if self.m_root == nil then return end

    
    -- --ios审核不显示12+防沉迷图片和wifi图标
    -- if WZUISystem:getInstance():getPlatformInfo() == 1 then return end

    local sSignalFile = "ui/common/common_icon_tpzsb4.png"
    local sSignalFile = "ui/common/common_wifi_01.png"
	self.tip = LocalStrings.NETTIP1
    if nDelayTime > 100 and nDelayTime <= 500 then
        sSignalFile = "ui/common/common_wifi_02.png"
		self.tip = LocalStrings.NETTIP2
    elseif nDelayTime > 500 then
        sSignalFile = "ui/common/common_wifi_03.png"
		self.tip = LocalStrings.NETTIP3
    end

    local imgSignal = GetElement(self.m_root, "imgSignal_CellNetSignal", WZUIImage)
    imgSignal:setFile(sSignalFile)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
