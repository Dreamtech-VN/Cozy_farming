--CellWorldTeamBossList.lua
--@brief	CellWorldTeamBossList的UI模块
--@date		2018/07/12
--@author	Tianxiang_Xu
--@note		世界组队boss


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellWorldTeamBossList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellWorldTeamBossList:onExit(element)
	self:_unInit()
end

--@brief 	加载数据
function CellWorldTeamBossList:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellWorldTeamBossList")

    self.m_root:addChild(cellElement)
    self:_update()
	AdaptLanguage(self)
end

--@brief    其它Item点击回调
function CellWorldTeamBossList:onOthersClick(luaTable, tag, tData)
    WndItemInfo:onCloseClick()
    local con = GetElement(SceneWorldTeamBoss.m_root, "conTips_SceneWorldTeamBoss", WZUIContainer)

    WndItemInfo:showInfo(luaTable.m_root, con, 1, tData, false)
end

--@brief 	点击头像回调
function CellWorldTeamBossList:onClickHead(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	if self.m_nType == 1 or self.m_nType == 2 then
		local nTag = element:getTag()
		WndCheckOther:show(self.m_tData.player[nTag].playerId)
	end
end

--@brief 	点击等待中的房间进入
function CellWorldTeamBossList:OnCheckEnterRoom(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	if self.m_nType == 2 then
		SceneWorldTeamBoss:onRoomListClick(self)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置玩家信息
local imgRankPath = {"ui/common/common_icon_1st.png","ui/common/common_icon_2nd.png","ui/common/common_icon_3rd.png"}
function CellWorldTeamBossList:_update()
    if self.m_nType == 1 and self.m_tData.rank == SceneWorldTeamBoss.bossRoomInfo.myRank then
        local imgDi = GetElement(self.m_root, "imgRankBg_CellWorldTeamBossList", WZUI9Image)
        imgDi:setFile("ui/common/common_scale9_di38.png")
    end

    if self.m_nType == 1 or self.m_nType == 3 then
    	local nRank
    	local endRank
    	if self.m_nType == 1 then
    		nRank = self.m_tData.rank 
    	else
    		local rank = self.m_tData.rank[1]
		    nRank = rank[1]
		    endRank = rank[2]
    	end
	    if nRank <= 3 then
	        local imgRank = GetElement(self.m_root,"imgRank_CellWorldTeamBossList",WZUIImage)
	        imgRank:setFile(imgRankPath[nRank])
	        imgRank:setVisible(true)
	    else
	    	if self.m_nType == 1 then
	    		local atxtRank = GetElement(self.m_root, "atxtRank_CellWorldTeamBossList", WZUILabelAtlasFont)
	    		atxtRank:setText(nRank)
	    	else
		        local txtRank = GetElement(self.m_root,"txtRank_CellWorldTeamBossList",WZUILabelTTF)
		        if endRank == -1 then
		            txtRank:setText(nRank.."+")
		        else
		            local strR = nRank == endRank and nRank or nRank.."-"..endRank
		            txtRank:setText(strR)
		        end
	    	end
	    end
	elseif self.m_nType == 2 then
		GetElement(self.m_root, "conRank_CellWorldTeamBossList", WZUIContainer):setVisible(false)
	end

	--头像
    local conHead = GetElement(self.m_root, "conHead_CellWorldTeamBossList", WZUIContainer)
	if self.m_nType == 1 then
		for i = 1, #self.m_tData.player do
			local conHead = GetElement(self.m_root, "conHead" .. i .. "_CellWorldTeamBossList", WZUIContainer)
			conHead:setVisible(true)
			local cellElement =  CellHead:show(conHead, self.m_tData.player[i].headId, self.m_tData.player[i].faceId, self.m_tData.player[i].sex, false, nil, self.m_tData.player[i].vipLevel, self.m_tData.player[i].headColor)
		end
	elseif self.m_nType == 2 then
		conHead:setRelativePosition(GlobalMethod:ccp(0.165, 0.5))
		for i = 1, #self.m_tData.player do
			local conHead = GetElement(self.m_root, "conHead" .. i .. "_CellWorldTeamBossList", WZUIContainer)
			conHead:setVisible(true)
			local cellElement =  CellHead:show(conHead, self.m_tData.player[i].headId, self.m_tData.player[i].faceId, self.m_tData.player[i].sex, false, nil, self.m_tData.player[i].vipLevel, self.m_tData.player[i].headColor)
		end
	elseif self.m_nType == 3 then
		conHead:setVisible(false)
	end

	--名字
	local ftxtName = GetElement(self.m_root, "ftxtName_CellWorldTeamBossList", WZUIFreeTextBox)
	local ftxtRoomId = GetElement(self.m_root, "ftxtRoomId_CellWorldTeamBossList", WZUIFreeTextBox)
	local txtHurt = GetElement(self.m_root,"txtHurt_CellWorldTeamBossList",WZUILabelTTF)
	local txtName = GetElement(self.m_root,"txtName_CellWorldTeamBossList",WZUILabelTTF)
	local txtRoomState = GetElement(self.m_root,"txtRoomState_CellWorldTeamBossList",WZUILabelTTF)
	local sFormat1 = [[<T C="105,65,46" S="18" P="0">%s</T>]]
	local sFormat2 = [[<BR></BR>]]
	local conReward = GetElement(self.m_root, "conReward_CellWorldTeamBossList", WZUIContainer)
	if self.m_nType == 1 then
		local count = #self.m_tData.player
		if count == 1 then
    		ftxtName:setShowText(string.format(sFormat1, self.m_tData.player[1].name))
    	else
    		txtName:setText(self.m_tData.player[1].name .. "\n" .. "&" .. "\n" .. self.m_tData.player[2].name)
    	--	ftxtName:setShowText(string.format(sFormat1 .. sFormat2 .. sFormat1 .. sFormat2 .. sFormat1, self.m_tData.player[1].name, "&", self.m_tData.player[2].name))
    	end

    	local hurtPercent = self.m_tData.hurt/SceneWorldTeamBoss.bossRoomInfo.bossBloodMax * 100
    	local nPercent = string.format("%0.2f", hurtPercent)
    	txtHurt:setText(self.m_tData.hurt .. "(" .. nPercent .. "%" .. ")")
	elseif self.m_nType == 2 then
    	ftxtName:setShowText(string.format(sFormat1, self.m_tData.roomName))
    	ftxtName:setRelativePosition(GlobalMethod:ccp(0.485, 0.5))
    	ftxtRoomId:setShowText(string.format(sFormat1 .. sFormat2 .. sFormat1, LocalStrings.TEAMBOSS_TEXT3 .. self.m_tData.roomId, LocalStrings.PEOPLE_NUM .. self.m_tData.count .. "/" .. self.m_tData.maxNum))
    	ftxtRoomId:setRelativePosition(GlobalMethod:ccp(0.67, 0.5))
    	if self.m_tData.state == 0 then
    		txtRoomState:setText(LocalStrings.WAITING)
    	else
    		txtRoomState:setColor(GlobalMethod:ccc3(158,0,0))
    		txtRoomState:setText(LocalStrings.COMBATTING)
    	end
	elseif self.m_nType == 3 then
		conReward:setVisible(true)
		local reward = self.m_tData.reward
		for i = 1, #reward do
			local conItem = GetElement(self.m_root, "conItem"..i.."_CellWorldTeamBossList", WZUIContainer)
			local shopItems = GDatatab_item["id_"..reward[i][1]]
	        local itemInfo = {id=reward[i][1], name=shopItems.name,icon=shopItems.icon,
	            lastNum=reward[i][2],quality=shopItems.quality,
	            basicInfo = GetItemLocalData(reward[i][1]),customizeLastTime = reward[i][2]*86400}
			local celElement,tLuaObj = CellGoodItem:createElement()
			if celElement  then
	        	celElement = WZUIContainer:luaTo(celElement)
	        	tLuaObj:setCellGoodItem(itemInfo,16)
	        	celElement:setScale(0.8)
	        	tLuaObj:setItemClickFun(self,self.onOthersClick)
	        	conItem:addChild(celElement)
	    	end
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function CellWorldTeamBossList:_adaptLanguage_pt( )
	local ftxtName = GetElement(self.m_root, "ftxtName_CellWorldTeamBossList", WZUIFreeTextBox)
	ftxtName:setRelativePosition(GlobalMethod:ccp(0.45, 0.5))
	local ftxtRoomId = GetElement(self.m_root, "ftxtRoomId_CellWorldTeamBossList", WZUIFreeTextBox)
	ftxtRoomId:setRelativePosition(GlobalMethod:ccp(0.6, 0.5))
end

function CellWorldTeamBossList:_adaptLanguage_es( )
	local ftxtName = GetElement(self.m_root, "ftxtName_CellWorldTeamBossList", WZUIFreeTextBox)
	ftxtName:setRelativePosition(GlobalMethod:ccp(0.45, 0.5))
	local ftxtRoomId = GetElement(self.m_root, "ftxtRoomId_CellWorldTeamBossList", WZUIFreeTextBox)
	ftxtRoomId:setRelativePosition(GlobalMethod:ccp(0.6, 0.5))
end

function CellWorldTeamBossList:_adaptLanguage_en( )
	local ftxtName = GetElement(self.m_root, "ftxtName_CellWorldTeamBossList", WZUIFreeTextBox)
	ftxtName:setRelativePosition(GlobalMethod:ccp(0.45, 0.5))
	local ftxtRoomId = GetElement(self.m_root, "ftxtRoomId_CellWorldTeamBossList", WZUIFreeTextBox)
	ftxtRoomId:setRelativePosition(GlobalMethod:ccp(0.6, 0.5))
end
-------------------------------------语言适配end----------------------------------------
