--WndSuggestionData.lua
--@brief	WndSuggestion的数据模块
--@date		2014/01/14
--@author	liangguang_long
--@note		意见箱模块

WndSuggestion = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSuggestion:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nLoadingId = nil     		--加载框ID
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSuggestion:_unInit()
	self.m_root = nil
	self.m_nLoadingId = nil     		--加载框ID
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSuggestion:createElement()
	local element = WZUISystem:getInstance():createElement("WndSuggestion")
	assert(element, "WndSuggestion create element failed!")
	self:_init()
	return element
end

--意见类型  1建议，8问题咨询，9充值咨询
--@brief	设置单选框菜单列表
function WndSuggestion:_setMenuData()
	local tData = {}
	table.insert(tData ,LocalStrings.SUGGESTTYPE_SUGGEST)
	table.insert(tData ,LocalStrings.SUGGESTTYPE_QUESTIONASK)
	table.insert(tData ,LocalStrings.SUGGESTTYPE_PAYASK)
	WndSelectBox:setMenuData(tData)	
end

--@brief	葡语包适配函数
function WndSuggestion:_adaptLanguage_pt()
	if self.m_root == nil then
		return
	end
	--确定按钮
	local txtSure = self.m_root:getChildElement("txtSure_WndSuggestion")
	if txtSure then
		txtSure = WZUILabelTTF:luaTo(txtSure)
		txtSure:setFontSize(25)
		txtSure:setRelativePosition(CCPoint(0.485,0.5))
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--中文策略
function WndSuggestion:_policy(bPolicy)
	bPolicy = bPolicy or false
	local editEnter = self.m_root:getChildElement("editEnter_WndSuggestion")
	if editEnter then
		editEnter = WZUIEditBox:luaTo(editEnter)
		editEnter:setSupportMultiChar(bPolicy)
	end
end



-------------------------------------私有方法模块End----------------------------------------
