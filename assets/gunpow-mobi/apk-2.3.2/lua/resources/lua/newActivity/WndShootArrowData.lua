--WndShootArrowData.lua
--@brief	WndShootArrow的数据模块
--@date		2021/06/22
--@author	XTX
--@note		射箭活动主界面

WndShootArrow = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndShootArrow:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tMessages = nil 
	self.m_nMessageIndex = nil 
	self.m_bIsBarrageOpen = true 		--弹幕是否打开
	self.m_nGiftRewardNum = 0 			--赛事礼包奖励数量
	self.m_tContent = nil 	
	self.m_tTeamState = {} 		--组队专属奖励状态
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nActivityId = nil 
	self.m_tShootResult = nil 
	self.m_nTimes = 0 			--聊天间隔
	self.m_bIsShooting = false 			--限制射箭的频率
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndShootArrow:_unInit()
	self.m_root = nil
	self.m_tMessages = nil 
	self.m_nMessageIndex = nil 
	self.m_bIsBarrageOpen = nil 		--弹幕是否打开
	self.m_nGiftRewardNum = nil			--赛事礼包奖励数量
	self.m_tContent = nil 	
	self.m_tTeamState = nil 		--组队专属奖励状态
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nActivityId = nil 
	self.m_tShootResult = nil 
	self.m_nTimes = nil 			--聊天间隔
	self.m_bIsShooting = nil 			--限制射箭的频率
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndShootArrow:createElement()
	if WndShootArrow.m_root ~= nil then
		WindowManager:removeWindow(WndShootArrow.m_root, WndShootArrow, true)
	end
	local element = WZUISystem:getInstance():createElement("WndShootArrow")
	assert(element, "WndShootArrow create element failed!")
	self:_init()
	return element
end

--@BRIEF 	外部接口
function WndShootArrow:showInterface()
	LoadNewActivityRes(true)
	local wndArrow = WndShootArrow:createElement()
	if wndArrow then
		g_nLastChannelId_ShootArrow = GlobalGame.g_nCurrentUIChannelId
		WindowManager:addWindow(wndArrow, WndShootArrow, false, nil, nil, true)
	end
end

--@brief 	获取活动详情成功
function WndShootArrow:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	if g_cityExtenInfo.activity7020 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		
		self:_analyzeBigReward()

		self:_update()
	end
end

--@brief 	操作结果
function WndShootArrow:opereteResultByType(activityId, activityType, doType, result, msg)
	-- body
	if doType == 1 then --1获取好友列表
	elseif doType == 2 then --2获取邀请通知
	elseif doType == 3 then --3发出邀请
	elseif doType == 4 then --4同意邀请
	elseif doType == 5 then --5拒绝邀请
	elseif doType == 6 then --6队伍信息
	elseif doType == 7 then --7点击发射
		WZLog("WndShootArrow:opereteResultByType", doType, msg)
		self:_setShootArrowReward(result, msg)
	elseif doType == 8 then --8通知服务器广播
	elseif doType == 9 then --9主动推送的活动信息
		self:_setTeamStateInfo(msg)
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndShootArrow:updatePlayerItemData()
	WZLog("WndShootArrow:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateArrowNum()
	end
end

--@brief 	插入新收到的消息
function WndShootArrow:putNewMessage(msgText)
	-- body
	if self.m_tMessages == nil then 
		self.m_tMessages = {}
	end
	WZLog("WndShootArrow:putNewMessage", msgText)
	table.insert(self.m_tMessages, msgText)
end

function WndShootArrow:_onGetRewardResult(itemsId, count, _type, rewardId)
	WndRewardShow:showById(itemsId, count)
	WndRewardShow:closeCallBack(self, self.afterRewardShow, _G, pushEquipInList)
end

--@brief 	设置射箭的状态
function WndShootArrow:setShootState(bShooting)
	-- body
	if self.m_root == nil then return end 

	self.m_bIsShooting = bShooting
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	解析大奖数据
function WndShootArrow:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.bigRewards
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {}
	for i = 1, #array do
		WZLog("WndShootArrow:_analyzeBigReward", string.sub(array[i], 2, -2))
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])
		table.insert(tItem, {id, num})
	end

	self.m_tContent.bigRewards = tItem

	local array1 = SplitStringWithSeparator(self.m_tContent.zdRewards, "&")
	local tItem1 = {}
	for i = 1, #array1 do
		WZLog("WndShootArrow:_analyzeBigReward", string.sub(array1[i], 2, -2))
		local string = string.sub(array1[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string, ",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string, ",")[3])
		table.insert(tItem1, {id, num})
	end

	self.m_tContent.zdRewards = tItem1
end

--@brief 	设置组队状态数据
--@param 	teamState:json  count:int当前玩家射箭次数,zdStatus:int组队状态 0未组队|1已组队,zdRewardStatus:int组队专属奖励领取状态-1不可领取|0可领取|1已领取
function WndShootArrow:_setTeamStateInfo(teamState)
	-- body
	self.m_tTeamState = json.decode(teamState)
	WZLog("WndShootArrow:_setTeamStateInfo", Serialize(self.m_tTeamState))
	self.m_nGiftRewardNum = self.m_tTeamState.ssRewardCount
	
	self:_updateTeamInfo()
end

--@brief 	射箭奖励
function WndShootArrow:_setShootArrowReward(result, msg)
	-- body
	self:setShootState(true)
	self.m_tShootResult = {}
	self.m_tShootResult.result = result 
	self.m_tShootResult.msg = msg
	
	self:showShootingAction()
end

function WndShootArrow:getMaxSubString(sMsgContent)
	if (ProjConfig.LANGUAGE == "cn" or ProjConfig.LANGUAGE == "hk" ) then
		local txtTemp = GetElement(self.m_root,"txtTempP_WndShootArrow",WZUILabelTTF)
		txtTemp:setMaxLength(24)
		txtTemp:setText(sMsgContent)
		local childrens = txtTemp:getChildren()
		local tempStr = ""
		if childrens and childrens:count() > 0 then
		    for i=0,childrens:count()-1 do
		        tempStr = tolua.cast(childrens:objectAtIndex(i),"CCLabelTTF"):getString()
		    end
        end
		return tempStr
	else
		local txtTemp = GetElement(self.m_root,"txtTempP_WndShootArrow",WZUILabelTTF)
		txtTemp:setMaxLength(64)
		txtTemp:setText(sMsgContent)
		local childrens = txtTemp:getChildren()
		local tempStr = ""
		if childrens and childrens:count() > 0 then
		    for i=0,childrens:count()-1 do
		        tempStr = tolua.cast(childrens:objectAtIndex(i),"CCLabelTTF"):getString()
		    end
        end
		return tempStr
	end
	return sMsgContent
end
-------------------------------------私有方法模块End----------------------------------------
