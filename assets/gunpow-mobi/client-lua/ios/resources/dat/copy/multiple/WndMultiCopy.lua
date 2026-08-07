--WndMultiCopy.lua
--@brief	WndMultiCopy的UI模块
--@date		2015-7-28
--@author	binshao
--@note		多人副本


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMultiCopy:onEnter(element)
	self.m_root = element
    SoundManager:playBgMusic(SoundDefine.E_MUSIC_HALL)
  
    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
    ChangeChatChannel(Chat_Channel_Team_Copy_Hall)
    NotificationCenter:registerNotification(UPDATEMULTICOPYDATANOTIFICATION, self, self.updateData)
    CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物
    ProtocolProcessorSceneBossRoom:regAll()
    -- 初始化地图数据

    self:_initData()
    --黑市商人出现
    WndGangsterInn:show()
    
    local isEndTeach, teachStep = TeachGroup1:isTeachFinish(15)

    if isEndTeach ~= true then
        TeachGroup1:startGroupLevelUp(nil, nil, true, nil, {15,3,self.m_root})
    end
    AdaptLanguage(self)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMultiCopy:onExit(element)
    self.m_root:disableSchedule()
    CacheCenter:unregisterUpatePlayerInfoObserver(self)
    NotificationCenter:unregisterNotification(nil, self)
    ProtocolProcessorSceneBossRoom:unregAll()
    self:_unInit()
end

--@brief onEnter函数执行完成回调
function WndMultiCopy:onEnterTransitionDidFinish(element)
    ProtocolProcessorBossMap:send_BOSSMAPROOM_GetRoomList( self.m_nSelectedIndex )
    --ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_BossMapRecord( self.m_nSelectedIndex )
    self.m_root:enableSchedule("scheduleGetRoomList", 5)
    self:_initCopyList()
    WndChat:addChatWindowToCurScene()
	
    self:checkBackRoomState()

    pushEquipInList()
    g_bIsShowWndDressUp = true
end


-- 点击副本时的回调，包括副本的选择以及房间列表的刷新
function WndMultiCopy:onClickCopy(index)
    if self.m_nSelectedIndex == index then return end
    local data = self.m_tCopyData[index]
    if data.openState == 3 then
        MsgBoxManager:showTipBox(LocalStrings.COPY_LOCKED)
    elseif data.openState == 4 then
        local sMsg = string.format(LocalStrings.PLAYER_LEVEL_UNLOCK_COPY, data[1].map_level)
        MsgBoxManager:showTipBox(sMsg)
    else
        self:_setCopySelState(index)
    end
end

-- 快速加入按钮时的回调
function WndMultiCopy:onQuickJoin(element)
    WZLog("WndMultiCopy:onQuickJoin")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if  self:_judgeHavePlayCnt()  and self:_judgePowerEnough() then
        --发送快速游戏协议
	    ProtocolProcessorBossMap:send_BOSSMAPROOM_QuickGame( self.m_nSelectedIndex )
    end
end

--组队副本扫荡
function WndMultiCopy:onCopySweep(element)
    WZLog("WndMultiCopy:onCopySweep")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    -- 默认选择当前难度的下一个难度等级
    local copyData = self.m_tCopyData[self.m_nSelectedIndex]
    local nStar = copyData.userData.starLevel
    local star = nStar
    if nStar == 0 then
        star = 1
    end
    local nId = copyData[math.min(3, star)].id
   
    local tempMapInfo = GDatatab_team_map["id_" .. nId]
    if tempMapInfo.quickly_sweep <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.SWEEP_COPY_NOT_TIP)
        return
    end

    if star < 3 then
        MsgBoxManager:showTipBox(LocalStrings.PASS_HARD_COPY_TIP)
        return
    end

    local palyerInfo = CacheCenter:getPlayerInfo()
    if palyerInfo.level < GDatatab_button_info["id_105"].open_level then
        MsgBoxManager:showTipBox(GDatatab_button_info["id_105"].feedback_info)
        return
    end

    local param = CacheCenter:getGameParam()
    local teamRaidsNeedVipLevel  = tonumber(param.teamRaidsNeedVipLevel) --组队副本每天扫荡次数限制
    if palyerInfo.vipLevel < teamRaidsNeedVipLevel then
        MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.MULTI_SWEEP_TIP,teamRaidsNeedVipLevel), self, self._EventToVIP, MSGBOXLEVEL_NORMAL, nil)
        return
    end

    if self:_judgeHavePlayCnt() then
        local passTime = self.m_tCopyData[self.m_nSelectedIndex].userData.passTime
        local maxTime = self.m_tCopyData[self.m_nSelectedIndex][1].challenge_num
        WndTeamCopySweep:show(nId,3, passTime, maxTime)
    end
end

--@brief    前往vip充值
function WndMultiCopy:_EventToVIP( nId, nResType )
    WZLog("CellGameSingInItem:_EventToVIP")
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndVip:showWndUI(0)
    end
end

-- 点击创建房间按钮时的回调
function WndMultiCopy:onCreateRoom(element)
    WZLog("WndMultiCopy:onCreateRoom")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self:_judgeHavePlayCnt() and self:_judgePowerEnough() then
        local nStar = self.m_tCopyData[self.m_nSelectedIndex].userData.starLevel
        -- 默认选择当前难度的下一个难度等级
        local nId = self.m_tCopyData[self.m_nSelectedIndex][math.min(3, nStar+1)].id
        ProtocolProcessorBossMap:send_BOSSMAPROOM_CreateRoom(nId, "")
        WZLog("-------------create room-------------","roomId = ",nId)
    end
end

-- 查找房间
function WndMultiCopy:onFindRoom(element)
    WZLog("WndMultiCopy:onFindRoom")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    local wndFindRoom = WndFindRoom:createElement()
    if wndFindRoom ~= nil then
        WindowManager:addWindow(wndFindRoom,WndFindRoom,true,nil,nil)
        WndFindRoom:setFindBtnCallBack(self.searchRoom,self)
    end
end

function WndMultiCopy:searchRoom(roomId,password)
    WZLog("WndMultiCopy:searchRoom--------",roomId,password)
    local id = tonumber(roomId)
    if id == nil then
        MsgBoxManager:showTipBox(LocalStrings.ROOM_FIND_TIPS)
    else
        if password == nil  then
            WZLog("WndMultiCopy:searchRoom password == nil ")
            ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom(id, "-1",0,GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZF)
        else
            WZLog("WndMultiCopy:searchRoom password ~= nil ")
            if password == "" then
                ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom(id, "-1",0, GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZF)
            else
                ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom(id, password,0, GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZF)
            end
        end
    end
end

--定时刷新房间列表的函数
function WndMultiCopy:scheduleGetRoomList(element,delta)
    if WndTeamCopySweep and WndTeamCopySweep.m_root == nil and WndSweepResult and WndSweepResult.m_root == nil then
        ProtocolProcessorBossMap:send_BOSSMAPROOM_GetRoomList(self.m_nSelectedIndex)
    end
end

--@brief    更新玩家基础数据，如果打开界面时，缓存数据没有到，就等待更新
function WndMultiCopy:updatePlayerInfoData()
    WZLog("WndMultiCopy:更新玩家基础数据")
    if self.m_root == nil then
        return
    end
    --弹活力值增加动画
    self:setAddVigorAni(CacheCenter:getPlayerInfo())
end

--@brief    更新活力值，播放活力动画
function WndMultiCopy:setAddVigorAni(tData)
    if self.m_root == nil or tData == nil or g_nCurVigor == nil then
        return
    end

    --活力值
    local nExp = tData.vigor - g_nCurVigor
    if nExp ~= 0 and g_nCurVigor ~= nil and tonumber(nExp) > 1 then
        g_nCurVigor = tData.vigor
        local parentNode = GetElement(self.m_root, "conLeft_WndMultiCopy", WZUIContainer)
        createActChangeAni(parentNode, "ui/common_num/common_num_yaoqianshuzi.png", "ui/common/common_icon_huoli.png", nExp)
        return
    end
end

function WndMultiCopy:onCheck(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    local tag = element:getTag()
    local conRoom = GetElement(self.m_root, "conRoom_WndMultiCopy", WZUIContainer)
    local conInfo = GetElement(self.m_root, "conInfo_WndMultiCopy", WZUIContainer)
    local conVideo = GetElement(self.m_root, "conVideo_WndMultiCopy", WZUIContainer)
    local con = {conRoom,conInfo,conVideo }
    for i = 1, #con do
        con[i]:setVisible(i == tag+1)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 初始化副本地图
function WndMultiCopy:_initCopyList()
    self.m_tCellCopyList = {}
    local tbconCopy = GetElement(self.m_root, "tbconCopy_WndMultiCopy", WZUITableContainer)
    tbconCopy:cleanTable()

    for i=1,self.m_nTotalCopy do
        local eCellCopy, tCellCopy = CellMultiCopyList:createElement()
        eCellCopy:setTag(i-1)
        tbconCopy:setCellElement(eCellCopy)
        table.insert(self.m_tCellCopyList, tCellCopy)
        tCellCopy:setData(self.m_tCopyData[i])
        tCellCopy:setClickCallback(self,self.onClickCopy)
    end
    self:_setCopySelState(g_mulCopyIndex)
    if g_mulCopyIndex >= 3 then
        local index = g_mulCopyIndex-2
        local leftH = (1-0.375*2)*tbconCopy:getAbsContentSize().height
        local curH = (g_mulCopyIndex-3)*0.375*tbconCopy:getAbsContentSize().height
        tbconCopy:getMoveElement():setPositionY(tbconCopy:getMinPosition().y+leftH+curH-24)
    end
end

-- 设置地图的选中状态
function WndMultiCopy:_setCopySelState(index)
    self.m_nSelectedIndex = index
    g_mulCopyIndex = index
    for i = 1, #self.m_tCellCopyList do
        local tcell = self.m_tCellCopyList[i]
        local sel = i == index and true or false
        tcell:setCellSelState(sel)
    end
    self:updateCopyInfo(index)
    self:_createVideo()

    -- 获取当前地图的房间列表
    ProtocolProcessorBossMap:send_BOSSMAPROOM_GetRoomList( self.m_nSelectedIndex )
    ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_BossMapRecord( self.m_nSelectedIndex )
end

-- 更新房间列表
function WndMultiCopy:_updateRoomList()
    if not self.m_root then return end
    WZLog("---------------update room list-------------------",self.m_nSelectedIndex)

    local tbconRoom = GetElement(self.m_root, "tbconRoom_WndMultiCopy", WZUITableContainer)
    tbconRoom:cleanTable()

    -- 存在房间时去掉暂无房间的提示
    local txtDesc = GetElement(self.m_root, "txtRoomDesc_WndMultiCopy", WZUILabelTTF)
    txtDesc:setVisible(#self.m_tRoomListData <=  0)

    if #self.m_tRoomListData > 0 then
        self:createRoomOnce()
    end

    if AutoRunBattleConst.AUTO_RUN_BATTLE and #self.m_tRoomListData == 0 then
        self:autoBattleChangeRoom()
    end
end


function WndMultiCopy:createRoomOnce()
    local tbconRoom = GetElement(self.m_root, "tbconRoom_WndMultiCopy", WZUITableContainer)
    local maxCnt = #self.m_tRoomListData > 20 and 20 or #self.m_tRoomListData
    for i = 1, maxCnt do
        local roomData = self.m_tRoomListData[i]
        if roomData then
            local eCellRoom, tCellRoom = CellCopyHallList:createElement()
            eCellRoom:setTag(i-1)
            tCellRoom:setData(roomData)
            tbconRoom:setCellElement(eCellRoom)
            self:autoBattleCheckRoom(roomData)
        end
    end
end


function WndMultiCopy:joinRoomCallBack(roomId,passWord,mapId)
    WZLog("------------want to enter room----------------",roomId,mapId)
    if self:_judgeHavePlayCnt() and self:_judgePowerEnough() then
        self:createLoadingBox()
        WZLog("--------------send-------------")
        --ProtocolProcessorBossMap:send_BOSSMAPROOM_EnterRoom(roomId,mapId) -- 进入房间消息
        ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom(roomId,passWord,mapId,GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZF) -- 进入房间消息
    end
end

-- 判断是否存在挑战次数
function WndMultiCopy:_judgeHavePlayCnt()
    local passTime = self.m_tCopyData[self.m_nSelectedIndex].userData.passTime
    local maxTime = self.m_tCopyData[self.m_nSelectedIndex][1].challenge_num
    WZLog("-----------------------------------passTime-----",passTime,maxTime)
    if passTime < maxTime then return true end

    -- 判断是否存在重置次数
    local vipLimit =  self:_initVipLimitInfo()
    local cnt = self:_getMyResetCnt()
    local leftCnt = cnt - self.m_tCopyData.resetTime
    WZLog("----------------can reset cnt ----------------------",cnt,leftCnt)
    if leftCnt <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.CHALLENGE_NOT_ENOUGH)
        return false
    end

    local nextResetCnt = self.m_tCopyData.resetTime + 1
    WZLog("--------------888----------------------",nextResetCnt)

    local mapNum = self.m_tCopyData[self.m_nSelectedIndex][1].map_num
    local mapName = self.m_tCopyData[self.m_nSelectedIndex][1].map_name
    local costId,costCnt = self:_getResetCost(nextResetCnt)
    -- 重置回调
    local function resetCopyCnt()
        WZLog("-----------------want to reset copy-----------------", costId)
        if JudgeMoneyIsEnough(costId,costCnt,nil,nil,15, nil, nil, nil, nil, WndMultiCopy, WndMultiCopy.sureUseDiamondInstead) then
            WndMultiCopy:sureUseDiamondInstead()
        end
    end
    local str = string.format(LocalStrings.MUL_RESET_COPY,costCnt,mapName,leftCnt)
    MsgBoxManager:showConfirmBox(str, nil,resetCopyCnt)

    return false
end

--@brief    确认用钻石代替礼券重置次数
function WndMultiCopy:sureUseDiamondInstead()
    -- body
    local mapNum = self.m_tCopyData[self.m_nSelectedIndex][1].map_num

    ProtocolProcessorBossMap:send_BOSSMAPROOM_ResetMap(mapNum)
end

-- 判断是否存在挑战体力
function WndMultiCopy:_judgePowerEnough()
    local data = self.m_tCopyData[self.m_nSelectedIndex][1]
    local power = data.pass_consume + data.play_consume
    local powerP = CacheCenter:getPlayerInfo().vigor

    -- 体力不足
    -- local function powerNotEnough()
    --     WndBuyActivity:showBuyInterface(1056)
    -- end

    if powerP < power then
        judgeNotEnoughJump(self, self.needMoreEnergy)
    --    MsgBoxManager:showConfirmBox(LocalStrings.POWER_NOT_ENOUGH, nil,powerNotEnough)-- 金币不足
        return false
    end
    WZLog("-------------------cur power--------------",power,powerP)
    return true
end

--@brief   是否补充活力值回调
function WndMultiCopy:needMoreEnergy(id,nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(1056) 
    end
end

function WndMultiCopy:onTouchBegan()
    WndItemInfo:_onCloseClick()
end

-- 点击物品后的回调
function WndMultiCopy:onClickListItem(tItem, nTag, tData)
    WndItemInfo:_onCloseClick()
    local parentCon = self.m_root:getParent():getParent()
    local con = GetElement(parentCon,"conTips_SceneCopy",WZUIContainer)
    WndItemInfo:showInfo(tItem.m_root,con,1,tData, false, nil)
end

-- 创建一个掉落物品
function WndMultiCopy:_createCellGoodItem(nItemId)
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

-- 选取副本后更新副本的信息
function WndMultiCopy:updateCopyInfo(index)
    local info = self.m_tCopyData[index][3]
    -- 副本描述
    local txtInfo1 = GetElement(self.m_root, "txtInfo1_WndMultiCopy", WZUILabelTTF)
    txtInfo1:setText(info.map_desc)

    -- 体力消耗
    local txtCostPower = GetElement(self.m_root, "txtSubPower_WndMultiCppy", WZUILabelTTF)
    txtCostPower:setText(info.pass_consume+info.play_consume)

    -- 奖励预览
    local tbconDrop = GetElement(self.m_root, "tabReward_WndMultiCopy", WZUITableContainer)
    tbconDrop:cleanTable()
    local tDropData = info.reward_boy[1]
    if CacheCenter:getPlayerInfo().sex == 1 then tDropData = info.reward_girl[1] end
    if tDropData then
        for i = 1 ,#tDropData do
            local eItem, tItem = self:_createCellGoodItem(tDropData[i])
            eItem:setTag(i-1)
            tbconDrop:setCellElement(eItem)
        end
    end

    local conInfo = GetElement(self.m_root,"conInfo_WndMultiCopy",WZUIContainer)
    local btnSweep = GetElement(conInfo,"btnSweep_WndMultiCopy",WZUIButton)
    local txtNotSweepTip = GetElement(conInfo,"txtNotSweepTip_WndMultiCopy",WZUILabelTTF)
    local copyData = self.m_tCopyData[index]
    local nStar = copyData.userData.starLevel
    local star = nStar
    if nStar == 0 then
        star = 1
    end
    local nId = copyData[math.min(3, star)].id
    txtNotSweepTip:setVisible(false)
    btnSweep:setVisible(true)
    local tempMapInfo = GDatatab_team_map["id_" .. nId]
    if tempMapInfo.quickly_sweep <= 0 then
        btnSweep:setVisible(false)
        txtNotSweepTip:setVisible(true)
    end
end

--@brief 检查空房间
function WndMultiCopy:autoBattleCheckRoom(roomData)
    if roomData.battleStatus == 0 and roomData.roomStaus == false then
        GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change",'state_room_boss_update',roomData.roomId,roomData.mapId)
    else
        GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change",'state_room_boss_update_2')
    end
end

--@brief 转换副本
function WndMultiCopy:autoBattleChangeRoom()
    local index = self.m_nSelectedIndex + 1
    if index > self.m_nTotalCopy then
        index = 1
    end
    WZLog("WndMultiCopy:autoBattleChangeRoom",index)
    self:onClickCopy(index)
end

-- 录像列表
function WndMultiCopy:_createVideo()
    if not self.m_root then return end
    local tabVideo = GetElement(self.m_root, "tabVideo_WndMultiCopy", WZUITableContainer)
    tabVideo:cleanTable()
    for i = 1, #self.videoData do
        local cell, tcell = CellMultiVideo:createElement()
        cell:setTag(i-1)
        tabVideo:setCellElement(cell)
        tcell:setData(self.videoData[i])
    end
end

function WndMultiCopy:checkBackRoomState()
    if WndMultiCopy.g_nBackRoomState and WndMultiCopy.g_nBackRoomState ~= 0 then
        if WndMultiCopy.g_nBackRoomState == 3 then
            judgeNotEnoughJump(self, self.needMoreEnergy)
        elseif WndMultiCopy.g_nBackRoomState == 4 then
            self:_judgeHavePlayCnt()
        end
        WndMultiCopy.g_nBackRoomState = 0
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------语言适配Begin---------------------------------------------------------------
function WndMultiCopy:_adaptLanguage_en()
    local txtCreateR1 = GetElement(self.m_root, "txtCreateR1_WndMultiCopy", WZUILabelTTF)
    txtCreateR1:setScale(0.7)
    local txtCreateR2 = GetElement(self.m_root, "txtCreateR2_WndMultiCopy", WZUILabelTTF)
    txtCreateR2:setScale(0.7)

    local txtFastJion1 = GetElement(self.m_root, "txtFastJion1_WndMultiCopy", WZUILabelTTF)
    txtFastJion1:setScale(0.88)
    local txtFastJion2 = GetElement(self.m_root, "txtFastJion2_WndMultiCopy", WZUILabelTTF)
    txtFastJion2:setScale(0.88)

    local txtInfo1 = GetElement(self.m_root, "txtInfo1_WndMultiCopy", WZUILabelTTF)
    txtInfo1:setScale(0.9)
    txtInfo1:setDimensions(GlobalMethod:CCSize(420))

    local txtNotSweepTip = GetElement(self.m_root,"txtNotSweepTip_WndMultiCopy",WZUILabelTTF)
    txtNotSweepTip:setDimensions(GlobalMethod:CCSize(200,0))
end

function WndMultiCopy:_adaptLanguage_pt(  )
    local txtCreateR1 = GetElement(self.m_root, "txtCreateR1_WndMultiCopy", WZUILabelTTF)
    txtCreateR1:setScale(0.88)
    local txtCreateR2 = GetElement(self.m_root, "txtCreateR2_WndMultiCopy", WZUILabelTTF)
    txtCreateR2:setScale(0.88)

    local txtFastJion1 = GetElement(self.m_root, "txtFastJion1_WndMultiCopy", WZUILabelTTF)
    txtFastJion1:setScale(0.88)
    local txtFastJion2 = GetElement(self.m_root, "txtFastJion2_WndMultiCopy", WZUILabelTTF)
    txtFastJion2:setScale(0.88)

    local txtSearch1 = GetElement(self.m_root, "txtSearch1_WndMultiCopy", WZUILabelTTF)
    txtSearch1:setScale(0.88)
    local txtSearch2 = GetElement(self.m_root, "txtSearch2_WndMultiCopy", WZUILabelTTF)
    txtSearch2:setScale(0.88)
    
end

function WndMultiCopy:_adaptLanguage_tr(  )
    -- local txtFast = GetElement(self.m_root, "txtFastJion_WndMultiCopy", WZUILabelTTF)
    -- txtFast:setFontSize(20)

    -- local txtCreateR = GetElement(self.m_root, "txtCreateR_WndMultiCopy", WZUILabelTTF)
    -- txtCreateR:setFontSize(20)
    -- txtCreateR:setDimensions(GlobalMethod:CCSize(110,0))

    -- GetElement(self.m_root,"txtCheck1_WndMultiCopy",WZUILabelTTF):setFontSize(22)
    -- GetElement(self.m_root,"txtCheckSel1_WndMultiCopy",WZUILabelTTF):setFontSize(22)
    local txtSubPower = GetElement(self.m_root,"txtSubPower_WndMultiCppy",WZUILabelTTF)
    txtSubPower:setRelativePosition(GlobalMethod:ccp(0.45,0.661013))
    local imgPower = GetElement(self.m_root,"imgPower_WndMultiCopy",WZUIImage)
    imgPower:setRelativePosition(GlobalMethod:ccp(0.52,0.676843))

    local txtInfo1 = GetElement(self.m_root, "txtInfo1_WndMultiCopy", WZUILabelTTF)
    txtInfo1:setScale(0.9)
    txtInfo1:setDimensions(GlobalMethod:CCSize(420))
end

function WndMultiCopy:_adaptLanguage_vn(  )
    for i=1,2 do
        local txtSweep = GetElement(self.m_root,"txtSweep"..i.."_WndMultiCopy",WZUILabelTTF)
        txtSweep:setScale(0.7)
        txtSweep:setDimensions(GlobalMethod:CCSize(100,0))
    end
end

function WndMultiCopy:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtCheck1_WndMultiCopy",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtCheckSel1_WndMultiCopy",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtCheck2_WndMultiCopy",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtCheckSel2_WndMultiCopy",WZUILabelTTF):setFontSize(18)
    for i=1,2 do
        local txtCreateR = GetElement(self.m_root,"txtCreateR"..i.."_WndMultiCopy",WZUILabelTTF)
        txtCreateR:setDimensions(GlobalMethod:CCSize(130,0))
        txtCreateR:setScale(0.8)

        local txtFastJion = GetElement(self.m_root,"txtFastJion"..i.."_WndMultiCopy",WZUILabelTTF)
        txtFastJion:setDimensions(GlobalMethod:CCSize(130,0))
        txtFastJion:setScale(0.8)

        local txtSearch = GetElement(self.m_root,"txtSearch"..i.."_WndMultiCopy",WZUILabelTTF)
        txtSearch:setDimensions(GlobalMethod:CCSize(130,0))
        txtSearch:setScale(0.8)
    end
end
-----------------------------语言适配End------------------------------------------------------------