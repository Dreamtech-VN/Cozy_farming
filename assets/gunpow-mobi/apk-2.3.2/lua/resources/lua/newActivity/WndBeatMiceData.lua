--WndBeatMiceData.lua
--@brief	WndBeatMice的数据模块
--@date		2022/03/03
--@author	XTX
--@note		欢乐地鼠活动

WndBeatMice = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBeatMice:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160226
	self.m_nDropCoinId = 160227
	self.m_nCurExp = 0 
	self.m_tLvRewardList = nil 			--捕鼠奖励列表
	self.m_tMiceList = nil 				--地鼠列表
	self.m_tMiceSpineFile = {"activity/ui_dishu", "activity/ui_dishuhat", "activity/ui_dishubag"} 				--地鼠类型列表
	self.m_nTimeCaculate = 0            --计算时间
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBeatMice:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = nil 
	self.m_tOpenResult = nil 
	self.m_nCoinId = nil
	self.m_nDropCoinId = nil
	self.m_nCurExp = nil 
	self.m_tLvRewardList = nil 
	self.m_tMiceList = nil 				--鼠列表
	self.m_tMiceSpineFile = nil 
	self.m_nTimeCaculate = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBeatMice:createElement()
	if WndBeatMice.m_root ~= nil then
		WindowManager:removeWindow(WndBeatMice.m_root, WndBeatMice, true)
	end
	local element = WZUISystem:getInstance():createElement("WndBeatMice")
	assert(element, "WndBeatMice create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndBeatMice:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndBeatMice:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndBeatMice, false)
	end
end

--@brief 	获取活动详情成功
function WndBeatMice:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndBeatMice:GetActivityInfoOK", g_cityExtenInfo.activity7037, activityId, content)
	if g_cityExtenInfo.activity7037 == activityId then 
		self.m_tContent = json.decode(content)
		WZLog("WndBeatMice:GetActivityInfoOK", Serialize(self.m_tContent.shrewmouse))
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nCurExp = self.m_tContent.whackExp

		self:_setMiceList()
		self:_analyzeBigReward()
		self:_update()
		self.m_root:enableSchedule("_updateMicePos", 1)
	end
end

--@brief 	获取其他活动数据
function WndBeatMice:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndBeatMice:_onGetOtherData", Serialize(tResult))
		self.m_tOpenResult = {}

		self.m_nCurExp = tResult.whackExp
		self.m_tOpenResult.normalRewards = {} --常规奖
		self.m_tOpenResult.firstRewards = {} --一等奖
		self.m_tOpenResult.bigRewards = {} --特等奖
		self.m_tOpenResult.miceRewards = {} --头盔地鼠或宝藏地鼠奖励
		self.m_tOpenResult.dropCornNum = tResult.dropCornNum --玉米掉落数量
		self.m_tOpenResult.times = tResult.times
		self.m_tContent.shrewmouse = tResult.shrewmouse
		local nSex = CacheCenter:getPlayerInfo().sex
		if #tResult.rewardTypes > 0 then 
			for i = 1, #tResult.rewardTypes do
				if tResult.rewardTypes[i] == 4 then 
					local array = tResult.rewards[i]
					for j = 1, #array do
						local tItem = {}

						tItem.itemId = array[j][nSex + 1]
						tItem.itemNum = array[j][3]
						tItem.type = 3

						table.insert(self.m_tOpenResult.firstRewards, tItem)
					end
				elseif tResult.rewardTypes[i] == 5 then 
					local array = tResult.rewards[i]
					for j = 1, #array do
						local tItem = {}

						tItem.itemId = array[j][nSex + 1]
						tItem.itemNum = array[j][3]
						tItem.type = 4

						table.insert(self.m_tOpenResult.bigRewards, tItem)
					end
				elseif tResult.rewardTypes[i] == 2 then 
					local array = tResult.rewards[i]
					for j = 1, #array do
						local tItem = {}

						tItem.itemId = array[j][nSex + 1]
						tItem.itemNum = array[j][3]
						tItem.type = 5

						table.insert(self.m_tOpenResult.miceRewards, tItem)
					end
				elseif tResult.rewardTypes[i] == 3 then 
					local array = tResult.rewards[i]
					for j = 1, #array do
						local tItem = {}

						tItem.itemId = array[j][nSex + 1]
						tItem.itemNum = array[j][3]
						tItem.type = 6

						table.insert(self.m_tOpenResult.miceRewards, tItem)
					end
				else
					local array = tResult.rewards[i]
					for j = 1, #array do
						local tItem = {}
						tItem.itemId = array[j][nSex + 1]
						tItem.itemNum = array[j][3]
						if tResult.times == 1 then 
							tItem.type = 1
						elseif tResult.times == 5 then 
							tItem.type = 2
						end

						table.insert(self.m_tOpenResult.normalRewards, tItem)
					end
				end
			end
		end

		if result == 1 then 
			self:_showLvAndExp()
			self:showOpenAction()
		end
	elseif doType == 4 then --领取捕鼠奖励
		if result == 1 then 
			local tResult = json.decode(jsonData)

			self.m_tLvRewardList[tResult.lv].status = 2
			local nSex = CacheCenter:getPlayerInfo().sex
			local ids, nums = SplitItemString(self.m_tLvRewardList[tResult.lv].reward, nSex)
			WndRewardShow:showById(ids, nums)

			self:_createLvRewardList()
		end
	elseif doType == 5 then --获取捕鼠奖励数据
		GetElement(self.m_root, "conLvReward_WndBeatMice", WZUIContainer):setVisible(true)
		local tResult = json.decode(jsonData)
		self.m_tLvRewardList = {}
		local tTempTable = CopyTable(self.m_tContent.whackLvConfig)
		for i = 1, #tResult.lvs do
			if tResult.lvs[i] > 0 then 
				local tItem = {}
				tItem.lv = tTempTable[tostring(tResult.lvs[i])].lv
				tItem.name = tTempTable[tostring(tResult.lvs[i])].name
				tItem.reward = tTempTable[tostring(tResult.lvs[i])].reward
				tItem.exp = tTempTable[tostring(tResult.lvs[i])].exp
				tItem.status = tResult.states[i]

				table.insert(self.m_tLvRewardList, tItem)
			end
		end

		table.sort(self.m_tLvRewardList, function (a, b)
				return a.lv < b.lv
			end
			)
		self:_createLvRewardList()
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndBeatMice:updatePlayerItemData()
	WZLog("WndBeatMice:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
		self:showRedDot()
	end
end

--@brief 	设置射箭的状态
function WndBeatMice:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndBeatMice:_afterCloseReward()
	if self.m_root == nil then return end 
	local tBigReward = {}
	local nIndex = 1
	if #self.m_tOpenResult.firstRewards > 0 then 
		tBigReward[nIndex] = CopyTable(self.m_tOpenResult.firstRewards)
		nIndex = nIndex + 1
	end
	if #self.m_tOpenResult.bigRewards > 0 then 
		tBigReward[nIndex] = CopyTable(self.m_tOpenResult.bigRewards)
	end

	local tOtherRewards = {}
	if self.m_tOpenResult.miceRewards and #self.m_tOpenResult.miceRewards > 0 then 
		table.insert(tOtherRewards, self.m_tOpenResult.miceRewards)
	end

	if (self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0) or #self.m_tOpenResult.miceRewards > 0 then 
		WndHoraryBigReward:showInterface(13, self.m_tOpenResult.normalRewards, tBigReward, tOtherRewards)
	elseif #tBigReward > 0 then 
		WndHoraryBigReward:showInterface(14, tBigReward)
	end
end

--@brief 	解析大奖数据
function WndBeatMice:_analyzeBigReward()
	-- body
	local sBigReward = self.m_tContent.firstReward
	local nSex = CacheCenter:getPlayerInfo().sex
	local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.BEATMICE_TEXT1[9]}
	self.m_tBigRewardList = {}
	for i = 1, #sBigReward do
		local id = sBigReward[i][nSex + 1]
		local num = sBigReward[i][3]

		table.insert(tItem.reward_ids1, id)
		table.insert(tItem.reward_nums1, num)
	end

	self.m_tBigRewardList[1] = tItem

	local specialReward = self.m_tContent.specialReward	
	local tItem1 = {reward_ids2 = {}, reward_nums2 = {}, name = LocalStrings.BEATMICE_TEXT1[10]}
	for i = 1, #specialReward do
		local id = specialReward[i][nSex + 1]
		local num = specialReward[i][3]
		
		table.insert(tItem1.reward_ids2, id)
		table.insert(tItem1.reward_nums2, num)
	end

	self.m_tBigRewardList[2] = tItem1
end

--@brief 	获取当前捕鼠等级
function WndBeatMice:getCurLvInfo()
	local tCurInfo = nil 
	local tNextInfo = nil 
	local tMaxInfo = nil 
	local nLevel = 0 
	local nMaxLv = 0 
	for i, value in pairs(self.m_tContent.whackLvConfig) do
		if self.m_nCurExp >= value.exp and value.lv >= nLevel then 
			nLevel = value.lv
			tCurInfo = value
		end
		if value.lv > nMaxLv then 
			nMaxLv = value.lv
			tMaxInfo = value
		end
	end

	if nLevel >= nMaxLv then 
		tCurInfo = tMaxInfo
		tNextInfo = tMaxInfo
	else
		for i, value in pairs(self.m_tContent.whackLvConfig) do
			if value.lv == nLevel + 1 then 
				tNextInfo = value
				break
			end
		end
	end

	return tCurInfo, tNextInfo, nMaxLv
end

--@brief 	设置地鼠列表
function WndBeatMice:_setMiceList()
	self.m_tMiceList = {}
	local tRandomList = GetRandomNum(15, 100, 1)
	for i = 1, #self.m_tContent.shrewmouse do
		if self.m_tContent.shrewmouse[i] > 0 then 
			local tItem = {}
			tItem[1] = i 
			tItem[2] = self.m_tContent.shrewmouse[i]
			tItem[3] = math.fmod(tRandomList[i], 3) + 1

			table.insert(self.m_tMiceList, tItem)
		end
	end

	table.sort(self.m_tMiceList, function (a, b)
			if a[2] ~= b[2] then 
				return a[2] > b[2]
			else
				return a[1] < b[1]
			end
		end
		)
end
-------------------------------------私有方法模块End----------------------------------------
CellLvRewardItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellLvRewardItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil
	self.m_bIsLoaded = false
	self.m_nType = 0 			--0:打地鼠等级奖励；1：台无止境等级奖励；2：修仙传等级奖励；3：攀藤大赛；4：深海寻宝；5：热血篮球；6：捕鱼大王; 7：魔法课堂 8：陶艺工坊 9:拼装积木 10:一起来采茶 11:植树造林
	self.m_tOtherData = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLvRewardItem:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bIsLoaded = nil 
	self.m_tOtherData = nil 
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellLvRewardItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellLvRewardItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellLvRewardItem")
	element:setAbsContentSize(GlobalMethod:CCSize(620,94))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	 设置数据
function CellLvRewardItem:setData(tData, nType, otherData)
	-- body
	self.m_tData = tData
	self.m_nType = nType or 0 
	self.m_tOtherData = otherData
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellLvRewardItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLvRewardItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLvRewardItem:onExit(element)
	self:_unInit()
end

--@brief 加载
function CellLvRewardItem:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellLvRewardItem_WndBeatMice")
	celElement:setVisible(true)
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true 
    self:_update()

    AdaptLanguage(self)
end

--@brief 	点击下拉按钮回调
function CellLvRewardItem:onGetReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	local tData = {}
	tData.lv = nTag
	

	local nActivityId = WndBeatMice.m_nActivityId
	local nOpType = 4
	if self.m_nType == 1 then 
		nActivityId = WndBilliardBall.m_nActivityId
		nOpType = 6
	elseif self.m_nType == 3 then 
		nActivityId = self.m_tData.activityId
		nOpType = 6
		tData.lvType = nTag
	elseif self.m_nType == 4 then 
		nActivityId = self.m_tData.activityId
		nOpType = 7
		tData.level = self.m_tData.lv
	elseif self.m_nType == 5 then 
		nActivityId = self.m_tData.activityId
		nOpType = 5
		tData.lv = self.m_tData.id
	elseif self.m_nType == 6 then 
		nActivityId = self.m_tData.activityId
		nOpType = 5
		tData.id = self.m_tData.lv - 1
	elseif self.m_nType == 7 then 
		nActivityId = self.m_tData.activityId
		nOpType = 5
		tData.id = self.m_tData.lv - 1
	elseif self.m_nType == 8 then 
		nActivityId = self.m_tData.activityId
		nOpType = 5
		tData.id = self.m_tData.lv - 1
	elseif self.m_nType == 9 then 
		nActivityId = self.m_tData.activityId
		nOpType = 5
		tData.id = self.m_tData.lv - 1
	elseif (self.m_nType == 10 or self.m_nType == 11) and self.m_tOtherData then 
		nActivityId = self.m_tData.activityId
		nOpType = self.m_tOtherData.opType
		tData.id = self.m_tData.lv - 1
	end
	local stringData = json.encode(tData)
	if self.m_nType == 2 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_tData.activityId, self.m_tData.id)
	else
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(nActivityId, nOpType, stringData)
	end
end

--@brief    刷新
function CellLvRewardItem:_update()
	WZLog("CellLvRewardItem:_update")
	--body
	local txtLv = GetElement(self.m_root, "txtLv_CellLvRewardItem", WZUILabelTTF)
	if txtLv then 
		txtLv:setText(LocalStrings.LV .. self.m_tData.lv)
	end
	local txtLvName = GetElement(self.m_root, "txtLvName_CellLvRewardItem", WZUILabelTTF)
	if txtLvName then 
		txtLvName:setText(self.m_tData.name)
	end
	if self.m_nType == 4 then 
		txtLv:setText("")
		txtLvName:setRelativePosition(GlobalMethod:ccp(0.03,0.75))
	end
	local txtLvExpWord = GetElement(self.m_root, "txtLvExpWord_CellLvRewardItem", WZUILabelTTF)
	local txtLvExp = GetElement(self.m_root, "txtLvExp_CellLvRewardItem", WZUILabelTTF)
	local nExp
	if self.m_nType == 0 then 
		txtLvExpWord:setText(LocalStrings.BEATMICE_TEXT1[11])
		nExp = WndBeatMice.m_nCurExp > self.m_tData.exp and self.m_tData.exp or WndBeatMice.m_nCurExp
	elseif self.m_nType == 1 then 
		txtLvExpWord:setText(LocalStrings.BILLIARDBALL_TEXT1[12])
		nExp = WndBilliardBall.m_nCurExp > self.m_tData.exp and self.m_tData.exp or WndBilliardBall.m_nCurExp
	elseif self.m_nType == 2 then 
		txtLvExpWord:setText(LocalStrings.BEINGIMMORTAL_TEXT1[23])
		nExp = self.m_tData.progress
	elseif self.m_nType == 3 then 
		txtLvExpWord:setText(LocalStrings.CLIMBTREE_TEXT1[7])
		nExp = self.m_tData.progress
	elseif self.m_nType == 4 then 
		txtLvExpWord:setText(LocalStrings.DEEPSEA_TEXT1[18])
		nExp = WndDeepSea.m_nCurExp > self.m_tData.exp and self.m_tData.exp or WndDeepSea.m_nCurExp
	elseif self.m_nType == 5 then 
		GetElement(self.m_root, "img9Bg_CellLvRewardItem", WZUI9Image):setFile("ui/common/frame_lieb_03.png")
		txtLvExpWord:setText(LocalStrings.HOTBASKETBALL_TEXT1[18])
		nExp = WndHotBasketball.m_nCurExp > self.m_tData.exp and self.m_tData.exp or WndHotBasketball.m_nCurExp
	elseif self.m_nType == 6 then 
		GetElement(self.m_root, "img9Bg_CellLvRewardItem", WZUI9Image):setFile("ui/common/frame_lieb_10.png")
		txtLvExpWord:setText(LocalStrings.CATCHFISH_TEXT1[18])
		nExp = WndCatchFish.m_nCurExp > self.m_tData.exp and self.m_tData.exp or WndCatchFish.m_nCurExp
	elseif self.m_nType == 7 then
		GetElement(self.m_root, "img9Bg_CellLvRewardItem", WZUI9Image):setFile("ui/common/frame_lieb_10.png")
		txtLvExpWord:setText(LocalStrings.MAGIC_CLASSROOM_TEXT1[11])
		nExp = WndMagicClassroom.m_nCurExp > self.m_tData.exp and self.m_tData.exp or WndMagicClassroom.m_nCurExp
	elseif self.m_nType == 8 then
		txtLvExpWord:setText(LocalStrings.CERAMIC_WORKSHOP_TEXT1[17])
		nExp = WndCeramicWorkshop.m_nCurExp > self.m_tData.exp and self.m_tData.exp or WndCeramicWorkshop.m_nCurExp
	elseif self.m_nType == 9 then
		txtLvExpWord:setText(LocalStrings.BUILDING_BLOCKS_TEXT1[7])
		nExp = WndBuildingBlocks.m_nCurExp > self.m_tData.exp and self.m_tData.exp or WndBuildingBlocks.m_nCurExp
	elseif (self.m_nType == 10 or self.m_nType == 11) and self.m_tOtherData then 
		txtLvExpWord:setText(self.m_tOtherData.strExp)
		nExp = self.m_tOtherData.exp > self.m_tData.exp and self.m_tData.exp or self.m_tOtherData.exp
	end
	txtLvExp:setText("(" .. nExp .. "/" .. self.m_tData.exp .. ")")
	local btnReward = GetElement(self.m_root, "btnReward_CellLvRewardItem", WZUIButton)
	if self.m_nType == 3 then 
		btnReward:setTag(self.m_tData.id)
	else
		btnReward:setTag(self.m_tData.lv)
	end
	if self.m_tData.status == 0 then 
		btnReward:setVisible(true)
		btnReward:setTouchEnable(false)
		GetElement(self.m_root, "txtBtnNor_CellLvRewardItem", WZUILabelTTF):setText(LocalStrings.UNCOMPLETE)
		GetElement(self.m_root, "txtBtnSel_CellLvRewardItem", WZUILabelTTF):setText(LocalStrings.UNCOMPLETE)
		GetElement(self.m_root, "txtBtnEnable_CellLvRewardItem", WZUILabelTTF):setText(LocalStrings.UNCOMPLETE)
	elseif self.m_tData.status == 1 then 
		btnReward:setVisible(true)
		btnReward:setTouchEnable(true)
		GetElement(self.m_root, "txtBtnNor_CellLvRewardItem", WZUILabelTTF):setText(LocalStrings.ACTIVE_BTN_GET)
		GetElement(self.m_root, "txtBtnSel_CellLvRewardItem", WZUILabelTTF):setText(LocalStrings.ACTIVE_BTN_GET)
		GetElement(self.m_root, "txtBtnEnable_CellLvRewardItem", WZUILabelTTF):setText(LocalStrings.ACTIVE_BTN_GET)
	elseif self.m_tData.status == 2 then 
		btnReward:setVisible(false)
		GetElement(self.m_root, "imgHaveGet_CellLvRewardItem", WZUIImage):setVisible(true)
	end
	--奖励
	local conReward = GetElement(self.m_root, "conReward_CellLvRewardItem", WZUIContainer)
	conReward:removeAllChildrenWithCleanup(true)
	local ids, nums = nil, nil
	local nStartX = 0.12 
	local nGapping = 0.25
	local nScale = 0.8
	if self.m_nType == 2 or self.m_nType == 3 or (self.m_tOtherData and self.m_tOtherData.rewardType == 1) then 
		ids, nums = {}, {}
		for i = 1, #self.m_tData.reward do
			table.insert(ids, self.m_tData.reward[i][1])
			table.insert(nums, self.m_tData.reward[i][2])
		end
		nScale = 0.67
		nGapping = 0.2
	elseif self.m_nType == 6 or self.m_nType == 7 or self.m_nType == 8 or self.m_nType == 9 or (self.m_tOtherData and self.m_tOtherData.rewardType == 2) then 
		local nSex = CacheCenter:getPlayerInfo().sex
		ids, nums = {}, {}
		for i = 1, #self.m_tData.reward do
			table.insert(ids, self.m_tData.reward[i][nSex + 1])
			table.insert(nums, self.m_tData.reward[i][3])
		end
	else
		local nSex = CacheCenter:getPlayerInfo().sex
		ids, nums = SplitItemString(self.m_tData.reward, nSex)
	end
	for i = 1, #ids do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			tNewObj:setCellGoodLocalId(tonumber(ids[i]), tonumber(nums[i]), 17)
			tNewObj:setItemClickFun(self, self.onItemClick)
			element:setRelativePosition(GlobalMethod:ccp(0.12 + (i - 1) * nGapping, 0.5))
			element:setScale(nScale)
			conReward:addChild(element)
		end
	end
end

function CellLvRewardItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    local rootTemp = WndBeatMice.m_root
    if self.m_nType == 1 then 
    	rootTemp = WndBilliardBall.m_root
    elseif self.m_nType == 2 then 
    	rootTemp = WndBeingImmortal.m_root
    elseif self.m_nType == 3 then 
    	rootTemp = WndClimbTree.m_root
    elseif self.m_nType == 4 then 
    	rootTemp = WndDeepSea.m_root
    elseif self.m_nType == 5 then 
    	rootTemp = WndHotBasketball.m_root
    elseif self.m_nType == 6 then 
    	rootTemp = WndCatchFish.m_root
    elseif self.m_nType == 7 then 
    	rootTemp = WndMagicClassroom.m_root
    elseif self.m_nType == 8 then 
    	rootTemp = WndCeramicWorkshop.m_root
    elseif self.m_nType == 9 then 
    	rootTemp = WndBuildingBlocks.m_root
    elseif (self.m_nType == 10 or self.m_nType == 11) and self.m_tOtherData then 
    	rootTemp = self.m_tOtherData.tipsRoot
    end
   	WndItemInfo:showInfo(tCell.m_root, rootTemp,1,tData,false,nil,true)
end

--@brief 	修改奖励状态
function CellLvRewardItem:updateStatue(status)
	self.m_tData.status = status
	local btnReward = GetElement(self.m_root, "btnReward_CellLvRewardItem", WZUIButton)
	if self.m_tData.status == 0 then 
		btnReward:setVisible(true)
		btnReward:setTouchEnable(false)
		GetElement(self.m_root, "txtBtnNor_CellLvRewardItem", WZUILabelTTF):setText(LocalStrings.UNCOMPLETE)
		GetElement(self.m_root, "txtBtnSel_CellLvRewardItem", WZUILabelTTF):setText(LocalStrings.UNCOMPLETE)
		GetElement(self.m_root, "txtBtnEnable_CellLvRewardItem", WZUILabelTTF):setText(LocalStrings.UNCOMPLETE)
	elseif self.m_tData.status == 1 then 
		btnReward:setVisible(true)
		btnReward:setTouchEnable(true)
		GetElement(self.m_root, "txtBtnNor_CellLvRewardItem", WZUILabelTTF):setText(LocalStrings.ACTIVE_BTN_GET)
		GetElement(self.m_root, "txtBtnSel_CellLvRewardItem", WZUILabelTTF):setText(LocalStrings.ACTIVE_BTN_GET)
		GetElement(self.m_root, "txtBtnEnable_CellLvRewardItem", WZUILabelTTF):setText(LocalStrings.ACTIVE_BTN_GET)
	elseif self.m_tData.status == 2 then 
		btnReward:setVisible(false)
		GetElement(self.m_root, "imgHaveGet_CellLvRewardItem", WZUIImage):setVisible(true)
	end
end

--@brief 	获取数据
function CellLvRewardItem:getData()
	return self.m_tData
end

--------------------------------------语言适配Begin-----------------------------------------

function CellLvRewardItem:_adaptLanguage_vn(  )
	local txtLvExpWord = GetElement(self.m_root, "txtLvExpWord_CellLvRewardItem", WZUILabelTTF)
	txtLvExpWord:setScale(0.7)
	local txtLvExp = GetElement(self.m_root, "txtLvExp_CellLvRewardItem", WZUILabelTTF)
	txtLvExp:setScale(0.7)
	txtLvExp:setRelativePosition(GlobalMethod:ccp(0.19,0.3))

	GetElement(self.m_root, "txtLvName_CellLvRewardItem", WZUILabelTTF):setScale(0.7)

	if self.m_nType == 2 then
		txtLvExp:setRelativePosition(GlobalMethod:ccp(0.25,0.3))
	end
end

---------------------------------------语言适配End------------------------------------------
