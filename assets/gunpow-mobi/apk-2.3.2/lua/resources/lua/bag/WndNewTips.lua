--WndNewTips.lua
--@brief	WndNewTips的UI模块
--@date		2020/12/08
--@author	hyx
--@note		新版tips


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndNewTips:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndNewTips:onExit(element)
	self:_unInit()
end
function WndNewTips:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function WndNewTips:actionCallback()
	
end
--[[
element:一般传self.m_root
btnElement: 按钮的element
txtTips:说明
]]
function WndNewTips:showInterface(element, btnElement, txtTips)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tips = WndNewTips:createElement()
	if tips ~= nil then
	    element:addChild(tips)
	    self:setData(btnElement, txtTips)
	end
end
function WndNewTips:setData(btnElement, txtTips)
	txtTips = txtTips or ""
	local txtDesTips = GetElement(self.m_root,"txtDesTips",WZUILabelTTF)
	txtDesTips:setText(txtTips)
	txtDesTips:setUseAbsCoordinate(true)
	

	local tip_container = GetElement(self.m_root,"tip_container",WZUIContainer)
	local container_width = tip_container:getContentSize().width
	txtDesTips:setDimensions(GlobalMethod:CCSize(container_width - 20))

	local width = txtDesTips:getContentSize().width
	local height = txtDesTips:getContentSize().height + 20

	tip_container:setUseAbsCoordinate(true)
	tip_container:setAbsContentSize(GlobalMethod:CCSize(container_width,height))
	tip_container:updateRelativeSize()

	local ptA = btnElement:convertToWorldSpace(GlobalMethod:ccp(0,0))
	if height > ptA.y then
		ptA.y = height
	end
	if (ptA.x+width) > 1136 then
		ptA.x = ptA.x - tip_container:getContentSize().width
	end
	tip_container:setAbsPosition(GlobalMethod:ccp(ptA.x, ptA.y))
	txtDesTips:setAbsPosition(GlobalMethod:ccp(10, height-10))
end
function WndNewTips:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root then
		self.m_root:removeFromParentAndCleanup(true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
