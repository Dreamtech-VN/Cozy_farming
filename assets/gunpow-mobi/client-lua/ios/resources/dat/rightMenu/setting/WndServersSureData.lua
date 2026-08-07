--WndServersSureData.lua
--@brief	WndServersSure的数据模块
--@date		2015/04/30
--@author	binshao
--@note		选择服务器确认框

WndServersSure= {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndServersSure:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndServersSure:_unInit()
    WZLog("WndServersSure:_unInit")
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndServersSure:createElement()
	local element = WZUISystem:getInstance():createElement("WndServersSure")
	assert(element, "WndServersSure create element failed!")
	self:_init()
	return element
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------
