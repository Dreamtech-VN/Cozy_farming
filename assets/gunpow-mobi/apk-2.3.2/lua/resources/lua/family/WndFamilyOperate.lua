--WndFamilyOperate.lua
--@brief	WndFamilyOperate的UI模块
--@date		2017/07/25
--@author	Tianxiang_Xu
--@note		家园系统操作窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFamilyOperate:onEnter(element)
	self.m_root = element
    self:_AdaptationIphoneX()
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFamilyOperate:onExit(element)
    ProtocolProcessorWndBag:unregAll()
	self:_unInit()
end

--@brief    界面加载完成回调
function WndFamilyOperate:onEnterTransitionDidFinish(element)
    -- body
    self.m_txtRecoverTime = GetElement(self.m_root, "txtRecoverTime_WndFamileOperate", WZUILabelTTF)
    self:setRecoverTimeCaculate()
    --新手定推礼包入口
    local conRightUp = GetElement(self.m_root, "conRightUp_WndFamileOperate", WZUIContainer)
    CreateLimitPackage(131, conRightUp, GlobalMethod:ccp(0.5, 0.45))

    self:_getBtnNode()
    self:_addTop()
end

--@brief    触摸开始回调
function WndFamilyOperate:onTouchBegin(element, pt)
    -- body
end

function WndFamilyOperate:hideRankList()
    --body
    if self.m_nRankState == 1 then
        self.m_nRankState = 0
        GetElement(self.m_root, "conForRankList_WndFamilyOperate", WZUIContainer):setVisible(false)
        local conRankList = GetElement(self.m_root, "conRankList_WndFamilyOperate", WZUIContainer)
        conRankList:setAnchorPoint(GlobalMethod:ccp(0,0.5))
        if IsIphoneX() then 
            conRankList:setRelativePosition(GlobalMethod:ccp(0.95, 0.46))
        else
            conRankList:setRelativePosition(GlobalMethod:ccp(1, 0.46))
        end
    end
end

function WndFamilyOperate:checkPointInBtn(pt)
    if self.m_root == nil then return end
    local btn = GetElement(self.m_root, "conRankList_WndFamilyOperate", WZUIContainer)
    if btn == nil then return false end
    local btnSize = btn:getContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        return true
    end 

    btn = GetElement(self.m_root, "btnFriendHome_WndFamilyOperate", WZUIButton)
    if btn == nil then return false end
    btnSize = btn:getContentSize()
    --获得btn的世界坐标
    ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        return true
    else
        return false
    end 
end

--@brief    显示需要网络数据的界面数据
function WndFamilyOperate:showOtherInfo()
    -- body
    GetElement(self.m_root, "conOutSide_WndFamilyOperate", WZUIContainer):setVisible(true)
    self:_setNodeVisible()
    self:_update()

    if self.m_bIsTeachOnEnter == nil then
        self.m_bIsTeachOnEnter = true
        local isEndTeach, finishStep = TeachGroup1:isTeachFinish(45)
        if isEndTeach ~= true then
            local buildingCK = SceneFamily:getBuildingCellById(40300)
            local buildingSS = SceneFamily:getBuildingCellById(40100)
            WZLog("WndFamilyOperate:onClickShop", tostring(buildingCK), tostring(buildingSS))
            if buildingCK == nil then
                TeachGroup1:startGroup({45,1,self.m_root})
            elseif buildingCK and buildingSS == nil then
                TeachGroup1:endTeachStep({45,3})
                TeachGroup1:startGroup({45,4,self.m_root})
            elseif buildingSS and buildingCK == nil then
                TeachGroup1:endTeachStep({45,6})
                TeachGroup1:startGroup({45,7,buildingSS.m_root})
            elseif buildingCK and buildingSS then
                TeachGroup1:removeTeach()
                TeachGroup1:setTeachFinish(45,-1)
            end

        -- if isEndTeach ~= true and finishStep < 3 then
        --     TeachGroup1:startGroup({45,1,self.m_root})
        -- elseif isEndTeach ~= true and finishStep < 6 then
        --     TeachGroup1:startGroup({45,4,self.m_root})
        -- elseif isEndTeach ~= true then
        --     WZLog("WndFamilyOperate:showOtherInfo two")
        --     TeachGroup1:startGroup({45,7,buildingSS.m_root})
        -- end
        end
    end
end

--@brief    点击建筑，对底部按钮添加相应的按钮操作
function WndFamilyOperate:onClickBuildingCallBack()
    WZLog("WndFamilyOperate:onClickBuildingCallBack")
    self:_showFuncBtnList()
end

--@brief  点击商店回调
function WndFamilyOperate:onClickShop(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self.m_bIsClickFunc = true 
    WndFamilyShop:showInterface()

    local buildingCK = SceneFamily:getBuildingCellById(40300)
    WZLog("WndFamilyOperate:onClickShop", tostring(buildingCK))
    if buildingCK == nil then
        TeachGroup1:endTeachStep({45,1})
    else
        TeachGroup1:endTeachStep({45,4})
    end
end

--@brief  点击排行榜回调
function WndFamilyOperate:onClickRank(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    self.m_bIsClickFunc = true 
    WndFamilyRank:showInterface()
end

--@brief  点击编辑回调
function WndFamilyOperate:onClickEdit(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

end

--@brief  点击回家按钮回调
function WndFamilyOperate:onClickGoHome(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    SceneFamily:showInterface()
end

--@brief  点击拍照回调
function WndFamilyOperate:onClickPhoto(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    if CanWeChatShare() then 
        --隐藏掉操作界面，显示游戏logo
        self.m_root:setVisible(false)
        SceneFamily:setLogoVisible(true)
        DoWeChatShare(11)
    end

   SceneFamily:setLogoVisible(false)
   self.m_root:setVisible(true)
end

--@brief  点击信息回调
function WndFamilyOperate:onClickInfo(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    self.m_bIsClickFunc = true 
    --如果建筑不在有效的位置上
    if not SceneFamily:canClickOperateFunc() then return end

    WndBuildingInfo:showInterface(SceneFamily.m_clickInfo.tData)
end

--@brief  点击取消回调
function WndFamilyOperate:onClickCancel(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    self.m_bIsClickFunc = true 
    --如果建筑不在有效的位置上
    if not SceneFamily:canClickOperateFunc() then return end

    local tData = SceneFamily.m_clickInfo.tData 
    self.m_tOperateData = CopyTable(SceneFamily.m_clickInfo.tData)
    local sAttContent 
    if tData.buildingStatus == 1 then
        sAttContent = string.format(LocalStrings.FAMILY_TEXT10, tData.basicInfo.name)
    elseif tData.buildingStatus == 2 then
        sAttContent = string.format(LocalStrings.FAMILY_TEXT9, tData.basicInfo.name)
    elseif tData.buildingStatus == 3 then
        sAttContent = string.format(LocalStrings.FAMILY_TEXT11, tData.basicInfo.name)
    end
    MsgBoxManager:showConfirmBox(sAttContent, self, self.sureToCancel)
end

--@brief  点击升级回调
function WndFamilyOperate:onClickUpgrade(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    self.m_bIsClickFunc = true 
    --如果建筑不在有效的位置上
    if not SceneFamily:canClickOperateFunc() then return end

    local tData = SceneFamily.m_clickInfo.tData 
    WndBuildingUpgrade:showInterface(tData)
end

--@brief  点击加速回调
function WndFamilyOperate:onClickSpeed(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    self.m_bIsClickFunc = true 
    --如果建筑不在有效的位置上
    if not SceneFamily:canClickOperateFunc() then return end

    local tData = SceneFamily.m_clickInfo.tData 
    self.m_tOperateData = CopyTable(SceneFamily.m_clickInfo.tData)
    local nCostValue = tData.basicData.speedup_price[1][2] * math.ceil(tData.countdown/60)
    local tCostBasicData = GDatatab_item["id_" .. tData.basicData.speedup_price[1][1]]
    local sAttContent 
    if tData.buildingStatus == 1 then
        sAttContent = string.format(LocalStrings.FAMILY_TEXT6, nCostValue, tCostBasicData.name, tData.basicInfo.name)
    elseif tData.buildingStatus == 2 then
        sAttContent = string.format(LocalStrings.FAMILY_TEXT5, nCostValue, tCostBasicData.name, tData.basicInfo.name)
    elseif tData.buildingStatus == 3 then
        sAttContent = string.format(LocalStrings.FAMILY_TEXT7, nCostValue, tCostBasicData.name, tData.basicInfo.name)
    end
    MsgBoxManager:showConfirmBox(sAttContent, self, self.sureToSpeed)
end

--@brief  点击移除回调
function WndFamilyOperate:onClickRemove(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tData = SceneFamily.m_clickInfo.tData
    local nFreeButlerNum = SceneFamily:getFreeButlerNum()
    local nTotalButlerNum = SceneFamily:getButlerNum()

    self.m_bIsClickFunc = true 
    --如果建筑不在有效的位置上
    if not SceneFamily:canClickOperateFunc() then return end

    if nFreeButlerNum == 0 then
        if nTotalButlerNum == 0 then 
            MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT19)
            return 
        else
            MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT28)
            -- local tTempData = SceneFamily:getMinCDTimeBuildingData()
            -- local nCostValue = tTempData.basicData.speedup_price[1][2] * math.ceil(tTempData.countdown/60)
            -- local tCostBasicData = GDatatab_item["id_" .. tTempData.basicData.speedup_price[1][1]]

            -- MsgBoxManager:showConfirmBox(string.format(LocalStrings.FAMILY_TEXT8, nCostValue, tCostBasicData.name), self, self.sureToFreeOneButler)
        end
        return 
    end
    local tDataCost = tData.basicData.remove_cost
    if type(tDataCost) == "table" then  
        --判断消耗
        for i = 1, #tDataCost do
            if not JudgeMoneyIsEnough(tDataCost[i][1], tDataCost[i][2], nil, nil, GlobalGame.g_nCurrentUIChannelId) then
                return 
            end
        end
    end
    SceneFamily:_toRemoveBuilding(tData)
end

--@brief  点击收集回调
function WndFamilyOperate:onClickCollect(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_bIsClickFunc = true 
    --如果建筑不在有效的位置上
    if not SceneFamily:canClickOperateFunc() then return end

    local tData = SceneFamily.m_clickInfo.tData
    SceneFamily:toCollect(tData)

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(45)
    if isEndTeach ~= true then
        TeachGroup1:endTeachStep({45,8})
        TeachGroup1:startGroup({45,9,self.m_root})
    end
end

--@brief  点击出售回调
function WndFamilyOperate:onClickSell(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_bIsClickFunc = true 

end

--@brief  点击翻转回调
function WndFamilyOperate:onClickFlip(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_bIsClickFunc = true 
    --如果建筑不在有效的位置上
    if not SceneFamily:canClickOperateFunc() then return end

    if SceneFamily.m_clickInfo.tData.flipStatus == 0 then 
        SceneFamily.m_clickInfo.tData.flipStatus = 1
    elseif SceneFamily.m_clickInfo.tData.flipStatus == 1 then 
        SceneFamily.m_clickInfo.tData.flipStatus = 0 
    end
    SceneFamily.m_clickInfo.tCell:setBuildFlipX(SceneFamily.m_clickInfo.tData.flipStatus)
    SceneFamily:toFlip(SceneFamily.m_clickInfo.tData)
end

--@brief    点击饲养按钮回调
function WndFamilyOperate:onClickFeed(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_bIsClickFunc = true 

    WndFamilyTrain:showInterface(SceneFamily.m_clickInfo.tData)
end

--@brief    点击探险按钮回调
function WndFamilyOperate:onClickExplore(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_bIsClickFunc = true 

    WndFamilyTrain:showInterface(SceneFamily.m_clickInfo.tData)
end

--@brief    点击豪华度回调
function WndFamilyOperate:onClickSheerLuxury(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tData = GDatatab_item["id_65"]
    WndItemInfo:showInfo(element, self.m_root, 3, tData.name.."                     "..tData.desc,false, nil, true)
end

--@brief  点击更多佣人回调
function WndFamilyOperate:onClickMoreButler(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndFamilyShop:showInterface()

    local buildingCK = SceneFamily:getBuildingCellById(40300)
    WZLog("WndFamilyOperate:onClickMoreButler", tostring(buildingCK))
    if buildingCK == nil then
        TeachGroup1:endTeachStep({45,1})
    else
        TeachGroup1:endTeachStep({45,4})
    end
end

--@brief    加速确认框确认加速按钮回调
function WndFamilyOperate:sureToSpeed()
    -- body
    local tData = self.m_tOperateData
    local nCostValue = tData.basicData.speedup_price[1][2] * math.ceil(tData.countdown/60)
    if not JudgeMoneyIsEnough(tData.basicData.speedup_price[1][1], nCostValue, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
        return 
    end

    self:sureUseDiamondInstead()
end

--@brief    确认用礼钻代替钻石加速时间
function WndFamilyOperate:sureUseDiamondInstead()
    -- body
    WZLog("WndFamilyOperate:sureUseDiamondInstead")
    --发送协议，进行加速
    local tData = self.m_tOperateData 
    SceneFamily:_toSpeedUp(tData)
end

--@brief    确认取消正在建造、升级、移除的操作
function WndFamilyOperate:sureToCancel()
    -- body
    local tData = self.m_tOperateData
    if tData then
        --发送取消协议
        SceneFamily:toCancel(tData)
    end
end

--@brief    佣人不够确认用货币消除一个时间，空出佣人
function WndFamilyOperate:sureToFreeOneButler()
    -- body
    local tTempData = SceneFamily:getMinCDTimeBuildingData()
    local nCostValue = tTempData.basicData.speedup_price[1][2] * math.ceil(tTempData.countdown/60)
    if not JudgeMoneyIsEnough(tTempData.basicData.speedup_price[1][1], nCostValue, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamondToFreeButler) then
        return 
    end

    self:sureToUseDiamondToFreeButler()
end

--@brief    确定用钻石代替礼钻释放一个佣人
function WndFamilyOperate:sureToUseDiamondToFreeButler()
    -- body

end

--@brief    刷新界面的经验、豪华度、等级
function WndFamilyOperate:refreshInfoShow()
    -- body
    if self.m_root == nil then return end 
    self:_update()
end

--@brief  点击限时特惠礼包按钮回调
function WndFamilyOperate:OpenNewUserPackage(element)
    --body
    OpenNewUserPackage(element)
end

--@brief    点击打工按钮回调
function WndFamilyOperate:onClickWork(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndFamilyProduce:showInterface(0)
end

--@brief    点击看守按钮回调
function WndFamilyOperate:onClickProtect(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndFamilyProduce:showInterface(1)
end

--@brief    点击受伤信息按钮回调
function WndFamilyOperate:onClickHurt(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    local tRecoverConfig = json.decode(CacheCenter:getGameParam().homeThiefConfig) 
    local price = tRecoverConfig.recover
    local id, num = SplitItemString(price)
    local nCost = tonumber(num[1]) * math.ceil(SceneFamily.m_nRecoverTime/60)
    local costIcon= GDatatab_item["id_" .. id[1]].icon
    local sAttContent = string.format(LocalStrings.FAMILY_TEXT36, nCost, costIcon)
    MsgBoxManager:showConfirmBox(sAttContent, self, self.sureToSpeedToRecover)
end

--@brief    加速受伤时间恢复确认框确认加速按钮回调
function WndFamilyOperate:sureToSpeedToRecover()
    -- body
    local tRecoverConfig = json.decode(CacheCenter:getGameParam().homeThiefConfig) 
    local price = tRecoverConfig.recover
    local id, num = SplitItemString(price)
    local nCost = tonumber(num[1]) * math.ceil(SceneFamily.m_nRecoverTime/60)

    if not JudgeMoneyIsEnough(tonumber(id[1]), nCost, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamondSpeedRecover) then
        return 
    end

    self:sureToUseDiamondSpeedRecover()
end

--@brief    确定用钻石代替立钻加速疗伤
function WndFamilyOperate:sureToUseDiamondSpeedRecover()
    -- body
    --发送协议
    SceneFamily:_createLoading()
    ProtocolProcessorFamily:send_HOME_Cure( )
end

--@brief    点击盗贼日志按钮回调
function WndFamilyOperate:onClickStoleLog(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndFamilyProtectLog:showInterface()
end 
--进入牧场
function WndFamilyOperate:onClickPasture()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndPastureBusiness:showInterface(SceneFamily.m_nPlayerId)  
end
--@brief    点击好友家园按钮回调
function WndFamilyOperate:onClickFriendHome()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self.m_bIsClickFunc = true 
    local conRankList = GetElement(self.m_root, "conRankList_WndFamilyOperate", WZUIContainer)
    if self.m_nRankState == 0 then
        self.m_nRankState = 1 
        if self.m_nTag == nil then 
            self.m_nTag = 3
        end
        ProtocolProcessorFamily:send_HOME_GetHomeRankList(self.m_nTag)
        local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
        local nPositionX = 1 - 325/screenSize.width
        if IsIphoneX() then
            conRankList:setAnchorPoint(GlobalMethod:ccp(1,0.5))
            conRankList:setRelativePosition(GlobalMethod:ccp(0.95, 0.46))
        else
            conRankList:setAnchorPoint(GlobalMethod:ccp(1,0.5))
            conRankList:setRelativePosition(GlobalMethod:ccp(1, 0.46))
        end
        GetElement(self.m_root, "conForRankList_WndFamilyOperate", WZUIContainer):setVisible(true)

        GetElement(self.m_root,"editInputId_WndFamilyOperate",WZUIEditBox):setPlaceHolder(LocalStrings.MASTERINFO16)
        WZLog("WndFamilyOperate:onClickFriendHome", GlobalMethod:crossServiceOpen())
        if GlobalMethod:crossServiceOpen() == 0 then
            GetElement(self.m_root,"checkBox2",WZUICheckBox):setVisible(false)
        else
            GetElement(self.m_root,"checkBox2",WZUICheckBox):setVisible(true)
        end
    else
        self:hideRankList()
    end
end

--@brief    点击查找公会ID按钮时
function WndFamilyOperate:onClickFindCommunityId(element)
    WZLog(" WndFamilyOperate:onClickFindCommunityId")
    --音效
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local inputText = nil 
    local editInputId  = self.m_root:getChildElement("editInputId_WndFamilyOperate")
    if editInputId ~= nil then 
        editInputId = WZUIEditBox:luaTo(editInputId)
        if editInputId ~= nil then 
            inputText = editInputId:getText()
        end 
    end 
    if tonumber(inputText) ~= nil then     --输入全是数字
        --加载圆圈
        --self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
        --获取并显示公会信息
        ProtocolProcessorFamily:send_HOME_Search(tonumber(inputText) )
        --显示取消查找按钮
        GetElement(self.m_root,"btnCancelFind_WndFamilyOperate",WZUIButton):setVisible(true)
    elseif inputText == LocalStrings.MASTERINFO16 or inputText == "" then 
        MsgBoxManager:showTipBox(LocalStrings.MASTERINFO16)
    else  
        MsgBoxManager:showTipBox(LocalStrings.MASTERINFO22)
    end 
end 

function WndFamilyOperate:onCancelFind(element) 
    WZLog("WndFamilyOperate:onCancelFind", tonumber(self.m_nTag))
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --隐藏取消查找按钮
    GetElement(self.m_root,"btnCancelFind_WndFamilyOperate",WZUIButton):setVisible(false)
    --刷新界面
    ProtocolProcessorFamily:send_HOME_GetHomeRankList(tonumber(self.m_nTag))
     
    GetElement(self.m_root,"editInputId_WndFamilyOperate",WZUIEditBox):setText("")
    GetElement(self.m_root,"editInputId_WndFamilyOperate",WZUIEditBox):setPlaceHolder(LocalStrings.MASTERINFO16)
end

function WndFamilyOperate:onReward(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCompeteGift:showWnd(2)
end

function WndFamilyOperate:onTab(element) 
    WZLog("WndFamilyOperate:onTab",element:getTag())
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = tonumber(element:getTag())
    self.m_nTag = tag
    ProtocolProcessorFamily:send_HOME_GetHomeRankList(tag )
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief     添加顶部货币栏
function WndFamilyOperate:_addTop()
    -- body
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/common_icon_azgy.png", SceneFamily, SceneFamily.onClickClose, true, 1, true,nil, {goldType = 11})
    self.m_root:addChild(celElement)
end

--@brief    刷新
function WndFamilyOperate:_update()
    -- body
    local tLevelData = GDatatab_home_level_up["id_" .. SceneFamily.m_nFamilyLevel]
    --家园等级
    local txtFamilyLevel = GetElement(self.m_root, "txtFamilyLevel_WndFamilyOperate", WZUILabelTTF)
    if txtFamilyLevel then
        txtFamilyLevel:setText("Lv" .. SceneFamily.m_nFamilyLevel)
    end
    --家园名字、经验
    local txtFamilyName = GetElement(self.m_root, "txtFamilyName_WndFamilyOperate", WZUILabelTTF)
    if txtFamilyName then
        txtFamilyName:setText(SceneFamily.m_sFamilyName)
    end
    local txtExp = GetElement(self.m_root, "txtExp_WndFamilyOperate", WZUILabelTTF)
    if txtExp then
        txtExp:setText(SceneFamily.m_nFamilyExp .. "/" .. tLevelData.exp)
    end
    local prgExp = GetElement(self.m_root, "prgExp_WndFamilyOperate", WZUIProgress)
    if prgExp then
        prgExp:setPercentage(math.floor(100 * SceneFamily.m_nFamilyExp/tLevelData.exp))
    end
    --豪华度图标
    local imgSheerLuxuryIcon = GetElement(self.m_root, "imgSheerLuxuryIcon_WndFamilyOperate", WZUIImage)
    if imgSheerLuxuryIcon then
        imgSheerLuxuryIcon:setFile(GDatatab_item["id_65"].icon)
        imgSheerLuxuryIcon:setScale(0.7)
    end
    --豪华度
    local txtSheerLuxury = GetElement(self.m_root, "txtSheerLuxury_WndFamilyOperate", WZUILabelTTF)
    if txtSheerLuxury then
        txtSheerLuxury:setText(SceneFamily.m_nFamilySheerLuxury)
    end
    --佣人数量
    self:showButlerNum()
    --照相按钮
    self:_whetherShowShareBtn()
    --受伤状态以及受伤恢复时间
    self:_showHurtState()
end

--@brief    显示佣人数量
function WndFamilyOperate:showButlerNum()
    -- body
    if self.m_root == nil then return end 
    --佣人数量
    local txtButlerNum = GetElement(self.m_root, "txtButlerNum_WndFamilyOperate", WZUILabelTTF)
    local nTotalButlerNum = SceneFamily:getButlerNum() 
    local nFreeButlerNum = SceneFamily:getFreeButlerNum()
    if txtButlerNum then
        txtButlerNum:setText(nFreeButlerNum .. "/" .. nTotalButlerNum)
    end
end

--@brief    获取按钮节点
function WndFamilyOperate:_getBtnNode()
    -- body
    if self.m_tBtnList == nil then 
        self.m_tBtnList = {} 
    end

    local btnInfo = GetElement(self.m_root, "btnInfo_WndFamilyOperate", WZUIButton)
    local btnSpeed = GetElement(self.m_root, "btnSpeed_WndFamilyOperate", WZUIButton)
    local btnUpgrade = GetElement(self.m_root, "btnUpgrade_WndFamilyOperate", WZUIButton)
    local btnCancel = GetElement(self.m_root, "btnCancel_WndFamilyOperate", WZUIButton)
    local btnRemove = GetElement(self.m_root, "btnRemove_WndFamilyOperate", WZUIButton)
    local btnSell = GetElement(self.m_root, "btnSell_WndFamilyOperate", WZUIButton)
    local btnCollect = GetElement(self.m_root, "btnCollect_WndFamilyOperate", WZUIButton)
    local btnFlip = GetElement(self.m_root, "btnFlip_WndFamilyOperate", WZUIButton)
    local btnFeed = GetElement(self.m_root, "btnFeed_WndFamilyOperate", WZUIButton)
    local btnExplore = GetElement(self.m_root, "btnExplore_WndFamilyOperate", WZUIButton)
    local btnWork = GetElement(self.m_root, "btnWork_WndFamilyOperate", WZUIButton)
    local btnProtect = GetElement(self.m_root, "btnProtect_WndFamilyOperate", WZUIButton)
    local btnStoleLog = GetElement(self.m_root, "btnStoleLog_WndFamilyOperate", WZUIButton)
    local btnPasture = GetElement(self.m_root, "btnPasture_WndFamilyOperate", WZUIButton)

    self.m_tBtnList[1] = btnInfo    --信息
    self.m_tBtnList[2] = btnSpeed   --加速
    self.m_tBtnList[3] = btnUpgrade --升级
    self.m_tBtnList[4] = btnCancel  --取消
    self.m_tBtnList[5] = btnRemove  --移除
    self.m_tBtnList[6] = btnSell    --出售
    self.m_tBtnList[7] = btnCollect --收集
    self.m_tBtnList[8] = btnFlip    --翻转
    self.m_tBtnList[9] = btnFeed    --饲养
    self.m_tBtnList[10] = btnExplore    --探险
    self.m_tBtnList[11] = btnWork    --打工
    self.m_tBtnList[12] = btnProtect    --看守
    self.m_tBtnList[13] = btnStoleLog    --盗贼日志
    self.m_tBtnList[14] = btnPasture    --进入牧场

end

--@brief    根据不同的功能建筑，不同的状态，显示不同的功能按钮
function WndFamilyOperate:_showFuncBtnList()
    -- body
    local txtBuildingName = GetElement(self.m_root, "txtBuildingName_WndFamilyOperate", WZUILabelTTF)

    for i = 1, #self.m_tBtnList do
        self.m_tBtnList[i]:setVisible(false)
    end
    txtBuildingName:setVisible(false)
    if SceneFamily.m_clickInfo == nil or SceneFamily.m_clickInfo == {} then
        return 
    end

    local tData = SceneFamily.m_clickInfo.tData 
    --建筑的名字和等级
    txtBuildingName:setVisible(true)
    txtBuildingName:setText(tData.basicInfo.name .. "(" .. tData.basicData.level .. LocalStrings.LEVEL1 .. ")")
    local tBtnIndex = {}
    tBtnIndex[1] = 1 
    if tData.basicData.type == 0 then
        if tData.buildingStatus == 0 and tData.countdown == 0 then  --可升级
            if tData.basicData.post_id ~= -1 then 
                tBtnIndex[2] = 3
            end
        elseif (tData.buildingStatus == 1 or tData.buildingStatus == 2 or tData.buildingStatus == 3) and tData.countdown > 0 then  --升级中
            tBtnIndex[2] = 4
            tBtnIndex[3] = 2
        end
    elseif tData.basicData.type == 1 then
        if tData.configId == 40509 then 
            if (tData.buildingStatus == 1 or tData.buildingStatus == 2 or tData.buildingStatus == 3) and tData.countdown > 0 then  --建造中
                tBtnIndex[2] = 4
                tBtnIndex[3] = 2
            end
        elseif tData.configId >= 40900 and tData.configId <= 40919 then 
            if (tData.buildingStatus == 1 or tData.buildingStatus == 2 or tData.buildingStatus == 3) and tData.countdown > 0 then  --建造中
                tBtnIndex[2] = 4
                tBtnIndex[3] = 2
            else
                tBtnIndex[2] = 14
            end
        else
            if tData.buildingStatus == 0 then  --可升级
                if tData.basicData.post_id ~= -1 then 
                    tBtnIndex[2] = 3
                    if tData.basicData.sub_type == 1 or tData.basicData.sub_type == 2 then
                        tBtnIndex[3] = 7
                    elseif tData.basicData.sub_type == 5 then 
                        tBtnIndex[3] = 9
                    elseif tData.basicData.sub_type == 6 then
                        tBtnIndex[3] = 10 
                    elseif tData.basicData.sub_type == 7 then 
                        tBtnIndex[3] = 11
                        tBtnIndex[4] = 12
                        tBtnIndex[5] = 13
                    end
                else
                    if tData.basicData.sub_type == 1 or tData.basicData.sub_type == 2 then
                        tBtnIndex[2] = 7
                    elseif tData.basicData.sub_type == 5 then 
                        tBtnIndex[2] = 9
                    elseif tData.basicData.sub_type == 6 then 
                        tBtnIndex[2] = 10
                    elseif tData.basicData.sub_type == 7 then 
                        tBtnIndex[2] = 11
                        tBtnIndex[3] = 12
                        tBtnIndex[4] = 13
                    end
                end
            elseif (tData.buildingStatus == 1 or tData.buildingStatus == 2 or tData.buildingStatus == 3) and tData.countdown > 0 then  --建造中、升级中、拆除中
                if tData.basicData.sub_type == 7 then 
                    tBtnIndex[2] = 11
                    tBtnIndex[3] = 12
                    tBtnIndex[4] = 4
                    tBtnIndex[5] = 2
                    tBtnIndex[6] = 13
                else
                    tBtnIndex[2] = 4
                    tBtnIndex[3] = 2
                end
            elseif tData.basicData.sub_type == 5 then 
                tBtnIndex[2] = 9
            elseif tData.basicData.sub_type == 6 then 
                tBtnIndex[2] = 10
            end
        end
    elseif tData.basicData.type == 2 then
        if tData.buildingStatus == 0 then  --可升级
            tBtnIndex[2] = 5
            tBtnIndex[3] = 8
        else
            tBtnIndex[2] = 4
            tBtnIndex[3] = 2
        end
    elseif tData.basicData.type == 3 then
        if tData.buildingStatus == 0 and tData.countdown == 0 then  --可移除
            tBtnIndex[2] = 5
        elseif (tData.buildingStatus == 1 or tData.buildingStatus == 2 or tData.buildingStatus == 3) and tData.countdown > 0 then  --移除中
            tBtnIndex[2] = 4
            tBtnIndex[3] = 2
        end
    end

    --显示按钮
    local nBtnNum = GetTableLen(tBtnIndex)
    local conBottom = GetElement(self.m_root, "conBottom_WndFamilyOperate", WZUIContainer)
    local nBtnWidth = 120
    conBottom:setAbsContentSize(GlobalMethod:CCSize(nBtnNum * nBtnWidth, 130))
    conBottom:setContentSize(GlobalMethod:CCSize(nBtnNum * nBtnWidth, 130))
    conBottom:updateRelativeSize()
    WZLog("WndFamilyOperate:_showFuncBtnList", nBtnNum)
    local sCostFormat = [[<I Z="0.4" P="1">%s</I><T S="16" C="255,255,255" P="1" SC="105,65,46" SS="4" SE="1">%d</T>]]
    for i = 1, nBtnNum do
        self.m_tBtnList[tBtnIndex[i]]:setVisible(true)
        self.m_tBtnList[tBtnIndex[i]]:setRelativePosition(GlobalMethod:ccp(1/(nBtnNum * 2) + (i - 1) * (1/nBtnNum), 0.5))
        if tBtnIndex[i] == 2 then --加速
            local ftxtSpeedCost = GetElement(self.m_root, "ftxtSpeedCost_WndFamilyOperate", WZUIFreeTextBox)
            local nCostValue = tData.basicData.speedup_price[1][2] * math.ceil(tData.countdown/60)
            local tCostBasicData = GDatatab_item["id_" .. tData.basicData.speedup_price[1][1]]
            if ftxtSpeedCost then
                ftxtSpeedCost:setShowText(string.format(sCostFormat, tCostBasicData.icon, nCostValue))
            end
        elseif tBtnIndex[i] == 3 then --升级
            local ftxtUpgradeCost = GetElement(self.m_root, "ftxtUpgradeCost_WndFamilyOperate", WZUIFreeTextBox)
            local nCostValue = tData.basicData.upgrade_cost[1][2]
            local tCostBasicData = GDatatab_item["id_" .. tData.basicData.upgrade_cost[1][1]]
            if ftxtUpgradeCost then
                ftxtUpgradeCost:setShowText(string.format(sCostFormat, tCostBasicData.icon, nCostValue))
            end
        elseif tBtnIndex[i] == 5 then --移除
            local ftxtRemoveCost = GetElement(self.m_root, "ftxtRemoveCost_WndFamilyOperate", WZUIFreeTextBox)
            local nCostValue = tData.basicData.remove_cost[1][2]
            local tCostBasicData = GDatatab_item["id_" .. tData.basicData.remove_cost[1][1]]
            if ftxtRemoveCost then
                ftxtRemoveCost:setShowText(string.format(sCostFormat, tCostBasicData.icon, nCostValue))
            end
        elseif tBtnIndex[i] == 7 then --收集
            local imgCoinType = GetElement(self.m_root, "imgCoinType_WndFamilyOperate", WZUIImage)
            local tCollectId = tData.basicData.functions[1][2]
            if imgCoinType then
                imgCoinType:setFile(GDatatab_item["id_" .. tCollectId].icon)
            end
        end
    end
end

--@brief    设置操作界面的按钮是否可见
function WndFamilyOperate:_setNodeVisible()
    -- body
    --判断是否显示回家按钮，如果在别人家园的话
    local btnGoHome = GetElement(self.m_root, "btnGoHome_WndFamilyOperate", WZUIButton)
    if SceneFamily.m_nPlayerId ~= CacheCenter:getPlayerInfo().id then
        if CacheCenter:getPlayerInfo().homeLevel > 0 then 
            btnGoHome:setVisible(true)
        end
        GetElement(self.m_root, "conRight_WndFamilyOperate", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conBottom_WndFamilyOperate", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conTopMid_WndFamilyOperate", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conButler_WndFamilyOperate", WZUIContainer):setVisible(false)
    else
        btnGoHome:setVisible(false)
        GetElement(self.m_root, "conRight_WndFamilyOperate", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conBottom_WndFamilyOperate", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conTopMid_WndFamilyOperate", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conButler_WndFamilyOperate", WZUIContainer):setVisible(true)
    end
end

--@brief    照相按钮的显示与否
function WndFamilyOperate:_whetherShowShareBtn()
    -- body
    -- if CanWeChatShare() then 
    --     GetElement(self.m_root, "btnPhoto_WndFamilyOperate", WZUIButton):setVisible(true)
    -- else
        GetElement(self.m_root, "btnPhoto_WndFamilyOperate", WZUIButton):setVisible(false)
--    end
end

--适配iphoneX
function WndFamilyOperate:_AdaptationIphoneX()
    -- body
    WZLog("WndFamilyOperate:_AdaptationIphoneX")
    if IsIphoneX() then
        local conLeft = GetElement(self.m_root,"conLeft_WndFamilyOperate",WZUIContainer)
        conLeft:setRelativePosition(GlobalMethod:ccp(0.045,1))

        local conRightButtom = GetElement(self.m_root,"conRightButtom_WndFamilyOperate",WZUIContainer)
        conRightButtom:setRelativePosition(GlobalMethod:ccp(0.97,0.028125))
        
        local conRankList = GetElement(self.m_root,"conRankList_WndFamilyOperate",WZUIContainer)
        conRankList:setRelativePosition(GlobalMethod:ccp(0.95, 0.46))
    end
end

--@brief 设置受伤状态
function WndFamilyOperate:_showHurtState()
    -- body
    local btnHurt = GetElement(self.m_root, "btnHurt_WndFamilyOperate", WZUIButton)
    if btnHurt then
        if SceneFamily.m_nRecoverTime and SceneFamily.m_nRecoverTime > 0 then
            btnHurt:setVisible(true)
            self:_showRecoverTime()
        else
            btnHurt:setVisible(false)
        end
    end

    --设置位置
    if SceneFamily.m_nPlayerId ~= CacheCenter:getPlayerInfo().id then
        if SceneFamily.m_nRecoverTime and SceneFamily.m_nRecoverTime > 0 then
            GetElement(self.m_root, "btnGoHome_WndFamilyOperate", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.177,-0.244))
            btnHurt:setRelativePosition(GlobalMethod:ccp(0.346,0.032))
        else
            GetElement(self.m_root, "btnGoHome_WndFamilyOperate", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.177,-0.008))
            btnHurt:setRelativePosition(GlobalMethod:ccp(0.346,-0.224))
        end
    else
        btnHurt:setRelativePosition(GlobalMethod:ccp(0.346,-0.224))
    end
end

--@brief    展示受伤恢复时间
function WndFamilyOperate:_showRecoverTime()
    -- body
    if SceneFamily.m_nRecoverTime == nil then return end 

    local hours,minutes,seconds
    hours = math.floor(SceneFamily.m_nRecoverTime/3600)
    minutes = math.floor((SceneFamily.m_nRecoverTime%3600)/60)
    seconds = SceneFamily.m_nRecoverTime%60
    local content = string.format("%d:%02d:%02d", hours, minutes, seconds)
    if SceneFamily.m_nRecoverTime < 10 * 3600 then 
        content = string.format("%02d:%02d:%02d", hours, minutes, seconds)
    end
    self.m_txtRecoverTime:setText(content)
end

--@brief    受伤恢复时间倒计时
function WndFamilyOperate:_recoverTimeCaculate()
    -- body
    if SceneFamily.m_nRecoverTime == nil then
        self.m_root:disableSchedule()
        return 
    end

    self:_showRecoverTime()
    if SceneFamily.m_nRecoverTime > 0 then
        SceneFamily.m_nRecoverTime = SceneFamily.m_nRecoverTime - 1
    else
        self:_showHurtState()
        self.m_root:disableSchedule()
    end
end

function WndFamilyOperate:showRank() 
    if self.m_root == nil then return end
    local tbCon = GetElement(self.m_root,"tbcon_WndFamilyOperate",WZUITableContainer)
    tbCon:cleanTable()

    --没有数据时显示提示
    if self.m_tDataList == nil or #self.m_tDataList == 0 then 
        ShowPanelNullTip(tbCon,nil,GlobalMethod:ccc3(255,236,193))
    else
        removeShowPanelNullTip(tbCon)
    end

    for i = 1, #self.m_tDataList do
        local celElement, tCell = CellFamilyRankNew:createElement()
        if celElement ~= nil and tCell ~= nil then 
            celElement = WZUIContainer:luaTo(celElement)
            tCell:setData(self.m_tDataList[i])
            celElement:setTag(i - 1)
            tbCon:setCellElement(celElement)
        end 
    end

    tbCon:getMoveElement():setPositionY(tbCon:getMinPosition().y)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin---------------------------------------------
function WndFamilyOperate:_adaptLanguage_vn(  )
    local editInputId = GetElement(self.m_root,"editInputId_WndFamilyOperate",WZUIEditBox)
    editInputId:setRelativeSize(GlobalMethod:CCSize(0.8,1))
    editInputId:setRelativePosition(GlobalMethod:ccp(0.38,0.5))
end

function WndFamilyOperate:_adaptLanguage_en(  )
    local editInputId = GetElement(self.m_root,"editInputId_WndFamilyOperate",WZUIEditBox)
    editInputId:setRelativeSize(GlobalMethod:CCSize(0.8,1))
    editInputId:setRelativePosition(GlobalMethod:ccp(0.38,0.5))

    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(130))
    txtIntensify1:setScale(0.6)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(130))
    txtIntensify2:setScale(0.6)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
    txtTransfer1:setDimensions(GlobalMethod:CCSize(130))
    txtTransfer1:setScale(0.6)
    txtTransfer1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
    txtTransfer2:setDimensions(GlobalMethod:CCSize(130))
    txtTransfer2:setScale(0.6)
    txtTransfer2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer3 = GetElement(self.m_root,"txtTransfer3_WndStrengthen",WZUILabelTTF)
    txtTransfer3:setDimensions(GlobalMethod:CCSize(130))
    txtTransfer3:setScale(0.6)
    txtTransfer3:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer4 = GetElement(self.m_root,"txtTransfer4_WndStrengthen",WZUILabelTTF)
    txtTransfer4:setDimensions(GlobalMethod:CCSize(130))
    txtTransfer4:setScale(0.6)
    txtTransfer4:setRelativePosition(GlobalMethod:ccp(0.5,0.49))

    local txtFriendHome = GetElement(self.m_root,"txtFriendHome_WndFamilyOperate",WZUILabelTTF)
    txtFriendHome:setScale(0.6)
    txtFriendHome:setDimensions(GlobalMethod:CCSize(64))
    GetElement(self.m_root,"txtRankReward_WndFamilyOperate",WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"txtWork_WndFamilyOperate",WZUILabelTTF):setScale(0.8)
    
end

function WndFamilyOperate:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtFriendHome_WndFamilyOperate",WZUILabelTTF):setScale(0.7)
end

function WndFamilyOperate:_adaptLanguage_es(  )
    local editInputId = GetElement(self.m_root,"editInputId_WndFamilyOperate",WZUIEditBox)
    editInputId:setRelativeSize(GlobalMethod:CCSize(0.8,1))
    editInputId:setRelativePosition(GlobalMethod:ccp(0.38,0.5))

    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify1:setScale(0.8)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify2:setScale(0.8)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
    txtTransfer1:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer1:setScale(0.8)
    txtTransfer1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
    txtTransfer2:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer2:setScale(0.8)
    txtTransfer2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer3 = GetElement(self.m_root,"txtTransfer3_WndStrengthen",WZUILabelTTF)
    txtTransfer3:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer3:setScale(0.8)
    txtTransfer3:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer4 = GetElement(self.m_root,"txtTransfer4_WndStrengthen",WZUILabelTTF)
    txtTransfer4:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer4:setScale(0.8)
    txtTransfer4:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    
    local txtFriendHome = GetElement(self.m_root,"txtFriendHome_WndFamilyOperate",WZUILabelTTF)
    txtFriendHome:setScale(0.6)
    txtFriendHome:setDimensions(GlobalMethod:CCSize(64))

    local txtRankReward = GetElement(self.m_root,"txtRankReward_WndFamilyOperate",WZUILabelTTF)
    txtRankReward:setScale(0.7)
    txtRankReward:setDimensions(GlobalMethod:CCSize(100))
    
    GetElement(self.m_root,"txtStoleLog_WndFamilyOperate",WZUILabelTTF):setScale(0.65)
end

function WndFamilyOperate:_adaptLanguage_pt(  )
    local editInputId = GetElement(self.m_root,"editInputId_WndFamilyOperate",WZUIEditBox)
    editInputId:setRelativeSize(GlobalMethod:CCSize(0.8,1))
    editInputId:setRelativePosition(GlobalMethod:ccp(0.38,0.5))

    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify1:setScale(0.8)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify2:setScale(0.8)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
    txtTransfer1:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer1:setScale(0.8)
    txtTransfer1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
    txtTransfer2:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer2:setScale(0.8)
    txtTransfer2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer3 = GetElement(self.m_root,"txtTransfer3_WndStrengthen",WZUILabelTTF)
    txtTransfer3:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer3:setScale(0.8)
    txtTransfer3:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer4 = GetElement(self.m_root,"txtTransfer4_WndStrengthen",WZUILabelTTF)
    txtTransfer4:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer4:setScale(0.8)
    txtTransfer4:setRelativePosition(GlobalMethod:ccp(0.5,0.49))

    local txtFriendHome = GetElement(self.m_root,"txtFriendHome_WndFamilyOperate",WZUILabelTTF)
    txtFriendHome:setScale(0.6)
    txtFriendHome:setDimensions(GlobalMethod:CCSize(64))

    local txtRankReward = GetElement(self.m_root,"txtRankReward_WndFamilyOperate",WZUILabelTTF)
    txtRankReward:setScale(0.7)
    txtRankReward:setDimensions(GlobalMethod:CCSize(100))

    GetElement(self.m_root,"txtStoleLog_WndFamilyOperate",WZUILabelTTF):setScale(0.65)
    
end

function WndFamilyOperate:_adaptLanguage_tr(  )
    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify1:setScale(0.8)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify2:setScale(0.8)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
    txtTransfer1:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer1:setScale(0.8)
    txtTransfer1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
    txtTransfer2:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer2:setScale(0.8)
    txtTransfer2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer3 = GetElement(self.m_root,"txtTransfer3_WndStrengthen",WZUILabelTTF)
    txtTransfer3:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer3:setScale(0.8)
    txtTransfer3:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer4 = GetElement(self.m_root,"txtTransfer4_WndStrengthen",WZUILabelTTF)
    txtTransfer4:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer4:setScale(0.8)
    txtTransfer4:setRelativePosition(GlobalMethod:ccp(0.5,0.49))

    local txtRankReward = GetElement(self.m_root,"txtRankReward_WndFamilyOperate",WZUILabelTTF)
    txtRankReward:setScale(0.8)
    txtRankReward:setDimensions(GlobalMethod:CCSize(120))

    local conFindId = GetElement(self.m_root,"conFindId_WndFamilyOperate",WZUIContainer)
    conFindId:setAbsContentSize(GlobalMethod:CCSize(200,35))
    conFindId:updateRelativeSize()
end

function WndFamilyOperate:_adaptLanguage_ug(  )
    local editInputId = GetElement(self.m_root,"editInputId_WndFamilyOperate",WZUIEditBox)
    editInputId:setRelativeSize(GlobalMethod:CCSize(0.8,1))
    editInputId:setRelativePosition(GlobalMethod:ccp(0.38,0.5))

    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(130))
    txtIntensify1:setScale(0.6)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(130))
    txtIntensify2:setScale(0.6)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
    txtTransfer1:setDimensions(GlobalMethod:CCSize(130))
    txtTransfer1:setScale(0.6)
    txtTransfer1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
    txtTransfer2:setDimensions(GlobalMethod:CCSize(130))
    txtTransfer2:setScale(0.6)
    txtTransfer2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer3 = GetElement(self.m_root,"txtTransfer3_WndStrengthen",WZUILabelTTF)
    txtTransfer3:setDimensions(GlobalMethod:CCSize(130))
    txtTransfer3:setScale(0.6)
    txtTransfer3:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer4 = GetElement(self.m_root,"txtTransfer4_WndStrengthen",WZUILabelTTF)
    txtTransfer4:setDimensions(GlobalMethod:CCSize(130))
    txtTransfer4:setScale(0.6)
    txtTransfer4:setRelativePosition(GlobalMethod:ccp(0.5,0.49))

    local txtFriendHome = GetElement(self.m_root,"txtFriendHome_WndFamilyOperate",WZUILabelTTF)
    txtFriendHome:setScale(0.6)
    txtFriendHome:setDimensions(GlobalMethod:CCSize(64))
    local txtRankReward = GetElement(self.m_root,"txtRankReward_WndFamilyOperate",WZUILabelTTF)
    txtRankReward:setScale(0.7)
    txtRankReward:setDimensions(GlobalMethod:CCSize(120))

    GetElement(self.m_root,"txtWork_WndFamilyOperate",WZUILabelTTF):setScale(0.8)
    
    local txtStoleLog = GetElement(self.m_root,"txtStoleLog_WndFamilyOperate",WZUILabelTTF)
    txtStoleLog:setDimensions(GlobalMethod:CCSize(160))
    txtStoleLog:setScale(0.6)
    local txtProtect = GetElement(self.m_root,"txtProtect_WndFamilyOperate",WZUILabelTTF)
    txtProtect:setDimensions(GlobalMethod:CCSize(160))
    txtProtect:setScale(0.6)
    local txtWork = GetElement(self.m_root,"txtWork_WndFamilyOperate",WZUILabelTTF)
    txtWork:setDimensions(GlobalMethod:CCSize(160))
    txtWork:setScale(0.6)
    local txtExplore = GetElement(self.m_root,"txtExplore_WndFamilyOperate",WZUILabelTTF)
    txtExplore:setDimensions(GlobalMethod:CCSize(160))
    txtExplore:setScale(0.6)
    local txtFeed = GetElement(self.m_root,"txtFeed_WndFamilyOperate",WZUILabelTTF)
    txtFeed:setDimensions(GlobalMethod:CCSize(160))
    txtFeed:setScale(0.6)
    local txtFlip = GetElement(self.m_root,"txtFlip_WndFamilyOperate",WZUILabelTTF)
    txtFlip:setDimensions(GlobalMethod:CCSize(160))
    txtFlip:setScale(0.6)
    local txtCollect = GetElement(self.m_root,"txtCollect_WndFamilyOperate",WZUILabelTTF)
    txtCollect:setDimensions(GlobalMethod:CCSize(160))
    txtCollect:setScale(0.6)
    local txtSell = GetElement(self.m_root,"txtSell_WndFamilyOperate",WZUILabelTTF)
    txtSell:setDimensions(GlobalMethod:CCSize(160))
    txtSell:setScale(0.6)
    local txtRemove = GetElement(self.m_root,"txtRemove_WndFamilyOperate",WZUILabelTTF)
    txtRemove:setDimensions(GlobalMethod:CCSize(160))
    txtRemove:setScale(0.6)
    local txtCancel = GetElement(self.m_root,"txtCancel_WndFamilyOperate",WZUILabelTTF)
    txtCancel:setDimensions(GlobalMethod:CCSize(160))
    txtCancel:setScale(0.6)
    local txtUpgrade = GetElement(self.m_root,"txtUpgrade_WndFamilyOperate",WZUILabelTTF)
    txtUpgrade:setDimensions(GlobalMethod:CCSize(160))
    txtUpgrade:setScale(0.6)
    local txtSpeed = GetElement(self.m_root,"txtSpeed_WndFamilyOperate",WZUILabelTTF)
    txtSpeed:setDimensions(GlobalMethod:CCSize(160))
    txtSpeed:setScale(0.6)
    local txtInfo = GetElement(self.m_root,"txtInfo_WndFamilyOperate",WZUILabelTTF)
    txtInfo:setDimensions(GlobalMethod:CCSize(160))
    txtInfo:setScale(0.6)
    
end
-------------------------------------语言适配End---------------------------------------------------