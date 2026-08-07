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
    self:addTop()
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
    	self.m_nCurSelectIndex = tag
		local copyInfo = self.m_tBossInfo[tag]
		self:_showRightCenter(self.m_tCommunityCopyInfo,copyInfo)
		imgSelect:setVisible(true)
		if self.m_elementCurSelcetCopy then
			self.m_elementCurSelcetCopy:setVisible(false)
		end
		self.m_elementCurSelcetCopy = imgSelect
	else
		MsgBoxManager:showTipBox(txt)
    end
end

--查看奖励信息
function SceneCommunityCopy:onClickReward(element)
	WZLog("SceneCommunityCopy:onClickReward")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local parent =  element:getParent()
	parent = WZUIContainer:luaTo(parent)
	local childNode = parent:getChildByTag(7)
    if childNode == nil then return end
    childNode = WZUIImage:luaTo(childNode)
    if childNode == nil then return end
	local file = childNode:getFile()

	if file == "ui/common/common_icon_lan2.png"  then
		self:createLoading()
		self.m_nGetRewardSelectIndex = 1
		ProtocolProcessorCommunityBossRoom:send_GUILD_GetHurtReward(1)
	elseif file == "ui/common/common_icon_zi2.png" then
		self:createLoading()
		self.m_nGetRewardSelectIndex = 2
		ProtocolProcessorCommunityBossRoom:send_GUILD_GetHurtReward(2)
	elseif file == "ui/common/common_icon_huang2.png" then
		self:createLoading()
		self.m_nGetRewardSelectIndex = 3
		ProtocolProcessorCommunityBossRoom:send_GUILD_GetHurtReward(3)
	else
		local tag = element:getTag()
		local reward = GDatatab_guild_boss_hurt_reward["id_" .. tag].reward

		cell, tcell = CellTowerRewardTip:createElement()
		local txtGet = GetElement(cell,"txtGet_CellTowerRewardTip",WZUILabelTTF)
		local temp =LocalStrings.DAILY_COPY_GOLD_DESC1 .. LocalStrings.ATH_REWARD_CHECK
		txtGet:setText(temp)
		local data = {}
		data.floor_reward = reward
		tcell:setData(data)
		local pParent = parent:getParent()
        pParent:addChild(cell)
        local psy = parent:getPositionY()
        psy = psy + 50
        local psx = parent:getPositionX() -100
        cell:setPosition(GlobalMethod:ccp(psx,psy))
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
    
    local parent = element:getParent()
    parent = WZUIContainer:luaTo(parent)
    local imgBossStats = GetElement(parent,"imgBossStats_SceneCommunityCopy",WZUIImage)
    if imgBossStats:isVisible() then
        local nTag = element:getTag()
        local nCopyId = nTag + (self.m_nCurSelectIndex - 1) * 3
        WndCommunityCopyRank:show(nCopyId) 
        return
    end
    local txtFightStats = GetElement(parent,"txtFightStats_SceneCommunityCopy",WZUILabelTTF)
    if not txtFightStats:isVisible() then
        MsgBoxManager:showTipBox(LocalStrings.DAILYCOPY_LOCKED_TIPS)
        return
    end

    local gampeParam = CacheCenter:getGameParam()
    --if self.m_tCommunityCopyInfo.playTimes >= tonumber(gampeParam.guildBossDareTimes)  then
    --    MsgBoxManager:showTipBox(LocalStrings.CHALLEGE_OVER)
    --    return
    --end
    replaceScene(SceneCommunityBossInfo:createElement())
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
end


function SceneCommunityCopy:_showRightCenter(data,curBoss)
	WZLog("SceneCommunityCopy:_showRightCenter")
	local txtMapName = GetElement(self.m_root,"txtMapName_SceneCommunityCopy",WZUILabelTTF)
    txtMapName:setText(curBoss[1].section_name)

    local conRight = GetElement(self.m_root,"conRight_SceneCommunityCopy",WZUIContainer)
    local totalHP = 0
    for i=1,3 do
        local conBoss = GetElement(self.m_root,"conBoss" .. i .. "_SceneCommunityCopy",WZUIContainer)
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
            local percent = data.bossHp / monsterHp * 100
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
end


function SceneCommunityCopy:_showRightButtom(data)
	WZLog("SceneCommunityCopy:_showRightButtom")
	local conRight = GetElement(self.m_root,"conRight_SceneCommunityCopy",WZUIContainer)
	local conRightButtom = GetElement(conRight,"conRightButtom_SceneCommunityCopy",WZUIContainer)
    local reward = VectorToTable(data.reward)
    local totalHP = 0
    data.weekHurt = tonumber(data.weekHurt)
    for i=1,3 do
        local txtBox = GetElement(conRightButtom,"txtBox" .. i .. "_SceneCommunityCopy",WZUILabelTTF)
        local hurt = GDatatab_guild_boss_hurt_reward["id_" .. i].hurt
        txtBox:setText(hurt)
        totalHP = hurt

        local imgBox = GetElement(conRightButtom,"imgBox" .. i .. "_SceneCommunityCopy",WZUIImage)
        local armBox = GetElement(conRightButtom,"armBox" .. i .. "_SceneCommunityCopy",WZArmature)
        local imgRedPoint = GetElement(conRightButtom,"imgRedPoint" .. i .. "_SceneCommunityCopy",WZUIImage)
        armBox:setVisible(false)
        imgRedPoint:setVisible(false)
        if data.weekHurt >= hurt  then
        	if i == 1 then
        		imgBox:setFile("ui/common/common_icon_lan2.png")
        		armBox:setVisible(true)
        		imgRedPoint:setVisible(true)
        	elseif i == 2 then
        		imgBox:setFile("ui/common/common_icon_zi2.png")
        		armBox:setVisible(true)
        		imgRedPoint:setVisible(true)
        	elseif i == 3 then
        		imgBox:setFile("ui/common/common_icon_huang2.png")
        		armBox:setVisible(true)
        		imgRedPoint:setVisible(true)
        	end
        end
        for j,k in ipairs(reward) do
            if k == 1 and i == 1 then
                armBox:setVisible(false)
                imgRedPoint:setVisible(false)
                imgBox:setFile("ui/common/common_icon_lan3.png")
            elseif k == 2 and i == 2 then
                armBox:setVisible(false)
                imgRedPoint:setVisible(false)
                imgBox:setFile("ui/common/common_icon_zi3.png")
            elseif k == 3 and i == 3 then
                armBox:setVisible(false)
                imgRedPoint:setVisible(false)
                imgBox:setFile("ui/common/common_icon_huang3.png")
            end
        end
    end
    local txtHurtTotal = GetElement(conRight,"txtHurtTotal_SceneCommunityCopy",WZUILabelTTF)
    if data.weekHurt < 0 then
        txtHurtTotal:setText("4294967296")
    else
        txtHurtTotal:setText(data.weekHurt)
    end
    
    for i=1,3 do
        local conRightButtom = GetElement(self.m_root,"conRightButtom_SceneCommunityCopy",WZUIContainer)
        local conBox = GetElement(conRightButtom,"conBox" .. i .. "_SceneCommunityCopy",WZUIContainer)
        local txtBox = GetElement(conRightButtom,"txtBox" .. i .. "_SceneCommunityCopy",WZUILabelTTF)
        local hurt = tonumber(txtBox:getText())
        local percent = hurt / totalHP
        local psx = percent * 480
        psx = psx / 480
        if i <= 2 then
            conBox:setRelativePosition(GlobalMethod:ccp(psx,0.560606))
        end
    end

    local proFightBoss = GetElement(conRight,"proFightBoss_SceneCommunityCopy",WZUIProgress)
    local percent = data.weekHurt / totalHP * 100
    proFightBoss:setPercentage(percent)
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
    
    if curBoss then
    	self:_showRightCenter(data,curBoss)
        self:_showRightButtom(data)
    end
end



-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------



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
    local txtChanngleTotal = GetElement(self.m_root,"txtChanngleTotal_SceneCommunityCopy",WZUILabelTTF)
    txtChanngleTotal:setRelativePosition(GlobalMethod:ccp(0.28,0.939256))
    local txtWeekDMG = GetElement(self.m_root,"txtWeekDMG_SceneCommunityCopy",WZUILabelTTF)
    txtWeekDMG:setRelativePosition(GlobalMethod:ccp(0.18,0.851546))
    local txtHurtTotal = GetElement(self.m_root,"txtHurtTotal_SceneCommunityCopy",WZUILabelTTF)
    txtHurtTotal:setRelativePosition(GlobalMethod:ccp(0.36,0.851546))
    local txtRank = GetElement(self.m_root,"txtRank_SceneCommnityCopy",WZUILabelTTF)
    txtRank:setScale(0.7)
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