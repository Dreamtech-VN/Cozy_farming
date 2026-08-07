--CellActivityVipPanelData.lua
--@brief	CellActivityVipPanel的数据模块
--@date		2015/07/04
--@author	weidong_wu
--@note		VIP等级礼包

CellActivityVipPanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellActivityVipPanel:_init()
	self.m_root = nil  			--Cell的根节点
	self.activityId = 0
	self.maxCount = 0
	self.count = 0
	self.rewardId = nil  
	self.status = nil  
	self.rewardItems = nil 
	self.rewardItemsParamCount = nil
	self.rewardCounts = nil
	self.removeCount =0
	self.tips = nil				--vip等级
	self.m_nMaxViplevel = 0 	--做大的VIP等级
	self.m_tActivityList = nil 	--活动数据表
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellActivityVipPanel:_unInit()
	self.m_root = nil
	self.activityId = 0
	self.maxCount = 0
	self.count = 0
	self.rewardId = nil  
	self.status = nil  
	self.rewardItems = nil 
	self.rewardItemsParamCount = nil
	self.rewardCounts = nil
	self.removeCount =0
	self.tips = nil 	
	self.m_nMaxViplevel = nil 	--做大的VIP等级
	self.m_tActivityList = nil 	--活动数据表
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellActivityVipPanel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellActivityVipPanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellActivityVipPanel")
	assert(element, "CellActivityVipPanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end


function CellActivityVipPanel:setMessage( activityId,count,maxCount,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, tips)
	self.activityId = activityId
	self.maxCount = maxCount
	self.count = count
	self.rewardId = rewardId 
	self.status = status 
	self.rewardItems = rewardItems
	self.rewardItemsParamCount = rewardItemsParamCount
	self.rewardCounts = rewardCounts
	self.tips = tips

	self.m_tActivityList = {}
	local itemCount = 1
	for idx=1,#self.rewardId do
		local tTemp = {}
		tTemp.rewardId = self.rewardId[idx]
		tTemp.status = self.status[idx]
		tTemp.tips = self.tips[idx]

		local m_tData = {}
		for i=1,self.rewardCounts[idx] do
			local item = {}
			item.id = self.rewardItems[itemCount]
			item.num = self.rewardItemsParamCount[itemCount]
			table.insert(m_tData,item)
			itemCount = itemCount+1
		end
		tTemp.m_tData = m_tData

		table.insert(self.m_tActivityList, tTemp)
	end

	table.sort(self.m_tActivityList, sortActivity)
end

--@排序函数
function sortActivity(a, b)
	-- body
	local statusA = CellActivityVipPanel:changeValue(a)
	local statusB = CellActivityVipPanel:changeValue(b)
	if statusA ~= statusB then
		return statusA > statusB
	else
		return a.rewardId < b.rewardId
	end
end

--@brief 	
function CellActivityVipPanel:changeValue(a)
	-- body
	if a.status == 0 then
		return 3
	elseif a.status == -1 then
		return 2
	else
		return 1
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellActivityVipPanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellActivityVipPanel.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
