--WndPastureTipsData.lua
--@brief	WndPastureTips的数据模块
--@date		2021/04/19
--@author	hyx
--@note		牧场Tips

WndPastureTips = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPastureTips:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tSkillId = nil --传入技能id
	self.m_sOtherVisible = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPastureTips:_unInit()
	self.m_root = nil
	self.m_tSkillId = nil
	self.m_sOtherVisible = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPastureTips:createElement(id)
	if WndPastureTips.m_root ~= nil then
		WindowManager:removeWindow(WndPastureTips.m_root, WndPastureTips, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPastureTips")
	assert(element, "WndPastureTips create element failed!")
	self:_init()
	self.m_tSkillId = id or nil
	return element
end
--设置某些东西不显示的时候
function WndPastureTips:setOtherVisible(visible)
	self.m_sOtherVisible = visible
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
