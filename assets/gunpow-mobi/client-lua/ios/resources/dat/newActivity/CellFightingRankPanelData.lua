--CellFightingRankPanelData.lua
--@brief	CellFightingRankPanel的数据模块
--@date		2017/08/23
--@author	Tianxiang_Xu
--@note		战力月榜之王活动

CellFightingRankPanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellFightingRankPanel:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tDataList = nil 
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tRankCell = nil 
	self.activityId = nil
	self.rewardRank = nil			--排名奖励名次
	self.reward = nil    			--排名奖励内容
	self.nFlowerListIndex = nil
	self.m_tDataListMale = {}
	self.m_tDataListFemale = {}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFightingRankPanel:_unInit()
	self.m_root = nil
	self.m_tDataList = nil 
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tRankCell = nil 
	self.activityId = nil
	self.rewardRank = nil			--排名奖励名次
	self.reward = nil    			--排名奖励内容
	self.nFlowerListIndex = nil
	self.m_tDataListMale = nil
	self.m_tDataListFemale = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellFightingRankPanel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellFightingRankPanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellFightingRankPanel")
	assert(element, "CellFightingRankPanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
function CellFightingRankPanel:setMessage_newServer(session, playerId, rank, worshipTimes, totlaWorshipTimes, fighting, name, faceId, headId, sex, level, vipLevel, headColor, bodyId, bodyColor, wingId, crossServer, activityId, rewardRank, reward)
	--body
	self.m_tDataList = {}
	self.rewardRank = {}
	self.reward = {}
	local tDataListMale = {}
	local tDataListFemale = {}	
	for i = 1, 10 do 
		local tItem = {}
		if i <= #playerId then 
			tItem.playerId = playerId[i]
			tItem.rank = rank[i]
			tItem.worshipTimes = worshipTimes[i]
			tItem.worshipNum = totlaWorshipTimes[i]
			tItem.fighting = fighting[i]
			tItem.name = name[i]
			tItem.faceId = faceId[i]
			tItem.headId = headId[i]
			tItem.sex = sex[i]
			tItem.level = level[i]
			tItem.vipLevel = vipLevel[i]
			tItem.headColor = headColor[i]
			tItem.bodyId = bodyId[i]
			tItem.bodyColor = bodyColor[i]
			tItem.wingId = wingId[i]
			tItem.cross = crossServer[i]
		else
			tItem.playerId = -1
			tItem.rank = i
		end
	
		table.insert(self.m_tDataList, tItem)
		if tItem.sex == 0 then
			table.insert(tDataListMale, tItem)
		elseif tItem.sex == 1 then
			table.insert(tDataListFemale, tItem)
		end
	end

	local sortFun = function (a,b)
		-- body
		return a.rank < b.rank 
	end

	table.sort(self.m_tDataList, sortFun)
	table.sort(tDataListMale, sortFun)
	table.sort(tDataListFemale, sortFun)

	for i = 1, 5 do
        if not tDataListMale[i] then
            tDataListMale[i] = {}
            tDataListMale[i].playerId = -1
        end
        self.m_tDataListMale[i] = CopyTable(tDataListMale[i])
        self.m_tDataListMale[i].rank = i
    
        if not tDataListFemale[i] then
            tDataListFemale[i] = {}
            tDataListFemale[i].playerId = -1
        end
        self.m_tDataListFemale[i] = CopyTable(tDataListFemale[i])
        self.m_tDataListFemale[i].rank = i
    end

	self.activityId = activityId

	if rewardRank then
		for i=1,#rewardRank do
			table.insert(self.rewardRank,rewardRank[i])
		end
	end

	if reward then
		for i=1,#reward do
			table.insert(self.reward,reward[i])
		end
	end

	WZLog("CellFightingRankPanel:setMessage_newServer", Serialize(self.m_tDataList))
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFightingRankPanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellFightingRankPanel.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
