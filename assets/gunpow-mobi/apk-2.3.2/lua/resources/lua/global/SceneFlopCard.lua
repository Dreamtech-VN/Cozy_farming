--WndFlopCard.lua
--@brief	SceneFlopCard的UI模块
--@date		2017/02/18
--@author	qixiang
--@note		翻牌


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneFlopCard:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
	self.m_root:enableSchedule("scheduleCountDown",1)
	self:initUI()
    CacheCenter:registerUpateMoneyObserver(self)
    g_nMyAssistState = 0
    ProtocolProcessorGlobal:send_BOSSMAPROOM_GetBossMapList()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneFlopCard:onExit(element)
	self:_unInit()
end

--@brief    货币信息有更新时
function SceneFlopCard:updateMoneyData()
    WZLog("SceneFlopCard:updateMoneyData")
    if not self.m_root then return end
    self:_updateDiamond()
end


function SceneFlopCard:scheduleCountDown(element)
	self.m_nCountdown = self.m_nCountdown - 1
	if self.m_nCountdown <= 0 then
		element:disableSchedule()
        for i = 1, self.m_nSweepTimes do
            if self.m_nOpenCardNum1 < self.m_nSweepTimes then 
                self.m_nOpenCardNum1 = self.m_nOpenCardNum1 + 1
                self:playerFlipCard(CacheCenter:getPlayerInfo().id, 1)
            end

            if self.m_nOpenCardNum2 < self.m_nSweepTimes and (CacheCenter:getPlayerInfo().vipLevel >= 5 or whetherHaveWelfareCard()) then --第二张牌未翻
                self.m_nOpenCardNum2 = self.m_nOpenCardNum2 + 1
                self:playerFlipCard(CacheCenter:getPlayerInfo().id, 2)
            end
        end
		self.m_root:enableSchedule("closeScene",0.6)
	end
	local txtCountdown = GetElement(self.m_root, "txtCountdown_SceneFlopCard", WZUIFreeTextBox)
    local sTime = string.format(LocalStrings.RESULT_DOWN_TIME, self.m_nCountdown)
    txtCountdown:setShowText(sTime)
end

function SceneFlopCard:closeScene(element)
    WZLog("SceneFlopCard:closeScene =")
	
	element:disableSchedule()
    if self.m_bIsMarryCopy then 
        -- local mapId = SceneMarryCopy:getCurMarryCopyMapId()
        -- WZLog("----------------88---------------------",mapId)
        -- ProtocolProcessorBossMap:send_BOSSMAPROOM_CreateRoom(mapId, "", GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_FF)
        -- ProtocolProcessorWndMarry:send_WEDDING_GetMarryInfo()
       -- SceneMarryWedding:showInterface()
        -- if WndFriends.m_root == nil then
        --     local wndFriends = WndFriends:createElement()
        --     if wndFriends.m_root then
        --         WndFriends:showMarryWed()
        --     end
        -- else
        --     WndFriends:showMarryWed()
        -- end
        if self.m_tMarryCopyRoomInfo then 
            ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_QuitRoom(self.m_tMarryCopyRoomInfo.roomId, self.m_tMarryCopyRoomInfo.roomSeat)
        end
        local sceneCity = SceneCity:createElement()
        replaceScene(sceneCity)
        WndCouple:showInterface(1)
    else
	   SceneCopy:showScene(2)
    end
end

--@brief    根据玩家id翻牌
--@param    nPlayerId, 玩家id
--@param    nIndex, 翻牌序号 1免费翻牌，2VIP翻牌，3钻石翻牌
function SceneFlopCard:playerFlipCard(nPlayerId, nIndex)
    if self.m_root == nil or nIndex > 3 then
        return
    end
    local tValidIndex = {}
    for i = nIndex*3 - 2, nIndex*3 do
        local nState = self.m_tCardObjList[i]:getState()
        if nState == 0 then
            table.insert(tValidIndex, i)
        end
    end
    local index = math.random(1, #tValidIndex)
    for i = 1, #self.m_tCardObjList do
        local info = self.m_tCardObjList[i]
        if info.m_nType == nIndex then
            WZLog("------------------card info-----------------","data = ",info,"type = ",info.m_nType,"state = ",info.m_nState)
        end
    end
    local tCard = self.m_tCardObjList[tValidIndex[index]]
    self:flopCard(tCard)
end

function SceneFlopCard:flopCard(tCard)
	WZLog("SceneFlopCard:flopCard")
	local nType = tCard:getType()
    local nGroupIndex = 1
    if nType == 1 then
        nGroupIndex = self.m_nOpenCardNum1 
    elseif nType == 2 then
        nGroupIndex = self.m_nOpenCardNum2
    elseif nType == 3 then
        nGroupIndex = self.m_nOpenCardNum3 
    end
	local playerInfo = CacheCenter:getPlayerInfo()
    local tData = {}
    tData.name = playerInfo.name
    tData.level = playerInfo.level
    tData.id = playerInfo.id
    local tReward = {}
    for i,v in ipairs(self.m_tSweepReward[nGroupIndex].flopId) do
    	table.insert(tReward, {flopId=v,flopCount=self.m_tSweepReward[nGroupIndex].flopCount[i]})
    end
    tData.flop = tReward
    tCard:setData(tData)
    tCard:flipCard()
end

function SceneFlopCard:clickCardBack(tCard)
	WZLog("SceneFlopCard:clickCardBack")
	local playerInfo = CacheCenter:getPlayerInfo()
    local nVipLevel = playerInfo.vipLevel
    local nDiamond2 = CacheCenter:getPlayerItemCountById(1)
    local nDiamond = 0
    if CacheCenter:getGameParam().isUseTicket == "0" then 
        nDiamond = CacheCenter:getPlayerItemCountById(70)
    end
	local nType = tCard:getType()

    if nType == 2 and nVipLevel < 5 and not whetherHaveWelfareCard() then --vip免费翻牌 vip等级不足
        MsgBoxManager:showTipBox(LocalStrings.TURNCARD_VIP_NEWTIPS)
    elseif nType == 3 and not DiamondIsEnoughNum(math.ceil(20 * self.m_nFlopRebate / 100)) then --钻石翻牌 钻石不足
        MsgBoxManager:showTipBox(LocalStrings.TURNCARD_DIAMOND_TIPS)
    else
	    local nType = tCard:getType()
	    -- for i = (nType-1)*3+1, nType*3 do
	    --     self.m_tCardObjList[i]:setTouchEnable(false)
	    -- end
	    if nType == 1 then
            if self.m_nOpenCardNum1 >= self.m_nSweepTimes then return end 
            self.m_nOpenCardNum1 = self.m_nOpenCardNum1 + 1
        elseif nType == 2 then
            if self.m_nOpenCardNum2 >= self.m_nSweepTimes then return end 
            self.m_nOpenCardNum2 = self.m_nOpenCardNum2 + 1
        elseif nType == 3 then
            if self.m_nOpenCardNum3 >= self.m_nSweepTimes then return end 
            self.m_nOpenCardNum3 = self.m_nOpenCardNum3 + 1
        end
        self:flopCard(tCard)
	    ProtocolProcessorSceneBattle:send_BOSSMAPROOM_Reward(nType, self.m_nOpenCardNum3)
    end
end

function SceneFlopCard:initUI()
	WZLog("SceneFlopCard:initUI")
	self.m_tCardObjList = {}
    local tbconCard = GetElement(self.m_root, "tbconCard_SceneFlopCard", WZUITableContainer)
    tbconCard:cleanTable()
    for i = 1, 9 do
        local eCard, tCard = CellSettlementCard:createElement()
        eCard:setTag(i-1)
        if math.ceil(i/3) == 3 then 
            tCard:setDiscount(self.m_nFlopRebate) --要在setType()之前调用
        end
        tCard:setType(math.ceil(i/3))
        tCard:setClickCallback2(self.clickCardBack,self)
        self.m_tCardObjList[i] = tCard
        tbconCard:setCellElement(eCard)
    end
    tbconCard:setVisible(true)
    self:_updateDiamond()
end

--@brief    更新钻石数量
function SceneFlopCard:_updateDiamond()
    local txtDiamond = GetElement(self.m_root, "txtDiamond_SceneFlopCard", WZUIFreeTextBox)
    txtDiamond:setVisible(true)
    local sTxt = string.format([[<I>ui/common/common_icon_zuanshi.png</I><T S="22" C="255,255,255" P="1"> %d</T>]], CacheCenter:getPlayerItemCountById(1))
    txtDiamond:setShowText(sTxt)
    --礼券
    WZLog("SceneFlopCard:_updateDiamond")
    local txtTicket = GetElement(self.m_root, "txtTicket_SceneFlopCard", WZUIFreeTextBox)
    txtTicket:setVisible(true)
    local sTxtTicket 
    if CacheCenter:getGameParam().isUseTicket == "0" then
        sTxtTicket= string.format([[<I Z="0.7" P="1">%s</I><T S="22" C="255,255,255" P="1">%d</T>]], GDatatab_item["id_70"].icon, CacheCenter:getMoneyList().ticket)
    else
        sTxtTicket= string.format([[<I Z="0.7" P="1">%s</I><T S="22" C="255,255,255" P="1">%d</T>]], GDatatab_item["id_1"].icon, CacheCenter:getMoneyList().ticket)
        txtTicket:setVisible(false)
    end
    txtTicket:setShowText(sTxtTicket)

    local txtConsumeAtt = GetElement(self.m_root, "txtConsumeAtt_SceneFlopCard", WZUILabelTTF)
    if txtConsumeAtt then
        txtConsumeAtt:setVisible(true)
        if CacheCenter:getGameParam().isUseTicket == "0" then
            txtConsumeAtt:setText(string.format(LocalStrings.CONSUME_FIRST, GDatatab_item["id_70"].name))
        else
            txtConsumeAtt:setText(string.format(LocalStrings.CONSUME_FIRST, GDatatab_item["id_1"].name))
        end
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    点击空白地方跳过或翻牌
function SceneFlopCard:onClickSkip(element)
    -- body
    if self.m_root == nil then return end 
    
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("SceneFlopCard:onClickSkip")
    self.m_root:disableSchedule()

    for i = 1, self.m_nSweepTimes do
        if self.m_nOpenCardNum1 < self.m_nSweepTimes then 
            self.m_nOpenCardNum1 = self.m_nOpenCardNum1 + 1
            self:playerFlipCard(CacheCenter:getPlayerInfo().id, 1)
        end

        if self.m_nOpenCardNum2 < self.m_nSweepTimes and (CacheCenter:getPlayerInfo().vipLevel >= 5 or whetherHaveWelfareCard()) then --第二张牌未翻
            self.m_nOpenCardNum2 = self.m_nOpenCardNum2 + 1
            self:playerFlipCard(CacheCenter:getPlayerInfo().id, 2)
        end
    end

    self.m_root:enableSchedule("closeScene",0.6)
end

--@brief    触摸结束回调
function SceneFlopCard:onTouchEnd(element, pt)
    -- body
    if not self:checkPointInBtn(pt) then
        self:onClickSkip(element)
    end
end

function SceneFlopCard:checkPointInBtn(pt)
    WZLog("SceneFlopCard:checkPoint")
    if self.m_root == nil then return end
    local btn
    local bIsPtInBtn = false 
    for i = 1, #self.m_tCardObjList do
        if self.m_tCardObjList[i] then
            btn = self.m_tCardObjList[i]:getCardBtnCon()
            local btnSize = btn:getContentSize()
            --获得btn的世界坐标
            local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
            WZLog("获得btn 世界坐标",ptA.x,ptA.y, pt.x, pt.y)
            WZLog("按钮大小", ptA.x + btnSize.width, ptA.y + btnSize.height)
            if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
                bIsPtInBtn = true
            end 
        end
        if bIsPtInBtn then 
            break 
        end
    end
    
    return bIsPtInBtn 
end
-------------------------------------私有方法模块End----------------------------------------



-------------------------------------语言适配Begin----------------------------------------

function SceneFlopCard:_adaptLanguage_en()
    local txtCountdown = GetElement(self.m_root, "txtCountdown_SceneFlopCard", WZUIFreeTextBox)
    txtCountdown:setScale(0.7)
    txtCountdown:setMaxWidth(420)
end

function SceneFlopCard:_adaptLanguage_pt()
    local txtCountdown = GetElement(self.m_root, "txtCountdown_SceneFlopCard", WZUIFreeTextBox)
    txtCountdown:setScale(0.7)
    txtCountdown:setMaxWidth(420)
end

function SceneFlopCard:_adaptLanguage_es()
    local txtCountdown = GetElement(self.m_root, "txtCountdown_SceneFlopCard", WZUIFreeTextBox)
    txtCountdown:setScale(0.7)
    txtCountdown:setMaxWidth(420)
end

function SceneFlopCard:_adaptLanguage_tr()
    local txtCountdown = GetElement(self.m_root, "txtCountdown_SceneFlopCard", WZUIFreeTextBox)
    txtCountdown:setScale(0.7)
    txtCountdown:setMaxWidth(420)
end
-------------------------------------语言适配End----------------------------------------