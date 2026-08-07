--CellCommunityDonateData.lua
--@brief	CellCommunityDonate的数据模块
--@date		2013/12/31
--@author	林庆凯
--@note		会员申批列表,捐献列表

CellCommunityDonate = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCommunityDonate:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nId = nil         	--成员ID
	self.m_bCheckBoxSelFlag = nil  --是否选中复选框的标记 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCommunityDonate:_unInit()
	self.m_root = nil
	self.m_nId = nil         	--成员ID
	self.m_bCheckBoxSelFlag = nil  --是否选中复选框的标记 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCommunityDonate:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCommunityDonate table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellCommunityDonate")
	assert(element, "CellCommunityDonate element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置列表内容的成员ID的函数
--@param #  nId 成员ID
function CellCommunityDonate:setPlayerId(nId)
	self.m_nId = nId
end 

--@brief	取得列表内容的成员ID的函数
--@return   成员ID
function CellCommunityDonate:getPlayerId()
	return self.m_nId
end 

-------------------------------------公有方法模块End----------------------------------------




-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCommunityDonate:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
