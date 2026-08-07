--WndServersSureData.lua
--@brief	WndServersSure的数据模块
--@date		2021/11/30
--@author	XTX
--@note		突破

WndServersSure= {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndServersSure:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tStarList = nil 
	self.m_nCurIndex = 0 
	self.m_nCurBreakId = nil 
	self.m_nMaxLevel = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndServersSure:_unInit()
	self.m_root = nil
	self.m_tStarList = nil 
	self.m_nCurIndex = 0 
	self.m_nCurBreakId = nil 
	self.m_nMaxLevel = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndServersSure:createElement()
	local element = WZUISystem:getInstance():createElement("WndServersSure")
	assert(element, "WndServersSure create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndServersSure:showWin()
	-- body
	local conSubWin = GetElement(WndBagMain.m_root, "conSubWin", WZUIContainer)
	if conSubWin then
		local wndElement = WndServersSure:createElement()
	    if wndElement then 
	        conSubWin:addChild(wndElement)
	    end
	end
end

--@brief 	设置数据
function WndServersSure:setData()
	self.m_tStarList = {}

	for i, value in pairs(GDatatab_level_breach) do
		if self.m_tStarList[value.lv] == nil then 
			self.m_tStarList[value.lv] = {}
		end

		local tItem = {}
		tItem.id = value.id 
		tItem.lv = value.lv 
		tItem.star = value.star 
		tItem.value = value.value 
		tItem.cost = value.cost 

		table.insert(self.m_tStarList[value.lv], tItem)
	end

	for i, value in pairs(self.m_tStarList) do
		table.sort( value, function (a, b) 
			return a.star < b.star
		end)
	end
	self.m_nCurBreakId = CacheCenter:getPlayerBreakLvId()
	local nextData = self:getNextStarData()
	self.m_nCurIndex = nextData.lv

	self:_update()
end

--@brief 	突破结果
function WndServersSure:breakResult(result, levelBreachId, maxLevel)
	if self.m_root == nil then return end 

	if result == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.BREAK_TEXT1[1])
		self.m_nCurBreakId = levelBreachId
		local nextData = self:getNextStarData()
		self.m_nCurIndex = nextData.lv
		CacheCenter:setPlayerBreakLvId(levelBreachId)
		CacheCenter:getGameParam().gameMaxLevel = maxLevel
		self.m_nMaxLevel = maxLevel
		WZLog("WndServersSure:breakResult 222", self.m_nMaxLevel)
		
		self:_update()
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndServersSure:updatePlayerItemData()
	if self.m_root ~= nil then
		self:_showCoinNum()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	下一级数据
function WndServersSure:getNextStarData()
	local tCurData = GDatatab_level_breach["id_" .. self.m_nCurBreakId]
	if tCurData.cost == -1 then 
		return tCurData
	end
	local nCurLv = tCurData.lv 
	local nCurStar = tCurData.star
	local nextData = nil 
	for i, value in pairs(GDatatab_level_breach) do
		if value.lv == nCurLv and value.star == nCurStar + 1 then 
			nextData = value 
			break 
		end
	end
	if not nextData then 
		for i, value in pairs(GDatatab_level_breach) do
			if value.lv == nCurLv + 1 and value.star == 1 then 
				nextData = value 
				break 
			end
		end
	end

	return nextData 
end

-------------------------------------私有方法模块End----------------------------------------
