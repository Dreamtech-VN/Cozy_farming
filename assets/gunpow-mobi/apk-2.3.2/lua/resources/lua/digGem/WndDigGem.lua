--WndDigGem.lua
--@brief	WndDigGem的UI模块
--@date		2017/03/13
--@author	Tianxiang_Xu
--@note		挖宝系统界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDigGem:onEnter(element)
	self.m_root = element
    ProtocolProcessorDigGem:regAll()
    ProtocolProcessorDigGem:send_MINING_GetHireFriendList( )
    ChangeChatChannel(Chat_Channel_DigGem)
    self:_AdaptationIphoneX()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDigGem:onExit(element)
	--因主城有用到故不注销ProtocolProcessorDigGem协议
    -- ProtocolProcessorDigGem:unregAll()
	self:_unInit()
end

--@brief    界面加载完成回调
function WndDigGem:onEnterTransitionDidFinish(element)
    -- body

    --格子数
    local miningConfig = json.decode(CacheCenter:getGameParam().miningConfig)
    self.m_nMaxNum = (miningConfig and miningConfig.gridLim) or 20


    --添加顶部货币栏
    self:_addTop()
    self.m_nTabIndex = GetElement(self.m_root, "checkBoxGroup_WndDigGem", WZUICheckBoxGroup):getCheckIndex()
    self:_createBagGrid()
    self:showRedDot(GlobalGame.g_tRedPointList.transaction)
    local particleGetGem = GetElement(self.m_root, "particleGetGem_WndDigGem", WZUIParticle)
    local conTarget = GetElement(self.m_root, "conTarget_WndDigGem", WZUIContainer)
    if particleGetGem then 
        self.m_tOriginPosition = particleGetGem:getRelativePosition()
    end
    if conTarget then
        self.m_tTargetPosition = conTarget:getRelativePosition()
        WZLog("WndDigGem:onEnterTransitionDidFinish", self.m_tTargetPosition.x, self.m_tTargetPosition.y)
    end
    self:showInteractivePrice()
    self:sendGetDem(1)


    AdaptLanguage(self)
end

--@brief    显示互动价格
function WndDigGem:showInteractivePrice()
    local strFormat = [[<I Z="0.35">%s</I><T C="255,236,193" S="18" P="0" SC="132,66,29" SE="1" SS="4">%s</T>]]
    local miningInteraction = json.decode(CacheCenter:getGameParam().miningInteraction)
    local kiss = SplitStringWithSeparator(string.sub(miningInteraction.kiss,2,-2),",")
    local bread = SplitStringWithSeparator(string.sub(miningInteraction.bread,2,-2),",")
    local whip = SplitStringWithSeparator(string.sub(miningInteraction.whip,2,-2),",")
    local sKissIcon = GDatatab_item["id_"..kiss[1]].icon
    local sBreadIcon = GDatatab_item["id_"..bread[1]].icon
    local sWhipIcon = GDatatab_item["id_"..whip[1]].icon

    local ftbOperate1 = GetElement(self.m_root,"ftbOperate1_WndDigGem",WZUIFreeTextBox)
    local ftbOperate2 = GetElement(self.m_root,"ftbOperate2_WndDigGem",WZUIFreeTextBox)
    local ftbOperate3 = GetElement(self.m_root,"ftbOperate3_WndDigGem",WZUIFreeTextBox)
    ftbOperate1:setShowText(string.format(strFormat,sKissIcon,kiss[2]))
    ftbOperate2:setShowText(string.format(strFormat,sBreadIcon,bread[2]))
    ftbOperate3:setShowText(string.format(strFormat,sWhipIcon,whip[2]))
end

--@brief    触摸开始回调
function WndDigGem:onTouchBegin(element, pt)
    -- body
    if self.m_topCellLua then
        self.m_topCellLua.goldCellInfo.tcell:removeCreateTips()
    end
    self.m_tClickGemInfo = nil 
end

--@brief    点击退出按钮回调
function WndDigGem:onClickClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    
    WindowManager:removeWindow(self.m_root, self, true)
end


--@brief    Chat按钮点击后的Lua回调
function WndDigGem:onChat(sender)
    if TeachGroup1.ISBATTLE == true then
        return
    end
    if WndDigGem.m_root ~= nil then
        if WndChat.m_root then
            WindowManager:removeWindow(WndChat.m_root, WndChat, true)
            WndChat.m_root:setVisible(false)
        end
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCurrentChat:wndCurChatVisible(false)
    WndChat:showChatWindowForFightingByOrder(nil)
end

--brief     点击宝物背包标签回调
function WndDigGem:onClickBag(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_nTabIndex == 0 then return end 

    self.m_nTabIndex = 0
    self:_updateRightContent()
end

--brief     点击挖宝日志标签回调
function WndDigGem:onClickLog(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_nTabIndex == 1 then return end 
    self.m_nTabIndex = 1
    if self.m_tLogList == nil then
        self:_createLoading()
        ProtocolProcessorDigGem:send_MINING_MiningLog( )
        return 
    end
    self:_updateRightContent()
end

--brief     点击遗迹之光标签回调
function WndDigGem:onClickRemains(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_nTabIndex == 2 then return end 
    self.m_nTabIndex = 2

    self:_updateRightContent()
end

--brief     点击雇佣标签回调
function WndDigGem:onClickHire(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_nTabIndex == 3 then return end 

    self.m_nTabIndex = 3
    self:_updateRightContent()
end

--brief     点击图鉴按钮回调
function WndDigGem:onLibraryClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndGemLibrary:showInterface()
end

--brief     点击鉴定按钮回调
function WndDigGem:onAppraiseClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    WndGemAppraise:showInterface()
end

--brief     点击交易按钮回调
function WndDigGem:onExchangeClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    WndTransaction:show()
end

--brief     点击回收按钮回调
function WndDigGem:onRecoverClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    WndTransaction:showTab(3)
end

--brief     点击遗迹之光任务按钮回调
function WndDigGem:onRemainsTaskClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tData = {}
    tData.complete = self.m_nComplete
    WndTips:show(element,WndDigGem.m_root,61,tData,GlobalMethod:ccp(200,50))
end

--@brief    点击开始挖宝按钮回调
function WndDigGem:onClickStart(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_bIsStart then
        --停止挖宝，发送协议
        self:_createLoading()
        self.m_nOperateType = 2 
        ProtocolProcessorDigGem:send_MINING_StopMining( )
    else
        --开始挖宝，弹出工具界面，选择工具
        if #self.m_tBagList >= self.m_nMaxNum then
            MsgBoxManager:showTipBox(LocalStrings.DIGGEM_TEXT12)
            return 
        end
        WndGemTool:showInterface()
    end
end

--@brief    点击宝石回调
function WndDigGem:onItemClick(tItem, nTag, tData)
    -- body
    self.m_tClickGemInfo = {}
    self.m_tClickGemInfo.tag = nTag 
    self.m_tClickGemInfo.tData = CopyTable(tData) 

    local conOutside = GetElement(self.m_root, "conOutside_WndDigGem", WZUIContainer)
    if self.m_tClickGemInfo.tData.basicInfo.id >= 2155 and self.m_tClickGemInfo.tData.basicInfo.id <= 2160 then
        WndItemInfo:showInfo(tItem.m_root,conOutside,1,tData, false, ccp(0,-60))
    else
        WndItemInfo:showInfo(tItem.m_root,conOutside,1,tData, false, ccp(0,0))
    end
end

--@brief    点击工具使用按钮调用
function WndDigGem:onClickUseTool(tData)
    -- body
    self.m_tUseToolData = tData 
    --发送使用工具，开始挖矿协议
    self:_createLoading()
    self.m_nOperateType = 3
    ProtocolProcessorDigGem:send_MINING_StartMining(tData.id)
end

--@brief    购买挖宝工具
function WndDigGem:onClickBuyTool(tData)
    --body
    if tData.buy_price[1][1] == 2 then
        if CacheCenter:getMoneyList().gold < tData.buy_price[1][2] then
            JudgeMoneyIsEnough(2, tData.buy_price[1][2],nil,nil,194)
            return 
        end
    elseif tData.buy_price[1][1] == 58 then
        local bCanBuy = JudgeMoneyIsEnough(58, tData.buy_price[1][2],nil,nil,194)
        if not bCanBuy then
            return 
        end
    end
    self:_createLoading()
    self.m_nOperateType = 4
    ProtocolProcessorDigGem:send_MINING_BuyTool(tData.id)
end

--@brief    点击确认购买回调
function WndDigGem:_sureToBuy(num)
    -- body
    local nMaxCount, tCurIndex = self:getBuyData(13)
    local nLeftTimes = nMaxCount - self.m_nBuyGemCoinTimes
    WZLog("WndDigGem:_sureToBuy", nMaxCount, self.m_nBuyGemCoinTimes)
    if nLeftTimes == 0 then
        self:_showTipsAccordCase()
    else
        local bDiamondEnough = JudgeMoneyIsEnough(1, tCurIndex.cost[1][2],nil,nil,194)
        if bDiamondEnough then
            ProtocolProcessorDigGem:send_MINING_MiningBuy(num)
        end
    end
end

--@brief    发送挖宝申请
--@param    nType:
function WndDigGem:sendGetDem(nType)
    --body
    WZLog("WndDigGem:sendGetDem 0000000000")
    if self.m_root == nil then return end 
    self:_createLoading()
    self.m_nOperateType = nType
    ProtocolProcessorDigGem:send_MINING_GetMining()
end

--@brief    鉴定或出售，下架后刷新挖宝背包
function WndDigGem:updateGemBag(item, num)
    -- body
    if self.m_root == nil then return end 

    self:resetBagData(item, num)
    self:_updateRightContent()
end

--@brief    交易行红点
function WndDigGem:showRedDot(bVisible)
    -- body
    if self.m_root == nil then return end 
    
    local imgRedDot = GetElement(self.m_root, "imgRedDot_WndDigGem", WZUIImage)
    if imgRedDot then
        imgRedDot:setVisible(bVisible)
    end
end

--@brief    点击规则按钮回调
--@brief    点击帮助按钮回调
function WndDigGem:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.DIGGEM_TEXT42)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------挖宝人物Start----------------------------------------

--@brief    创建人物
function WndDigGem:createRole()
    WZLog("WndDigGem:createRole")
    if self.m_tRoleDataList == nil then return end
    local playerInfo = CacheCenter:getPlayerInfo()
    local sex = playerInfo.sex
    local con = GetElement(self.m_root,"conRoleMove",WZUIContainer)
    con:removeAllChildrenWithCleanup(true)

    self.m_tRoleList = {}
    local tPlayerPos = {ccp(0.33,0.35),ccp(0.44,0.35),ccp(0.55,0.35)}
    for i=1,#self.m_tRoleDataList do
        local tData = self.m_tRoleDataList[i]
        local uiNode = WZUIContainer:create()
        uiNode:setTouchEnable(true)
        uiNode:setAbsContentSize(CCSize(160,160))
        uiNode:setUseAbsSize(true)
        uiNode:setRelativePosition(tPlayerPos[i])
        uiNode:setAnchorPoint(ccp(0.5,0.5))
        con:addChild(uiNode,1,i)
        --角色形象
        local nHeadId = tData.playerHeadId
        local nFaceId = tData.playerFaceId
        local nBodyId = tData.playerBodyId
        local nHeadcolour = tData.playerHeadcolour
        local nBodycolour = tData.playerBodycolour
        if tData.playerBodyId <= 0 then
            if tData.playerSex == 0 then
                nHeadId = 4903
                nFaceId = 4902
                nBodyId = 4901
            else
                nHeadId = 4906
                nFaceId = 4905
                nBodyId = 4904
            end
            nHeadcolour = 0
            nBodycolour = 0
        end
        local conPlayer = YDPlayerAnimation:createAnimation(tData.playerSex == 0, false)
        conPlayer:setHead(GDatatab_item["id_"..nHeadId].animation_index_code, nHeadcolour or 0)
        conPlayer:setFace(GDatatab_item["id_"..nFaceId].animation_index_code)
        conPlayer:setBody(GDatatab_item["id_"..nBodyId].animation_index_code)
        conPlayer:setBodyRanSe(nBodycolour or 0)
        conPlayer:play("standby1",true)
        local ani = conPlayer:getAnimNode()
        ani:setTouchEnable(false)
        ani:setScale(0.6)
        ani:setRelativePosition(ccp(0.5,0.5))
        ani:setFlipX(true)
        uiNode:addChild(ani,1,i)
        --宠物
        local petMessage = tData.playerPet
        if petMessage ~= nil and petMessage ~= "" then
            local con1 = WZUIContainer:create()
            uiNode:addChild(con1,10)
            con1:setTag(1)
            local ani, ani1 = CreatePetAni(con1, nil, petMessage, tData.advancedLevel)
            ani:getAnimNode():setTouchEnable(false)
            ani:getAnimNode():setScale(0.4)
            ani:getAnimNode():setRelativePosition(ccp(0.8,1.1))
            ani:setFlipX(true)
        end
        --镐子动画
        local spine = WZUISpine:create()
        local aniName = "ui_dijing"
        spine:setTouchEnable(false)
        spine:setFileJson("ui/digGem/"..aniName..".json")
        spine:setFileAtlas("ui/digGem/"..aniName..".atlas")
        spine:setAnimationName(aniName)
        spine:setUseOriginSize(true)
        spine:setRelativePosition(ccp(0.18,0.65))
        spine:play(aniName,true)
        spine:setScale(0.7)
        uiNode:addChild(spine,10)
        --名字
        local label_name = WZUILabelTTF:create()
        label_name:setText(tData.playerName)
        label_name:setColor(ccc3(255,255,255))
        label_name:setFontSize(20)
        label_name:setAnchorPoint(ccp(0.5,0.8))
        label_name:setEnableStroke(true)
        label_name:setStrokeColor(ccc3(145,77,44))
        label_name:setStrokeSize(4)
        label_name:setRelativePosition(ccp(0.5,1.3))
        uiNode:addChild(label_name, 12, 700)
        --心情
        local conMood = WZUIContainer:create()
        conMood:setAbsContentSize(CCSize(100,100))
        conMood:setUseAbsSize(true)
        conMood:setRelativePosition(ccp(0.5,1.4))
        conMood:setAnchorPoint(ccp(0.5,0.5))
        uiNode:addChild(conMood,10)
        self:setMood(conMood, tData.hireMoodValue)

        --点击按钮
        local btn1, b = self:createBtn()
        if i <= self.m_nHireNum then
            b:setTag(tData.playerId)
        end
        uiNode:addChild(btn1,2)

        self.m_tRoleList[i] = {}
        self.m_tRoleList[i].index = i
        self.m_tRoleList[i].conPlayer = conPlayer
        self.m_tRoleList[i].uiNode = uiNode
        self.m_tRoleList[i].playerId = tData.playerId

        --偷矿人特殊处理
        if i > self.m_nHireNum then
            uiNode:setRelativePosition(tPlayerPos[3])
            conMood:setVisible(false)
            btn1:setVisible(false)
            --"偷矿中..."文本
            local label_name = WZUILabelTTF:create()
            label_name:setText(LocalStrings.DIGGEM_TEXT50)
            label_name:setColor(ccc3(255,255,255))
            label_name:setFontSize(20)
            label_name:setAnchorPoint(ccp(0.5,0.8))
            label_name:setEnableStroke(true)
            label_name:setStrokeColor(ccc3(145,77,44))
            label_name:setStrokeSize(4)
            label_name:setRelativePosition(ccp(0.5,1.5))
            uiNode:addChild(label_name, 12)
            --驱赶按钮
            local conQG = WZUIContainer:create()
            conQG:setUseAbsSize(true)
            conQG:setAbsContentSize(GlobalMethod:CCSize(124,54))
            conQG:setRelativePosition(GlobalMethod:ccp(0.5,0.4))
            conQG:setScale(0.7)
            uiNode:addChild(conQG, 12, 1100)
            local imgIcon = WZUIImage:create()
            imgIcon:setFile("ui/common/common_btn_05.png")
            imgIcon:setUseOriginSize(true)
            local imgIconSel = WZUIImage:create()
            imgIconSel:setFile("ui/common/common_btn_05.png")
            imgIconSel:setUseOriginSize(true)
            local btn = WZUIButton:create()
            btn:setNormalElement(imgIcon)
            btn:setSelectElement(imgIconSel)
            btn:setLuaActionName("Normal")
            btn:setLuaDoneFunctionName("onClickChasing")
            conQG:addChild(btn)
            local txtBtn = WZUILabelTTF:create()
            txtBtn:setText(LocalStrings.DIGGEM_TEXT51)
            txtBtn:setColor(ccc3(255,250,236))
            txtBtn:setFontSize(24)
            txtBtn:setEnableStroke(true)
            txtBtn:setStrokeColor(ccc3(163,74,20))
            txtBtn:setStrokeSize(4)
            btn:addChild(txtBtn)
        end
    end
end

-- 显示互动按钮
function WndDigGem:showOperateBtn()
    local bIsExistPlayer = false
    local uiNode
    for i=1,self.m_nHireNum do
        if self.m_tRoleList[i].playerId == self.operateId then
            bIsExistPlayer = true
            uiNode = self.m_tRoleList[i].uiNode
        end
    end
    if bIsExistPlayer == false then
        self.operateId = false
        GetElement(self.m_root,"conOperate",WZUIContainer):setVisible(false)
    else
        if uiNode then
            GetElement(self.m_root,"conOperate",WZUIContainer):setVisible(true)
            self:setSelected(uiNode)
        end
    end
end

--@brief    创建人物按钮
function WndDigGem:createBtn()
    local con = WZUIContainer:create()
    con:setTouchSwallow(true)
    con:setUseAbsSize(true)
    con:setAbsContentSize(CCSize(120,120))
    con:setRelativePosition(ccp(0.5,0.55))
    con:setAnchorPoint(ccp(0.5,0.5))
    local btn = WZUIButton:create()
    btn:setLuaDoneFunctionName("clickRole")
    btn:setTouchSwallow(true)
    con:addChild(btn)
    return con, btn
end

--@brief    点击人物按钮回调
function WndDigGem:clickRole(element)
    WZLog("WndDigGem:clickRole")
    if self.playing == true then
        return
    end
    local tag = element:getTag()
    self.operateId = tag

    local tData
    local uiNode
    for i=1,self.m_nHireNum do
        if self.m_tRoleList[i].playerId == self.operateId then
            self.operateIndex = i
            tData = self.m_tRoleList[i]
            uiNode = tData.uiNode
        end
        local n = self.m_tRoleList[i].uiNode
        if n:getChildByTag(500) then n:removeChildByTag(500, true) end
    end
    --选中特效
    self:setSelected(uiNode)

    local conOperate = GetElement(self.m_root,"conOperate",WZUIContainer)
    if self.operateIndex <= self.m_nHireNum then
        conOperate:setVisible(true)
    else
        conOperate:setVisible(false)
    end
end

--@brief    点击驱逐回调
function WndDigGem:onClickChasing(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    ProtocolProcessorDigGem:send_MINING_ChasingThief()
end

--@brief    选中人物的光圈特效
function WndDigGem:setSelected(uiNode)
    if uiNode:getChildByTag(500) then
        return
    end
    local animation = WZArmature:create()
    animation:setTouchEnable(false)
    animation:setArmatureName("skills_dz_xq_01")
    animation:setArmatureFile("ui/skills_dz_xq_01.xml")
    animation:setUseOriginSize(true)
    animation:setRelativePosition(ccp(0.5,0.48))
    animation:setScale(0.7)
    uiNode:addChild(animation, 0, 500)
    local action = WZUIArmatureAnimationById:create()
    action:setAnimationId(0)
    action:setLoop(-1)
    animation:runUIAction(action)
end

--@brief    创建心情图片
function WndDigGem:setMood(con, moodValue)
    for i=1,5 do
        local mood = WZUIImage:create()
        mood:setUseOriginSize(true)
        mood:setRelativePosition(ccp(0.2*(i-1),0.5))
        mood:setAnchorPoint(ccp(0,0.5))
        con:addChild(mood,19)
        if i*20 < moodValue then
            mood:setFile("ui/common/common_icon_xqz_1.png")
        elseif i*20 > moodValue + 20 then 
            mood:setFile("ui/common/common_icon_xqz_2.png")
        else
            mood:setFile("ui/common/common_icon_xqz_2.png")
            local prgLeftTime = WZUIProgress:create()
            prgLeftTime:setBgPicture("ui/common/common_icon_xqz_1.png")
            prgLeftTime:setUseOriginSize(true)
            prgLeftTime:setRelativePosition(GlobalMethod:ccp(0.2*(i-1),0.5))
            prgLeftTime:setPercentage((moodValue-i*20+20)*5)
            prgLeftTime:setAnchorPoint(ccp(0,0.5))
            con:addChild(prgLeftTime, 20)
        end
    end
end

--@brief    播放表情动画
--@param    nFaceId:表情Id
function WndDigGem:playFaceAnimation(nFaceId, p)
    if self.m_faceAnim then
        self.m_faceAnim:getAnimNode():removeFromParentAndCleanup(true)
        self.m_faceAnim = nil
    end

    self.m_faceAnim = BattleAnimation:createAnimation(WndBattleHud.FACE_INDEX[nFaceId],true)

    --self:updateFaceAnimation()

    local node = self.m_faceAnim:getAnimNode()
    node:setZOrder(3)
    p:addChild(node, 20)

    node:setRelativePosition(ccp(0.52,0.6))
    self.m_faceAnim:play("0",true)
    node:setScale(0.15)
    node:setTag(100)
    local act1=CCScaleTo:create(0.2,1)
    local act2=CCDelayTime:create(2.1)
    local act3=CCScaleTo:create(0.2,0.2)
    local act4=CCCallFuncN:create(_WndDigGemPlayFaceEnd)
    local array = CCArray:create()
    array:addObject(act1)
    array:addObject(act2)
    array:addObject(act3)
    array:addObject(act4)
    node:runAction(CCSequence:create(array))
end

--@brief    播放表情动画结束回调
--@param    sender:动画对象
--@note     原生回调只能回调全局函数，暂用
function _WndDigGemPlayFaceEnd(sender)
    if WndDigGem.m_faceAnim then
        WndDigGem.m_faceAnim:getAnimNode():removeFromParentAndCleanup(true)
        WndDigGem.m_faceAnim = nil
    end
    -- WndDigGem.playing = false

    WndDigGem:playMoodChange()
end

--播放心情值变化动画
function WndDigGem:playMoodChange()
    local uiNode = self.playFaceRole.uiNode

    local label = WZUILabelTTF:create()
    if self.moodChange > 0 then
        label:setText(string.format(LocalStrings.DIGGEM_TEXT48, self.moodChange))
        label:setColor(ccc3(47,178,57))
    elseif self.moodChange < 0 then
        label:setText(string.format(LocalStrings.DIGGEM_TEXT49, -self.moodChange))
        label:setColor(ccc3(213,105,76))
    elseif self.moodChange == 0 then
        if self.moodValue == 0 then
            label:setText(string.format(LocalStrings.DIGGEM_TEXT49, -self.moodChange))
            label:setColor(ccc3(213,105,76))
        else
            label:setText(string.format(LocalStrings.DIGGEM_TEXT48, self.moodChange))
            label:setColor(ccc3(47,178,57))
        end
    end
    label:setFontSize(20)
    label:setAnchorPoint(ccp(0.5,0.5))
    label:setEnableStroke(true)
    label:setStrokeColor(ccc3(132,66,29))
    label:setStrokeSize(4)
    label:setRelativePosition(ccp(0.51,0.67))
    uiNode:addChild(label, 12, 900)

    local x,y = label:getPosition()
    local startSpeed = 0.3

    local act1=CCMoveTo:create(startSpeed,ccp(x,y+20))
    local act2=CCDelayTime:create(0.7)
    local act3=CCCallFuncN:create(_WndDigGemMoodChangeEnd)
    local array = CCArray:create()
    array:addObject(act1)
    array:addObject(act2)
    array:addObject(act3)
    label:runAction(CCSequence:create(array))
end

function _WndDigGemMoodChangeEnd()
    WZLog("_WndDigGemMoodChangeEnd")
    local uiNode = WndDigGem.playFaceRole.uiNode
    if uiNode and uiNode:getChildByTag(900) then
        uiNode:removeChildByTag(900, true)
    end
    WndDigGem.playing = false
end

-- 玩家互动(飞吻,喂食,皮鞭)
function WndDigGem:onOperate(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tRoleDataList[self.m_tRoleList[self.operateIndex].index].hireMoodValue >= 100 then
        MsgBoxManager:showTipBox(LocalStrings.DIGGEM_TEXT69)
        return
    end

    if self.operateId == nil then return end
    if self.playing then return end
    local tag = element:getTag()

    -- --判断矿晶是否足够
    local tOperatePrice = {}
    local miningInteraction = json.decode(CacheCenter:getGameParam().miningInteraction)
    local kiss = SplitStringWithSeparator(string.sub(miningInteraction.kiss,2,-2),",")
    local bread = SplitStringWithSeparator(string.sub(miningInteraction.bread,2,-2),",")
    local whip = SplitStringWithSeparator(string.sub(miningInteraction.whip,2,-2),",")
    tOperatePrice[1] = kiss
    tOperatePrice[2] = bread
    tOperatePrice[3] = whip
    if not JudgeMoneyIsEnough(tOperatePrice[tag][1],tOperatePrice[tag][2]) then
        return
    end

    local tData = self.m_tRoleList[self.operateIndex]
    local uiNode = tData.uiNode
    if uiNode:getChildByTag(800) or self.m_faceAnim then --互动动画或表情动画还没结束提示玩家稍等一会
        MsgBoxManager:showTipBox(LocalStrings.MARRY_DESC_25)
        return
    end

    --互动的动画
    local aniNames = {"ui_kiss","ui_food","ui_whip"}
    local positions = {ccp(0.45,0.46), ccp(0.54,0.48), ccp(0.55,0.54)}
    local aniName = aniNames[tag]
    local spine = WZUISpine:create()
    spine:setTouchEnable(false)
    spine:setFileJson("ui/digGem/"..aniName..".json")
    spine:setFileAtlas("ui/digGem/"..aniName..".atlas")
    spine:setAnimationName(aniName)
    spine:setUseOriginSize(true)
    spine:setRelativePosition(positions[tag])
    spine:play(aniName,true)
    spine:setRelativePosition(GlobalMethod:ccp(0.5,1.9))
    uiNode:addChild(spine,10,800)

    -- uiNode:enableSchedule("stopOperateAni", 2)

    local con = GetElement(self.m_root,"conOperate",WZUIContainer)
    con:enableSchedule("stopAniSchedule", 1.5)

    WZLog("WndDigGem:onOperate", tag)
    self.operateType = tag
    self.playing = true
end

function WndDigGem:stopAniSchedule(element, t)
    local con = GetElement(self.m_root,"conOperate",WZUIContainer)
    con:disableSchedule()

    ProtocolProcessorDigGem:send_MINING_HireInteract(self.operateId, self.operateType)
end

-------------------------------------挖宝人物End----------------------------------------



-------------------------------------私有方法模块Begin--------------------------------------
--@brief    创建背包格子
function WndDigGem:_createBagGrid()
    -- body
    local tableBagList = GetElement(self.m_root, "tableBagList_WndDigGem", WZUITableContainer)
    tableBagList:cleanTable()
    tableBagList:setLoadCountPerFrame(3)
    self.m_tCellGridList = {}

    for i= 1, self.m_nMaxNum do
        local celElement,tCell = CellGrid:createElement()
        if celElement and tCell then
            celElement:setTag(i-1)
            tableBagList:setCellElement(celElement)
            tCell:setItemClickFun(self,self.onItemClick)
            table.insert(self.m_tCellGridList,tCell)
        end
    end
end

--brief     设置背包格子数据
function WndDigGem:_setBagData()
    -- body
    for i = 1, #self.m_tCellGridList do
        self.m_tCellGridList[i]:removeAllChild()
    end

    local tableBagList = GetElement(self.m_root, "tableBagList_WndDigGem", WZUITableContainer)
    for i = 1, #self.m_tBagList do
        if self.m_tCellGridList[i] == nil then
            local celElement,tCell = CellGrid:createElement()
            if celElement and tCell then
                celElement:setTag(i-1)
                tableBagList:setCellElement(celElement)
                tCell:setItemClickFun(self,self.onItemClick)
                table.insert(self.m_tCellGridList,tCell)
            end
        end
        self.m_tCellGridList[i]:setCellGoodItem(self.m_tBagList[i],2)
    end

    if self.m_tClickGemInfo ~= nil then
        if self.m_tBagList[self.m_tClickGemInfo.tag + 1] and self.m_tBagList[self.m_tClickGemInfo.tag + 1].id ~= self.m_tClickGemInfo.tData.id then
            --取消之前的选中状态
            self.m_tCellGridList[self.m_tClickGemInfo.tag + 1]:setHighLight(false)
            if self.m_tBagList[self.m_tClickGemInfo.tag + 2] and self.m_tBagList[self.m_tClickGemInfo.tag + 2].id == self.m_tClickGemInfo.tData.id then
                self.m_tCellGridList[self.m_tClickGemInfo.tag + 2]:setHighLight(true)
                self.m_tClickGemInfo.tag = self.m_tClickGemInfo.tag + 1
            end
        end
    end
end

--@brief    创建日志列表
function WndDigGem:_createLog()
    -- body
    --[[
    local tableLogList = GetElement(self.m_root, "tableLogList_WndDigGem", WZUITableContainer)
    local nCurPositionY = tableLogList:getMoveElement():getPositionY()
    local nLastSize = tableLogList:getMoveElement():getContentSize()
    tableLogList:cleanTable()

    local conLog = GetElement(self.m_root, "conLog_WndDigGem", WZUIContainer)
    if self.m_tLogList == nil or #self.m_tLogList == 0 then
        if ProjConfig.LANGUAGE == "ug" then
            ShowPanelNullTip( conLog, LocalStrings.DIGGEM_TEXT21, GlobalMethod:ccc3(195,171,148),nil,nil,nil,2)
        else
            ShowPanelNullTip( conLog, LocalStrings.DIGGEM_TEXT21, GlobalMethod:ccc3(195,171,148))
        end
        return 
    end
    removeShowPanelNullTip(conLog)

    for i = 1, #self.m_tLogList do
        local celElement, tNewObj = CellDigGemLog:createElement()
        if celElement and tNewObj then
            celElement:setTag(i - 1)
            tNewObj:setData(self.m_tLogList[i])
            tableLogList:setCellElement(celElement)
        end
    end

    --重新设置列表位置
    local nCurSize = tableLogList:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (nCurSize.height - nLastSize.height)/2
    if nTempPositionY > tableLogList:getMaxPosition().y then
        nTempPositionY = tableLogList:getMaxPosition().y
    end
    tableLogList:getMoveElement():setPositionY(nTempPositionY)
    --]]


    local flcLogList = GetElement(self.m_root, "flcLogList_WndDigGem", WZUIFreeListContainer)
    flcLogList:removeAll()

    local conLog = GetElement(self.m_root, "conLog_WndDigGem", WZUIContainer)
    if self.m_tLogList == nil or #self.m_tLogList == 0 then
        ShowPanelNullTip( conLog, LocalStrings.DIGGEM_TEXT21, GlobalMethod:ccc3(195,171,148))
        return 
    end
    removeShowPanelNullTip(conLog)

    for i = 1, #self.m_tLogList do
        local celElement, tNewObj = CellDigGemLog:createElement()
        if celElement and tNewObj then
            tNewObj:setData(self.m_tLogList[i])
            flcLogList:pushBack(WZUIContainer:luaTo(celElement))
        end
    end
    flcLogList:getMoveElement():setPositionY(flcLogList:getMinPosition().y)
end

--@brief    创建遗迹列表
function WndDigGem:_createRemains()
    local tableRemainsList = GetElement(self.m_root, "tableRemainsList_WndDigGem", WZUITableContainer)
    local nCurPositionY = tableRemainsList:getMoveElement():getPositionY()
    local nLastSize = tableRemainsList:getMoveElement():getContentSize()
    tableRemainsList:cleanTable()

    local conRemains = GetElement(self.m_root, "conRemains_WndDigGem", WZUIContainer)
    if self.m_tRemainsList == nil or #self.m_tRemainsList == 0 then
        ShowPanelNullTip( conRemains, LocalStrings.RELIC_TEXT_2, GlobalMethod:ccc3(195,171,148))
        return 
    end
    removeShowPanelNullTip(conRemains)

    self.m_tRemainsEleList = {}
    for i = 1, #self.m_tRemainsList do
        local celElement, tNewObj = CellDigGemRemains:createElement()
        if celElement and tNewObj then
            celElement:setTag(i - 1)
            tNewObj:setData(self.m_tRemainsList[i])
            tableRemainsList:setCellElement(celElement)
            table.insert(self.m_tRemainsEleList, tNewObj)
        end
    end

    --重新设置列表位置
    local nCurSize = tableRemainsList:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (nCurSize.height - nLastSize.height)/2
    if nTempPositionY > tableRemainsList:getMaxPosition().y then
        nTempPositionY = tableRemainsList:getMaxPosition().y
    end
    tableRemainsList:getMoveElement():setPositionY(nTempPositionY)

    --遗迹之光分享按钮
    for i = 1, #self.m_tRemainsEleList do
        local tNewObj = self.m_tRemainsEleList[i]
        tNewObj:showShareCD(self.m_nShareTime)
    end
    self:showShareBtnCD()
end

--@brief    创建雇佣列表
function WndDigGem:_createHire()
    local tableHireList = GetElement(self.m_root, "tableHireList_WndDigGem", WZUITableContainer)
    -- local nCurPositionY = tableHireList:getMoveElement():getPositionY()
    -- local nLastSize = tableHireList:getMoveElement():getContentSize()
    tableHireList:cleanTable()

    local conHire = GetElement(self.m_root, "conHire_WndDigGem", WZUIContainer)
    if self.m_tHireFriendList == nil or #self.m_tHireFriendList == 0 then
        ShowPanelNullTip( conHire, LocalStrings.EMPTYFRIENDTIP1, GlobalMethod:ccc3(195,171,148))
        return 
    end
    removeShowPanelNullTip(conHire)

    -- for i = 1, #self.m_tHireFriendList do
    --     local celElement, tNewObj = CellDigGemHire:createElement()
    --     if celElement and tNewObj then
    --         celElement:setTag(i - 1)
    --         tNewObj:setData(self.m_tHireFriendList[i])
    --         tableHireList:setCellElement(celElement)
    --     end
    -- end

    self.m_nStartIndex = 1
    tableHireList:enableSchedule("_addFriend")

    -- --重新设置列表位置
    -- local nCurSize = tableHireList:getMoveElement():getContentSize()
    -- local nTempPositionY = nCurPositionY - (nCurSize.height - nLastSize.height)/2
    -- if nTempPositionY > tableHireList:getMaxPosition().y then
    --     nTempPositionY = tableHireList:getMaxPosition().y
    -- end
    -- tableHireList:getMoveElement():setPositionY(nTempPositionY)

end

--@brief  每帧加载好友
function WndDigGem:_addFriend(element)
    local tableHireList = GetElement(self.m_root,"tableHireList_WndDigGem",WZUITableContainer)
    
    local endIndex = math.min(self.m_nStartIndex+2,#self.m_tHireFriendList)
    for i=self.m_nStartIndex,endIndex do
        local celElement, tNewObj = CellDigGemHire:createElement()
        if celElement and tNewObj then
            celElement:setTag(i - 1)
            tNewObj:setData(self.m_tHireFriendList[i])
            tableHireList:setCellElement(celElement)
        end

        self.m_nStartIndex = self.m_nStartIndex + 1
    end
    if self.m_nStartIndex > #self.m_tHireFriendList then
        tableHireList:disableSchedule()
    end

end

function WndDigGem:showShareBtnCD()
    if self.m_nShareTime > 0 then
        local conRemains = GetElement(self.m_root, "conRemains_WndDigGem", WZUIContainer)
        conRemains:disableSchedule()
        conRemains:enableSchedule("_countdownShareCD", 1)
    end
end

function WndDigGem:_countdownShareCD()
    local conRemains = GetElement(self.m_root, "conRemains_WndDigGem", WZUIContainer)
    self.m_nShareTime = self.m_nShareTime - 1
    if self.m_nShareTime <= 0 then
        self.m_nShareTime = 0
        conRemains:disableSchedule()
        ProtocolProcessorDigGem:send_MINING_GetMining()
    end

    for i = 1, #self.m_tRemainsEleList do
        local tNewObj = self.m_tRemainsEleList[i]
        tNewObj:showShareCD(self.m_nShareTime)
    end
end

--@brief     添加顶部货币栏
function WndDigGem:_addTop()
    -- body
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/common_icon_wb.png", WndDigGem, WndDigGem.onClickClose, true, false, false,nil, {goldType = 7})
    self.m_root:addChild(celElement)
    self.m_topCellLua = tNewObj
end

--@brief    设置文本
function WndDigGem:_setStaticText()
    -- body
    local ftxtLeftTime = GetElement(self.m_root, "ftxtLeftTime_WndDigGem", WZUIFreeTextBox)
    local txtExp = GetElement(self.m_root, "txtExp_WndDigGem", WZUILabelTTF)
    if ftxtLeftTime then
        if self.m_bIsStart then
            self:_showLeftTime()
            ftxtLeftTime:setVisible(true)
            txtExp:setRelativePosition(GlobalMethod:ccp(0.5,0.7))
            self.m_root:enableSchedule("_caculateTime", 0.2)
        else
            ftxtLeftTime:setVisible(false)
            txtExp:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        end
    end
    
    --熟练度
    self:_showExp()
end

--@brief    挖宝剩余时间倒计时
function WndDigGem:_caculateTime(element, delta)
    -- body
    self.m_nTempSeconds = self.m_nTempSeconds + delta
    if self.m_nTempSeconds >= 1 then
        if self.m_nToolLeftTime > 0 then
            self.m_nToolLeftTime = self.m_nToolLeftTime - 1
            self.m_nTempSeconds = self.m_nTempSeconds - 1
            self:_showLeftTime()
            --计算下次挖到宝物时间，倒计时为零发送请求
            if self.m_nNextStartTime > 0 then
                self.m_nNextStartTime = self.m_nNextStartTime - 1
            else
                --挖到宝物
                if self.m_nNextStartTime == 0 then
                    self.m_nNextStartTime = -1
                    self:sendGetDem(5)
                end
            end
        else
            if self.m_nToolLeftTime == 0 then
                self.m_nToolLeftTime = -1
                self:sendGetDem(6)
            end
            self:_stopDigDemToDealWith(1)
        end
    end
end

--@brief    根据选中的标签，显示相应的信息
function WndDigGem:_updateRightContent()
    -- body
    --右边底部字
    local ftxtBottomText = GetElement(self.m_root, "ftxtBottomText_WndDigGem", WZUIFreeTextBox)
    local imgRightBg = GetElement(self.m_root,"imgRightBg_WndDigGem",WZUI9Image)
    if ftxtBottomText then
        if self.m_nTabIndex == 0 then
            imgRightBg:setVisible(true)
            local sFormat = [[<T C="127,70,26" S="23" P="1">%s:</T><T C="229,105,22" S="22" P="1">%d/%d</T>]]
            local nItemNum = #self.m_tBagList
            ftxtBottomText:setShowText(string.format(sFormat, LocalStrings.DIGGEM_TEXT7, nItemNum, self.m_nMaxNum))
        elseif self.m_nTabIndex == 1 then
            imgRightBg:setVisible(true)
            local sFormat = [[<T C="127,70,26" S="20" P="1">%s</T>]]
            ftxtBottomText:setShowText(string.format(sFormat, LocalStrings.DIGGEM_TEXT8))
        elseif self.m_nTabIndex == 2 then 
            imgRightBg:setVisible(true)
            local digdungeoncapacity = CacheCenter:getGameParam().digdungeoncapacity
            local sFormat = [[<T C="127,70,26" S="22" P="1">%s:</T><T C="229,105,22" S="22" P="1">%d/%d</T>]]
            ftxtBottomText:setShowText(string.format(sFormat,LocalStrings.DIGGEM_TEXT7,self.m_nMapSize,digdungeoncapacity))
        elseif self.m_nTabIndex == 3 then
            imgRightBg:setVisible(false)
            ftxtBottomText:setShowText("")
        end
    end

    if self.m_nTabIndex == 0 then
        GetElement(self.m_root, "conBag_WndDigGem", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conLog_WndDigGem", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conRemains_WndDigGem", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conHire_WndDigGem", WZUIContainer):setVisible(false)

        self:_setBagData()
    elseif self.m_nTabIndex == 1 then
        GetElement(self.m_root, "conBag_WndDigGem", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conLog_WndDigGem", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conRemains_WndDigGem", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conHire_WndDigGem", WZUIContainer):setVisible(false)

        self:_createLog()
    elseif self.m_nTabIndex == 2 then
        GetElement(self.m_root, "conBag_WndDigGem", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conLog_WndDigGem", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conRemains_WndDigGem", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conHire_WndDigGem", WZUIContainer):setVisible(false)

        self:_createRemains()
    elseif self.m_nTabIndex == 3 then
        GetElement(self.m_root, "conBag_WndDigGem", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conLog_WndDigGem", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conRemains_WndDigGem", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conHire_WndDigGem", WZUIContainer):setVisible(true)

        self:_createHire()
    end
end

--@brief    设置挖矿按钮是否显示
function WndDigGem:_showMiningBtn(bShow)
    local btnClickStart = GetElement(self.m_root, "btnClickStart_WndDigGem", WZUIButton)
    if btnClickStart then
        btnClickStart:setVisible(bShow)
    end
end

--@brief    设置挖宝按钮字
function WndDigGem:_showBtnText(sText)
    -- body
    local txtBtnText = GetElement(self.m_root, "txtBtnText_WndDigGem", WZUILabelTTF)
    if txtBtnText then
        txtBtnText:setText(sText)
    end
end

--@brief    显示挖宝剩余时间
function WndDigGem:_showLeftTime()
    -- body
    local ftxtLeftTime = GetElement(self.m_root, "ftxtLeftTime_WndDigGem", WZUIFreeTextBox)
    local sTime = returnToTimeFormat(self.m_nToolLeftTime)
    local sTimeFormat = [[<T C="255,236,193" S="22" P="1" SC="132,66,29" SE="1" SS="4">%s</T><T C="229,105,22" S="22" P="1" SC="132,66,29" SE="1" SS="4">%s</T>]]
    if ftxtLeftTime then
        ftxtLeftTime:setShowText(string.format(sTimeFormat, LocalStrings.DIGGEM_TEXT3, sTime))
    end

    --剩余时间为0或n小时59分59秒时,刷新雇佣列表的雇佣消耗
    if self.m_nToolLeftTime == 0 or (self.m_nToolLeftTime + 1) % 60 == 0 then
        self:_createHire()
    end
end

--@brief    显示熟练度相关
function WndDigGem:_showExp()
    -- body
    local txtExp = GetElement(self.m_root, "txtExp_WndDigGem", WZUILabelTTF)
    if txtExp then
        txtExp:setText(LocalStrings.DIGGEM_TEXT6 .. ":" .. "Lv" .. self.m_nMyLevel .. "(" .. self.m_nCurExp .. "/" .. self.m_nCurMaxExp .. ")")
    end
end

--@brief    停止挖宝处理
--@param    nType: 1->时间到，自动停止；2->主动停止；3->背包满，自动停止
function WndDigGem:_stopDigDemToDealWith(nType)
    -- body
    local txtTipContent 
    if nType == 1 then
        txtTipContent = LocalStrings.DIGGEM_TEXT11
    elseif nType == 2 then
        txtTipContent = LocalStrings.DIGGEM_TEXT14
    elseif nType == 3 then
        txtTipContent = LocalStrings.DIGGEM_TEXT12
    end
    MsgBoxManager:showTipBox(txtTipContent)
    --
    self.m_root:disableSchedule()
    self.m_bIsStart = false
    self.m_nNextStartTime = 0
    self:_setStaticText()
    self:_showBtnText(LocalStrings.DIGGEM_TEXT4)
    self:_showMiningBtn(true)
    --切换挖宝动画
    self:_showDigGemAni(0)
end

--@brief    显示挖宝动画
--@param    nIndex : 动画索引
function WndDigGem:_showDigGemAni(nIndex)
    -- body
    local spineRole = GetElement(self.m_root, "spineRole_WndDigGem", WZUISpine)
    if spineRole then
        if nIndex == 0 then
            GetElement(self.m_root, "imgDigging_WndDigGem", WZUIImage):setVisible(false)
            spineRole:setVisible(false)
        else
            spineRole:setAnimationName("dug" .. nIndex)
            spineRole:setVisible(true)
            GetElement(self.m_root, "imgDigging_WndDigGem", WZUIImage):setVisible(true)
        end
    end
end

--@brief    当购买次数用完后，根据情况弹出不同的提示
function WndDigGem:_showTipsAccordCase()
    -- body
    local nMaxVipValue = GetMaxVipLevel()

    if CacheCenter:getPlayerInfo().vipLevel < nMaxVipValue then
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
        MsgBoxManager:showConfirmBox(LocalStrings.BUY_UNSUCCESS, self, self.needMoreDiamondCallBack, nil, tCustomUIConfig)
    elseif CacheCenter:getPlayerInfo().vipLevel == nMaxVipValue then
        MsgBoxManager:showTipBox(LocalStrings.DIGGEM_TEXT35)
    end
end

--@brief    提示充值框的回调
--@param    nId:消息id
--@param    nResType:响应类型(超时，确定，取消)
function WndDigGem:needMoreDiamondCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end

--@brief    挖宝动作音效
function WndDigGem:attack()
    -- body
    WZLog("WndDigGem:attack")
--    SoundManager:playEffectSound(SoundDefine.E_S_KILL_WABAO)
end

--适配iphoneX
function WndDigGem:_AdaptationIphoneX()
    -- body
    WZLog("WndWakeup:_AdaptationIphoneX")
    -- if IsIphoneX() then
    --     local conLeftPart = GetElement(self.m_root,"conLeft_WndDigGem",WZUIContainer)
        
    -- end
end
-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function WndDigGem:_adaptLanguage_en(  )
    local txtBackpack1 = GetElement(self.m_root, "txtBackpack1_WndDigGem", WZUILabelTTF)
    txtBackpack1:setScale(0.85)
    txtBackpack1:setDimensions(GlobalMethod:CCSize(110))
    local txtBackpack2 = GetElement(self.m_root, "txtBackpack2_WndDigGem", WZUILabelTTF)
    txtBackpack2:setScale(0.85)
    txtBackpack2:setDimensions(GlobalMethod:CCSize(110))

    local ftxtBottomText = GetElement(self.m_root, "ftxtBottomText_WndDigGem", WZUIFreeTextBox)
    ftxtBottomText:setScale(0.8)
    ftxtBottomText:setMaxWidth(500)
end

function WndDigGem:_adaptLanguage_th(  )
    local txtLog1 = GetElement(self.m_root, "txtLog1_WndDigGem", WZUILabelTTF)
    txtLog1:setScale(0.75)
    local txtLog2 = GetElement(self.m_root, "txtLog2_WndDigGem", WZUILabelTTF)
    txtLog2:setScale(0.75)

    local ftxtBottomText = GetElement(self.m_root, "ftxtBottomText_WndDigGem", WZUIFreeTextBox)
    ftxtBottomText:setScale(0.7)
    ftxtBottomText:setMaxWidth(500)

end

function WndDigGem:_adaptLanguage_vn(  )
    local txtBackpack1 = GetElement(self.m_root, "txtBackpack1_WndDigGem", WZUILabelTTF)
    txtBackpack1:setScale(0.8)
    txtBackpack1:setDimensions(GlobalMethod:CCSize(110))
    local txtBackpack2 = GetElement(self.m_root, "txtBackpack2_WndDigGem", WZUILabelTTF)
    txtBackpack2:setScale(0.8)
    txtBackpack2:setDimensions(GlobalMethod:CCSize(110))

    local txtLog1 = GetElement(self.m_root, "txtLog1_WndDigGem", WZUILabelTTF)
    txtLog1:setScale(0.8)
    txtLog1:setDimensions(GlobalMethod:CCSize(110))
    local txtLog2 = GetElement(self.m_root, "txtLog2_WndDigGem", WZUILabelTTF)
    txtLog2:setScale(0.8)
    txtLog2:setDimensions(GlobalMethod:CCSize(110))

    local txtRemains1 = GetElement(self.m_root, "txtRemains1_WndDigGem", WZUILabelTTF)
    txtRemains1:setScale(0.8)
    txtRemains1:setDimensions(GlobalMethod:CCSize(110))
    local txtRemains2 = GetElement(self.m_root, "txtRemains2_WndDigGem", WZUILabelTTF)
    txtRemains2:setScale(0.8)
    txtRemains2:setDimensions(GlobalMethod:CCSize(110))

    local ftxtBottomText = GetElement(self.m_root, "ftxtBottomText_WndDigGem", WZUIFreeTextBox)
    ftxtBottomText:setScale(0.8)
    ftxtBottomText:setMaxWidth(500)
end

function WndDigGem:_adaptLanguage_pt(  )
    local txtBackpack1 = GetElement(self.m_root, "txtBackpack1_WndDigGem", WZUILabelTTF)
    txtBackpack1:setScale(0.8)
    txtBackpack1:setDimensions(GlobalMethod:CCSize(120))
    local txtBackpack2 = GetElement(self.m_root, "txtBackpack2_WndDigGem", WZUILabelTTF)
    txtBackpack2:setScale(0.8)
    txtBackpack2:setDimensions(GlobalMethod:CCSize(120))

    local txtLog1 = GetElement(self.m_root, "txtLog1_WndDigGem", WZUILabelTTF)
    txtLog1:setScale(0.6)
    txtLog1:setDimensions(GlobalMethod:CCSize(160))
    local txtLog2 = GetElement(self.m_root, "txtLog2_WndDigGem", WZUILabelTTF)
    txtLog2:setScale(0.6)
    txtLog2:setDimensions(GlobalMethod:CCSize(160))

    local ftxtBottomText = GetElement(self.m_root, "ftxtBottomText_WndDigGem", WZUIFreeTextBox)
    ftxtBottomText:setScale(0.7)
    ftxtBottomText:setMaxWidth(380)

    local txtBtnText = GetElement(self.m_root, "txtBtnText_WndDigGem", WZUILabelTTF)
    txtBtnText:setScale(0.8)
    txtBtnText:setDimensions(GlobalMethod:CCSize(200))
end

function WndDigGem:_adaptLanguage_es(  )
    local txtBackpack1 = GetElement(self.m_root, "txtBackpack1_WndDigGem", WZUILabelTTF)
    txtBackpack1:setScale(0.8)
    txtBackpack1:setDimensions(GlobalMethod:CCSize(120))
    local txtBackpack2 = GetElement(self.m_root, "txtBackpack2_WndDigGem", WZUILabelTTF)
    txtBackpack2:setScale(0.8)
    txtBackpack2:setDimensions(GlobalMethod:CCSize(120))

    local txtLog1 = GetElement(self.m_root, "txtLog1_WndDigGem", WZUILabelTTF)
    txtLog1:setScale(0.6)
    txtLog1:setDimensions(GlobalMethod:CCSize(160))
    local txtLog2 = GetElement(self.m_root, "txtLog2_WndDigGem", WZUILabelTTF)
    txtLog2:setScale(0.6)
    txtLog2:setDimensions(GlobalMethod:CCSize(160))

    local ftxtBottomText = GetElement(self.m_root, "ftxtBottomText_WndDigGem", WZUIFreeTextBox)
    ftxtBottomText:setScale(0.7)
    ftxtBottomText:setMaxWidth(380)

    local txtBtnText = GetElement(self.m_root, "txtBtnText_WndDigGem", WZUILabelTTF)
    txtBtnText:setScale(0.8)
    txtBtnText:setDimensions(GlobalMethod:CCSize(200))
end

function WndDigGem:_adaptLanguage_tr(  )
    local txtBackpack1 = GetElement(self.m_root, "txtBackpack1_WndDigGem", WZUILabelTTF)
    txtBackpack1:setScale(0.8)
    txtBackpack1:setDimensions(GlobalMethod:CCSize(120))
    local txtBackpack2 = GetElement(self.m_root, "txtBackpack2_WndDigGem", WZUILabelTTF)
    txtBackpack2:setScale(0.8)
    txtBackpack2:setDimensions(GlobalMethod:CCSize(120))

    local txtLog1 = GetElement(self.m_root, "txtLog1_WndDigGem", WZUILabelTTF)
    txtLog1:setScale(0.6)
    txtLog1:setDimensions(GlobalMethod:CCSize(160))
    local txtLog2 = GetElement(self.m_root, "txtLog2_WndDigGem", WZUILabelTTF)
    txtLog2:setScale(0.6)
    txtLog2:setDimensions(GlobalMethod:CCSize(160))

    local ftxtBottomText = GetElement(self.m_root, "ftxtBottomText_WndDigGem", WZUIFreeTextBox)
    ftxtBottomText:setScale(0.7)
    ftxtBottomText:setMaxWidth(380)

    local txtBtnText = GetElement(self.m_root, "txtBtnText_WndDigGem", WZUILabelTTF)
    txtBtnText:setScale(0.8)
    txtBtnText:setDimensions(GlobalMethod:CCSize(200))
end

function WndDigGem:_adaptLanguage_ug(  )
    local txtBackpack1 = GetElement(self.m_root, "txtBackpack1_WndDigGem", WZUILabelTTF)
    txtBackpack1:setScale(0.6)
    txtBackpack1:setDimensions(GlobalMethod:CCSize(160))
    local txtBackpack2 = GetElement(self.m_root, "txtBackpack2_WndDigGem", WZUILabelTTF)
    txtBackpack2:setScale(0.6)
    txtBackpack2:setDimensions(GlobalMethod:CCSize(160))

    local txtLog1 = GetElement(self.m_root, "txtLog1_WndDigGem", WZUILabelTTF)
    txtLog1:setScale(0.6)
    txtLog1:setDimensions(GlobalMethod:CCSize(160))
    local txtLog2 = GetElement(self.m_root, "txtLog2_WndDigGem", WZUILabelTTF)
    txtLog2:setScale(0.6)
    txtLog2:setDimensions(GlobalMethod:CCSize(160))

    local ftxtBottomText = GetElement(self.m_root, "ftxtBottomText_WndDigGem", WZUIFreeTextBox)
    ftxtBottomText:setScale(0.7)
    ftxtBottomText:setMaxWidth(380)

    local txtBtnText = GetElement(self.m_root, "txtBtnText_WndDigGem", WZUILabelTTF)
    txtBtnText:setScale(0.8)
    txtBtnText:setDimensions(GlobalMethod:CCSize(260))
    
    GetElement(self.m_root,"imgBtn3_WndDigGem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.6,0))
    GetElement(self.m_root,"imgBtn4_WndDigGem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.55,0))
end
---------------------------------------语言适配End------------------------------------------