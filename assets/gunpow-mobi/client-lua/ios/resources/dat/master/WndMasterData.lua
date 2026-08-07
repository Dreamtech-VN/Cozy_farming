--WndMasterData.lua
--@brief	WndMaster的数据模块
--@date		2015/05/27
--@author	zsq
--@note		师徒大厅

WndMaster = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMaster:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurIndex = nil
	self.m_tHallElement = nil
	self.m_tMemberElement = nil
	self.m_tRewardElement = nil
	self.m_tLogElement = nil
	self.m_tTarget = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMaster:_unInit()
	self.m_root = nil
	self.m_nCurIndex = nil
	self.m_tHallElement = nil
	self.m_tMemberElement = nil
	self.m_tRewardElement = nil
	self.m_tLogElement = nil
	self.m_tTarget = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMaster:createElement()
	local element = WZUISystem:getInstance():createElement("WndMaster")
	assert(element, "WndMaster create element failed!")
	self:_init()
	return element
end

function WndMaster:updateRedPoint()
	local masterInfo = CacheCenter:getMasterInfo()
	if masterInfo == nil then return end
	if masterInfo.taskfinish == 1 then
		GetElement(self.m_root,"hasTarget_WndMaster",WZUIImage):setVisible(true)
	elseif masterInfo.taskfinish == 0 then
		GetElement(self.m_root,"hasTarget_WndMaster",WZUIImage):setVisible(false)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
