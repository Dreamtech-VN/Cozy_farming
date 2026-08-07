--CellBreakEggsItemData.lua
--@brief	CellBreakEggsItem的数据模块
--@date		2017/08/23
--@author	Tianxiang_Xu
--@note		砸金蛋活动-金蛋子节点cell

CellBreakEggsItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellBreakEggsItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_nActivityId = nil 
	self.m_tRewardItems = nil 
	self.m_tRewardCount = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellBreakEggsItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_nActivityId = nil 
	self.m_tRewardItems = nil 
	self.m_tRewardCount = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellBreakEggsItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellBreakEggsItem table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellBreakEggsItem")
	assert(element, "CellBreakEggsItem element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置蛋的数据
function CellBreakEggsItem:setData(tData, activityId)
	-- body
	self.m_tData = tData
	self.m_nActivityId = activityId

	self:_update()
end

--@brief 	砸蛋成功
function CellBreakEggsItem:ACTIVITY_ReceiveRewardOk(rewardItems,rewardCount)
	--body
	-- body
	MsgBoxManager:stopLoadingBoxByMsgId(CellBreakEggsItem.m_current_click.m_nloadingId)
	--设置领取后的奖励项的状态
	CellBreakEggsItem.m_current_click:setRewardState(1)
	CellBreakEggsItem.m_current_click:playEggAni()
	self.m_tRewardItems = rewardItems 
	self.m_tRewardCount = rewardCount 
end

--@brief 	 展示奖励
function CellBreakEggsItem:showReward()
	-- body
	--展示购买的物品数量
	WndRewardShow:showById(self.m_tRewardItems,self.m_tRewardCount)
	WndRewardShow:closeCallBack(self,self._GetRewardOk, _G, pushEquipInList)
end

--@brief 	更新蛋的状态
function CellBreakEggsItem:setRewardState(status)
	-- body
	self.m_tData.state = status

	local imgEgg = GetElement(self.m_root, "imgEgg_CellBreakEggsItem", WZUIImage)
    local btnEgg = GetElement(self.m_root, "btnEgg_CellBreakEggsItem", WZUIButton)
    if self.m_tData.state == 0 then 
        imgEgg:setVisible(true)
        btnEgg:setTouchEnable(true)
    else
        imgEgg:setVisible(false)
        btnEgg:setTouchEnable(false)
    end
end

--@brief 	
function CellBreakEggsItem:_GetRewardOk()
	-- body
	if self.m_root == nil then return end 
	
	CellBreakEggsPanel:updateEggsData(self.m_tData.rewardId, self.m_tData.state)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellBreakEggsItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
