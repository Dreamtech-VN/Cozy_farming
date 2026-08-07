--WndCommunityLog.lua
--@brief	WndCommunityLog的UI模块
--@date		2015/04/28
--@author	zsq
--@note		公会日志


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityLog:onEnter(element)
	self.m_root = element
end

--@brief	加载完成
--function WndCommunityLog:onEnterTransitionDidFinish(element)
--	self:onCheck2()
--end

--@brief    onenter函数已执行
function WndCommunityLog:onEnterTransitionDidFinish(element)
    WZLog("WndWelfare:onEnterTransitionDidFinish")
	AdaptLanguage(self)
    --弹窗动画
    WindowManagerAni:createAppearAction(self.m_root, true, "onCheck2", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityLog:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮
function WndCommunityLog:onClose(element)
	WZLog("WndCommunityLog:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityLog, true)
	end 
end

--@brief	操作日志
function WndCommunityLog:onCheck1(element)
	WZLog("WndCommunityLog:onCheck1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	self.m_nType = 0
	ProtocolProcessorSceneCommunity:send_GUILD_GetOperationLog()
	SceneCommunityMain:createLoading()

	GetElement(self.m_root,"imgAll_WndEquip",WZUI9Image):setVisible(true)
	GetElement(self.m_root,"imgArms_WndEquip",WZUI9Image):setVisible(false)

	GetElement(self.m_root,"txtAll_WndEquip",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"txtAllSel_WndEquip",WZUILabelTTF):setVisible(true)
	GetElement(self.m_root,"txtArms_WndEquip",WZUILabelTTF):setVisible(true)
	GetElement(self.m_root,"txtArmsSel_WndEquip",WZUILabelTTF):setVisible(false)
end

--@brief	捐献日志
function WndCommunityLog:onCheck2(element)
	WZLog("WndCommunityLog:onCheck2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	self.m_nType = 1
	ProtocolProcessorSceneCommunity:send_GUILD_GetDonateLog()
	SceneCommunityMain:createLoading()

	GetElement(self.m_root,"imgAll_WndEquip",WZUI9Image):setVisible(false)
	GetElement(self.m_root,"imgArms_WndEquip",WZUI9Image):setVisible(true)

	GetElement(self.m_root,"txtAll_WndEquip",WZUILabelTTF):setVisible(true)
	GetElement(self.m_root,"txtAllSel_WndEquip",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"txtArms_WndEquip",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"txtArmsSel_WndEquip",WZUILabelTTF):setVisible(true)
end

--@brief	显示公会日志
function WndCommunityLog:showLog()
	local freeListContainer = GetElement(self.m_root,"freeconText_WndCommunityLog",WZUIFreeListContainer)
	freeListContainer:removeAll()

	local conForLog = GetElement(self.m_root, "conForLog_WndCommunityLog", WZUIContainer)
	local freeListContainer = GetElement(self.m_root,"freeconText_WndCommunityLog",WZUIFreeListContainer)
	freeListContainer:removeAll()

	if self.username1 == nil or #self.username1 == 0 then 
		--暂无数据
		ShowPanelNullTip( conForLog)
		return
	else
		removeShowPanelNullTip(conForLog)
	end
	removeShowPanelNullTip(conForLog)

	self:_setFreeListContainer()
	local startIndex = math.max(1,#self.username1 - (self.pageNumber - 1) * 20)
	local endIndex = math.max(1,#self.username1 - (self.pageNumber) * 20 + 1)
	self:updateOperatorLog(startIndex, endIndex)
end

--@brief	更新公会操作日志
function WndCommunityLog:updateOperatorLog(startIndex, endIndex)
	local freeListContainer = GetElement(self.m_root,"freeconText_WndCommunityLog",WZUIFreeListContainer)
	local position = {["0"] = LocalStrings.NORMAL_COMMUNITY_MEMBER,["1"] = LocalStrings.PICK,
		["2"] = LocalStrings.ELDERS,["3"] = LocalStrings.VICE_PRESIDENT,["4"] = LocalStrings.PRESIDENT}
	if freeListContainer ~= nil then 
		for i = startIndex ,endIndex, -1 do
			local celElement,tFreeCell = CellCommunityInfoList:createElement()
			celElement:setTag(i-1)
			tFreeCell:setLogType()
			if celElement ~= nil and tFreeCell ~= nil then 
    			local log = ""
				local time = os.date("%m-%d  %H:%M", self.createTime1[i])
				if self.m_nType == 0 then
					if self.action1[i] == 1 then           
						log = string.format(LocalStrings.COMMUNITYLOG1,self.username1[i])
					elseif self.action1[i] == 3 then         
						if self.level1 ~= nil and self.level1[i] ~= nil then
							log = string.format(LocalStrings.COMMUNITYLOG2,self.operator1[i],self.username1[i],position[tostring(self.level1[i])])
						end
					elseif self.action1[i] == 6 then         
						log = string.format(LocalStrings.COMMUNITYLOG2,self.operator1[i],self.username1[i],position["4"])
					elseif self.action1[i] == 2 then        
						log = string.format(LocalStrings.COMMUNITYLOG3,self.username1[i])
					elseif self.action1[i] == 4 then        
						if self.level1 ~= nil and self.level1[i] ~= nil then
							log = string.format(LocalStrings.COMMUNITYLOG4,self.operator1[i],self.username1[i],position[tostring(self.level1[i])])
						end
					elseif self.action1[i] == 7 then       
						log = string.format(LocalStrings.COMMUNITYLOG5,self.operator1[i],self.level1[i])
					elseif self.action1[i] == 8 then       
						log = string.format(LocalStrings.COMMUNITYLOG10,self.operator1[i],self.level1[i])
					elseif self.action1[i] == 5 then       
						log = string.format(LocalStrings.COMMUNITYLOG7,self.operator1[i],self.username1[i])
					elseif self.action1[i] == 9 then       
						log = string.format(LocalStrings.COMMUNITYLOG11,self.operator1[i],self.level1[i])
					elseif self.action1[i] == 10 then       
						log = string.format(LocalStrings.COMMUNITYLOG6,self.operator1[i],self.level1[i])
					end
				end
				tFreeCell:setLog(log,self.createTime1[i])
				celElement = WZUIContainer:luaTo(celElement)
				local freeconSize = freeListContainer:getContentSize()				
				local cellSize = celElement:getAbsContentSize()
				--自由列表只能支持相对大小
				--celElement:setRelativeSize(GlobalMethod:CCSize(cellSize.width/freeconSize.width, cellSize.height/freeconSize.height))
				freeListContainer:pushBack(celElement)
			end 
		end 
	end 
	freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
end

--@brief	显示公会捐献日志
function WndCommunityLog:showDonateLog()
	local conForLog = GetElement(self.m_root, "conForLog_WndCommunityLog", WZUIContainer)
	local freeListContainer = GetElement(self.m_root,"freeconText_WndCommunityLog",WZUIFreeListContainer)
	freeListContainer:removeAll()

	if self.username2 == nil or #self.username2 == 0 then 
		--暂无数据
		ShowPanelNullTip( conForLog)
		local freeListContainer = GetElement(self.m_root,"freeconText_WndCommunityLog",WZUIFreeListContainer)
		freeListContainer:removeAll()
		return 
	end

	self:_setFreeListContainer()
	local startIndex = math.max(1,#self.username2 - (self.pageNumber - 1) * 20)
	local endIndex = math.max(1,#self.username2 - (self.pageNumber) * 20 + 1)
	self:updateDonateLog(startIndex, endIndex)
end

--@brief	更新公会捐献日志
function WndCommunityLog:updateDonateLog(startIndex, endIndex)
	local freeListContainer = GetElement(self.m_root,"freeconText_WndCommunityLog",WZUIFreeListContainer)
	if freeListContainer ~= nil then 
		for i = startIndex ,endIndex, -1 do
			local celElement,tFreeCell = CellCommunityInfoList:createElement()
			tFreeCell:setLogType()
			if celElement ~= nil and tFreeCell ~= nil then 
    			local log = ""
				local time = os.date("%m-%d %H:%M", self.createTime2[i])
				if self.username2[i] == nil or self.cost2[i] == nil or self.reward2[i] == nil then return end
				if self.m_nType == 1 then
					if self.costType2[i] == 1 then
					--WZLog("i 是",i,Serialize(self.username2),Serialize(self.cost2),Serialize(self.reward2))
					--WZLog("i 是1",i,self.username2[i],type(self.username2[i]))
						log = string.format(LocalStrings.COMMUNITYLOG8,tostring(self.username2[i]),self.cost2[i],self.reward2[i])
					else
			WZLog("i 是",startIndex,endIndex,i)
						log = string.format(LocalStrings.COMMUNITYLOG9,self.username2[i],self.cost2[i],self.reward2[i])
					end
				end
				tFreeCell:setLog(log,self.createTime2[i])
				celElement = WZUIContainer:luaTo(celElement)
				local freeconSize = freeListContainer:getContentSize()				
				local cellSize = celElement:getAbsContentSize()
				--自由列表只能支持相对大小
				--celElement:setRelativeSize(GlobalMethod:CCSize(cellSize.width/freeconSize.width, cellSize.height/freeconSize.height))
				freeListContainer:pushBack(celElement)
			end 
		end 
	end 
	freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置容器是否显示翻页
function WndCommunityLog:_setFreeListContainer()
	local freeListContainer = GetElement(self.m_root,"freeconText_WndCommunityLog",WZUIFreeListContainer)
	if freeListContainer == nil then return end 

	--上下拉触发分页
	if self:_getUpPage() then
		freeListContainer:setEnableDropRefresh(false)
		local ttf = WZUILabelTTF:create()
		ttf:setText(LocalStrings.FRONT_PAGE)
		ttf:setFontSize(22)
		ttf:setUseOriginSize(true)
		ttf:setColor(GlobalMethod:ccc3(255,236,193))
		freeListContainer:setTopNotice(LocalStrings.FRONT_PAGE, LocalStrings.FRONT_PAGE_TIP)
		freeListContainer:setTopElementFunction("onPageUp")--设置TopElement的Lua回调函数
		freeListContainer:setEnableTopElement(true)--设置TopElement是否可用
		freeListContainer:setVisibleHeight(30)
		freeListContainer:setHideTopElement(false)--设置topElement是否隐藏
		freeListContainer:setTopElement(ttf)--设置容器的TopElement对象
	else
		freeListContainer:setEnableDropRefresh(false)
		freeListContainer:setEnableTopElement(false)
		freeListContainer:setHideTopElement(true)
	end
	if self:_getDownPage() then
		freeListContainer:setEnableDagLoading(false)
		local ttf = WZUILabelTTF:create()
		ttf:setText(LocalStrings.NEXT_PAGE)
		ttf:setFontSize(22)
		ttf:setColor(GlobalMethod:ccc3(255,236,193))
		ttf:setUseOriginSize(true)
		freeListContainer:setBottomNotice(LocalStrings.NEXT_PAGE, LocalStrings.NEXT_PAGE_TIP)
		freeListContainer:setBottomElementFunction("onPageDown")--设置BottomElement的Lua回调函数
		freeListContainer:setVisibleHeight(30)
		freeListContainer:setEnableBottomElement(true)--设置BottomElement是否可用
		freeListContainer:setHideBottomElement(false)--设置bottomElement是否隐藏
		freeListContainer:setBottomElement(ttf)--设置容器的BottomElement对象
	else 
		freeListContainer:setEnableDagLoading(false)
		freeListContainer:setEnableBottomElement(false)
		freeListContainer:setHideBottomElement(true)
	end
end 

--@brief	向上翻页
function WndCommunityLog:onPageUp()
	WZLog("WndCommunityLog:onPageUp")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.pageNumber = self.pageNumber - 1
	if self.m_nType == 0 then
		self:showLog()
	else
		self:showDonateLog()
	end
end

--@brief	向下翻页
function WndCommunityLog:onPageDown()
	WZLog("WndCommunityLog:onPageDown")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.pageNumber = self.pageNumber + 1
	if self.m_nType == 0 then
		self:showLog()
	else
		self:showDonateLog()
	end
end

function WndCommunityLog:_adaptLanguage_vn()
    WZLog("WndCommunityLog:_adaptLanguage_vn ")
    local txtAll = GetElement(self.m_root,"txtAll_WndEquip",WZUILabelTTF)
    txtAll:setDimensions(GlobalMethod:CCSize(100,0))
    txtAll:setScale(0.65)

    local txtAllSel = GetElement(self.m_root,"txtAllSel_WndEquip",WZUILabelTTF)
    txtAllSel:setDimensions(GlobalMethod:CCSize(100,0))
    txtAllSel:setScale(0.65)

    local txtArms = GetElement(self.m_root,"txtArms_WndEquip",WZUILabelTTF)
    txtArms:setScale(0.65)

    local txtArmsSel = GetElement(self.m_root,"txtArmsSel_WndEquip",WZUILabelTTF)
    txtArmsSel:setScale(0.65)
end

function WndCommunityLog:_adaptLanguage_tr()
    WZLog("WndCommunityLog:_adaptLanguage_tr ")
    local txtAll = GetElement(self.m_root,"txtAll_WndEquip",WZUILabelTTF)
    txtAll:setDimensions(GlobalMethod:CCSize(130,0))
    txtAll:setScale(0.65)

    local txtAllSel = GetElement(self.m_root,"txtAllSel_WndEquip",WZUILabelTTF)
    txtAllSel:setDimensions(GlobalMethod:CCSize(130,0))
    txtAllSel:setScale(0.65)

    local txtArms = GetElement(self.m_root,"txtArms_WndEquip",WZUILabelTTF)
    txtArms:setScale(0.65)
    txtArms:setDimensions(GlobalMethod:CCSize(130,0))

    local txtArmsSel = GetElement(self.m_root,"txtArmsSel_WndEquip",WZUILabelTTF)
    txtArmsSel:setScale(0.65)
    txtArmsSel:setDimensions(GlobalMethod:CCSize(130,0))
end

function WndCommunityLog:_adaptLanguage_es(  )
	local txtAll = GetElement(self.m_root,"txtAll_WndEquip",WZUILabelTTF)
    txtAll:setDimensions(GlobalMethod:CCSize(150,0))
    txtAll:setScale(0.6)

    local txtAllSel = GetElement(self.m_root,"txtAllSel_WndEquip",WZUILabelTTF)
    txtAllSel:setDimensions(GlobalMethod:CCSize(150,0))
    txtAllSel:setScale(0.6)

    local txtArms = GetElement(self.m_root,"txtArms_WndEquip",WZUILabelTTF)
    txtArms:setScale(0.6)
    txtArms:setDimensions(GlobalMethod:CCSize(150,0))

    local txtArmsSel = GetElement(self.m_root,"txtArmsSel_WndEquip",WZUILabelTTF)
    txtArmsSel:setScale(0.6)
    txtArmsSel:setDimensions(GlobalMethod:CCSize(150,0))
end
-------------------------------------私有方法模块End----------------------------------------
