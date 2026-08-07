--WndRiseReward.lua
--@brief	WndRiseReward的UI模块
--@date		2021/06/25
--@author	hyx
--@note		崛起之路选择道具奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRiseReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRiseReward:onExit(element)
	self:_unInit()
end
function WndRiseReward:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function WndRiseReward:actionCallback()
end
function WndRiseReward:showInterface(element, btnElement, data, chooseData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tips = WndRiseReward:createElement()
	if tips ~= nil then
	    element:addChild(tips)
	    self:setData(btnElement, data, chooseData)
	end
end
function WndRiseReward:setData(btnElement, data, chooseData)
	chooseData = chooseData or {}
	local reward_container = GetElement(self.m_root,"reward_container",WZUIContainer)
	reward_container:setUseAbsCoordinate(true)
	local ptA = btnElement:convertToWorldSpace(GlobalMethod:ccp(0,0))
	reward_container:setAbsPosition(GlobalMethod:ccp(ptA.x+130, ptA.y+90))

	local rewardFreeList = GetElement(self.m_root,"rewardFreeList",WZUIFreeListContainer)
	rewardFreeList:removeAll()
	local temp_count = {}
	for i,v in pairs(chooseData) do
		if v then
			if temp_count[v] then
				temp_count[v] = temp_count[v] + 1
			else
				temp_count[v] = 1
			end
		end
	end
	for i = 1, #data.itemId do
		local element, tLuaObj = RiseRewardItem:createElement()
		rewardFreeList:pushBack(WZUIContainer:luaTo(element))
		rewardFreeList:getMoveElement():setPositionX(rewardFreeList:getMaxPosition().x)
		local count = 0
		if data.itemBuyLimit[i] == -1 then
			count = -1
		else
			local choose_count = temp_count[data.itemId[i]] or 0
			count = data.itemBuyLimit[i] - data.itemBuyCount[i] - choose_count
			if count <= 0 then
				count = 0
			end
		end
		tLuaObj:setRewardRemainData(i, data.itemId[i], data.itemNum[i], count)
		tLuaObj:setFunc(function(tCell,tag,tData,count)
			WndItemInfo:onCloseClick()
			if count <= 0 and count ~= -1 then
				MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT63)
			else
				if self.m_nCurItemIndex ~= tag and self.m_tChooseItem[self.m_nCurItemIndex] then
					self.m_tChooseItem[self.m_nCurItemIndex] = nil
					if self.m_sTouchItemCell then
						self.m_sTouchItemCell:setItemSelState(false)
					end
				end
				self.m_tTouchChooseItem = nil
				if self.m_tChooseItem[tag] == nil then
					self.m_tTouchChooseItem = tData
					self.m_tChooseItem[tag] = true
					tCell:setItemSelState(true)
					WndItemInfo:showInfo(tCell.m_root,WndRiseMainActivity.m_root,1,tData,false,nil,true)
				else
					self.m_tChooseItem[tag] = nil
					tCell:setItemSelState(false)
				end
				self.m_nCurItemIndex = tag
				self.m_sTouchItemCell = tCell
			end
		end)
	end
end
function WndRiseReward:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root then
		GlobalGame:getGameEventDispathcer():Dispatch(WndNationalEvent.WndNationalEvent_GiftItemChoose, self.m_tTouchChooseItem, self.m_nCurItemIndex)
		self.m_root:removeFromParentAndCleanup(true)		
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
