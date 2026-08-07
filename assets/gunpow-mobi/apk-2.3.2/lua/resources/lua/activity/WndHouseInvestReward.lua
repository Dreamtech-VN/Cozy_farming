--WndHouseInvestReward.lua
--@brief	WndHouseInvestReward的UI模块
--@date		2021/09/27
--@author	hyx
--@note		投资奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHouseInvestReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHouseInvestReward:onExit(element)
	self:_unInit()
end
function WndHouseInvestReward:showInterface()
	local wndInvestReward = WndHouseInvestReward:createElement()
	if wndInvestReward ~= nil then
	    WindowManager:addWindow(wndInvestReward,WndHouseInvestReward,nil,false)
	end
end
function WndHouseInvestReward:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndHouseInvestReward:actionCallback()
	local investFreeList = GetElement(self.m_root,"investFreeList",WZUIFreeListContainer)
	investFreeList:removeAll()
	for i = 1, 5 do
		local element, tLuaObj = InvestRewardItem:createElement()
		investFreeList:pushBack(WZUIContainer:luaTo(element))
		investFreeList:getMoveElement():setPositionY(investFreeList:getMinPosition().y)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
