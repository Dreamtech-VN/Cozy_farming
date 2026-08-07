--WndFriendInviteCodeData.lua
--@brief	WndFriendInviteCode的数据模块
--@date		2016/06/07
--@author	Tianxiang_Xu
--@note		填写邀请码窗口

WndFriendInviteCode = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndFriendInviteCode:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nLoadingId = nil 
	self.m_nState = nil 		--标记是否已经输入过邀请码
	self.m_tFriend = nil 		--我的邀请码好友数据
	self.m_sMyInviteCode = nil 	--我填写的邀请码
	self.m_sInputCode = nil 	--输入框的内容
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFriendInviteCode:_unInit()
	self.m_root = nil
	self.m_nLoadingId = nil 
	self.m_nState = nil 
	self.m_tFriend = nil 		--我的邀请码好友数据
	self.m_sMyInviteCode = nil
	self.m_sInputCode = nil 	--输入框的内容
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndFriendInviteCode:createElement()
	local element = WZUISystem:getInstance():createElement("WndFriendInviteCode")
	assert(element, "WndFriendInviteCode element create failed!")
	self:_init()
	return element
end

--@brief 	设置数据
function WndFriendInviteCode:setData(code, name, level, serverid, playerId, successFlag, headId, faceId, vipLevel, sex, headColor, headEffectId)
	-- body
	self:_closeLoading()
	self.m_nState = CacheCenter:getInviteCodeState()
	WZLog("WndFriendInviteCode:setData", self.m_nState, successFlag)
	if self.m_nState == 0 then
		if successFlag == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SUBMIT_OK)
			--提交成功，关闭窗口
			CacheCenter:resetInviteState(1)
			self.m_nState = 1
			WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
		else
			WZLog("WndFriendInviteCode:setData  Fail")
			MsgBoxManager:showTipBox(LocalStrings.INVITE_CODE_NOT_EXIST)
		end
		return 
	else
		self.m_tFriend = {}
		self.m_tFriend.id = playerId
		self.m_tFriend.name = name
		self.m_tFriend.level = level
		self.m_tFriend.vipLevel = vipLevel
		self.m_tFriend.serverName = CacheCenter:getServerNameByServerId(serverid)
		self.m_tFriend.headItemId = headId
		self.m_tFriend.faceItemId = faceId
		self.m_tFriend.sex = sex
		self.m_tFriend.headColor = headColor
		self.m_tFriend.headEffectId = headEffectId or 0

		self.m_sMyInviteCode = code
	end
	
	self:_update()
end

--@brief 	外部接口
function WndFriendInviteCode:showInterface()
	-- body
	local wndInviteCode = WndFriendInviteCode:createElement()
	if wndInviteCode then
		WindowManager:addWindow(wndInviteCode, WndFriendInviteCode)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
