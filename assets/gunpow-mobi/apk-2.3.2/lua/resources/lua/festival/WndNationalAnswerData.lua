--WndNationalAnswerData.lua
--@brief	WndNationalAnswer的数据模块
--@date		2020/09/08
--@author	hyx
--@note		趣味答题

WndNationalAnswer = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndNationalAnswer:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sAnswerResult = nil
	self.m_nChangeCurIndex = 1
	self.m_tChangeContainerList = {}
	--排行
	self.m_tChangeRankTitleList = {} --排行头部信息存储
	self.m_nCurRankTitleIndex = 1
	self.m_tRankTitleAreaList = {} --判断是否已点击过的排行
	--答题
	self.m_tSubjectList = {}
	self.m_sIsRewardItemList = nil -- 判读是否已经创建了答题奖励的子项
	self.m_tRewardItemList = {}

	self.m_tRewardInfoData = {}
	self.m_tRewardStatus = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndNationalAnswer:_unInit()
	self.m_root = nil
	self.m_sAnswerResult = nil
	self.m_nChangeCurIndex = 1
	self.m_tChangeContainerList = {}

	self.m_tChangeRankTitleList = {}
	self.m_nCurRankTitleIndex = 1
	self.m_tRankTitleAreaList = {}

	self.m_tSubjectList = {}
	self.m_sIsRewardItemList = nil
	self.m_tRewardItemList = {}
	self.m_tRewardInfoData = {}
	self.m_tRewardStatus = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndNationalAnswer:createElement()
	if WndNationalAnswer.m_root ~= nil then
		WindowManager:removeWindow(WndNationalAnswer.m_root, WndNationalAnswer, true)
	end
	local element = WZUISystem:getInstance():createElement("WndNationalAnswer")
	assert(element, "WndNationalAnswer create element failed!")
	self:_init()
	return element
end

--***************** 答题领取 ******************
CellNotionalAnswerGetItem = {}
function CellNotionalAnswerGetItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRewardItemList = {}
	self.m_tRewardItemObjList = {}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNotionalAnswerGetItem:_unInit()
	self.m_root = nil
	self.m_tRewardItemList = {}
	self.m_tRewardItemObjList = {}
end

--@brief	创建控件
function CellNotionalAnswerGetItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(300,110))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function CellNotionalAnswerGetItem:setNationalAnswerMessage(index, data)
	self.m_nAnswerIndex = index
	self.m_tAnswerItemGetData = data
end
--@brief 	开始加载
function CellNotionalAnswerGetItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("answer_item")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:nationalAnsertGetDateItem()
end

function CellNotionalAnswerGetItem:nationalAnsertGetDateItem()
	if not self.m_tAnswerItemGetData then return end

	self.m_tRewardItemList[self.m_nAnswerIndex] = {}
	self.m_tRewardItemObjList[self.m_nAnswerIndex] = {}
	self:setBtnGetStatus(self.m_nAnswerIndex,self.m_tAnswerItemGetData.status, self.m_tAnswerItemGetData.desc, self.m_tAnswerItemGetData.reward, self.m_tAnswerItemGetData.num, self.m_tAnswerItemGetData.id)
end
--设置按钮状态  0可领取 1已经领取了 2不可领取
function CellNotionalAnswerGetItem:setBtnGetStatus(index, status, desc, reward, num, id)
	if not self.m_root then return end

	self.m_nRewardGetId = id
	local answer_subject = GetElement(self.m_root,"answer_subject",WZUILabelTTF)
	answer_subject:setText(desc)

	local btnAnswerGet = GetElement(self.m_root,"btnAnswerGet",WZUIButton)
	local btnAnswerGetLabel = GetElement(btnAnswerGet,"btnAnswerGetLabel",WZUILabelTTF)
	btnAnswerGet:setVisible(false)
	local get_img = GetElement(self.m_root,"get_img",WZUIImage)
	get_img:setVisible(false)

	btnAnswerGet:setVisible(status ~= 1)
	if status == 0 then
		btnAnswerGet:setTouchEnable(true)
		btnAnswerGetLabel:setEnableStroke(true)
		btnAnswerGetLabel:setColor(GlobalMethod:ccc3(255,250,236))
		btnAnswerGetLabel:setStrokeColor(GlobalMethod:ccc3(163,74,20))
		btnAnswerGetLabel:setStrokeSize(4)
	elseif status == 1 then
		get_img:setVisible(true)
	elseif status == 2 then
		btnAnswerGet:setTouchEnable(false)
		btnAnswerGetLabel:setEnableStroke(false)
		btnAnswerGetLabel:setColor(GlobalMethod:ccc3(255,255,255))
	end

	--假设为5个
	for i=1,5 do
		if self.m_tRewardItemList[index] and self.m_tRewardItemList[index][i] then
			self.m_tRewardItemList[index][i]:setVisible(false)
		end
	end
	local good_container = GetElement(self.m_root,"good_container",WZUIContainer)
	for i=1,#reward do
		local key = "id_"..reward[i]
	    local name = GDatatab_item[key].name
	    local path = GDatatab_item[key].icon
	    local num = num[i]
	    local quality = GDatatab_item[key].quality
		local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}

		if  self.m_tRewardItemList[index][i] == nil then
		    local celElement,tLuaObj = CellGoodItem:createElement()
		    good_container:addChild(celElement)
		    celElement:setScale(0.75)
		    celElement:setUseAbsCoordinate(true)
		    self.m_tRewardItemList[index][i] = celElement
		    self.m_tRewardItemObjList[index][i] = tLuaObj
		end
		if self.m_tRewardItemList[index][i] and self.m_tRewardItemObjList[index][i] then
			self.m_tRewardItemList[index][i]:setVisible(true)
		    self.m_tRewardItemObjList[index][i]:setCellGoodItem(itemInfo, 4)
			self.m_tRewardItemObjList[index][i]:setItemClickFun(WndNationalAnswer,self.onItemClick)
			self.m_tRewardItemList[index][i]:setAbsPosition(GlobalMethod:ccp(40+(i-1)*70,40))
		end
	end
end

--@brief	点击物品弹出对应的tips
function CellNotionalAnswerGetItem:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndNationalAnswer.m_root,1,tData,false,nil,true)
end
--领取
function CellNotionalAnswerGetItem:onClickGetAnswer()
	if self.m_nRewardGetId then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveInterestingReward(tonumber(self.m_nRewardGetId))
	end
end
--@return	新建的表实例对象
function CellNotionalAnswerGetItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
--***********************************

--************** 总排行、公会排行 *******************
CellRank1Item = {}
function CellRank1Item:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRank1Item:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellRank1Item:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,92))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
--[[
_type: 1:总排行  2:公会排行
]]
function CellRank1Item:setRankItemMessage(_type, data)
	self._type = _type
	self.m_sRanksData = data
end
--@brief 	开始加载
function CellRank1Item:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("rank1_item")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:updataRankItem()
end

function CellRank1Item:updataRankItem()
	if not self.m_sRanksData then return end

	local rank_name = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
	local rank_img = GetElement(self.m_root,"rank_img",WZUIImage)
	rank_img:setVisible(false)
	local rank_label = GetElement(self.m_root,"rank_label",WZUILabelTTF)
	rank_label:setVisible(false)
	if self.m_sRanksData.rank then
		local rank = tonumber(self.m_sRanksData.rank)
		if rank <= 3 then
			rank_img:setVisible(true)
			rank_img:setFile(rank_name[rank])
		else
			rank_label:setVisible(true)
			rank_label:setText(self.m_sRanksData.rank)
		end
	end
	if self.m_sRanksData.rightNum then
		local right_label = GetElement(self.m_root,"right_label",WZUILabelTTF)
		right_label:setText(self.m_sRanksData.rightNum)
	end
	local head_container = GetElement(self.m_root,"head_container",WZUIContainer)
	if self._type == 1 then
		local role_info = WZUIFreeTextBox:create()
		role_info:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		role_info:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
		role_info:setMaxWidth(500)
		local img = ""
		if self.m_sRanksData.cross == 1 then
			img = "ui/common/common_icon_kuafu.png"
		end
		local str = string.format([[<I P="1">%s</I><T C="127,70,26" S="20" P="1">Lv</T><T C="229,105,22" S="20" P="1">%d </T><T C="127,70,26" S="20" P="1"> %s</T>]],img,tonumber(self.m_sRanksData.level),self.m_sRanksData.name)
		role_info:setShowText(str)
		self.m_root:addChild(role_info)

		local imgHead = CellHead:show(head_container, self.m_sRanksData.headId, self.m_sRanksData.faceId, self.m_sRanksData.sex, false, nil, self.m_sRanksData.vipLevel, 
			self.m_sRanksData.headColor)
	elseif self._type == 2 then
		head_container:setVisible(false)
		local role_info = WZUIFreeTextBox:create()
		role_info:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		role_info:setRelativePosition(GlobalMethod:ccp(0.4,0.65))
		role_info:setMaxWidth(500)
		local str = string.format([[<T C="127,70,26" S="20" P="1">Lv</T><T C="229,105,22" S="20" P="1">%d </T><T C="127,70,26" S="20" P="1"> %s</T>]],tonumber(self.m_sRanksData.level),self.m_sRanksData.name)
		role_info:setShowText(str)
		self.m_root:addChild(role_info)

		local id_info = WZUIFreeTextBox:create()
		id_info:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		id_info:setRelativePosition(GlobalMethod:ccp(0.4,0.35))
		id_info:setMaxWidth(500)
		id_info:setShowText(string.format([[<T C="127,70,26" S="20" P="1">ID:</T><T C="229,105,22" S="20" P="1"> %s</T>]],self.m_sRanksData.guildId))
		self.m_root:addChild(id_info)
	end
end
function CellRank1Item:onClickGuildHead()
	if self._type and self._type ~= 1 then return end

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_sRanksData then return end
	WndCheckOther:show(self.m_sRanksData.playerId)
end
--@return	新建的表实例对象
function CellRank1Item:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
--***********************************

--************** 奖励 *******************
CellReward1Item = {}
function CellReward1Item:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellReward1Item:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellReward1Item:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,92))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
--[[
_type:  1:公会排行 2:总排行
]]
function CellReward1Item:setRankRewardItemMessage(data)
	-- self.reward_type = _type
	self.m_sRankRewardItem = data
end
--@brief 	开始加载
function CellReward1Item:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("rank3_item")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:updataRankRewardItem()
end

function CellReward1Item:updataRankRewardItem()
	if not self.m_sRankRewardItem then return end

	local rank_img3 = GetElement(self.m_root,"rank_img3",WZUIImage)
	rank_img3:setVisible(false)
	local rank_label3 = GetElement(self.m_root,"rank_label3",WZUILabelTTF)
	rank_label3:setVisible(false)
	if self.m_sRankRewardItem.rank then
		local rank_name = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
		local rank = tonumber(self.m_sRankRewardItem.rank)
		if type(rank) == "number" and rank <= 3 then
			rank_img3:setVisible(true)
			rank_img3:setFile(rank_name[rank])
		else
			rank_label3:setVisible(true)
			rank_label3:setText(self.m_sRankRewardItem.rank)
		end
	end
	local good_container = GetElement(self.m_root,"good_container",WZUIContainer)
	if self.m_sRankRewardItem.reward and self.m_sRankRewardItem.num then
		for i=1,#self.m_sRankRewardItem.reward do
			local key = "id_"..self.m_sRankRewardItem.reward[i]
		    local name = GDatatab_item[key].name
		    local path = GDatatab_item[key].icon
		    local num =  self.m_sRankRewardItem.num[i]
		    local quality = GDatatab_item[key].quality
			local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		    local celElement,tLuaObj = CellGoodItem:createElement()
		    tLuaObj:setCellGoodItem(itemInfo, 4)
		    celElement:setScale(0.75)
			good_container:addChild(celElement)
			tLuaObj:setItemClickFun(WndNationalAnswer,self.onRankRewardItemClick)

			celElement:setUseAbsCoordinate(true)
			celElement:setAbsPosition(GlobalMethod:ccp(480-(i-1)*70,40))
		end
	end
end
--@brief	点击物品弹出对应的tips
function CellReward1Item:onRankRewardItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndNationalAnswer.m_root,1,tData,false,nil,true)
end
--@return	新建的表实例对象
function CellReward1Item:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
--***********************************
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
