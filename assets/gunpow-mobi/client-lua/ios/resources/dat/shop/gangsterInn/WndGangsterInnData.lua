--WndGangsterInnData.lua
--@brief	WndGangsterInn的数据模块
--@date		2016/10/11
--@author	zsq
--@note		黑店

WndGangsterInn = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGangsterInn:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDataList = nil
	self.m_bIsOpen = nil
	--self.m_nLeftSecond = nil
	self.m_bFirstOpen = false
	self.m_nBuyItemId = nil
	self.m_nBuyItemNum = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGangsterInn:_unInit()
	self.m_root = nil
	self.m_tDataList = nil
	self.m_bIsOpen = nil
	--self.m_nLeftSecond = nil
	self.m_nBuyItemId = nil
	self.m_nBuyItemNum = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGangsterInn:createElement()
	local element = WZUISystem:getInstance():createElement("WndGangsterInn")
	assert(element, "WndGangsterInn create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndGangsterInn:setData(isOpen, leftSecond, id, itemId, gainCount, leftBuyTime, costItemId, costCount)
	self.m_bIsOpen = isOpen
	self.m_nLeftSecond = leftSecond - 1
	self.m_tDataList = {}
	if self.m_nScheduleId ~= nil then
    	CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nScheduleId)
	end
	if leftSecond ~= nil and leftSecond > 1 then
		self.m_nScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self.updateTime, 1, false)
	end

	for i=1,#itemId do
		local tempData = {}
		tempData.id = id[i]
		tempData.itemId = itemId[i]
		tempData.gainCount = gainCount[i]
		tempData.leftBuyTime = leftBuyTime[i]
		tempData.costItemId = costItemId[i]
		tempData.costCount = costCount[i]

		table.insert(self.m_tDataList, tempData)
	end

	WZLog("WndGangsterInn:setData",Serialize(self.m_tDataList))
	WZLog("WndGangsterInn:setData", isOpen, leftSecond)

	self:update()
end




-------------------------------------私有方法模块End----------------------------------------
