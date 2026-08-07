--CellRoomSeat.lua
--@brief	CellRoomSeat的UI模块
--@date		2013/12/27
--@author	李光森
--@author   qixiang_xie
--@note		房间玩家座位


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRoomSeat:onEnter(element)
	self.m_root = element
    CacheCenter:registerUpatePlayerInfoObserver(self)
	self:_update()
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRoomSeat:onExit(element)
    CacheCenter:unregisterUpatePlayerInfoObserver(self)
	self:_unInit()
end

--@brief	cell点击回调
--@param	element:表绑定的UI节点引用
function CellRoomSeat:onCellClick(element)
	WZLog("CellRoomSeat:onCellClick")

	if self.m_pCallBackFunc ~= nil then
		self.m_pCallBackFunc(self.m_tCallBackTable,self.m_root)
	end
end

--@监听到玩家信息更新
function CellRoomSeat:updatePlayerInfoData()
    -- local playerInfo = CacheCenter:getPlayerInfo()
    -- if self.m_tData.playerId == GlobalGame.g_tPlayerInfo.nPlayerId then
    --     local txtPlayerName = GetElement(self.m_root,"txtPlayerName_CellRoomSeat",WZUILabelTTF)
    --     txtPlayerName:setText(playerInfo.name)
    -- end
end

--获取显示的密友图片
function CellRoomSeat:getFriendImage()
    WZLog("CellRoomSeat:getFriendImage")
    local maxValue = nil
    for i,v in ipairs(self.m_tFriendValue) do
        if maxValue == nil then
            maxValue = tonumber(v[2])
        else
            if tonumber(v[2]) > maxValue then
                maxValue = tonumber(v[2])
            end
        end
    end
    local temp = nil
    local index = nil
    for j,k in pairs(GDatatab_relationship) do
        if k.type == 2 then
            if temp ~= nil then
                if maxValue >= k.degree and temp < k.degree then
                    temp = k.degree
                    index = k.id
                end
            else
                if maxValue >= k.degree then
                   index = k.id
                   temp = k.degree
                end
            end
        end
    end
    local imageIcon = nil
    if index ~= nil then
        imageIcon = GDatatab_relationship["id_" .. index ].icon
    end
    return imageIcon
end

--获取显示的师徒图片
function CellRoomSeat:getMasterImage()
    WZLog("CellRoomSeat:getMasterImage")
    local maxValue = nil
    local bMaster = nil
    for i,v in ipairs(self.m_nMasterValue) do
        bMaster = v[1]
        if maxValue == nil then
            maxValue = tonumber(v[4])
        else
            if tonumber(v[4]) > maxValue then
                maxValue = tonumber(v[4])
            end
        end
    end
    local temp = nil
    local index = nil
    for j,k in pairs(GDatatab_relationship) do
        if not bMaster and k.type == 4 then
            index = k.id
            break
        else
            if k.type == 3 then
                if temp ~= nil then
                    if maxValue >= k.degree and temp < k.degree  then
                        index = k.id
                        temp = k.degree
                    end
                else
                    if maxValue >= k.degree then
                       index = k.id
                       temp = k.degree
                    end
                end
            end
        end
    end
    local imageIcon = nil
    if index ~= nil then
        imageIcon = GDatatab_relationship["id_" .. index ].icon
    end
    return imageIcon
end


--获取显示的夫妻图片
function CellRoomSeat:getSpouseImage()
    WZLog("CellRoomSeat:getSpouseImage")
    local maxValue = self.m_nSpuseLevel
    local temp = nil
    local index = nil
    for j,k in pairs(GDatatab_relationship) do
        if k.type == 1 then
            if temp ~= nil then
                if maxValue >= temp and temp < k.degree  then
                    index = k.id
                    temp = k.degree
                end
            else
                if maxValue >= k.degree then
                   index = k.id
                   temp = k.degree
                end
            end
        end
    end
    local imageIcon = nil
    if index ~= nil then
        imageIcon = GDatatab_relationship["id_" .. index ].icon
    end
    return imageIcon
end


--查看密友信息
function CellRoomSeat:onTouchFriend(element)
    WZLog("CellRoomSeat:onTouchFriend")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local titleName = {}
    local valueName = {}
    for i,v in ipairs(self.m_tFriendValue) do
        local friendName = v[1]
        local temp = nil
        local showTip = nil
        for j,k in pairs(GDatatab_relationship) do
            if k.type == 2 then
                if temp ~= nil then
                    if v[2] >= k.degree and temp < k.degree  then
                        temp = k.degree
                        showTip = k.title
                    end
                else
                    if v[2] >= k.degree then
                        temp = k.degree
                        showTip = k.title
                    end
                end
            end
        end

        local temp2 = SplitStringWithSeparator(showTip,"&")
        local sex = v[3]
        if sex == 0 then --男
            if self.m_tData.playerSex == sex then  --相同的性别
                title = friendName .. temp2[1]
            else
                title = friendName .. temp2[2]
            end
        else  --女
            if self.m_tData.playerSex == sex then  --相同的性别
                title = friendName .. temp2[3]
            else
                title = friendName .. temp2[2]
            end
        end
        table.insert(titleName,title)
        local value = LocalStrings.FRIENDLINESS .. v[2]
        table.insert(valueName,value)
    end
    local temppp = {}
    table.insert(temppp,titleName)
    table.insert(temppp,valueName)
    
    WndTips:show(element,self.m_parentRoot,31,temppp,GlobalMethod:ccp(-90,0),true)
end

--师徒
function CellRoomSeat:onClickMaster(element)
    WZLog("CellRoomSeat:onClickMaster")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local titleName = {}
    local valueName = {}
    for i,v in ipairs(self.m_nMasterValue) do
        local bMaster = v[1]
        local masterNum = v[2]
        local masterName = v[3]
        local masterLevel = v[4] --师徒等级
        local temp = nil
        local showTip = nil
        for j,k in pairs(GDatatab_relationship) do
            if not bMaster then
               if k.type == 4 then
                    showTip = k.title
                    break
               end
            else
                if k.type == 3 then
                    if temp ~= nil then
                        if masterLevel >= k.degree and temp < k.degree then
                            temp = k.degree
                            showTip = k.title
                        end
                    else
                        if masterLevel >= k.degree then
                            temp = k.degree
                            showTip = k.title
                        end
                    end
                end
            end 
        end
        local title  = masterName .. showTip
        local value = LocalStrings.FRIENDLINESS .. masterNum

        table.insert(titleName,title)
        table.insert(valueName,value)
    end

    local temppp = {}
    table.insert(temppp,titleName)
    table.insert(temppp,valueName)
    WndTips:show(element,self.m_parentRoot,31,temppp,GlobalMethod:ccp(-90,0),true)
end

--夫妻关系
function CellRoomSeat:onTouchLove(element)
    WZLog("CellRoomSeat:onTouchLove")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local temp = 1
    local title = nil
    for k,v in pairs(GDatatab_relationship) do 
        if v.type == 1 then
            if self.m_nSpuseLevel >= temp  then
                temp = v.degree
                if self.m_sWifeName ~= nil then
                    title = self.m_sWifeName .. v.title
                else
                    title = self.m_sHusband .. v.title
                end
            end
        end
    end

    local titleName = {}
    local valueName = {}

    local value = LocalStrings.COUPLE_LOVE .. " : " .. self.m_nSpouseValue

    table.insert(titleName,title)
    table.insert(valueName,value)

    local temppp = {}
    table.insert(temppp,titleName)
    table.insert(temppp,valueName)
    
    WndTips:show(element,self.m_parentRoot,31,temppp,GlobalMethod:ccp(-90,30),true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新函数
--@note 	实际上的初始化函数
function CellRoomSeat:_update()
    if self.m_root == nil then
        WZLog("CellRoomSeat:_update m_root is nil.")
		return
    end

    if self.m_tData == nil then
        WZLog("CellRoomSeat:_update m_tData is nil.")
        return
    end
    self:_updateProperty()
    local globalGame = GlobalGame
	--娱乐赛不显示开放关闭按钮
	if self.m_tData.roomChannel == globalGame.g_tRoomChannel.BATTLE_CHANNEL_PW or self.m_tData.roomChannel == globalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then -- 排位赛
		GetElement(self.m_root,"conCloseSeat",WZUIContainer):setVisible(false)	
		GetElement(self.m_root,"txtOpenSeat_CellRoomSeat",WZUILabelTTF):setVisible(false)	
    end
end

--@brief   展示玩家基本属性
function CellRoomSeat:_updateProperty()
    WZLog("CellRoomSeat:_updateProperty")
    local ftbPlayerNameAndLevel = GetElement(self.m_root,"ftbPlayerNameAndLevel_CellRoomSeat",WZUIFreeTextBox)
    local level = "Lv" .. self.m_tData.playerLevel
    local playerId = CacheCenter:getPlayerInfo().id
    local conInfo = GetElement(self.m_root,"conInfo_CellRoomSeat",WZUIContainer)
    local txtPlayerLv = GetElement(conInfo,"txtPlayerLv_CellRoomSeat",WZUILabelTTF)
    local txtPlayerName = GetElement(conInfo,"txtPlayerName_CellRoomSeat",WZUILabelTTF)
    txtPlayerLv:setText(level)
    txtPlayerName:setText(self.m_tData.playerName)
    if playerId == self.m_tData.playerId then
        txtPlayerName:setColor(GlobalMethod:ccc3(99,255,95))
    else
        txtPlayerName:setColor(GlobalMethod:ccc3(255,255,255))
    end
    txtPlayerLv:setVisible(false)
    txtPlayerName:setVisible(false)

    local serverName,serverId = IPDhttpServer:getCurServerName()
    local palyerServerId = self.m_tData.serverid
    if palyerServerId ~= 0 and palyerServerId ~= tonumber(serverId) then
        local imgCrossService = GetElement(self.m_root,"imgCrossService_CellRoomSeat",WZUIImage)
        imgCrossService:setVisible(true) 
    else
        local imgCrossService = GetElement(self.m_root,"imgCrossService_CellRoomSeat",WZUIImage)
        imgCrossService:setVisible(false) 
    end
    
    if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX  then --练习模式才分红、蓝队
        local imgTeam = GetElement(self.m_root,"imgTeamTag_CellRoomSeat",WZUI9Image)
        if self.m_tData.index <= 3 then
            imgTeam:setFile("ui/hall/battle_scale9_jndj03.png")
        else
            imgTeam:setFile("ui/hall/battle_scale9_jndj04.png")
        end
    end

    local btnLove = GetElement(self.m_root,"btnLove_CellRoomSeat",WZUIButton)
    local btnFriend = GetElement(self.m_root,"btnFriend_CellRoomSeat",WZUIButton)
    local btnMaster = GetElement(self.m_root,"btnMaster_CellRoomSeat",WZUIButton)
    btnLove:setVisible(false)
    btnFriend:setVisible(false)
    btnMaster:setVisible(false)

    local imgLove = GetElement(btnLove,"imgLove_CellRoomSeat",WZUIImage)
    local imgLove2 = GetElement(btnLove,"imgLove2_CellRoomSeat",WZUIImage)
    imgLove:setFile("")
    imgLove2:setFile("")

    local imgFriend = GetElement(btnFriend,"imgFriend_CellRoomSeat",WZUIImage)
    local imgFriend2 = GetElement(btnFriend,"imgFriend2_CellRoomSeat",WZUIImage)
    imgFriend:setFile("")
    imgFriend2:setFile("")

    local imgMaster = GetElement(btnMaster,"imgMaster_CellRoomSeat",WZUIImage)
    local imgMaster2 = GetElement(btnMaster,"imgMaster2_CellRoomSeat",WZUIImage)
    imgMaster:setFile("")
    imgMaster2:setFile("")

    local visibleCount = 0
    local visTag1 = nil
    local visTag2 = nil
    local visTag3 = nil
    if self.m_nSpouseValue ~= nil then
        btnLove:setVisible(true)
        visibleCount = 1
        visTag1 = true
        local icon = self:getSpouseImage()
        imgLove:setFile(icon)
        imgLove2:setFile(icon)
    end

    if self.m_tFriendValue ~= nil and #self.m_tFriendValue > 0 then
        btnFriend:setVisible(true)
        local icon = self:getFriendImage()
        imgFriend:setFile(icon)
        imgFriend2:setFile(icon)
        visibleCount = visibleCount + 1
        visTag2 = true
    end

    if self.m_nMasterValue ~= nil and #self.m_nMasterValue > 0 then
        btnMaster:setVisible(true)
        visibleCount = visibleCount + 1
        local icon = self:getMasterImage()
        imgMaster:setFile(icon)
        imgMaster2:setFile(icon)
        visTag3 = true
    end

    local imgBgCenterIcon = GetElement(self.m_root,"imgBgCenterIcon_CellRoomSeat",WZUIImage)
    imgBgCenterIcon:setVisible(true)
    local imgBg = GetElement(self.m_root,"imgBg_CellRoomSeat",WZUIImage)
    if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZF then
        imgBg:setFile("ui/hall/battle_scale9_jndj01.png")
    elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_WTB then
        imgBg:setVisible(false)
    end

    self:showAssetFight()

    if self.m_tData.seatUsed then
        local conPlayer = nil
    	if self.m_tData.playerId > 0 then
            imgBgCenterIcon:setVisible(false)
    		self:updateSeatCon(true,false,false,false,false,false)
    	else
    		if self.m_tData.wnersId == GlobalGame.g_tPlayerInfo.nPlayerId and self.m_tData.roomChannel ~= GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZF and self.m_tData.roomChannel ~= GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_WTB then
                self:updateSeatCon(false,false,true,false,false,false)
    		else
    			self:updateSeatCon(false,false,false,true,false,false)
    		end
    	end
        
    else   --此座位没有人
        WZLog("lllllllllllllllll", self.m_tData.startMode)
    	if self.m_tData.startMode ==1 then --匹配模式
    		if self.m_tData.wnersId == GlobalGame.g_tPlayerInfo.nPlayerId then --房主
    			if self.m_tData.playerNumMode == 2 or self.m_tData.playerNumMode == 1 then --2对2
    				if self.m_nIndex ==4  then
                        if not self.m_tData.allSeatStatus[1] then
                            self:updateSeatCon(false,false,false,false,false,true)
                        else
                             self:updateSeatCon(false,true,false,false,false,false)
                        end
    				elseif self.m_nIndex ==5 then
                        if not self.m_tData.allSeatStatus[2] then
                            self:updateSeatCon(false,false,false,false,false,true)
                        else
                            self:updateSeatCon(false,true,false,false,false,false)
                        end
                    elseif self.m_nIndex ==6 then
                        if not self.m_tData.allSeatStatus[3] then
                            self:updateSeatCon(false,false,false,false,false,true)
                        else
                            self:updateSeatCon(false,true,false,false,false,false)
                        end
    				elseif self.m_nIndex ==3 or self.m_nIndex == 2 or self.m_nIndex ==1 then
    					self:updateSeatCon(false,false,false,false,true,false)
    				end
    			elseif  self.m_tData.playerNumMode == 3 then --3对3
    				if self.m_nIndex ==4 or self.m_nIndex==5 or self.m_nIndex == 6 then
    					self:updateSeatCon(false,true,false,false,false,false)
    				end
    			end
			else  --不是房主
				if self.m_tData.playerNumMode == 1 then  --1对1
    				if self.m_nIndex ==4 then
    					self:updateSeatCon(false,true,false,false,false,false)
    				elseif self.m_nIndex ==2 or self.m_nIndex ==3 or self.m_nIndex ==5 or self.m_nIndex ==6  then
    					self:updateSeatCon(false,false,false,false,false,true)
    				end
    			elseif self.m_tData.playerNumMode == 2 then --2对2
                    for i,v in ipairs(self.m_tSeatUseInfo) do
                        if i == 1 and v and self.m_nIndex == 4 then
                            self:updateSeatCon(false,true,false,false,false,false)
                            break
                        elseif i == 2 and v and self.m_nIndex == 5 then
                            self:updateSeatCon(false,true,false,false,false,false)
                            break
                        elseif i== 3 and v and self.m_nIndex == 6 then
                            self:updateSeatCon(false,true,false,false,false,false)
                            break
                        else
                            self:updateSeatCon(false,false,false,false,false,true)
                        end
                    end
    			elseif  self.m_tData.playerNumMode == 3 then --3对3
    				if self.m_nIndex ==4 or self.m_nIndex==5 or self.m_nIndex == 6 then
    					self:updateSeatCon(false,true,false,false,false,false)
    				end
    			end
    		end
    	elseif self.m_tData.startMode == 2  then  --组队模式
    		if self.m_tData.wnersId == GlobalGame.g_tPlayerInfo.nPlayerId then --房主
    			self:updateSeatCon(false,false,false,false,true,false)
    		else
    			self:updateSeatCon(false,false,false,false,false,true)
    		end
        elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZF then
            self:updateSeatCon(false,false,false,true,false,false)
        elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_WTB then
            WZLog("jjjjjjjjjjjjjjjjjjjjjjjjjj")
            self:updateSeatCon(false,false,false,true,false,false)
    	end
    end
    
    self:showKickedOutUI()

    if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW and self.m_tData.playerNumMode == GlobalGame.g_tNumMode.NUM_MODE_3  then
        self:updateQualifyLevel()
    elseif self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZF or self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_WTB then
        self:updateQualifyLevel()
    else
        self:updateAthleticLevel()
    end
end

--@brief  更新玩家竞技等级
function CellRoomSeat:updateAthleticLevel()
    WZLog("CellRoomSeat:updateAthleticLevel")
    local conInfo = GetElement(self.m_root,"conInfo_CellRoomSeat",WZUIContainer)
    WZLog("conInfo = ",conInfo:isVisible())
    if not conInfo:isVisible() then return end
    local conQualifyLevel = GetElement(conInfo,"conQualifyLevel_CellRoomSeat",WZUIContainer)
    local conAthleticLevel = GetElement(conInfo,"conAthleticLevel_CellRoomSeat",WZUIContainer)

    local imgPKLevel = GetElement(conAthleticLevel,"imgPKLevel_CellRoomSeat",WZUIImage)
    local btnAthleticLevel = GetElement(conAthleticLevel,"btnAthleticLevel_CellRoomSeat",WZUIButton)

    imgPKLevel:setFile("")
    conQualifyLevel:setVisible(false)
    conAthleticLevel:setVisible(true)
    btnAthleticLevel:setTouchEnable(true)
    local  nAthleticLevel = self.m_tData.tournamentLevel

    if nAthleticLevel == 0 or nAthleticLevel == nil then
        nAthleticLevel = nAthleticLevel + 1
    end
    
    local levelIcon = GDatatab_integral["id_" .. nAthleticLevel].iocn
    imgPKLevel:setFile("ui/common/" .. levelIcon .. ".png")
    if nAthleticLevel % 10 == 0 then
       nAthleticLevel = 10
    else
        nAthleticLevel = nAthleticLevel % 10
    end
end 


--更新玩家排位等级图标
function CellRoomSeat:updateQualifyLevel()
    WZLog("CellRoomSeat:updateQualifyLevel")
    local conInfo = GetElement(self.m_root,"conInfo_CellRoomSeat",WZUIContainer)
    if not conInfo:isVisible() then return end
    local conQualifyLevel = GetElement(conInfo,"conQualifyLevel_CellRoomSeat",WZUIContainer)
    local conAthleticLevel = GetElement(conInfo,"conAthleticLevel_CellRoomSeat",WZUIContainer)
    conAthleticLevel:setVisible(false)
    conQualifyLevel:setVisible(true)
    local nQualifyLevel = self.m_tData.qualifyingLevel
    local temp = nQualifyLevel + 1
    local mathInfo = GDatatab_trio_rank_match_config["id_" .. temp]
    if mathInfo == nil then
        mathInfo = GDatatab_trio_rank_match_config["id_999"]
    end
    local icon = mathInfo.icon
    local imgQualifyLevel = GetElement(conQualifyLevel,"imgQualifyLevel_CellRoomSeat",WZUIImage)
    local temp2 = "ui/common/" .. icon .. ".png"
    imgQualifyLevel:setFile(temp2)

end

--@brief 根据不同的撮合模式、竞技房间类型显示不同的房间属性
function CellRoomSeat:updateSeatCon(bconInfo,bconSeatProhibit,bconSeatWait,bconSeatGuest,bconSeatClose,bconSeatLock)
	WZLog("CellRoomSeat:updateSeatCon = ",self.m_tData.playerName,bconInfo,bconSeatProhibit,bconSeatWait,bconSeatGuest,bconSeatClose,bconSeatLock)
    local conInfo = WZUIContainer:luaTo(self.m_root:getChildElement("conInfo_CellRoomSeat"))
    local conSeatProhibit = WZUIContainer:luaTo(self.m_root:getChildElement("conSeatProhibit_CellRoomSeat"))
    local conSeatWait = WZUIContainer:luaTo(self.m_root:getChildElement("conSeatWait_CellRoomSeat"))
    local conSeatGuest = WZUIContainer:luaTo(self.m_root:getChildElement("conSeatGuest_CellRoomSeat"))
    local conSeatClose = WZUIContainer:luaTo(self.m_root:getChildElement("conSeatClose_CellRoomSeat"))
    local conSeatLock = WZUIContainer:luaTo(self.m_root:getChildElement("conSeatLock_CellRoomSeat"))

	conInfo:setVisible(bconInfo)
    conSeatProhibit:setVisible(bconSeatProhibit)
    conSeatWait:setVisible(bconSeatWait)
    conSeatGuest:setVisible(bconSeatGuest)
    conSeatClose:setVisible(bconSeatClose)
    conSeatLock:setVisible(bconSeatLock)
    if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_WTB then
        GetElement(self.m_root, "imgAddIcon_CellRoomSeat", WZUIImage):setVisible(true)
        GetElement(self.m_root, "txtWaitSeatGuest_CellRoomSeat", WZUILabelTTF):setVisible(false)
    end
end

function CellRoomSeat:showKickedOutUI()
    WZLog("CellRoomSeat:showKickedOutUI")
    local playerInfo = CacheCenter:getPlayerInfo()
    local playerId = playerInfo.id
    local conKickedOut =  GetElement(self.m_root,"conKickedOut_CellRoomSeat",WZUIContainer)
    conKickedOut:setVisible(false)
    if self.m_tData.playerId ~= nil and  self.m_tData.playerId ~= "" and playerId == self.m_tData.wnersId and playerId ~= self.m_tData.playerId and self.m_tData.playerId > 0 then
        conKickedOut:setVisible(true)
    end
end

--@brief    设置踢出房间按钮位置
function CellRoomSeat:setKickOutPt(pt)
    -- body
    local conKickedOut =  GetElement(self.m_root,"conKickedOut_CellRoomSeat",WZUIContainer)
    if conKickedOut then
        conKickedOut:setRelativePosition(pt)
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------回调方法模块Begin----------------------------------------

-- --@brief  邀请玩家
-- function CellRoomSeat:onClickInvPlayer(element)
-- 	WZLog("CellRoomSeat:onClickInvPlayer")
-- 	if self.m_pInvBackFunc ~= nil then
-- 		self.m_pInvBackFunc(self.m_tInvCallBackTable,self.m_root,self.m_nIndex)
-- 	end
-- end

--@brief  换位
function CellRoomSeat:onClickChangSeat(element)
	WZLog("CellRoomSeat:onClickChangeSeat")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_pChangeSeatBackFun ~= nil then
		self.m_pChangeSeatBackFun(self.m_tChangeSeatTable,self.m_root,self.m_nIndex)
	end
end

--@brief  关闭座位
function CellRoomSeat:onClickCloseSeat(element)
	WZLog("CellRoomSeat:onClickCloseSeat")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_pCloseSeatBackFunc ~= nil then
		self.m_pCloseSeatBackFunc(self.m_tCloseCallBackTable,self.m_root,self.m_nIndex)
	end
end

--@brief  开启座位
function CellRoomSeat:onClickOpenSeat(element)
	WZLog("CellRoomSeat:onClickOpenSeat")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --排位赛1v1,2v2模式无法开启座位
    if self.m_tData.roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
        if self.m_tData.playerNumMode == 1 then
            MsgBoxManager:showTipBox(LocalStrings.PAIWEISAI_SEASON_MODE_1V1)
            return
        elseif self.m_tData.playerNumMode == 2 then
            MsgBoxManager:showTipBox(LocalStrings.PAIWEISAI_SEASON_MODE_2V2)
            return
        end
    end

	if self.m_pOpenSeatBackFunc ~= nil then
		self.m_pOpenSeatBackFunc(self.m_tOpenCallBackTable,self.m_root,self.m_nIndex)
	end
end


-- 查看玩家信息和踢出玩家操作
-- 查看玩家信息，弹出背包界面
-- 踢出玩家，当玩家VIP等级比自己低时，可以踢出玩家
function CellRoomSeat:onClickKickedOut(element)
    WZLog("CellRoomSeat:onClickPopupMenuItem");
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local bMatching = SceneRoom:getClickSeat()
    if bMatching == false then
        MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
        return 
    end
    local playerInfo = CacheCenter:getPlayerInfo()
    if tonumber(playerInfo.vipLevel) < self.m_tData.vipLevel then
        MsgBoxManager:showTipBox(LocalStrings.TARGET_VIP_LEVEL_OVER_THEN_YOU)
    else
        ProtocolProcessorSceneRoom:send_ROOM_QuitRoom(self.m_nRoomId,self.m_tData.index-1)
    end
end

--@brief    查看段位按钮
function CellRoomSeat:onEventSection(element)
    WZLog("CellRoomSeat:onEventSection")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local AthleticLevel = {tournamentLevel=self.m_tData.tournamentLevel,playNum=self.m_tData.playNum,winNum=self.m_tData.winNum,tournamentIntegral=self.m_tData.tournamentExp}
    WndTips:show(element,self.m_parentRoot,4,AthleticLevel,GlobalMethod:ccp(80,100),true)
end

--@brief    查看排位按钮
function CellRoomSeat:onClickQualifyBtn( element )
    WZLog("CellRoomSeat:onClickQualifyBtn")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    local con =WZUIContainer:luaTo(element:getParent())
  
    local winN = self.m_tData.winTimes
    local joinTimes = self.m_tData.joinTimes
    local continuousWinTimes = self.m_tData.continuousWinTimes
    local matchscore = self.m_tData.matchscore
    local matchLevel = self.m_tData.qualifyingLevel
    
    local data = {winNum = winN,total = joinTimes,maxWinNum = continuousWinTimes, exp=matchscore,level=matchLevel}
    WndTips:show(element,self.m_parentRoot,17,data,GlobalMethod:ccp(80,100), true)
end

--是否显示助战标记
function CellRoomSeat:showAssetFight()
    -- body
    WZLog("CellRoomSeat:showAssetFight")
    local conInfo = GetElement(self.m_root,"conInfo_CellRoomSeat",WZUIContainer)
    local imgAssetFight = GetElement(conInfo,"imgAssetFight_CellRoomSeat",WZUIImage)
    if imgAssetFight then
        imgAssetFight:setVisible(false)
        if self.m_tData.assist ~= nil and self.m_tData.assist == 0 then
            imgAssetFight:setVisible(true)
        end
    end
end

-------------------------------------回调方法模块End----------------------------------------
------------------------------------------语言适配Begin-----------------------------------
function CellRoomSeat:_adaptLanguage_pt(  )
    -- local txtCloseSeat = GetElement(self.m_root,"txtCloseSeat_CellRoomSeat",WZUILabelTTF)
    -- txtCloseSeat:setDimensions(GlobalMethod:CCSize(140,0))
    -- txtCloseSeat:setFontSize(20)
    GetElement(self.m_root,"txtSeatStats_CellRoomSeat",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(180,0))
    -- local txtOpenSeat = GetElement(self.m_root,"txtOpenSeat_CellRoomSeat",WZUILabelTTF)
    -- txtOpenSeat:setDimensions(GlobalMethod:CCSize(140,0))
    -- txtOpenSeat:setFontSize(20)
end

function CellRoomSeat:_adaptLanguage_tr()
    GetElement(self.m_root,"txtCloseSeat_CellRoomSeat",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtOpenSeat_CellRoomSeat",WZUILabelTTF):setFontSize(20)
end

function CellRoomSeat:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtPlayerName_CellRoomSeat",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtCloseSeat_CellRoomSeat",WZUILabelTTF):setFontSize(20)

    -- local txtOpenSeat = GetElement(self.m_root,"txtOpenSeat_CellRoomSeat",WZUILabelTTF)
    -- txtOpenSeat:setDimensions(GlobalMethod:CCSize(200,0))
    -- txtOpenSeat:setFontSize(20)

    local txtSeatStats = GetElement(self.m_root,"txtSeatStats_CellRoomSeat",WZUILabelTTF)
    txtSeatStats:setDimensions(GlobalMethod:CCSize(200,0))
end
-----------------------------------------语言适配End------------------------------------