--WndThankfulSignData.lua
--@brief	WndThankfulSign的数据模块
--@date		2023/02/28
--@author	XTX
--@note		感恩打卡活动

WndThankfulSign = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndThankfulSign:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nActivityId = nil
	self.m_nLeftDays = 0
	self.m_tRewardList = nil 
	self.m_nInterfaceIndex = nil 	--界面索引
	self.m_tCellItem = nil 	
	self.m_tContent = nil 
	self.m_tResignCost = nil 		--补卡消耗
	self.m_tMsgData = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndThankfulSign:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nActivityId = nil
	self.m_nLeftDays = nil 
	self.m_tRewardList = nil 
	self.m_nInterfaceIndex = nil  	--界面索引
	self.m_tCellItem = nil 	
	self.m_tContent = nil 
	self.m_tResignCost = nil 		--补卡消耗
	self.m_tMsgData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndThankfulSign:createElement()
	if WndThankfulSign.m_root ~= nil then
		WindowManager:removeWindow(WndThankfulSign.m_root, WndThankfulSign, true)
	end
	local element = WZUISystem:getInstance():createElement("WndThankfulSign")
	assert(element, "WndThankfulSign create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndThankfulSign:showInterface(nIndex, tMsg)
	LoadNewActivityRes(true)
	local wndWater = WndThankfulSign:createElement()
	if wndWater then 
		self.m_nInterfaceIndex = nIndex or 1
		self.m_tMsgData = tMsg
		WindowManager:addWindow(wndWater, WndThankfulSign, false, nil, nil, true)
	end
end

--@brief 	获取活动详情成功
function WndThankfulSign:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndThankfulSign:GetActivityInfoOK", g_cityExtenInfo.activity7067, Serialize(finishCondition), content)
	if g_cityExtenInfo.activity7067 == activityId then 
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_nLeftDays = count
		self.m_tContent = json.decode(content)
		local tempContent = json.decode(self.m_tContent.reward)
		local tempCost = json.decode(self.m_tContent.buka)
		WZLog("WndThankfulSign:GetActivityInfoOK", Serialize(tempContent), Serialize(self.m_tResignCost))
		self.m_tResignCost = {}
		local array = SplitStringWithSeparator(tempCost[1], "&")
		for i = 1, #array do
			local strTemp = string.sub(array[i], 2, -2) 
			local id = tonumber(SplitStringWithSeparator(strTemp,",")[1])
			local num = tonumber(SplitStringWithSeparator(strTemp,",")[2])

			table.insert(self.m_tResignCost, {id, num})
		end

		self.m_tRewardList = {}
		for i = 1, #rewardId do
			local tItem = {}
			tItem.rewardId = rewardId[i]
			tItem.status = status[i]
			tItem.reward = {}
			for j, value in pairs(tempContent[tostring(i)]) do
				local rewardItem = {}
				rewardItem[1] = tonumber(j)
				rewardItem[2] = tonumber(value)

				table.insert(tItem.reward, rewardItem)
			end
			table.insert(self.m_tRewardList, tItem)
		end

		self:_update()
	end
end

--@brief 	获取活动剩余天数
function WndThankfulSign:getLeftDay()
	return self.m_nLeftDays
end

--@brief 	获取活动总天数
function WndThankfulSign:getTotalDays()
	return #self.m_tRewardList
end

--@brief 	获取活动总天数
function WndThankfulSign:getResignCost()
	return self.m_tResignCost
end

--@brief 	获取其他活动数据
function WndThankfulSign:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --补卡成功
		local tResult = json.decode(jsonData)
		WZLog("WndThankfulSign:_onGetOtherData 111", Serialize(tResult))
		if result == 1 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
			self.m_tRewardList[tResult.bukaIndex].status = 1
			if self.m_tCellItem and self.m_tCellItem[tResult.bukaIndex] then 
				self.m_tCellItem[tResult.bukaIndex]:updateStatue(1)
			end
		end
	end
end

--@brief 	射箭任务奖励
function WndThankfulSign:_onGetTaskResult(itemIds, itemNums, activityType, id)
--	WZLog("WndThankfulSign:_onGetTaskResult", self.m_nActivityId, activityId, id)
	if 7067 ~= activityType then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
		return
	end
	
	WndRewardShow:showById(itemIds, itemNums)
	self.m_tRewardList[id].status = 1
	if self.m_tCellItem and self.m_tCellItem[id] then 
		self.m_tCellItem[id]:updateStatue(1)
	end
end

--@brief    添加保存是否主动弹感恩打卡活动设置
function WndThankfulSign:saveAutoActivity(nValue)
    WZLog("WndThankfulSign:saveAutoActivity")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "THANKFULSIGN" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    local curValue = string.format("%02d%02d_%d", curDate.month, curDate.day, nValue)
    if strValue == nil or strValue == "" or strValue ~= curValue then
        data:setStringValue("CALABASH_MARK", _KeyString, curValue)
        data:flush()
    end
end

--@brief    获取上次保存的感恩打卡活动设置
function WndThankfulSign:getAutoActivity()
    WZLog("WndThankfulSign:getAutoActivity")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "THANKFULSIGN" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    local curValue = string.format("%02d%02d", curDate.month, curDate.day)
    if strValue ~= nil and strValue ~= "" then
        local result = SplitStringWithSeparator(strValue, "_")
        if result[1] == curValue then 
            GlobalGame.g_autoThankfulSign = tonumber(result[2]) == 0 
            return tonumber(result[2])
        end
    end

    return 0
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
CellThankfulSignItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellThankfulSignItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil
	self.m_bIsLoaded = false
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellThankfulSignItem:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bIsLoaded = nil 
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellThankfulSignItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellThankfulSignItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellThankfulSignItem")
	element:setAbsContentSize(GlobalMethod:CCSize(190,334))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	 设置数据
function CellThankfulSignItem:setData(tData)
	-- body
	self.m_tData = tData 
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellThankfulSignItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellThankfulSignItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellThankfulSignItem:onExit(element)
	self:_unInit()
end

--@brief 加载
function CellThankfulSignItem:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellThankfulSignItem")
	celElement:setVisible(true)
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true 
    self:_update()
end

--@brief 	点击打卡按钮回调
function CellThankfulSignItem:onClickSign(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

	local nActivityId = WndThankfulSign.m_nActivityId
	
	if self.m_tData.status == 0 then 
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(nActivityId, self.m_tData.rewardId)
	else
		local strContent = LocalStrings.SPRINGOUTING_TEXT1[23]
		local costFormat = [[<I Z="0.5" P="1">%s</I><T C="127,70,26" S="22" P="1">*%d</T>]]
		local costComma = [[<T C="127,70,26" S="22" P="1">,</T>]]
		local resignCost = WndThankfulSign:getResignCost()
		for i = 1, #resignCost do
			local basicInfo = GDatatab_item["id_" .. resignCost[i][1]]
			local tempStr = string.format(costFormat, basicInfo.icon, resignCost[i][2])

			if i ~= 1 then 
				strContent = strContent .. costComma
			end
			strContent = strContent .. tempStr
		end
		strContent = strContent .. LocalStrings.SPRINGOUTING_TEXT1[24]
		local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.SPRINGOUTING_TEXT1[22], bgPath = "ui/newActivity/hd_pic_hyhl_tc_xiao.png", bShowClose = true}
		MsgBoxManager:showConfirmBox(strContent, self, self.sureToResign, nil, tCustomUIConfig, true)
	end
end

--@brief 	点击打卡按钮回调
function CellThankfulSignItem:sureToResign(element)
	local resignCost = WndThankfulSign:getResignCost()
	for i = 1, #resignCost do
		if not JudgeMoneyIsEnough(resignCost[i][1], resignCost[i][2], nil, nil, nil, nil, nil, nil, nil, self, self.sureToUseBlueDia) then 
			return 
		end
	end
	self:sureToUseBlueDia()
end

--@brief 	确定购买
function CellThankfulSignItem:sureToUseBlueDia()
	-- body
	WZLog("CellThankfulSignItem:sureToUseDiamond")
	local nActivityId = WndThankfulSign.m_nActivityId
	local tData = {}
	tData.index = self.m_tData.rewardId
	
	local stringData = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(nActivityId, 1, stringData)
end

--@brief    刷新
function CellThankfulSignItem:_update()
	WZLog("CellThankfulSignItem:_update")
	--body
	local ftxtDay = GetElement(self.m_root, "ftxtDay_CellThankfulSignItem", WZUIFreeTextBox)
	local nLeftDays = WndThankfulSign:getLeftDay()
	local nTotalDays = WndThankfulSign:getTotalDays()
	local nCurDayIndex = nTotalDays - nLeftDays
	local bIsCurDay = false 
	if ftxtDay then 
		if self.m_tData.status == 0 or self.m_tData.rewardId == nCurDayIndex then 
			GetElement(self.m_root, "imgBk_CellThankfulSignItem", WZUIImage):setFile("ui/newActivity/common_hyhl_di_01.png")
			GetElement(self.m_root, "imgBtnSign_CellThankfulSignItem", WZUIImage):setFile("ui/newActivity/common_btn_hyhl_dk_01.png")
			GetElement(self.m_root, "imgBtnSignSel_CellThankfulSignItem", WZUIImage):setFile("ui/newActivity/common_btn_hyhl_dk_01.png")
			ftxtDay:setShowText(string.format(LocalStrings.SPRINGOUTING_TEXT1[21], self.m_tData.rewardId))

			bIsCurDay = true 
		else
			local strNewFormat = string.gsub(LocalStrings.SPRINGOUTING_TEXT1[21], "127,70,26", "91,65,167")
			ftxtDay:setShowText(string.format(strNewFormat, self.m_tData.rewardId))
		end
	end
	self:updateStatue()
	--奖励
	local conReward = GetElement(self.m_root, "conReward_CellThankfulSignItem", WZUIContainer)
	conReward:removeAllChildrenWithCleanup(true)
	local nStartY = 0.75 
	local nGapping = 0.5
	local nScale = 1

	for i = 1, #self.m_tData.reward do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			tNewObj:setCellGoodLocalId(self.m_tData.reward[i][1], self.m_tData.reward[i][2], 17)
			tNewObj:setItemClickFun(self, self.onItemClick)
			element:setRelativePosition(GlobalMethod:ccp(0.5, nStartY - (i - 1)*nGapping))
			if bIsCurDay then 
				tNewObj:setBackImgFile("ui/newActivity/common_hyhl_tbd_01.png", nil, nil, GlobalMethod:ccp(0.55, 0.42))			
			else
				tNewObj:setBackImgFile("ui/newActivity/common_hyhl_tbd_02.png", nil, nil, GlobalMethod:ccp(0.55, 0.42))			
			end
			tNewObj:setQualityFrameVisible(false)
			element:setScale(nScale)
			conReward:addChild(element)
		end
	end
end

function CellThankfulSignItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    local rootTemp = WndThankfulSign.m_root

   	WndItemInfo:showInfo(tCell.m_root, rootTemp,1,tData,false,nil,true)
end

--@brief 	修改奖励状态
function CellThankfulSignItem:updateStatue(status)
	if status then
		self.m_tData.status = status
	end
	if self.m_bIsLoaded == false then return end 

	local conDone = GetElement(self.m_root, "conDone_CellThankfulSignItem", WZUIContainer)
	local btnReward = GetElement(self.m_root, "btnSign_CellThankfulSignItem", WZUIButton)
	local nLeftDays = WndThankfulSign:getLeftDay()
	local nTotalDays = WndThankfulSign:getTotalDays()
	local nCurDayIndex = nTotalDays - nLeftDays
	if self.m_tData.status == -1 then 
		btnReward:setVisible(true)
		if self.m_tData.rewardId < nCurDayIndex then 
			btnReward:setTouchEnable(true)
			GetElement(self.m_root, "txtBtnSign_CellThankfulSign", WZUILabelTTF):setText(LocalStrings.SPRINGOUTING_TEXT1[22])
			GetElement(self.m_root, "txtBtnSign_CellThankfulSign", WZUILabelTTF):setEnableStroke(false)
			GetElement(self.m_root, "txtBtnSignSel_CellThankfulSign", WZUILabelTTF):setText(LocalStrings.SPRINGOUTING_TEXT1[22])
			GetElement(self.m_root, "txtBtnSignSel_CellThankfulSign", WZUILabelTTF):setEnableStroke(false)
		else
			btnReward:setTouchEnable(false)
		end
	elseif self.m_tData.status == 0 then 
		btnReward:setVisible(true)
		btnReward:setTouchEnable(true)
		GetElement(self.m_root, "txtBtnSign_CellThankfulSign", WZUILabelTTF):setText(LocalStrings.FOOTMARK_TEXT29)
		GetElement(self.m_root, "txtBtnSignSel_CellThankfulSign", WZUILabelTTF):setText(LocalStrings.FOOTMARK_TEXT29)
	elseif self.m_tData.status == 1 then 
		btnReward:setTouchEnable(false)
		conDone:setVisible(true)
		if self.m_tData.rewardId == nCurDayIndex then 
			conDone:setAbsContentSize(GlobalMethod:CCSize(182,336))
			conDone:updateRelativeSize()
		end
	end
end