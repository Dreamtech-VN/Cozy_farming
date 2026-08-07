--WndKidOperate.lua
--@brief	WndKidOperate的UI模块
--@date		2018/05/07
--@author	Tianxiang_Xu
--@note		小家操作界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKidOperate:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKidOperate:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndKidOperate:onEnterTransitionDidFinish(element)
    -- body
    self:_AdaptationIphoneX()
    AdaptLanguage(self)

    self:_getBtnNode()
    self:_addTop()

    self:showUIByType()

    self:updateRedDot()
end

--@brief    更新红点
function WndKidOperate:updateRedDot()
    if self.m_root == nil then
        return
    end
    if GlobalGame.g_tRedPointList.schoolApplyWaiting or GlobalGame.g_tRedPointList.schoolApplyPass then
        GetElement(self.m_root,"imgSchoolRedDot_WndKidOperate",WZUIImage):setVisible(true)
    else
        GetElement(self.m_root,"imgSchoolRedDot_WndKidOperate",WZUIImage):setVisible(false)
    end 
end

--@brief    根据类型显示界面
function WndKidOperate:showUIByType()
    --小孩学校按钮
    if CheckButtonOpen(199, true) then
        local btnSchool = GetElement(self.m_root, "btnSchool_WndKidOperate", WZUIButton)
        btnSchool:setVisible(true)
    end
end

--@brief    点击好友家园按钮回调
function WndKidOperate:onClickFriendHome()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self.m_bIsClickFunc = true 
    local conRankList = GetElement(self.m_root, "conRankList_WndKidOperate", WZUIContainer)
    if self.m_nRankState == 0 then
        self.m_nRankState = 1 
        if self.m_nTag == nil then 
            self.m_nTag = 3
        end
        local nIndex = GetElement(self.m_root, "checkGroup_WndKidOperate", WZUICheckBoxGroup):getCheckIndex()
        WZLog("WndKidOperate:onClickFriendHome", self.m_nTag, nIndex)
        ProtocolProcessorKid:send_WWEDDING_GetHouseRankInfo(self.m_nTag)

        local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
        local nPositionX = 1 - 325/screenSize.width
        if IsIphoneX() then
            conRankList:setAnchorPoint(GlobalMethod:ccp(1,0.5))
            conRankList:setRelativePosition(GlobalMethod:ccp(0.95, 0.46))
        else
            conRankList:setAnchorPoint(GlobalMethod:ccp(1,0.5))
            conRankList:setRelativePosition(GlobalMethod:ccp(1, 0.46))
        end
        GetElement(self.m_root, "conForRankList_WndKidOperate", WZUIContainer):setVisible(true)

        GetElement(self.m_root,"editInputId_WndKidOperate",WZUIEditBox):setPlaceHolder(LocalStrings.MASTERINFO16)
        WZLog("WndKidOperate:onClickFriendHome", GlobalMethod:crossServiceOpen())
        if GlobalMethod:crossServiceOpen() == 0 then
            GetElement(self.m_root,"checkBox2_WndKidOperate",WZUICheckBox):setVisible(false)
        else
            GetElement(self.m_root,"checkBox2_WndKidOperate",WZUICheckBox):setVisible(true)
        end
    else
        self:hideRankList()
    end
end

--@brief    点击查找好友ID按钮时
function WndKidOperate:onClickFindCommunityId(element)
    WZLog(" WndKidOperate:onClickFindCommunityId")
    --音效
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local inputText = nil 
    local editInputId  = self.m_root:getChildElement("editInputId_WndKidOperate")
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
        GetElement(self.m_root,"btnCancelFind_WndKidOperate",WZUIButton):setVisible(true)
    elseif inputText == LocalStrings.MASTERINFO16 or inputText == "" then 
        MsgBoxManager:showTipBox(LocalStrings.MASTERINFO16)
    else  
        MsgBoxManager:showTipBox(LocalStrings.MASTERINFO22)
    end 
end 

function WndKidOperate:onCancelFind(element) 
    WZLog("WndKidOperate:onCancelFind", tonumber(self.m_nTag))
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --隐藏取消查找按钮
    GetElement(self.m_root,"btnCancelFind_WndKidOperate",WZUIButton):setVisible(false)
    --刷新界面
    ProtocolProcessorKid:send_WWEDDING_GetHouseRankInfo(tonumber(self.m_nTag))
     
    GetElement(self.m_root,"editInputId_WndKidOperate",WZUIEditBox):setText("")
    GetElement(self.m_root,"editInputId_WndKidOperate",WZUIEditBox):setPlaceHolder(LocalStrings.MASTERINFO16)
end

function WndKidOperate:onReward(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCompeteGift:showWnd(3)
end

function WndKidOperate:onTab(element) 
    WZLog("WndKidOperate:onTab",element:getTag())
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = tonumber(element:getTag())
    self.m_nTag = tag
    ProtocolProcessorKid:send_WWEDDING_GetHouseRankInfo(tag)
end

--@brief 	点击关爱按钮回调
function WndKidOperate:onClickCare(element) 
    WZLog("WndKidOperate:onClickCare",element:getTag())
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_bIsClickFunc = true 
    if SceneKidHome.m_tKidData == nil or #SceneKidHome.m_tKidData == 0 then 
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT8)
        self.m_bIsClickFunc = false 
    	return 
    end

    WndParentsCare:showInterface(1)
end

--@brief 	点击管理按钮回调
function WndKidOperate:onClickManager(element) 
    WZLog("WndKidOperate:onClickManager")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_bIsClickFunc = true 

    WndKidManager:showInterface(1)
end

--@brief    点击学校按钮回调
function WndKidOperate:onClickSchool(element) 
    WZLog("WndKidOperate:onClickSchool")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if SceneKidHome.m_tKidData == nil or #SceneKidHome.m_tKidData == 0 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT130)
        return
    end

    ProtocolProcessorKidSchool:send_SCHOOL_EntrySchool(0)
end

--@brief  点击回家按钮回调
function WndKidOperate:onClickGoHome2(element)
    WZLog("WndKidOperate:onClickGoHome2")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    SceneKidHome:showInterface()
end

function WndKidOperate:checkPointInBtn(pt)
    if self.m_root == nil then return end
    local btn = GetElement(self.m_root, "conRankList_WndKidOperate", WZUIContainer)
    if btn == nil then return false end
    local btnSize = btn:getContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        return true
    end 

    btn = GetElement(self.m_root, "btnFriendHome_WndKidOperate", WZUIButton)
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
function WndKidOperate:showOtherInfo()
    -- body
    GetElement(self.m_root, "conOutSide_WndKidOperate", WZUIContainer):setVisible(true)
    self:_setNodeVisible()
    self:_update()
end

--@brief    点击箭头回调
function WndKidOperate:onClickArrow(element)
    --body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    self:onClickBabyHeadCallBack()
end

--@brief    点击孩子头像回调
function WndKidOperate:onClickBabyHeadCallBack(tCell, tData)
    -- body
    if WndKidOperate.m_root == nil then return end 

    if self.m_nBabyInfoState == 0 then
        self.m_nBabyInfoState = 1
    else
        self.m_nBabyInfoState = 0
    end

    for i = 1, #self.m_tCellKid do
        local imgArrowHead = GetElement(self.m_root, "imgArrowHead" .. i .. "_WndKidOperate", WZUIImage)
        if self.m_nBabyInfoState == 0 then
            GetElement(self.m_root, "img9Bk" .. i .. "_WndKidOperate", WZUI9Image):setVisible(false)
            imgArrowHead:setRelativePosition(GlobalMethod:ccp(0.44,0.5))
            imgArrowHead:setRotation(180)
            self.m_tCellKid[i]:setInfoState(false)
        else
            GetElement(self.m_root, "img9Bk" .. i .. "_WndKidOperate", WZUI9Image):setVisible(true)
            imgArrowHead:setRelativePosition(GlobalMethod:ccp(1.084,0.5))
            imgArrowHead:setRotation(0)
            self.m_tCellKid[i]:setInfoState(true)
        end 
    end
end

--@brief    点击建筑，对底部按钮添加相应的按钮操作
function WndKidOperate:onClickBuildingCallBack()
    self:_showFuncBtnList()
end

--@brief  点击信息回调
function WndKidOperate:onClickInfo(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    --如果建筑不在有效的位置上
    if SceneKidHome.m_clickInfo.tData.basicData.type == 1 then
        if not SceneKidHome:canClickOperateFunc() then return end
    end

    self.m_bIsClickFunc = true 
    WndBuildingInfo:showInterface(SceneKidHome.m_clickInfo.tData, 2)
end

--@brief    点击摇摇车按钮回调
function WndKidOperate:onClickPlayCar(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    --如果建筑不在有效的位置上
    if not SceneKidHome:canClickOperateFunc() then return end

    self.m_bIsClickFunc = true 
    if SceneKidHome.m_tKidData == nil or #SceneKidHome.m_tKidData == 0 then 
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT73)
        self.m_bIsClickFunc = false 
        return 
    end

    WndParentsCare:showInterface(2)
    WndParentsCare:setPlayCarData(SceneKidHome.m_clickInfo.tData)
end

--@brief  点击移除回调
function WndKidOperate:onClickRemove(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tData = SceneKidHome.m_clickInfo.tData

    --如果建筑不在有效的位置上
    if tData.basicData.type == 1 then
        if not SceneKidHome:canClickOperateFunc() then return end
    end
    
    self.m_bIsClickFunc = true 
    SceneKidHome:_toRemoveBuilding(tData)
end

--@brief  点击翻转回调
function WndKidOperate:onClickFlip(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --如果建筑不在有效的位置上
    if not SceneKidHome:canClickOperateFunc() then return end

    self.m_bIsClickFunc = true 
    if SceneKidHome.m_clickInfo.tData.flipStatus == 0 then 
        SceneKidHome.m_clickInfo.tData.flipStatus = 1
    elseif SceneKidHome.m_clickInfo.tData.flipStatus == 1 then 
        SceneKidHome.m_clickInfo.tData.flipStatus = 0 
    end
    
    SceneKidHome.m_clickInfo.tCell:setBuildFlipX(SceneKidHome.m_clickInfo.tData.flipStatus)
    SceneKidHome:toFlip(SceneKidHome.m_clickInfo.tData)
end

--@brief    展示舒适度
function WndKidOperate:showComfirtValue()
    -- body
    if self.m_root == nil then return end 
    
    local txtComfortValue = GetElement(self.m_root, "txtComfortValue_WndKidOperate", WZUILabelTTF)
    if txtComfortValue then
        txtComfortValue:setText(LocalStrings.KID_TEXT53 .. ":" .. SceneKidHome.m_nComfirtValue)
    end
end

--@brief    规则按钮回调
function WndKidOperate:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.KID_TEXT106)
end

--@brief  点击回家按钮回调
function WndKidOperate:onClickGoHome(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    SceneKidHome:showInterface()
end

--@brief  点击拜访按钮回调
function WndKidOperate:onClickVisit(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local bIsFriend = CacheCenter:judgeIsContainsById(SceneKidHome.m_nPlayerId)
    local playerId = SceneKidHome.m_nPlayerId
    if not bIsFriend then 
        if SceneKidHome.m_tMateData and SceneKidHome.m_tMateData.id then 
            bIsFriend = CacheCenter:judgeIsContainsById(SceneKidHome.m_tMateData.id)
            playerId = SceneKidHome.m_tMateData.id
        end
    end
    if bIsFriend == false then
        MsgBoxManager:showTipBox(LocalStrings.KID_HOME_TEXT3)
        return
    end

    ProtocolProcessorKid:send_WEDDING_VisitFriend(playerId)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    获取按钮节点
function WndKidOperate:_getBtnNode()
    -- body
    if self.m_tBtnList == nil then 
        self.m_tBtnList = {} 
    end

    local btnInfo = GetElement(self.m_root, "btnInfo_WndKidOperate", WZUIButton)
    local btnRemove = GetElement(self.m_root, "btnRemove_WndKidOperate", WZUIButton)
    local btnFlip = GetElement(self.m_root, "btnFlip_WndKidOperate", WZUIButton)
    local btnPlayCar = GetElement(self.m_root, "btnPlayCar_WndKidOperate", WZUIButton)

    self.m_tBtnList[1] = btnInfo    --信息
    self.m_tBtnList[2] = btnRemove  --移除
    self.m_tBtnList[3] = btnFlip    --翻转
    self.m_tBtnList[4] = btnPlayCar    --摇摇车

end

--@brief    根据不同的功能建筑，不同的状态，显示不同的功能按钮
function WndKidOperate:_showFuncBtnList()
    -- body
    local txtBuildingName = GetElement(self.m_root, "txtBuildingName_WndKidOperate", WZUILabelTTF)

    for i = 1, #self.m_tBtnList do
        self.m_tBtnList[i]:setVisible(false)
    end
    txtBuildingName:setVisible(false)
    if SceneKidHome.m_clickInfo == nil or SceneKidHome.m_clickInfo == {} then
        return 
    end

    local tData = SceneKidHome.m_clickInfo.tData 
    --建筑的名字和等级
    txtBuildingName:setVisible(true)
    txtBuildingName:setText(tData.basicInfo.name)

    local tBtnIndex = {}
    tBtnIndex[1] = 1 
    if tData.basicData.type == 1 then
        tBtnIndex[2] = 2 
        if tData.basicInfo.id ~= 50008 and tData.basicInfo.id ~= 50009 and tData.basicInfo.id ~= 50013 and tData.basicInfo.id ~= 50018 and tData.basicInfo.id ~= 50037 then 
            tBtnIndex[3] = 3 
        end
        if tData.basicInfo.sub_type == 2 then
            tBtnIndex[4] = 4 
        end
    elseif tData.basicData.type == 2 then
        tBtnIndex[2] = 2
    elseif tData.basicData.type == 3 then
        tBtnIndex[2] = 2
    end

    --显示按钮
    local nBtnNum = GetTableLen(tBtnIndex)
    local conBottom = GetElement(self.m_root, "conBottom_WndKidOperate", WZUIContainer)
    local nBtnWidth = 120
    conBottom:setAbsContentSize(GlobalMethod:CCSize(nBtnNum * nBtnWidth, 130))
    conBottom:setContentSize(GlobalMethod:CCSize(nBtnNum * nBtnWidth, 130))
    conBottom:updateRelativeSize()
    for i = 1, nBtnNum do
        self.m_tBtnList[tBtnIndex[i]]:setVisible(true)
        self.m_tBtnList[tBtnIndex[i]]:setRelativePosition(GlobalMethod:ccp(1/(nBtnNum * 2) + (i - 1) * (1/nBtnNum), 0.5))
    end
end


--@brief     添加顶部货币栏
function WndKidOperate:_addTop()
    -- body
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/common_icon_home.png", SceneKidHome, SceneKidHome.onClickClose, true, 1, true,nil, {goldType = 13})
    self.m_root:addChild(celElement)
end

--@brief    刷新
function WndKidOperate:_update()
    -- body
    --公寓名字
    local txtHomeName = GetElement(self.m_root, "txtHomeName_WndKidOperate", WZUILabelTTF)
    if txtHomeName then
        txtHomeName:setText(SceneKidHome.m_sHomeName)
    end
    --舒适度
    self:showComfirtValue()
    --孩子数据展示
    self:_showKidsInfo()
end

--@brief	展示孩子信息
function WndKidOperate:_showKidsInfo()
	-- body
	if SceneKidHome.m_tKidData == nil or SceneKidHome.m_tKidData == 0 then return end 

    self.m_tCellKid = {}
	for i = 1, #SceneKidHome.m_tKidData do
		self:createKidInfo(SceneKidHome.m_tKidData[i], i)
	end
end

--@brief    创建小孩信息
function WndKidOperate:createKidInfo(tData, nIndex)
    -- body
    local conKidInfo = GetElement(self.m_root, "conKidInfo" .. nIndex .. "_WndKidOperate", WZUIContainer)
    if conKidInfo:getChildByTag(88) then
        conKidInfo:removeChildByTag(88, true)
    end

    local element, tNewObj = CellKidItem:createElement()
    if element and tNewObj then
        conKidInfo:setVisible(true)
        tNewObj:setData(tData, 1)
        element:setTag(88)
        table.insert(self.m_tCellKid, tNewObj)
        conKidInfo:addChild(element)
    end
end

--@brief    更新小孩信息展示
function WndKidOperate:updateKidInfoShow(tData, nIndex)
    -- body
    if self.m_tCellKid and self.m_tCellKid[nIndex] then
        self.m_tCellKid[nIndex]:setData(tData, 1)
    end 
end

--@brief    设置操作界面的按钮是否可见
function WndKidOperate:_setNodeVisible()
    -- body
    --判断是否显示回家按钮，如果在别人家园的话
    local btnGoHome = GetElement(self.m_root, "btnGoHome_WndKidOperate", WZUIButton)
    local btnVisit = GetElement(self.m_root, "btnVisit_WndKidOperate", WZUIButton)
    local txtVisitTime = GetElement(self.m_root, "txtVisitTime_WndKidOperate", WZUILabelTTF)
    if SceneKidHome.m_nPlayerId ~= CacheCenter:getPlayerInfo().id then
        btnGoHome:setVisible(true)
        btnVisit:setVisible(true)
        if #SceneKidHome.m_tKidData == 0 then
            btnGoHome:setRelativePosition(GlobalMethod:ccp(0.177,0.032))
            btnVisit:setRelativePosition(GlobalMethod:ccp(0.177,-0.352))
        elseif #SceneKidHome.m_tKidData == 1 then
            btnGoHome:setRelativePosition(GlobalMethod:ccp(0.177,-0.352))
            btnVisit:setRelativePosition(GlobalMethod:ccp(0.177,-0.736))
        elseif #SceneKidHome.m_tKidData == 2 then
            btnGoHome:setRelativePosition(GlobalMethod:ccp(0.177,-0.736))
            btnVisit:setRelativePosition(GlobalMethod:ccp(0.177,-1.12))
        end
        GetElement(self.m_root, "conRight_WndKidOperate", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conTopMid_WndKidOperate", WZUIContainer):setVisible(true)

        txtVisitTime:setText("")
    else
        btnGoHome:setVisible(false)
        btnVisit:setVisible(false)
        GetElement(self.m_root, "conRight_WndKidOperate", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conTopMid_WndKidOperate", WZUIContainer):setVisible(false)

        self:_updateVisitTime()
        txtVisitTime:enableSchedule("_updateVisitTime",1)
    end

end

-- 拜访剩余倒计时
function WndKidOperate:_updateVisitTime()
    if SceneKidHome.m_tVisitingTime == nil then return end 
    
    local txtVisitTime = GetElement(self.m_root, "txtVisitTime_WndKidOperate", WZUILabelTTF)
    local nRemainingTime = SceneKidHome.m_nSingleVisitTime - (SystemTime:getServerTime() - SceneKidHome.m_tVisitingTime)

    if nRemainingTime <= 0 then
        SceneKidHome:showHostRole()
        txtVisitTime:setText("")
        txtVisitTime:disableSchedule()
    else
        local s = nRemainingTime%60
        local m = math.floor(nRemainingTime/60)%60
        local h = math.floor(nRemainingTime/3600)

        txtVisitTime:setText(string.format(LocalStrings.KID_HOME_TEXT7,h,m,s))
    end
end

function WndKidOperate:hideRankList()
    --body
    if self.m_nRankState == 1 then
        self.m_nRankState = 0
        GetElement(self.m_root, "conForRankList_WndKidOperate", WZUIContainer):setVisible(false)
        local conRankList = GetElement(self.m_root, "conRankList_WndKidOperate", WZUIContainer)
        conRankList:setAnchorPoint(GlobalMethod:ccp(0,0.5))
        if IsIphoneX() then 
            conRankList:setRelativePosition(GlobalMethod:ccp(0.95, 0.46))
        else
            conRankList:setRelativePosition(GlobalMethod:ccp(1, 0.46))
        end
    end
end

function WndKidOperate:showRank() 
    if self.m_root == nil then return end
    local tbCon = GetElement(self.m_root,"tbcon_WndKidOperate",WZUITableContainer)
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
            tCell:setData(self.m_tDataList[i], 2)
            celElement:setTag(i - 1)
            tbCon:setCellElement(celElement)
        end 
    end

    tbCon:getMoveElement():setPositionY(tbCon:getMinPosition().y)
end

--适配iphoneX
function WndKidOperate:_AdaptationIphoneX()
    -- body
    WZLog("WndKidOperate:_AdaptationIphoneX")
    if IsIphoneX() then
        local conLeft = GetElement(self.m_root,"conLeft_WndKidOperate",WZUIContainer)
        conLeft:setRelativePosition(GlobalMethod:ccp(0.045,1))

        local conRightButtom = GetElement(self.m_root,"conRightButtom_WndKidOperate",WZUIContainer)
        conRightButtom:setRelativePosition(GlobalMethod:ccp(0.97,0.028125))
        
        local conRankList = GetElement(self.m_root,"conRankList_WndKidOperate",WZUIContainer)
        conRankList:setRelativePosition(GlobalMethod:ccp(0.95, 0.46))
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function WndKidOperate:_adaptLanguage_vn(  )
    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndKidOperate",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify1:setScale(0.8)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndKidOperate",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify2:setScale(0.8)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox2 = GetElement(self.m_root,"checkBox2_WndKidOperate",WZUICheckBox)
    local txtTransfer21 = GetElement(checkBox2,"txtTransfer1_WndKidOperate",WZUILabelTTF)
    txtTransfer21:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer21:setScale(0.8)
    txtTransfer21:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer22 = GetElement(checkBox2,"txtTransfer2_WndKidOperate",WZUILabelTTF)
    txtTransfer22:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer22:setScale(0.8)
    txtTransfer22:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox3 = GetElement(self.m_root,"checkBox3_WndKidOperate",WZUICheckBox)
    local txtTransfer31 = GetElement(checkBox3,"txtTransfer1_WndKidOperate",WZUILabelTTF)
    txtTransfer31:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer31:setScale(0.8)
    txtTransfer31:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer32 = GetElement(checkBox3,"txtTransfer2_WndKidOperate",WZUILabelTTF)
    txtTransfer32:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer32:setScale(0.8)
    txtTransfer32:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
end

function WndKidOperate:_adaptLanguage_th(  )
    local txtFriendHome = GetElement(self.m_root,"txtFriendHome_WndKidOperate",WZUILabelTTF)
    txtFriendHome:setScale(0.75)
end

function WndKidOperate:_adaptLanguage_en(  )
    local txtFriendHome = GetElement(self.m_root,"txtFriendHome_WndKidOperate",WZUILabelTTF)
    txtFriendHome:setDimensions(GlobalMethod:CCSize(70))
    txtFriendHome:setScale(0.6)

    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndKidOperate",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify1:setScale(0.8)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndKidOperate",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify2:setScale(0.8)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox2 = GetElement(self.m_root,"checkBox2_WndKidOperate",WZUICheckBox)
    local txtTransfer21 = GetElement(checkBox2,"txtTransfer1_WndKidOperate",WZUILabelTTF)
    txtTransfer21:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer21:setScale(0.8)
    txtTransfer21:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer22 = GetElement(checkBox2,"txtTransfer2_WndKidOperate",WZUILabelTTF)
    txtTransfer22:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer22:setScale(0.8)
    txtTransfer22:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox3 = GetElement(self.m_root,"checkBox3_WndKidOperate",WZUICheckBox)
    local txtTransfer31 = GetElement(checkBox3,"txtTransfer1_WndKidOperate",WZUILabelTTF)
    txtTransfer31:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer31:setScale(0.8)
    txtTransfer31:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer32 = GetElement(checkBox3,"txtTransfer2_WndKidOperate",WZUILabelTTF)
    txtTransfer32:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer32:setScale(0.8)
    txtTransfer32:setRelativePosition(GlobalMethod:ccp(0.5,0.49))

    local txtRankReward = GetElement(self.m_root,"txtRankReward_WndKidOperate",WZUILabelTTF)
    txtRankReward:setScale(0.8)
    txtRankReward:setDimensions(GlobalMethod:CCSize(120))

    local txtComfortValue = GetElement(self.m_root, "txtComfortValue_WndKidOperate", WZUILabelTTF)
    txtComfortValue:setScale(0.8)
end

function WndKidOperate:_adaptLanguage_tr(  )
    local txtFriendHome = GetElement(self.m_root,"txtFriendHome_WndKidOperate",WZUILabelTTF)
    txtFriendHome:setDimensions(GlobalMethod:CCSize(60))
    txtFriendHome:setScale(0.6)

    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndKidOperate",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify1:setScale(0.8)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndKidOperate",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify2:setScale(0.8)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox2 = GetElement(self.m_root,"checkBox2_WndKidOperate",WZUICheckBox)
    local txtTransfer21 = GetElement(checkBox2,"txtTransfer1_WndKidOperate",WZUILabelTTF)
    txtTransfer21:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer21:setScale(0.8)
    txtTransfer21:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer22 = GetElement(checkBox2,"txtTransfer2_WndKidOperate",WZUILabelTTF)
    txtTransfer22:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer22:setScale(0.8)
    txtTransfer22:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox3 = GetElement(self.m_root,"checkBox3_WndKidOperate",WZUICheckBox)
    local txtTransfer31 = GetElement(checkBox3,"txtTransfer1_WndKidOperate",WZUILabelTTF)
    txtTransfer31:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer31:setScale(0.8)
    txtTransfer31:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer32 = GetElement(checkBox3,"txtTransfer2_WndKidOperate",WZUILabelTTF)
    txtTransfer32:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer32:setScale(0.8)
    txtTransfer32:setRelativePosition(GlobalMethod:ccp(0.5,0.49))

    local txtRankReward = GetElement(self.m_root,"txtRankReward_WndKidOperate",WZUILabelTTF)
    txtRankReward:setScale(0.8)
    txtRankReward:setDimensions(GlobalMethod:CCSize(120))

    local txtComfortValue = GetElement(self.m_root, "txtComfortValue_WndKidOperate", WZUILabelTTF)
    txtComfortValue:setScale(0.8)

    local txtPlayCar = GetElement(self.m_root,"txtPlayCar_WndKidOperate",WZUILabelTTF)
    txtPlayCar:setScale(0.8)
    txtPlayCar:setDimensions(GlobalMethod:CCSize(120))
end
function WndKidOperate:_adaptLanguage_pt(  )
    local txtFriendHome = GetElement(self.m_root,"txtFriendHome_WndKidOperate",WZUILabelTTF)
    txtFriendHome:setDimensions(GlobalMethod:CCSize(70))
    txtFriendHome:setScale(0.6)

    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndKidOperate",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify1:setScale(0.8)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndKidOperate",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify2:setScale(0.8)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox2 = GetElement(self.m_root,"checkBox2_WndKidOperate",WZUICheckBox)
    local txtTransfer21 = GetElement(checkBox2,"txtTransfer1_WndKidOperate",WZUILabelTTF)
    txtTransfer21:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer21:setScale(0.8)
    txtTransfer21:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer22 = GetElement(checkBox2,"txtTransfer2_WndKidOperate",WZUILabelTTF)
    txtTransfer22:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer22:setScale(0.8)
    txtTransfer22:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox3 = GetElement(self.m_root,"checkBox3_WndKidOperate",WZUICheckBox)
    local txtTransfer31 = GetElement(checkBox3,"txtTransfer1_WndKidOperate",WZUILabelTTF)
    txtTransfer31:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer31:setScale(0.8)
    txtTransfer31:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer32 = GetElement(checkBox3,"txtTransfer2_WndKidOperate",WZUILabelTTF)
    txtTransfer32:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer32:setScale(0.8)
    txtTransfer32:setRelativePosition(GlobalMethod:ccp(0.5,0.49))

    local txtRankReward = GetElement(self.m_root,"txtRankReward_WndKidOperate",WZUILabelTTF)
    txtRankReward:setScale(0.8)
    txtRankReward:setDimensions(GlobalMethod:CCSize(120))

    GetElement(self.m_root,"txtPlayCar_WndKidOperate",WZUILabelTTF):setScale(0.8)
end

function WndKidOperate:_adaptLanguage_es(  )
    local txtFriendHome = GetElement(self.m_root,"txtFriendHome_WndKidOperate",WZUILabelTTF)
    txtFriendHome:setDimensions(GlobalMethod:CCSize(70))
    txtFriendHome:setScale(0.6)

    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndKidOperate",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify1:setScale(0.8)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndKidOperate",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify2:setScale(0.8)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox2 = GetElement(self.m_root,"checkBox2_WndKidOperate",WZUICheckBox)
    local txtTransfer21 = GetElement(checkBox2,"txtTransfer1_WndKidOperate",WZUILabelTTF)
    txtTransfer21:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer21:setScale(0.8)
    txtTransfer21:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer22 = GetElement(checkBox2,"txtTransfer2_WndKidOperate",WZUILabelTTF)
    txtTransfer22:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer22:setScale(0.8)
    txtTransfer22:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox3 = GetElement(self.m_root,"checkBox3_WndKidOperate",WZUICheckBox)
    local txtTransfer31 = GetElement(checkBox3,"txtTransfer1_WndKidOperate",WZUILabelTTF)
    txtTransfer31:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer31:setScale(0.8)
    txtTransfer31:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer32 = GetElement(checkBox3,"txtTransfer2_WndKidOperate",WZUILabelTTF)
    txtTransfer32:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer32:setScale(0.8)
    txtTransfer32:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    
    local txtRankReward = GetElement(self.m_root,"txtRankReward_WndKidOperate",WZUILabelTTF)
    txtRankReward:setScale(0.8)
    txtRankReward:setDimensions(GlobalMethod:CCSize(120))

    GetElement(self.m_root,"txtPlayCar_WndKidOperate",WZUILabelTTF):setScale(0.8)
    
    local txtComfortValue = GetElement(self.m_root, "txtComfortValue_WndKidOperate", WZUILabelTTF)
    txtComfortValue:setScale(0.8)
end

function WndKidOperate:_adaptLanguage_ug(  )
    local txtFriendHome = GetElement(self.m_root,"txtFriendHome_WndKidOperate",WZUILabelTTF)
    txtFriendHome:setDimensions(GlobalMethod:CCSize(60))
    txtFriendHome:setScale(0.6)

    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndKidOperate",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify1:setScale(0.7)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndKidOperate",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify2:setScale(0.7)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox2 = GetElement(self.m_root,"checkBox2_WndKidOperate",WZUICheckBox)
    local txtTransfer21 = GetElement(checkBox2,"txtTransfer1_WndKidOperate",WZUILabelTTF)
    txtTransfer21:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer21:setScale(0.7)
    txtTransfer21:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer22 = GetElement(checkBox2,"txtTransfer2_WndKidOperate",WZUILabelTTF)
    txtTransfer22:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer22:setScale(0.7)
    txtTransfer22:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox3 = GetElement(self.m_root,"checkBox3_WndKidOperate",WZUICheckBox)
    local txtTransfer31 = GetElement(checkBox3,"txtTransfer1_WndKidOperate",WZUILabelTTF)
    txtTransfer31:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer31:setScale(0.7)
    txtTransfer31:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer32 = GetElement(checkBox3,"txtTransfer2_WndKidOperate",WZUILabelTTF)
    txtTransfer32:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer32:setScale(0.7)
    txtTransfer32:setRelativePosition(GlobalMethod:ccp(0.5,0.49))

    local txtRankReward = GetElement(self.m_root,"txtRankReward_WndKidOperate",WZUILabelTTF)
    txtRankReward:setScale(0.8)
    txtRankReward:setDimensions(GlobalMethod:CCSize(120))

    local txtComfortValue = GetElement(self.m_root, "txtComfortValue_WndKidOperate", WZUILabelTTF)
    txtComfortValue:setScale(0.6)

    local txtPlayCar = GetElement(self.m_root,"txtPlayCar_WndKidOperate",WZUILabelTTF)
    txtPlayCar:setScale(0.8)
    txtPlayCar:setDimensions(GlobalMethod:CCSize(120))


    local txtbtnManager = GetElement(self.m_root,"txtbtnManager_WndKidOperate",WZUILabelTTF)
    txtbtnManager:setScale(0.6)
    txtbtnManager:setDimensions(GlobalMethod:CCSize(120))
    local txtbtnCare = GetElement(self.m_root,"txtbtnCare_WndKidOperate",WZUILabelTTF)
    txtbtnCare:setScale(0.6)
    txtbtnCare:setDimensions(GlobalMethod:CCSize(120))
    
    
end
-------------------------------------语言适配End----------------------------------------