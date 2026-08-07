--WndTreasureResultData.lua
--@brief	WndTreasureResult的数据模块
--@date		2020/10/31
--@author	hyx
--@note		寻宝奖励

WndTreasureResult = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTreasureResult:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sReward_container = nil
	self.m_tSerachItemId = {}
	self.m_tSerachItemNum = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTreasureResult:_unInit()
	self.m_root = nil
	self.m_sReward_container = nil
	self.m_tSerachItemId = {}
	self.m_tSerachItemNum = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTreasureResult:createElement(count)
	if WndTreasureResult.m_root ~= nil then
		WindowManager:removeWindow(WndTreasureResult.m_root, WndTreasureResult, true)
	end
	local element = WZUISystem:getInstance():createElement("WndTreasureResult")
	assert(element, "WndTreasureResult create element failed!")
	self:_init()
	return element
end
function WndTreasureResult:setTreasureResultData(item_id, item_num)
	self.m_tSerachItemId = item_id
	self.m_tSerachItemNum = item_num
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
