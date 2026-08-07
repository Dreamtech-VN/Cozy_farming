--WndRegisterData.lua
--@brief	WndRegister的数据模块
--@date		2013/12/11
--@author	SuYuan
--@note		登陆窗口

WndRegister = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRegister:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sAccount = nil				--账号
	self.m_sPassword = nil				--密码
	self.m_sPswConfirm = nil			--密码确认
	self.m_sMail = nil					--邮箱
	self.m_sInviteCode = nil			--邀请码
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRegister:_unInit()
	self.m_root = nil
	self.m_sAccount = nil				
	self.m_sPassword = nil				
	self.m_sPswConfirm = nil				
	self.m_sMail = nil					
	self.m_sInviteCode = nil				
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRegister:createElement()
	local element = WZUISystem:getInstance():createElement("WndRegister")
	assert(element, "WndRegister create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	葡语包适配函数
function WndRegister:_adaptLanguage_pt()
	WZLog("WndRegister:_adaptLanguage_pt")
	local txtInviteCodeTip = self.m_root:getChildElement("txtTip_Register")
		if nil ~= txtInviteCodeTip then
			txtInviteCodeTip = WZUIFreeTextBox:luaTo(txtInviteCodeTip)
			if nil ~= txtInviteCodeTip then
				local pos = txtInviteCodeTip:getRelativePosition()
				pos.x = pos.x + 0.07
				pos.y = pos.y - 0.02
				txtInviteCodeTip:setRelativePosition(pos)
			else
				WZLog("nil == txtInviteCodeTip")
			end
		end
end



-------------------------------------私有方法模块End----------------------------------------
