--WndCommunityHall.lua
--@brief	WndCommunityHall的UI模块
--@date		2015-6-11
--@author	binshao 2015-6-11
--@note		游戏大厅模块


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityHall:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    --ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWar( )
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityHall:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
end

--@brief	打开加载动画
function WndCommunityHall:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end

--@brief	窗口动画完成回调
function WndCommunityHall:actionCallback(elem,data)
    ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWar( )
end

-- 动画完成回调
function WndCommunityHall:onActionCallBack()
    WindowManager:removeWindow(self.m_root, WndCommunityHall, true)
end

--@brief	关闭整个窗口时被调用的函数
function WndCommunityHall:onClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManagerAni:createCloseAction(self.m_root,"onActionCallBack",self)
end

-- 快速开始游戏
function WndCommunityHall:onFirstEnter(element)
	WZLog("WndCommunityHall:onFirstEnter")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.baseInfo.timeLeft < 0 then
        MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_FIGHT_END)
        return
    end
    ProtocolProcessorSceneCommunity:send_GUILD_QuickGame( )
end

-- 创建房间
function WndCommunityHall:OnCreateRoom()
	WZLog("WndCommunityHall:createRoom")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.baseInfo.timeLeft < 0 then
        MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_FIGHT_END)
        return
    end
    ProtocolProcessorSceneCommunity:send_GUILD_CreateWarRoom( )
end

-- 排行榜
function WndCommunityHall:OnCheckRank( element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local wndCommunityRank = WndCommunityRank:createElement()
    WindowManager:addWindow(wndCommunityRank,WndCommunityRank)

	self.m_root:setVisible(false)
end

-- 加入房间
function WndCommunityHall:onRoomListClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndCommunityHall:onRoomListClick")
    if element.m_tData.battleStatus ~= 0 then --战斗中
        MsgBoxManager:showTipBox(LocalStrings.ROOM_BATTLEING)
    elseif element.m_tData.curNum == element.m_tData.maxNum then --房间已满
        MsgBoxManager:showTipBox(LocalStrings.ROOM_FULL)
    end
    --ProtocolProcessorSceneHall:send_ROOM_SelectRoom(element.m_tData.roomId, "-1")
end

function WndCommunityHall:onRuleClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.COMMUNITYINFO65)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 每过一段时间更新一下房间列表
function WndCommunityHall:_scheduleRoomList(element, delta)
    WZLog("WndCommunityHall:_scheduleRoomList")
    self.m_bUsePrePosition = true
    ProtocolProcessorSceneCommunity:send_GUILD_GetGuildWar( )
end

function WndCommunityHall:_update()
    self:_initMyCommunityBaseInfo()
    self:_createRoomList()
    self.m_root:enableSchedule("_scheduleRoomList",5)
end

-- 初始化玩家的公会基本信息
function WndCommunityHall:_initMyCommunityBaseInfo()
    local info = self.baseInfo
    local winP = info.warCount == 0 and 0 or math.floor(info.winCount/info.warCount*100).."%"
    local ftb1 = GetElement(self.m_root,"ftbHistory1_WndCommunityHall",WZUIFreeTextBox)
    ftb1:setShowText(string.format(LocalStrings.COMMUNITY_HISTORY_FIGHT,info.warCount,info.winCount,winP))

    local ftb2 = GetElement(self.m_root,"ftbHistory2_WndCommunityHall",WZUIFreeTextBox)
    ftb2:setShowText(string.format(LocalStrings.COMMUNITY_HISTORY_FIRST,info.first))

    local ftb3 = GetElement(self.m_root,"ftbHistory3_WndCommunityHall",WZUIFreeTextBox)
    ftb3:setShowText(string.format(LocalStrings.COMMUNITY_HISTORY_SECOND,info.second))

    local ftb4 = GetElement(self.m_root,"ftbHistory4_WndCommunityHall",WZUIFreeTextBox)
    ftb4:setShowText(string.format(LocalStrings.COMMUNITY_HISTORY_THIRD,info.third))

    local txt5 = GetElement(self.m_root,"txtName_WndCommunityHall",WZUILabelTTF)
    txt5:setText(info.name2)

    local winP2 = info.warCount2 == 0 and 0 or math.floor(info.winCount2/info.warCount2*100).."%"
    local ftb6 = GetElement(self.m_root,"ftbHistory6_WndCommunityHall",WZUIFreeTextBox)
    ftb6:setShowText(string.format(LocalStrings.COMMUNITY_CUR_DATA,info.warCount2,info.winCount2,winP2))

    local ftb7 = GetElement(self.m_root,"ftbHistory7_WndCommunityHall",WZUIFreeTextBox)
    ftb7:setShowText(string.format(LocalStrings.COMMUNITY_CUR_SCORE,info.score2))

    local ftb8 = GetElement(self.m_root,"ftbHistory8_WndCommunityHall",WZUIFreeTextBox)
    ftb8:setShowText(string.format(LocalStrings.COMMUNITY_CUR_RANK,info.rank2))

    -- 倒计时注册一次就行
    WZLog("---------------------self.bGetTime---------------",self.bGetTime)
    if not self.bGetTime and info.timeLeft > 0 then
        local num,str = self:_descTimeDown(info.timeLeft)
        local ftb9 = GetElement(self.m_root,"ftbHistory9_WndCommunityHall",WZUIFreeTextBox)
        ftb9:setShowText(string.format(LocalStrings.COMMUNITY_CUR_RESULT,num,str))
        ftb9:enableSchedule("_scheduleEndTImeDown",1)
        self.bGetTime = true
    end

    if info.timeLeft < 0 then
        for i = 1, 4 do
            local img = GetElement(self.m_root,"imgBtn"..i.."_WndCommunityHall",WZUIImage)
            img:setGrayRender(true)
        end
    end
end

-- 创建房间列表
function WndCommunityHall:_createRoomList()
    WZLog("---------create Room List----------------",#self.roomInfo)
    local tab = GetElement(self.m_root,"tabRoomList_WndCommunityHall",WZUITableContainer)
    tab:cleanTable()

    local stateR = #self.roomInfo == 0 and true or false
    local txt5 = GetElement(self.m_root,"txtRoomDesc_WndCommunityHall",WZUILabelTTF)
    txt5:setVisible(stateR)

    for i = 1, #self.roomInfo do
        local cell,tcell = CellRoomItem:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setData(self.roomInfo[i])
        tcell:setClickCallback(self.onRoomListClick,WndCommunityHall)
    end
end

-- 公会战关闭倒计时
function WndCommunityHall:_scheduleEndTImeDown(element,t)
    WZLog("----------------820------------------",self.baseInfo.timeLeft)
    self.baseInfo.timeLeft = self.baseInfo.timeLeft - 1
    local time = self.baseInfo.timeLeft

    -- 小于1个小时开始倒计时
    if time < 60*60 and time >= 0 then
        local num,str = self:_descTimeDown(time)
        local ftb9 = GetElement(self.m_root,"ftbHistory9_WndCommunityHall",WZUIFreeTextBox)
        ftb9:setShowText(string.format(LocalStrings.COMMUNITY_CUR_RESULT,num,str))
    elseif  time < 0 then
        local ftb9 = GetElement(self.m_root,"ftbHistory9_WndCommunityHall",WZUIFreeTextBox)
        ftb9:disableSchedule()
        ftb9:setVisible(false)
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-----------------------------------------
function WndCommunityHall:_adaptLanguage_es(  )
    local txtBtn1 = GetElement(self.m_root,"txtBtn1_WndCommunityHall",WZUILabelTTF)
    txtBtn1:setDimensions(GlobalMethod:CCSize(130,0))
    txtBtn1:setScale(0.9)
    local txtBtn2 = GetElement(self.m_root,"txtBtn2_WndCommunityHall",WZUILabelTTF)
    txtBtn2:setDimensions(GlobalMethod:CCSize(130,0))
    txtBtn2:setScale(0.9)
end
-------------------------------------语言适配End-------------------------------------------