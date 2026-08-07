--CellPrivilegeRankChanpionData.lua
--@brief	CellPrivilegeRankChanpion的数据模块
--@date		2021/04/07
--@author	hyx
--@note		名人榜历届冠军

CellPrivilegeRankChanpion = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellPrivilegeRankChanpion:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRankChanpionData = {}
	self.m_tRankChanpionItem = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPrivilegeRankChanpion:_unInit()
	self.m_root = nil
	self.m_tRankChanpionData = {}
	self.m_tRankChanpionItem = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellPrivilegeRankChanpion:createElement()
	if CellPrivilegeRankChanpion.m_root ~= nil then
		WindowManager:removeWindow(CellPrivilegeRankChanpion.m_root, CellPrivilegeRankChanpion, true)
	end
	local element = WZUISystem:getInstance():createElement("CellPrivilegeRankChanpion")
	assert(element, "CellPrivilegeRankChanpion create element failed!")
	self:_init()
	return element
end

function CellPrivilegeRankChanpion:setChanpionRankData(playerId, ranking, name, level, faceId, headId, sex, param1, param3,bodyId, windId,headColor,bodyColor,worship,title, qqHallInfo)
	for i = 0, ranking:size() - 1 do
		local temp = {}
		temp.ranking   = ranking:get(i)
		temp.playerId   = playerId:get(i)
		temp.name = name:get(i)
		temp.level = level:get(i)
		temp.worship = worship:get(i)
		temp.score = param1:get(i)
		temp.headId   = headId:get(i)
		temp.faceId = faceId:get(i)
		temp.bodyId = tonumber(bodyId:get(i))
		temp.wingId = tonumber(windId:get(i))
		temp.sex = sex:get(i)
		temp.headColor = headColor:get(i)
		temp.bodyColor = bodyColor:get(i)
		temp.title = title:get(i)
		if qqHallInfo and qqHallInfo:get(i) ~= "" then 
			temp.qqHallData = json.decode(qqHallInfo:get(i))
		end

		self.m_tRankChanpionData[i+1] = temp
	end
	table.sort( self.m_tRankChanpionData, function (a,b)
		return a.ranking > b.ranking
	end )
	return self.m_tRankChanpionData
end

--==============冠军子项===================
PrivilegeChanpionRankItem = {}
function PrivilegeChanpionRankItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function PrivilegeChanpionRankItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function PrivilegeChanpionRankItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(296,472))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function PrivilegeChanpionRankItem:setRankItemData(data)
	self.m_tChanpionRankData = data
end
--@brief 	开始加载
function PrivilegeChanpionRankItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("chanpionItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setChanpionRankItem()

	AdaptLanguage(self)
end

function PrivilegeChanpionRankItem:setChanpionRankItem()
	if not self.m_tChanpionRankData then return end

	local data = self.m_tChanpionRankData

	local txtCurChanpion = GetElement(self.m_root,"txtCurChanpion",WZUILabelTTF)
	txtCurChanpion:setText(string.format(LocalStrings.NEWVIP_TEXT23,tostring(data.ranking)))

	CreatePlayerLvNameAndBlueIcon(self.m_root, {0.5, 0.82}, data.level, GlobalMethod:ccc3(255,236,193), GlobalMethod:ccc3(132,66,29), 22, data.qqHallData, data.name, GlobalMethod:ccc3(255,236,193), GlobalMethod:ccc3(132,66,29), 22)
	
	self.m_sTxtShipCount = GetElement(self.m_root,"txtShipCount",WZUIFreeTextBox)
	self:setWorshipNum(data.worship)

	local txtScore = GetElement(self.m_root,"txtScore",WZUILabelTTF)
	txtScore:setText(data.score)

	local tEquip = {}
    table.insert(tEquip,data.headId)
    table.insert(tEquip,data.faceId)
    table.insert(tEquip,data.bodyId)
    table.insert(tEquip,data.wingId)
	local roleCon = GetElement(self.m_root,"roleCon",WZUIContainer)
	--人物
	local conPlayer = CreatePlayerFigure(data.sex, tEquip, "wait0", nil, nil, nil, nil, nil, nil, nil, data.headColor, data.bodyColor, false)
	roleCon:addChild(conPlayer:getAnimNode())

	--称号
	local sTempTitle,sTitleString
	local title_con = GetElement(self.m_root,"title_con",WZUIContainer)
	local playerTitle = GetElement(self.m_root,"playerTitle",WZUILabelTTF)
	if data.title ~= nil and data.title ~= "" then
		local sTitleName = SplitStringWithSeparator(data.title,"&")
        local sNewTitle, nLetterNum = string.gsub(data.title, "&", ",")
        if sTitleName[2] ~= nil and sTitleName[2] ~= "" then
            if tonumber(sTitleName[2]) == nil or nLetterNum > 2 then
                sTitleString = "<"..data.title..">"
            else
                local bExist = WZFileUtil:isFileExist(string.format("ui/common_titleframe_%s", sTitleName[2]) .. ".json")
                if bExist then
                    bTitleStroke = true
                    sTitleString = data.title
                    sTempTitle = sTitleName[1]
                else
                    sTitleString = "<"..data.title..">"
                end
            end
        else
            sTitleString = "<"..data.title..">"
        end            
	else
		sTitleString = LocalStrings.SHOP_NOCHENGHAO
	end
	CreateDesiSpine(title_con, playerTitle, data.title, GlobalMethod:ccp(0.5,0.8))
end

--膜拜个数
function PrivilegeChanpionRankItem:setWorshipNum(num)
	if self.m_sTxtShipCount then
		self.m_sTxtShipCount:setShowText(string.format(LocalStrings.NEWVIP_TEXT22, num))
	end
end

function PrivilegeChanpionRankItem:onBtnRole()
	local btnChanpionContainer = GetElement(self.m_root,"btnChanpionContainer",WZUIContainer)
	if btnChanpionContainer:isVisible() == true then
		btnChanpionContainer:setVisible(false)
	else
		btnChanpionContainer:setVisible(true)
	end
end

function PrivilegeChanpionRankItem:onBtnWorship()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tChanpionRankData then
		ProtocolProcessorWndRankList:send_RANK_Worship(55, self.m_tChanpionRankData.playerId )
		GetElement(self.m_root,"btnChanpionContainer",WZUIContainer):setVisible(false)
	end
end
function PrivilegeChanpionRankItem:onBtnCheckRole()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tChanpionRankData then return end
	WndCheckOther:show(self.m_tChanpionRankData.playerId)
end
--@return	新建的表实例对象
function PrivilegeChanpionRankItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------

function PrivilegeChanpionRankItem:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtShipCount",WZUIFreeTextBox):setMaxWidth(400)
end

---------------------------------------语言适配End------------------------------------------
