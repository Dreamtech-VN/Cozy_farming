--CellCommunityAppoint.lua
--@brief	CellCommunityAppoint的UI模块
--@date		2016/08/30
--@author	zsq
--@note		职位任命


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityAppoint:onEnter(element)
	self.m_root = element
end

--@brief    onenter函数已执行
function CellCommunityAppoint:onEnterTransitionDidFinish(element)
	
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityAppoint:onExit(element)
	self:_unInit()
end

function CellCommunityAppoint:setData(tData)
    self.m_tData = tData
	if WndCommunityAppoint.m_tChangeList == nil then WndCommunityAppoint.m_tChangeList = {} end
	--复选框
	local position = self.m_tData.position
	local tPosition = {COMMUNITY_VICE_PRESIDENT,COMMUNITY_ELDER,COMMUNITY_ELITE}
	if tonumber(position) == tPosition[WndCommunityAppoint.m_nTag] then
		table.insert(WndCommunityAppoint.m_tChangeList, self.m_tData.playerId)
	end
	--self:update()
end

function CellCommunityAppoint:onInfo()
	WZLog("CellCommunityAppoint:onInfo")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_tData.playerId)
end

function CellCommunityAppoint:onCheck(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if WndCommunityAppoint.m_tChangeList == nil then WndCommunityAppoint.m_tChangeList = {} end
	local check = GetElement(self.m_root,"setChat",WZUICheckBox):getCheckIndex()
	if check == 1 then
		if WndCommunityAppoint.m_nNumber >= WndCommunityAppoint.m_nTotal then
			GetElement(self.m_root,"setChat",WZUICheckBox):setCheckIndex(0)
			MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO133)
			return
		end
		WndCommunityAppoint.m_nNumber = WndCommunityAppoint.m_nNumber + 1
		table.insert(WndCommunityAppoint.m_tChangeList, self.m_tData.playerId)
	else
		WndCommunityAppoint.m_nNumber = WndCommunityAppoint.m_nNumber - 1
		for i=1,#WndCommunityAppoint.m_tChangeList do
			if WndCommunityAppoint.m_tChangeList[i] == self.m_tData.playerId then
				table.remove(WndCommunityAppoint.m_tChangeList, i)
			end
		end
	end
	GetElement(WndCommunityAppoint.m_root,"ttf2",WZUILabelTTF):setText(WndCommunityAppoint.m_nNumber.."/"..WndCommunityAppoint.m_nTotal)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellCommunityAppoint:onLoadData(element)
--function CellCommunityAppoint:update()
	local cellElement = WZUISystem:getInstance():createElement("CellCommunityAppoint")
	assert(cellElement, "CellCommunityAppoint cellElement create failed!")
    self.m_root:addChild(cellElement)
	cellElement:setLuaObjectIndex(self)

	if WndCommunityAppoint.m_tChangeList == nil then WndCommunityAppoint.m_tChangeList = {} end
	--设置文本
	GetElement(self.m_root, "ttf3", WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO106..":")
	GetElement(self.m_root, "ttf4", WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO107..":")
	GetElement(self.m_root, "ttf5", WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO105..":")
	GetElement(self.m_root, "ttf6", WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO51..":")
	--名字
	GetElement(self.m_root, "txtPlayerName", WZUILabelTTF):setText(self.m_tData.playerName)
	--等级
	GetElement(self.m_root, "txtLevel", WZUILabelTTF):setText(self.m_tData.playerLevel)
	--职位
	local txtJob = GetElement(self.m_root, "txtJob", WZUILabelTTF)
	local position = self.m_tData.position
	if position == COMMUNITY_PRESIDENT then       --会长
		txtJob:setText(LocalStrings.PRESIDENT)
	elseif position == COMMUNITY_VICE_PRESIDENT then   --副会长
		txtJob:setText(LocalStrings.VICE_PRESIDENT)
	elseif position == COMMUNITY_ELDER then   --长老
		txtJob:setText(LocalStrings.ELDERS)
	elseif position == COMMUNITY_ELITE then   --精英
		txtJob:setText(LocalStrings.PICK)
	elseif position == COMMUNITY_MEMBER then  --普通会员
		txtJob:setText(LocalStrings.NORMAL_COMMUNITY_MEMBER)
	end 
	--本周贡献
	GetElement(self.m_root, "txtContribution1", WZUILabelTTF):setText(self.m_tData.weekDonate)
	--上周贡献
	GetElement(self.m_root, "txtContribution2", WZUILabelTTF):setText(self.m_tData.lastDonate)
	--总贡献
	GetElement(self.m_root, "txtContribution3", WZUILabelTTF):setText(self.m_tData.allDonate)
	--登录时间
	GetElement(self.m_root, "txtPlayerName", WZUILabelTTF):setText(self.m_tData.playerName)
	--登陆时间
	local txtState = GetElement(self.m_root, "txtState", WZUILabelTTF)
	if self.m_tData.onLineState == 1 then
		txtState:setText(LocalStrings.REWARD_BTN_ONLINE)
	else
		local t = self.m_tData.onLine
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
		tip = ""
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
	--头像
	self.vipLevel = self.m_tData.vipLevel
	self.headColor = self.m_tData.headColor
	if self.m_tData.onLineState == 1 then
		self:_addHead(self.m_tData.headId,self.m_tData.faceId,self.m_nSex)
	else
		self:_addHead(self.m_tData.headId,self.m_tData.faceId,self.m_nSex,true)
	end
	--复选框
	local tPosition = {COMMUNITY_VICE_PRESIDENT,COMMUNITY_ELDER,COMMUNITY_ELITE}
	if tonumber(position) == tPosition[WndCommunityAppoint.m_nTag] then
		GetElement(self.m_root,"setChat",WZUICheckBox):setCheckIndex(1)
		--table.insert(WndCommunityAppoint.m_tChangeList, self.m_tData.playerId)
	else
		GetElement(self.m_root,"setChat",WZUICheckBox):setCheckIndex(0)
	end
	AdaptLanguage(self)
end

--@brief   玩家人物
function CellCommunityAppoint:_addHead(headId,faceId,sex,online)
	WZLog("CellCommunityAppoint:_addHead",sex)

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

-------------------------------------语言适配Begin-----------------------------------------------
function CellCommunityAppoint:_adaptLanguage_en(  )
	GetElement(self.m_root,"ttf3",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"ttf4",WZUILabelTTF):setFontSize(18)
	local ttf5 = GetElement(self.m_root,"ttf5",WZUILabelTTF)
	ttf5:setFontSize(18)
	ttf5:setRelativePosition(GlobalMethod:ccp(0.6,0.22))
	--ttf5:setRelativePosition(GlobalMethod:ccp(0.435,0.22))
	GetElement(self.m_root,"txtContribution1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.565,0.78))
	GetElement(self.m_root,"txtContribution2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.58,0.5))
	GetElement(self.m_root,"txtContribution3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.22))
	local name = GetElement(self.m_root,"txtPlayerName",WZUILabelTTF)
	name:setRelativePosition(GlobalMethod:ccp(0.16,0.78))
	name:setFontSize(16)
	local txtJob = GetElement(self.m_root,"txtJob",WZUILabelTTF)
	txtJob:setRelativePosition(GlobalMethod:ccp(0.245,0.22))
	txtJob:setFontSize(16)

	local txtState = GetElement(self.m_root,"txtState",WZUILabelTTF)
	txtState:setFontSize(16)
	txtState:setRelativePosition(GlobalMethod:ccp(0.78,0.78))
	local ttf6 = GetElement(self.m_root,"ttf6",WZUILabelTTF)
	ttf6:setRelativePosition(GlobalMethod:ccp(0.72,0.78))
	ttf6:setFontSize(16)
end

function CellCommunityAppoint:_adaptLanguage_th(  )
	local txtJob = GetElement(self.m_root,"txtJob",WZUILabelTTF)
	txtJob:setRelativePosition(GlobalMethod:ccp(0.245,0.22))
	GetElement(self.m_root,"txtContribution2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.53,0.5))
end

function CellCommunityAppoint:_adaptLanguage_pt(  )
	GetElement(self.m_root,"ttf3",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"ttf4",WZUILabelTTF):setFontSize(16)
	local ttf5 = GetElement(self.m_root,"ttf5",WZUILabelTTF)
	ttf5:setFontSize(16)
	ttf5:setRelativePosition(GlobalMethod:ccp(0.5,0.22))
	--ttf5:setRelativePosition(GlobalMethod:ccp(0.435,0.22))
	local contribution1 = GetElement(self.m_root,"txtContribution1",WZUILabelTTF)
	contribution1:setRelativePosition(GlobalMethod:ccp(0.54,0.78))
	contribution1:setFontSize(18)
	GetElement(self.m_root,"txtContribution2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.58,0.5))
	GetElement(self.m_root,"txtContribution3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.615,0.22))
	local name = GetElement(self.m_root,"txtPlayerName",WZUILabelTTF)
	name:setRelativePosition(GlobalMethod:ccp(0.16,0.78))
	name:setFontSize(16)
	local txtJob = GetElement(self.m_root,"txtJob",WZUILabelTTF)
	txtJob:setRelativePosition(GlobalMethod:ccp(0.245,0.22))
	txtJob:setFontSize(16)
	GetElement(self.m_root,"ttf6",WZUILabelTTF):setFontSize(18)
	local txtState = GetElement(self.m_root,"txtState",WZUILabelTTF)
	txtState:setFontSize(16)
	txtState:setRelativePosition(GlobalMethod:ccp(0.81,0.78))
	local ttf6 = GetElement(self.m_root,"ttf6",WZUILabelTTF)
	ttf6:setRelativePosition(GlobalMethod:ccp(0.72,0.78))
	ttf6:setFontSize(16)
end

function CellCommunityAppoint:_adaptLanguage_tr(  )
	GetElement(self.m_root,"ttf3",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"ttf4",WZUILabelTTF):setFontSize(16)
	local ttf5 = GetElement(self.m_root,"ttf5",WZUILabelTTF)
	ttf5:setFontSize(16)
	ttf5:setRelativePosition(GlobalMethod:ccp(0.455,0.22))
	
	local contribution1 = GetElement(self.m_root,"txtContribution1",WZUILabelTTF)
	contribution1:setRelativePosition(GlobalMethod:ccp(0.55,0.78))
	contribution1:setFontSize(16)
	local txtContribution2 = GetElement(self.m_root,"txtContribution2",WZUILabelTTF)
	txtContribution2:setFontSize(16)
	txtContribution2:setRelativePosition(GlobalMethod:ccp(0.55,0.5))

	local txtContribution3 = GetElement(self.m_root,"txtContribution3",WZUILabelTTF)
	txtContribution3:setFontSize(16)
	txtContribution3:setRelativePosition(GlobalMethod:ccp(0.523448,0.22))

	local name = GetElement(self.m_root,"txtPlayerName",WZUILabelTTF)
	name:setFontSize(16)

	local txtJob = GetElement(self.m_root,"txtJob",WZUILabelTTF)
	txtJob:setRelativePosition(GlobalMethod:ccp(0.25,0.22))
	txtJob:setFontSize(16)
	txtJob:setDimensions(GlobalMethod:CCSize(100))

	local txtState = GetElement(self.m_root,"txtState",WZUILabelTTF)
	txtState:setFontSize(16)
	txtState:setRelativePosition(GlobalMethod:ccp(0.8,0.78))

	local ttf6 = GetElement(self.m_root,"ttf6",WZUILabelTTF)
	ttf6:setRelativePosition(GlobalMethod:ccp(0.72,0.78))
	ttf6:setFontSize(16)
	ttf6:setDimensions(GlobalMethod:CCSize(130,0))

	GetElement(self.m_root, "txtLevel", WZUILabelTTF):setFontSize(16)
end

function CellCommunityAppoint:_adaptLanguage_es(  )
	GetElement(self.m_root,"ttf3",WZUILabelTTF):setFontSize(16)
	local ttf4 = GetElement(self.m_root,"ttf4",WZUILabelTTF)
	ttf4:setFontSize(16)
	ttf4:setRelativePosition(GlobalMethod:ccp(0.46,0.5))

	local ttf5 = GetElement(self.m_root,"ttf5",WZUILabelTTF)
	ttf5:setFontSize(16)
	ttf5:setRelativePosition(GlobalMethod:ccp(0.5,0.22))

	GetElement(self.m_root,"ttf6",WZUILabelTTF):setFontSize(16)

	local contribution1 = GetElement(self.m_root,"txtContribution1",WZUILabelTTF)
	contribution1:setRelativePosition(GlobalMethod:ccp(0.54,0.78))
	contribution1:setFontSize(18)
	GetElement(self.m_root,"txtContribution2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.64,0.5))
	GetElement(self.m_root,"txtContribution3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.615,0.22))

	local txtState = GetElement(self.m_root,"txtState",WZUILabelTTF)
	txtState:setFontSize(16)
	txtState:setRelativePosition(GlobalMethod:ccp(0.81,0.78))

	local name = GetElement(self.m_root,"txtPlayerName",WZUILabelTTF)
	name:setRelativePosition(GlobalMethod:ccp(0.16,0.78))
	name:setFontSize(16)
	
	local txtJob = GetElement(self.m_root,"txtJob",WZUILabelTTF)
	txtJob:setRelativePosition(GlobalMethod:ccp(0.245,0.22))
	txtJob:setFontSize(16)
end
-------------------------------------语言适配End-----------------------------------------------