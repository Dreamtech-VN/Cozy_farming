--SceneCommunityCopy.lua
--@brief	SceneCommunityCopy的UI模块
--@date		2017/02/14
--@author	qixiang
--@note		公会副本主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneCommunityCopy:onEnter(element)
    WZLog("SceneCommunityCopy:onEnter")
	self.m_root = element
	ProtocolProcessorCommunityBossRoom:regAll()
	ProtocolProcessorCommunityBossRoom:send_GUILD_GetGuildBossInfo()
	SceneCommunityCopy:createLoading()

    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneCommunityCopy:onExit(element)
	WZLog("SceneCommunityCopy:onExit")
	ProtocolProcessorCommunityBossRoom:unregAll()
	self:_unInit()
end

--@brief    界面加载完成回调
function SceneCommunityCopy:onEnterTransitionDidFinish(element)
    self.isUseTicket = CacheCenter:getGameParam().isUseTicket
    self.m_nAddOncePrice = tonumber(CacheCenter:getGameParam().guildBossInspirePrice)
    --鼓舞消耗
    local inspireCostFormat = [[<I Z="0.5" P="1" >%s</I><T S="22" C="255,250,236" P="1" SC="163,74,20" SS="4" SE="1">%d%s</T>]]
    local ftxtInspireCost2 = GetElement(self.m_root, "ftxtInspireCost_SceneCommunityCopy2", WZUIFreeTextBox)
    local ftxtInspireCost5 = GetElement(self.m_root, "ftxtInspireCost_SceneCommunityCopy5", WZUIFreeTextBox)
    local iconPath = nil 
    if self.isUseTicket == "0" then 
        iconPath = GDatatab_item["id_70"].icon
    else
        iconPath = GDatatab_item["id_1"].icon
    end
    ftxtInspireCost2:setShowText(string.format(inspireCostFormat, iconPath, self.m_nAddOncePrice, LocalStrings.GUILD_BOSS_INSPIRE))
    ftxtInspireCost5:setShowText(string.format(inspireCostFormat, iconPath, self.m_nAddOncePrice * 5, LocalStrings.GUILD_BOSS_INSPIRE_FIVE))
    --
    GetElement(self.m_root, "txtPlayerInsp_SceneCommunityCopy", WZUILabelTTF):setText(LocalStrings.PLAYER .. "/" .. LocalStrings.STAR_PROPERTY_ADD)
end

--@brief    关闭按钮点击回调
--@param    element:button的引用
function SceneCommunityCopy:onCloseClick(element)
    WZLog("SceneCommunityCopy:onCloseClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    replaceScene(SceneCommunityMain:createElement())
end

function SceneCommunityCopy:onClickImage(element)
    -- body
    WZLog("SceneCommunityCopy:onClickImage")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local itemInfo = GDatatab_item["id_" .. 27]
    local conRight = GetElement(self.m_root,"conRight_SceneCommunityCopy",WZUIContainer)
    WndItemInfo:showInfo(element,conRight,3,itemInfo.name,false,GlobalMethod:ccp(35,0))
end

function SceneCommunityCopy:onClickImage2(element)
    -- body
    WZLog("SceneCommunityCopy:onClickImage2")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local itemInfo = GDatatab_item["id_" .. 7]
    local conRight = GetElement(self.m_root,"conRight_SceneCommunityCopy",WZUIContainer)
    WndItemInfo:showInfo(element,conRight,3,itemInfo.name,false,GlobalMethod:ccp(35,0))
end

--@brief	触摸函数，判断消息是否在消息框显示范围内，如果不是的话，就让消息框不显示，反之，显示
--@param #1	element:表绑定的UI节点引用
--@param #2	point:点击位置
function SceneCommunityCopy:onTouchBegan(element, point)
	WZLog("SceneCommunityCopy:onTouchBegan")
	if self.m_root == nil then 
		WZLog("WndFriend:onTouchBegan(element, point) self.m_root is nil ")
	end 

    local cellTowerRewardTip = GetElement(self.m_root,"CellTowerRewardTip",WZUIContainer)
    if cellTowerRewardTip then
        cellTowerRewardTip:removeFromParentAndCleanup(true)
    end
    --隐藏掉落预览tips
    self:checkWhetherHideRewardDrop(point)
end

--table cell回调
function SceneCommunityCopy:onClickCell(element)
	WZLog("SceneCommunityCopy:onClickCell")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local parent = element:getParent()
    parent = WZUIContainer:luaTo(parent)
    local tag = parent:getTag() + 1
    local txtBossOpenTip = GetElement(parent,"txtBossOpenTip_CellBossMap",WZUILabelTTF)
    local imgSelect = GetElement(parent,"imgSelect_CellBossMap",WZUI9Image)
    if imgSelect:isVisible() then return end
    local txt = txtBossOpenTip:getText()
    if txt == "" then
        local copyInfo = self.m_tBossInfo[tag]
        if self.m_tCommunityCopyInfo.sectionId < copyInfo[1].section then 
            MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_NEWTEXT7)
        else
            self.m_nCurSelectIndex = tag
    		self:_showRightCenter(self.m_tCommunityCopyInfo,copyInfo)
    		imgSelect:setVisible(true)
    		if self.m_elementCurSelcetCopy then
    			self.m_elementCurSelcetCopy:setVisible(false)
    		end
    		self.m_elementCurSelcetCopy = imgSelect
        end
	else
		MsgBoxManager:showTipBox(txt)
    end
end

--查看奖励信息
function SceneCommunityCopy:onClickReward(element)
	WZLog("SceneCommunityCopy:onClickReward")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local imgWRReddot = GetElement(self.m_root, "imgWRReddot_SceneCommunityCopy", WZUIImage)
    local bVisible = imgWRReddot:isVisible()

	if bVisible and self.m_tWeekRewardDone[1] then
		self:createLoading()
		self.m_nGetRewardSelectIndex = 1
		ProtocolProcessorCommunityBossRoom:send_GUILD_GetHurtReward(1)
	elseif bVisible and self.m_tWeekRewardDone[2] then
		self:createLoading()
		self.m_nGetRewardSelectIndex = 2
		ProtocolProcessorCommunityBossRoom:send_GUILD_GetHurtReward(2)
	elseif bVisible and self.m_tWeekRewardDone[3] then
		self:createLoading()
		self.m_nGetRewardSelectIndex = 3
		ProtocolProcessorCommunityBossRoom:send_GUILD_GetHurtReward(3)
	else
		local conRightButtom = GetElement(self.m_root, "conRightButtom_SceneCommunityCopy", WZUIContainer)
        if not conRightButtom:isVisible() then 
            conRightButtom:setVisible(true)
        end
	end
end

--通关排行
function SceneCommunityCopy:onClickRank(element)
	WZLog("SceneCommunityCopy:onClickRank")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCommunityBossWarRank:show(self.m_nCurSelectIndex)
end

--挑战
function SceneCommunityCopy:onClickChallenge(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("SceneCommunityCopy:onClickChallenge")
    
    local parent = GetElement(self.m_root,"conBoss" .. self.m_nSectionBossIndex .. "_SceneCommunityCopy",WZUIContainer)
    local txtFightStats = GetElement(parent,"txtFightStats_SceneCommunityCopy",WZUILabelTTF)
    if not txtFightStats:isVisible() then
        MsgBoxManager:showTipBox(LocalStrings.DAILYCOPY_LOCKED_TIPS)
        return
    end

    local gampeParam = CacheCenter:getGameParam()
    if self.m_tCommunityCopyInfo.playTimes >= tonumber(gampeParam.guildBossDareTimes)  then
        MsgBoxManager:showTipBox(LocalStrings.CHALLEGE_OVER)
        return
    end
    if self.m_nFightCost and CacheCenter:getPlayerInfo().vigor < self.m_nFightCost then
        judgeNotEnoughJump(self, self.needMoreEnergy)
        return
    end
    self:createLoading()
    ProtocolProcessorCommunityBossRoom:send_GUILD_GetGuildMakePair(self.m_tCommunityCopyInfo.bossId)
end
	
--@brief 单次鼓舞
function SceneCommunityCopy:OnInspireClick(element)
    local tag = element:getTag()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local addOnceHurt = tonumber(CacheCenter:getGameParam().guildBossInspireAdd)

    self.m_nLeftInspire = (tonumber(CacheCenter:getGameParam().guildBossMaxHurtAdd) - self.m_tCommunityCopyInfo.hurtAdd)/addOnceHurt*tag
    if self.m_nLeftInspire <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.GUILD_BOSS_INSPIRE_FULL)
        return
    end

    self.m_nInspireNum = 1*tag
    if self.isUseTicket == "0" then
        if not JudgeMoneyIsEnough(70, self.m_nAddOncePrice*tag, nil, nil, Chat_Channel_Guild_Boss, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
            return
        end
    else
        if not JudgeMoneyIsEnough(1, self.m_nAddOncePrice*tag, nil, nil, Chat_Channel_Guild_Boss, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
            return
        end
    end

    self:sureUseDiamondInstead()
end

--@brief    确认用钻石代替礼券回调
function SceneCommunityCopy:sureUseDiamondInstead()
    -- body
    WZLog("SceneCommunityCopy:sureUseDiamondInstead", self.m_nInspireNum,self.m_tCommunityCopyInfo.bossId)

    self:createLoading()
    self.m_bInspireClick = true
    ProtocolProcessorCommunityBossRoom:send_GUILD_GuildInspire(self.m_nInspireNum,self.m_tCommunityCopyInfo.bossId)
end

--@biref    切换下一个Boss
function SceneCommunityCopy:onClickNext(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("SceneCommunityCopy:onClickNext", type(self.m_nCurSelectIndex), self.m_nCurSelectIndex, self.m_tCommunityCopyInfo.sectionId)
    if self.m_tBossInfo[self.m_nCurSelectIndex][1].section < self.m_tCommunityCopyInfo.sectionId then 
        if self.m_nSectionBossIndex >= 3 then 
            MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_NEWTEXT4)
            return 
        else
            self.m_nSectionBossIndex = self.m_nSectionBossIndex + 1
        end
    else
        if self.m_tBossInfo[self.m_nCurSelectIndex][1].section == self.m_tCommunityCopyInfo.sectionId then 
            if self.m_nSectionBossIndex >= 3 then 
                MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_NEWTEXT4)
                return 
            else
                if self.m_tBossInfo[self.m_nCurSelectIndex][self.m_nSectionBossIndex + 1].id > self.m_tCommunityCopyInfo.bossId then 
                    MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_NEWTEXT6)
                    return 
                else
                    self.m_nSectionBossIndex = self.m_nSectionBossIndex + 1
                end
            end
        end
    end

    self:showSelBoss()
end

--@biref    切换上一个Boss
function SceneCommunityCopy:onClickPre(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    WZLog("SceneCommunityCopy:onClickPre", type(self.m_nCurSelectIndex))
    if self.m_tBossInfo[self.m_nCurSelectIndex][1].section < self.m_tCommunityCopyInfo.sectionId then 
        if self.m_nSectionBossIndex <= 1 then 
            MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_NEWTEXT5)
            return 
        else
            self.m_nSectionBossIndex = self.m_nSectionBossIndex - 1
        end
    else
        if self.m_tBossInfo[self.m_nCurSelectIndex][1].section == self.m_tCommunityCopyInfo.sectionId then 
            if self.m_nSectionBossIndex <= 1 then 
                MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_NEWTEXT5)
                return 
            else
                self.m_nSectionBossIndex = self.m_nSectionBossIndex - 1
            end
        end
    end

    self:showSelBoss()
end

--@brief    点击掉落预览按钮回调
function SceneCommunityCopy:onClickDrop(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local conItemDrop = GetElement(self.m_root, "conItemDrop_SceneCommunityCopy", WZUIContainer)
    if not conItemDrop:isVisible() then 
        conItemDrop:setVisible(true)
        self:showDropTips()
    end
end

--@brief    检测对否隐藏奖励掉落tips
--@param    index: 2->周奖励tips
function SceneCommunityCopy:checkWhetherHideRewardDrop(pt)
    -- body
    if self.m_root == nil then return end 

    local conRightButtom = GetElement(self.m_root, "conRightButtom_SceneCommunityCopy", WZUIContainer)
    local index = 1
    if conRightButtom:isVisible() then 
        index = 2
    end

    if index == 2 then 
        if not self:checkPointInBtn(pt, index) and conRightButtom:isVisible() then 
            conRightButtom:setVisible(false)
        end
    else
        local conItemDrop = GetElement(self.m_root, "conItemDrop_SceneCommunityCopy", WZUIContainer)
        if not self:checkPointInBtn(pt, index) and conItemDrop:isVisible() then 
            conItemDrop:setVisible(false)
        end
    end
end

-- 点击物品后的回调
function SceneCommunityCopy:onClickListItem(tItem, nTag, tData)
    WZLog("SceneCommunityCopy:onClickListItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false, nil,true)
end

--@brief    点击规则按钮回调
function SceneCommunityCopy:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.COMMUNITY_NEWTEXT9)
end

function SceneCommunityCopy:updateBtnStatu()
    if self.btnStatu then return end
    local normalBtn = GetElement(self.m_root,"btnNormal_SceneCommunityCopy",WZUIButton)
    self.btnStatu = GetElement(self.m_root,"btnStatu2_SceneCommunityCopy",WZUIContainer)
    self.btnStatu:setVisible(true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function SceneCommunityCopy:_showRightTopInfo(data)
	WZLog("SceneCommunityCopy:_showRightTopInfo")
    local gampeParam = CacheCenter:getGameParam()
    local lastNum =  gampeParam.guildBossDareTimes - data.playTimes
    local temp = lastNum .. "/" .. gampeParam.guildBossDareTimes

	local txtChanngleTotal = GetElement(self.m_root,"txtChanngleTotal_SceneCommunityCopy",WZUILabelTTF)
    txtChanngleTotal:setText(temp)

    local txtGetTotal = GetElement(self.m_root,"txtGetTotal_SceneCommunityCopy",WZUILabelTTF)
    txtGetTotal:setText(data.todayGain)
    local txtGetTotal2 = GetElement(self.m_root,"txtGetTotal2_SceneCommunityCopy",WZUILabelTTF)
    txtGetTotal2:setText(data.contribution)
end


function SceneCommunityCopy:_showRightCenter(data,curBoss)
	WZLog("SceneCommunityCopy:_showRightCenter", self.m_nSectionBossIndex)
    local conRight = GetElement(self.m_root,"conRight_SceneCommunityCopy",WZUIContainer)
    local totalHP = 0
    for i=1,3 do
        local conBoss = GetElement(self.m_root,"conBoss" .. i .. "_SceneCommunityCopy",WZUIContainer)
        if self.m_nSectionBossIndex == i then 
            conBoss:setVisible(true)
        else
            conBoss:setVisible(false)
        end
        local txtBossName = GetElement(conBoss,"txtBossName_SceneCommunityCopy",WZUILabelTTF)
        local txtPro = GetElement(conBoss,"txtPro_SceneCommunityCopy",WZUILabelTTF)
        local proBossLife = GetElement(conBoss,"proBossLife_SceneCommunityCopy",WZUIProgress)
        local imgBossStats = GetElement(conBoss,"imgBossStats_SceneCommunityCopy",WZUIImage)
        local txtHurtBuffer = GetElement(conBoss,"txtHurtBuffer_SceneCommunityCopy",WZUILabelTTF)
        local txtFightStat = GetElement(conBoss,"txtFightStats_SceneCommunityCopy",WZUILabelTTF)
        local imgLock = GetElement(conBoss,"imgLock_SceneCommunityCopy",WZUIImage)
        local txtOpenStats =  GetElement(conBoss,"txtOpenStats_SceneCommunityCopy",WZUILabelTTF)
        local spBoss = GetElement(conBoss,"spBoss_SceneCommunityCopy",WZUISpine)
        spBoss:setFileAtlas("")
        spBoss:setFileJson("")
        spBoss:setAnimationName("")
        imgLock:setVisible(false)
        local txtOpenStats = GetElement(conBoss,"txtOpenStats_SceneCommunityCopy",WZUILabelTTF)
        txtOpenStats:setVisible(false)

        txtBossName:setText(curBoss[i].map_name)
        txtHurtBuffer:setText("")
        txtFightStat:setVisible(false)
        local monsterId = curBoss[i].monster[1][1]
        local monsterInfo = GDatatab_monster["id_" .. monsterId]
        local monsterHp = monsterInfo.hp
        local monsterSpine = monsterInfo.AniFileId
        spBoss:setScale(curBoss[i].scale/100)
        spBoss:setFileAtlas("battle/monster/" .. monsterSpine .. ".atlas")
        spBoss:setFileJson("battle/monster/" .. monsterSpine .. ".json")
        spBoss:setAnimationName("wait")
        totalHP = totalHP + monsterHp
        imgBossStats:setVisible(false)
        if curBoss[i].id < data.bossId then
            txtPro:setText("0%")
            proBossLife:setPercentage(0)
            imgBossStats:setVisible(true)
        elseif curBoss[i].id == data.bossId then
            local percent = data.bossHp / data.bossMaxHp * 100
            percent = math.ceil(percent)
            proBossLife:setPercentage(percent)
            txtPro:setText(percent .. "%")
            local tempStr = string.format(LocalStrings.HURT_BUFFER,data.hurtAdd)
            tempStr = tempStr .. "%"
            txtHurtBuffer:setText(tempStr)
            txtFightStat:setVisible(true)
        else
            txtPro:setText("100%")
            proBossLife:setPercentage(100)
            imgLock:setVisible(true)
            txtOpenStats:setVisible(true)
        end
    end

    self:showSelBoss()
end


function SceneCommunityCopy:_showRightButtom(data)
    WZLog("SceneCommunityCopy:_showRightButtom")
    local conRight = GetElement(self.m_root,"conRight_SceneCommunityCopy",WZUIContainer)
    local conRightButtom = GetElement(conRight,"conRightButtom_SceneCommunityCopy",WZUIContainer)
    local reward = VectorToTable(data.reward)
    local totalHP = 0
    data.weekHurt = tonumber(data.weekHurt)
    local reddotNum = 0 
    local imgRedPoint = GetElement(self.m_root,"imgWRReddot_SceneCommunityCopy",WZUIImage)
    imgRedPoint:setVisible(false)
    self.m_tWeekRewardDone = {}
    for i=1,3 do
        local txtBox = GetElement(conRightButtom,"txtBox" .. i .. "_SceneCommunityCopy",WZUILabelTTF)
        local hurt = GDatatab_guild_boss_hurt_reward["id_" .. i].hurt
        local level = CacheCenter:getPlayerInfo().level
        -- 等级*等级*(等级+系数)
        hurt = level*level*(level+hurt)
        txtBox:setText(string.format(LocalStrings.COMMUNITY_NEWTEXT3, hurt))
        totalHP = hurt

        local imgBox = GetElement(conRightButtom,"imgBox" .. i .. "_SceneCommunityCopy",WZUIImage)
        if data.weekHurt >= hurt  then
            if i == 1 then
                imgBox:setFile("ui/common/common_icon_ywc.png")
                self.m_tWeekRewardDone[1] = true
                reddotNum = reddotNum + 1
            elseif i == 2 then
                imgBox:setFile("ui/common/common_icon_ywc.png")
                self.m_tWeekRewardDone[2] = true
                reddotNum = reddotNum + 1
            elseif i == 3 then
                imgBox:setFile("ui/common/common_icon_ywc.png")
                self.m_tWeekRewardDone[3] = true
                reddotNum = reddotNum + 1
            end
        end
        for j,k in ipairs(reward) do
            if k == 1 and i == 1 then
                reddotNum = reddotNum - 1
                self.m_tWeekRewardDone[1] = false
                imgBox:setFile("ui/common/commom_icon_ylq.png")
            elseif k == 2 and i == 2 then
                reddotNum = reddotNum - 1
                self.m_tWeekRewardDone[2] = false
                imgBox:setFile("ui/common/commom_icon_ylq.png")
            elseif k == 3 and i == 3 then
                reddotNum = reddotNum - 1
                self.m_tWeekRewardDone[3] = false
                imgBox:setFile("ui/common/commom_icon_ylq.png")
            end
        end
    end
    if reddotNum > 0 then 
        imgRedPoint:setVisible(true)
    end
    local minLimitHurt = self:getCurHurtLimit()
    local txtHurtTotal = GetElement(conRight,"txtHurtTotal_SceneCommunityCopy",WZUILabelTTF)
    if data.weekHurt < 0 then
        txtHurtTotal:setText("4294967296")
    else
        txtHurtTotal:setText(data.weekHurt .. "/" .. minLimitHurt)
    end
    
    for i=1,3 do
        local conRightButtom = GetElement(self.m_root,"conRightButtom_SceneCommunityCopy",WZUIContainer)
        local tableRewardList = GetElement(conRightButtom, "tableRewardList" .. i .. "_SceneCommunityCopy", WZUITableContainer)
        tableRewardList:cleanTable()
        local reward = GDatatab_guild_boss_hurt_reward["id_" .. i].reward
        for j = 1, #reward do
            local element, tNewObj = CellGoodItem:createElement()
            if element and tNewObj then 
                element:setTag(j - 1)
                tNewObj:setCellGoodLocalId(reward[j][1], reward[j][2], 17)
                tNewObj:setItemClickFun(self, self.onClickListItem)
                tableRewardList:setCellElement(element)
                element:setScale(0.7)
            end
        end
    end
end

function SceneCommunityCopy:_showLeft(data)
	WZLog("SceneCommunityCopy:_showLeft")
	local tabBossList = GetElement(self.m_root,"tabBossList_SceneCommunityCopy",WZUITableContainer)
    tabBossList:cleanTable()
	local sectionId = 1
    local curBoss = nil
    self.m_elementCurSelcetCopy = nil
    local selectIndex = nil
    for i,v in ipairs(self.m_tBossInfo) do
    	table.sort(v,function (a,b)
		    if a.id < b.id then
		        return true
		    end
		    return false
        end)
        local bOpen = false
        
        if CacheCenter:getPlayerInfo().guildLevel >= v[1].open_level  then
            bOpen = true
        end
        
        local cellBossMap = CreateElement("CellBossMap")
        cellBossMap = WZUIContainer:luaTo(cellBossMap)
        cellBossMap:setVisible(true)
        cellBossMap:setTag(i-1)
        tabBossList:setCellElement(cellBossMap)
       
        local txtMapName = GetElement(cellBossMap,"txtMapName_CellBossMap",WZUILabelTTF)
        txtMapName:setText(v[1].section_name)

        local imgMap = GetElement(cellBossMap,"imgMap_CellBossMap",WZUIImage)
        imgMap:setFile("map/" .. v[1].section_icon .. "_bg.png")

        if not bOpen then
            imgMap:setGrayRender(true)
            local txtBossOpenTip = GetElement(cellBossMap,"txtBossOpenTip_CellBossMap",WZUILabelTTF)
            local temp = string.format(LocalStrings.COMMUNITY_OPEN_TIP,v[1].open_level)
            txtBossOpenTip:setText(temp)
        end
        local imgSelect = GetElement(cellBossMap,"imgSelect_CellBossMap",WZUI9Image)
        if i == 1 and data.sectionId <= 0 then
            imgSelect:setVisible(true)
            selectIndex=i
            self.m_elementCurSelcetCopy = imgSelect
            self.m_nCurSelectIndex = i
            curBoss = v
        end

        if v[1].section  < data.sectionId then
            local txtPassStats = GetElement(cellBossMap,"txtPassStats_CellBossMap",WZUILabelTTF)
            txtPassStats:setVisible(true)
        end
       
        if v[1].section == data.sectionId then
            local txtFightStats = GetElement(cellBossMap,"txtFightStats_CellBossMap",WZUILabelTTF)
            txtFightStats:setVisible(true)
            imgSelect:setVisible(true)
            selectIndex=i
            sectionId = v.section
            imgMap:setFile("map/" .. v[1].section_icon .. "_bg.png")
            curBoss = v
            self.m_elementCurSelcetCopy = imgSelect
            self.m_nCurSelectIndex = i
            if ProjConfig.LANGUAGE == "pt" then
                txtFightStats:setRelativePosition(GlobalMethod:ccp(0.7,0.205064))
            end
        end
    end
    if selectIndex and selectIndex >= 4 then
        local count  = #self.m_tBossInfo
        local moveElement = tabBossList:getMoveElement()
        local cellElement = tabBossList:getCellElement(1)
        local minY = tabBossList:getMinPosition().y
        local maxY = tabBossList:getMaxPosition().y
        if selectIndex >= count-3 then
            moveElement:setPositionY(maxY)
        else
            local maxxY = math.abs(minY)+maxY
            local cellH = maxxY / count
            local tempY = selectIndex * cellH + minY
            moveElement:setPositionY(tempY)
        end
    end
end

--@brief 更新界面
	-- sectionId : 挑战中章节ID
	-- bossId : 挑战中BossID
	-- bossHP : Boss当前血量
	-- hurtAdd : 当前伤害加成
	-- cheerId : 鼓舞玩家ID
	-- cheerName : 鼓舞玩家名称
	-- cheerCost : 鼓舞花费钻石数
	-- playTimes : 今日挑战次数
	-- todayGain : 公会货币今日收获数量
	-- weekHurt : 本周伤害输出
	-- reward : 已领取的周奖励ID
	-- fighterNum:正在挑战玩家数
function SceneCommunityCopy:_updateView(data)
    WZLog("SceneCommunityCopy:_updateView")
    local tempTable = {}
    for k,v in pairs(GDatatab_guild_boss_map) do
        local bExit = false
        local tt = nil
        for j,p in ipairs(tempTable) do
            for u,m in ipairs(p) do
                if m.section == v.section then
                    bExit = true
                    tt = p
                    break
                end
            end
            if bExit then
                break
            end
        end
        if not bExit then
            local temp = {}
            table.insert(temp,v)
            table.insert(tempTable,temp)
        else
            table.insert(tt,v)
        end
    end

    table.sort(tempTable,function (a,b)
        if a[1].section < b[1].section then
            return true
        end
        return false
    end)
   
    self.m_tBossInfo = tempTable
--    WZLog("SceneCommunityCopy:_updateView", Serialize(self.m_tBossInfo))
    self:_showLeft(data)
    local curBoss = nil
    for i,v in ipairs(self.m_tBossInfo) do
    	if i == 1 and data.sectionId <= 0 then
            curBoss = v
        end

        if v[1].section == data.sectionId then
            curBoss = v
            break
        end
    end

    self:_showRightTopInfo(data)
    WZLog("SceneCommunityCopy:_updateView 22", self.m_nSectionBossIndex)
    
    if curBoss then
        --首次进入，获取默认boss索引
        for i = 1, #curBoss do
            if curBoss[i].id == data.bossId then 
                self.m_nSectionBossIndex = i
                break 
            end
        end
    	self:_showRightCenter(data,curBoss)
        self:_showRightButtom(data)
    end
end

--@brief    可变的数据
function SceneCommunityCopy:updateOtherInfo()
    -- body
    --挑战消耗
--    WZLog("刷新伤害榜单",Serialize(self.m_tBossInfo))
    local curBossData = self.m_tBossInfo[self.m_nCurSelectIndex][self.m_nSectionBossIndex]
    local labFightCost = GetElement(self.m_root, "labFightCost_SceneCommunityBossInfo", WZUILabelTTF)
    if labFightCost then 
        labFightCost:setText("X" .. curBossData.cost .. LocalStrings.CHALLENGEENTRANCE_TITLE)
        self.m_nFightCost = curBossData.cost
    end
    --刷新伤害榜单
    local conForHurt = GetElement(self.m_root, "conForHurt_SceneCommunityCopy", WZUIContainer)
    WndCommunityCopyRank:show(curBossData.id, conForHurt) 
    --挑战和鼓舞按钮
    local conBottomBtn = GetElement(self.m_root, "conBottomBtn_SceneCommunityCopy", WZUIContainer)
    if curBossData.id == self.m_tCommunityCopyInfo.bossId then 
        conBottomBtn:setVisible(true)
    else
        conBottomBtn:setVisible(false)
    end 
end

--@brief    显示奖励掉落
function SceneCommunityCopy:showDropTips()
    -- body
    local conTabItem = GetElement(self.m_root, "conTabItem_SceneCommunityCopy", WZUITableContainer)
    conTabItem:cleanTable()

    local tDropData = self.m_tBossInfo[self.m_nCurSelectIndex][self.m_nSectionBossIndex].reward[1]

    
    if tDropData then
        local list = {}
        for i = 1 ,#tDropData do
            local info = {}
            info.id = tDropData[i]
            local tmp = GDatatab_item["id_"..info.id]
            info.quality = tmp and tmp.quality or 1
            table.insert(list,info)
        end
        local sortFunc = function(a, b) return a.quality > b.quality end
        table.sort(list , sortFunc)
       
        for i = 1 ,#list do
            local eItem, tItem = self:_createCellGoodItem(list[i].id)
            eItem:setTag(i-1)
            conTabItem:setCellElement(eItem)
        end
    end
end

-- 创建一个掉落物品
function SceneCommunityCopy:_createCellGoodItem(nItemId)
    WZLog("SceneCommunityCopy:_createCellGoodItem",nItemId)
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setScale(0.8)
    tItem:setItemClickFun(self, self.onClickListItem)
    local tData = {
        id = nItemId,
        isUse = false,
        data = "",
        playerItemId = -1,
        basicInfo = GetItemLocalData(nItemId)
    }
    tItem:setCellGoodItem(tData, 2)
    return eItem, tItem
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 更新界面
    -- sectionId : 挑战中章节ID
    -- bossId : 关卡Id
    -- bossHp : Boss当前血量
    -- hurtAdd : 当前伤害加成
    -- cheerId : 鼓舞玩家ID
    -- cheerName : 鼓舞玩家名称
    -- cheerCost : 鼓舞花费钻石数
    -- playTimes : 今日挑战次数
    -- todayGain : 公会货币今日收获数量
    -- weekHurt : 本周伤害输出
    -- reward : 已领取的周奖励ID
    -- fighterNum:正在挑战玩家数
function SceneCommunityCopy:showInspireList(data)
    local conTabPlayer = GetElement(self.m_root, "conTabPlayer_SceneCommunityCopy", WZUITableContainer)
    conTabPlayer:cleanTable()

    local conForPlayer = GetElement(self.m_root, "conForPlayer_SceneCommunityCopy", WZUIContainer)
    if data == nil or #data == 0 then
        ShowPanelNullTip(conForPlayer, LocalStrings.COMMUNITY_NEWTEXT8, GlobalMethod:ccc3(138,122,106), nil, 20)
    else
        removeShowPanelNullTip(conForPlayer)
        for i = 1 ,#data do
            local eItem, tItem = CellCommunityBossInspire:createElement()
            eItem:setTag(i-1)
            conTabPlayer:setCellElement(eItem)
            tItem:setData(data[i])
        end
    end
end

--@brief    显示相应的boss
function SceneCommunityCopy:showSelBoss()
    -- body
    for i = 1, 3 do
        local conBoss = GetElement(self.m_root,"conBoss" .. i .. "_SceneCommunityCopy",WZUIContainer)
        if self.m_nSectionBossIndex == i then 
            conBoss:setVisible(true)
        else
            conBoss:setVisible(false)
        end
    end

    self:updateOtherInfo()

    ProtocolProcessorSceneCommunity:send_GUILD_GetGuildBossInspireRank(CacheCenter:getGuildInfo().guildId, self.m_tBossInfo[self.m_nCurSelectIndex][self.m_nSectionBossIndex].id)
end

function SceneCommunityCopy:checkPointInBtn(pt, index)
    WZLog("SceneCommunityCopy:checkPoint")
    if self.m_root == nil then return end
    local btn = GetElement(self.m_root, "conItemDrop_SceneCommunityCopy", WZUIContainer)
    if index == 2 then 
        btn = GetElement(self.m_root, "conRightButtom_SceneCommunityCopy", WZUIContainer)
    end
    if btn == nil then return false end
    local btnSize = btn:getContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    WZLog("获得btn 世界坐标",ptA.x,ptA.y, ptA.x + btnSize.width, ptA.y + btnSize.height, pt.x, pt.y)
    WZLog("按钮大小",btnSize.width,btnSize.height)
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        WZLog("SceneCommunityCopy:checkPoint  true")
        return true
    else
        return false
    end 
end
-------------------------------------私有方法模块End----------------------------------------

------------------------------------语言适配Begin-------------------------------------------
function SceneCommunityCopy:_adaptLanguage_en(  )
    local txtChangle = GetElement(self.m_root,"txtChangle_SceneCommunityCopy",WZUILabelTTF)
    txtChangle:setRelativePosition(GlobalMethod:ccp(0.18,0.941375))
    local txtChanngleTotal = GetElement(self.m_root,"txtChanngleTotal_SceneCommunityCopy",WZUILabelTTF)
    txtChanngleTotal:setRelativePosition(GlobalMethod:ccp(0.34,0.939256))
    local txtRank = GetElement(self.m_root,"txtRank_SceneCommnityCopy",WZUILabelTTF)
    txtRank:setDimensions(GlobalMethod:CCSize(100,0))
    txtRank:setScale(0.7)
    local txtWeekDMG = GetElement(self.m_root,"txtWeekDMG_SceneCommunityCopy",WZUILabelTTF)
    txtWeekDMG:setRelativePosition(GlobalMethod:ccp(0.17,0.851546))
    local txtHurtTotal = GetElement(self.m_root,"txtHurtTotal_SceneCommunityCopy",WZUILabelTTF)
    txtHurtTotal:setRelativePosition(GlobalMethod:ccp(0.33,0.851546))
end

function SceneCommunityCopy:_adaptLanguage_th(  )
    local txtRank = GetElement(self.m_root,"txtRank_SceneCommnityCopy",WZUILabelTTF)
    txtRank:setScale(0.7)
    local txtChangle = GetElement(self.m_root,"txtChangle_SceneCommunityCopy",WZUILabelTTF)
    txtChangle:setRelativePosition(GlobalMethod:ccp(0.22,0.941375))
    local txtChanngleTotal = GetElement(self.m_root,"txtChanngleTotal_SceneCommunityCopy",WZUILabelTTF)
    txtChanngleTotal:setRelativePosition(GlobalMethod:ccp(0.34,0.939256))
    local txtWeekDMG = GetElement(self.m_root,"txtWeekDMG_SceneCommunityCopy",WZUILabelTTF)
    txtWeekDMG:setRelativePosition(GlobalMethod:ccp(0.17,0.851546))
    local txtHurtTotal = GetElement(self.m_root,"txtHurtTotal_SceneCommunityCopy",WZUILabelTTF)
    txtHurtTotal:setRelativePosition(GlobalMethod:ccp(0.33,0.851546))
end

function SceneCommunityCopy:_adaptLanguage_vn(  )
    local txtRank = GetElement(self.m_root,"txtRank_SceneCommnityCopy",WZUILabelTTF)
    txtRank:setScale(0.7)
    GetElement(self.m_root, "ftxtInspireCost_SceneCommunityCopy5", WZUIFreeTextBox):setScale(0.8)

    local txtWeekDMG = GetElement(self.m_root,"txtWeekDMG_SceneCommunityCopy",WZUILabelTTF)
    txtWeekDMG:setRelativePosition(GlobalMethod:ccp(0.78,0.685))
    local txtHurtTotal = GetElement(self.m_root,"txtHurtTotal_SceneCommunityCopy",WZUILabelTTF)
    txtHurtTotal:setRelativePosition(GlobalMethod:ccp(0.74,0.644))
end

function SceneCommunityCopy:_adaptLanguage_pt(  )
    local txtChangle = GetElement(self.m_root,"txtChangle_SceneCommunityCopy",WZUILabelTTF)
    txtChangle:setDimensions(GlobalMethod:CCSize(180))
    txtChangle:setRelativePosition(GlobalMethod:ccp(0.183986,0.941375))
    GetElement(self.m_root,"txtChanngleTotal_SceneCommunityCopy",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.343986,0.939256))
    local txtGet = GetElement(self.m_root,"txtGet_SceneCommunityCopy",WZUILabelTTF)
    txtGet:setDimensions(GlobalMethod:CCSize(140))
    txtGet:setRelativePosition(GlobalMethod:ccp(0.631259,0.941375))
    
    GetElement(self.m_root,"txtRank_SceneCommnityCopy",WZUILabelTTF):setScale(0.6)

    local txtWeekDMG = GetElement(self.m_root,"txtWeekDMG_SceneCommunityCopy",WZUILabelTTF)
    txtWeekDMG:setLabelStyleKey("C13_F20")
    txtWeekDMG:setRelativePosition(GlobalMethod:ccp(0.279352,0.851546))
    local txtHurtTotal = GetElement(self.m_root,"txtHurtTotal_SceneCommunityCopy",WZUILabelTTF)
    txtHurtTotal:setRelativePosition(GlobalMethod:ccp(0.522008,0.851546))
end

function SceneCommunityCopy:_adaptLanguage_es(  )
    local txtChange = GetElement(self.m_root,"txtChangle_SceneCommunityCopy",WZUILabelTTF)
    txtChange:setScale(0.8)
    txtChange:setRelativePosition(GlobalMethod:ccp(0.16,0.941375))

    local txtChanngleTotal = GetElement(self.m_root,"txtChanngleTotal_SceneCommunityCopy",WZUILabelTTF)
    txtChanngleTotal:setRelativePosition(GlobalMethod:ccp(0.28,0.939256))

    local txtGet = GetElement(self.m_root,"txtGet_SceneCommunityCopy",WZUILabelTTF)
    txtGet:setRelativePosition(GlobalMethod:ccp(0.65,0.941375))

    local txtChange = GetElement(self.m_root,"txtRank_SceneCommnityCopy",WZUILabelTTF)
    txtChange:setScale(0.7)
    txtChange:setDimensions(GlobalMethod:CCSize(100,0))

    local txtHurtTotal = GetElement(self.m_root,"txtHurtTotal_SceneCommunityCopy",WZUILabelTTF)
    txtHurtTotal:setRelativePosition(GlobalMethod:ccp(0.58,0.851546))

    local txtWeekDMG = GetElement(self.m_root,"txtWeekDMG_SceneCommunityCopy",WZUILabelTTF)
    txtWeekDMG:setRelativePosition(GlobalMethod:ccp(0.28,0.851546))
end

function SceneCommunityCopy:_adaptLanguage_tr(  )
    local txtChangle = GetElement(self.m_root,"txtChangle_SceneCommunityCopy",WZUILabelTTF)
    txtChangle:setDimensions(GlobalMethod:CCSize(180))
    txtChangle:setRelativePosition(GlobalMethod:ccp(0.183986,0.941375))
    GetElement(self.m_root,"txtChanngleTotal_SceneCommunityCopy",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.343986,0.939256))
    local txtGet = GetElement(self.m_root,"txtGet_SceneCommunityCopy",WZUILabelTTF)
    txtGet:setDimensions(GlobalMethod:CCSize(140))
    txtGet:setRelativePosition(GlobalMethod:ccp(0.631259,0.941375))
    
    local txtRank = GetElement(self.m_root,"txtRank_SceneCommnityCopy",WZUILabelTTF)
    txtRank:setDimensions(GlobalMethod:CCSize(180,0))
    txtRank:setScale(0.4)

    local txtWeekDMG = GetElement(self.m_root,"txtWeekDMG_SceneCommunityCopy",WZUILabelTTF)
    txtWeekDMG:setLabelStyleKey("C13_F20")
    txtWeekDMG:setRelativePosition(GlobalMethod:ccp(0.279352,0.851546))
    local txtHurtTotal = GetElement(self.m_root,"txtHurtTotal_SceneCommunityCopy",WZUILabelTTF)
    txtHurtTotal:setRelativePosition(GlobalMethod:ccp(0.522008,0.851546))
end
-----------------------------------语言适配End----------------------------------------------