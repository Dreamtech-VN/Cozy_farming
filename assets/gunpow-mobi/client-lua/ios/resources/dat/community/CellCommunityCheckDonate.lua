--CellCommunityCheckDonate.lua
--@brief	CellCommunityCheckDonate的UI模块
--@date		2016/05/03
--@author	zsq
--@note		查看公会成员贡献


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityCheckDonate:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityCheckDonate:onExit(element)
	self:_unInit()
end

function CellCommunityCheckDonate:setData(tData)
    self.m_tData = tData
end

--@brief	查看人物信息
function CellCommunityCheckDonate:onHead()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_tData.playerId)
end

--@brief	查看人物信息
function CellCommunityCheckDonate:onCheck()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_tData.playerId)
end

--@brief	点击cell
function CellCommunityCheckDonate:onClick(element)
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--点击自己直接返回
	if self.m_tData.playerId == CacheCenter:getPlayerInfo().id then 
		WndCheckOther:show(self.m_tData.playerId)
		return 
	end 

	--创建弹出框
	local popupMenu = WndPopupMenu:createElement()
	WZLog("CellCommunityCheckDonate:onClick",popupMenu:getPositionX(),popupMenu:getPositionY(),popupMenu:isVisible())
	popupMenu:setShowAll(false)
	WndCommunityCheckDonate.m_root:addChild(popupMenu,100,100)	

	SceneMemberList.m_sCurCelName = self.m_tData.playerName
	SceneMemberList.m_nCurCelId = self.m_tData.playerId
	SceneMemberList.m_nJob = self.m_tData.position
	
	local tPopMenuItems = SceneMemberList:_getPopMenuItems(CacheCenter:getGuildInfo().position,self.m_tData.position)
	WndPopupMenu:setPopupMenuItem(tPopMenuItems, nil, 3)
	WndPopupMenu:setCallBackFunc(SceneMemberList, SceneMemberList.onClickPopupMenuItem)
	
	--转换触摸点坐标
	local cell = element:getParentElement()
	local x = cell:getPositionX()
	local y = cell:getPositionY()
	position = cell:convertToWorldSpace(CCPoint(x, y))
	position = WndCommunityCheckDonate.m_root:convertToNodeSpace(position)
	if #tPopMenuItems <= 1 then
		position.y = position.y - 110
	end
	WZLog("显示位置",position.x,position.y)

	if WndCommunityCheckDonate.m_root ~= nil then
		WndPopupMenu:popUpAtPoint(WndCommunityCheckDonate.m_root, position)
	end 
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function CellCommunityCheckDonate:onLoadData(element)
	local cellElement = WZUISystem:getInstance():createElement("CellCommunityCheckDonate")
	assert(cellElement, "CellCommunityCheckDonate cellElement create failed!")
    self.m_root:addChild(cellElement) 
	cellElement:setLuaObjectIndex(self)

	if self.m_tData == nil then return end
	--self.m_tData = tData
	local tData = self.m_tData 
	--头像
	self:_addHead(tData.headId,tData.faceId,tData.sex,nil,tData.vipLevel,tData.headColor)
	--名称
	local ttfName = GetElement(self.m_root,"ttfName",WZUILabelTTF)
	ttfName:setText(tData.playerName)
	--等级
	local ttfLevel = GetElement(self.m_root,"ttfLevel",WZUILabelTTF)
	ttfLevel:setText(tData.playerLevel)
	--职位
	local ttfTitle = GetElement(self.m_root,"ttfTitle",WZUILabelTTF)
	ttfTitle:setText(COMMUNITY_POSITION[tData.position+1])
	local ttfDonate = nil
	--贡献
	if WndCommunityCheckDonate.m_nTag == 1 then
		ttfDonate = GetElement(self.m_root,"ttfDonate",WZUILabelTTF)
		ttfDonate:setText(tData.allDonate)
	elseif WndCommunityCheckDonate.m_nTag == 2 then
		ttfDonate = GetElement(self.m_root,"ttfDonate",WZUILabelTTF)
		ttfDonate:setText(tData.weekDonate)
	elseif WndCommunityCheckDonate.m_nTag == 3 then
		ttfDonate = GetElement(self.m_root,"ttfDonate",WZUILabelTTF)
		ttfDonate:setText(tData.lastDonate)
	end
	--登陆时间
	local NTIME = 60
	local txtState = self.m_root:getChildElement("ttfTime")
	language = ProjConfig.LANGUAGE
	if "th" == language then
		txtState:setScale(0.8)
		ttfName:setScale(0.8)
		ttfLevel:setScale(0.8)
		ttfTitle:setScale(0.8)
		ttfDonate:setScale(0.8)
	end

	if "en" == language then
		txtState:setScale(0.7)
		ttfName:setScale(0.8)
		ttfLevel:setScale(0.8)
		ttfTitle:setScale(0.8)
		ttfDonate:setScale(0.8)
	end
	if "vn" == language then
		txtState:setScale(0.7)
	end

	if "pt" == language then
		txtState:setScale(0.63)
		ttfName:setScale(0.8)
		ttfLevel:setScale(0.8)
		ttfTitle:setScale(0.8)
		ttfDonate:setScale(0.8)
	end

	if "tr" == language then
		txtState:setScale(0.7)
		WZUILabelTTF:luaTo(txtState):setDimensions(GlobalMethod:CCSize(130,0))
		ttfName:setScale(0.8)
		ttfLevel:setScale(0.8)
		ttfTitle:setScale(0.8)
		ttfDonate:setScale(0.8)
	end

	if "es" == language then
		txtState:setScale(0.7)
		WZUILabelTTF:luaTo(txtState):setDimensions(GlobalMethod:CCSize(130,0))
		ttfName:setScale(0.8)
		ttfLevel:setScale(0.8)
		ttfTitle:setScale(0.8)
		ttfDonate:setScale(0.8)
	end

	if tData.onLineState == 1 then
		txtState = WZUILabelTTF:luaTo(txtState)
		txtState:setText(LocalStrings.REWARD_BTN_ONLINE)
		return
	end
	if txtState ~= nil then 
		txtState = WZUILabelTTF:luaTo(txtState)
		if txtState ~= nil and tData.onLineState ~= nil then 
			local t = tData.onLine
			local desc = ""
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
	AdaptLanguage(self) 
end

--@brief   玩家人物
function CellCommunityCheckDonate:_addHead(headId,faceId,sex,online,vipLevel,headColor)
	WZLog("CellCommunityCheckDonate:_addHead",sex)

	local head,face,sex1 

	if headId == 0 then
		head = 2
	else
		head = headId
		if GDatatab_item["id_"..headId].sex ~= nil then
			sex1 = GDatatab_item["id_"..headId].sex
		end
	end

	if faceId == 0 then
		face = 2
	else
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

	local conPlayerAni = GetElement(self.m_root,"conHead",WZUIContainer)
	local imgHead = CellHead:show(conPlayerAni,head,face,nSex,online,GlobalMethod:ccp(0.5,0.29),vipLevel,headColor)
	imgHead:setScale(1.15)
end




-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配Begin-----------------------------------------
function CellCommunityCheckDonate:_adaptLanguage_vn(  )
	local ttfTime = GetElement(self.m_root,"ttfTime",WZUILabelTTF)
	ttfTime:setScale(0.6)
	ttfTime:setDimensions(GlobalMethod:CCSize(240,0))
end
-------------------------------------语言适配End-------------------------------------------