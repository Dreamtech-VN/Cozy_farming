--WndWelfare.lua
--@brief	WndWelfare的UI模块
--@date		2016/05/13
--@author	Tianxiang_Xu
--@note		福利


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWelfare:onEnter(element)
	self.m_root = element
    ProtocolProcessorWndActivityOnLine:regAll()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWelfare:onExit(element)
    g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	self:_unInit()
    ProtocolProcessorWndActivityOnLine:unregAll()
end


--@brief    onenter函数已执行
function WndWelfare:onEnterTransitionDidFinish(element)
    WZLog("WndWelfare:onEnterTransitionDidFinish")
	--ProtocolProcessorWndShop:send_MALL_GetBlackMarketInfo()
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    --弹窗动画
    WindowManagerAni:createAppearAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndWelfare:actionCallback(element, data)
    self:_createLoading()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo()
end

--@brief    弹窗动画完成后的回调
function WndWelfare:actionCallback_close(element,data)
    if self.m_tMsgData ~= nil then 
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
    end
    WindowManager:removeWindow(self.m_root , self , true)
    if GlobalGame.g_autoGameActivity then
        WZLog("***** 进主城，获取活动信息 *****")
        if CheckButtonShow(21) then
            if WndGameActivity.m_root == nil then
                MsgBoxManager:showGameActivity()
            end
        end
    end
end

--@brief    关闭窗口
function WndWelfare:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManagerAni:createDisappearAction(self.m_root,"actionCallback_close",self)
end

--@brief    触摸开始
function WndWelfare:onTouchBegan(element, pt)
    -- body
    local point = self.m_root:getParentElement():convertToNodeSpace(pt)
    local bPoint = WndItemInfo:checkPoint(pt,dir)
    WZLog("开始按下回调函数:",bPoint)
    if bPoint == true then
        WZLog("回调函数1:",type(bPoint),bPoint)
    else 
        WZLog("回调函数12:",type(bPoint),bPoint)
        WndItemInfo:onCloseClick()
    end

    if WndTips.m_root then
        WndTips:onCloseClick()
    end
end

--@brief    点击左边栏按钮回调
function WndWelfare:onClickLeftMenu(nItemId)
    -- body
    self.m_nCurUIId = nItemId

    self:_setLightVisible()
    
	self:chooseMethod()
end

--@brief    更新福利界面红点
function WndWelfare:updateRedDot()
    --body
    if self.m_root == nil or self.m_tLeftCell == nil then return end
    if self.m_tLeftCell == nil then return end
    for i = 1, #self.m_tLeftCell do
        if self.m_tLeftCell[i] then
            local bIsHavedRed = false
            if self.m_nType == 1 then 
                if CacheCenter.m_tWelfareItemRedDotList then
                    for idx = 1, #CacheCenter.m_tWelfareItemRedDotList do
                        WZLog("WndWelfare:updateRedDot ", CacheCenter.m_tWelfareItemRedDotList[idx])
                        if self.m_tListItem[i].ui_id == CacheCenter.m_tWelfareItemRedDotList[idx] then
                            bIsHavedRed = true
                            break
                        end
                    end
                end
            elseif self.m_nType == 6 then 
                if CacheCenter.m_tBackActivityRedDotList then
                    for idx = 1, #CacheCenter.m_tBackActivityRedDotList do
                        WZLog("WndWelfare:updateRedDot ", CacheCenter.m_tBackActivityRedDotList[idx])
                        if self.m_tListItem[i].ui_id == CacheCenter.m_tBackActivityRedDotList[idx] then
                            bIsHavedRed = true
                            break
                        end
                    end
                end
            end
            if bIsHavedRed then
                self.m_tLeftCell[i]:setRedDotVisible(true)
            else
                self.m_tLeftCell[i]:removeRedDot()
            end
        end
    end
end


function WndWelfare:setFyberTime()
    --body
    for i = 1, #self.m_tLeftCell do
        local nUIId = self.m_tLeftCell[i]:getItemId()
        if nUIId == 999998 then
            tNewObj:setFyberTime()
            break 
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新界面信息
function WndWelfare:_update()
    -- body
    --标题
    self:_setTitle()
    --左边栏
    self:_createLeftMenu()
    --右边栏内容
	self:chooseMethod()
end

function WndWelfare:chooseMethod()
    --刷新右边栏内容
    if self.m_nCurUIId == 79 or self.m_nCurUIId == 126 or self.m_nCurUIId == 115 or self.m_nCurUIId == 165 or self.m_nCurUIId == 181 or self.m_nCurUIId == 1000000 or self.m_nCurUIId == 190 or self.m_nCurUIId == 999998 then
        self:_updateRightContent()
    else
        self:_sendProtoco(self.m_nCurUIId)
    end
end

--@brief    设置界面标题
function WndWelfare:_setTitle()
    -- body
    local imgTitle = GetElement(self.m_root, "imgTitle_WndWelfare", WZUIImage)
    if self.m_nType == 1 then
        ChangeChatChannel(Chat_Channel_Welfare_Weal)
        imgTitle:setFile("ui/welfare/common_icon_fl.png")

		self.m_tListItem = nil
        if self.m_tListItem == nil then
            self.m_tListItem = {}
        end

        for idx, value in pairs(self.m_tWelfareList) do
            if CheckButtonShow(value.button_id) then
                if value.ui_id == 999998 then
                    if NeedFyber(2) then
                        table.insert(self.m_tListItem, 1, value)
                    end
				elseif value.ui_id == 115 then
                    if not CacheCenter:getFundFinish() then
                        table.insert(self.m_tListItem, value)
                    end
                else
                    table.insert(self.m_tListItem, value)
                end
            end
        end
        --将获取的活动列表中的福利添加到列表中
        for i = 1, #self.m_tTempListItem do
            local tTemp = {}
            tTemp.name = self.m_tTempListItem[i].title
            tTemp.ui_id = self.m_tTempListItem[i].type 
            tTemp.button_id = 0
            if tTemp.ui_id == 1 then
                table.insert(self.m_tListItem, 1, tTemp)
            else
                table.insert(self.m_tListItem, tTemp)
            end
        end
		WZLog("sdgjkjsdkklsllll",CacheCenter:getGameParam().blackMarketRateOpenLevel)
		if CacheCenter:getGameParam().blackMarketRateOpenLevel ~= nil and CacheCenter:getPlayerInfo().level >= tonumber(CacheCenter:getGameParam().blackMarketRateOpenLevel) then
		if WndGangsterInn.m_bOpen == nil or WndGangsterInn.m_bOpen == false then
			table.insert(self.m_tListItem,  
			{name = LocalStrings.GAME_ACTIVITY_TITLE39, ui_id = 1000000, button_id = 18})
		elseif WndGangsterInn.m_bOpen == true then
			table.insert(self.m_tListItem, 1, 
			{name = LocalStrings.GAME_ACTIVITY_TITLE39, ui_id = 1000000, button_id = 18})
		end
		end
    elseif self.m_nType == 6 then --回归活动
        imgTitle:setFile("ui/welfare/common_icon_dzhg.png")

        self.m_tListItem = {}

        --将获取的活动列表中的福利添加到列表中
        for i = 1, #self.m_tTempListItem do
            local tTemp = {}
            tTemp.name = self.m_tTempListItem[i].title
            tTemp.ui_id = self.m_tTempListItem[i].type 
            tTemp.button_id = 0
            
            table.insert(self.m_tListItem, tTemp)
        end
    else
        ChangeChatChannel(Chat_Channel_Welfare_Compete)
        imgTitle:setFile("ui/welfare/common_icon_bs.png")

        if self.m_tListItem == nil then
            self.m_tListItem = {}
        end
        for idx, value in pairs(self.m_tCompeteList) do
            if CheckButtonShow(value.button_id) then
                table.insert(self.m_tListItem, value)
            end
        end
    end
end

--@brief    设置左边列表菜单
function WndWelfare:_createLeftMenu()
    -- body
    local flListItem = GetElement(self.m_root, "flListItem_WndWelfare", WZUIFreeListContainer)
	flListItem:removeAll()
    self.m_tLeftCell = {}

    local bIsExist = self:_checkUI_IDExist(self.m_nCurUIId)
    local nFirstRedUI_Id, nFirstIndex = self:_getFirstRedDotItem() --返回首个红点的项的ui_id和索引
    WZLog("WndWelfare:_createLeftMenu", nFirstRedUI_Id, nFirstIndex)

    for i = 1, #self.m_tListItem do
    WZLog("WndWelfare:_createLeftMenu", self.m_tListItem[i].ui_id)
        local element, tCell = CellWelfareItem:createElement()
        if element and tCell then
            if (bIsExist == false or self.m_nCurUIId == nil) then
                if i == 1 and self.m_tListItem[i].ui_id ~= 999998 then
                    if nFirstRedUI_Id then
                        self.m_nCurUIId = nFirstRedUI_Id
                    else
                        self.m_nCurUIId = self.m_tListItem[i].ui_id
                    end
                    bIsExist = true
                else
                    if i == 2 and self.m_tListItem[i].ui_id ~= 999998 then
                        if nFirstRedUI_Id then
                            self.m_nCurUIId = nFirstRedUI_Id
                        else
                            self.m_nCurUIId = self.m_tListItem[i].ui_id
                        end
                        bIsExist = true
                    end
                end
            end

            if self.m_nType == 1 then 
                if CacheCenter.m_tWelfareItemRedDotList then
                    for idx = 1, #CacheCenter.m_tWelfareItemRedDotList do
                        WZLog("WndWelfare:_createLeftMenu 1111", CacheCenter.m_tWelfareItemRedDotList[idx])
                        if self.m_tListItem[i].ui_id == CacheCenter.m_tWelfareItemRedDotList[idx] then
                            tCell:setRedDotVisible(true)
                        end
                    end
                end
            --比赛红点
            elseif self.m_nType == 2 then
                if WndLeagueTeamDetail.m_bNeedRecruit == true and self.m_tListItem[i].ui_id == 156 then
                    tCell:setRedDotVisible(true)
                elseif GlobalGame.g_tRedPointList.qualifying and self.m_tListItem[i].ui_id == 118 then
                    tCell:setRedDotVisible(true)
                elseif GlobalGame.g_tRedPointList.melee and self.m_tListItem[i].ui_id == 181 then
                    tCell:setRedDotVisible(true) 
                elseif GlobalGame.g_bIsGuildWarHaveRedDot and self.m_tListItem[i].ui_id == 110 then
                    tCell:setRedDotVisible(true) 
                end
            elseif self.m_nType == 6 then --回流活动红点
                for idx = 1, #CacheCenter.m_tBackActivityRedDotList do
                    WZLog("WndWelfare:_createLeftMenu 1111", CacheCenter.m_tBackActivityRedDotList[idx])
                    if self.m_tListItem[i].ui_id == CacheCenter.m_tBackActivityRedDotList[idx] then
                        tCell:setRedDotVisible(true)
                    end
                end
            end
            tCell:setData(self.m_tListItem[i].name, self.m_tListItem[i].ui_id)
            tCell:setCallBack(self, self.onClickLeftMenu)
            element = WZUIContainer:luaTo(element)
            flListItem:pushBack(element)
            table.insert(self.m_tLeftCell, tCell)
        end
    end
    if nFirstIndex and nFirstIndex > 5 then
        local nPositionY = flListItem:getMinPosition().y + (nFirstIndex - 5) * 80
        if nPositionY > flListItem:getMaxPosition().y then
            nPositionY = flListItem:getMaxPosition().y
        end
        flListItem:getMoveElement():setPositionY(nPositionY)
    else
        flListItem:getMoveElement():setPositionY(flListItem:getMinPosition().y)
    end
    --
    self:_setLightVisible()
end

--@brief    需要发送协议获取数据的项
--@param    nItemId:界面Id
function WndWelfare:_sendProtoco(nItemId)
    -- body
    if nItemId == 110 then
        --公会战
        self:_createLoading()
        ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarTime( )
    elseif nItemId == 118 then
        --排位赛
        self:_createLoading()
        ProtocolProcessorScenePvpRank:send_TRIO_GetMatchInfo( )
        return 
    elseif nItemId == 156 then 
        --英雄联赛
        self:_createLoading()
        ProtocolProcessorWndLeague:send_HERO_HeroStartTime()
        return 
    else
        local nRewardId 
        for i = 1, #self.m_tTempListItem do
            --WZLog("WndWelfare:self.m_tTempListItem",self.m_tTempListItem[i].type)
            if self.m_tTempListItem[i].type == nItemId then
                --WZLog("WndWelfare:self.m_tTempListItem:",self.m_tTempListItem[i].activityId)
                nRewardId = self.m_tTempListItem[i].activityId
                break
            end
        end
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(nRewardId, nItemId)
    end
end

--@brief    设置右边容器内容
function WndWelfare:_updateRightContent()
    -- body
    WZLog("--WndWelfare:_updateRightContent--",self.m_nCurUIId)
    local conContext = GetElement(self.m_root, "conContext_WndWelfare", WZUIContainer)
    if conContext == nil then return end

    if self.m_nCurUIId ~= 999998 then
        conContext:removeAllChildrenWithCleanup(true)
        GetElement(self.m_root, "img9GrayBg_WndWelfare", WZUI9Image):setVisible(true)
    end
    if self.m_nCurUIId == 79 then
        WZLog("WndWelfare:_updateRightContent  签到")
        local bRet = true
        self.m_tPanelElement = conContext:getChildByTag(self.m_nCurUIId)
        if self.m_tPanelElement ~= nil then
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            self.m_tPanelLuaObj = self.m_tPanelElement:getLuaObjectIndex()
            bRet = false
        else
            WndGameSingIn.m_bNeedSendProtocol = true
            self.m_tPanelElement, self.m_tPanelLuaObj = WndGameSingIn:createElement()
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            bRet = true
        end
        if bRet then
            conContext:addChild(self.m_tPanelElement, 0, self.m_nCurUIId)
        end
    elseif self.m_nCurUIId == 115 then
        WZLog("WndWelfare:_updateRightContent  成长基金")
        local bRet = true
        self.m_tPanelElement = conContext:getChildByTag(self.m_nCurUIId)
        if self.m_tPanelElement ~= nil then
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            self.m_tPanelLuaObj = self.m_tPanelElement:getLuaObjectIndex()
            bRet = false
        else
            self.m_tPanelElement, self.m_tPanelLuaObj = WndFund:createElement()
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            bRet = true
        end
        if bRet then
            conContext:addChild(self.m_tPanelElement, 0, self.m_nCurUIId)
        end
    elseif self.m_nCurUIId == 126 then
        WZLog("WndWelfare:_updateRightContent  爱心许愿")
        local bRet = true
        self.m_tPanelElement = conContext:getChildByTag(self.m_nCurUIId)
        if self.m_tPanelElement ~= nil then
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            self.m_tPanelLuaObj = self.m_tPanelElement:getLuaObjectIndex()
            bRet = false
        else
            self.m_tPanelElement, self.m_tPanelLuaObj = WndLoveLottery:createElement()
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            bRet = true
        end
        if bRet then
            conContext:addChild(self.m_tPanelElement, 0, self.m_nCurUIId)
        end
    elseif self.m_nCurUIId == 118 or self.m_nCurUIId == 181 then
        WZLog("WndWelfare:_updateRightContent  排位赛入口 || 大乱斗")
        local bRet = true
        self.m_tPanelElement = conContext:getChildByTag(self.m_nCurUIId)
        if self.m_tPanelElement ~= nil then
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            self.m_tPanelLuaObj = self.m_tPanelElement:getLuaObjectIndex()
            bRet = false
        else
            self.m_tPanelElement, self.m_tPanelLuaObj = CellPvpCompete:createElement()
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            bRet = true
        end
        if bRet then
            conContext:addChild(self.m_tPanelElement, 0, self.m_nCurUIId)
        end
        if self.m_tPanelLuaObj then
            self.m_tPanelLuaObj:show(self.m_tData, self.m_nCurUIId)
        end
    elseif self.m_nCurUIId == 156 then
        WZLog("WndWelfare:_updateRightContent  英雄联赛入口")
        local bRet = true
        self.m_tPanelElement = conContext:getChildByTag(self.m_nCurUIId)
        if self.m_tPanelElement ~= nil then
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            self.m_tPanelLuaObj = self.m_tPanelElement:getLuaObjectIndex()
            bRet = false
        else
            self.m_tPanelElement, self.m_tPanelLuaObj = CellLeagueCompete:createElement()
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            bRet = true
        end
        if bRet then
            conContext:addChild(self.m_tPanelElement, 0, self.m_nCurUIId)
        end
        if self.m_tPanelLuaObj then
            self.m_tPanelLuaObj:show(self.m_nLeagueStartTime, self.m_nLeagueEndTime, self.m_nLeagueType)
        end
    elseif self.m_nCurUIId == 110 then
        WZLog("WndWelfare:_updateRightContent  公会战")
        local bRet = true
        self.m_tPanelElement = conContext:getChildByTag(self.m_nCurUIId)
        if self.m_tPanelElement ~= nil then
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            self.m_tPanelLuaObj = self.m_tPanelElement:getLuaObjectIndex()
            bRet = false
        else
            self.m_tPanelElement, self.m_tPanelLuaObj = CellCommunityFight:createElement()
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            bRet = true
        end
        if bRet then
            conContext:addChild(self.m_tPanelElement, 0, self.m_nCurUIId)
        end
        self.m_tPanelLuaObj:setMessage(self.m_sCommunityTime, self.m_nNextStartTime, self.m_nCommunityState)
        
        if self.m_tPanelLuaObj then
            self.m_tPanelLuaObj:show()
        end
    elseif self.m_nCurUIId == 165 then
        WZLog("WndWelfare:_updateRightContent  在线福利")
        local bRet = true
        self.m_tPanelElement = conContext:getChildByTag(self.m_nCurUIId)
        if self.m_tPanelElement ~= nil then
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            self.m_tPanelLuaObj = self.m_tPanelElement:getLuaObjectIndex()
            bRet = false
        else
            self.m_tPanelElement, self.m_tPanelLuaObj = CellOnLineReward:createElement()
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            bRet = true
        end
        if bRet then
            conContext:addChild(self.m_tPanelElement, 0, self.m_nCurUIId)
        end
    elseif self.m_nCurUIId == 1000000 then
        WZLog("WndWelfare:_updateRightContent  黑市入口")
        local bRet = true
        self.m_tPanelElement = conContext:getChildByTag(self.m_nCurUIId)
        if self.m_tPanelElement ~= nil then
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            self.m_tPanelLuaObj = self.m_tPanelElement:getLuaObjectIndex()
            bRet = false
        else
            self.m_tPanelElement, self.m_tPanelLuaObj = WndGangsterInnActivity:createElement()
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            bRet = true
        end
        if bRet then
            conContext:addChild(self.m_tPanelElement, 0, self.m_nCurUIId)
        end
    elseif self.m_nCurUIId == 190 then
        WZLog("WndWelfare:_updateRightContent  幸运礼盒入口")
        local bRet = true
        self.m_tPanelElement = conContext:getChildByTag(self.m_nCurUIId)
        if self.m_tPanelElement ~= nil then
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            self.m_tPanelLuaObj = self.m_tPanelElement:getLuaObjectIndex()
            bRet = false
        else
            self.m_tPanelElement, self.m_tPanelLuaObj = WndLuckyGift:createElement()
            self.m_tPanelElement = WZUIContainer:luaTo(self.m_tPanelElement)
            bRet = true
        end
        if bRet then
            conContext:addChild(self.m_tPanelElement, 0, self.m_nCurUIId)
        end
    elseif self.m_nCurUIId == 999998 then
        WZLog("WndWelfare:_updateRightContent  奖励入口") 
        DoFyberReward(1)
        return 
    end
end

--@brief    设置面板内容
function WndWelfare:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
    WZLog("WndWelfare::_updateActivityContext()")
    if self.m_nCurUIId == nil then return end 
    if self.m_nCurUIId == 79 or self.m_nCurUIId == 110 or self.m_nCurUIId == 126 or self.m_nCurUIId == 115 or self.m_nCurUIId == 165 or self.m_nCurUIId == 118 or self.m_nCurUIId == 156 or self.m_nCurUIId == 181 or self.m_nCurUIId == 1000000 or self.m_nCurUIId == 190 then
        self:_updateRightContent()
        return 
    end

    if self.m_nCurUIId == g_tGameActivityTypes.ACTIVITY_EASTTHINGS then
        GetElement(self.m_root, "img9GrayBg_WndWelfare", WZUI9Image):setVisible(false)
    else
        GetElement(self.m_root, "img9GrayBg_WndWelfare", WZUI9Image):setVisible(true)
    end
    local con_ActivityContext = GetElement(self.m_root,"conContext_WndWelfare",WZUIContainer)
    if con_ActivityContext == nil then
        return
    end
    con_ActivityContext:removeAllChildrenWithCleanup(true)
    WZLog("m_nCurrentSelectTypeId="..self.m_nCurUIId)
    if g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE == self.m_nCurUIId then 
        WZLog("WndWelfare:_updateActivityContext|| 首次充值")
        local NodeTag = 101
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellRechargePanelActivity:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        WZLog("rewardId="..rewardId[1])
        self.m_tCommonPanelLuaObj:setMessage(content,status[1],rewardItems,rewardItemsParamCount,activityId,rewardId[1])
    elseif g_tGameActivityTypes.ACTIVITY_TOTALFIRSTRECHARGE == self.m_nCurUIId or g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST == self.m_nCurUIId or g_tGameActivityTypes.ACTIVITY_STRENGTHEN == self.m_nCurUIId or g_tGameActivityTypes.ACTIVITY_BACK_RECHARGE == self.m_nCurUIId then 
        WZLog("WndWelfare:_updateActivityContext|| 累计充值|累计消费|装备强化|回归充值")
        for i=1,#tips do
            WZLog("tip "..i.."|"..tips[i])
        end

        for i=1,#target do
            WZLog("=======================>"..target[i])
        end

        if #target ==0 then 
            WZLog("=================null==============")
        end 

        local NodeTag = 102
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellTotalRechargetPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end

        self.m_tCommonPanelLuaObj:setMessage(self.m_nCurUIId,tips,startTime ,endTime ,serverTime,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,activityId,target)
    elseif g_tGameActivityTypes.ACTIVITY_CUMULATIVELOGIN == self.m_nCurUIId then 
        WZLog("WndWelfare:_updateActivityContext|| 累计登录")
        local NodeTag = 103
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellTotalLoginPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, self.m_cellItemObj, tips,startTime ,endTime)
    elseif g_tGameActivityTypes.ACTIVITY_TIMEDLOGIN == self.m_nCurUIId or g_tGameActivityTypes.ACTIVITY_BACK_LOGIN == self.m_nCurUIId then 
        WZLog("WndWelfare:_updateActivityContext|| 限时登录 || 回归登陆")
        local NodeTag = 104
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellLoginActivityPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId, tips, startTime, endTime, serverTime, rewardItems, rewardId, rewardItemsParamCount, count, status, rewardCounts, self.m_cellItemObj, self.m_nCurUIId)
    elseif g_tGameActivityTypes.ACTIVITY_GRADE == self.m_nCurUIId then 
        WZLog("WndWelfare:_updateActivityContext|| 等级冲刺")
        local NodeTag = 105
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellLevelSprintPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(self.m_nCurUIId,tips,startTime,endTime,serverTime,rewardId,status,rewardItems,rewardItemsParamCount,rewardCounts,activityId,target)
    elseif g_tGameActivityTypes.ACTIVITY_IMPROVEFIGHT == self.m_nCurUIId then 
        WZLog("WndWelfare:_updateActivityContext|| 战力冲刺")
        local NodeTag = 106
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellFightingPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId,tips,startTime,endTime,serverTime,rewardId,status,rewardItems,rewardItemsParamCount,rewardCounts,target)
    elseif g_tGameActivityTypes.ACTIVITY_VIPGIFBAG == self.m_nCurUIId then 
        WZLog("WndWelfare:_updateActivityContext|| VIP等级礼包") 
        local NodeTag = 107
        local bRet = true 
        for i=1,#tips do
            WZLog("VIP等级礼包 "..i.."|"..tips[i] .. "|" .. status[i])
        end
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellActivityVipPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage( activityId,count,maxCount ,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, tips)
    elseif g_tGameActivityTypes.ACTIVITY_DISCOUNTGIFBAG == self.m_nCurUIId then 
        WZLog("WndWelfare:_updateActivityContext|| 优惠礼包") 
        local NodeTag = 108
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellActivityGifPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end 
        self.m_tCommonPanelLuaObj:setMessage(activityId,startTime,endTime,rewardItems,rewardItemsParamCount,count,status[1],maxCount,rewardId)
    elseif self.m_nCurUIId == g_tGameActivityTypes.ACTIVITY_TARGETREWARD_1 or g_tGameActivityTypes.ACTIVITY_TARGETREWARD_2 ==self.m_nCurUIId or g_tGameActivityTypes.ACTIVITY_TARGETREWARD_3 == self.m_nCurUIId or g_tGameActivityTypes.ACTIVITY_TARGETREWARD_4 == self.m_nCurUIId then 
        WZLog("WndWelfare:_updateActivityContext|| 副本关卡|竞技目标奖励|排位积分|弹王积分")


        for i=1,#target do
            WZLog("=======================>"..target[i])
        end

        if #target ==0 then 
            WZLog("=================null==============")
        end 
        
        local NodeTag = 109
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellCostActivityPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end 
        
        self.m_tCommonPanelLuaObj:setMessage( activityId, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count ,target, self.m_nCurUIId)
    elseif self.m_nCurUIId == g_tGameActivityTypes.ACTIVITY_EASTTHINGS then 
        WZLog("WndWelfare:_updateActivityContext|| 补充活力") 
        local NodeTag = 110
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)

        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellEatthingsPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end 

        self.m_tCommonPanelLuaObj:setMessage(activityId,self.m_nCurUIId,status,serverTime,rewardItems,rewardItemsParamCount)
    elseif self.m_nCurUIId == g_tGameActivityTypes.ACTIVITY_DAILYFIRSTRECHARGE then 
        WZLog("WndWelfare:_updateActivityContext|| 每日首充")
        local NodeTag = 111
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellDailyFirstRecharge:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        WZLog("rewardId="..rewardId[1])
        self.m_tCommonPanelLuaObj:setMessage(activityId, status[1], serverTime, rewardItems,rewardItemsParamCount,rewardId[1], target[1])
    elseif self.m_nCurUIId == g_tGameActivityTypes.ACTIVITY_TIMEDFIRSTRECHARGE then 
        WZLog("WndWelfare:_updateActivityContext|| 限时充值") 
        local NodeTag = 112
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellTimeFirstRecharge:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        WZLog("rewardId="..rewardId[1])
        self.m_tCommonPanelLuaObj:setMessage(activityId, status[1], serverTime, rewardItems,rewardItemsParamCount, startTime, endTime, rewardId[1])
    elseif self.m_nCurUIId == g_tGameActivityTypes.ACTIVITY_PRERECHARGE then 
        WZLog("WndWelfare:_updateActivityContext|| 封测充值") 
        local NodeTag = 113
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellPreRechargePanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end

        self.m_tCommonPanelLuaObj:setMessage(activityId, content, tips)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_LEVELLIST or g_tGameActivityTypes.ACTIVITY_ATHLETICSLIST ==self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_FIGHTINGLIST == self.m_nCurrentSelectTypeId then 
        WZLog("WndGameActivity:_updateActivityContext|| 排行")

        local NodeTag = 114
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellListPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end 

        self.m_tCommonPanelLuaObj:setMessage(self.m_nCurrentSelectTypeId, tips, startTime, endTime, serverTime, rewardId, rewardItems, rewardItemsParamCount, rewardCounts, activityId, content)
    elseif g_tGameActivityTypes.ACTIVITY_TODAYRECHARGE == self.m_nCurUIId then
        WZLog("WndWelfare:ACTIVITY_TODAYRECHARGE",g_tGameActivityTypes.ACTIVITY_TODAYRECHARGE)
        WZLog("WndWelfare:_updateActivityContext||每日充值奖励") 
        
        local NodeTag = 115
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellTodayRechargePanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end

        self.m_tCommonPanelLuaObj:setMessage(self.m_nCurUIId,tips,startTime ,endTime ,serverTime,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,activityId,target)
    elseif self.m_nCurUIId == g_tGameActivityTypes.ACTIVITY_NEWSERVER_CARPACKAGE then
        local NodeTag = 116
        
        self.m_tCommonPanelElement = WndCardDraw:createElement()
        self.m_tCommonPanelLuaObj = WndCardDraw
        con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        return 
    elseif g_tGameActivityTypes.ACTIVITY_BACK_FIGHT == self.m_nCurUIId then 
        WZLog("WndWelfare:_updateActivityContext|| 回归-每日战斗")
        local NodeTag = 117
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellBackFightPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
    end
    
    if self.m_tCommonPanelElement ~= nil then
        self.m_tCommonPanelLuaObj:showWindow()
    end
end

--@brief    设置选中的左边菜单变亮
function WndWelfare:_setLightVisible()
    -- body
    if self.m_tLeftCell then
        for i = 1, #self.m_tLeftCell do
            if self.m_tLeftCell[i]:getItemId() == self.m_nCurUIId then
                self.m_tLeftCell[i]:setLightVisible(true)
                if self.m_tLeftCell[i]:getItemId() == 181 then
                    if GlobalGame.g_tRedPointList.melee then
                        GlobalGame.g_tRedPointList.melee = false
                        self.m_tLeftCell[i]:setRedDotVisible(false)
                        ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(self.m_tLeftCell[i]:getItemId())
                    end
                end
            else
                self.m_tLeftCell[i]:setLightVisible(false)
            end
        end
    end
end

--@brief    网络勾搭动画
function WndWelfare:_createLoading()
    -- body
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief    关闭网络勾搭动画
function WndWelfare:_closeLoading()
    -- body
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

--@brief    判断传进来的ui_id是否存在列表当中
--@param    ui_id:检测的ui_id
function WndWelfare:_checkUI_IDExist(ui_id)
    -- body
    if self.m_tListItem == nil or ui_id == nil then 
        return false 
    end

    for i = 1, #self.m_tListItem do
        if self.m_tListItem[i].ui_id == ui_id then
            return true
        end
    end

    return false
end
-------------------------------------私有方法模块End----------------------------------------

--@brief    设置在线奖励内容
function  WndWelfare:setCellData( online,reward, config)
    self.m_tPanelLuaObj:setData(online,VectorToTable(reward), VectorToTable(config))
end

--@brief    领取在线奖励
function WndWelfare:getReward( rewardId,itemId,num,online,reward )
    self.m_tPanelLuaObj:getRewardOk(VectorToTable(itemId),VectorToTable(num),online,VectorToTable(reward))
end
