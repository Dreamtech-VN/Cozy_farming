--CellUnionMemberList.lua
--@brief	CellUnionMemberList的UI模块
--@date		2024/01/10
--@author	XTX
--@note		联盟成员列表Item界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellUnionMemberList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellUnionMemberList:onExit(element)
	self:_unInit()
end

--@brief	点击列表时被调用的函数
function CellUnionMemberList:onClickCellBtn(element)
	WZLog("CellUnionMemberList:onClickCellBtn(element)")
	WndUnionHall:onClickBtnFromCellCommunityMemberList(element,self.m_nJob,self.m_sPlayerName,self.m_nPlayerId,self.m_nTime,self.m_sState, self.m_nFight, self.vipLevel, self.m_nLevelNum)
end

--@brief	查看玩家信息
function CellUnionMemberList:onCheck(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_nPlayerId)
end

--@brief	设置玩家姓名的函数
--@param    姓名
function CellUnionMemberList:setPlayerName(sPlayerName)
	if self.m_root == nil and sPlayerName == nil then 
		WZLog("CellUnionMemberList:setPlayerName(sPlayerName) self.m_root is nil ")
		return 
	end 
	self.m_sPlayerName = sPlayerName
	local txtPlayerName = self.m_root:getChildElement("txtPlayerName_CellUnionMemberList")
	if txtPlayerName ~= nil then 
		txtPlayerName = WZUILabelTTF:luaTo(txtPlayerName)
		if txtPlayerName ~= nil  then 
			txtPlayerName:setText(self.m_sPlayerName)
		end 
	end 
end


--@brief	设置排名,玩家姓名 ,职位,贡献度,字体颜色的函数
--@param    #1 nRed 红色
--@param    #2 nGreen 绿色
--@param    #3 nBlue  蓝色
function CellUnionMemberList:setCellContentFontColor(nRed,nGreen,nBlue)
	if self.m_root == nil  then 
		return 
	end 
	--等级
	local txtLv = GetElement(self.m_root, "txtLevel_CellUnionMemberList", WZUILabelTTF)
	if txtLv ~= nil then
		txtLv:setColor(GlobalMethod:ccc3(nRed,nGreen,nBlue))
	end
	
	--玩家姓名 
	local txtPlayerName = self.m_root:getChildElement("txtPlayerName_CellUnionMemberList")
	if txtPlayerName ~= nil then 
		txtPlayerName = WZUILabelTTF:luaTo(txtPlayerName)
		if txtPlayerName ~= nil then 
			txtPlayerName:setColor(GlobalMethod:ccc3(nRed,nGreen,nBlue))
		end 
	end 
	
	--职位 
	local txtJob = self.m_root:getChildElement("txtJob_CellUnionMemberList")
	if txtJob ~= nil then 
		txtJob = WZUILabelTTF:luaTo(txtJob)
		if txtJob ~= nil then 	
			txtJob:setColor(GlobalMethod:ccc3(nRed,nGreen,nBlue))
		end 
	end 
	
	--今日贡献 
	local txtContribution = self.m_root:getChildElement("txtContribution_CellUnionMemberList")
	if txtContribution ~= nil then 
		txtContribution = WZUILabelTTF:luaTo(txtContribution)
		if txtContribution ~= nil then 
			txtContribution:setColor(GlobalMethod:ccc3(nRed,nGreen,nBlue))
		end 
	end 
	
	--登陆时间
	local txtState = self.m_root:getChildElement("txtState_CellUnionMemberList")
	if txtState ~= nil then 
		txtState = WZUILabelTTF:luaTo(txtState)
		if txtState ~= nil and self.m_sState ~= nil then 
			txtState:setColor(GlobalMethod:ccc3(nRed,nGreen,nBlue))
		end 
	end 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新公会成员列表的函数(排名,玩家等级图片,玩家等级数量,玩家姓名,职位,贡献度,状态 )
function CellUnionMemberList:onLoadData(element)
	if self.m_root == nil then 
		WZLog("CellUnionMemberList:_update() self.m_root is nil ")
		return 
	end 
	WZLog("CellUnionMemberList:onLoadData",self.m_sPlayerName)
	local cellElement = WZUISystem:getInstance():createElement("CellUnionMemberList")
	assert(cellElement, "CellUnionMemberList cellElement create failed!")
    self.m_root:addChild(cellElement)
	cellElement:setLuaObjectIndex(self)

	--头像
	if self.m_sState == 1 then
		self:_addHead(self.m_nHeadId,self.m_nFaceId,self.m_nSex)
	else
		self:_addHead(self.m_nHeadId,self.m_nFaceId,self.m_nSex, true)
	end 
	
	--玩家等级数量
	if self.m_nLevelNum ~= nil then 
		self:_setWhichAtlasFontVisable(self.m_nLevelNum)
	end 
	
	
	--玩家姓名 
	local txtPlayerName = self.m_root:getChildElement("txtPlayerName_CellUnionMemberList")
	if txtPlayerName ~= nil then 
		txtPlayerName = WZUILabelTTF:luaTo(txtPlayerName)
		if txtPlayerName ~= nil and self.m_sPlayerName ~= nil  then 
			txtPlayerName:setText(self.m_sPlayerName)
		end 
	end 
	
	--职位 
	local txtJob = self.m_root:getChildElement("txtJob_CellUnionMemberList")
	if txtJob ~= nil then 
		txtJob = WZUILabelTTF:luaTo(txtJob)
		if txtJob ~= nil and self.m_nJob ~= nil then 
			txtJob:setText("("..UNION_POSITION[self.m_nJob + 1]..")")
		end 
	end 
		
	--今日贡献 
	local txtContribution = self.m_root:getChildElement("txtContribution_CellUnionMemberList")
	if txtContribution ~= nil then 
		txtContribution = WZUILabelTTF:luaTo(txtContribution)
		if txtContribution ~= nil and  self.m_nTodayContribution ~= nil and self.m_nPlayerContribution ~= nil  then 
			--txtContribution:setText(self.m_nTodayContribution .. "(" .. self.m_nPlayerContribution .. ")")
			txtContribution:setText(self.m_nTodayContribution)
		end 
	end 
	
	local NTIME = 60
	--登陆时间
	local txtState = self.m_root:getChildElement("txtState_CellUnionMemberList")
	local txtLoginWord = self.m_root:getChildElement("txtLoginWord_CellUnionMemberList")
	txtLoginWord = WZUILabelTTF:luaTo(txtLoginWord)
	if self.m_sState == 1 then
		txtState = WZUILabelTTF:luaTo(txtState)
		txtState:setText(LocalStrings.REWARD_BTN_ONLINE)
		txtState:setRelativePosition(GlobalMethod:ccp(0.82, 0.5))
		txtLoginWord:setText("")
		return
	end
	txtState:setRelativePosition(GlobalMethod:ccp(0.82, 0.3))
	txtLoginWord:setText(LocalStrings.REWARD_BTN_LOGIN..":")
	if txtState ~= nil then 
		txtState = WZUILabelTTF:luaTo(txtState)
		if txtState ~= nil and self.m_sState ~= nil then 
			local t = self.m_nTime
			local desc = ""
			--local tt = (os.time() - t)
			local tt = (SystemTime:getServerTime() - t)

			s = tt % NTIME--s
			tt = math.floor(tt/NTIME)
			m = tt % NTIME--m
			tt = math.floor(tt/NTIME)
			h = tt % 24--h
			tt = math.floor(tt/24)
			d = tt --d
			local tip = ""	--剩余时间:
			if d > 30 then
				desc = string.format(tip .. LocalStrings.MONTH_BEFORE, 1)
			elseif d > 0 then
				desc = string.format(tip..LocalStrings.DAY_BEFORE,d)
			else
				if h > 0 then 
					desc = string.format(tip..LocalStrings.HOUR_BEFORE, h)
				elseif m > 3 then
					desc = string.format(tip..LocalStrings.MINUTE_BEFORE, m)
				else 
					desc = tip .. LocalStrings.JUST_NOW
				end
			end
			txtState:setText(desc)
		end 
	end 
	AdaptLanguage(self)
end

--@brief   玩家人物
function CellUnionMemberList:_addHead(headId,faceId,sex,online)
	WZLog("CellUnionMemberList:_addHead",sex)

	local head,face,sex1 

	if headId == 0 then
		head = 2
	else
		--head = GDatatab_item["id_"..headId].animation_index_code
		head = headId
		if GDatatab_item["id_"..headId].sex ~= nil then
			sex1 = GDatatab_item["id_"..headId].sex
		end
	end

	if faceId == 0 then
		face = 2
	else
		--face = GDatatab_item["id_"..faceId].animation_index_code
		face = faceId
		if GDatatab_item["id_"..faceId].sex ~= nil then
			sex1 = GDatatab_item["id_"..faceId].sex
		end
	end

	if sex1 ~= nil then
		nSex = sex1
	else
		nSex = 0
	end

	if sex ~= nil then
		nSex = sex
	end

	local aniSex = true
	local relativePosition = GlobalMethod:ccp(0.32,0.16)
	if nSex == 0 then
		aniSex = true
		relativePosition = GlobalMethod:ccp(0.28,0.24)
	else
		aniSex = false
	end

	local conPlayerAni = GetElement(self.m_root,"conHead_CellUnionMemberList",WZUIContainer)
	local imgHead = CellHead:show(conPlayerAni,head,face,nSex,online,GlobalMethod:ccp(0.54,0.29),self.vipLevel,self.headColor, nil, nil, nil, nil, self.m_nHeadEffectId)
	imgHead:setScale(1.1)
end

--@brief  设置那种颜色字体控件可见的函数
--@param sLevel 等级
function CellUnionMemberList:_setWhichAtlasFontVisable(sLevel)
	if self.m_root == nil then 
		WZLog("CellUnionMemberList:_setWhichAtlasFontVisable self.m_root is nil ")
		return 
	end 

	local txtLevel = self.m_root:getChildElement("txtLevel_CellUnionMemberList")
	if txtLevel ~= nil then 
		txtLevel = WZUILabelTTF:luaTo(txtLevel)
		if txtLevel ~= nil then 
			txtLevel:setText(tostring(self.m_nLevelNum))
			txtLevel:setVisible(true)
		end
	end  
end 

-------------------------------------私有方法模块End----------------------------------------
