--CellBluePrivilegeData.lua
--@brief	CellBluePrivilege的数据模块
--@date		2022/03/17
--@author	XTX
--@note		蓝钻特权-子活动界面

CellBluePrivilege = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellBluePrivilege:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nActivityType = nil 
	self.m_tRewardList = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellBluePrivilege:_unInit()
	self.m_root = nil
	self.m_nActivityType = nil 
	self.m_tRewardList = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellBluePrivilege:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellBluePrivilege table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellBluePrivilege")
	assert(element, "CellBluePrivilege element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

function CellBluePrivilege:setMessage(activityType, content, activityId, startTime, endTime, serverTime)
	self.m_nActivityType = activityType
	if activityType ~= 999999 then 
		self.m_tRewardList = {}
		local tTempList = {}
		WZLog("CellBluePrivilege:setMessage Zero", activityType, content, activityId, startTime, endTime, serverTime)
		local configList = json.decode(content)
		WZLog("CellBluePrivilege:setMessage", Serialize(configList))
		if activityType == g_tGameActivityTypes.ACTIVITY_BULEPRIVILEGE_NEWGIFT then 
			local tRewards = json.decode(configList.rewardItems)
			local tDesc = json.decode(configList.rewardDecs)
			for i = 1, #tRewards do 
				local tItem = {}
				tItem.rewardId = i
				tItem.status = configList.giftState
				tItem.activityId = activityId
				tItem.rewardItemId = {}
				tItem.rewardItemNum = {}
				tItem.desc = tDesc[i]
				tItem.level = tonumber(key)
				tItem.attDesc = tDesc[i]

				local nSex = CacheCenter:getPlayerInfo().sex
		        local ids, nums = SplitItemString(tRewards[i], nSex)
				for j = 1, #ids do
					table.insert(tItem.rewardItemId, tonumber(ids[j]))
					table.insert(tItem.rewardItemNum, tonumber(nums[j]))
				end 

				table.insert(tTempList, tItem)
			end
		else
			for key, value in pairs(configList.rewardItems) do 
				local tItem = {}
				tItem.rewardId = tonumber(key)
				tItem.status = configList.giftState[key]
				tItem.activityId = activityId
				tItem.rewardItemId = {}
				tItem.rewardItemNum = {}
				tItem.desc = configList.rewardDecs[key]
				tItem.level = tonumber(key)
				tItem.attDesc = configList.rewardDecs[key]

				local nSex = CacheCenter:getPlayerInfo().sex
		        local ids, nums = SplitItemString(value, nSex)
				for j = 1, #ids do
					table.insert(tItem.rewardItemId, tonumber(ids[j]))
					table.insert(tItem.rewardItemNum, tonumber(nums[j]))
				end 

				table.insert(tTempList, tItem)
			end

			table.sort(tTempList, function (a, b) 
				return a.rewardId < b.rewardId
			end )
		end
		if activityType == g_tGameActivityTypes.ACTIVITY_BULEPRIVILEGE_DAYGIFT then 
			local qqHallData = CacheCenter:getPlayerInfo().qqHallData
			if qqHallData and qqHallData.is_blue_vip then 
				for i = 1, #tTempList do
					if tTempList[i].rewardId == qqHallData.blue_vip_level then 
						table.insert(self.m_tRewardList, tTempList[i])
					elseif i > #tTempList - 2 then 
						table.insert(self.m_tRewardList, tTempList[i])
					end
				end
			else
				for i = 1, #tTempList do
					if tTempList[i].rewardId == 1 then 
						table.insert(self.m_tRewardList, tTempList[i])
					elseif i > #tTempList - 2 then 
						table.insert(self.m_tRewardList, tTempList[i])
					end
				end
			end
		else
			self.m_tRewardList = tTempList
		end
	end
	--WZLog("CellBluePrivilege:setMessage 111", Serialize(self.m_tRewardList))
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellBluePrivilege:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------

CellBlueDayGiftItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellBlueDayGiftItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_nActivityType = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellBlueDayGiftItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_nActivityType = nil 
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellBlueDayGiftItem:onEnter(element)
	self.m_root = element
	CellBlueDayGiftItem.m_click_current = self
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellBlueDayGiftItem:onExit(element)
	self:_unInit()
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellBlueDayGiftItem:createElement(conSize)
	local tNewObj = self:_new()
	assert(tNewObj, "CellBlueDayGiftItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	assert(element, "CellBlueDayGiftItem element create failed!")
	element:setUseAbsSize(true)
	element:setAbsContentSize(conSize) 
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

function CellBlueDayGiftItem:onLoadData( element )
	local nodeName = "CellDayGiftItem_CellBulePrivilege"
	if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_BULEPRIVILEGE_GROWGIFT then 
		nodeName = "CellGrowGiftItem_CellBulePrivilege"
	end
	local ele = WZUISystem:getInstance():createElement(nodeName)
	ele:setVisible(true)
	self.m_root:addChild(ele)
	self:ShowCellItem()
end

--@breif 设置数据
function CellBlueDayGiftItem:setData(tData, activityType)
	self.m_tData = tData
	self.m_nActivityType = activityType
end

--@brief    加载item
function CellBlueDayGiftItem:ShowCellItem(  )
    self:_initItemMsg()
    self:_setRewardList()
end

--@brief	领取按钮的回调方法
function CellBlueDayGiftItem:onGetReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    self.m_nloadingId = MsgBoxManager:showLoadingBox()
    WZLog("CellBlueDayGiftItem:self.m_nloadingId",self.m_nloadingId)
    CellBlueDayGiftItem.m_current_click = self
    --发送领取奖励协议
    local tData = {}
    tData.rewardKey = self.m_tData.rewardId
    local strJson = json.encode(tData)
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tData.activityId, 1, strJson)
end

--@brief 	点击叹号按钮回调
function CellBlueDayGiftItem:onClickAtt(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {}
	tData.attDesc = self.m_tData.attDesc
	WndTips:show(element, WndBluePrivilege.m_root, 81, tData, nil, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellBlueDayGiftItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@breif    设置Item显示的信息
function CellBlueDayGiftItem:_initItemMsg( )
	--WZLog("CellBlueDayGiftItem:_initItemMsg", Serialize(self.m_tData))
	if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_BULEPRIVILEGE_DAYGIFT then 
	    local descFreeText = GetElement(self.m_root, "descFreeText_CellDayGiftItem", WZUIFreeTextBox)
	    local strFormat = [[<T C="127,70,26" S="20" P="1" SC="132,66,29" SE="0" SS="4">%s</T>]]
	    descFreeText:setShowText(string.format(strFormat, self.m_tData.desc))
	    local btnAtt = GetElement(self.m_root, "btnAtt_CellDayGiftItem", WZUIButton)
	    if btnAtt and tonumber(self.m_tData.status) == -1 then 
	    	btnAtt:setVisible(true)
	    end
	elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_BULEPRIVILEGE_GROWGIFT then 
		local txtLevelWord = GetElement(self.m_root, "txtLevelWord_CellGrowGiftItem", WZUILabelTTF)
		if txtLevelWord then 
			txtLevelWord:setText(self.m_tData.desc)
		end
	end

    local imgGetState = GetElement(self.m_root,"img_get_CellDayGiftItem", WZUIImage)
    local txt_buttonNor = GetElement(self.m_root,"txt_buttonNor_CellDayGiftItem", WZUILabelTTF)
    local txt_buttonSel = GetElement(self.m_root,"txt_buttonSel_CellDayGiftItem", WZUILabelTTF)
    local txt_buttonEna = GetElement(self.m_root,"txt_buttonEna_CellDayGiftItem", WZUILabelTTF)
    local btnGetReward = GetElement(self.m_root, "btnGetReward_CellDayGiftItem", WZUIButton)

    if -1 == tonumber(self.m_tData.status) then
        btnGetReward:setTouchEnable(false)
        imgGetState:setVisible(false)
        txt_buttonNor:setText(LocalStrings.NEWFIRSTCHARGE_TEXT5)
        txt_buttonSel:setText(LocalStrings.NEWFIRSTCHARGE_TEXT5)
        txt_buttonEna:setText(LocalStrings.NEWFIRSTCHARGE_TEXT5)
    elseif tonumber(self.m_tData.status) == 0 then
        btnGetReward:setTouchEnable(true)
        imgGetState:setVisible(false)
        txt_buttonNor:setText(LocalStrings.ACTIVE_BTN_GET)
        txt_buttonSel:setText(LocalStrings.ACTIVE_BTN_GET)
        txt_buttonEna:setText(LocalStrings.ACTIVE_BTN_GET)
    elseif tonumber(self.m_tData.status) == 1 then
        imgGetState:setVisible(true)
        btnGetReward:setVisible(false)
    end
end

--@brief    显示奖励图标
function CellBlueDayGiftItem:_setRewardList(  )
    local ItemCount = #self.m_tData.rewardItemId
    local conItems = GetElement(self.m_root, "conItems_CellDayGiftItem", WZUIContainer)
    local nStartX = 0.08
    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_BULEPRIVILEGE_GROWGIFT then 
    	nStartX = 0.28
    end
    local nGapping = 0.13
    for i = 1, ItemCount do
        local celElement,tLuaObj = CellGoodItem:createElement()
        if celElement and tLuaObj then 
            tLuaObj:setCellGoodLocalId(self.m_tData.rewardItemId[i], self.m_tData.rewardItemNum[i], 17)
 
            celElement:setTag(i-1)
            tLuaObj:setItemClickFun(self, self.onOthersClick)
            celElement:setRelativePosition(GlobalMethod:ccp(nStartX + (i - 1) * nGapping, 0.5))
        	conItems:addChild(celElement)
        end
    end
end

--@brief    点击Item时回调tips
function CellBlueDayGiftItem:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,WndBluePrivilege.m_root,1,tData,false, nil, true)
end