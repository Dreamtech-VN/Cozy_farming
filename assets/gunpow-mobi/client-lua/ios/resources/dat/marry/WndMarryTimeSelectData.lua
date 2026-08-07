--WndMarryTimeSelectData.lua
--@brief	WndMarryTimeSelect的数据模块
--@date		2015/05/21
--@author	qixiang_xie
--@note		选择举办婚礼时间

WndMarryTimeSelect = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMarryTimeSelect:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nWeddingType = nil           --举办婚礼类型
	self.m_nTimeId = 1      --举行婚礼时间
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMarryTimeSelect:_unInit()
	self.m_root = nil
	self.m_nWeddingType = nil      
	self.m_nTimeId = nil      
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMarryTimeSelect:createElement()
	local element = WZUISystem:getInstance():createElement("WndMarryTimeSelect")
	assert(element, "WndMarryTimeSelect create element failed!")
	self:_init()
	return element
end

--@brief  设置举办婚礼类型
function WndMarryTimeSelect:setWeddingType(wedType)
	WZLog("WndMarryTimeSelect:setWeddingType ",wedType)
	self.m_nWeddingType = wedType
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
