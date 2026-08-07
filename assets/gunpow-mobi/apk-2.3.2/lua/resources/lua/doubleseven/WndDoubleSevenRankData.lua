--WndDoubleSevenRankData.lua
--@brief	WndDoubleSevenRank的数据模块
--@date		2020/08/03
--@author	hyx
--@note		情侣榜

WndDoubleSevenRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDoubleSevenRank:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tTitleChange = nil
	self.m_nCurIndex = 1
	self.m_tLovesItem = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDoubleSevenRank:_unInit()
	self.m_root = nil
	self.m_tTitleChange = nil
	self.m_nCurIndex = 1
	self.m_tLovesItem = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDoubleSevenRank:createElement()
	if WndDoubleSevenRank.m_root ~= nil then
		WindowManager:removeWindow(WndDoubleSevenRank.m_root, WndDoubleSevenRank, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDoubleSevenRank")
	assert(element, "WndDoubleSevenRank create element failed!")
	self:_init()
	return element
end

--************** 奖励子项 ******************
CellDoubleSevenRewardItem = {}
function CellDoubleSevenRewardItem:_init()
	self.m_root = nil	 	  			--场景根节点

end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDoubleSevenRewardItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellDoubleSevenRewardItem:createElement()
	local tNewObj = self:_rewardnew()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,82))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function CellDoubleSevenRewardItem:setRewardInitMessage(index, data)
	self.index = index
	self.m_tRewardData = data
end
--@brief 	开始加载
function CellDoubleSevenRewardItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("reward_item")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:upDateRewardItem()
end

function CellDoubleSevenRewardItem:upDateRewardItem()
	local good_con_reward = GetElement(self.m_root, "good_con_reward", WZUIContainer)
	if not self.m_tRewardData then return end
	local rank_img = GetElement(self.m_root, "rank_img", WZUIImage)
	local rank_label = GetElement(self.m_root,"rank_label",WZUILabelTTF)
	rank_label:setVisible(false)

	local rank_str = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
	local ids = tonumber(self.m_tRewardData.rank_ids)
	local nums = tonumber(self.m_tRewardData.rank_nums)
	if ids == nums then
		rank_img:setFile(rank_str[ids])
	else
		rank_img:setVisible(false)
		rank_label:setVisible(true)
		rank_label:setText(ids.."-"..nums)
	end
	local scale = 0.8
	local reward_ids = self.m_tRewardData.reward_ids
	for i=1,#reward_ids do
		local cellElement,luaObj = CellGoodItem:createElement()
		cellElement:setUseAbsCoordinate(true)
		cellElement:setScale(scale)
		cellElement:setAbsPosition(GlobalMethod:ccp(540-(95*scale*(i-1)),40))
		local item_id = "id_"..tonumber(reward_ids[i])
		local tData = {id = GDatatab_item[item_id].id,icon=GDatatab_item[item_id].icon,lastTime=self.m_tRewardData.reward_nums[i],quality=GDatatab_item[item_id].quality,basicInfo=CopyTable(GDatatab_item[item_id])}
		luaObj:setCellGoodItem(tData, 17)
		luaObj:setItemClickFun(self,self.onItemClick)
		good_con_reward:addChild(cellElement)
	end
end
--@brief    其它Item点击回调
function CellDoubleSevenRewardItem:onItemClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,WndDoubleSevenRank.m_root,1,tData,false)
end
--@return	新建的表实例对象
function CellDoubleSevenRewardItem:_rewardnew( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--*************** 排行子项 *****************
CellDoubleSevenRankItem = {}
function CellDoubleSevenRankItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDoubleSevenRankItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellDoubleSevenRankItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,92))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function CellDoubleSevenRankItem:setRankInitMessage(index, leftData, rightData, confessSum)
	self.m_nRankIndex = index
	self.m_tLeftData = leftData
	self.m_tRightData = rightData
	self.m_nConfessSum = confessSum
end
--@brief 	开始加载
function CellDoubleSevenRankItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("rank_item")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:upDateRankItem()
end

function CellDoubleSevenRankItem:upDateRankItem()
	local rank_vlaue_img = GetElement(self.m_root,"rank_vlaue_img",WZUIImage)
	rank_vlaue_img:setVisible(false)
	local rankValueLabel = GetElement(self.m_root,"rankValueLabel",WZUILabelTTF)
	rankValueLabel:setVisible(false)
	local rank_str = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
	if self.m_nRankIndex <= 3 then
		rank_vlaue_img:setVisible(true)
		rank_vlaue_img:setFile(rank_str[self.m_nRankIndex])
	else
		rankValueLabel:setVisible(true)
		rankValueLabel:setText(tostring(self.m_nRankIndex))
	end
	--左边的
	local my_head = GetElement(self.m_root,"my_head",WZUIContainer)
	local my_name = GetElement(my_head,"my_name",WZUILabelTTF)
	local lv_label = GetElement(my_head,"lv_label",WZUILabelTTF)
	CellHead:show(my_head, self.m_tLeftData.headId, self.m_tLeftData.faceId, self.m_tLeftData.sex, false, nil, nil, self.m_tLeftData.headColor)
	my_name:setText(self.m_tLeftData.nickname)
	lv_label:setText(self.m_tLeftData.level)

	--右边的
	local other_head = GetElement(self.m_root,"other_head",WZUIContainer)
	local other_name = GetElement(other_head,"other_name",WZUILabelTTF)
	local other_lv_label = GetElement(other_head,"other_lv_label",WZUILabelTTF)
	CellHead:show(other_head, self.m_tRightData.headId, self.m_tRightData.faceId, self.m_tRightData.sex, false, nil, nil, self.m_tRightData.headColor)
	other_name:setText(self.m_tRightData.nickname)
	other_lv_label:setText(self.m_tRightData.level)

	local love_count = GetElement(self.m_root,"love_count",WZUILabelTTF)
	love_count:setText(self.m_nConfessSum)
end
function CellDoubleSevenRankItem:onClickMyHead()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tLeftData then return end
	WndCheckOther:show(self.m_tLeftData.playerId)
end

function CellDoubleSevenRankItem:onClickOtherHead()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tRightData then return end
	WndCheckOther:show(self.m_tRightData.playerId)
end

--@return	新建的表实例对象
function CellDoubleSevenRankItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
