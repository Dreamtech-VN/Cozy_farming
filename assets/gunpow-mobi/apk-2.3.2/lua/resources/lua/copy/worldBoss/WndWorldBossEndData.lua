--WndWorldBossEndData.lua
--@brief	WndWorldBossEnd的数据模块
--@date		2015-10-15
--@author	binshao
--@note		世界boss活动结束界面

WndWorldBossEnd = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWorldBossEnd:_init()
	self.m_root = nil	 	  			--场景根节点
    self.data = nil
    self.isDesc = nil                   -- 是否显示结算动画
    self.m_nType = nil 					--2->世界组队Boss, 3->夫妻争霸Boss, 其他世界boss
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWorldBossEnd:_unInit()
	self.m_root = nil
    self.data = nil
    self.isDesc = nil
    self.m_nType = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWorldBossEnd:createElement()
	local element = WZUISystem:getInstance():createElement("WndWorldBossEnd")
	assert(element, "WndWorldBossEnd create element failed!")
	self:_init()
	return element
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------