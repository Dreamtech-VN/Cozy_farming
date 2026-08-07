--CellActivityVipItemData.lua
--@brief	CellActivityVipItem的数据模块
--@date		2015/07/04
--@author	weidong_wu
--@note		vip奖励物品列表

CellActivityVipItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellActivityVipItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.activityId = nil 
	self.status = nil 
	self.m_tData = nil 
	self.rewardId = nil 
	self.m_nloadingId = 0
	self.index = nil 
	self.m_FuncCallback = nil
	self.m_tCallBackLuaObjMap = {}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellActivityVipItem:_unInit()
	self.m_root = nil
	self.activityId = nil 
	self.status = nil 
	self.m_tData = nil 
	self.rewardId = nil 
	self.m_nloadingId = 0
	self.index = nil 
	self.m_FuncCallback = nil
	self.m_tCallBackLuaObjMap = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellActivityVipItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellActivityVipItem table create failed!")
	tNewObj:_init()
	
    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellActivityVipItem")
    element:setAbsContentSize(GlobalMethod:CCSize(630,138))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end


function CellActivityVipItem:setMessage(activityId,status,m_tData,rewardId,index)
	self.activityId = activityId 
	self.status = status 
	self.m_tData = m_tData 
	self.rewardId = rewardId
	self.index = index 
end


function CellActivityVipItem:setFunc( func,tNewObj )
    self.m_FuncCallback = func
	self.m_tCallBackLuaObjMap[func] = tNewObj 
end

--@获得奖励
function CellActivityVipItem:ACTIVITY_ReceiveActivityRewardOk(itemsId,count)
	WZLog("CellActivityVipItem:ACTIVITY_ReceiveActivityRewardOk")
    if CellActivityVipItem.m_current_click.m_root == nil then
    	WZLog("self.m_root is nil!")
        return
    end
    CellActivityVipItem.m_current_click.status = 1
    CellActivityVipItem.m_current_click:_setButtonState(CellActivityVipItem.m_current_click.status)
    MsgBoxManager:removeMsgById(CellActivityVipItem.m_current_click.m_nloadingId)
    WndRewardShow:showById(itemsId,count)
    WndRewardShow:closeCallBack(CellActivityVipItem.m_current_click,CellActivityVipItem.m_current_click._GetRewardOk, _G, pushEquipInList)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellActivityVipItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
