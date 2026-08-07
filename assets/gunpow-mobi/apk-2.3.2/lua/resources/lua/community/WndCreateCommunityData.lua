--WndCreateCommunityData.lua
--@brief	WndCreateCommunity的数据模块
--@date		2013/12/26
--@author	林庆凯
--@note		创建公会窗口

WndCreateCommunity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCreateCommunity:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_ClickBtnCallBackFun =  nil 	--点击按钮的回调函数
	self.m_tCallBackLuaOjbect = nil 	--回调函数所在的表对象
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCreateCommunity:_unInit()
	self.m_root = nil
	self.m_ClickBtnCallBackFun =  nil 	--点击按钮的回调函数
	self.m_tCallBackLuaOjbect = nil 	--回调函数所在的表对象
	self.m_sTitle = nil 				--標題
end

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCreateCommunity:createElement()
	local element = WZUISystem:getInstance():createElement("WndCreateCommunity")
	assert(element, "WndCreateCommunity create element failed!")
	self:_init()
	return element
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
function WndCreateCommunity:_policy()
	local tCell = nil 
	tCell = self.m_root:getChildElement("editBoxInputName_WndCreateCommunity")
	self:_setPolicyProperty(tCell)
	tCell = nil 
end

--中文策略属性
function WndCreateCommunity:_setPolicyProperty(tCell,bPolicy)
	if self.m_root == nil or tCell == nil then
		return
	end
	bPolicy = bPolicy or false
	tCell = WZUIEditBox:luaTo(tCell)
	tCell:setSupportMultiChar(bPolicy)
end
-------------------------------------私有方法模块End----------------------------------------
