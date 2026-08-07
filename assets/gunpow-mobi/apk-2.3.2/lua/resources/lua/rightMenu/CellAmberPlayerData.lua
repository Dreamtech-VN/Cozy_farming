--CellAmberPlayerData.lua
--@brief	CellAmberPlayer的数据模块
--@date		2020/09/16
--@author	nijinlin
--@note		oppo琥珀大玩家

CellAmberPlayer = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellAmberPlayer:_init()
	self.m_root = nil  			--Cell的根节点
  self.typeId = 0
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
function CellAmberPlayer:_unInit()
  self.m_root = nil
  self.typeId = 0
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
function CellAmberPlayer:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellAmberPlayer table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellAmberPlayer")
	assert(element, "CellAmberPlayer element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief    初始化信息
function CellAmberPlayer:setMessage(type, activityId,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, cellItemObj, tips, startTime, endTime, target, count)
   --WZLog("CellAmberPlayer:setMessage", type, activityId, Serialize(tips), Serialize(target))
   self.typeId = type
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

function CellAmberPlayer:ACTIVITY_ReceiveRewardOk(itemsId,count)
	WZLog("CellAmberPlayer:ACTIVITY_ReceiveRewardOk")
    WndRewardShow:showById(itemsId,count)
	  WndAmberPlayer:refreshActivityContext()
    WndRewardShow:closeCallBack(nil,nil, _G, pushEquipInList)
end

--@获得奖励
--function CellAmberPlayer:ACTIVITY_ReceiveActivityRewardOk(itemsId,count)
--    MsgBoxManager:removeMsgById(CellAmberPlayer.m_current_click.m_nloadingId)
--    WndRewardShow:showById(itemsId,count)
--    WndRewardShow:closeCallBack(CellAmberPlayer.m_current_click,CellAmberPlayer.m_current_click._GetRewardOk, _G, pushEquipInList)
--end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellAmberPlayer:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
  CellAmberPlayer.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------