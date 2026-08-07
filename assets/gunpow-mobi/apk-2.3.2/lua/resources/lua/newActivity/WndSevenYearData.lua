--WndSevenYearData.lua
--@brief	WndSevenYear的数据模块
--@date		2023/05/23
--@author	XTX
--@note		七周年签到活动主界面

WndSevenYear = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSevenYear:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nActivityId = nil
	self.m_nCurDay = 0
	self.m_tRewardList = nil 
	self.m_nInterfaceIndex = nil 	--界面索引
	self.m_tCellItem = nil 	
	self.m_tContent = nil 
	self.m_tResignCost = nil 		--补卡消耗
	self.m_tMsgData = nil 
	self.m_nMakeupTimes = 0 		--当前补签次数
	self.m_nShowItemId = nil 		--特别展示的物品Id
	self.m_nSignDays = 0  			--已签到天数
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSevenYear:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_nActivityId = nil
	self.m_nCurDay = nil 
	self.m_tRewardList = nil 
	self.m_nInterfaceIndex = nil  	--界面索引
	self.m_tCellItem = nil 	
	self.m_tContent = nil 
	self.m_tResignCost = nil 		--补卡消耗
	self.m_tMsgData = nil 
	self.m_nMakeupTimes = nil  		--当前补签次数
	self.m_nShowItemId = nil 
	self.m_nSignDays = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSevenYear:createElement()
	if WndSevenYear.m_root ~= nil then
		WindowManager:removeWindow(WndSevenYear.m_root, WndSevenYear, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSevenYear")
	assert(element, "WndSevenYear create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndSevenYear:showInterface(nIndex, tMsg)
	LoadNewActivityRes(true)
	local wndWater = WndSevenYear:createElement()
	if wndWater then 
		self.m_nInterfaceIndex = nIndex or 1
		self.m_tMsgData = tMsg
		WindowManager:addWindow(wndWater, WndSevenYear, false, nil, nil, true)
	end
end

--@brief 	获取活动详情成功
function WndSevenYear:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndSevenYear:GetActivityInfoOK", content)
	if g_cityExtenInfo.activity7078 == activityId then 
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		self.m_tContent = json.decode(content)
		self.m_tResignCost = json.decode(self.m_tContent.signConfig)
		WZLog("WndSevenYear:GetActivityInfoOK", Serialize(self.m_tContent), Serialize(self.m_tResignCost))

		self:_analyzeBigReward()
		self:_initActivityTime()
		self:_getShowItemId()
		self:_showEffect()
	end
end

--@brief 	获取活动当前
function WndSevenYear:getCurDay()
	return self.m_nCurDay
end

--@brief 	获取活动总天数
function WndSevenYear:getTotalDays()
	return #self.m_tRewardList
end

--@brief 	获取活动总天数
function WndSevenYear:getResignCost()
	return self.m_tResignCost
end

--@brief 	获取其他活动数据
function WndSevenYear:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --额外数据
		local tResult = json.decode(jsonData)
		WZLog("WndSevenYear:_onGetOtherData 111", Serialize(tResult))
		self.m_nSignDays = 0
		for i = 1, #tResult.signStatus do
			self.m_tRewardList[i].status = tResult.signStatus[i]
			if tResult.signStatus[i] == 1 then 
				self.m_nSignDays = self.m_nSignDays + 1
			end
		end
		self.m_nMakeupTimes = tResult.buSignNum
		self.m_nCurDay = tResult.day
		self:_update()
	elseif doType == 2 then --补签成功
		local tResult = json.decode(jsonData)
		WZLog("WndSevenYear:_onGetOtherData 222", Serialize(tResult))
		if result == 0 then 
			WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
			self.m_tRewardList[tResult.day + 1].status = 1
			if self.m_tCellItem and self.m_tCellItem[tResult.day + 1] then 
				self.m_tCellItem[tResult.day + 1]:updateStatue(1)
			end
			self.m_nSignDays = self.m_nSignDays + 1
			self.m_nMakeupTimes = tResult.buSignNum
		end
	end
end

--@brief    添加保存是否主动弹感恩打卡活动设置
function WndSevenYear:saveAutoActivity(nValue)
    WZLog("WndSevenYear:saveAutoActivity")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "SEVENYEAR" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    local curValue = string.format("%02d%02d_%d", curDate.month, curDate.day, nValue)
    if strValue == nil or strValue == "" or strValue ~= curValue then
        data:setStringValue("CALABASH_MARK", _KeyString, curValue)
        data:flush()
    end
end

--@brief    获取上次保存的感恩打卡活动设置
function WndSevenYear:getAutoActivity()
    WZLog("WndSevenYear:getAutoActivity")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "SEVENYEAR" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    local curValue = string.format("%02d%02d", curDate.month, curDate.day)
    if strValue ~= nil and strValue ~= "" then
        local result = SplitStringWithSeparator(strValue, "_")
        if result[1] == curValue then 
            GlobalGame.g_autoSevenYear = tonumber(result[2]) == 0 
            return tonumber(result[2])
        end
    end

    return 0
end

--@brief    添加保存已签到天数
function WndSevenYear:saveHavedSignDays(nValue)
    WZLog("WndSevenYear:saveHavedSignDays")
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "SEVENYEARDays" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    local curValue = tostring(self.m_nActivityId) .. "_" .. nValue
    
    data:setStringValue("CALABASH_MARK", _KeyString, curValue)
    data:flush()
end

--@brief    获取上次保存的已打卡天数
function WndSevenYear:getHavedSignDays()
    WZLog("WndSevenYear:getHavedSignDays")
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "SEVENYEARDays" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    if strValue ~= nil and strValue ~= "" then
        local result = SplitStringWithSeparator(strValue, "_")
        if tonumber(result[1]) == tonumber(g_cityExtenInfo.activity7078) and result[2] == "T" then 
        	GlobalGame.g_autoSevenYear = false
        end
        return result[1], result[2]
    end

    return nil, nil 
end

--@brief 	获取补卡次数
function WndSevenYear:getMakeupTimes()
	return self.m_nMakeupTimes
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	解析大奖数据
function WndSevenYear:_analyzeBigReward()
	-- body
	local tBigReward = json.decode(self.m_tContent.signRewards)
	local nSex = CacheCenter:getPlayerInfo().sex

	self.m_tRewardList = {}
	for j = 1, #tBigReward do
		local array = SplitStringWithSeparator(tBigReward[j], "&")
		local tItem = {}
		tItem.rewardId = j
		tItem.status = -1
		tItem.reward = {}
		for i = 1, #array do
			local strTemp = string.sub(array[i], 2, -2) 
			local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
			local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])

			local rewardItem = {}
			rewardItem[1] = id
			rewardItem[2] = num

			table.insert(tItem.reward, rewardItem)
		end

		table.insert(self.m_tRewardList, tItem)
	end
end

--获取配置的头像框物品Id
function  WndSevenYear:_getShowItemId()
	-- body
	local sShowReward = self.m_tContent.UIRewardConfig
	local array = SplitStringWithSeparator(sShowReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	for i = 1, #array do
		local strTemp = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(strTemp,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(strTemp,",")[3])

		local basicInfo = GDatatab_item["id_" .. id]
		if basicInfo and basicInfo.main_type == 40 then 
			self.m_nShowItemId = id
			break 
		end
	end
end


-------------------------------------私有方法模块End----------------------------------------
CellSevenYearSignItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellSevenYearSignItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil
	self.m_bIsLoaded = false
	self.m_nType = 1
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellSevenYearSignItem:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bIsLoaded = nil 
	self.m_nType = nil 
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellSevenYearSignItem:createElement(ccSize)
	local tNewObj = self:_new()
	assert(tNewObj, "CellSevenYearSignItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellSevenYearSignItem")
	if ccSize then 
		element:setAbsContentSize(ccSize)
	else
		element:setAbsContentSize(GlobalMethod:CCSize(228,208))
	end
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	 设置数据
function CellSevenYearSignItem:setData(tData, nType)
	-- body
	self.m_tData = tData 
	self.m_nType = nType
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellSevenYearSignItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSevenYearSignItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSevenYearSignItem:onExit(element)
	self:_unInit()
end

--@brief 加载
function CellSevenYearSignItem:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellSevenYearSignItem")
	celElement:setVisible(true)
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true 
    self:_update()
end

--@brief 	加载
function CellSevenYearSignItem:loadData()
	local strNodeName = "CellSevenYearSignItem"
	if self.m_nType == 2 then 
		strNodeName = "CellSevenYearSignItemH"
	end
	local celElement = WZUISystem:getInstance():createElement(strNodeName)
	celElement:setVisible(true)
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true 
    self:_update()
end

--@brief 	点击打卡按钮回调
function CellSevenYearSignItem:onClickSign(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

	local nActivityId = WndSevenYear.m_nActivityId
	
	local tData = {}
	tData.day = self.m_tData.rewardId - 1

	local stringData = json.encode(tData)
	if self.m_tData.status == 0 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(nActivityId, 2, stringData)
	else
		WZLog("CellSevenYearSignItem:onClickSign")
		local strContent = LocalStrings.SEVENYEAR_TEXT1[3]
		local costFormat = [[<I Z="0.5" P="1">%s</I><T C="127,70,26" S="22" P="1">*%d</T>]]
		local resignCost = WndSevenYear:getResignCost()

		local makeupTimes = WndSevenYear:getMakeupTimes()
		local basicInfo = GDatatab_item["id_" .. resignCost[1]]
		local tempStr = string.format(costFormat, basicInfo.icon, resignCost[2] + resignCost[3] * makeupTimes)

		strContent = strContent .. tempStr

		strContent = strContent .. LocalStrings.SEVENYEAR_TEXT1[4]
		local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.NEWSINGIN5, bgPath = "ui/newActivity/hd_pic_hyhl_tc_xiao.png", bShowClose = true}
		MsgBoxManager:showConfirmBox(strContent, self, self.sureToResign, nil, tCustomUIConfig, true)
	end
end

--@brief 	点击打卡按钮回调
function CellSevenYearSignItem:sureToResign(element)
	local resignCost = WndSevenYear:getResignCost()
	local makeupTimes = WndSevenYear:getMakeupTimes()
	if not JudgeMoneyIsEnough(resignCost[1], resignCost[2] + resignCost[3] * makeupTimes, nil, nil, nil, nil, nil, nil, nil, self, self.sureToUseBlueDia) then 
		return 
	end
	self:sureToUseBlueDia()
end

--@brief 	确定购买
function CellSevenYearSignItem:sureToUseBlueDia()
	-- body
	WZLog("CellSevenYearSignItem:sureToUseDiamond")
	local nActivityId = WndSevenYear.m_nActivityId
	local tData = {}
	tData.day = self.m_tData.rewardId - 1
	
	local stringData = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(nActivityId, 2, stringData)
end

--@brief    刷新
function CellSevenYearSignItem:_update()
	WZLog("CellSevenYearSignItem:_update", Serialize(self.m_tData))
	--body
	local ftxtDay = GetElement(self.m_root, "ftxtDay_CellSevenYearSignItem", WZUIFreeTextBox)
	local nCurDays = WndSevenYear:getCurDay()
	local bIsCurDay = false 
	if ftxtDay then 
		if self.m_tData.status == 0 or self.m_tData.rewardId == nCurDays then 
			if self.m_nType == 1 then 
				GetElement(self.m_root, "imgBk_CellSevenYearSignItem", WZUIImage):setFile("ui/specialBg/common_7zn_di_02.png")
			else
				GetElement(self.m_root, "imgBk_CellSevenYearSignItem", WZUIImage):setFile("ui/specialBg/common_7zn_di_04.png")
			end
			ftxtDay:setShowText(string.format(LocalStrings.SEVENYEAR_TEXT1[2], self.m_tData.rewardId))
			bIsCurDay = true 
		else
			local strNewFormat = LocalStrings.SEVENYEAR_TEXT1[2]
			ftxtDay:setShowText(string.format(strNewFormat, self.m_tData.rewardId))
		end
	end
	self:updateStatue()
	--奖励
	local conReward = GetElement(self.m_root, "conReward_CellSevenYearSignItem", WZUIContainer)
	conReward:removeAllChildrenWithCleanup(true)
	local nStartX = 0.25 
	local nStartY = 0.82 
	local nGappingX = 0.5
	local nGappingY = 0.32
	local nScale = 1

	for i = 1, #self.m_tData.reward do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			tNewObj:setCellGoodLocalId(self.m_tData.reward[i][1], self.m_tData.reward[i][2], 17)
			tNewObj:setItemClickFun(self, self.onItemClick)
			if self.m_nType == 1 then 
				element:setRelativePosition(GlobalMethod:ccp(nStartX + (i - 1)*nGappingX, 0.5))
			else
				element:setRelativePosition(GlobalMethod:ccp(0.5, nStartY - (i - 1)*nGappingY))
			end
			if bIsCurDay then 
				tNewObj:setBackImgFile("ui/newActivity/common_7zn_tbd_02.png", nil, nil, GlobalMethod:ccp(0.55, 0.42))			
			else
				tNewObj:setBackImgFile("ui/newActivity/common_7zn_tbd_01.png", nil, nil, GlobalMethod:ccp(0.55, 0.42))			
			end
			tNewObj:setQualityFrameVisible(false)
			element:setScale(nScale)
			conReward:addChild(element)
		end
	end
end

function CellSevenYearSignItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    local rootTemp = WndSevenYear.m_root

   	WndItemInfo:showInfo(tCell.m_root, rootTemp,1,tData,false,nil,true)
end

--@brief 	修改奖励状态
function CellSevenYearSignItem:updateStatue(status)
	if status then
		self.m_tData.status = status
	end
	if self.m_bIsLoaded == false then return end 

	local conDone = GetElement(self.m_root, "conDone_CellSevenYearSignItem", WZUIContainer)
	local btnReward = GetElement(self.m_root, "btnSign_CellSevenYearSignItem", WZUIButton)
	if self.m_tData.status == -1 then 
		btnReward:setVisible(true)
		btnReward:setTouchEnable(false)
	elseif self.m_tData.status == 0 then 
		btnReward:setVisible(true)
		btnReward:setTouchEnable(true)
		GetElement(self.m_root, "txtBtnSign_CellSevenYearSignItem", WZUILabelTTF):setText(LocalStrings.SEVENYEAR_TEXT1[5])
		GetElement(self.m_root, "txtBtnSignSel_CellSevenYearSignItem", WZUILabelTTF):setText(LocalStrings.SEVENYEAR_TEXT1[5])
	elseif self.m_tData.status == 1 then 
		btnReward:setTouchEnable(false)
		conDone:setVisible(true)
	elseif self.m_tData.status == 2 then 
		btnReward:setTouchEnable(true)
		GetElement(self.m_root, "imgBtnSign_CellSevenYearSignItem", WZUIImage):setFile("ui/common/common_btn_06_1.png")
		GetElement(self.m_root, "imgBtnSignSel_CellSevenYearSignItem", WZUIImage):setFile("ui/common/common_btn_06_1.png")
		GetElement(self.m_root, "txtBtnSign_CellSevenYearSignItem", WZUILabelTTF):setText(LocalStrings.NEWSINGIN5)
		GetElement(self.m_root, "txtBtnSign_CellSevenYearSignItem", WZUILabelTTF):setStrokeColor(GlobalMethod:ccc3(0,112,202))
		GetElement(self.m_root, "txtBtnSignSel_CellSevenYearSignItem", WZUILabelTTF):setText(LocalStrings.NEWSINGIN5)
		GetElement(self.m_root, "txtBtnSignSel_CellSevenYearSignItem", WZUILabelTTF):setStrokeColor(GlobalMethod:ccc3(0,112,202))
	end
end