--CellNewYearTaskDayData.lua
--@brief	CellNewYearTaskDay的数据模块
--@date		2020/12/01
--@author	hyx
--@note		元旦每日任务

CellNewYearTaskDay = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellNewYearTaskDay:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tTaskDayData = {}
	self.m_tDayTaskItemCell = {}
	self.m_nType = 0 
	self.m_tOtherData = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewYearTaskDay:_unInit()
	self.m_root = nil
	self.m_tTaskDayData = nil 
	self.m_tDayTaskItemCell = nil 
	self.m_nType = nil 
	self.m_tOtherData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellNewYearTaskDay:createElement(data, nType, otherData)
	if CellNewYearTaskDay.m_root ~= nil then
		WindowManager:removeWindow(CellNewYearTaskDay.m_root, CellNewYearTaskDay, true)
	end
	local element = WZUISystem:getInstance():createElement("CellNewYearTaskDay")
	assert(element, "CellNewYearTaskDay create element failed!")
	self:_init()
	self.m_tTaskDayData = data
	self.m_nType = nType
	self.m_tOtherData = otherData
	return element
end

--================== 任务子项 ========================
CellNewYearTaskItem = {}
function CellNewYearTaskItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGoodItemCell = {}
	self.m_nTaskRewardId = nil
	self.m_nType = nil 
	self.m_bIsLoaded = false 
	self.m_tOtherData = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewYearTaskItem:_unInit()
	self.m_root = nil
	self.m_tGoodItemCell = nil 
	self.m_nTaskRewardId = nil
	self.m_nType = nil 
	self.m_bIsLoaded = nil 
	self.m_tOtherData = nil 
end

--@brief	创建控件
function CellNewYearTaskItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,122))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellNewYearTaskItem:setGiftBuyMessage(index, data, nType, otherData)
	self.m_nIndex = index
	self.m_tTaskItemData = data
	self.m_nType = nType 
	self.m_tOtherData = otherData
end

--@brief 	开始加载
function CellNewYearTaskItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellNewYearItem")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:setTaskDayDataItem()
end

function CellNewYearTaskItem:setTaskDayDataItem()
	if not self.m_tTaskItemData then return end
	local data = self.m_tTaskItemData

	self.m_tGoodItemCell = {}
	self:setTaskItemMessage(self.m_nIndex,data)
end
function CellNewYearTaskItem:setTaskItemMessage(index,data)
	--0=不可领取|1=可领取|2=已领取
	self.m_nIndex = index
	self.m_tTaskItemData = data
	if not self.m_bIsLoaded then return end 
	if self.m_nType and (self.m_nType == 13 or self.m_nType == 37) then 
		GetElement(self.m_root, "img9Bg_CellNewYearItem", WZUI9Image):setFile("ui/common/frame_lieb_03.png")
		GetElement(self.m_root, "img9Title_CellNewYearItem", WZUI9Image):setFile("ui/activity/title_frame_10.png")
	elseif self.m_nType and self.m_nType == 26 then 
		GetElement(self.m_root, "img9Bg_CellNewYearItem", WZUI9Image):setFile("ui/common/frame_lieb_09.png")
		GetElement(self.m_root, "img9Title_CellNewYearItem", WZUI9Image):setFile("ui/common/title_frame_32.png")
	elseif self.m_nType and self.m_nType == 28 then 
		GetElement(self.m_root, "img9Bg_CellNewYearItem", WZUI9Image):setFile("ui/common/frame_lieb_03.png")
		GetElement(self.m_root, "img9Title_CellNewYearItem", WZUI9Image):setFile("ui/common/title_frame_31.png")
	elseif self.m_nType and (self.m_nType == 41 or self.m_nType == 45 or self.m_nType == 46 or self.m_nType == 49 or self.m_nType == 50 or self.m_nType == 54) then 
		GetElement(self.m_root, "img9Bg_CellNewYearItem", WZUI9Image):setFile("ui/common/frame_lieb_10.png")
		GetElement(self.m_root, "img9Title_CellNewYearItem", WZUI9Image):setFile("ui/common/title_frame_36.png")
	elseif self.m_nType and self.m_nType == 60 then 
		if self.m_tOtherData.itemImg9Bg then 
			GetElement(self.m_root, "img9Bg_CellNewYearItem", WZUI9Image):setFile(self.m_tOtherData.itemImg9Bg)
		end
		if self.m_tOtherData.itemImg9Title then 
			GetElement(self.m_root, "img9Title_CellNewYearItem", WZUI9Image):setFile(self.m_tOtherData.itemImg9Title)
		end
	end
	GetElement(self.m_root,"btnGoto",WZUIButton):setVisible(data.status == 0)
	GetElement(self.m_root,"btnGet",WZUIButton):setVisible(data.status == 1)
	GetElement(self.m_root,"imgGet",WZUIImage):setVisible(data.status == 2)
	if self.m_tTaskItemData.activityId and g_cityExtenInfo and (self.m_tTaskItemData.activityId == g_cityExtenInfo.activity7115 or self.m_tTaskItemData.activityId == g_cityExtenInfo.activity7119) then 
		if data.group_by and data.group_by == 3 then 
			local txtGet1 = GetElement(self.m_root, "txtGet1_CellNewTearTaskDay", WZUILabelTTF)
			txtGet1:setTextKey("")
			txtGet1:setText(string.format(LocalStrings.FOURYEAR_TEXT11, data.param2))
			local txtGet2 = GetElement(self.m_root, "txtGet2_CellNewTearTaskDay", WZUILabelTTF)
			txtGet2:setTextKey("")
			txtGet2:setText(string.format(LocalStrings.FOURYEAR_TEXT11, data.param2))

			local txtGoto1 = GetElement(self.m_root, "txtGoto1_CellNewTearTaskDay", WZUILabelTTF)
			txtGoto1:setTextKey("")
			txtGoto1:setText(string.format(LocalStrings.FOURYEAR_TEXT11, data.param2))
			local txtGoto2 = GetElement(self.m_root, "txtGoto2_CellNewTearTaskDay", WZUILabelTTF)
			txtGoto2:setTextKey("")
			txtGoto2:setText(string.format(LocalStrings.FOURYEAR_TEXT11, data.param2))
			local txtGoto3 = GetElement(self.m_root, "txtGoto3_CellNewTearTaskDay", WZUILabelTTF)
			txtGoto3:setTextKey("")
			txtGoto3:setText(string.format(LocalStrings.FOURYEAR_TEXT11, data.param2))
			if data.status == 0 then 
			    GetElement(self.m_root,"btnGoto",WZUIButton):setTouchEnable(false)
			end
			GetElement(self.m_root, "txtTimes_CellNewYearTaskDay", WZUILabelTTF):setText(string.format(LocalStrings.FOURYEAR_TEXT11, data.param2))
			GetElement(self.m_root,"imgGet",WZUIImage):setVisible(false)
			GetElement(self.m_root,"conOtherGet_CellNewYearTaskDay", WZUIContainer):setVisible(data.status == 2)
		end
	end
	local txtDescTitle = GetElement(self.m_root,"txtDescTitle",WZUILabelTTF)
	local ftxtDescTitle = GetElement(self.m_root, "ftxtDescTitle_CellNewYearItem", WZUIFreeTextBox)
	if string.find(data.desc, "<T") == nil then
		txtDescTitle:setText(data.desc)
	else
		ftxtDescTitle:setShowText(data.desc)
	end

	self.m_nTaskRewardId = data.id
	for i=1,6 do --最大6个奖励
		if self.m_tGoodItemCell and self.m_tGoodItemCell[i] and self.m_tGoodItemCell[i].celElement then
			self.m_tGoodItemCell[i].celElement:setVisible(false)
		end
	end
	local good_con = GetElement(self.m_root,"good_con",WZUIContainer)
	WZLog("CellNewYearTaskItem:setTaskItemMessage", Serialize(data.ids))
	for i=1, #data.ids do
		local key = "id_"..data.ids[i]
		local tabItem = GDatatab_item[key]
		local num = data.nums[i]
		if data.activityId and g_cityExtenInfo and (data.activityId == g_cityExtenInfo.activity7115 or data.activityId == g_cityExtenInfo.activity7119) and data.group_by == 3 then 
			num = num/data.param2
		end
		local origin = nil
		if self.m_tOtherData and self.m_tOtherData.origin then 
			origin = self.m_tOtherData.origin
		end
		local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key]), origin = origin}
		if self.m_tGoodItemCell == nil or self.m_tGoodItemCell[i] == nil then
			if self.m_tGoodItemCell == nil then 
				self.m_tGoodItemCell = {}
			end
			local celElement,tLuaObj = CellGoodItem:createElement()
			good_con:addChild(celElement)
			celElement:setScale(0.85)
			celElement:setUseAbsCoordinate(true)
			local tab = {}
			tab.celElement = celElement
			tab.tLuaObj = tLuaObj
			self.m_tGoodItemCell[i] = tab
		end
		if self.m_tGoodItemCell[i] and self.m_tGoodItemCell[i].celElement and self.m_tGoodItemCell[i].tLuaObj then
			local celElement = self.m_tGoodItemCell[i].celElement
			local tLuaObj = self.m_tGoodItemCell[i].tLuaObj
			tLuaObj:setCellGoodItem(itemInfo, 17)
			tLuaObj:setItemClickFun(CellNewYearTask,self.onItemClick)
			local _x = 35 + (i-1) * 85
			celElement:setAbsPosition(GlobalMethod:ccp(_x, 40))
			celElement:setVisible(true)
		end
	end
end
--@brief	点击物品弹出对应的tips
function CellNewYearTaskItem:onItemClick(tCell,tag,tData)
      if tData == nil then
            return
      end
      WndItemInfo:onCloseClick()
      if WndShopRank and WndShopRank.m_root then 
   		WndItemInfo:showInfo(tCell.m_root,WndShopRank.m_root,1,tData,false,nil,true)
      elseif WndHouseInvite and WndHouseInvite.m_root then 
   		WndItemInfo:showInfo(tCell.m_root,WndHouseInvite.m_root,1,tData,false,nil,true)
      else
   		WndItemInfo:showInfo(tCell.m_root,CellNewYearTask.m_root,1,tData,false,nil,true)
   	end
end
function CellNewYearTaskItem:onBtnGoto()
	local data = self.m_tTaskItemData
	if data and data.script and type(data.script) == "table" and data.script[1][1] > 0 then 
		local mainId = data.script[1][1]
		if mainId == 27 then --公会
        	SceneCommunity:onJumpToCommunity()
		elseif mainId == 192 and CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().guildId == 0 then --公会副本
			SceneCommunity:onJumpToCommunity()
		elseif mainId > 0 then
			if self.m_nType == 14 then 
				CellNewYearTask:onBtnClickClose()
			end
			JumpByUIId(mainId)
		end
	else
		CellNewYearTask:onBtnClickClose()
	end
end
function CellNewYearTaskItem:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nType == 0 then 
		if self.m_nTaskRewardId then
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_Activity6120ReceiveTaskReward(tonumber(self.m_nTaskRewardId))
		end
	else 
		WZLog("CellNewYearTaskItem:onBtnGet", self.m_tTaskItemData.activityId, self.m_nTaskRewardId)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_tTaskItemData.activityId, self.m_nTaskRewardId)
	end
end
--@return	新建的表实例对象
function CellNewYearTaskItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
