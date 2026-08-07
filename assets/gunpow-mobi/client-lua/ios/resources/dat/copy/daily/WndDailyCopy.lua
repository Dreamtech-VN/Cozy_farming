--WndDailyCopy.lua
--@brief	WndDailyCopy的UI模块
--@date		2015-6-17
--@author	binshao
--@note		日常副本


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDailyCopy:onEnter(element)
    
	self.m_root = element
    AdaptLanguage(self)
    if CacheCenter.m_tDailyCopyData == nil then
        --CacheCenter:setDailyCopyData({3001,3002,3003}, {1,0,0}, {true,true,false}, {0,2,0})
    end
    ChangeChatChannel(Chat_Channel_Daily_Copy_Hall)
    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
    self:_initMoreLanguage()
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    self:regAllDailyCopy()
    ProtocolProcessorSingleMap:send_SINGLEMAP_GetDailyMap( )
    local leftCon = GetElement(self.m_root,"conLeft_WndDailyCopy",WZUIContainer)
    WindowManagerAni:createSwitchTabAction(leftCon,0,false)
    SceneCopy:setUiAniCallBack(self,self.actionBackWnd)

    GlobalGame:getGameEventDispathcer():Dispatch("GameState_Change",'state_hall')
    
    --黑市商人出现
    WndGangsterInn:show()
    
    TeachGroup1:endTeachStep({13,1})
    SoundManager:playBgMusic(SoundDefine.E_MUSIC_HALL)
    --TeachGroup1:startGroup({13,2,WndDailyCopy.m_root})
end

--@brief onEnter函数执行完成回调
function WndDailyCopy:onEnterTransitionDidFinish(element)
    local sweepCost = CacheCenter:getGameParam().raidsDailyCost
    local ids, num = SplitItemString(sweepCost)
    self.m_tCleanoutCost = {}
    self.m_tCleanoutCost[1] = tonumber(ids[1])
    self.m_tCleanoutCost[2] = tonumber(num[1])
    WZLog("WndDailyCopy:onEnterTransitionDidFinish", Serialize(self.m_tCleanoutCost))
    local ftxtCleanoutCost = GetElement(self.m_root, "ftxtCleanoutCost_WndDailyCopy", WZUIFreeTextBox)
    if ftxtCleanoutCost then
        local sFormat = [[<I Z="0.6">%s</I><T C="255,236,193" S="22" P="1" SC="128,54,13" SS="4" SE="1">X%d%s</T>]]
        local tBasicData = GDatatab_item["id_" .. self.m_tCleanoutCost[1]]
        ftxtCleanoutCost:setShowText(string.format(sFormat, tBasicData.icon, self.m_tCleanoutCost[2], LocalStrings.WIPE_OUT))
    end
	
    pushEquipInList()
    g_bIsShowWndDressUp = true
    AdaptLanguage(self)
end

--@brief    注册bag
function WndDailyCopy:regAllDailyCopy()
    ProtocolProcessorSingleMap:regAll()
    CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物
end

--@brief    反注册
function WndDailyCopy:unregAllDailyCopy()
    CacheCenter:unregisterUpatePlayerInfoObserver(self)
end



--@brief    弹窗动画完成后的回调
function WndDailyCopy:actionCallback(element, data)

end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDailyCopy:onExit(element)
    self:unregAllDailyCopy()
	self:_unInit()
end

function WndDailyCopy:actionBackWnd()
    local leftCon = GetElement(self.m_root,"conLeft_WndDailyCopy",WZUIContainer)
    WindowManagerAni:createSwitchTabAction(leftCon,0,true,nil,SceneCopy,SceneCopy.closeEnd)
end
-- 难度选择回调，简单
function WndDailyCopy:onCheckDif_WndDailyCopy(elelment)
    WZLog("WndDailyCopy:onCheckDif_WndDailyCopy")
    SoundManager:playEffectSound(SoundDefine.E_S_KILL_RANSHAO)
    local tag = elelment:getParent():getTag()+1
    self:selectDiff(tag)
end

-- 难度选择回调，普通
function WndDailyCopy:onBtnClose()
    WZLog("WndDailyCopy:onBtnClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --self:selectDiff(2)
    --WindowManager:removeWindow(self.m_root, self, true)
    local leftCon = GetElement(self.m_root,"conLeft_WndDailyCopy",WZUIContainer)
    WindowManagerAni:createSwitchTabAction(leftCon,0,true,nil,self,self.exitClose,true)
    
end

--关闭界面回调
function WndDailyCopy:exitClose()
    SceneCopy:onClose()
end

-- 难度选择回调，困难
function WndDailyCopy:onCheckDif3_WndDailyCopy()
    --self:selectDiff(3)
end

-- 日常副本难度选择
function WndDailyCopy:selectDiff(diff)
    local index = self.curTag + 1
    local data = self.tData[index].diff[diff].localData

    local playerInfo = CacheCenter:getPlayerInfo()
    local playerLv = playerInfo.level
    local limitLv = data.open_level
    WZLog("--------------limit level-------------",diff,playerLv,limitLv)
    if playerLv < limitLv then
        MsgBoxManager:showTipBox(string.format(LocalStrings.DAILYCOPY_OPENLEVEL,limitLv))
        return
    end
    self:_setCopyModle(diff)
end

-- 战斗回调
function WndDailyCopy:onBtnFighting()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    TeachGroup1:endTeachStep({13,2})
    --背包已满
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    local index = self.curTag + 1
    local data = self.tData[index].diff[self.difficult]
    local mapId = data.mapId
    local state = data.isOpen
    if not state then
        MsgBoxManager:showTipBox(LocalStrings.DAILYCOPY_NOOPEN)
        return
    end

    local useNum = data.localData.pass_consume + data.localData.play_consume
    
    if CacheCenter:getPlayerInfo().vigor < useNum then
        judgeNotEnoughJump(self, self.needMoreEnergy)
       return 
    end
    GDailyCopy_Modle2 = self.curTag
    WZLog("WWWWWW:",self.difficult, self.curTag)
    WZLog("---------------------------map-------------------------",mapId)
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(mapId,2)
    --WndDailyCopySettlement:showWindow(tData)
    g_copyST = os.time()
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
end

--@brief   是否补充活力值回调
function WndDailyCopy:needMoreEnergy(id,nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(1056) 
    end
end

-- 当更换模式时，难度重置为1
function WndDailyCopy:updateCopyInfo(tag)
    WZLog("WndDailyCopy:updateCopyInfo = ",tag)
    self.curTag = tag
    local index = tag + 1
    local curInfo = self.tData[index]
	self.curInfo = curInfo
    -- 重新设置地图的选择状态
    for k,v in pairs(self.cellData) do
        local state = k == index and true or false
        v.tcell:SetSelectState(state)
    end

    -- 重新设置描述信息
    local localData = curInfo.diff[1].localData
    local txtDesc = GetElement(self.m_root,"txtCopyDesc_WndDailyCopy", WZUILabelTTF)
    txtDesc:setText(localData.map_desc)

    local hasNum = localData.pass_times - self.tData[index].passTime
    self:_showLeftTimes(hasNum)
    
    local txtPowe2 = GetElement(self.m_root,"txtPowerSub2_WndDailyCopy", WZUILabelTTF)
    local usePower = localData.pass_consume + localData.play_consume
    txtPowe2:setText(""..usePower)

    local modelLevel = self:_setCopyModleBg()
    self:_setCopyModle(modelLevel)
    self:_updateTabPos()
    WZLog("-------------local data--------------=",modelLevel)
end

--@brief    更新玩家基础数据，如果打开界面时，缓存数据没有到，就等待更新
function WndDailyCopy:updatePlayerInfoData()
    WZLog("WndDailyCopy:更新玩家基础数据")
    if self.m_root == nil then
        return
    end
    --弹活力值增加动画
    self:setAddVigorAni(CacheCenter:getPlayerInfo())
end

--@brief    更新活力值，播放活力动画
function WndDailyCopy:setAddVigorAni(tData)
    if self.m_root == nil or tData == nil or g_nCurVigor == nil then
        return
    end

    --活力值
    local nExp = tData.vigor - g_nCurVigor
    if nExp ~= 0 and g_nCurVigor ~= nil and tonumber(nExp) > 1 then
        g_nCurVigor = tData.vigor
        local parentNode = GetElement(self.m_root, "conLeft_WndDailyCopy", WZUIContainer)
        createActChangeAni(parentNode, "ui/common_num/common_num_yaoqianshuzi.png", "ui/common/common_icon_huoli.png", nExp)
        return
    end
end

--@brief    点击扫荡按钮回调
function WndDailyCopy:onClickCleanout(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --背包已满
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    local index = self.curTag + 1
    local data = self.tData[index].diff[self.difficult]
    if data.canSweep ~= 1 then 
        MsgBoxManager:showTipBox(LocalStrings.DAILY_TEXT2)
        return 
    end

    if not JudgeMoneyIsEnough(self.m_tCleanoutCost[1], self.m_tCleanoutCost[2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
        return 
    end

    self:sureUseDiamondInstead()
end

--@brief    确定使用钻石代替粉钻
function WndDailyCopy:sureUseDiamondInstead()
    -- body
    local index = self.curTag + 1
    local data = self.tData[index].diff[self.difficult]
    local mapId = data.mapId
    local state = data.isOpen
    if not state then
        MsgBoxManager:showTipBox(LocalStrings.DAILYCOPY_NOOPEN)
        return
    end

    local useNum = data.localData.pass_consume + data.localData.play_consume
    
    if CacheCenter:getPlayerInfo().vigor < useNum then
        judgeNotEnoughJump(self, self.needMoreEnergy)
       return 
    end
    if self.tData[index].passTime < data.localData.pass_times then
        if not self.m_bSweepFinish then
            return 
        end
        --发送协议，进行扫荡
        GDailyCopy_Modle2 = self.curTag
        WZLog("WWWWWW:",self.difficult, self.curTag)
        self.m_bSweepFinish = false 
        WZLog("---------------------------map-------------------------",mapId)
        ProtocolProcessorSingleMap:send_MAP_StartRaidsDaily(mapId, 1)
        g_copyST = os.time()
        g_bIsShowWndDressUp = false
        g_tTempItemForLaterShow = {}
    else
        --次数不足
        local needVip = 0
        local cost = {{70, 100}}
        local vipLevel = tonumber(CacheCenter:getPlayerInfo().vipLevel)
        for i=820,860 do
            local t = GDatatab_vip_restriction["id_"..i]
            if t ~= nil and t.type == 21 then
                needVip = t.vip_level
                break
            end
        end

        if CacheCenter:getPlayerInfo().vipLevel < needVip then
            local sMsg = string.format(LocalStrings.DAILY_TEXT1, needVip)
            MsgBoxManager:showConfirmCancelBox(sMsg, self, self.needMoreDiamondCallBack, MSGBOXLEVEL_HIGH,nil)
            return
        end
        self.m_nResetNum = self.curInfo.resetTimes

        --判断剩余次数
        if self.m_nResetNum <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.CHALLEGE_OVER)
            return
        end
        
        for i=820,860 do
            local t = GDatatab_vip_restriction["id_"..i]
            local count = self.curInfo.count + 1
            if t ~= nil and t.type == 21 and count == t.count then
                cost = t.cost
                break
            end
        end
        

        --弹出提示框
        local msg1 = string.format(LocalStrings.DAILYRESET2, tostring(cost[1][2])..GDatatab_item["id_"..cost[1][1]].name)
        MsgBoxManager:showConfirmCancelBox(msg1, self, self.resetConfirm, MSGBOXLEVEL_HIGH,nil)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-- 创建日常副本的tab
function WndDailyCopy:_createCopyTable()
    WZLog("WndDailyCopy:_createCopyTable:", #self.tData)
    local tabC = GetElement(self.m_root,"tabCopy_WndDailyCopy", WZUITableContainer)
	tabC:cleanTable()
    for i = 1, #self.tData do
        local cell,tcell = CellDailyCopy:createElement()
        cell:setTag(i-1)
        tabC:setCellElement(cell)
        --cell:setScale(0.9)
        tcell:setData(self.tData[i] )
        tcell:setCallback(self,self.updateCopyInfo)
        self:_addCell(i,cell,tcell)
    end

    -- 更新当前选择的界面
    local openIndex = self:_getOpenCopyIndex()
    WZLog("wwww:",openIndex)
    self.curTag = openIndex
    
    local tableCopyType = GetElement(self.m_root,"tableCopyType_WndDailyCopy",WZUITableContainer)
	tableCopyType:cleanTable()
    for i=1,6 do
        local cellDiffCopy = CreateElement("CellDiffCopy_WndDailyCopy")
        cellDiffCopy = WZUIContainer:luaTo(cellDiffCopy)
        cellDiffCopy:setTag(i-1)
        cellDiffCopy:setVisible(true)
        local armCopyLevel1 = GetElement(cellDiffCopy,"armCopyLevel1_WndDailyCopy",WZUISpine)
        local imgCopyLevelBg1 = GetElement(cellDiffCopy,"imgCopyLevelBg1_WndDailyCopy",WZUIImage)
        local imgCopyDiffName = GetElement(cellDiffCopy,"imgCopyDiffName_WndDailyCopy",WZUIImage)
        if i == 1 then
            armCopyLevel1:setAnimationName("easy")
            imgCopyLevelBg1:setFile("ui/dailyCopy/common_icon_jiandan.png")
            imgCopyDiffName:setFile("ui/dailyCopy/common_icon_jiandan3.png")
        elseif i == 2 then
            armCopyLevel1:setAnimationName("normal")
            imgCopyLevelBg1:setFile("ui/dailyCopy/common_icon_pt.png")
            imgCopyDiffName:setFile("ui/dailyCopy/common_icon_pt3.png")
        elseif i == 3 then
            armCopyLevel1:setAnimationName("hard")
            imgCopyLevelBg1:setFile("ui/dailyCopy/common_icon_kunan.png")
            imgCopyDiffName:setFile("ui/dailyCopy/common_icon_kunnan3.png")
        elseif i == 4 then
            armCopyLevel1:setAnimationName("jingying")
            imgCopyLevelBg1:setFile("ui/dailyCopy/common_icon_jingying_02.png")
            imgCopyDiffName:setFile("ui/dailyCopy/common_icon_jingyin4.png")
        elseif i == 5 then
            armCopyLevel1:setAnimationName("emeng")
            imgCopyLevelBg1:setFile("ui/dailyCopy/common_icon_emeng.png")
            imgCopyDiffName:setFile("ui/dailyCopy/common_icon_emeng5.png")
        elseif i == 6 then
            armCopyLevel1:setAnimationName("diyu")
            imgCopyLevelBg1:setFile("ui/dailyCopy/common_icon_diyu.png")
            imgCopyDiffName:setFile("ui/dailyCopy/common_icon_diyu6.png")
        end
        tableCopyType:setCellElement(cellDiffCopy)
    end
    if openIndex then self:updateCopyInfo(openIndex) end
end

-- 初始化多语言版本
function WndDailyCopy:_initMoreLanguage()
    -- local txtTitle = GetElement(self.m_root,"txtTitle_WndDailyCopy", WZUILabelTTF)
    -- txtTitle:setText("日常副本")

    -- local txtBtn = GetElement(self.m_root,"txtBtn_WndDailyCopy", WZUILabelTTF)
    -- txtBtn:setText("挑战")
    --self:_setCopyModle(1)
end

-- 设置副本难度选择的显示
function WndDailyCopy:_setCopyModle(tag)
    self.difficult = tag
    GDailyCopy_Modle[self.curTag+1] = self.difficult
    local tableCopyType = GetElement(self.m_root,"tableCopyType_WndDailyCopy",WZUITableContainer)
    for i = 1, 6 do
        local cellElement = WZUIContainer:luaTo(tableCopyType:getCellElement(i-1))
        local ani =  GetElement(cellElement,"armCopyLevel1_WndDailyCopy", WZUISpine)
        ani:setVisible(i == tag)
        local num = 2*i-1
        local num2 = 2*i
        if i == tag then
            GetElement(self.m_root,"imgCopyzidi1_WndDailyCopy", WZUIImage):setFile("ui/common/common_icon_zidi_sel.png")
            GetElement(self.m_root,"imgCopyzidi2_WndDailyCopy", WZUIImage):setFile("ui/common/common_icon_zidi_sel.png")
        else
            GetElement(self.m_root,"imgCopyzidi1_WndDailyCopy", WZUIImage):setFile("ui/common/common_icon_zidi.png")
            GetElement(self.m_root,"imgCopyzidi2_WndDailyCopy", WZUIImage):setFile("ui/common/common_icon_zidi.png")
        end
    end
end


function WndDailyCopy:_updateTabPos()
    WZLog("WndDailyCopy:_updateTabPos")
    local tableCopyType = GetElement(self.m_root,"tableCopyType_WndDailyCopy",WZUITableContainer)
    local moveElement = tableCopyType:getMoveElement()
    if self.difficult > 3 then    
        local minPos = tableCopyType:getMinPosition()
        moveElement:setPositionX(minPos.x)
    else
        local maxPos = tableCopyType:getMaxPosition()
        moveElement:setPositionX(maxPos.x)
    end
end

-- 得出当前最大挑战次数，不能挑战的变灰色
--return 当前可挑战的等级
function WndDailyCopy:_setCopyModleBg()
    local maxLevel = 1
    local index = self.curTag + 1
    local playerInfo = CacheCenter:getPlayerInfo()
    local playerLv = playerInfo.level
    local tableCopyType = GetElement(self.m_root,"tableCopyType_WndDailyCopy",WZUITableContainer)
    for i = 1, 6 do
        local data = self.tData[index].diff[i].localData
        local limitLv = data.open_level
        local cellElement = WZUIContainer:luaTo(tableCopyType:getCellElement(i-1))
        if playerLv < limitLv then
            GetElement(cellElement,"imgCopyLevelBg1_WndDailyCopy", WZUIImage):setGrayRender(true)
        else
            maxLevel = i
            GetElement(cellElement,"imgCopyLevelBg1_WndDailyCopy", WZUIImage):setGrayRender(false)
        end  
    end
    
    if GDailyCopy_Modle[self.curTag+1] ~= 0 then
        return GDailyCopy_Modle[self.curTag+1]
    end
    return maxLevel
end

--@brief    显示剩余挑战次数
function WndDailyCopy:_showLeftTimes(nNum)
    -- body
    local txtNum2 = GetElement(self.m_root,"txtFightNum2_WndDailyCopy", WZUILabelTTF)
    if txtNum2 then
        txtNum2:setText(tostring(nNum))
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndDailyCopy:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtCopyDesc_WndDailyCopy",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(450,0))
    local ftxtCleanoutCost = GetElement(self.m_root, "ftxtCleanoutCost_WndDailyCopy", WZUIFreeTextBox)
    ftxtCleanoutCost:setScale(0.8)
    ftxtCleanoutCost:setMaxWidth(300)
end

function WndDailyCopy:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtCopyDesc_WndDailyCopy",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(480,0))
    local ftxtCleanoutCost = GetElement(self.m_root, "ftxtCleanoutCost_WndDailyCopy", WZUIFreeTextBox)
    ftxtCleanoutCost:setScale(0.8)
    ftxtCleanoutCost:setMaxWidth(300)
end
function WndDailyCopy:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtCopyDesc_WndDailyCopy",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(460,0))
    
end


function WndDailyCopy:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtCopyDesc_WndDailyCopy",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(480,0))
    GetElement(self.m_root,"txtResert1_WndDailyCopy",WZUILabelTTF):setScale(1.2)
    GetElement(self.m_root,"txtResert2_WndDailyCopy",WZUILabelTTF):setScale(1.2)
    local ftxtCleanoutCost = GetElement(self.m_root, "ftxtCleanoutCost_WndDailyCopy", WZUIFreeTextBox)
    ftxtCleanoutCost:setScale(0.8)
    ftxtCleanoutCost:setMaxWidth(300)
end

function WndDailyCopy:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtCopyDesc_WndDailyCopy",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(450,0))
    local ftxtCleanoutCost = GetElement(self.m_root, "ftxtCleanoutCost_WndDailyCopy", WZUIFreeTextBox)
    ftxtCleanoutCost:setScale(0.75)
    ftxtCleanoutCost:setMaxWidth(300)
end

function WndDailyCopy:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtCopyDesc_WndDailyCopy",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(450,0))
    local ftxtCleanoutCost = GetElement(self.m_root, "ftxtCleanoutCost_WndDailyCopy", WZUIFreeTextBox)
    ftxtCleanoutCost:setScale(0.75)
    ftxtCleanoutCost:setMaxWidth(300)
end
-------------------------------------语言适配End--------------------------------------------
