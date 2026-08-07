--WndGameRoleSound.lua
--@brief	WndGameRoleSound的UI模块
--@date		2016/06/24
--@author	zhangming
--@note		人物声音切换


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGameRoleSound:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGameRoleSound:onExit(element)
	self:_unInit()
end

--@brief 关闭
function WndGameRoleSound:onBtnClose(element)
	WZLog("WndGameRoleSound:onBtnClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 选择语言的判断
function WndGameRoleSound:onChoiceSound(element)
	WZLog("WndGameRoleSound:onChoiceLan")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	local data = WZDataFile:getInstance():getUserData()
	if data then		
		data:setStringValue("SoundData", "soundType", ""..tag)
		data:flush()
		WndSetting:initRoleSound(tag)
		WindowManager:removeWindow(self.m_root, self, true)
	end
    GlobalGame.g_nRoleSound = tonumber(tag)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
------------------------------------语言适配Begin-------------------------------------------
function WndGameRoleSound:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtSound_WndGameRoleSound",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(200,0))
end
-----------------------------------语言适配End-------------------------------------------