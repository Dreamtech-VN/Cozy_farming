--WndHouseInvestRewardData.lua
--@brief	WndHouseInvestReward的数据模块
--@date		2021/09/27
--@author	hyx
--@note		投资奖励

WndHouseInvestReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHouseInvestReward:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHouseInvestReward:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHouseInvestReward:createElement()
	if WndHouseInvestReward.m_root ~= nil then
		WindowManager:removeWindow(WndHouseInvestReward.m_root, WndHouseInvestReward, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHouseInvestReward")
	assert(element, "WndHouseInvestReward create element failed!")
	self:_init()
	return element
end


--======= 投资奖励 ========
InvestRewardItem = {}
function InvestRewardItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function InvestRewardItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function InvestRewardItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(580,100))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function InvestRewardItem:setNoticeData()
	
end

--@brief 	开始加载
function InvestRewardItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("InvestRewardItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()	
end
function InvestRewardItem:setData()

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@return	新建的表实例对象
function InvestRewardItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
