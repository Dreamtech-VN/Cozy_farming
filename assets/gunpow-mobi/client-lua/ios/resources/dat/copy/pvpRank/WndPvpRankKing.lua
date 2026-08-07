--WndPvpRankKing.lua
--@brief	WndPvpRankKing的UI模块
--@date		2015-11-12
--@author	bishao
--@note		竞技之王


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPvpRankKing:onEnter(element)
	self.m_root = element
    ProtocolProcessorScenePvpRank:regAll()
    AdaptLanguage(self)
end

----@brief onEnter函数执行完成回调
function WndPvpRankKing:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

----@brief    弹窗动画完成后的回调
function WndPvpRankKing:actionCallback(element, data)
    WZLog("----------------send worship log and player info-----------------")
    self:_createLoadingBox()
    if self.m_nType == 99 then 
        ProtocolProcessorScenePvpRank:send_RANKMATCH_GetWorshipLog()
        ProtocolProcessorScenePvpRank:send_RANKMATCH_GetPlayerInfo()
    elseif self.m_nType == 98 then 
        GetElement(self.m_root, "imgTitle_WndPvpRankKing", WZUIImage):setFile("ui/common/common_icon_star.png")
        ProtocolProcessorScenePvpRank:send_TRIO_GetTourPlayerInfo()
        ProtocolProcessorScenePvpRank:send_TRIO_GetTourWorshipLog()
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPvpRankKing:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndPvpRankKing:OnClose(element)
    WZLog("WndPvpRankKing:onClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)
end

--@brief	动画播完后的回调
function WndPvpRankKing:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
end


function WndPvpRankKing:onTouchBegin(element, point)
    -- 点击日志其他地方，取消日志
    local conLog = GetElement(self.m_root,"conWorship_WndPvpRankKing",WZUIContainer)
    local isContain = self:checkPointContain(conLog,point)
    if not isContain then
        self.descLog = false
        conLog:setVisible(self.descLog)
    end

    self:clearChecked(point)
end

function WndPvpRankKing:checkPointContain(con,point)
    local x = con:getPositionX()
    local y = con:getPositionY()
    local pt1 = con:convertToNodeSpace(GlobalMethod:ccp(point.x,point.y))
    local size = con:getContentSize()
    if pt1.x > 0 and pt1.x < size.width and pt1.y > 0 and pt1.y < size.height then
        return true
    end
    return false
end


function WndPvpRankKing:onClickPlayer()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.playerInfo.playerId)
end

-- 查看宠物信息
function WndPvpRankKing:OnPet()
    WZLog("-------------------click pet--------------------")
    local petInfo = self.playerInfo.petMessage
    if petInfo == "" then return end
    petInfo = json.decode(self.playerInfo.petMessage)
    local conPet = GetElement(self.m_root,"conPet_WndPvpRankKing",WZUIContainer)
    local con =  GetElement(self.m_root,"conMain_WndPvpRankKing",WZUIContainer)
    WndTips:show(conPet,con,13,petInfo,GlobalMethod:ccp(100,0))
end

-- 查看日志
function WndPvpRankKing:onCheckLog()
    WZLog("---------------------onCheckLog--------------------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local conLog = GetElement(self.m_root,"conWorship_WndPvpRankKing",WZUIContainer)
    conLog:setVisible(not self.descLog)
    self.descLog = not self.descLog
end


function WndPvpRankKing:updateLog()
    WZLog("-------------------get log--------------------")
    ProtocolProcessorScenePvpRank:send_RANKMATCH_GetWorshipLog( )
end

--@brief    获取是否可以膜拜
function WndPvpRankKing:getCanWorship()
    -- body
    WZLog("WndPvpRankKing:getCanWorship", self.logData.worshipState)
    if self.m_nType == 98 then 
        if self.logData.worshipState == 2 then 
            return 1
        else
            return 0
        end
    elseif self.m_nType == 99 then 
        if self.logData.worshipState == 2 then 
            return 1
        else
            return 0
        end
    end
end

--@brief    点击排名详情回调
function WndPvpRankKing:onCheckRankList(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nType == 98 then 
        WndAthRank:showAthRank()
    elseif self.m_nType == 99 then 
        self:_createLoadingBox()
        ProtocolProcessorScenePvpRank:send_TRIO_GetMatchInfo()
    end
end

--@brief    点击规则按钮回调
function WndPvpRankKing:onCheckRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nType == 98 then 
        WndSingleMapDesc:showInterface1(LocalStrings.RANK_SCORE_DESC4)
    elseif self.m_nType == 99 then 
        WndSingleMapDesc:showInterface1(LocalStrings.RANK_SCORE_DESC3)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 更新
function WndPvpRankKing:_updateLog()
    self:_createLog()
end

function WndPvpRankKing:_initUI(info)
    if info.id == CacheCenter:getPlayerInfo().id and self.m_nType == 99 then 
        GetElement(self.m_root, "conMy_WndPvpRankKing", WZUIContainer):setVisible(true)
        
        local cntW = GetElement(self.m_root,"ftbWorShiped_WndPvpRankKing",WZUIFreeTextBox)
        cntW:setShowText(string.format(LocalStrings.RANK_KING_WORSHIP_CNT, info.worshipNum))
        local cntG = GetElement(self.m_root,"ftbGold_WndPvpRankKing",WZUIFreeTextBox)
        cntG:setShowText(string.format(LocalStrings.RANK_KING_GOLD_CNT, self.logData.gold))
    end
end

-- 膜拜记录
function WndPvpRankKing:_createLog()
    if not self.m_root then return end
    -- 日志记录
    local tab = GetElement(self.m_root,"tabWorship_WndPvpRankKing",WZUITableContainer)
    tab:cleanTable()
    for i = 1, #self.logData.log do
        local cell,tcell = CellPvpRankKingLog:createElement()
        cell:setTag(i - 1)
        tab:setCellElement(cell)
        tcell:setData(self.logData.log[i])
    end
end

--@brief    显示角色
function WndPvpRankKing:showPlayer(info)
    -- body
    self:_initUI(info)
    -- 描述
    if info.rank == 1 then 
        local ftbKing = GetElement(self.m_root,"ftbLastKing_WndPvpRankKing",WZUIFreeTextBox)
        if self.m_nType == 98 then 
            ftbKing:setShowText(string.format(LocalStrings.RANK_SCORE_DESC1,info.name))
        else
            ftbKing:setShowText(string.format(LocalStrings.RANK_KING_DESC1,info.name))
        end
    end

    local celElement,tCell = CellRankSeat:createElement()
    if self.m_tRoleAniList == nil then self.m_tRoleAniList = {} end

    if celElement ~= nil and tCell ~= nil then 
        celElement:setTag(info.rank - 1)    --从0开始设置Tag值
        self:setRolePosition(celElement, tCell, info.rank, self.m_nType)
        if info.rank == 3 then  --设置翻转
            tCell:setRankSeat(info, self.m_nType, true)
        else
            tCell:setRankSeat(info, self.m_nType)
        end
        tCell:setOtherData(self.m_nType, self, self.m_root)

        self.m_tRoleAniList[info.rank] = tCell 
    end 
end

--@brief    设置角色的位置
--@param    element要添加的节点
--@param    positionIndex角色的名次
--@param    nType 排行榜类型
function WndPvpRankKing:setRolePosition(element, tCell, positionIndex, nType)
    -- body
    tCell:setMedalType(positionIndex, nType)
    if positionIndex == 1 then
        GetElement(self.m_root, "conFirst_WndPvpRankKing", WZUIContainer):addChild(element)
    elseif positionIndex == 2 then
        GetElement(self.m_root, "conSecond_WndPvpRankKing", WZUIContainer):addChild(element)
    elseif positionIndex == 3 then
        GetElement(self.m_root, "conThird_WndPvpRankKing", WZUIContainer):addChild(element)
    end
end

--@brief    清除人物选中状态
function WndPvpRankKing:clearChecked(pt)
    if self.m_tRoleAniList == nil then return end
    WZLog("WndPvpRankKing:clearChecked")
    if pt then
        for i = 1, #self.m_tRoleAniList do
            WZLog("WndPvpRankKing:clearChecked", i, type(self.m_tRoleAniList[i]))
            if self.m_tRoleAniList[i] and not self.m_tRoleAniList[i]:checkPointInCon(pt) then
                self.m_tRoleAniList[i]:setChecked(false)
            end
        end
        return
    else
        for i = 1, #self.m_tRoleAniList do
            if self.m_tRoleAniList[i] then 
                self.m_tRoleAniList[i]:setChecked(false)
            end
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function WndPvpRankKing:_adaptLanguage_pt(  )
    GetElement(self.m_root,"btnLog_WndPvpRanking",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.135,0.48051))
end
--------------------------------------语言适配End-------------------------------------------