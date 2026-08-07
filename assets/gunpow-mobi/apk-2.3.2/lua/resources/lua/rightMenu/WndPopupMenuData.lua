--WndPopupMenuData.lua
--@brief	WndPopupMenu的数据模块
--@date		2013/12/11
--@author	xiaoyu_wu
--@note		弹出菜单模块

WndPopupMenu = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPopupMenu:_init()
	self.m_root = nil	 	  			--场景根节点
	
	self.m_tCallBackLuaObj = nil		--触发点击方法时回调的表对象
	self.m_fCallBackFunc = nil			--触发点击方法时回调的方法
	self.m_tMenuItems = nil 			--菜单选项数组
	self.m_tMenu = nil
	self.m_nType = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPopupMenu:_unInit()
	self.m_root = nil
	
	self.m_tCallBackLuaObj = nil
	self.m_fCallBackFunc = nil
	self.m_tMenu = nil
	self.m_nType = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPopupMenu:createElement()
	local element = WZUISystem:getInstance():createElement("WndPopupMenu")
	assert(element, "WndPopupMenu create element failed!")
	self:_init()
	return element
end

--@brief	设置点击弹出菜单某项时回调的方法
--@param	tLuaObj,回调的表对象
--@param	fCallBackFunc,回调方法
--@note		在点击弹出菜单某一项时，在响应方法中会回调给设置的表对象
function WndPopupMenu:setCallBackFunc(tLuaObj, fCallBackFunc)
	self.m_tCallBackLuaObj = tLuaObj
	self.m_fCallBackFunc = fCallBackFunc
end

--@brief	设置弹出菜单的选项
--@param	tMenuItems,菜单选项Id的数组;nType按钮类型
--@note		根据Id设置弹出菜单的选项，Id定义参见GlobalDefine中弹出菜单相关定义
function WndPopupMenu:setPopupMenuItem(tMenuItems,tMenu,nType)
	self.m_tMenuItems = tMenuItems
	self.m_tMenu = tMenu
	self.m_nType = nType
	self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
