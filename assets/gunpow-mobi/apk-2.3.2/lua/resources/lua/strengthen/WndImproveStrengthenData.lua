--WndImproveStrengthenData.lua
--@brief	WndImproveStrengthen的数据模块
--@date		2014/8/16
--@author	zsq
--@note		升星窗口

WndImproveStrengthen = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndImproveStrengthen:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bIsImproving = false         --是否正在升星
	self.m_nImproveNeedGold = 0			--升星所需金币
	--升星相关数据
    self.m_nLoadingId = nil           --加载框ID
    self.m_nMaxStarLevel = 0
    self.m_tCurSelectedEquip = nil    --当前选择的装备

	self.m_starStoneElement = nil
	self.m_starStoneLuaObj = nil
	self.m_holyStoneElement = nil
	self.m_holyStoneLuaObj = nil

	self.m_bStarStoneEnough = nil	--升星石足够
	self.m_tChooseStarItem = {} --13星以上的选择物品
	self.m_tChooseStarPlayerId = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndImproveStrengthen:_unInit()
	self.m_root = nil	 	  			--场景根节点
	self.m_bIsImproving = nil         --是否正在升星
	self.m_nImproveNeedGold = nil		--升星所需金币
	--升星相关数据
    self.m_nLoadingId = nil
    self.m_nMaxStarLevel = nil
    self.m_tCurSelectedEquip = nil

	self.m_starStoneElement = nil
	self.m_starStoneLuaObj = nil
	self.m_holyStoneElement = nil
	self.m_holyStoneLuaObj = nil

	self.m_bStarStoneEnough = nil
	self.m_tChooseStarItem = {}
	self.m_tChooseStarPlayerId = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndImproveStrengthen:createElement()
	local element = WZUISystem:getInstance():createElement("WndImproveStrengthen")
	assert(element, "WndImproveStrengthen create element failed!")
	self:_init()
	return element
end

--@brief	获得升星表
--@param    equipType: 1人物装备 2宠物装备
function WndImproveStrengthen:getStarsUpTable(level ,quality, equipType)
	WZLog("WndImproveStrengthen:getStarsUpTable",level,type(level),quality,type(quality))

	equipType = equipType or 1
    if equipType == 2 then
		for k,v in pairs(GDatatab_pet_stars_up) do
			if quality == 4 then
				if v.quality == 4 and v.level == level then

					--找到前一级
					local tempprobability = 0
					local tempkprobability = 0
					local tempitem_id = nil
					local tempitem1_id = nil
					local tempcost = nil
					local tempmiss = 0
					local tempisDemote = 0
					for k2,v2 in pairs(GDatatab_pet_stars_up) do
						if v2.quality == 4 and v2.level == level - 1 then
							tempprobability = v2.probability
							tempkprobability = v2.kprobability
							tempitem_id = v2.item_id
							tempitem1_id = v2.item1_id
							tempcost = v2.cost
							tempmiss = v2.miss
							tempisDemote = v2.isDemote
						end
					end

					local temp = CopyTable(v)
					temp.probability = tempprobability
					temp.kprobability = tempkprobability
					temp.cost = tempcost
					temp.miss = tempmiss
					temp.item_id = tempitem_id[1][1]
					temp.num = tempitem_id[1][2]
					temp.item1_id = tempitem1_id[1][1]
					temp.num1 = tempitem1_id[1][2]
					temp.isDemote = tempisDemote

					return temp
				end
			else
				if v.level == level and v.quality ~= 4 then

					--找到前一级
					local tempprobability = 0
					local tempkprobability = 0
					local tempitem_id = nil
					local tempitem1_id = nil
					local tempcost = nil
					local tempmiss = 0
					local tempisDemote = 0
					for k2,v2 in pairs(GDatatab_pet_stars_up) do
						if v2.level == level - 1 and v2.quality ~= 4 then
							tempprobability = v2.probability
							tempkprobability = v2.kprobability
							tempitem_id = v2.item_id
							tempitem1_id = v2.item1_id
							tempcost = v2.cost
							tempmiss = v2.miss
							tempisDemote = v2.isDemote
						end
					end

					local temp = CopyTable(v)
					temp.probability = tempprobability
					temp.kprobability = tempkprobability
					temp.cost = tempcost
					temp.miss = tempmiss
					temp.item_id = tempitem_id[1][1]
					temp.num = tempitem_id[1][2]
					temp.item1_id = tempitem1_id[1][1]
					temp.num1 = tempitem1_id[1][2]
					temp.isDemote = tempisDemote

					return temp
				end
			end
		end
    else
		for k,v in pairs(GDatatab_stars_up) do
			if quality == 4 then
				if v.quality == 4 and v.level == level then
					return v
				end
			else
				if v.level == level and v.quality ~= 4 then
					return v
				end
			end
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndImproveStrengthen:updatePlayerItemData()
	WZLog("WndImproveStrengthen:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateStarAndHolyStoneNum()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   创建加载框
function WndImproveStrengthen:_createLoading()
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndImproveStrengthen:_closeLoading()
    local nId = self.m_nLoadingId
    MsgBoxManager:stopLoadingBoxByMsgId(nId)
end




-------------------------------------私有方法模块End----------------------------------------
