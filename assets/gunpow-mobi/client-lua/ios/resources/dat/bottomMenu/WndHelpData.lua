--WndHelpData.lua
--@brief	WndHelp的数据模块
--@date		2014/01/14
--@author	liangguang_long
--@note		帮助模块

WndHelp = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHelp:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sHelp = nil 					--帮助说明
	self.m_nLoadingId = nil     		--加载框ID
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHelp:_unInit()
	self.m_root = nil
	self.m_sHelp = nil 					--帮助说明
	self.m_nLoadingId = nil      		--加载框ID
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHelp:createElement()
	local element = WZUISystem:getInstance():createElement("WndHelp")
	assert(element, "WndHelp create element failed!")
	self:_init()
	return element
end

--@brief	获取帮助数据函数
--@param	#1 about:会员成长值
function WndHelp:setAboutData( help )
	if self.m_root == nil then 
		return 
	end
	self.m_sHelp = help 
	self:_update()
	--关闭加载框
	self:closeLoading()
end

--@brief	葡语包适配函数
function WndHelp:_adaptLanguage_pt()
	if self.m_root == nil then
		return
	end
	local txtSure = self.m_root:getChildElement("txtBtnSure_WndHelp")
	if txtSure then
		txtSure = WZUILabelTTF:luaTo(txtSure)
		txtSure:setFontSize(25)
		txtSure:setRelativePosition(CCPoint(0.485,0.5))
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
