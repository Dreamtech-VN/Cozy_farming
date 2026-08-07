--WndMountStoneQuick.lua
--@brief	WndMountStoneQuick的UI模块
--@date		2021/04/28
--@author	hyx
--@note		坐骑灵石快速选择


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMountStoneQuick:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMountStoneQuick:onExit(element)
	self:_unInit()
end
function WndMountStoneQuick:showInterface()
	local wndStongQuick = WndMountStoneQuick:createElement()
	if wndStongQuick ~= nil then
	    WindowManager:addWindow(wndStongQuick,WndMountStoneQuick,nil,false)
	end
end
function WndMountStoneQuick:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndMountStoneQuick:actionCallback()
	self:initShow()
end
function WndMountStoneQuick:initShow()
	for i=1,4 do
		local tab = {}
		local btnQuick = GetElement(self.m_root,"btnQuick"..i,WZUIButton)
		tab.imgSelect = GetElement(btnQuick,"imgSelect",WZUIImage)
		self.m_tQuickChooseItem[i] = tab
	end
	local data = WndMountStoneStong:getQuickStatus()
	for i,v in pairs(data) do
		if v then
			self.m_tQuickChooseItem[i].imgSelect:setVisible(true)
		end
	end
end

function WndMountStoneQuick:onBtnChoose(element)
	local tag = element:getTag()
	if tag == 1 then return end
	local data = WndMountStoneStong:getQuickStatus()
	if data[tag] == nil then
		data[tag] = true
		self.m_tQuickChooseItem[tag].imgSelect:setVisible(true)
	else
		data[tag] = nil
		self.m_tQuickChooseItem[tag].imgSelect:setVisible(false)
	end
	WndMountStoneStong:setQuickStatus(data)
end

function WndMountStoneQuick:onBtnConfirm( ... )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
function WndMountStoneQuick:onBtnCancel( ... )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndMountStoneStong:setQuickStatus({true})
	WindowManager:removeWindow(self.m_root, self, true)
end
function WndMountStoneQuick:onBtnClose( ... )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndMountStoneStong:setQuickStatus({true})
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
