--CellInviteSuccessData.lua
--@brief	CellInviteSuccess的数据模块
--@date		2014/01/05
--@author	liangguang_long
--@note		邀请成功清单模块

CellInviteSuccess = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellInviteSuccess:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nSort = nil 			--邀请清单顺序
	self.m_sServerName = nil    --服务器名称
	self.m_sPlayerName = nil    --玩家名称
	self.m_sPageText = nil   	--页码文本
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellInviteSuccess:_unInit()
	self.m_root = nil
	self.m_nSort = nil 			--邀请清单顺序
	self.m_sServerName = nil    --服务器名称
	self.m_sPlayerName = nil    --玩家名称
	self.m_sPageText = nil   	--上一页文本
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@param	#1，控件element的引用
--@param	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellInviteSuccess:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellInviteSuccess table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellInviteSuccess")
	assert(element, "CellInviteSuccess element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	获取邀请码清单参数
--@param	#1, nSort:邀请清单顺序
--@param	#2, sServerName:服务器名称
--@param	#3, sPlayerName:玩家名称
function CellInviteSuccess:setInviteElement( nSort , sServerName , sPlayerName )
	if self.m_root == nil then
		return
	end
	self.m_nSort = nSort				--邀请清单顺序
	self.m_sServerName = sServerName	--服务器名称
	self.m_sPlayerName = sPlayerName 	--玩家名称
	self:_update()
end

--@brief	显示上一页函数
--@param	#1, sText:显示上一页文本
function CellInviteSuccess:setUpPage( sText )
	if self.m_root == nil then 
		return 
	end 
	self.m_sPageText =  sText 
	self:_updateUpPage() 
end

--@brief	显示下一页函数
--@param	#1, sText:显示下一页文本
function CellInviteSuccess:setDownPage( sText )
	if self.m_root == nil then 
		return 
	end 
	self.m_sPageText =  sText 
	self:_updateDownPage() 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@param	新建的表实例对象
function CellInviteSuccess:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
