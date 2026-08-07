--WndWeddingDetailsData.lua
--@brief	WndWeddingDetails的数据模块
--@date		2016/04/14
--@author	qixiang_xie
--@note		婚礼详情

WndWeddingDetails = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWeddingDetails:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tWeddingInfo = nil           --婚礼详细信息
	self.m_nCurShowWeddingType = 1     --当前正在显示的婚礼信息,默认是奢华
	self.m_nSeleWeddingType = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWeddingDetails:_unInit()
	self.m_root = nil
	self.m_tWeddingInfo = nil    
	self.m_nCurShowWeddingType = 0  
	self.m_nSeleWeddingType = nil     
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWeddingDetails:createElement()
	local element = WZUISystem:getInstance():createElement("WndWeddingDetails")
	assert(element, "WndWeddingDetails create element failed!")
	self:_init()
	return element
end


--@brief   需要显示的婚礼类型
--@param   weddingType : 1、奢华  2、豪华  3、浪漫
function WndWeddingDetails:setShowWeddingIndex(weddingType)
	WZLog("WndWeddingDetails:setShowWeddingIndex = ",weddingType)
	self.m_nCurShowWeddingType = weddingType - 8
	self.m_nSeleWeddingType = weddingType - 8
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
