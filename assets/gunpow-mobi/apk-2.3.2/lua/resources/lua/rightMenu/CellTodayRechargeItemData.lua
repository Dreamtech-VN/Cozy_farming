--CellTodayRechargeItemData.lua
--@brief	CellTodayRechargeItem的数据模块
--@date		2016/07/18
--@author	maopeiting
--@note		每日充值奖励

CellTodayRechargeItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellTodayRechargeItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.tag = 0
	self.target = nil
	--self.rewardItems = nil
    --self.rewardCountOrDay = nil
    self.m_tData = nil
    self.rewardId = nil
    self.itemId = {}
    self.itemCount = {}
    --self.rewardItemsParamCount = nil
    --self.theirConditions = nil
    self.Parameters1 = nil
    --self.Parameters2 = nil
    --self.Parameters3 = nil
    self.m_nloadingId = 0
    self.status = nil
    self.num = nil
    self.typeIndex = 0
    self.m_FuncCallback = nil
    self.m_tCallBackLuaObjMap = {}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellTodayRechargeItem:_unInit()
	self.m_root = nil
	self.target = nil
	self.count = nil
	self.m_tData = nil
	--self.rewardItems = nil
    --self.rewardCountOrDay = nil
    self.rewardId = nil
    self.itemId = nil
    self.itemCount = nil
    --self.rewardItemsParamCount = nil
    --self.theirConditions = nil
    self.Parameters1 = nil
    --self.Parameters2 = nil
    --self.Parameters3 = nil
    self.m_nloadingId = nil
    self.status = nil
    self.num = nil
    self.typeIndex = nil
    self.m_FuncCallback = nil
    self.m_tCallBackLuaObjMap = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellTodayRechargeItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellTodayRechargeItem table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	assert(element, "CellTodayRechargeItem element create failed!")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(630,138)) 
	element:setLuaObjectIndex(tNewObj)
	--tNewObj.m_root = element
	return element,tNewObj
end

function CellTodayRechargeItem:onLoadData( element )
	local ele = WZUISystem:getInstance():createElement("CellTodayRechargeItem")
	self.m_root:addChild(ele)
	self:ShowCellItem()
end

--@breif 设置数据
function CellTodayRechargeItem:setMessage(i,rewardId,tData,Parameters1,status,typeIndex,target)
	self.tag = i
	self.rewardId = rewardId
	self.m_tData = tData
	self.Parameters1 = Parameters1
    self.status = status
    self.typeIndex = typeIndex
    self.target = target
    --self.num = num
    for i=1,#tData do
    	table.insert(self.itemId,tData[i].id)
    	table.insert(self.itemCount,tData[i].num)
    end
    --for i=1,#tData do
    	WZLog("CellTodayRechargeItem:self.itemId",Serialize(self.itemId),Serialize(self.itemCount))
    --end
end

--@获得奖励
-- function CellTodayRechargeItem:ACTIVITY_ReceiveActivityRewardOk(itemsId,count)
--     if CellTodayRechargeItem.m_current_click.m_root == nil then
--         return
--     end
--     WZLog("--CellTodayRechargeItem:ACTIVITY_ReceiveActivityRewardOk--",CellTodayRechargeItem.m_current_click.m_nloadingId)
--     WZLog("--CellTodayRechargeItem:itemsId,count--",itemsId,count)
--     MsgBoxManager:removeMsgById(CellTodayRechargeItem.m_current_click.m_nloadingId)
--     -- if itemsId[1]==-1 and count[1]==-1 then
--     --     MsgBoxManager:showTipBox(LocalStrings.REWARD_HAVED_GET)
--     --     table.insert(CellTodayRechargePanel.m_current.m_tNextId,self.rewardId)
--     --     CellTotayRechargePanel:_updateReward()
--     --  else 
--         WndRewardShow:showById(itemsId,count)
--         WndRewardShow:closeCallBack(CellTodayRechargeItem.m_current_click,CellTodayRechargeItem.m_current_click._GetRewardOk, _G, pushEquipInList)
--     --end 
-- end

-- function CellTodayRechargeItem:setFunc( func,tNewObj )
--     self.m_FuncCallback = func
--     self.m_tCallBackLuaObjMap[func] = tNewObj 
-- end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellTodayRechargeItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
