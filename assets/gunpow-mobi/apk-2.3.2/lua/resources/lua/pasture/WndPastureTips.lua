--WndPastureTips.lua
--@brief	WndPastureTips的UI模块
--@date		2021/04/19
--@author	hyx
--@note		牧场Tips


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPastureTips:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPastureTips:onExit(element)
	self:_unInit()
end

function WndPastureTips:showInterface(id)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tips = WndPastureTips:createElement(id)
	if tips ~= nil then
	    WindowManager:addWindow(tips,WndPastureTips,nil,false)
	end
end

function WndPastureTips:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndPastureTips:actionCallback()
	self:initShow()
end

function WndPastureTips:initShow()
	if not self.m_tSkillId then return end
	
	local desc_con = GetElement(self.m_root,"desc_con",WZUIContainer)
	if self.m_sOtherVisible == true then
		desc_con:setVisible(false)
	else
		desc_con:setVisible(true)
	end

	local skillData = GDatatab_skill["id_" .. self.m_tSkillId]
	if skillData then
		GetElement(self.m_root,"txtDesc1",WZUILabelTTF):setText(skillData.tool_desc)
	end
	if skillData.upgrade_id ~= -1 then
		local conNext = GetElement(self.m_root,"conNext",WZUIContainer)
		if self.m_sOtherVisible == true then
			conNext:setVisible(false)
		else
			conNext:setVisible(true)
		end
		local nextData = GDatatab_skill["id_" .. skillData.upgrade_id]
		if nextData then
			GetElement(self.m_root,"txtDesc2",WZUILabelTTF):setText(nextData.tool_desc)
		end
	else
		GetElement(self.m_root,"txtMaxAtt",WZUILabelTTF):setVisible(true)
	end
end

function WndPastureTips:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
