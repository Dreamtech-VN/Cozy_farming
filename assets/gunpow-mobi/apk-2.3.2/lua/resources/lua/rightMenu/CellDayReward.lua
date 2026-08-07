--CellDayReward.lua
--@brief	CellDayReward的UI模块
--@date		2017/05/25
--@author	 
--@note		登录奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDayReward:onEnter(element)
	self.m_root = element
	self:uiInit()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDayReward:onExit(element)
	self:_unInit()
end

--显示UI
function CellDayReward:uiInit()
	WZLog("CellDayReward:uiInit")
	local GetElement = GetElement
	local LocalStrings = LocalStrings
	local txtDay = GetElement(self.m_root,"txtDay_CellDayReward",WZUILabelTTF)
	txtDay:setText(string.format(LocalStrings.SingInDAYS,self.m_nIndex))
	local imgReward = GetElement(self.m_root,"imgReward_CellDayReward",WZUIImage)
	local itemInfo = GDatatab_item["id_" ..self.m_nRewardItemId ]
	imgReward:setFile(itemInfo.icon)
	self:updateUI(self.m_nGetStats)
	local txtItemName = GetElement(self.m_root,"txtItemName_CellDayReward",WZUILabelTTF)
	txtItemName:setText(itemInfo.name)
	local conLock = GetElement(self.m_root,"conLock_CellDayReward",WZUIContainer)
	
end


function CellDayReward:onClickGet(element)
	WZLog("CellDayReward:onClickGet")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nGetStats == -1 or self.m_nGetStats == 1 then
		WndItemInfo:onCloseClick()
		
		tData = {
            id = self.m_nRewardItemId,
            lastNum = self.m_nRewardCount,
            lastTime = 1,
            isUse = false,
            data = "",
            playerItemId = -1,
            basicInfo = GetItemLocalData(self.m_nRewardItemId)
        }
		WndItemInfo:showInfo(self.m_root,WndNewActivity.m_root,1,tData,false)
	else
		self.m_callbackFun(self.m_callbackLua,self.m_nActivityId,self.m_nRewardid,self)
	end
	
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
