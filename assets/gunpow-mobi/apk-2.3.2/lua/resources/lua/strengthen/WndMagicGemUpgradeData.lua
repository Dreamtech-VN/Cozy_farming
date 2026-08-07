--WndMagicGemUpgradeData.lua
--@brief	WndMagicGemUpgrade的数据模块
--@date		2019/07/23
--@author	yrd
--@note		魔力宝石升级

WndMagicGemUpgrade = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMagicGemUpgrade:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tCurSelectedEquip = nil 		--当前装备数据
	self.m_tGemData = nil 				--当前宝石数据
	self.m_tAllSelGemData = {} 			--所有选上的宝石数据
	self.m_curTag = nil					--当前选的格子
	self.m_nMaxExp = 0 					--溢出经验边界
	self.m_nNextExp = 0					--将提升的经验
	self.m_nOperateType = nil 			--1是升级 2是吞噬
	self.m_tabCurSelGemData = nil 		--当前添加的吞噬材料数据
	self.m_nCurGemExp = 0				--宝石当前附加经验
	self.m_tListData = {}				--所有宝石
	self.m_tGemList = {}			
	self.m_tag = nil 					--当前选中宝石	
	self.m_nAddLevel = 0 				--提升的等级
	self.m_nMaxAddLevel = 0 			--本次最大提升等级数
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMagicGemUpgrade:_unInit()
	self.m_root = nil
	self.m_tCurSelectedEquip = nil 		--当前装备数据
	self.m_tGemData = nil 				--当前宝石数据
	self.m_tAllSelGemData = nil 		--所有选上的宝石数据
	self.m_curTag = nil					--当前选的格子
	self.m_nMaxExp = 0 					--溢出经验边界
	self.m_nNextExp = 0					--将提升的经验
	self.m_nOperateType = nil 			--1是升级 2是吞噬
	self.m_tabCurSelGemData = nil 		--当前添加的吞噬材料数据
	self.m_nCurGemExp = nil				--宝石当前附加经验
	self.m_tListData = nil
	self.m_tGemList = nil
	self.m_tag = nil
	self.m_nAddLevel = nil 				--提升的等级
	self.m_nMaxAddLevel = nil 			--本次最大提升等级数
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMagicGemUpgrade:createElement()
	local element = WZUISystem:getInstance():createElement("WndMagicGemUpgrade")
	assert(element, "WndMagicGemUpgrade create element failed!")
	self:_init()
	return element
end

function WndMagicGemUpgrade:showInterface(tCurSeldEquip, tData, parentNode)
	WZLog("WndMagicGemUpgrade:showInterface",Serialize(tCurSeldEquip),Serialize(tData))
	local wndMagicGemUpgrade = WndMagicGemUpgrade:createElement()
	parentNode:addChild(wndMagicGemUpgrade)

	self.m_tCurSelectedEquip = tCurSeldEquip
	self.m_tGemData = tData

--	self:refreshEquipmentData()
	self:_update()
end

function WndMagicGemUpgrade:getGemOperateOk(result,operateType)
	if self.m_nOperateType == 1 then
		if result == true then
			MsgBoxManager:showTipBox(LocalStrings.NEWSKILL14)
			self:cleanGemCell()
			self:_update()
			return
		else
			MsgBoxManager:showTipBox(LocalStrings.STAR_SOUL_LIGHT_FAIL)
			return
		end
	elseif self.m_nOperateType == 2 then
		if result == true then
			MsgBoxManager:showTipBox(LocalStrings.GEM_MOUNTING_9)
			self:cleanGemCell()
			self:_update()
			return
		else
			MsgBoxManager:showTipBox(LocalStrings.GEM_MOUNTING_10)
			return
		end
	else
		if result == true then
			MsgBoxManager:showTipBox(LocalStrings.SUCCESS)
			self:cleanGemCell()
			self:_update()
			return
		else
			MsgBoxManager:showTipBox(LocalStrings.FAIL)
			return
		end
	end
		
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	获取当前经验可提升的等级
function WndMagicGemUpgrade:setAddLevel(nExp)
	self.m_nAddLevel = 0 				--提升的等级
	local tGemUpInfo = GDatatab_dig_up["id_"..self.m_tGemData.id]
	if tGemUpInfo.up_consume == -1 or tGemUpInfo.up_exp == -1 then 
		return 
	end

    local nCurExp = nExp
    while tGemUpInfo and tGemUpInfo.up_consume ~= -1 and tGemUpInfo.up_exp ~= -1 and nCurExp >= tGemUpInfo.up_exp do
    	self.m_nAddLevel = self.m_nAddLevel + 1
    	nCurExp = nCurExp - tGemUpInfo.up_exp
    	tGemUpInfo = GDatatab_dig_up["id_".. tGemUpInfo.behind_id]
    end
end

--@brief 	获取当前可提升的最大等级
function WndMagicGemUpgrade:setAddMaxLevel()
	self.m_nMaxAddLevel = 0 				--提升的等级
	local tGemUpInfo = GDatatab_dig_up["id_"..self.m_tGemData.id]
	if tGemUpInfo.up_consume == -1 or tGemUpInfo.up_exp == -1 then 
		return 
	end

    while tGemUpInfo and tGemUpInfo.up_consume ~= -1 and tGemUpInfo.up_exp ~= -1 do
    	self.m_nMaxAddLevel = self.m_nMaxAddLevel + 1
    	tGemUpInfo = GDatatab_dig_up["id_".. tGemUpInfo.behind_id]
    end
end

--@brief  	升到curLv+self.m_nAddLevel+1级所需的总经验
function WndMagicGemUpgrade:getNeedExp(nAddLevel)
	local tGemUpInfo = GDatatab_dig_up["id_"..self.m_tGemData.id]

	local nNeedExp = 0
	while nAddLevel > 0 do
		nNeedExp = nNeedExp + tGemUpInfo.up_exp

		tGemUpInfo = GDatatab_dig_up["id_".. tGemUpInfo.behind_id]

		nAddLevel = nAddLevel - 1
	end

	return nNeedExp
end

--@brief 	获取提升n等级的消耗
function WndMagicGemUpgrade:getTotalCost()
	local tGemUpInfo = GDatatab_dig_up["id_" .. self.m_tGemData.id]
	local tTotalCost = {}
	if tGemUpInfo.up_consume ~= -1 then 
		for i = 1, #tGemUpInfo.up_consume do
			local tItem = {}
			tItem[1] = tGemUpInfo.up_consume[i][1]
			tItem[2] = 0

			table.insert(tTotalCost, tItem)
		end
	elseif tGemUpInfo.ad_up ~= -1 then 
		for i = 1, #tGemUpInfo.ad_up do
			local tItem = {}
			tItem[1] = tGemUpInfo.ad_up[i][1]
			tItem[2] = 0

			table.insert(tTotalCost, tItem)
		end
	end

	local nAddLevel = self.m_nAddLevel
	while nAddLevel > 0 do
		for i = 1, #tGemUpInfo.up_consume do
			local bExist = false 
			for j = 1, #tTotalCost do
				if tTotalCost[j][1] == tGemUpInfo.up_consume[i][1] then 
					tTotalCost[j][2] = tTotalCost[j][2] + tGemUpInfo.up_consume[i][2]
					bExist = true 
					break 
				end
			end

			if not bExist then 
				table.insert(tTotalCost, tGemUpInfo.up_consume[i])
			end
		end
		tGemUpInfo = GDatatab_dig_up["id_".. tGemUpInfo.behind_id]
		nAddLevel = nAddLevel - 1
	end

	return tTotalCost
end



--@brief 	修改宝石可以选择宝石的最大数量
function WndMagicGemUpgrade:getGemCanSelCount(tSelGemData)
	local tGemData = self.m_tGemData
	local nCurGemExp = self.m_nCurGemExp
	local nNextExp = self.m_nNextExp

	--通过"拥有材料"算出"最多能升几级"
	local nMaxAddLevel = 1 --最大能升几级
	local tConsumeList = {} --升级消耗材料累计表 key:id value:数量
	local bEnough = true --材料是否足够
	local tGemUpInfo = GDatatab_dig_up["id_"..tGemData.id]
	while tGemUpInfo and tGemUpInfo.up_consume ~= -1 and tGemUpInfo.up_exp ~= -1 and bEnough == true do
		for i=1,#tGemUpInfo.up_consume do
			local nItemId = tGemUpInfo.up_consume[i][1]
			local nItemNum = tGemUpInfo.up_consume[i][2]
			if tConsumeList[nItemId] == nil then
				tConsumeList[nItemId] = 0
			end
			tConsumeList[nItemId] = tConsumeList[nItemId] + nItemNum
		end
		for key,value in pairs(tConsumeList) do
			if CacheCenter:getPlayerItemCountById(key) < value then
				bEnough = false
				break
			end
		end

		nMaxAddLevel = nMaxAddLevel + 1
		tGemUpInfo = GDatatab_dig_up["id_".. tGemUpInfo.behind_id]
	end

	--通过"当前宝石等级"算出"升到最大级所需经验"
	local nNeedExp = 0 --升到最大级所需经验
	local tGemUpInfo = GDatatab_dig_up["id_"..tGemData.id]
	local tmpMaxLevel = nMaxAddLevel
	while tmpMaxLevel > 0 do
		nNeedExp = nNeedExp + tGemUpInfo.up_exp
		tGemUpInfo = GDatatab_dig_up["id_".. tGemUpInfo.behind_id]
		tmpMaxLevel = tmpMaxLevel - 1
	end

	--"升到最大级所需经验"减去"当前宝石经验"和"已选过宝石的经验"总和
	nNeedExp = nNeedExp - nCurGemExp - nNextExp

	--通过"升到最大级所需经验"算出"当前宝石可选最大数量"
	local nCount = 1 --默认最少显示1个
	if nNeedExp > 0 then
		local tDigUpData = GDatatab_dig_up["id_"..tSelGemData.id]
		nCount = math.ceil(nNeedExp / tDigUpData.mine_exp)
	end
	--拥有宝石数量
	nCount = math.min(nCount, tSelGemData.lastNum)

	return nCount
end


-------------------------------------私有方法模块End----------------------------------------
