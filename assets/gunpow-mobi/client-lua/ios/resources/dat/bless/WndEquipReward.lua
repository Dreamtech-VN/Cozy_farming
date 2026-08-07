--WndEquipReward.lua
--@brief	WndEquipReward的UI模块
--@date		2017/11/09
--@author	qixiang
--@note		显示装备召唤奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndEquipReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndEquipReward:onExit(element)
	self:_unInit()
end



-------------------------------------公有方法模块End----------------------------------------




-------------------------------------私有方法模块Begin--------------------------------------

function WndEquipReward:onClickGet(element)
	-- body
	WZLog("WndEquipReward:onClickGet")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	WZLog("tag = ",tag)
	ProtocolProcessorWndEquipmentRaffle:send_EQUIP_ReceiveTenLotteryReward(tag)


end

function WndEquipReward:onCloseClick(element)
	-- body
	WZLog("WndEquipReward:onClickGet")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end



-------------------------------------私有方法模块End----------------------------------------
