--WndMountStoneQuickData.lua
--@brief	WndMountStoneQuick的数据模块
--@date		2021/04/28
--@author	hyx
--@note		坐骑灵石快速选择

WndMountStoneQuick = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMountStoneQuick:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tQuickChooseItem = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMountStoneQuick:_unInit()
	self.m_root = nil
	self.m_tQuickChooseItem = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMountStoneQuick:createElement()
	if WndMountStoneQuick.m_root ~= nil then
		WindowManager:removeWindow(WndMountStoneQuick.m_root, WndMountStoneQuick, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMountStoneQuick")
	assert(element, "WndMountStoneQuick create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
