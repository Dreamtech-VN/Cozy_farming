--CellLevelSprintPanelItemData.lua
--@brief	CellLevelSprintPanelItem的数据模块
--@date		2015/05/13
--@author	weidong_wu
--@note		等级冲刺

CellLevelSprintPanelItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellLevelSprintPanelItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.tag = 0
    self.rewardId = nil
    self.m_tData = nil
    self.Parameters1 = nil
    self.status = nil
    self.m_nloadingId = 0
    self.index=0
    self.typeIndex = 0
    self.m_FuncCallback = nil
    self.m_tCallBackLuaObjMap = {}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLevelSprintPanelItem:_unInit()
	self.m_root = nil
	self.tag = 0
    self.rewardId = nil
    self.m_tData = nil
    self.Parameters1 = nil
    self.status = nil
    self.m_nloadingId = 0
    self.index=0
    self.typeIndex = 0
    self.m_FuncCallback = nil
    self.m_tCallBackLuaObjMap = nil 
end

--@breif 设置数据
function CellLevelSprintPanelItem:setMessage(i,rewardId,tData,Parameters1,status,typeIndex,target)
	self.tag = i
	self.rewardId = rewardId
	self.m_tData = tData
	self.Parameters1 = Parameters1
    self.status = status
    self.typeIndex = typeIndex
    self.target = target
end


--@获得奖励
function CellLevelSprintPanelItem:ACTIVITY_ReceiveActivityRewardOk(itemsId,count)
    if CellLevelSprintPanelItem.m_current_click.m_root == nil then
        return
    end
    WZLog("++++++"..CellLevelSprintPanelItem.m_current_click.m_nloadingId)
    MsgBoxManager:removeMsgById(CellLevelSprintPanelItem.m_current_click.m_nloadingId)
    WndRewardShow:showById(itemsId,count)
    WndRewardShow:closeCallBack(CellLevelSprintPanelItem.m_current_click,CellLevelSprintPanelItem.m_current_click._GetRewardOk, _G, pushEquipInList)
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellLevelSprintPanelItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellLevelSprintPanelItem table create failed!")
	tNewObj:_init()
	
    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellLevelSprintPanelItem")
    element:setAbsContentSize(GlobalMethod:CCSize(626,122))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end


function CellLevelSprintPanelItem:setFunc( func,tNewObj )
    self.m_FuncCallback = func
    self.m_tCallBackLuaObjMap[func] = tNewObj 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellLevelSprintPanelItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
