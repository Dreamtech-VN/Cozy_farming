--WndFlyUpFirstData.lua
--@brief	WndFlyUpFirst的数据模块
--@date		2022/12/07
--@author	XTX
--@note		飞升仙界-榜首界面

WndFlyUpFirst = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFlyUpFirst:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nActivityId = nil 
	self.m_tRankChanpionData = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFlyUpFirst:_unInit()
	self.m_root = nil
	self.m_nActivityId = nil 
	self.m_tRankChanpionData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFlyUpFirst:createElement()
	if WndFlyUpFirst.m_root ~= nil then
		WindowManager:removeWindow(WndFlyUpFirst.m_root, WndFlyUpFirst, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFlyUpFirst")
	assert(element, "WndFlyUpFirst create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndFlyUpFirst:showInterface(activityId)
	local wndWater = WndFlyUpFirst:createElement()
	if wndWater then 
		self.m_nActivityId = activityId
		WindowManager:addWindow(wndWater, WndFlyUpFirst, false, nil, nil, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFlyUpFirst:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_nActivityId == activityId then 
		if doType == 2 then 
			local tResult = json.decode(jsonData)
			self:setChanpionRankData(tResult.playerId, tResult.periodNum, tResult.name, tResult.level, tResult.faceId, tResult.headId, tResult.sex, tResult.flyUpNum, tResult.serverId, tResult.bodyId, tResult.wingId, tResult.headColour, tResult.bodycolour, tResult.title, tResult.blueVip)
			local tbList = GetElement(self.m_root,"tbList_WndFlyUpFirst", WZUITableContainer)
			tbList:cleanTable()

			if next(self.m_tRankChanpionData) == nil then
				ShowPanelNullTip( tbList, LocalStrings.CHARM_RESULT)
				return
			end

			for i=1, #self.m_tRankChanpionData do
				local element, tLuaObj = CellFlyupFirstItem:createElement()
				if element and tLuaObj then 
					element:setTag(i - 1)
					tLuaObj:setRankItemData(self.m_tRankChanpionData[i])

					tbList:setCellElement(element)
				end
			end
		end
	end
end

function WndFlyUpFirst:setChanpionRankData(playerId, ranking, name, level, faceId, headId, sex, param1, serverId, bodyId, windId,headColor,bodyColor, title, qqHallInfo)
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

		self.m_tRankChanpionData[i] = temp
	end
	return self.m_tRankChanpionData
end


-------------------------------------私有方法模块End----------------------------------------
--==============冠军子项===================
CellFlyupFirstItem = {}
function CellFlyupFirstItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFlyupFirstItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellFlyupFirstItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(254,400))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellFlyupFirstItem:setRankItemData(data)
	self.m_tChanpionRankData = data
end
--@brief 	开始加载
function CellFlyupFirstItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellFlyupFirstItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setChanpionRankItem()
end

function CellFlyupFirstItem:setChanpionRankItem()
	if not self.m_tChanpionRankData then return end

	local data = self.m_tChanpionRankData

	local txtCurChanpion = GetElement(self.m_root,"txtCurChanpion_CellFlyupFirstItem",WZUILabelTTF)
	txtCurChanpion:setText(string.format(LocalStrings.NEWVIP_TEXT23,tostring(data.ranking)))

	local conContent = GetElement(self.m_root, "conContent_CellFlyupFirstItem", WZUIContainer)
	CreatePlayerLvNameAndBlueIcon(conContent, {0.5, 0.82}, data.level, GlobalMethod:ccc3(255,236,193), GlobalMethod:ccc3(132,66,29), 22, data.qqHallData, data.name, GlobalMethod:ccc3(255,236,193), GlobalMethod:ccc3(132,66,29), 22)
	
	local txtScore = GetElement(self.m_root,"ftxtScore_CellFlyupFirstItem",WZUIFreeTextBox)
	txtScore:setShowText(string.format(LocalStrings.BEINGIMMORTAL_TEXT1[27], data.score))

	local tEquip = {}
    table.insert(tEquip,data.headId)
    table.insert(tEquip,data.faceId)
    table.insert(tEquip,data.bodyId)
    table.insert(tEquip,data.wingId)
	local roleCon = GetElement(self.m_root,"roleCon_CellFlyupFirstItem",WZUIContainer)
	--人物
	local conPlayer = CreatePlayerFigure(data.sex, tEquip, "wait0", nil, nil, nil, nil, nil, nil, nil, data.headColor, data.bodyColor, false)
	roleCon:addChild(conPlayer:getAnimNode())

	--称号
	local sTempTitle,sTitleString
	local title_con = GetElement(self.m_root,"conTitle_CellFlyupFirstItem",WZUIContainer)
	local playerTitle = GetElement(self.m_root,"playerTitle_CellFlyupFirstItem",WZUILabelTTF)
	CreateDesiSpine(title_con, playerTitle, data.title, GlobalMethod:ccp(0.5,0.893))
end

function CellFlyupFirstItem:onBtnCheckRole()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tChanpionRankData then return end
	ProtocolProcessorWndBag:regAll1()
	ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(self.m_tChanpionRankData.playerId)
end
--@return	新建的表实例对象
function CellFlyupFirstItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end