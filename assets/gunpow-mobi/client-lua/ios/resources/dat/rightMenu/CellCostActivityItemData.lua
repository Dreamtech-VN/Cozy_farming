--CellCostActivityItemData.lua
--@brief	CellCostActivityItem的数据模块
--@date		2015/02/04
--@author	weidong_wu
--@note		花费活动奖励项

CellCostActivityItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCostActivityItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.ActivityId = nil 
	self.RewardId = nil 
	self.m_nloadingId = 0
	self.m_FuncCallback = nil
	self.m_tCallBackLuaObjMap = {}
	self.index = 0 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCostActivityItem:_unInit()
	self.m_root = nil
	self.ActivityId = nil 
	self.RewardId = nil 
	self.m_nloadingId = 0
	self.m_FuncCallback = nil
	self.m_tCallBackLuaObjMap = nil 
	self.index = 0
end

function CellCostActivityItem:setIndex( index )
	self.index = index 
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCostActivityItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCostActivityItem table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellCostActivityItem")
	assert(element, "CellCostActivityItem element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end


function CellCostActivityItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	WZLog("CellCostActivityItem:ACTIVITY_ReceiveActivityRewardOk")
    if CellCostActivityItem.m_current_click.m_root == nil then
    	WZLog("self.m_root is nil!")
        return
    end
    MsgBoxManager:removeMsgById(CellCostActivityItem.m_current_click.m_nloadingId)
    WndRewardShow:showById(rewardItems,rewardCount)
    WndRewardShow:closeCallBack(CellCostActivityItem.m_current_click,CellCostActivityItem.m_current_click._GetRewardOk, _G, pushEquipInList)
end 

function CellCostActivityItem:setFunc( func,tNewObj )
    self.m_FuncCallback = func
	self.m_tCallBackLuaObjMap[func] = tNewObj 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCostActivityItem:_new()
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
