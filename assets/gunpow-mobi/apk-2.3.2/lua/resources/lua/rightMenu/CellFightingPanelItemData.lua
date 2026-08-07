--CellFightingPanelItemData.lua
--@brief	CellFightingPanelItem的数据模块
--@date		2015/05/13
--@author	weidong_wu
--@note		战力冲刺 等级列表

CellFightingPanelItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellFightingPanelItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.tag = 0
    self.rewardId = nil
    self.m_tData = nil
    self.Parameters1 = nil
    self.status = nil
    self.m_nloadingId = 0
    self.index=0
    self.typeIndex = 0
    self.target = nil 
    self.m_FuncCallback = nil
    self.m_tCallBackLuaObjMap = {}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFightingPanelItem:_unInit()
	self.m_root = nil
	self.tag = 0
    self.rewardId = nil
    self.m_tData = nil
    self.Parameters1 = nil
    self.status = nil
    self.m_nloadingId = 0
    self.index=0
    self.typeIndex = 0
    self.target = nil 
    self.m_FuncCallback = nil
    self.m_tCallBackLuaObjMap = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellFightingPanelItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellFightingPanelItem table create failed!")
	tNewObj:_init()
	
    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellFightingPanelItem")
    element:setAbsContentSize(GlobalMethod:CCSize(626,122))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end

--@breif 设置数据
function CellFightingPanelItem:setMessage(i,rewardId,tData,Parameters1,status,typeIndex,target)
	self.tag = i
	self.rewardId = rewardId
	self.m_tData = tData
	self.Parameters1 = Parameters1
    self.status = status
    self.typeIndex = typeIndex
    self.target = target
end

--@获得奖励
function CellFightingPanelItem:ACTIVITY_ReceiveActivityRewardOk(itemsId,count)
    if CellFightingPanelItem.m_current_click.m_root == nil then
        return
    end
    WZLog("++++++"..CellFightingPanelItem.m_current_click.m_nloadingId)
    MsgBoxManager:removeMsgById(CellFightingPanelItem.m_current_click.m_nloadingId)
    WZLog("CellFightingPanelItem:ACTIVITY_ReceiveActivityRewardOk", Serialize(itemsId), Serialize(count))
    WndRewardShow:showById(itemsId,count)
    WndRewardShow:closeCallBack(CellFightingPanelItem.m_current_click,CellFightingPanelItem.m_current_click._GetRewardOk, _G, pushEquipInList)
end

function CellFightingPanelItem:setFunc( func,tNewObj )
    self.m_FuncCallback = func
    self.m_tCallBackLuaObjMap[func] = tNewObj 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFightingPanelItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
