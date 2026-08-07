--WndLeagueCreateData.lua
--@brief	WndLeagueCreate的数据模块
--@date		2016/06/12
--@author	zsq
--@note		创建战队

WndLeagueCreate = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLeagueCreate:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bUploading = nil
	self.m_nUploadTime = nil
	self.m_bUploadOutTime = nil
	self.m_nLoadingCircleId = nil
	self.m_nType = nil  --1创建战队2设置战队
	self.m_nCost = nil
	self.m_nCostId = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLeagueCreate:_unInit()
	self.m_root = nil
	self.m_bUploading = nil
	self.m_nUploadTime = nil
	self.m_bUploadOutTime = nil
	self.m_nLoadingCircleId = nil
	self.m_nType = nil
	self.m_nCost = nil
	self.m_nCostId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLeagueCreate:createElement()
	local element = WZUISystem:getInstance():createElement("WndLeagueCreate")
	assert(element, "WndLeagueCreate create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
