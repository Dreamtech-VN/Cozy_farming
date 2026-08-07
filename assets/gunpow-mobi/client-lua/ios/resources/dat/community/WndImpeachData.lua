--WndImpeachData.lua
--@brief	WndImpeach的数据模块
--@date		2016/12/27
--@author	zsq
--@note		公会弹劾

WndImpeach = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndImpeach:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndImpeach:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndImpeach:createElement()
	local element = WZUISystem:getInstance():createElement("WndImpeach")
	assert(element, "WndImpeach create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndImpeach:setData(captainName, offlineDays, memberNum, agreeNum, voteStatus, impeachCountDown)
	self.captainName = captainName
	self.offlineDays = offlineDays
	self.memberNum = memberNum
	self.agreeNum = agreeNum
	self.voteStatus = voteStatus
	self.impeachCountDown = impeachCountDown

	self:update()
	SceneCommunityMain:setImpeachBtn()
end




-------------------------------------私有方法模块End----------------------------------------
