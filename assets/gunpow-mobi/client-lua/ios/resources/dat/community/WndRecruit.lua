--WndRecruit.lua
--@brief	WndRecruit的UI模块
--@date		2013/12/26
--@author	林庆凯
--@note		招收会员的窗口
--会员审批


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRecruit:onEnter(element)
	self.m_root = element
end

--@brief	
function WndRecruit:onEnterTransitionDidFinish(element)
	--静态初始化UI文本
	self:_updateUiText()
	--多语言版本界面适配
    AdaptLanguage(self)

	ProtocolProcessorSceneCommunity:send_GUILD_GetApplyerList()
	SceneCommunityMain:createLoading()
	
	local guildInfo = CacheCenter:getGuildInfo()
	if guildInfo == nil then return end
	GetElement(self.m_root,"ttfNumber",WZUILabelTTF):setText(SceneMemberList.m_nMembers.."/"..GDatatab_guild_level["id_"..guildInfo.guildLevel].total)
	AdaptLanguage(self)
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRecruit:onExit(element)
	self:_unInit()
end

function WndRecruit:onActionCallBack()
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndRecruit, true)
	end 
end


function WndRecruit:onCloseActionCallback()
	WindowManager:removeWindow(self.m_root,nWndRecruit, true)
end

--@brief	点击关闭按钮时函数
function WndRecruit:onCloseWindowBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, WndRecruit, true)
	--if self.m_root ~= nil then 
	--	WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	--end 
	SceneMemberList:setMinPosition()
end 


--@brief 点击同意按钮时的回调函数
function WndRecruit:onAgreeBtn(element)
	WZLog(" WndRecruit:onAgreeBtn(element)")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_SelPlayerIdList == nil then return end
	--判断公会人数是否到达上限
	local guildLevel = SceneMemberList.m_nGuildLevel
	WZLog("当前人数",SceneMemberList.m_nMembers,"总人数",GDatatab_guild_level["id_"..guildLevel].total)
	if tonumber(SceneMemberList.m_nMembers+#self.m_SelPlayerIdList) > tonumber(GDatatab_guild_level["id_"..guildLevel].total) then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO17)
		return
	end
	self:_setCheckBoxSelState(0)
	--把表格转换成整型数组
	local vans = WZLuaVector_int_:create()
	if self.m_SelPlayerIdList ~= nil then 
		for var = 1 ,#self.m_SelPlayerIdList do 
			vans:push(tonumber(self.m_SelPlayerIdList[var]))
		end 
		WZLog("WndRecruit:onAgreeBtn",Serialize(VectorToTable(vans)))
		ProtocolProcessorSceneCommunity:send_GUILD_Approval(vans, 1 )
	end 
	--获取公会大厅
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()	
	SceneCommunityMain:createLoading()
end 

--@brief	点击拒绝按钮时的回调函数
function WndRecruit:onRefuseBtn(element)
	WZLog("  WndRecruit:onRefuseBtn(element)")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:_setCheckBoxSelState(0)
	--把表格转换成整型数组
	local vans = WZLuaVector_int_:create()
	if self.m_SelPlayerIdList ~= nil then 
		for var = 1 ,#self.m_SelPlayerIdList do
			vans:push(tonumber(self.m_SelPlayerIdList[var]))
		end 
		ProtocolProcessorSceneCommunity:send_GUILD_Approval(vans, 0 )
	end 	
	
end 

--@brief	点击全选复选框的回调函数
function WndRecruit:onSelCheckBoxAllSel(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then 
		WZLog("WndRecruit:onSelCheckBoxAllSel(element) self.m_root is nil ")
		return 
	end 
	--取得当前状态 
	local nCheckBoxState = self:_getCheckBoxSelState()
	

	--根据在表格中的Tag值取得当前的容器的表对象设置相应的状态   
	local tbconTextMemberList = self.m_root:getChildElement("tbconTextMemberList_WndRecruit")
	if tbconTextMemberList ~= nil then 
		tbconTextMemberList = WZUITableContainer:luaTo(tbconTextMemberList)
		if tbconTextMemberList ~= nil then 
			for var = 1,#self.m_tPendProList  do 
				local celElement = tbconTextMemberList:getCellElement(var-1)
				celElement = WZUIContainer:luaTo(celElement)
				if celElement ~= nil then 
					if nCheckBoxState  == 0 then   --全选中状态
						CellRecruitList:setCheckBoxSelState(celElement,1)	
					elseif nCheckBoxState  == 1 then  
						CellRecruitList:setCheckBoxSelState(celElement,0)	
					end 
				end				
			end 
		end 
	end 
	
	if nCheckBoxState == 1 then  --没全选
		self.m_SelPlayerIdList = {}
	elseif nCheckBoxState == 0 then --全选
		self.m_SelPlayerIdList = {}
		--self.m_SelPlayerIdList = self:deepcopy(self.m_tPendProList)
		for i=1,#self.m_tPendProList do
			table.insert(self.m_SelPlayerIdList,self.m_tPendProList[i].playerId)
		end
	end 
	
end 


--@brief	点击表格中复选框的函数
--@param  #1   nPLayerId:成员ID
--@param  #2   nFlagSel:选中标志
function WndRecruit:onSelCheckBoxByCelRecruit(nPLayerId,nFlagSel)
	WZLog(" WndRecruit:onSelCheckBoxByCelRecruit(element)")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if nFlagSel == 0 then     --选中加入数据
		table.insert(self.m_SelPlayerIdList,nPLayerId)
	elseif nFlagSel  == 1 then  --不选中删除数据   
		self:_deleteAsPlayerId(nPLayerId)
		self:_setCheckBoxSelState(0)
	end 
end 


--@brief	逐帧加载tbconText每个单元格的定时器回调方法
--@param	element:定时器绑定的UI节点引用
--@param	delta:定时器回调间隔
--@note		采用定时器逐帧加载tbconText的每一项(或几项)，防止在同一帧中加载太多数据导致的卡顿以及瞬间的内存脉冲
function WndRecruit:ScheduleCreateCell(element, delta)
	local element = GetElement(self.m_root,"tbconTextMemberList_WndRecruit",WZUITableContainer)

	if element == nil or self.m_nCurCelIndex == nil  then 
		element:disableSchedule()
	end 	
	
	if self.m_tPendProList == nil then 
		element:disableSchedule()
		return 
	end 

	local length = math.min(self.m_nEndIndex,#self.m_tPendProList)
	
	if self.m_nCurCelIndex > length or self.m_nCurCelIndex < 1 then 
		element:disableSchedule()
		if self.m_nEndIndex < #self.m_tPendProList then
			element:setEnableDagLoading(false)
			local ttf = WZUILabelTTF:create()
			ttf:setText(LocalStrings.NEXT_PAGE)
			ttf:setFontSize(22)
			ttf:setColor(GlobalMethod:ccc3(255,236,193))
			ttf:setUseOriginSize(true)
			element:setBottomNotice(LocalStrings.NEXT_PAGE, LocalStrings.NEXT_PAGE_TIP)
			element:setBottomElementFunction("onPageDown")--设置BottomElement的Lua回调函数
			element:setVisibleHeight(30)
			element:setEnableBottomElement(true)--设置BottomElement是否可用
			element:setHideBottomElement(false)--设置bottomElement是否隐藏
			element:setBottomElement(ttf)--设置容器的BottomElement对象
		else 
			element:setEnableDagLoading(false)
			element:setEnableBottomElement(false)
			element:setHideBottomElement(true)
		end
	end 
	--每帧加载表格元素
	if self.m_nCurCelIndex >  length then    
		return
	end 
	local celElement,tCell = CellRecruitList:createElement()
	if celElement ~= nil and tCell ~= nil then 
		celElement:setTag(self.m_nCurCelIndex -1)
		element:setCellElement(celElement)
		--设置内容
		tCell:setRecruitListContent(self.m_tPendProList[self.m_nCurCelIndex].playerLevel,
									self.m_tPendProList[self.m_nCurCelIndex].playerName,
									self.m_tPendProList[self.m_nCurCelIndex].vipLevel,
									self.m_tPendProList[self.m_nCurCelIndex].headId,
									self.m_tPendProList[self.m_nCurCelIndex].faceId,
									self.m_tPendProList[self.m_nCurCelIndex].sex,
									self.m_tPendProList[self.m_nCurCelIndex].fight,
									self.m_tPendProList[self.m_nCurCelIndex].headColor)
		--设置ID
		tCell:setPlayerId(self.m_tPendProList[self.m_nCurCelIndex].playerId)
		if self.m_nEndIndex == 40 then
			element:getMoveElement():setPositionY(element:getMinPosition().y+1300-45)
		end
	end 
	self.m_nCurCelIndex = self.m_nCurCelIndex  + 1 
end 

--@brief	点击下一页触发函数
--@param	element:表绑定的UI节点引用
function WndRecruit:onPageDown(element)
	WZLog("WndRecruit:onPageDown",self.m_nCurCelIndex)
	self.m_nEndIndex = self.m_nEndIndex + 20
	local tableCon = GetElement(self.m_root,"tbconTextMemberList_WndRecruit",WZUITableContainer)
	tableCon:enableSchedule("ScheduleCreateCell")
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新待审批成员列表的函数
function WndRecruit:_update()
	if self.m_root == nil then 
		WZLog(" WndRecruit:_update() self.m_root is nil ")
		return 
	end 

	self.m_nCurCelIndex = 1 
	self.m_SelPlayerIdList = {}  
	--设置表格中的数据
	local tbconText = self.m_root:getChildElement("tbconTextMemberList_WndRecruit")
	if tbconText ~= nil then 
		tbconText = WZUITableContainer:luaTo(tbconText)
		if tbconText ~= nil then 
			tbconText:cleanTable()
			self.m_nEndIndex = 20
			--开启逐帧加载tbconText每个单元格的定时器
			tbconText:enableSchedule("ScheduleCreateCell")
		end 
	end 
end 


--@brief	取得选择复选框状态的函数
--@param 	nFalg 选中状态 
function WndRecruit:_getCheckBoxSelState()
	if self.m_root == nil then 
		WZLog("CellRecruitList:getCheckBoxSelState() self.m_root is nil ")
		return 
	end 
	
	local checkBoxAllSel = self.m_root:getChildElement("checkBoxAllSel_WndRecruit")
	if checkBoxAllSel ~= nil then 
		checkBoxAllSel = WZUICheckBox:luaTo(checkBoxAllSel)
		if checkBoxAllSel ~= nil then 
			--返回选中状态 
			return checkBoxAllSel:getCheckIndex()
		end 
	end 
end 


--@brief	设置选择复选框状态的函数
--@param 	nFalg 选中状态 
function WndRecruit:_setCheckBoxSelState(nFalg)
	if self.m_root == nil then 
		WZLog("  WndRecruit:_setCheckBoxSelState(nFalg) is nil ")
		return 
	end 
	
	local checkBoxSel = self.m_root:getChildElement("checkBoxAllSel_WndRecruit")
	if checkBoxSel ~= nil then 
		checkBoxSel = WZUICheckBox:luaTo(checkBoxSel)
		if checkBoxSel ~= nil then 
			--设置选中状态 
			checkBoxSel:setCheckIndex(nFalg)
		end 
	end 
end 

--@brief   根据成员ID从表格中删除的数据函数
--@param  nId 成员ID
function WndRecruit:_deleteAsPlayerId(nId)
	if self.m_SelPlayerIdList ~= nil then 
		for var = 1,#self.m_SelPlayerIdList do 
			if nId == self.m_SelPlayerIdList[var] then 
				WZLog("********************************")
				table.remove(self.m_SelPlayerIdList,var)
				WZLog("222  #self.m_SelPlayerIdList = ",#self.m_SelPlayerIdList)
			end 
		end 
	end 
end 

--@brief 静态初始化UI文本
function WndRecruit:_updateUiText()
	if self.m_root == nil then 
		return 
	end 
	
	local txtSelectAll = self.m_root:getChildElement("txtSelectAll_WndRecruit")
	if txtSelectAll == nil then 
		return 
	end 
	
	WZUILabelTTF:luaTo(txtSelectAll):setText(LocalStrings.SELECT_ALL)
end 

function WndRecruit:_adaptLanguage_vn()
	WZLog("WndRecruit:_adaptLanguage_vn")
	GetElement(self.m_root,"txtSelectAll_WndRecruit",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.716337,0.843))
    GetElement(self.m_root,"ttfNumber",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.200743,0.843))
end

--@brief	英文包适配函数
function WndRecruit:_adaptLanguage_en()
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"ttfNumber",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.22,0.843))
	GetElement(self.m_root,"txtSelectAll_WndRecruit",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.843))
end

function WndRecruit:_adaptLanguage_pt(  )
		if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"ttfNumber",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.22,0.843))
	GetElement(self.m_root,"txtSelectAll_WndRecruit",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.843))
end

--@brief	泰文包适配函数
function WndRecruit:_adaptLanguage_th()
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"ttfNumber",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.22,0.843))
	GetElement(self.m_root,"txtSelectAll_WndRecruit",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.843))
end

function WndRecruit:_adaptLanguage_vn()
	WZLog("WndRecruit:_adaptLanguage_vn")
	GetElement(self.m_root,"txtSelectAll_WndRecruit",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.716337,0.843))
    GetElement(self.m_root,"ttfNumber",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.200743,0.843))
end

function WndRecruit:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtSelectAll_WndRecruit",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.68,0.843))
	local ttfNumber = GetElement(self.m_root,"ttfNumber",WZUILabelTTF)
	ttfNumber:setRelativePosition(GlobalMethod:ccp(0.25,0.843))
end

function WndRecruit:_adaptLanguage_es()
	GetElement(self.m_root,"txtSelectAll_WndRecruit",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.65,0.843))
    GetElement(self.m_root,"ttfNumber",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.27,0.843))
    GetElement(self.m_root,"ttfRecruit_WndRecruit",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.14,0.843))
end
-------------------------------------私有方法模块End----------------------------------------

