--ScenePvpAmuseData.lua
--@brief	ScenePvpAmuse的数据模块
--@date		2016/11/21
--@author	binshao
--@note		pvp模式娱乐竞技

ScenePvpAmuse = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function ScenePvpAmuse:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tItemList = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function ScenePvpAmuse:_unInit()
	self.m_root = nil
	self.m_tItemList = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function ScenePvpAmuse:createElement()
	local element = WZUISystem:getInstance():createElement("ScenePvpAmuse")
	assert(element, "ScenePvpAmuse create element failed!")
	self:_init()
	return element
end

function ScenePvpAmuse:setOpenState(matchType, activityStatus, dayOfWeek)
	WZLog("ScenePvpAmuse:setOpenState =",Serialize(matchType),Serialize(activityStatus),Serialize(dayOfWeek))
	if self.m_root == nil then
		return
	end

	self.m_tItemList = {}
	for i = 1, #matchType do
		local tItem = {}
		tItem.openState = activityStatus[i]
		tItem.openTime = dayOfWeek[i]
		tItem.matchType = matchType[i]
		if matchType[i] == 1 then 
			tItem.sort = 2
		elseif matchType[i] == 2 then 
			tItem.sort = 5
		elseif matchType[i] == 3 then 
			tItem.sort = 1
		elseif matchType[i] == 4 then 
			tItem.sort = 3
		elseif matchType[i] == 5 then 
			tItem.sort = 4
		elseif matchType[i] == 6 then 
			tItem.sort = 6
		elseif matchType[i] == 7 then 
			tItem.sort = 7
		end

		table.insert(self.m_tItemList, tItem)
	end

	-- local tItem = {}
	-- tItem.openState = 1
	-- tItem.openTime = "1,4"
	-- tItem.matchType = 7
	-- tItem.sort = 7
	-- table.insert(self.m_tItemList, tItem)

	table.sort(self.m_tItemList, function (a,b)
		-- body
		if a.openState ~= b.openState then 
			return a.openState < b.openState
		else
			return a.sort < b.sort
		end
	end)

	WZLog("ScenePvpAmuse:setOpenState", Serialize(self.m_tItemList))
	self:initOpenState()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
