--WndCommentData.lua
--@brief	WndComment的数据模块
--@date		2017/04/26
--@author	zhangming
--@note		评论UI界面

WndComment = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndComment:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nId = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndComment:_unInit()
	self.m_root = nil
	self.m_nId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndComment:createElement()
	if WndComment.m_root ~= nil then
		WindowManager:removeWindow(WndComment.m_root, WndComment, true)
	end
	local element = WZUISystem:getInstance():createElement("WndComment")
	assert(element, "WndComment create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
