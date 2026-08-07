--CellExchangePanelData.lua
--@brief	CellExchangePanel的数据模块
--@date		2016/08/13
--@author	Tianxiang_Xu
--@note		物品兑换活动

CellExchangePanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellExchangePanel:_init()
	self.m_root = nil  			--Cell的根节点 

	self.m_activityId = nil
	self.m_startTime = nil
	self.m_endTime = nil
	self.m_rewardItems = nil
	self.m_rewardCounts = nil
	self.m_rewardItemsParamCount = nil
	self.m_target = nil 
	self.m_content = nil
	self.m_nloadingId = nil 
	self.m_rewardId = nil 
	self.m_tCellObj = nil 
	self.m_tips = nil 
	self.m_tPlayerAni = nil
	self.m_nActivityType = nil

	self.m_tSkinEquipmentData = {}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellExchangePanel:_unInit()
	self.m_root = nil

	self.m_activityId = nil
	self.m_startTime = nil
	self.m_endTime = nil
	self.m_rewardItems = nil
	self.m_rewardCounts = nil
	self.m_rewardItemsParamCount = nil
	self.m_target = nil 
	self.m_content = nil
	self.m_nloadingId = nil 
	self.m_rewardId = nil 
	self.m_tCellObj = nil 
	self.m_tips = nil 
	self.m_tPlayerAni = nil 
	self.m_nActivityType = nil

	self.m_tSkinEquipmentData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellExchangePanel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellExchangePanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellExchangePanel")
	assert(element, "CellExchangePanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
function CellExchangePanel:setMessage(activityId, startTime, endTime, rewardItems, rewardCounts, rewardItemsParamCount, target, content, rewardId, tips, activityType)
	-- body
	self.m_activityId = activityId
	self.m_startTime = startTime
	self.m_endTime = endTime
	self.m_rewardItems = rewardItems
	self.m_rewardCounts = rewardCounts
	self.m_rewardItemsParamCount = rewardItemsParamCount
	self.m_target = target 
	self.m_content = content
	self.m_rewardId = rewardId
	self.m_tips = tips 
	self.m_nActivityType = activityType

	WZLog("CellExchangePanel:setMessage", self.m_activityId, Serialize(self.m_rewardItems), Serialize(self.m_rewardCounts), Serialize(self.m_rewardItemsParamCount), Serialize(self.m_target), self.m_content, Serialize(self.m_rewardId), Serialize(self.m_tips))

	if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_EXCHANGE_ONE then
		ProtocolProcessorScenePets:regAll()
		ProtocolProcessorScenePets:send_PET_GetAllPetList()
		ProtocolProcessorPhantom:regAll()
		ProtocolProcessorPhantom:send_SHAPE_SendEquipInfo()
	end
end

--@brief 	兑换物品OK
function CellExchangePanel:ACTIVITY_ExchangeGoodsOk(rewardItems,rewardCount)
	-- body
	MsgBoxManager:stopLoadingBoxByMsgId(CellExchangePanel.m_current.m_nloadingId)
	--刷新消耗物品的数量和剩余次数
	if CellExchangePanel.m_current.m_tCellObj then
		for i = 1, #CellExchangePanel.m_current.m_tCellObj do
			local rewardId = CellExchangePanel.m_current.m_tCellObj[i]:getRewardId()
			if rewardId == CellExchangePanel.m_current.m_ClickRewardId then
				CellExchangePanel.m_current.m_tCellObj[i]:refreshData(true)
			else
				CellExchangePanel.m_current.m_tCellObj[i]:refreshData()
			end
		end
	end
	--展示购买的物品数量
	WndRewardShow:showById(rewardItems,rewardCount)
	WndRewardShow:closeCallBack(CellExchangePanel.m_current,CellExchangePanel.m_current._GetRewardOk, _G, pushEquipInList)
end

--@brief 	
function CellExchangePanel:_GetRewardOk()
	-- body
end


--@brief     获取宠物列表成功
function CellExchangePanel:GetAllPetListOk(itemId, name, icon,animation, advancedLevel, upgradeLevel, property, giftSkill, commonSkill1, commonSkill2, isInUsed, playerPetId,num,petExp,fighting,birthSkill,skill, petSkinItemId, fetterStatus)
	if self.m_root == nil then return end
	if playerPetId ~= nil and #playerPetId > 0 then
		CacheCenter:clearPlayerPetInfo()
		for i=1,#playerPetId do
			CacheCenter:addPlayerPetInfo(itemId[i], name[i], icon[i],animation[i],advancedLevel[i],upgradeLevel[i] ,property[i],giftSkill[i], commonSkill1[i], commonSkill2[i], isInUsed[i], playerPetId[i],num[i],petExp[i],fighting[i],birthSkill[i],skill[i], petSkinItemId[i], fetterStatus[i])
		end
		table.sort(CacheCenter:getPlayerPetInfo(),sortPets)
	end
	self:updateCellObjConsume()
end

--@brief     成功获得皮肤装备信息
function CellExchangePanel:GetEquipInfoOk(shapeId, eId, bId, bItemId, gId, status, quality, pastEquip)
	if self.m_root == nil then return end
	self.m_tSkinEquipmentData = {}
	for i=1,#bId do
		self.m_tSkinEquipmentData[i] = {}
		self.m_tSkinEquipmentData[i].playerItemId = bId[i]
		self.m_tSkinEquipmentData[i].id = bItemId[i]
	end
	self:updateCellObjConsume()
end

--@brief     获取宠物列表成功
function CellExchangePanel:RemoveShapeEquipInfoOK(ids)
	if self.m_root == nil then return end
	for i=#self.m_tSkinEquipmentData,1,-1 do
		for j=1,#ids do
			if self.m_tSkinEquipmentData[i].playerItemId == ids[j] then
				table.remove(self.m_tSkinEquipmentData,i)
			end
		end
	end
	self:updateCellObjConsume()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellExchangePanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellExchangePanel.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
