--WndHoraryRule.lua
--@brief	WndHoraryRule的UI模块
--@date		2021/07/21
--@author	hyx
--@note		占卜卦象规则


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHoraryRule:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHoraryRule:onExit(element)
	self:_unInit()
end
function WndHoraryRule:showInterface()
	local wndRule = WndHoraryRule:createElement()
	if wndRule ~= nil then
	    WindowManager:addWindow(wndRule,WndHoraryRule,nil,false)
	end
end

function WndHoraryRule:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
	if IsIphoneX() then
		self.m_root:setRelativePosition(ccp(0.05,0.45))
	end
end
function WndHoraryRule:actionCallback()
	local ruleFreeList = GetElement(self.m_root,"ruleFreeList",WZUIFreeListContainer)
	ruleFreeList:removeAll()
	for i = 1, 6 do
		local element, tLuaObj = HoraryRuleItem:createElement()
		ruleFreeList:pushBack(WZUIContainer:luaTo(element))
		ruleFreeList:getMoveElement():setPositionY(ruleFreeList:getMinPosition().y)
		tLuaObj:setRuleData(i)
	end
end

function WndHoraryRule:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
