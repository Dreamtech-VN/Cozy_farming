--CellActivitySevenRedEnvelopeData.lua
--@brief	CellActivitySevenRedEnvelope的数据模块
--@date		2016/08/11
--@author	Zsq
--@note		新角色红包

CellActivitySevenRedEnvelope = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellActivitySevenRedEnvelope:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nStartTime = nil
	self.m_nEndTime = nil
	self.maxCount = nil
	self.count = nil
	self.status = nil
	self.rewardCounts = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellActivitySevenRedEnvelope:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil
	self.m_nEndTime = nil
	self.maxCount = nil
	self.count = nil
	self.status = nil
	self.rewardCounts = nil
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellActivitySevenRedEnvelope:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellActivitySevenRedEnvelope table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellActivitySevenRedEnvelope")
	assert(element, "CellActivitySevenRedEnvelope element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据					
function CellActivitySevenRedEnvelope:setMessage(activityId,startTime,endTime, maxCount, count, status, rewardCounts)
	-- body
	WZLog("CellFireworks:setMessage",count,maxCount,Serialize(rewardCounts))
	self.m_nStartTime = startTime
	self.m_nEndTime = endTime
	self.maxCount = maxCount
	self.count = count
	self.status = status
	self.rewardCounts = rewardCounts
	self:_showTime()
end

--@brief    设置活动时间
function CellActivitySevenRedEnvelope:_showTime()
    -- body
    --字“活动时间”
    local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellActivitySevenRedEnvelope", WZUILabelTTF)
    if txtTimeWord then
        txtTimeWord:setText(LocalStrings.ACTIVE_TIME .. ":")
    end
    --活动时间
    local txtTime = GetElement(self.m_root, "txtTime_CellActivitySevenRedEnvelope", WZUILabelTTF)
	local leftTime = self.m_nEndTime - SystemTime:getServerTime()
	if leftTime <= 0 then
        txtTime:setText(string.format(LocalStrings.SHOP_DAY, 0))
	else
        txtTime:setText(string.format(LocalStrings.SHOP_DAY, math.ceil(leftTime/86400)))
	end
        local sEndDate = os.date("*t", self.m_nEndTime)
		WZLog("CellActivitySevenRedEnvelope:_showTime",sEndDate.year,sEndDate.month,sEndDate.day)
    --if txtTime then
    --    local sStartDate = os.date("*t", self.m_nStartTime)
    --    local sEndDate = os.date("*t", self.m_nEndTime)
    --    txtTime:setText(string.format(LocalStrings.ACTIVITY_TIMELINE_KEY, sStartDate.month, sStartDate.day, sEndDate.month, sEndDate.day))
    --end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellActivitySevenRedEnvelope:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellActivitySevenRedEnvelope.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
