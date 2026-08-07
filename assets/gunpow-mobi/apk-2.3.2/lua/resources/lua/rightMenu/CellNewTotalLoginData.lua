--CellTotalLoginPanelData.lua
--@brief	CellTotalLoginPanel的数据模块
--@date		2015/05/12
--@author	weidong_wu
--@note		累计陆录活动

CellNewTotalLogin = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellNewTotalLogin:_init()
	self.m_root = nil  			--Cell的根节点
	self.index = 0 
 	self.rewardId = nil 
 	self.status = nil 
 	self.rewardItems = nil 
 	self.rewardItemsParamCount=nil 
 	self.rewardCounts = nil
 	self.m_currentIndex = 1
 	self.m_nloadingId = 0
  self.m_cellItemObj = nil 
  self.m_tips = nil 
  self.m_nStartTime = nil 
  self.m_nEndTime = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewTotalLogin:_unInit()
  self.m_root = nil
	self.index = 0 
  self.rewardId = nil 
  self.status = nil 
  self.rewardItems = nil 
  self.rewardItemsParamCount=nil 
  self.rewardCounts = nil
  self.m_currentIndex = 1
  self.m_nloadingId = 0
  self.m_cellItemObj = nil
  self.m_tips = nil 
  self.m_nStartTime = nil 
  self.m_nEndTime = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellNewTotalLogin:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellNewTotalLogin table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellNewTotalLogin")
	assert(element, "CellNewTotalLogin element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief    初始化信息
function CellNewTotalLogin:setActivityReturnInfo(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target, cellItemObj)
   self.index = activityId   
   self.rewardId = rewardId 
   self.status = status 
   self.rewardItems = rewardItems 
   self.rewardItemsParamCount=rewardItemsParamCount 
   self.rewardCounts = rewardCounts
   self.m_cellItemObj = cellItemObj
   self.m_tips = tips
   self.m_nStartTime = startTime
   self.m_nEndTime = endTime
   self.target = target
   self.count = count
end

function CellNewTotalLogin:ACTIVITY_ReceiveRewardOk(itemsId,count)
	  WZLog("CellNewTotalLogin:ACTIVITY_ReceiveRewardOk")
    WndRewardShow:showById(itemsId,count)
	  WndWelfare:chooseMethod()
    WndRewardShow:closeCallBack(nil,nil, _G, pushEquipInList)
end

--@获得奖励
--function CellNewTotalLogin:ACTIVITY_ReceiveActivityRewardOk(itemsId,count)
--    MsgBoxManager:removeMsgById(CellNewTotalLogin.m_current_click.m_nloadingId)
--    WndRewardShow:showById(itemsId,count)
--    WndRewardShow:closeCallBack(CellNewTotalLogin.m_current_click,CellNewTotalLogin.m_current_click._GetRewardOk, _G, pushEquipInList)
--end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellNewTotalLogin:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
  CellNewTotalLogin.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
