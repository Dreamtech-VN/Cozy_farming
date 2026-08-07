--WndChangeAccountData.lua
--@brief	WndChangeAccount的数据模块
--@date		2014/01/23
--@author	SuYuan
--@note		切换账号窗口

WndChangeAccount = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndChangeAccount:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sAccount = nil				--账号
	self.m_sPassword = nil				--密码
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndChangeAccount:_unInit()
	self.m_root = nil
	self.m_sAccount = nil
	self.m_sPassword = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndChangeAccount:createElement()
	local element = WZUISystem:getInstance():createElement("WndChangeAccount")
	assert(element, "WndChangeAccount create element failed!")
	self:_init()
	return element
end


--@brief	葡语包适配函数
function WndChangeAccount:_adaptLanguage_pt()
	if self.m_root == nil then
		return
	end
	--确定按钮
	local txtBtnSure = self.m_root:getChildElement("txtBtnSure_WndChangeAccount")
	if txtBtnSure then
		txtBtnSure = WZUILabelTTF:luaTo(txtBtnSure)
		txtBtnSure:setFontSize(25)
		txtBtnSure:setRelativePosition(CCPoint(0.45,0.5))
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
