--CellPopupMenu.lua
--@brief	CellPopupMenu的UI模块
--@date		2013/12/11
--@author	xiaoyu_wu
--@note		弹出菜单的选项单元格模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPopupMenu:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPopupMenu:onExit(element)
	self:_unInit()
end

--@brief	菜单选项被点击时的响应方法
--@param	element:表绑定的UI节点引用
--@note		菜单选项被点击时的响应方法，回调给弹出菜单
function CellPopupMenu:onClick(element)
	WndPopupMenu:onClickMenuItem(element, self.m_nId)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	界面更新函数
--@note		根据菜单选项Id生成菜单选项
function CellPopupMenu:_update()
	if self.m_root == nil or self.m_nId == nil then
		return
	end
	self:_updateWin(self.m_tMenu)

	--设置按钮显示的文字
	GetElement(self.m_root,"txt_CellPopupMenu",WZUILabelTTF):setText(g_tPopupMenuString[self.m_nId])
	GetElement(self.m_root,"txtSel_CellPopupMenu",WZUILabelTTF):setText(g_tPopupMenuString[self.m_nId])
	GetElement(self.m_root,"txtDisable_CellPopupMenu",WZUILabelTTF):setText(g_tPopupMenuString[self.m_nId])
	--语言适配
	local language = ProjConfig.LANGUAGE
	if "en" == language then
		local txt1 = GetElement(self.m_root,"txt_CellPopupMenu",WZUILabelTTF)
		local txt2 = GetElement(self.m_root,"txtSel_CellPopupMenu",WZUILabelTTF)
		if txt1:getText() == "New Guild Master" then
			WZLog("--CellPopupMenu:_update--")
			txt1:setScale(0.5)
			txt2:setScale(0.5)
		else
			txt1:setScale(0.65)
			txt2:setScale(0.65)
		end
	end
	if "pt" == language then
		local txt1 = GetElement(self.m_root,"txt_CellPopupMenu",WZUILabelTTF)
		local txt2 = GetElement(self.m_root,"txtSel_CellPopupMenu",WZUILabelTTF)
		if txt1:getText() == g_tPopupMenuString[POPUPMENU_TRANSFER] then
			txt1:setScale(0.47)
			txt2:setScale(0.47)
			txt1:setDimensions(GlobalMethod:CCSize(210))
			txt2:setDimensions(GlobalMethod:CCSize(210))
		else
			txt1:setScale(0.7)
			txt2:setScale(0.7)
		end
	end	
	if "th" == language then
		--if string.len(g_tPopupMenuString[self.m_nId]) > 10 then
			GetElement(self.m_root,"txt_CellPopupMenu",WZUILabelTTF):setScale(0.7)
			GetElement(self.m_root,"txtSel_CellPopupMenu",WZUILabelTTF):setScale(0.7)
		--end
	end	

	if "vn" == language then
		local txt = GetElement(self.m_root,"txt_CellPopupMenu",WZUILabelTTF)
		txt:setScale(0.6)
		txt:setDimensions(GlobalMethod:CCSize(180,0))
		txt:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		txt:setAlignment(kCCTextAlignmentCenter)
		local txtSel = GetElement(self.m_root,"txtSel_CellPopupMenu",WZUILabelTTF)
		txtSel:setScale(0.6)
		txtSel:setDimensions(GlobalMethod:CCSize(180,0))
		txtSel:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		txtSel:setAlignment(kCCTextAlignmentCenter)
	end

	if "tr" == language then
		GetElement(self.m_root,"txt_CellPopupMenu",WZUILabelTTF):setScale(0.6)
		GetElement(self.m_root,"txtSel_CellPopupMenu",WZUILabelTTF):setScale(0.6)
	end
	if "es" == language then
		local txt1 = GetElement(self.m_root,"txt_CellPopupMenu",WZUILabelTTF)
		txt1:setFontSize(12)
		--txt1:setDimensions(GlobalMethod:CCSize(120,0))
		local txt2 = GetElement(self.m_root,"txtSel_CellPopupMenu",WZUILabelTTF)
		txt2:setFontSize(12)
		--txt2:setDimensions(GlobalMethod:CCSize(120,0))
	end	
end

--@brief	设置按钮类型
--@param	nType 3:只显示文字
function CellPopupMenu:setBtnType(nType)
	if nType == 2 then
		GetElement(self.m_root,"imgBk1_CellPopupMenu",WZUI9Image):setFile("ui/common/common_scale9_faguang1.png")
		GetElement(self.m_root,"imgBk2_CellPopupMenu",WZUI9Image):setFile("ui/common/common_scale9_faguang1.png")
	elseif nType == 3 then
		GetElement(self.m_root,"imgBk1_CellPopupMenu",WZUI9Image):setVisible(false)
		GetElement(self.m_root,"imgBk2_CellPopupMenu",WZUI9Image):setVisible(false)
		GetElement(self.m_root,"imgLine",WZUIImage):setVisible(true)
		GetElement(self.m_root,"btn_CellPopupMenu",WZUIButton):setTouchEnable(false)
	end
end

--@brief	设置是否显示红点
function CellPopupMenu:setLightUp(bool)
	if bool == nil then return end
	GetElement(self.m_root,"imgLight_CellPopupMenu",WZUIImage):setVisible(bool)
end

function CellPopupMenu:_updateWin(tMenu)
	if tMenu == nil or tMenu.width == nil then
		return
	end
	--调整窗口大小
	local tCell = WZUIElementContainer:luaTo(self.m_root)
	local winSize = tCell:getContentSize()
	local w = winSize.width-tMenu.width
	WZLog("_updateWin:::"..self.m_root:getTag(),tMenu.width,winSize.width,winSize.height,w)
	for i=1,2 do 
		local sName = "imgBk%d_CellPopupMenu"
		sName = string.format(sName,i)
		local imgBk = self.m_root:getChildElement(sName)
		if imgBk then
			imgBk = WZUI9Image:luaTo(imgBk)
			local size = imgBk:getRelativeSize()
			--imgBk:setRelativeSize(GlobalMethod:CCSize(w/winSize.width,size.height))
		end
	end
	--tCell:setContentSize(GlobalMethod:CCSize(w,winSize.height))
end

-------------------------------------私有方法模块End----------------------------------------
