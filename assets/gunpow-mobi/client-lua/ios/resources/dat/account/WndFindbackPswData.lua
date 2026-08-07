--WndFindbackPswData.lua
--@brief	WndFindbackPsw的数据模块
--@date		2014/01/23
--@author	SuYuan
--@note		找回密码窗口

WndFindbackPsw = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFindbackPsw:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sMail = nil					--邮箱
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFindbackPsw:_unInit()
	self.m_root = nil
	self.m_sMail = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFindbackPsw:createElement()
	local element = WZUISystem:getInstance():createElement("WndFindbackPsw")
	assert(element, "WndFindbackPsw create element failed!")
	self:_init()
	return element
end

--@brief	葡语包适配函数
function WndFindbackPsw:_adaptLanguage_pt()
	if self.m_root == nil then
		return
	end
	--确定按钮
	local txtBtnSure = self.m_root:getChildElement("txtBtnSure_WndFindbackPsw")
	if txtBtnSure then
		txtBtnSure = WZUILabelTTF:luaTo(txtBtnSure)
		txtBtnSure:setFontSize(25)
		txtBtnSure:setRelativePosition(CCPoint(0.47,0.5))
	end
	
	--E-mail图片
	local imgEmail = self.m_root:getChildElement("imgEmail_WndFindbackPsw")
	if imgEmail then 
		imgEmail = WZUIImage:luaTo(imgEmail)
		imgEmail:setRelativePosition(CCPoint(0.275206,0.546744))
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
