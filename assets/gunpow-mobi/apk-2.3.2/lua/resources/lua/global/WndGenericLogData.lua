--WndGenericLogData.lua
--@brief	WndGenericLog的数据模块
--@date		2015/05/25
--@author	qixiang_xie
--@note		通用的列表信息显示(例如恩爱日志显示)

WndGenericLog = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGenericLog:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tListInfo = nil              --存放需要显示的信息
	self.m_sTitle = nil
	self.m_nCreateCount = 0
	self.m_freeListObject = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGenericLog:_unInit()
	self.m_root = nil
	self.m_tListInfo = nil
	self.m_sTitle = nil
	self.m_nCreateCount = nil
	self.m_freeListObject = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGenericLog:createElement()
	local element = WZUISystem:getInstance():createElement("WndGenericLog")
	assert(element, "WndGenericLog create element failed!")
	self:_init()
	return element
end

--@brief 设置需要显示的信息
function WndGenericLog:setListInfo(listInfo)
	self.m_tListInfo = listInfo
	self:_update()
end

--@brief 标题图片
function WndGenericLog:setTitleImg(titleImg)
	self.m_sTitle = titleImg
	if self.m_root ~= nil then
		GetElement(self.m_root,"imgTitle_WndGenericLog",WZUIImage):setFile(self.m_sTitle)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
