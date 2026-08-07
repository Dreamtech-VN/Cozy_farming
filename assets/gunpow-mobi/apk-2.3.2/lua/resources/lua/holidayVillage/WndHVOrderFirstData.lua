--WndHVOrderFirstData.lua
--@brief	WndHVOrderFirst的数据模块
--@date		2023/01/03
--@author	XTX
--@note		鲜花订单历届榜首界面

WndHVOrderFirst = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHVOrderFirst:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRankChanpionData = nil 
	self.m_tSelCell = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHVOrderFirst:_unInit()
	self.m_root = nil
	self.m_tRankChanpionData = nil 
	self.m_tSelCell = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHVOrderFirst:createElement()
	if WndHVOrderFirst.m_root ~= nil then
		WindowManager:removeWindow(WndHVOrderFirst.m_root, WndHVOrderFirst, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHVOrderFirst")
	assert(element, "WndHVOrderFirst create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndHVOrderFirst:showInterface()
	local wndWater = WndHVOrderFirst:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndHVOrderFirst, false, nil, nil, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndHVOrderFirst:onGetOtherData(index, playerIds, serverIds, names, faceIds, headIds, headColors, sexs, levels, vipLevels, title, bodyId, wingId, bodyColor, footmark, blueVipInfo, flower, mobai)
		self:setChanpionRankData(playerIds, index, names, levels, faceIds, headIds, sexs, flower, serverIds, bodyId, wingId, headColors, bodyColor, title, blueVipInfo, mobai)
		local tbList = GetElement(self.m_root,"tbList_WndHVOrderFirst", WZUITableContainer)
		tbList:cleanTable()

		if next(self.m_tRankChanpionData) == nil then
			ShowPanelNullTip( tbList, LocalStrings.CHARM_RESULT)
			return
		end

		for i=1, #self.m_tRankChanpionData do
			local element, tLuaObj = CellOrderFirstItem:createElement()
			if element and tLuaObj then 
				element:setTag(i - 1)
				tLuaObj:setRankItemData(self.m_tRankChanpionData[i])

				tbList:setCellElement(element)
			end
		end
end

function WndHVOrderFirst:setChanpionRankData(playerId, ranking, name, level, faceId, headId, sex, param1, serverId, bodyId, windId,headColor,bodyColor, title, qqHallInfo, mobai)
	self.m_tRankChanpionData = {}

	for i = 1, #ranking do
		local temp = {}
		temp.ranking   = ranking[i]
		temp.playerId   = playerId[i]
		temp.name = name[i]
		temp.level = level[i]
		temp.score = param1[i]
		temp.headId   = headId[i]
		temp.faceId = faceId[i]
		temp.bodyId = tonumber(bodyId[i])
		temp.wingId = tonumber(windId[i])
		temp.sex = sex[i]
		temp.headColor = headColor[i]
		temp.bodyColor = bodyColor[i]
		temp.title = title[i]
		if serverId[i] == CacheCenter:getPlayerInfo().serverId then 
			temp.cross = 0
		else
			temp.cross = 1
		end
		if qqHallInfo and qqHallInfo[i] ~= "" then 
			temp.qqHallData = json.decode(qqHallInfo[i])
		end
		temp.worshipNum = mobai[i]

		self.m_tRankChanpionData[i] = temp
	end
	return self.m_tRankChanpionData
end

--@brief 	膜拜成功
function WndHVOrderFirst:worshipOK(mobaiNum, season, playerId)
	for i = 1, #self.m_tRankChanpionData do
		if self.m_tRankChanpionData[i].ranking == season and self.m_tRankChanpionData[i].playerId == playerId then 
			self.m_tRankChanpionData[i].worshipNum = mobaiNum
			break 
		end
	end
	if self.m_tSelCell then 
		local tData = self.m_tSelCell:getData()
		if tData.playerId == playerId and tData.ranking == season then 
			self.m_tSelCell:setWorshipNum(mobaiNum)
		end
	end

	local nLeftWorshipTimes = WndHVFlowerOrder:getLeftWorshipTimes()
	nLeftWorshipTimes = nLeftWorshipTimes - 1
	WndHVFlowerOrder:setLeftWorshipTimes(nLeftWorshipTimes)
end
-------------------------------------私有方法模块End----------------------------------------
--==============冠军子项===================
CellOrderFirstItem = {}
function CellOrderFirstItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellOrderFirstItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellOrderFirstItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(254,400))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellOrderFirstItem:setRankItemData(data)
	self.m_tChanpionRankData = data
end

--@brief 	获取数据
function CellOrderFirstItem:getData()
	return self.m_tChanpionRankData
end

--@brief 	开始加载
function CellOrderFirstItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellOrderFirstItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setChanpionRankItem()
end

function CellOrderFirstItem:setChanpionRankItem()
	if not self.m_tChanpionRankData then return end

	local data = self.m_tChanpionRankData

	local txtCurChanpion = GetElement(self.m_root,"txtCurChanpion_CellOrderFirstItem",WZUILabelTTF)
	txtCurChanpion:setText(string.format(LocalStrings.NEWVIP_TEXT23,tostring(data.ranking)))

	local conContent = GetElement(self.m_root, "conContent_CellOrderFirstItem", WZUIContainer)
	CreatePlayerLvNameAndBlueIcon(conContent, {0.5, 0.82}, data.level, GlobalMethod:ccc3(255,236,193), GlobalMethod:ccc3(132,66,29), 22, data.qqHallData, data.name, GlobalMethod:ccc3(255,236,193), GlobalMethod:ccc3(132,66,29), 22)
	
	local txtScore = GetElement(self.m_root,"ftxtScore_CellOrderFirstItem",WZUIFreeTextBox)
	txtScore:setShowText(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT3[19], data.score))

	local tEquip = {}
    table.insert(tEquip,data.headId)
    table.insert(tEquip,data.faceId)
    table.insert(tEquip,data.bodyId)
    table.insert(tEquip,data.wingId)
	local roleCon = GetElement(self.m_root,"roleCon_CellOrderFirstItem",WZUIContainer)
	--人物
	local conPlayer = CreatePlayerFigure(data.sex, tEquip, "wait0", nil, nil, nil, nil, nil, nil, nil, data.headColor, data.bodyColor, false)
	roleCon:addChild(conPlayer:getAnimNode())

	--称号
	local sTempTitle,sTitleString
	local title_con = GetElement(self.m_root,"conTitle_CellOrderFirstItem",WZUIContainer)
	local playerTitle = GetElement(self.m_root,"playerTitle_CellOrderFirstItem",WZUILabelTTF)
	CreateDesiSpine(title_con, playerTitle, data.title, GlobalMethod:ccp(0.5,0.893))
	--膜拜次数
	self:setWorshipNum(data.worshipNum)
end

--膜拜个数
function CellOrderFirstItem:setWorshipNum(num)
	local txtShipCount = GetElement(self.m_root, "txtShipCount_CellOrderFirstItem", WZUIFreeTextBox)
	if txtShipCount then
		local strTemp = string.gsub(LocalStrings.NEWVIP_TEXT22, [[S="22"]], [[S="18"]])
		txtShipCount:setShowText(string.format(strTemp, num))
	end
end

function CellOrderFirstItem:onBtnRole()
	local conChanpion = GetElement(self.m_root,"conChanpion_CellOrderFirstItem",WZUIContainer)
	if conChanpion:isVisible() == true then
		conChanpion:setVisible(false)
	else
		conChanpion:setVisible(true)
	end
end

function CellOrderFirstItem:onBtnCheckRole()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tChanpionRankData then return end
	ProtocolProcessorWndBag:regAll1()
	ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(self.m_tChanpionRankData.playerId)
end

function CellOrderFirstItem:onBtnWorship()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nLeftWorshipTimes = WndHVFlowerOrder:getLeftWorshipTimes()
	if self.m_tChanpionRankData.playerId == CacheCenter:getPlayerInfo().id then 
		MsgBoxManager:showTipBox(LocalStrings.CANT_WORSHIP_SELF)
	else
		if nLeftWorshipTimes <= 0 then 
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT3[17])
		else
			if self.m_tChanpionRankData then
				WndHVOrderFirst.m_tSelCell = self
				ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_MobaiFlowerTycoon(self.m_tChanpionRankData.ranking, self.m_tChanpionRankData.playerId)
				GetElement(self.m_root,"conChanpion_CellOrderFirstItem",WZUIContainer):setVisible(false)
			end
		end
	end
end

--@return	新建的表实例对象
function CellOrderFirstItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end