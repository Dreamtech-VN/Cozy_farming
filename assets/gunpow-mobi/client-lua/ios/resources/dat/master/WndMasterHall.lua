--WndMasterHall.lua
--@brief	WndMasterHall的UI模块
--@date		2015/05/27
--@author	zsq
--@note		师徒大厅


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMasterHall:onEnter(element)
	self.m_root = element

	--初始化UI静态文本	
	self:_initStaticUiText()
	--获取师徒大厅
	ProtocolProcessorWndMaster:send_MENTORING_GetMentoring(-1)
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMasterHall:onExit(element)
	self:_unInit()
end

--@brief	清除人物选中状态
function WndMasterHall:clearChecked()
	if self.m_tRoleAniList == nil then return end
	for i=1,#self.m_tRoleAniList do
		self.m_tRoleAniList[i]:setChecked(false)
	end
end

--@brief	师徒大厅说明
function WndMasterHall:onInfo(element)
	WZLog("WndMasterHall:onInfo")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface1(LocalStrings.MASTERINFO3)
end

--@brief	师徒大厅刷新
function WndMasterHall:onRefresh(element)
	WZLog("WndMasterHall:onRefresh")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--获取师徒大厅
	ProtocolProcessorWndMaster:send_MENTORING_GetMentoring(-1)

	--设置自己3秒内不能点击
	element:setTouchEnable(false)
	self.m_nRefreshTime = 3
	GetElement(self.m_root, "btnRefresh3_WndMasterHall", WZUILabelTTF):setText("3s")

    self.m_root:enableSchedule("scheduleRefreshTime", 1)
end

--@brief	刷新倒计时时间
function WndMasterHall:scheduleRefreshTime()
	WZLog("WndMasterHall:scheduleRefreshTime",self.m_nRefreshTime)
	if self.m_nRefreshTime > 1 then
		self.m_nRefreshTime = self.m_nRefreshTime - 1
		GetElement(self.m_root, "btnRefresh3_WndMasterHall", WZUILabelTTF):setText(self.m_nRefreshTime.."s")
	else

		GetElement(self.m_root, "btnRefresh_WndMasterHall", WZUIButton):setTouchEnable(true)
   		self.m_root:disableSchedule()
	end
end

--@brief	点击查找ID按钮时
function WndMasterHall:onClickFind(element)
	WZLog("WndMasterHall:onClickFind")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local inputText = nil 
	local editInputId  = self.m_root:getChildElement("editInputId_WndMasterHall")
	if editInputId ~= nil then 
		editInputId = WZUIEditBox:luaTo(editInputId)
		if editInputId ~= nil then 
			inputText = editInputId:getText()
		end 
	end 
	if tonumber(inputText) ~= nil then     --输入全是数字
		--获取师徒大厅
		ProtocolProcessorWndMaster:send_MENTORING_GetMentoring(tonumber(inputText))
	elseif inputText == LocalStrings.MASTERINFO16 or inputText == "" then 
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO16)
	else  
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO22)
	end 
end 

--@brief	设置查找公会ID编辑框控件状态的函数
--@param 	#sString 要默认显示的内容
function WndMasterHall:_setFindCommunityEditBoxPlaceHolder(sString)
	if self.m_root == nil then
		return 
	end 
	local editInputId  = self.m_root:getChildElement("editInputId_WndMasterHall")
	if editInputId ~= nil then 
		editInputId = WZUIEditBox:luaTo(editInputId)
		if editInputId ~= nil then 
			editInputId:setPlaceHolder(sString)
			if ProjConfig.LANGUAGE == "pt" then
				editInputId:setScale(0.78)
				editInputId:setDimensions(GlobalMethod:CCSize(0,0))
				editInputId:setRelativeSize(GlobalMethod:CCSize(1,1))
			end
		end 
	end 
	if ProjConfig.LANGUAGE == "vn" then
		WZLog("--WndMasterHall:editInputId--")
		editInputId:setFontSize(16)
	end
end 
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	刷新界面
function WndMasterHall:update()
	WZLog("WndMasterHall:update")
	local tableContainer = GetElement(self.m_root,"tbConRole_WndMasterHall",WZUITableContainer)
	if tableContainer == nil then return end
	tableContainer:cleanTable()
	tableContainer:setVisible(true)
	tableContainer:setEnableGlScissor(false)

	self.m_nStartIndex = 1
	self.m_tRoleAniList = {}
	self:_addCell()
	tableContainer:enableSchedule("_addCell",0)
end

--@brief	每帧加载Cell
function WndMasterHall:_addCell(element, t)
	if self.m_tMasterHall == nil then
		local tableContainer = GetElement(self.m_root,"tbConRole_WndMasterHall",WZUITableContainer)
		tableContainer:disableSchedule()
		return
	end
	local tableContainer = GetElement(self.m_root,"tbConRole_WndMasterHall",WZUITableContainer)
	local endIndex = math.min(self.m_nStartIndex,#self.m_tMasterHall)
	for i = self.m_nStartIndex,endIndex do 
		local celElement,tCell = CellMasterSeat:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement:setTag(i-1)    --从0开始设置Tag值
			tableContainer:setCellElement(celElement)
			tCell:setMasterSeat(self.m_tMasterHall[i],1,i)
			tCell.m_tParentWnd = self
			table.insert(self.m_tRoleAniList,tCell)
		end 
		self.m_nStartIndex = self.m_nStartIndex + 1
	end 

	--加载完成，结束计时器
	if self.m_nStartIndex > #self.m_tMasterHall or tableContainer == nil then
		tableContainer:disableSchedule()

		local playerInfo = CacheCenter:getPlayerInfo()
		local masterInfo = CacheCenter:getMasterInfo()
		if playerInfo == nil or masterInfo == nil then return end
		if playerInfo.level < MASTERLEVEL then
			--是否拜师
			if masterInfo.hasMaster == true then
				GetElement(self.m_root,"info_WndMasterHall",WZUILabelTTF):setText(LocalStrings.MASTERINFO34)
			else
				GetElement(self.m_root,"info_WndMasterHall",WZUILabelTTF):setText(LocalStrings.MASTERINFO35)
			end
		else
			--收徒人数
			if masterInfo then
				local pupilNum = masterInfo.pupil
				local moralityLevel = masterInfo.moralityLevel
				if moralityLevel == 0 then moralityLevel = 1 end
				local max_pupil = GDatatab_morality["id_"..moralityLevel].max_pupil
				GetElement(self.m_root,"info_WndMasterHall",WZUILabelTTF):setText(LocalStrings.MASTERINFO36..":"..pupilNum.."/"..max_pupil.."")
			end
		end
	end
end

--@brief 初始化UI静态文本
function WndMasterHall:_initStaticUiText()
	--请输入公会ID
	self:_setFindCommunityEditBoxPlaceHolder(LocalStrings.MASTERINFO16)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-------------------------------------------
function WndMasterHall:_adaptLanguage_en(  )
	local info = GetElement(self.m_root,"info_WndMasterHall",WZUILabelTTF)
	info:setRelativePosition(GlobalMethod:ccp(0.8,0.048))
end
-------------------------------------语言适配End---------------------------------------------