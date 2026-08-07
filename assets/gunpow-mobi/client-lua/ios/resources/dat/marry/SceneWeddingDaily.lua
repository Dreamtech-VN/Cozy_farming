--SceneWeddingDaily.lua
--@brief	SceneWeddingDaily的UI模块
--@date		2014/4/11
--@author	lqk
--@modify   qixiang_xie
--@note		每日婚礼场景


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneWeddingDaily:onEnter(element)
	SoundManager:playBgMusic(SoundDefine.E_MUSIC_WED,true)
	self.m_root = element
	WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
	ChangeChatChannel(Chat_Channel_Wedding_List)
	--获得婚礼列表（WEDDING_GetWedList = 16）
	--ProtocolProcessorMarryHoll:send_WEDDING_GetWedList( )
	--每隔30秒刷新一次婚礼列表 
	--self.m_root:enableSchedule("ReFreshMarryList",30)
	local editFind = GetElement(self.m_root,"editFind_SceneWeddingDaily",WZUIEditBox)
	editFind:setPlaceHolder(LocalStrings.EDIT_MARRY_ID)
    self:_addTop()
    WndChat:addChatWindowToCurScene()
    ProtocolProcessorSceneWeddingChurch:regAll()
end

function SceneWeddingDaily:onEnterTransitionDidFinish(element)
	WZLog("SceneWeddingDaily:onEnterTransitionDidFinish")
	self:_update()
	AdaptLanguage(self)
end
--@brief	刷新婚礼列表
--@param #1	element:对象的引用
--@param #2	delta:秒数
function SceneWeddingDaily:ReFreshMarryList(element,delta)
	--获得婚礼列表（WEDDING_GetWedList = 16）
	ProtocolProcessorMarryHoll:send_WEDDING_GetWedList( )
end 

--
function SceneWeddingDaily:onBeginEdit(element)
	WZLog("SceneWeddingDaily:onBeginEdit")
	local editFind = GetElement(self.m_root,"editFind_SceneWeddingDaily",WZUIEditBox)
	editFind:setPlaceHolder("")
end
	

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneWeddingDaily:onExit(element)
	--关闭计时器
	if self.m_otbconWeddingList then
		self.m_otbconWeddingList:disableSchedule()
	end
	ProtocolProcessorSceneWeddingChurch:unregAll()
	self:_unInit()
end

--@brief	点击返回按钮时被调用的函数
function SceneWeddingDaily:onCloseClick(element)
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	self:removeBottomBar()

	self:exitClose()
end 

--@beif  关闭婚礼列表界面
function SceneWeddingDaily:exitClose()
	local sceneCity = SceneCity:createElement()
	if sceneCity ~= nil then 
		replaceScene(sceneCity)
		SceneCity.m_bFromChurch = true
	end 
end

--@breif  删除通用bottomBar
function SceneWeddingDaily:removeBottomBar()
	local wndBottomBar = self.m_root:getChildByTag(88)
    if wndBottomBar then
        self.m_root:removeChildByTag(88,true)
    end
end

--@brief	参加按钮点击回调
--@param 	element:参加按钮的引用
function SceneWeddingDaily:onJoinBtn(element)
	WZLog("SceneWeddingDaily:onJoinBtn(element)")
	--@brief	参加婚礼（WEDDING_JoinWedding = 22）
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("self.m_tData.wedNum[self.m_nCellIndex] = ",self.m_tData[self.m_nCurrentCellIndex].wedId)
    GlobalGame.g_sWenddingNum = self.m_tData[self.m_nCurrentCellIndex].wedId
    GlobalGame.g_manName = self.m_tData[self.m_nCurrentCellIndex].manName
    GlobalGame.g_womanName=self.m_tData[self.m_nCurrentCellIndex].womanName
	
    if self.m_tData[self.m_nCurrentCellIndex].usePassword == true then --密码礼堂
       local wndIntoMerry = WndIntoMerry:createElement()
        if wndIntoMerry then
            WindowManager:addWindow(wndIntoMerry,WndIntoMerry)
        end
    else --无密码礼堂
	   ProtocolProcessorGlobal:send_WEDDING_JoinWedding(self.m_tData[self.m_nCurrentCellIndex].wedId,"")
    end
end 

--@brief  更新人物形象
function SceneWeddingDaily:updateLeftPlayerInfo(element)
	WZLog("SceneWeddingDaily:updateLeftPlayerInfo")
	element:disableSchedule()
	self:_updateBrigeGroomAndBrigeInfo(self.m_nCurrentCellIndex)
end
	
--@brief	点击婚礼单元格回调方法
--@param #1  nCellIndex：当前单元格索引 
function SceneWeddingDaily:onCellBtn(nCellIndex)
	WZLog(" SceneWeddingChurch:onCellBtn")
	WZLog("nCurBattleId = ",nCellIndex)
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if self.m_tData == nil then 
		WZLog("uiowewe")
		return 
	end 
	self.m_sCurSelWedNum  = self.m_tData[nCellIndex].wedNum
	--更新右边文字
	self:_updateRightUiText(self.m_tData[nCellIndex].manName,self.m_tData[nCellIndex].womanName,self.m_tData[nCellIndex].startTime,self.m_tData[nCellIndex].endTime)
    GlobalGame.g_manName = self.m_tData[nCellIndex].manName
    GlobalGame.g_womanName = self.m_tData[nCellIndex].womanName
	--更新右边人物信息
	--self:_updateBrigeGroomAndBrigeInfo(nCellIndex)
	
	--取得婚礼列表表格
	local tbconWeddingList = WZUITableContainer:luaTo(GetElement(self.m_root,"tbconWeddingList_SceneWeddingDaily"))
	
	local nTabTotalNum = #self.m_tData
	WZLog("nCellIndex = ",nCellIndex) 

	--for var = 0,nTabTotalNum do 
	local celElement = tbconWeddingList:getCellElement(self.m_nCurrentCellIndex-1)
	if celElement ~= nil then 
		--设为0表示不选中状态
		CellWeddingItem:setCheckBoxStates(celElement,0)
		CellWeddingItem:setCheckBoxTououEnable(celElement,true)
	end 
	celElement = tbconWeddingList:getCellElement(nCellIndex-1)
	CellWeddingItem:setCheckBoxTououEnable(celElement,false)
	--end 
	self.m_nCurrentCellIndex = nCellIndex
	--进行中
	if self.m_tData[self.m_nCurrentCellIndex].wedStatus == 1 then 
		GetElement(self.m_root,"btnJoin_SceneWeddingDaily",WZUIButton):setTouchEnable(true)
	else 
		GetElement(self.m_root,"btnJoin_SceneWeddingDaily",WZUIButton):setTouchEnable(false)
	end 
	self.m_root:enableSchedule("updateLeftPlayerInfo")
end
	
	
--@brief	切换到每日婚礼场景列表
function SceneWeddingDaily:onChangeSceneWeddingDialy()
	local sceneWeddingDaily = SceneWeddingDaily:createElement()
	if sceneWeddingDaily ~= nil then 
		replaceScene(sceneWeddingDaily)
	end 
end

--查找婚礼房间
function SceneWeddingDaily:onFind(element)
	WZLog("SceneWeddingDaily:onFind")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData == nil then return end
	local editFind = GetElement(self.m_root,"editFind_SceneWeddingDaily",WZUIEditBox)
	local txt = editFind:getText()
	local strRoomId = nil
	if txt ~= nil and txt ~= "" then
		local roomId  = txt
		roomId = tonumber(roomId)
		local tData = nil
		for i,v in ipairs(self.m_tData) do
			if roomId == v.wedId then
				strRoomId = v.wedId
				tData = v
			end
		end
		if strRoomId == nil then
		    MsgBoxManager:showTipBox(LocalStrings.MARRY_ROOM_FIND)
		else
			if tData.wedStatus == 0 then
				MsgBoxManager:showTipBox(LocalStrings.WEDDING_TIP_STATS1)
				return
			elseif tData.wedStatus == 2 then
				MsgBoxManager:showTipBox(LocalStrings.WEDDING_TIP_STATS2)
				return
			end
			GlobalGame.g_sWenddingNum = tData.wedId
			GlobalGame.g_manName = tData.manName
			GlobalGame.g_womanName=tData.womanName
			if tData.usePassword == true then --密码礼堂
			   local wndIntoMerry = WndIntoMerry:createElement()
			    if wndIntoMerry then
			        WindowManager:addWindow(wndIntoMerry,WndIntoMerry)
			    end
			else --无密码礼堂
			    ProtocolProcessorGlobal:send_WEDDING_JoinWedding(tData.wedId,"")
			end
	    end
	else
		MsgBoxManager:showTipBox(LocalStrings.NO_FIND_MARRY_TIP)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	scene更新函数
--@note 	实际上的初始化函数
function SceneWeddingDaily:_update()
    if self.m_root == nil then
        WZLog("SceneWeddingDaily:_update m_root is nil.")
		return
    end
	
	local tbconWeddingList = WZUITableContainer:luaTo(GetElement(self.m_root,"tbconWeddingList_SceneWeddingDaily"))
	if self.m_tData == nil  then 
		return 
	end 
	if self.m_nCurrentCellIndex ==-1 then
		self.m_nCurrentCellIndex = 1
		self.m_sManName  = self.m_tData[self.m_nCurrentCellIndex].manName
	elseif #self.m_tData < self.m_nCurrentCellIndex then
		self.m_nCurrentCellIndex = 1
	elseif self.m_tData[self.m_nCurrentCellIndex].manName ~= self.m_sManName  then
		self.m_nCurrentCellIndex = 1
	end
	--右边文字
	self:_updateRightUiText(self.m_tData[self.m_nCurrentCellIndex].manName,self.m_tData[self.m_nCurrentCellIndex].womanName,self.m_tData[self.m_nCurrentCellIndex].startTime,self.m_tData[self.m_nCurrentCellIndex].endTime)
	self.m_nexpectRoom = 0
	if tbconWeddingList == nil then 
		return
	end
	tbconWeddingList:cleanTable()
	self.m_otbconWeddingList = tbconWeddingList
	self:loadMarryList()
end

--@brief  加载婚礼列表
function SceneWeddingDaily:loadMarryList()
	WZLog("SceneWeddingDaily:loadMarryList")
	local ttf = WZUILabelTTF:create()
    ttf:setText(LocalStrings.UP_TO_LOAD_MORE)
    ttf:setFontSize(22)
    ttf:setColor(GlobalMethod:ccc3(138,122,106))
    ttf:setUseOriginSize(true)

    self.m_otbconWeddingList:setBottomElementFunction("onPageDown")--设置BottomElement的Lua回调函数
    self.m_otbconWeddingList:setBottomNotice(LocalStrings.UP_TO_LOAD_MORE, LocalStrings.RELAX_TO_LOAD)
    self.m_otbconWeddingList:setEnableBottomElement(true)--设置BottomElement是否可用
    self.m_otbconWeddingList:setHideBottomElement(false)--设置bottomElement是否隐藏
    self.m_otbconWeddingList:setBottomElement(ttf)--设置容器的BottomElement对象
    
    self:createTenListInfo()
end

--@brief  向下拉加载更多数据
function SceneWeddingDaily:onPageDown(element)
    WZLog("SceneWeddingDaily:onPageDown")
    self.m_otbconWeddingList:setHideBottomElement(false)
    self:createTenListInfo()
end

--@brief    每次创建10个表项
function SceneWeddingDaily:createTenListInfo()
    WZLog("********* SceneWeddingDaily:createTenListInfo **************")
    self.m_fTableCurMaxPsY = self.m_otbconWeddingList:getMaxPosition().y - 150 --80为cell高度
    for i=1+self.m_nLoadListIndex*10,10+self.m_nLoadListIndex*10 do
    	if i > self.m_nMarryListCount then
    		break
    	end

    	local celElement,tCell = CellWeddingItem:createElement()
		local sStartTime = self.m_tData[self.m_nCurrendLoadCell+1].startTime

		if ProjConfig.LANGUAGE == "vn" then
			sStartTime =os.date("%H:%M %d-%m",sStartTime)
		else
			sStartTime =os.date("%m-%d %H:%M",sStartTime)
		end

		tCell:setWeddingListUi(self.m_tData[self.m_nCurrendLoadCell+1].wedId,
											self.m_tData[self.m_nCurrendLoadCell+1].manName,
											self.m_tData[self.m_nCurrendLoadCell+1].womanName,
											self.m_tData[self.m_nCurrendLoadCell+1].wedStatus,
											self.m_tData[self.m_nCurrendLoadCell+1].marryType,
											sStartTime,self.m_tData[self.m_nCurrendLoadCell+1].usePassword)

		--设置数据表单元格索引
		tCell:setTableDataIndex(self.m_nCurrendLoadCell+1)

		if self.m_nCurrendLoadCell+1 == self.m_nCurrentCellIndex then
			tCell:setCheckBoxStates(celElement,1)
			tCell:setCheckBoxTououEnable(celElement,false)
			self:_updateBrigeGroomAndBrigeInfo(self.m_nCurrentCellIndex)
			if self.m_tData[self.m_nCurrendLoadCell+1].wedStatus == 1 then
				GetElement(self.m_root,"btnJoin_SceneWeddingDaily",WZUIButton):setTouchEnable(true)
			else
				GetElement(self.m_root,"btnJoin_SceneWeddingDaily",WZUIButton):setTouchEnable(false)
			end
		else
		    tCell:setCheckBoxStates(celElement,0)
		end
		celElement:setTag(self.m_nCurrendLoadCell)
		self.m_nCurrendLoadCell  =  self.m_nCurrendLoadCell +1
		self.m_otbconWeddingList:setCellElement(celElement)
    end
    self.m_nLoadListIndex = self.m_nLoadListIndex + 1 --已加载页数加1

    if self.m_nLoadListIndex* 10 >= self.m_nMarryListCount then
        self.m_otbconWeddingList:setEnableBottomElement(false)
    end
    self.m_otbconWeddingList:setHideBottomElement(true)
    if self.m_nLoadListIndex ~= 1 and self.m_nLoadListIndex < self.m_nTotalPage then
        self.m_otbconWeddingList:getMoveElement():setPositionY(self.m_fTableCurMaxPsY)
    end
end

--@brief	逐帧加载tbconContainer每个单元格的定时器回调方法
--@param	element:定时器绑定的UI节点引用
--@param	delta:定时器回调间隔
--@note		采用定时器逐帧加载tbconContainer的每一项(或几项)，防止在同一帧中加载太多数据导致的卡顿以及瞬间的内存脉冲
function  SceneWeddingDaily:scheduleCreateCell(element, delta)
	WZLog("SceneWeddingDaily:scheduleCreateCell ",self.m_nCurrendLoadCell,self.m_nWeddingCount )
	if element == nil  then 
		element:disableSchedule()
		return 
	end 	
	if self.m_nCurrendLoadCell >=self.m_nWeddingCount then
	    element:disableSchedule()
		return 
	end

	--每帧加载2个单元格
	for var = 1,2 do
		if self.m_nCurrendLoadCell >=self.m_nWeddingCount then
		   return
		end
	    local celElement,tCell = CellWeddingItem:createElement()
	    local sStartTime = self.m_tData[self.m_nCurrendLoadCell+1].startTime

	    if ProjConfig.LANGUAGE == "vn" then
	    	sStartTime =os.date("%H:%M %d-%m",sStartTime)
	    else
	    	sStartTime =os.date("%m-%d %H:%M",sStartTime)
	    end

        tCell:setWeddingListUi(self.m_tData[self.m_nCurrendLoadCell+1].wedId,
										self.m_tData[self.m_nCurrendLoadCell+1].manName,
										self.m_tData[self.m_nCurrendLoadCell+1].womanName,
										self.m_tData[self.m_nCurrendLoadCell+1].wedStatus,
										self.m_tData[self.m_nCurrendLoadCell+1].marryType,
										sStartTime,self.m_tData[self.m_nCurrendLoadCell+1].usePassword)
        --设置数据表单元格索引
	    tCell:setTableDataIndex(self.m_nCurrendLoadCell+1)
	    if self.m_nCurrendLoadCell+1 == self.m_nCurrentCellIndex then
	    	tCell:setCheckBoxStates(celElement,1)
	    	tCell:setCheckBoxTououEnable(celElement,false)
	    	self:_updateBrigeGroomAndBrigeInfo(self.m_nCurrentCellIndex)
	    	if self.m_tData[self.m_nCurrendLoadCell+1].wedStatus == 1 then
	    		GetElement(self.m_root,"btnJoin_SceneWeddingDaily",WZUIButton):setTouchEnable(true)
	    	else
	    		GetElement(self.m_root,"btnJoin_SceneWeddingDaily",WZUIButton):setTouchEnable(false)
	    	end
	    else
	    	tCell:setCheckBoxStates(celElement,0)
	    end
	    celElement:setTag(self.m_nCurrendLoadCell)
	    self.m_nCurrendLoadCell  =  self.m_nCurrendLoadCell +1
	    --element = WZUITableContainer:luaTo(element)
	    element:setCellElement(celElement)
	end
end 

--@brief	更新新郎，新娘，婚礼时间文本
function SceneWeddingDaily:_updateRightUiText(sBriggeName,sBrigeName,startTime,endTime)
    local startTimes = nil
    local endTimes = nil
    local strTimes = nil
	startTimes = os.date("%H:%M",startTime)
	endTimes = os.date("%H:%M",endTime)
	strTimes = startTimes.."-"..endTimes

	 --新郎
    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtBridgeGroomName_SceneWeddingDaily")):setText(sBriggeName)
    --新娘
    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtBridgeName_SceneWeddingDaily")):setText(sBrigeName)
	--婚礼时间(20:00:00-21:00:00-> 20:00-21:00)
	WZUILabelTTF:luaTo(GetElement(self.m_root,"txtWeddingStartTime_SceneWeddingDaily")):setText(strTimes)

end 



--@brief 更新新郎，新娘人物信息相关信息
--@param nCellIndex 当前单元格索引
function SceneWeddingDaily:_updateBrigeGroomAndBrigeInfo(nCellIndex)
	WZLog("SceneWeddingDaily:_updateBrigeGroomAndBrigeInfo ",nCellIndex)
	
	local propInfo = self.m_tData[nCellIndex]
	local manHead = propInfo.manHead
	local womanHead = propInfo.womanHead
	local manFace = propInfo.manFace
	local womanFace = propInfo.womanFace
	local manBody = propInfo.manBody
	local womanBody = propInfo.womanBody
	local manHeadColor = propInfo.manHeadColor
	local womanHeadColor = propInfo.womanHeadColor
	local manBodyColor = propInfo.manBodyColor
	local womanBodyColor = propInfo.womanBodyColor
    local leftCon = GetElement(self.m_root,"leftCon_SceneWeddingDaily",WZUIContainer)
	local rightCon = GetElement(self.m_root,"rightCon_SceneWeddingDaily",WZUIContainer)
	leftCon:removeAllChildrenWithCleanup(true)
	rightCon:removeAllChildrenWithCleanup(true)
	self:showPlayerAnim(0,manHead,manFace,manBody,manHeadColor,manBodyColor)
	self:showPlayerAnim(1,womanHead,womanFace,womanBody,womanHeadColor,womanBodyColor)
end

--@brief   玩家人物
function SceneWeddingDaily:showPlayerAnim(sex,phead,pface,pbody,headColor,bodyColor)
	local nSex = sex--玩家性别
	local tEquip = {phead, pface,pbody}

	local conPlayer = CreatePlayerFigure(nSex,tEquip,nil,nil,nil,nil,nil,nil,nil,nil,headColor,bodyColor)
	local conAmin = WZUIContainer:luaTo(self.m_root:getChildElement("conBrigeAndBrigeGroomArm_SceneWeddingDaily"))
	local leftCon = GetElement(conAmin,"leftCon_SceneWeddingDaily",WZUIContainer)
	local rightCon = GetElement(conAmin,"rightCon_SceneWeddingDaily",WZUIContainer)
	
	local conElement = conPlayer:getAnimNode()
	if sex ==0 then --男
		rightCon:removeAllChildrenWithCleanup(true)
		conElement:setTag(50)
	    conElement:setFlipX(true)
	    rightCon:addChild(conElement)
	elseif sex ==1 then  --女
		leftCon:removeAllChildrenWithCleanup(true)
		conElement:setTag(60)
	    leftCon:addChild(conElement)
	end
	conElement:setScale(0.95)
	conElement:setAnchorPoint(GlobalMethod:ccp(0.5,0))
    conElement:setRelativePosition(GlobalMethod:ccp(0.5,0))
	conAmin:setVisible(true)
end

--查看新娘信息
function SceneWeddingDaily:onClickLeft(element)
	WZLog("SceneWeddingDaily:onClickLeft")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurrentCellIndex ~= nil and self.m_nCurrentCellIndex ~= -1 then
		if self.m_tData ~= nil and self.m_nCurrentCellIndex <= #self.m_tData then
			local womanId =self.m_tData[self.m_nCurrentCellIndex].womanPlayerId
			if womanId ~= nil then
				WndCheckOther:show(womanId)
			end
		end
	end
end

--查看新郎信息
function SceneWeddingDaily:onClickRight(element)
	WZLog("SceneWeddingDaily:onClickRight")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurrentCellIndex ~= nil and self.m_nCurrentCellIndex ~= -1 then
		if self.m_tData ~= nil and self.m_nCurrentCellIndex <= #self.m_tData then
			local manId =self.m_tData[self.m_nCurrentCellIndex].manPlayerId
			if manId ~= nil then
				WndCheckOther:show(manId)
			end
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配器模块Begin--------------------------------------


function SceneWeddingDaily:_adaptLanguage_en()
    WZLog("SceneWeddingDaily:_adaptLanguage_en")
    local txtTitle = GetElement(self.m_root,"txtTitle_SceneWeddingDaily",WZUILabelTTF)
    txtTitle:setRelativePosition(GlobalMethod:ccp(-0.08,0.5))

    local txtWeddingStartTime = GetElement(self.m_root,"txtWeddingStartTime_SceneWeddingDaily",WZUILabelTTF)
    txtWeddingStartTime:setRelativePosition(GlobalMethod:ccp(0.516578,0.5))

    local txtBridgeName = GetElement(self.m_root,"txtBridgeName_SceneWeddingDaily",WZUILabelTTF)
    txtBridgeName:setScale(0.8)

    local txtBridgeGroomName = GetElement(self.m_root,"txtBridgeGroomName_SceneWeddingDaily",WZUILabelTTF)
    txtBridgeGroomName:setScale(0.8)

    local conFind = GetElement(self.m_root,"conFind_SceneWeddingDaily",WZUIContainer)
    conFind:setAbsContentSize(GlobalMethod:CCSize(260,40))
    conFind:updateRelativeSize()

end

function SceneWeddingDaily:_adaptLanguage_pt()
	local txtTitle = GetElement(self.m_root,"txtTitle_SceneWeddingDaily",WZUILabelTTF)
    txtTitle:setRelativePosition(GlobalMethod:ccp(-0.232,0.5))

    local txtWeddingStartTime = GetElement(self.m_root,"txtWeddingStartTime_SceneWeddingDaily",WZUILabelTTF)
    txtWeddingStartTime:setRelativePosition(GlobalMethod:ccp(0.584578,0.5))

    local txtBridgeName = GetElement(self.m_root,"txtBridgeName_SceneWeddingDaily",WZUILabelTTF)
    txtBridgeName:setScale(0.8)

    local txtBridgeGroomName = GetElement(self.m_root,"txtBridgeGroomName_SceneWeddingDaily",WZUILabelTTF)
    txtBridgeGroomName:setScale(0.8)

    local conFind = GetElement(self.m_root,"conFind_SceneWeddingDaily",WZUIContainer)
    conFind:setAbsContentSize(GlobalMethod:CCSize(260,40))
    conFind:updateRelativeSize()
end

function SceneWeddingDaily:_adaptLanguage_vn(  )
	GetElement(self.m_root,"editFind_SceneWeddingDaily",WZUIEditBox):setRelativeSize(GlobalMethod:CCSize(1,1))
end

function SceneWeddingDaily:_adaptLanguage_es(  )
	local edit = GetElement(self.m_root,"editFind_SceneWeddingDaily",WZUIEditBox)
	edit:setRelativeSize(GlobalMethod:CCSize(1,1))
	edit:setRelativePosition(GlobalMethod:ccp(0.8,0.5))
	edit:setScale(0.77)
end
-------------------------------------语言适配模模块End----------------------------------------