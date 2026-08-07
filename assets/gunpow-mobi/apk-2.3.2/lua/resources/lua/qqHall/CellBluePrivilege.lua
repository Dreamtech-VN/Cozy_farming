--CellBluePrivilege.lua
--@brief	CellBluePrivilege的UI模块
--@date		2022/03/17
--@author	XTX
--@note		蓝钻特权-子活动界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellBluePrivilege:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellBluePrivilege:onExit(element)
	self:_unInit()
end

function CellBluePrivilege:showWindow()
	self:_update()
end

--@brief    点击Item时回调tips
function CellBluePrivilege:onClickItem(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root, WndBluePrivilege.m_root, 1, tData, false, nil, true)
end

--@brief 	新手礼包-点击领取按钮回调
function CellBluePrivilege:onGetNewGift(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = self.m_tRewardList[1]
	WZLog("CellBluePrivilege:onGetNewGift", tData.activityId)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(tData.activityId, 1, "")
end

--@brief 	蓝钻特权说明-点击跳转url
function CellBluePrivilege:onOpenUrl(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZPush:openURL("http://gamevip.qq.com/?ADTAG=VIP.WEB.DDD2")
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	显示相应的界面
function CellBluePrivilege:_update()
	if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_BULEPRIVILEGE_NEWGIFT then 
		GetElement(self.m_root, "conNewGift_CellBluePrivilege", WZUIContainer):setVisible(true)
		self:_showNewGift()
	elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_BULEPRIVILEGE_DAYGIFT then 
		GetElement(self.m_root, "conDayGift_CellBluePrivilege", WZUIContainer):setVisible(true)
		self:_showDayGift()
	elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_BULEPRIVILEGE_GROWGIFT then 
		GetElement(self.m_root, "conGrowGift_CellBluePrivilege", WZUIContainer):setVisible(true)
		self:_showGrowGift()
	elseif self.m_nActivityType == 999999 then 
		GetElement(self.m_root, "conBlueDesc_CellBluePrivilege", WZUIContainer):setVisible(true)
		local ftxtBlueDesc = GetElement(self.m_root, "ftxtBlueDesc_CellBluePrivilege", WZUIFreeTextBox)
		if ftxtBlueDesc then 
			ftxtBlueDesc:setShowText(LocalStrings.LZTQ_TEXT2)
		end
	end
end

--@brief 	新手礼包界面刷新
function CellBluePrivilege:_showNewGift()
	local tData = self.m_tRewardList[1]
	if tData == nil then return end 

	local tbNewGiftList = GetElement(self.m_root, "tbNewGiftList_CellBluePrivilege", WZUITableContainer)
	tbNewGiftList:cleanTable()
	for i = 1, #tData.rewardItemId do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setCellGoodLocalId(tData.rewardItemId[i], tData.rewardItemNum[i], 17)
			tNewObj:setItemClickFun(self, self.onClickItem)

			tbNewGiftList:setCellElement(element)
		end
	end
	--礼包状态
	if tData.status == 1 then 
		GetElement(self.m_root, "imgNewGiftState_CellBluePrivilege", WZUIImage):setVisible(true)
		GetElement(self.m_root, "btnNewGift_CellBluePrivilege", WZUIButton):setVisible(false)
	elseif tData.status == 0 then 
		GetElement(self.m_root, "btnNewGift_CellBluePrivilege", WZUIButton):setTouchEnable(true)
		GetElement(self.m_root, "txtBtnNor_CellBluePrivilege", WZUILabelTTF):setText(LocalStrings.ACTIVE_BTN_GET)
		GetElement(self.m_root, "txtBtnSel_CellBluePrivilege", WZUILabelTTF):setText(LocalStrings.ACTIVE_BTN_GET)
		GetElement(self.m_root, "txtBtnEna_CellBluePrivilege", WZUILabelTTF):setText(LocalStrings.ACTIVE_BTN_GET)
	elseif tData.status == -1 then 
		GetElement(self.m_root, "btnNewGift_CellBluePrivilege", WZUIButton):setTouchEnable(false)
		GetElement(self.m_root, "txtBtnNor_CellBluePrivilege", WZUILabelTTF):setText(LocalStrings.NEWFIRSTCHARGE_TEXT5)
		GetElement(self.m_root, "txtBtnSel_CellBluePrivilege", WZUILabelTTF):setText(LocalStrings.NEWFIRSTCHARGE_TEXT5)
		GetElement(self.m_root, "txtBtnEna_CellBluePrivilege", WZUILabelTTF):setText(LocalStrings.NEWFIRSTCHARGE_TEXT5)
	end
end

--@brief 	每日礼包界面刷新
function CellBluePrivilege:_showDayGift()
	local tbDayGiftList = GetElement(self.m_root, "tbDayGiftList_CellBluePrivilege", WZUITableContainer)
	tbDayGiftList:cleanTable()
	for i = 1, #self.m_tRewardList do
		local element, tNewObj = CellBlueDayGiftItem:createElement(GlobalMethod:CCSize(722, 122))
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setData(self.m_tRewardList[i], self.m_nActivityType)

			tbDayGiftList:setCellElement(element)
		end
	end
end

--@brief 	成长礼包界面刷新
function CellBluePrivilege:_showGrowGift()
	local tbGrowGiftList = GetElement(self.m_root, "tbGrowGiftList_CellBluePrivilege", WZUITableContainer)
	tbGrowGiftList:cleanTable()
	for i = 1, #self.m_tRewardList do
		local element, tNewObj = CellBlueDayGiftItem:createElement(GlobalMethod:CCSize(722, 92))
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setData(self.m_tRewardList[i], self.m_nActivityType)

			tbGrowGiftList:setCellElement(element)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
