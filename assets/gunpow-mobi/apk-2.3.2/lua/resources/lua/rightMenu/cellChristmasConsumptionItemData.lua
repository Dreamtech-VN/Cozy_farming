--cellChristmasConsumptionItemData.lua
--@brief	cellChristmasConsumptionItem的数据模块
--@date		2020/12/08
--@author	hyc
--@note		圣诞排行榜子item

cellChristmasConsumptionItem = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function cellChristmasConsumptionItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_index = nil					--排名
	self.m_RankData = nil				--排名相關數據
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function cellChristmasConsumptionItem:_unInit()
	self.m_root = nil
	self.m_index = nil 
	self.m_RankData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function cellChristmasConsumptionItem:createElement()
	WZLog("cellChristmasConsumptionItem:createElement")
	local tNewObj = self:_new()
	assert(tNewObj, "cellChristmasConsumptionItem table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("cellChristmasConsumptionItem")
	assert(element, "cellChristmasConsumptionItem element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

function cellChristmasConsumptionItem:setShopRankMessage(index,data)
	self.m_index = index
	self.m_RankData = data
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function cellChristmasConsumptionItem:_new( )
	-- body
	local tNewObj = {}
	setmetatable(tNewObj,self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
