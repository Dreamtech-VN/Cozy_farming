--WndInvitedData.lua
--@brief	WndInvited的数据模块
--@date		2014/01/23
--@author	liangguang_long
--@note		副本战斗邀请请求模块

WndInvited = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndInvited:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nInviteIndex = 7 			--邀请索引，用于计算接受邀请时间
	self.m_tCallbackFun = nil 			--回调函数
	self.m_tCell = nil                  --表名
	self.m_nId = nil 					--房间ID
	self.m_sPassword = "-1"              --房间密码
	self.m_nBattleId = nil 				--战斗房间ID
	self.m_nRoomChannel = nil
	self.m_nAssistFight = 1            --是否为助战（1：不是 0：是）
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndInvited:_unInit()
	self.m_root = nil
	self.m_nInviteIndex = nil 			--邀请索引，用于计算接受邀请时间
	self.m_nId = nil 					--房间ID
	self.m_nBattleId = nil 				--战斗房间ID
	self.m_sPassword = nil 
	self.m_nRoomChannel = nil
	self.m_nAssistFight = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndInvited:createElement()
	local element = WZUISystem:getInstance():createElement("WndInvited")
	assert(element, "WndInvited create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
