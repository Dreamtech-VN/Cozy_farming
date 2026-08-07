--CellOnlineRewardItemData.lua
--@brief	CellOnlineRewardItem的数据模块
--@date		2017/06/23
--@author	peiting_mao
--@note		在线奖励物品item

CellOnlineRewardItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellOnlineRewardItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.reward = nil			--奖励
	self.desc = nil 			--奖励内容
	--self.time = nil 			--规定的在线奖励时间
	self.id = nil 				--领取奖励的id
	self.state = nil 			--领取按钮状态 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellOnlineRewardItem:_unInit()
	self.m_root = nil
	self.reward = nil
	self.desc = nil
	--self.time = nil
	self.id = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellOnlineRewardItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellOnlineRewardItem table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellOnlineRewardItem")
	assert(element, "CellOnlineRewardItem element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	获得数据
--@param	state:按钮状态，0：可领取，1：不可领取,2:已领取
--@param	data:奖励内容
function CellOnlineRewardItem:setData( data, state)
	WZLog("--*********000---",state)
	if CacheCenter:getPlayerInfo().sex == 0 then --男性玩家
		self.reward = data.reward
	else
		self.reward = data.reward2
	end
	self.id = data.id
	self.desc = data.text
	self.activityId = data.activityId
	--self.time = data.time
	self.state = state
	self:_update()
end

--@brief 	刷新领取按钮状态
--@param	state:按钮状态，0：可领取，1：不可领取,2:已领取
function CellOnlineRewardItem:setUpdateData( state )
	self.state = state
	self:_updateBtnState()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellOnlineRewardItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
