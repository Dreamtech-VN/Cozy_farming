--CellCommunityRemove.lua
--@brief	CellCommunityRemove的UI模块
--@date		2013/12/31
--@author	林庆凯
--@note		公会成员列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityRemove:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityRemove:onExit(element)
	self:_unInit()
end


--@brief	点击列表时被调用的函数
function CellCommunityRemove:onClickCellBtn(element)
	WZLog("CellCommunityRemove:onClickCellBtn(element)")
	--SceneMemberList:onClickBtnFromCellCommunityRemove(element,self.m_nJob,self.m_sPlayerName,self.m_nPlayerId,self.m_nTime,self.m_sState)
end

--@brief	查看玩家信息
function CellCommunityRemove:onCheck(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_nPlayerId)
end

--@brief	设置玩家姓名的函数
--@param    姓名
function CellCommunityRemove:setPlayerName(sPlayerName)
	if self.m_root == nil and sPlayerName == nil then 
		WZLog("CellCommunityRemove:setPlayerName(sPlayerName) self.m_root is nil ")
		return 
	end 
	self.m_sPlayerName = sPlayerName
	local txtPlayerName = self.m_root:getChildElement("txtPlayerName_CellCommunityRemove")
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
function CellCommunityRemove:setCellContentFontColor(nRed,nGreen,nBlue)
	if self.m_root == nil  then 
		WZLog(" CellCommunityRemove:setCellContentFontColor(GlobalMethod:ccc3(nRed,nGreen,nBlue)) self.m_root is nil ")
		return 
	end 
	
	--等级
	local txtLv = GetElement(self.m_root, "txtLevel_CellCommunityRemove", WZUILabelTTF)
	if txtLv ~= nil then
		txtLv:setColor(GlobalMethod:ccc3(nRed,nGreen,nBlue))
	end
	
	--玩家姓名 
	local txtPlayerName = self.m_root:getChildElement("txtPlayerName_CellCommunityRemove")
	if txtPlayerName ~= nil then 
		txtPlayerName = WZUILabelTTF:luaTo(txtPlayerName)
		if txtPlayerName ~= nil then 
			txtPlayerName:setColor(GlobalMethod:ccc3(nRed,nGreen,nBlue))
		end 
	end 
	
	--职位 
	local txtJob = self.m_root:getChildElement("txtJob_CellCommunityRemove")
	if txtJob ~= nil then 
		txtJob = WZUILabelTTF:luaTo(txtJob)
		if txtJob ~= nil then 	
			txtJob:setColor(GlobalMethod:ccc3(nRed,nGreen,nBlue))
		end 
	end 
	
	
	--今日贡献 
	local txtContribution = self.m_root:getChildElement("txtContribution_CellCommunityRemove")
	if txtContribution ~= nil then 
		txtContribution = WZUILabelTTF:luaTo(txtContribution)
		if txtContribution ~= nil then 
			txtContribution:setColor(GlobalMethod:ccc3(nRed,nGreen,nBlue))
		end 
	end 
	
	--登陆时间
	local txtState = self.m_root:getChildElement("txtState_CellCommunityRemove")
	if txtState ~= nil then 
		txtState = WZUILabelTTF:luaTo(txtState)
		if txtState ~= nil and self.m_sState ~= nil then 
			txtState:setColor(GlobalMethod:ccc3(nRed,nGreen,nBlue))
		end 
	end 

end

function CellCommunityRemove:onRemove() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--弹出窗口内容：你确定将该玩家开除？
	local wndDismissCommunity = WndDismissCommunity:createElement()
	WindowManager:addWindow(wndDismissCommunity,WndDismissCommunity)

	GetElement(WndDismissCommunity.m_root,"txtOK_WndDismissCommunity",WZUILabelTTF):setText(LocalStrings.CONFIRM)

	WndDismissCommunity:setCommunityFriedWindow(self.m_nTime, self.m_sPlayerName)
	WndDismissCommunity:setClickCelPlayerId(self.playerId)
end

function CellCommunityRemove:onCheck() 
	WndCheckOther:show(self.playerId)
end

function CellCommunityRemove:onChecked(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local check = GetElement(self.m_tCell,"checkBox",WZUICheckBox):getCheckIndex()
	if tonumber(check) == 1 then
		self.isSelect = false
	else
		self.isSelect = true
	end
end

function CellCommunityRemove:setChecked(check) 
	--GetElement(self.m_tCell,"txtPlayerName_CellCommunityRemove",WZUILabelTTF):setText("hehe?")
	GetElement(self.m_tCell,"checkBox",WZUICheckBox):setCheckIndex(check)
	
end

function CellCommunityRemove:isSelected() 
	--local s = tonumber(GetElement(self.m_root,"checkBox",WZUICheckBox):getCheckIndex())
	--if s == 1 then return true else return false end
	if self.isSelect == nil then self.isSelect = false end
	return self.isSelect
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	更新公会成员列表的函数(排名,玩家等级图片,玩家等级数量,玩家姓名,职位,贡献度,状态 )
function CellCommunityRemove:onLoadData(element)
	if self.m_root == nil then 
		WZLog("CellCommunityRemove:_update() self.m_root is nil ")
		return 
	end 
	WZLog("CellCommunityRemove:onLoadData",self.m_sPlayerName)
	local cellElement = WZUISystem:getInstance():createElement("CellCommunityRemove")
	assert(cellElement, "CellCommunityRemove cellElement create failed!")
    self.m_root:addChild(cellElement)
	self.m_tCell = cellElement
	cellElement:setLuaObjectIndex(self)
	
	--是否选中
	local condition1 = tonumber(GetElement(WndCommunityRemove.m_root,"condition1",WZUICheckBox):getCheckIndex())
	local condition2 = tonumber(GetElement(WndCommunityRemove.m_root,"condition2",WZUICheckBox):getCheckIndex())
	local condition3 = tonumber(GetElement(WndCommunityRemove.m_root,"condition3",WZUICheckBox):getCheckIndex())

	local position = self.m_nJob

			local t = self.m_nTime
			local tt = (SystemTime:getServerTime() - t)
			local dt = math.floor(self.m_nDonateTime / 1000)
			local dtt = (SystemTime:getServerTime() - dt)
			WZLog("状态",condition1,condition2,condition3,t,tt,dt,dtt,position)
			WZLog("贡献时间",dt,dtt)
			if ((condition1 == 0) or tt>86400*3) and ((condition2 == 0) or dtt>86400*3) and ((condition3 == 0) or position<2) then
				WZLog("可可",condition3,position)
				GetElement(cellElement,"checkBox",WZUICheckBox):setCheckIndex(1)
				if (condition1 == 0) and (condition2 == 0) and (condition3 == 0) then
					GetElement(cellElement,"checkBox",WZUICheckBox):setCheckIndex(0)
				end
			else
				GetElement(cellElement,"checkBox",WZUICheckBox):setCheckIndex(0)
			end

	--头像
	if self.m_sState == 1 then
		self:_addHead(self.m_nHeadId,self.m_nFaceId,self.m_nSex)
	else
		self:_addHead(self.m_nHeadId,self.m_nFaceId,self.m_nSex,true)
	end
	
	--玩家等级数量
	if self.m_nLevelNum ~= nil then 
		GetElement(self.m_root,"txtLevel_CellCommunityRemove",WZUILabelTTF):setText("Lv"..self.m_nLevelNum)
	end 
	
	
	--玩家姓名 
	local txtPlayerName = self.m_root:getChildElement("txtPlayerName_CellCommunityRemove")
	if txtPlayerName ~= nil then 
		txtPlayerName = WZUILabelTTF:luaTo(txtPlayerName)
		if txtPlayerName ~= nil and self.m_sPlayerName ~= nil  then 
			txtPlayerName:setText(self.m_sPlayerName)
		end 
	end 

	--战斗力
	GetElement(self.m_root,"txtFight_CellCommunityRemove",WZUILabelTTF):setText(LocalStrings.COMBAT..":"..self.fight)
	
	--职位 
	local txtJob = self.m_root:getChildElement("txtJob_CellCommunityRemove")
	if txtJob ~= nil then 
		txtJob = WZUILabelTTF:luaTo(txtJob)
		if txtJob ~= nil and self.m_nJob ~= nil then 
			if self.m_nJob == COMMUNITY_PRESIDENT then       --会长
				txtJob:setText("("..LocalStrings.PRESIDENT..")")
			elseif self.m_nJob == COMMUNITY_VICE_PRESIDENT then   --副会长
				txtJob:setText("("..LocalStrings.VICE_PRESIDENT..")")
			elseif self.m_nJob == COMMUNITY_ELDER then   --长老
				txtJob:setText("("..LocalStrings.ELDERS..")")
			elseif self.m_nJob == COMMUNITY_ELITE then   --精英
				txtJob:setText("("..LocalStrings.PICK..")")
			elseif self.m_nJob == COMMUNITY_MEMBER then  --普通会员
				txtJob:setText("("..LocalStrings.NORMAL_COMMUNITY_MEMBER..")")
			end 
		end 
	end 
		
	--今日贡献 
	local txtContribution = self.m_root:getChildElement("txtContribution_CellCommunityRemove")
	if txtContribution ~= nil then 
		txtContribution = WZUILabelTTF:luaTo(txtContribution)
		if txtContribution ~= nil and  self.m_nTodayContribution ~= nil and self.m_nPlayerContribution ~= nil  then 
			--txtContribution:setText(self.m_nTodayContribution .. "(" .. self.m_nPlayerContribution .. ")")
			txtContribution:setText(self.m_nTodayContribution)
		end 
	end 
	
	local NTIME = 60
	--登陆时间
	local txtState = self.m_root:getChildElement("txtState_CellCommunityRemove")
	if self.m_sState == 1 then
		txtState = WZUILabelTTF:luaTo(txtState)
		txtState:setText(LocalStrings.REWARD_BTN_ONLINE)
		return
	end
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
			local tip = LocalStrings.REWARD_BTN_LOGIN..":"--剩余时间:
			if d > 30 then
				desc = string.format(tip..LocalStrings.DAY_BEFORE,30)
			elseif d > 0 then
				desc = string.format(tip..LocalStrings.DAY_BEFORE,d)
			else
				if h > 0 then 
					desc = string.format(tip..LocalStrings.HOUR_BEFORE,h)
				elseif m > 0 then
					desc = string.format(tip..LocalStrings.MINUTE_BEFORE,m)
				else 
					desc = string.format(tip..LocalStrings.MINUTE_BEFORE,1)
				end
			end
			txtState:setText(desc)
		end 
	end 

end

--@brief   玩家人物
function CellCommunityRemove:_addHead(headId,faceId,sex,online)
	WZLog("CellCommunityRemove:_addHead",sex)

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

	local conPlayerAni = GetElement(self.m_root,"conHead_Cell",WZUIContainer)
	local imgHead = CellHead:show(conPlayerAni,head,face,nSex,online,GlobalMethod:ccp(0.54,0.29),self.vipLevel,self.headColor)
	imgHead:setScale(1.25)
end



-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin--------------------------------------------------
function CellCommunityRemove:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtState_CellCommunityRemove",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(200,0))
end
-------------------------------------语言适配End----------------------------------------------------