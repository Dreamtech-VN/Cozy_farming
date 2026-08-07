--CellChristmasConsumptionListData.lua
--@brief	CellChristmasConsumptionList的数据模块
--@date		2020/12/08
--@author	hyc
--@note		圣诞排行榜

CellChristmasConsumptionList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellChristmasConsumptionList:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_activityId = 0
	self.m_startime = nil
	self.m_endtime = nil
	self.m_scorce = nil					--我的积分
	self.m_rank = nil					--我的排名
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellChristmasConsumptionList:_unInit()
	self.m_root = nil
	self.m_activityId = nil
	self.m_startime = nil
	self.m_endtime = nil
	self.m_scorce = nil
	self.m_rank = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellChristmasConsumptionList:createElement()
	WZLog("圣诞消费榜进来了")
	local tNewObj = self:_new()
	assert(tNewObj, "CellChristmasConsumptionList table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellChristmasConsumptionList")
	assert(element, "CellChristmasConsumptionList element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj

end
function CellChristmasConsumptionList:setActivityReturnInfo(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	-- body
	self.m_activityId = activityId
	self.m_startime = startTime
	self.m_endtime = endTime
	self.m_scorce = count
	self.m_rank = maxCount
end

function CellChristmasConsumptionList:setChristmasRankData(data, playerId, level, point, nickname, faceId, headId, headColor, sex)
	if not data then
		return {}, -1
	end
	WZLog("CellChristmasConsumptionList:setChristmasRankData",Serialize(data),Serialize(playerId),Serialize(level),Serialize(point),Serialize(nickname),
		Serialize(faceId),Serialize(headId),Serialize(headColor),Serialize(sex))
	local table_insert = table.insert
	local temp = {}
	for i=1, #data do
		local tab = {}
		local array = SplitStringWithSeparator(data[i],"rank:")
		for j=1,#array do
			if j > 1 then
				local start1,endpos1 = string.find(array[j], ",reward:", 1)
				local sub1 = string.sub(array[j], 1, start1-1)
				local sub1 = string.sub(sub1,2,-2)
				local rank1 = SplitStringWithSeparator(sub1,",")[1]
				WZLog("CellChristmasConsumptionList:setChristmasRankData1",rank1)
				tab.rank = rank1
				local sub2 = string.sub(array[j], endpos1+1)
				tab.ids, tab.nums = SplitItemString(sub2)
			end
		end
		temp[i] = tab
	end

	local index, myCurRank = 1, -1
	local tData, ids, nums = {}, {}, {}
	local my_id = CacheCenter:getPlayerInfo().id
	for i=1, #playerId do
		if my_id == playerId[i] then
			myCurRank = i
		end

		local tab = {}
		tab.rank_index = i
		tab.playerId = playerId[i]
		tab.level = level[i]
		tab.point = point[i]
		tab.name = nickname[i]
		tab.faceId = faceId[i]
		tab.headId = headId[i]
		tab.headColor = headColor[i]
		tab.sex = sex[i]

		--因为策划可能配排名奖励是[1,1],[2,50]或是[1,1],[2,2],[3,3],[4,50],所以不把值写死
		
		-- if tonumber(temp[index].rank) <= 2 then
		-- 	ids = {}
		-- 	nums = {}
		-- 	ids = temp[index].ids
		-- 	nums = temp[index].nums
		-- 	index = index + 1
		-- else
		if tonumber(temp[index].rank) == i then
			ids = {}
			nums = {}
			ids = temp[index].ids
			nums = temp[index].nums
			index = index + 1
			if index > #temp then
				index = index - 1
			end
		end
		tab.reward_id = ids
		tab.reward_num = nums
		tData[i] = tab
	end
	return tData, myCurRank
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellChristmasConsumptionList:_new( )
	-- body
	local tNewObj = {}
	setmetatable(tNewObj,self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------



--************** 排行榜item *******************
cellChristmasConsumptionItem = {}
function cellChristmasConsumptionItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function cellChristmasConsumptionItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function cellChristmasConsumptionItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(622,92))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function cellChristmasConsumptionItem:setChristmasRankMessage(index, data)
	self.index = index
	self.mRankData = data
end
--@brief 	开始加载
function cellChristmasConsumptionItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("christmasRankItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setChirstmasRankItemData()
end

function cellChristmasConsumptionItem:setChirstmasRankItemData()
	if not self.mRankData then return end

	local img_rank = GetElement(self.m_root,"img_rank",WZUIImage)
	img_rank:setVisible(false)
	local txt_rank = GetElement(self.m_root,"txt_rank",WZUILabelTTF)
	local rank_name = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
	txt_rank:setVisible(false)
	if self.index <= 3 then
		img_rank:setVisible(true)
		img_rank:setFile(rank_name[self.index])
	else
		txt_rank:setVisible(true)
		txt_rank:setText(tostring(self.index))
	end

	GetElement(self.m_root,"txt_name",WZUILabelTTF):setText(self.mRankData.name)
	GetElement(self.m_root,"txt_lv",WZUILabelTTF):setText(self.mRankData.level)
	GetElement(self.m_root,"txt_rankScore",WZUILabelTTF):setText(self.mRankData.point)

	local head_contianer = GetElement(self.m_root,"head_contianer",WZUIContainer)
	CellHead:show(head_contianer, self.mRankData.headId, self.mRankData.faceId, self.mRankData.sex, false, nil, nil, self.mRankData.headColor)
	local reward_container = GetElement(self.m_root,"reward_container",WZUIContainer)
	if self.mRankData.reward_id then
		for i, v in ipairs(self.mRankData.reward_id) do
			local key = "id_"..v
			if GDatatab_item[key] then
			    local name = GDatatab_item[key].name
			    local path = GDatatab_item[key].icon
			    local quality = GDatatab_item[key].quality
			    local num = self.mRankData.reward_num[i]
				local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
			    local celElement,tLuaObj = CellGoodItem:createElement()
			    tLuaObj:setCellGoodItem(itemInfo, 17)
			    celElement:setScale(0.8)
				reward_container:addChild(celElement)
				tLuaObj:setItemClickFun(cellChristmasConsumptionItem,self.onChristmasRankRewardItemClick)

				celElement:setUseAbsCoordinate(true)
				celElement:setAbsPosition(GlobalMethod:ccp(185-(i-1)*70,32))
			end
		end
	end
end
function cellChristmasConsumptionItem:onClickChristmasRankHead()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.mRankData then return end
	WndCheckOther:show(self.mRankData.playerId)
end
--@brief	点击物品弹出对应的tips
function cellChristmasConsumptionItem:onChristmasRankRewardItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WZLog("点击物品弹出对应的tips")
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndGameActivity.m_root,1,tData,false,nil,true)
end

--@return	新建的表实例对象
function cellChristmasConsumptionItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
