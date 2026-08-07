--WndCastSoulUpgradeData.lua
--@brief	WndCastSoulUpgrade的数据模块
--@date		2020/05/20
--@author	XTX
--@note		时装铸魂升级界面

WndCastSoulUpgrade = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCastSoulUpgrade:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil 
	self.m_nTabIndex = nil 				--标记当前是在时装还是在翅膀标签
	self.m_fiveNum = 1 					--多次升级
	self.m_nCanUpgrade = 0    			--可以升级的数目
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCastSoulUpgrade:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_nTabIndex = nil 
	self.m_fiveNum = nil 
	self.m_nCanUpgrade = nil    			--可以升级的数目
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCastSoulUpgrade:createElement()
	if WndCastSoulUpgrade.m_root ~= nil then
		WindowManager:removeWindow(WndCastSoulUpgrade.m_root, WndCastSoulUpgrade, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCastSoulUpgrade")
	assert(element, "WndCastSoulUpgrade create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
function WndCastSoulUpgrade:showInterface(tData, nTabIndex)
    -- body
    local wndExp = WndCastSoulUpgrade:createElement()
    if wndExp then
    	self.m_tData = tData  
    	self.m_nTabIndex = nTabIndex
        WindowManager:addWindow(wndExp, WndCastSoulUpgrade, nil, nil, nil, true)
    end
end

--@brief 	升级后数据的刷新
function WndCastSoulUpgrade:updateData(gridId, soulId, nTabIndex, num, result, lucky)
	--body
	if self.m_root == nil then return end 
	if self.m_nTabIndex ~= nTabIndex then return end 
	WZLog("WndCastSoulUpgrade:updateData", gridId, soulId, nTabIndex,num, Serialize(result))
	local levelInfo = CopyTable(GDatatab_spirit["id_" .. soulId])
	-- 第9个以后的普通元魂和第3个以后的共鸣元魂选用另一套配置
	if self.m_tData.basicInfo.sub_type ~= 4 and self.m_tData.basicInfo.gridId > 9 or self.m_tData.basicInfo.sub_type == 4 and self.m_tData.basicInfo.gridId > 3 or self.m_nTabIndex == 3 then
		levelInfo.exp = levelInfo.exp2
		levelInfo.property = levelInfo.property2
		levelInfo.rate = levelInfo.rate2
		levelInfo.luckeylimit = levelInfo.luckeylimit2
	end
	levelInfo.exp2 = nil
	levelInfo.property2 = nil
	levelInfo.rate2 = nil
	levelInfo.luckeylimit2 = nil

	if num == 1 and result[1] == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.NEWSKILL14)
	end
	local nCurLevel = self.m_tData.basicInfo.levelInfo.level
	if self.m_tData.basicInfo.gridId == gridId and self.m_tData.id == levelInfo.item_id then
		self.m_tData.icon = levelInfo.icon 
		self.m_tData.basicInfo.icon = levelInfo.icon
		self.m_tData.basicInfo.quality = levelInfo.quality
		self.m_tData.basicInfo.property = levelInfo.property
		self.m_tData.level = levelInfo.level 
		self.m_tData.cost = levelInfo.exp 
		self.m_tData.basicInfo.levelInfo = levelInfo
		self.m_tData.basicInfo.lucky = lucky

		self:_update()
	end
	-- WZLog("升级后服务端传来的升级次数",num)
	if num > 1 then
		self:updateUpLog(num, result, nCurLevel)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- --@brief 	获取下一级数据
-- function WndCastSoulUpgrade:getNextLevelData()
-- 	--body
-- 	WZLog("WndCastSoulUpgrade:getNextLevelData", self.m_tData.id)
-- 	for i, value in pairs(GDatatab_spirit) do
-- 		if value.item_id == self.m_tData.id and value.level == self.m_tData.basicInfo.levelInfo.level + 1 then 
-- 			local tempSpirit = CopyTable(value)
-- 			-- 第9个以后的普通元魂和第3个以后的共鸣元魂选用另一套配置
-- 			if self.m_tData.basicInfo.sub_type ~= 4 and self.m_tData.basicInfo.gridId > 9 or self.m_tData.basicInfo.sub_type == 4 and self.m_tData.basicInfo.gridId > 3 then
-- 				tempSpirit.exp = tempSpirit.exp2
-- 				tempSpirit.property = tempSpirit.property2
-- 				tempSpirit.rate = tempSpirit.rate2
-- 				tempSpirit.luckeylimit = tempSpirit.luckeylimit2
-- 			end
-- 			tempSpirit.exp2 = nil
-- 			tempSpirit.property2 = nil
-- 			tempSpirit.rate2 = nil
-- 			tempSpirit.luckeylimit2 = nil

-- 			return tempSpirit 
-- 		end
-- 	end

-- 	return nil 
-- end



-------------------------------------私有方法模块End----------------------------------------
