--WndCommunityRank.lua
--@brief	WndCommunityRank的UI模块
--@date		2015/10/14
--@author	zsq
--@note		公会战绩排行

local PAGESIZE = 20
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityRank:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)

	self.m_nType = 1
	self:showRank()

	self.pageNumber = 1
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWarRank(PAGESIZE, self.pageNumber - 1 )

	--加载圆圈
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
end

--@brief onEnter函数执行完成回调
function WndCommunityRank:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, nil, nil)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityRank:onExit(element)
	self:_unInit()
end

function WndCommunityRank:onTouchBegan()
	WZLog("WndCommunityRank:onTouchBegan")
	if WndItemInfo then
		WndItemInfo:onCloseClick()
	end
end

--@brief	关闭按钮
function WndCommunityRank:onClose(element)
	WZLog("WndCommunityRank:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityRank, true)
	end 

	if WndCommunityHall.m_root ~= nil then
		WndCommunityHall.m_root:setVisible(true)
	end
end

--@brief	
function WndCommunityRank:onCheck(element)
	WZLog("WndCommunityRank:onCheck",element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	self.m_nType = tonumber(element:getTag())

	self:showRank()

	if self.m_nType == 1 then
		self.pageNumber = 1
		ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWarRank(PAGESIZE, self.pageNumber - 1 )

		--加载圆圈
		self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
	elseif self.m_nType ==2 then
		self.pageNumber = 1
		ProtocolProcessorSceneCommunity:send_GUILD_GetPlayerWarRank(PAGESIZE, self.pageNumber - 1 )

		--加载圆圈
		self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
	elseif self.m_nType ==3 then
		self:_update()
	elseif self.m_nType ==4 then
		self:_update()
	end
end

--@brief	点击上一页触发函数
function WndCommunityRank:onPageUp(element)
	WZLog("WndCommunityRank:onPageUp",self.pageNumber,self.totalNumber)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self:_getUpPage() then 
		self.pageNumber = self.pageNumber - 1
		local nPageNum = self.pageNumber - 1
		--取得列表
		if self.m_nType == 1 then
			ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWarRank(PAGESIZE, self.pageNumber - 1 )

			--加载圆圈
			self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
		elseif self.m_nType ==2 then
			ProtocolProcessorSceneCommunity:send_GUILD_GetPlayerWarRank(PAGESIZE, self.pageNumber - 1 )

			--加载圆圈
			self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
		end
	end
	self.turnPage = "up"
end

--@brief	点击下一页触发函数
function WndCommunityRank:onPageDown(element)
	WZLog("WndCommunityRank:onPageDown",self.pageNumber,self.totalNumber)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self:_getDownPage() then 
		self.pageNumber = self.pageNumber + 1
		local nPageNum = self.pageNumber - 1
		--取得列表
		if self.m_nType == 1 then
			ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWarRank(PAGESIZE, self.pageNumber - 1 )

			--加载圆圈
			self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
		elseif self.m_nType ==2 then
			ProtocolProcessorSceneCommunity:send_GUILD_GetPlayerWarRank(PAGESIZE, self.pageNumber - 1 )

			--加载圆圈
			self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
		end
	end
	self.turnPage = "down"
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	显示战绩排行
--@param	index:第几个标签
function WndCommunityRank:showRank()
	local con = GetElement(self.m_root,"con_WndCommunityRank",WZUITableContainer)
	local index = self.m_nType

	if index == 1 then
		GetElement(self.m_root,"title2_WndCommunityRank",WZUILabelTTF):setText(LocalStrings.COMMUNITY..LocalStrings.QUALIFYING_NAME)
		GetElement(self.m_root,"title3_WndCommunityRank",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"title4_WndCommunityRank",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"ttfBtm",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"ttfBtm",WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO64)
		con:setCellElementHeight(0.23)
	elseif index == 2 then
		GetElement(self.m_root,"title2_WndCommunityRank",WZUILabelTTF):setText(LocalStrings.PLAYER_NAME)
		GetElement(self.m_root,"title3_WndCommunityRank",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"title4_WndCommunityRank",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"ttfBtm",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"ttfBtm",WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO66)
		con:setCellElementHeight(0.23)
	elseif index == 3 then
		GetElement(self.m_root,"title2_WndCommunityRank",WZUILabelTTF):setText(LocalStrings.ATH_REWARD_CHECK)
		GetElement(self.m_root,"title3_WndCommunityRank",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"title4_WndCommunityRank",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"ttfBtm",WZUILabelTTF):setVisible(false)
		con:setCellElementHeight(0.285)
	elseif index == 4 then
		GetElement(self.m_root,"title2_WndCommunityRank",WZUILabelTTF):setText(LocalStrings.ATH_REWARD_CHECK)
		GetElement(self.m_root,"title3_WndCommunityRank",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"title4_WndCommunityRank",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"ttfBtm",WZUILabelTTF):setVisible(false)
		con:setCellElementHeight(0.285)
	end
end

--@brief	刷新列表
function WndCommunityRank:_update()
	local con = GetElement(self.m_root,"con_WndCommunityRank",WZUITableContainer)
	con:cleanTable()
	removeShowPanelNullTip(self.m_root)
	local tag = 0
	local tDataList = {}

	--上下拉触发分页
	local tbconContainer = con
	if self:_getUpPage() then
		tbconContainer:setEnableDropRefresh(false)
		local ttf = WZUILabelTTF:create()
		ttf:setText(LocalStrings.FRONT_PAGE)
		ttf:setFontSize(22)
		ttf:setUseOriginSize(true)
		ttf:setColor(GlobalMethod:ccc3(255,236,193))
		tbconContainer:setTopNotice(LocalStrings.FRONT_PAGE, LocalStrings.FRONT_PAGE_TIP)
		tbconContainer:setTopElementFunction("onPageUp")--设置TopElement的Lua回调函数
		tbconContainer:setEnableTopElement(true)--设置TopElement是否可用
		tbconContainer:setVisibleHeight(30)
		tbconContainer:setHideTopElement(false)--设置topElement是否隐藏
		tbconContainer:setTopElement(ttf)--设置容器的TopElement对象
	else
		tbconContainer:setEnableDropRefresh(false)
		tbconContainer:setEnableTopElement(false)
		tbconContainer:setHideTopElement(true)
	end
	if self:_getDownPage() then
		tbconContainer:setEnableDagLoading(false)
		local ttf = WZUILabelTTF:create()
		ttf:setText(LocalStrings.NEXT_PAGE)
		ttf:setFontSize(22)
		ttf:setColor(GlobalMethod:ccc3(255,236,193))
		ttf:setUseOriginSize(true)
		tbconContainer:setBottomNotice(LocalStrings.NEXT_PAGE, LocalStrings.NEXT_PAGE_TIP)
		tbconContainer:setBottomElementFunction("onPageDown")--设置BottomElement的Lua回调函数
		tbconContainer:setVisibleHeight(30)
		tbconContainer:setEnableBottomElement(true)--设置BottomElement是否可用
		tbconContainer:setHideBottomElement(false)--设置bottomElement是否隐藏
		tbconContainer:setBottomElement(ttf)--设置容器的BottomElement对象
	else 
		tbconContainer:setEnableDagLoading(false)
		tbconContainer:setEnableBottomElement(false)
		tbconContainer:setHideBottomElement(true)
	end

	if self.m_nType == 1 or self.m_nType == 2 then
		if #self.m_tDataList == 0 then
			ShowPanelNullTip( self.m_root)
			if self.m_root:getChildByTag(100) then
    		    self.m_root:getChildByTag(100):setScale(0.6)
    		end
		end
		for i = 1 ,#self.m_tDataList do
			local celElement,tCell = CellCommunityRank:createElement()
			celElement:setTag(i-1)
			con:setCellElement(celElement)
			tCell:setType(1)
			tCell:setRank(self.m_tDataList[i])
			if self.m_nType == 1 and self.m_tDataList[i].id == CacheCenter:getPlayerInfo().guildId then
				tCell:setGreen()
			end
			if self.m_nType == 2 and self.m_tDataList[i].id == CacheCenter:getPlayerInfo().id then
				tCell:setGreen()
			end
		end 
	elseif self.m_nType == 3 then
		for k,v in pairs(GDatatab_guild_war_reward) do
			if v.type == 1 then
				table.insert(tDataList,v)
			end
		end
		table.sort(tDataList,_sortData)
		for i=1,#tDataList do
			WZLog("创建一列")
			local celElement,tCell = CellCommunityRank:createElement()
			celElement:setTag(i-1)
			con:setCellElement(celElement)
			tCell:setType(2)
			local id = {}
			local num = {}
			for k=1,#tDataList[i].reward do
				table.insert(id,tDataList[i].reward[k][1])
				table.insert(num,tDataList[i].reward[k][2])
			end
			if i == #tDataList then
				tCell:setReward({id=id,num=num,rank=tDataList[i].rank[1][1],lastRow=true})
			else
			    tCell:setReward({id=id,num=num,rank=tDataList[i].rank[1][1]})
			end
		end
	elseif self.m_nType == 4 then
		for k,v in pairs(GDatatab_guild_war_reward) do
			if v.type == 2 then
				table.insert(tDataList,v)
			end
		end
		table.sort(tDataList,_sortData)
		for i=1,#tDataList do
			local celElement,tCell = CellCommunityRank:createElement()
			celElement:setTag(i-1)
			con:setCellElement(celElement)
			tCell:setType(2)
			local id = {}
			local num = {}
			for k=1,#tDataList[i].reward do
				table.insert(id,tDataList[i].reward[k][1])
				table.insert(num,tDataList[i].reward[k][2])
			end
			if i == #tDataList then
				tCell:setReward({id=id,num=num,rank=tDataList[i].rank[1][1],lastRow=true})
			else
			    tCell:setReward({id=id,num=num,rank=tDataList[i].rank[1][1]})
			end
		end
	end
end

--@brief	给数据排序
function _sortData(a,b)
	if a.rank[1][1] ~= b.rank[1][2] then
		return a.rank[1][1] < b.rank[1][1]
	end
end
-------------------------------------私有方法模块End----------------------------------------

----------------------------------------语言适配Begin--------------------------------------
function WndCommunityRank:_adaptLanguage_tr(  )
	for i=1,4 do
		local txt = GetElement(self.m_root,"txtArms"..i.."_WndCommunityRank",WZUILabelTTF)
		txt:setDimensions(GlobalMethod:CCSize(100,0))
	end
end

function WndCommunityRank:_adaptLanguage_es(  )
	for i=1,4 do
		local txt = GetElement(self.m_root,"txtArms"..i.."_WndCommunityRank",WZUILabelTTF)
		txt:setDimensions(GlobalMethod:CCSize(150,0))
		txt:setScale(0.6)
	end
end
---------------------------------------语言适配End-----------------------------------------