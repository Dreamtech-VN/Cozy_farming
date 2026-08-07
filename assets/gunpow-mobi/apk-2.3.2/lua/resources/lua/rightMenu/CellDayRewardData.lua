--CellDayRewardData.lua
--@brief	CellDayReward的数据模块
--@date		2017/05/25
--@author	 
--@note		登录奖励

CellDayReward = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellDayReward:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nRewardid = nil
	self.m_nRewardItemId = nil
	self.m_nRewardCount = nil
	self.m_nGetStats = nil
	self.m_nIndex = nil
	self.m_nActivityId = nil
	self.m_callbackLua = nil
	self.m_callbackFun = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDayReward:_unInit()
	self.m_root = nil
	self.m_nRewardid = nil
	self.m_nRewardItemId = nil
	self.m_nRewardCount = nil
	self.m_nGetStats = nil
	self.m_nIndex = nil
	self.m_nActivityId = nil
	self.m_callbackLua = nil
	self.m_callbackFun = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellDayReward:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellDayReward table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellDayReward")
	assert(element, "CellDayReward element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--设置奖励物品信息
function CellDayReward:setRewardData(acitityId,rewardid,rewardItemId,rewardCount,getStats,index)
	WZLog("CellDayReward:setRewardData")
	self.m_nRewardid = rewardid
	self.m_nRewardItemId = rewardItemId
	self.m_nRewardCount = rewardCount
	self.m_nGetStats = getStats
	self.m_nIndex = index
	self.m_nActivityId = acitityId
end

function CellDayReward:setGetRewardCallback(callbackLua,callbackFun)
	WZLog("CellDayReward:setGetRewardCallback")
	self.m_callbackLua = callbackLua
	self.m_callbackFun = callbackFun
end

function CellDayReward:updateUI(getStats)
	WZLog("CellDayReward:updateUI")
	self.m_nGetStats = getStats
	local conHeidi = GetElement(self.m_root,"conHeidi_CellDayReward",WZUIContainer)
	if self.m_nGetStats == 1 then
		conHeidi:setVisible(true)
	else
		conHeidi:setVisible(false)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellDayReward:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end



-------------------------------------私有方法模块End----------------------------------------
