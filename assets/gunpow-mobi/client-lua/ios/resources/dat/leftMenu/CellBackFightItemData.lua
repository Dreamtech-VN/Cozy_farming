--CellBackFightItemData.lua
--@brief	CellBackFightItem的数据模块
--@date		2018/11/21
--@author	Tianxiang_Xu
--@note		回归活动-每日战斗Item

CellBackFightItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellBackFightItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_bIsLoaded = false 
	self.m_nloadingId = nil 
	self.m_FuncCallback = nil
    self.m_tCallBackLuaObjMap = {}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellBackFightItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_bIsLoaded = nil 
	self.m_nloadingId = nil 
	self.m_FuncCallback = nil
    self.m_tCallBackLuaObjMap = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellBackFightItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellBackFightItem table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
    element:setName("__CellBackFightItem")
    element:setUseAbsSize(true)
    element:setAbsContentSize(GlobalMethod:CCSize(486,138))
    element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	设置数据
function CellBackFightItem:setData(tData)
	-- body
	self.m_tData = tData
end

--@获得奖励
function CellBackFightItem:ACTIVITY_ReceiveActivityRewardOk(itemsId,count)
    if CellBackFightItem.m_current_click.m_root == nil then
        return
    end
    WZLog("ACTIVITY_ReceiveActivityRewardOk", CellBackFightItem.m_current_click.m_nloadingId)
    MsgBoxManager:removeMsgById(CellBackFightItem.m_current_click.m_nloadingId)
    if itemsId[1]==-1 and count[1]==-1 then
        MsgBoxManager:showTipBox(LocalStrings.REWARD_HAVED_GET)
        table.insert(CellTotalRechargetPanel.m_current.m_tNextId, self.m_tData.rewardId)
        CellTotalRechargetPanel:_setRewardList()
    else 
        WndRewardShow:showById(itemsId, count)
        WndRewardShow:closeCallBack(CellBackFightItem.m_current_click, CellBackFightItem.m_current_click._GetRewardOk,  _G, pushEquipInList)
    end 
end


function CellBackFightItem:setFunc( func,tNewObj )
    self.m_FuncCallback = func
    self.m_tCallBackLuaObjMap[func] = tNewObj 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellBackFightItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
