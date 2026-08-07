--WndSingleCopyMyIsland.lua
--@brief	WndSingleCopyMyIsland的UI模块
--@date		2018/06/14
--@author	Tianxiang_Xu
--@note		我的小岛界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSingleCopyMyIsland:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSingleCopyMyIsland:onExit(element)
	self:_unInit()
end

--@brief 	界面加载完成回调
function WndSingleCopyMyIsland:onEnterTransitionDidFinish(element)
	self:_createList()
end

--@brief 	关闭窗口
function WndSingleCopyMyIsland:onCloseClick(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief  跳转到相应场景
function WndSingleCopyMyIsland:onClickJump(element)
	WZLog("WndSingleCopyMyIsland:onClickJump")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local sectionId = element:getTag()
	if CopyManager:bJumpToSingleCopy(sectionId) then
		SceneCopy:showScene(1, nil, sectionId, false, nil, nil, nil, 1)
		WindowManager:removeWindow(self.m_root, self, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	创建列表
function WndSingleCopyMyIsland:_createList()
	-- body
	local tableHurdlesList = GetElement(self.m_root, "tableHurdlesList_WndFastGetItems", WZUIFreeListContainer)
	tableHurdlesList:removeAll()

	local element = WZUIContainer:luaTo(WZUISystem:getInstance():createElement("CellFastJump2_WndSingleCopyMyIsland"))
	if element then
		self:_setCellContent2(element, LocalStrings.SINGLECOPY_TEXT10, 1)

		element:setVisible(true)
		element:setContentSize(GlobalMethod:CCSize(370,40))
        element:setRelativeSize(GlobalMethod:CCSize(1,40/450))
		tableHurdlesList:pushBack(element)
	end

	if self.m_tIslandHostId and #self.m_tIslandHostId > 0 then
		for i = 1, #self.m_tIslandHostId do
			local element = WZUIContainer:luaTo(WZUISystem:getInstance():createElement("CellFastJump_WndSingleCopyMyIsland"))
			if element then
				self:_setCellContent(element, self.m_tIslandHostId[i])

				element:setVisible(true)
				element:setContentSize(GlobalMethod:CCSize(370,90))
        		element:setRelativeSize(GlobalMethod:CCSize(1,90/450))
				tableHurdlesList:pushBack(element)
			end
		end
	else
		local element = WZUIContainer:luaTo(WZUISystem:getInstance():createElement("CellFastJump2_WndSingleCopyMyIsland"))
		if element then
			self:_setCellContent2(element, LocalStrings.COMMUNITY_COMPETE_TEXT43, 2)

			element:setVisible(true)
			element:setContentSize(GlobalMethod:CCSize(370,40))
        	element:setRelativeSize(GlobalMethod:CCSize(1,40/450))
			tableHurdlesList:pushBack(element)
		end
	end

	--助战岛
	local element = WZUIContainer:luaTo(WZUISystem:getInstance():createElement("CellFastJump2_WndSingleCopyMyIsland"))
	if element then
		self:_setCellContent2(element, LocalStrings.ISLAND_OWNER_TEXT20, 1)

		element:setVisible(true)
		element:setContentSize(GlobalMethod:CCSize(370,40))
        element:setRelativeSize(GlobalMethod:CCSize(1,40/450))
		tableHurdlesList:pushBack(element)
	end

	if self.m_tIslandAssistId and #self.m_tIslandAssistId > 0 then
		for i = 1, #self.m_tIslandAssistId do
			local element = WZUIContainer:luaTo(WZUISystem:getInstance():createElement("CellFastJump_WndSingleCopyMyIsland"))
			if element then
				self:_setCellContent(element, self.m_tIslandAssistId[i])

				element:setVisible(true)
				element:setContentSize(GlobalMethod:CCSize(370,90))
        		element:setRelativeSize(GlobalMethod:CCSize(1,90/450))
				tableHurdlesList:pushBack(element)
			end
		end
	else
		local element = WZUIContainer:luaTo(WZUISystem:getInstance():createElement("CellFastJump2_WndSingleCopyMyIsland"))
		if element then
			self:_setCellContent2(element, LocalStrings.COMMUNITY_COMPETE_TEXT43, 2)

			element:setVisible(true)
			element:setContentSize(GlobalMethod:CCSize(370,40))
        	element:setRelativeSize(GlobalMethod:CCSize(1,40/450))
			tableHurdlesList:pushBack(element)
		end
	end
end

--@brief 	设置Cell内容
function WndSingleCopyMyIsland:_setCellContent(element, id)
	-- body
	local tData = GDatatab_single_map["id_" .. id]
	if tData == nil then return end 
	local txtChaptersName = GetElement(element, "txtChaptersName_WndSingleCopyMyIsland", WZUILabelTTF)
	if txtChaptersName then
		if tData.map_type == 1 then
			txtChaptersName:setText(tData.map_name .. "(" .. LocalStrings.NORMAL .. ")")
		elseif tData.map_type == 2 then
			txtChaptersName:setText(tData.map_name .. "(" .. LocalStrings.PICK .. ")")
		elseif tData.map_type == 3 then
			txtChaptersName:setText(tData.map_name .. "(" .. LocalStrings.E_DRAW .. ")")
		end
	end

	local txtChaptersDesc = GetElement(element, "txtChaptersDesc_WndSingleCopyMyIsland", WZUILabelTTF)
	if txtChaptersDesc then
		txtChaptersDesc:setText(tData.map_desc)
	end

	GetElement(element, "btnJump_CellFastJump", WZUIButton):setTag(id)

	-- 语言适配
	if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" then
		if txtChaptersName then
			txtChaptersName:setScale(0.8)
			txtChaptersName:setRelativePosition(GlobalMethod:ccp(0.03,0.76))
		end
		if txtChaptersDesc then
			txtChaptersDesc:setScale(0.8)
			txtChaptersDesc:setRelativePosition(GlobalMethod:ccp(0.03,0.57))
			txtChaptersDesc:setDimensions(GlobalMethod:CCSize(430))
		end
	end
end

--@brief 	设置Cell内容
function WndSingleCopyMyIsland:_setCellContent2(element, text, nIndex)
	-- body
	local txtInterfaceName = GetElement(element, "txtInterfaceName_WndSingleCopyMyIsland", WZUILabelTTF)
	if txtInterfaceName then
		txtInterfaceName:setText(text)
	end

	local img9Bk = GetElement(element, "img9Bk_WndSingleCopyMyIsland", WZUI9Image)
	if img9Bk then
		if nIndex == 1 then
			img9Bk:setVisible(true)
		else
			img9Bk:setVisible(false)
			txtInterfaceName:setColor(GlobalMethod:ccc3(255,236,193))
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------
