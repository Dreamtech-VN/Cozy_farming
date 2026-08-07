--WndTeamTipsData.lua
--@brief	WndTeamTips的数据模块
--@date		2016/06/22
--@author	Tianxiang_Xu
--@note		战队列表状Tips

WndTeamTips = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndTeamTips:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_Element = nil 
	self.m_parentNode = nil 
	self.m_offset = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTeamTips:_unInit()
	self.m_root = nil
	self.m_tData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndTeamTips:createElement()
	local element = WZUISystem:getInstance():createElement("WndTeamTips")
	assert(element, "WndTeamTips element create failed!")
	self:_init()
	return element
end

function WndTeamTips:show(element,parentElement,tData,offset,bShowAll)
	if element == nil or parentElement == nil then return end
	
	local wndTips = WndTeamTips:createElement()
	if bShowAll then
		wndTips:setShowAll(bShowAll)
	end
	self.m_tData = tData
	self.m_Element = element 
	self.m_parentNode = parentElement 
	self.m_offset = offset 
	parentElement:addChild(wndTips,999,999)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------
