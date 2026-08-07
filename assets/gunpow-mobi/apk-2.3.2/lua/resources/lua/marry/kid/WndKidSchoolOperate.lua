--WndKidSchoolOperate.lua
--@brief	WndKidSchoolOperate的UI模块
--@date		2021/05/10
--@author	yrd
--@note		小家学校操作界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKidSchoolOperate:onEnter(element)
	self.m_root = element

    ProtocolProcessorKidSchool:regAll()
    self.m_root:enableSchedule("_heartbeatSchedule",10)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKidSchoolOperate:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndKidSchoolOperate:onEnterTransitionDidFinish(element)
    -- body
    self:_AdaptationIphoneX()
    AdaptLanguage(self)

    self:_getBtnNode()
    self:_addTop()

    self:showUIByType()

    self:updateRedDot()
end

--@brief    更新红点
function WndKidSchoolOperate:updateRedDot()
    if self.m_root == nil then
        return
    end
    if GlobalGame.g_tRedPointList.schoolApplyWaiting then
        GetElement(self.m_root,"imgManagerRedDot_WndKidSchoolOperate",WZUIImage):setVisible(true)
    else
        GetElement(self.m_root,"imgManagerRedDot_WndKidSchoolOperate",WZUIImage):setVisible(false)
    end
end

function WndKidSchoolOperate:_heartbeatSchedule(element)
    ProtocolProcessorKidSchool:send_SCHOOL_HeartbeatSchool()
end

--@brief    根据类型显示界面
function WndKidSchoolOperate:showUIByType()
    GetElement(self.m_root, "btnCare_WndKidSchoolOperate", WZUIButton):setVisible(false)
    GetElement(self.m_root, "btnSchool_WndKidSchoolOperate", WZUIButton):setVisible(false)
    GetElement(self.m_root, "btnGoHome2_WndKidSchoolOperate", WZUIButton):setVisible(true)
    GetElement(self.m_root, "btnManager_WndKidSchoolOperate", WZUIButton):setVisible(true)

    GetElement(self.m_root, "conRightTop_WndKidSchoolOperate", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conRankList_WndKidSchoolOperate", WZUIContainer):setVisible(false)
end

--@brief    点击好友家园按钮回调
function WndKidSchoolOperate:onClickFriendHome()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self.m_bIsClickFunc = true 
    local conRankList = GetElement(self.m_root, "conRankList_WndKidSchoolOperate", WZUIContainer)
    if self.m_nRankState == 0 then
        self.m_nRankState = 1 
        if self.m_nTag == nil then 
            self.m_nTag = 3
        end
        local nIndex = GetElement(self.m_root, "checkGroup_WndKidSchoolOperate", WZUICheckBoxGroup):getCheckIndex()
        WZLog("WndKidSchoolOperate:onClickFriendHome", self.m_nTag, nIndex)
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
        GetElement(self.m_root, "conForRankList_WndKidSchoolOperate", WZUIContainer):setVisible(true)

        GetElement(self.m_root,"editInputId_WndKidSchoolOperate",WZUIEditBox):setPlaceHolder(LocalStrings.MASTERINFO16)
        WZLog("WndKidSchoolOperate:onClickFriendHome", GlobalMethod:crossServiceOpen())
        if GlobalMethod:crossServiceOpen() == 0 then
            GetElement(self.m_root,"checkBox2_WndKidSchoolOperate",WZUICheckBox):setVisible(false)
        else
            GetElement(self.m_root,"checkBox2_WndKidSchoolOperate",WZUICheckBox):setVisible(true)
        end
    else
        self:hideRankList()
    end
end

--@brief    点击查找好友ID按钮时
function WndKidSchoolOperate:onClickFindCommunityId(element)
    WZLog(" WndKidSchoolOperate:onClickFindCommunityId")
    --音效
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local inputText = nil 
    local editInputId  = self.m_root:getChildElement("editInputId_WndKidSchoolOperate")
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
        GetElement(self.m_root,"btnCancelFind_WndKidSchoolOperate",WZUIButton):setVisible(true)
    elseif inputText == LocalStrings.MASTERINFO16 or inputText == "" then 
        MsgBoxManager:showTipBox(LocalStrings.MASTERINFO16)
    else  
        MsgBoxManager:showTipBox(LocalStrings.MASTERINFO22)
    end 
end 

function WndKidSchoolOperate:onCancelFind(element) 
    WZLog("WndKidSchoolOperate:onCancelFind", tonumber(self.m_nTag))
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --隐藏取消查找按钮
    GetElement(self.m_root,"btnCancelFind_WndKidSchoolOperate",WZUIButton):setVisible(false)
    --刷新界面
    ProtocolProcessorKid:send_WWEDDING_GetHouseRankInfo(tonumber(self.m_nTag))
     
    GetElement(self.m_root,"editInputId_WndKidSchoolOperate",WZUIEditBox):setText("")
    GetElement(self.m_root,"editInputId_WndKidSchoolOperate",WZUIEditBox):setPlaceHolder(LocalStrings.MASTERINFO16)
end

function WndKidSchoolOperate:onReward(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCompeteGift:showWnd(3)
end

function WndKidSchoolOperate:onTab(element) 
    WZLog("WndKidSchoolOperate:onTab",element:getTag())
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = tonumber(element:getTag())
    self.m_nTag = tag
    ProtocolProcessorKid:send_WWEDDING_GetHouseRankInfo(tag)
end

--@brief 	点击关爱按钮回调
function WndKidSchoolOperate:onClickCare(element) 
    WZLog("WndKidSchoolOperate:onClickCare",element:getTag())
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
function WndKidSchoolOperate:onClickManager(element) 
    WZLog("WndKidSchoolOperate:onClickManager")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_bIsClickFunc = true 

    WndKidSchoolList:showInterface(1)

end

--@brief    点击学校按钮回调
function WndKidSchoolOperate:onClickSchool(element) 
    WZLog("WndKidSchoolOperate:onClickSchool")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if SceneKidHome.m_tKidData == nil or #SceneKidHome.m_tKidData == 0 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT130)
        return
    end

    ProtocolProcessorKidSchool:send_SCHOOL_EntrySchool(0)
end

--@brief  点击回家按钮回调
function WndKidSchoolOperate:onClickGoHome2(element)
    WZLog("WndKidSchoolOperate:onClickGoHome2")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    SceneKidHome:showInterface()
end

function WndKidSchoolOperate:checkPointInBtn(pt)
    if self.m_root == nil then return end
    local btn = GetElement(self.m_root, "conRankList_WndKidSchoolOperate", WZUIContainer)
    if btn == nil then return false end
    local btnSize = btn:getContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        return true
    end 

    btn = GetElement(self.m_root, "btnFriendHome_WndKidSchoolOperate", WZUIButton)
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
function WndKidSchoolOperate:showOtherInfo()
    -- body
    GetElement(self.m_root, "conOutSide_WndKidSchoolOperate", WZUIContainer):setVisible(true)
    -- self:_setNodeVisible()
    self:_update()
end

--@brief    点击孩子头像回调
function WndKidSchoolOperate:onClickBabyHeadCallBack(tCell, tData)
    -- body
    if WndKidSchoolOperate.m_root == nil then return end 

    if self.m_nBabyInfoState == 0 then
        self.m_nBabyInfoState = 1
    else
        self.m_nBabyInfoState = 0
    end

    for i = 1, #self.m_tCellKid do
        local imgArrowHead = GetElement(self.m_root, "imgArrowHead" .. i .. "_WndKidSchoolOperate", WZUIImage)
        if self.m_nBabyInfoState == 0 then
            GetElement(self.m_root, "img9Bk" .. i .. "_WndKidSchoolOperate", WZUI9Image):setVisible(false)
            imgArrowHead:setRelativePosition(GlobalMethod:ccp(0.44,0.5))
            imgArrowHead:setRotation(180)
            self.m_tCellKid[i]:setInfoState(false)
        else
            GetElement(self.m_root, "img9Bk" .. i .. "_WndKidSchoolOperate", WZUI9Image):setVisible(true)
            imgArrowHead:setRelativePosition(GlobalMethod:ccp(1.084,0.5))
            imgArrowHead:setRotation(0)
            self.m_tCellKid[i]:setInfoState(true)
        end 
    end
end

--@brief    点击建筑，对底部按钮添加相应的按钮操作
function WndKidSchoolOperate:onClickBuildingCallBack()
    self:_showFuncBtnList()
end

--@brief  点击信息回调
function WndKidSchoolOperate:onClickInfo(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    self.m_bIsClickFunc = true 
    WndBuildingInfo:showInterface(SceneKidSchoolHome.m_clickInfo.tData, 3)
end


--@brief  点击技能回调
function WndKidSchoolOperate:onClickSkill(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_bIsClickFunc = true
    WndKidSchoolSkill:showInterface()
end

--@brief  点击前往回调
function WndKidSchoolOperate:onClickAreaGoto(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    local areaType = 0
    local ntype = SceneKidSchoolHome.m_clickInfo.tData.basicData.type
    if ntype == 11 then
        areaType = 1
    elseif ntype == 8 then
        areaType = 2
    elseif ntype == 10 then
        areaType = 3
    elseif ntype == 9 then
        areaType = 4
    end

    local nShoolLevel = SceneKidSchoolHome:getShoolLevel()
    for k,v in pairs(GDatatab_school) do
        if v.level == nShoolLevel then
            local peopleCount = 0
            if areaType == 1 then
                peopleCount = v.people3
            elseif areaType == 2 then
                peopleCount = v.people5
            elseif areaType == 3 then
                peopleCount = v.people4
            elseif areaType == 4 then
                peopleCount = v.people2
            end
            if peopleCount == 0 then
                MsgBoxManager:showTipBox(LocalStrings.KID_TEXT242)
                return
            end
        end
    end

    ProtocolProcessorKidSchool:send_SCHOOL_JoinArea(areaType)
end

--@brief  点击返回回调
function WndKidSchoolOperate:onClickAreaBack(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    ProtocolProcessorKidSchool:send_SCHOOL_JoinArea(0)
end

--@brief    点击摇摇车按钮回调
function WndKidSchoolOperate:onClickPlayCar(element)
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
function WndKidSchoolOperate:onClickRemove(element)
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
function WndKidSchoolOperate:onClickFlip(element)
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
function WndKidSchoolOperate:showComfirtValue()
    -- body
    if self.m_root == nil then return end 
    
    local txtComfortValue = GetElement(self.m_root, "txtComfortValue_WndKidSchoolOperate", WZUILabelTTF)
    if txtComfortValue then
        txtComfortValue:setText(LocalStrings.KID_TEXT131 .. ":" .. SceneKidSchoolHome:getEffectId())
    end
end

--@brief    规则按钮回调
function WndKidSchoolOperate:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.KID_TEXT106)
end

--@brief  点击回家按钮回调
function WndKidSchoolOperate:onClickGoHome(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    SceneKidHome:showInterface()
end

--@brief  点击拜访按钮回调
function WndKidSchoolOperate:onClickVisit(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local bIsFriend = CacheCenter:judgeIsContainsById(SceneKidHome.m_nPlayerId)
    if bIsFriend == false then
        MsgBoxManager:showTipBox(LocalStrings.KID_HOME_TEXT3)
        return
    end

    ProtocolProcessorKid:send_WEDDING_VisitFriend(SceneKidHome.m_nPlayerId)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    获取按钮节点
function WndKidSchoolOperate:_getBtnNode()
    -- body
    if self.m_tBtnList == nil then 
        self.m_tBtnList = {} 
    end

    local btnInfo = GetElement(self.m_root, "btnInfo_WndKidSchoolOperate", WZUIButton)
    local btnRemove = GetElement(self.m_root, "btnRemove_WndKidSchoolOperate", WZUIButton)
    local btnFlip = GetElement(self.m_root, "btnFlip_WndKidSchoolOperate", WZUIButton)
    local btnPlayCar = GetElement(self.m_root, "btnPlayCar_WndKidSchoolOperate", WZUIButton)
    local btnAreaGoto = GetElement(self.m_root, "btnAreaGoto_WndKidSchoolOperate", WZUIButton)
    local btnAreaBack = GetElement(self.m_root, "btnAreaBack_WndKidSchoolOperate", WZUIButton)
    local btnSkill = GetElement(self.m_root, "btnSkill_WndKidSchoolOperate", WZUIButton)

    self.m_tBtnList[1] = btnInfo    --信息
    self.m_tBtnList[2] = btnRemove  --移除
    self.m_tBtnList[3] = btnFlip    --翻转
    self.m_tBtnList[4] = btnPlayCar    --摇摇车
    self.m_tBtnList[5] = btnAreaGoto    --前往
    self.m_tBtnList[6] = btnAreaBack    --返回
    self.m_tBtnList[7] = btnSkill    --技能

end

--@brief    根据不同的功能建筑，不同的状态，显示不同的功能按钮
function WndKidSchoolOperate:_showFuncBtnList()
    -- body
    local txtBuildingName = GetElement(self.m_root, "txtBuildingName_WndKidSchoolOperate", WZUILabelTTF)

    for i = 1, #self.m_tBtnList do
        self.m_tBtnList[i]:setVisible(false)
    end
    txtBuildingName:setVisible(false)

    if SceneKidSchoolHome.m_root and (SceneKidSchoolHome.m_clickInfo == nil or SceneKidSchoolHome.m_clickInfo == {}) then
        return 
    end

    local tData = nil
    if SceneKidHome.m_root then
        tData = SceneKidHome.m_clickInfo.tData
    elseif SceneKidSchoolHome.m_root then
        tData = SceneKidSchoolHome.m_clickInfo.tData
    end

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
    elseif tData.basicData.type == 7 then
        tBtnIndex[2] = 7
    elseif tData.basicData.type == 8 or tData.basicData.type == 9 or tData.basicData.type == 10 or tData.basicData.type == 11 then
        tBtnIndex[2] = 5
        local myArea = SceneKidSchoolHome:getMyKidArea()
        if tData.basicData.type == 8 and myArea == 2 or
                tData.basicData.type == 9 and myArea == 4 or
                tData.basicData.type == 10 and myArea == 3 or
                tData.basicData.type == 11 and myArea == 1 then
            tBtnIndex[2] = 6
        end
    end


    --显示按钮
    local nBtnNum = GetTableLen(tBtnIndex)
    local conBottom = GetElement(self.m_root, "conBottom_WndKidSchoolOperate", WZUIContainer)
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
function WndKidSchoolOperate:_addTop()
    -- body
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/common_icon_xx.png", SceneKidSchoolHome, SceneKidSchoolHome.onClickClose, true, 1, true,nil, {goldType = 13})
    self.m_root:addChild(celElement)
end

--@brief    刷新
function WndKidSchoolOperate:_update()
    -- body
    --公寓名字
    local txtHomeName = GetElement(self.m_root, "txtHomeName_WndKidSchoolOperate", WZUILabelTTF)
    if txtHomeName then
        txtHomeName:setText(SceneKidSchoolHome:getSchoolName())
    end
    --舒适度
    self:showComfirtValue()
    --孩子数据展示
    self:_showKidsInfo()
end

--@brief	展示孩子信息
function WndKidSchoolOperate:_showKidsInfo()
	-- body
	if SceneKidHome.m_tKidData == nil or SceneKidHome.m_tKidData == 0 then return end 

    self.m_tCellKid = {}
	for i = 1, #SceneKidHome.m_tKidData do
		self:createKidInfo(SceneKidHome.m_tKidData[i], i)
	end
end

--@brief    创建小孩信息
function WndKidSchoolOperate:createKidInfo(tData, nIndex)
    -- body
    local conKidInfo = GetElement(self.m_root, "conKidInfo" .. nIndex .. "_WndKidSchoolOperate", WZUIContainer)
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
function WndKidSchoolOperate:updateKidInfoShow(tData, nIndex)
    -- body
    if self.m_tCellKid and self.m_tCellKid[nIndex] then
        self.m_tCellKid[nIndex]:setData(tData, 1)
    end 
end

--@brief    设置操作界面的按钮是否可见
function WndKidSchoolOperate:_setNodeVisible()
    -- body
    --判断是否显示回家按钮，如果在别人家园的话
    local btnGoHome = GetElement(self.m_root, "btnGoHome_WndKidSchoolOperate", WZUIButton)
    local btnVisit = GetElement(self.m_root, "btnVisit_WndKidSchoolOperate", WZUIButton)
    local txtVisitTime = GetElement(self.m_root, "txtVisitTime_WndKidSchoolOperate", WZUILabelTTF)
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
        GetElement(self.m_root, "conRight_WndKidSchoolOperate", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conTopMid_WndKidSchoolOperate", WZUIContainer):setVisible(true)

        txtVisitTime:setText("")
    else
        btnGoHome:setVisible(false)
        btnVisit:setVisible(false)
        GetElement(self.m_root, "conRight_WndKidSchoolOperate", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conTopMid_WndKidSchoolOperate", WZUIContainer):setVisible(false)

        self:_updateVisitTime()
        txtVisitTime:enableSchedule("_updateVisitTime",1)
    end

end

-- 拜访剩余倒计时
function WndKidSchoolOperate:_updateVisitTime()
    if SceneKidHome.m_tVisitingTime == nil then return end 
    
    local txtVisitTime = GetElement(self.m_root, "txtVisitTime_WndKidSchoolOperate", WZUILabelTTF)
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

function WndKidSchoolOperate:hideRankList()
    --body
    if self.m_nRankState == 1 then
        self.m_nRankState = 0
        GetElement(self.m_root, "conForRankList_WndKidSchoolOperate", WZUIContainer):setVisible(false)
        local conRankList = GetElement(self.m_root, "conRankList_WndKidSchoolOperate", WZUIContainer)
        conRankList:setAnchorPoint(GlobalMethod:ccp(0,0.5))
        if IsIphoneX() then 
            conRankList:setRelativePosition(GlobalMethod:ccp(0.95, 0.46))
        else
            conRankList:setRelativePosition(GlobalMethod:ccp(1, 0.46))
        end
    end
end

function WndKidSchoolOperate:showRank() 
    if self.m_root == nil then return end
    local tbCon = GetElement(self.m_root,"tbcon_WndKidSchoolOperate",WZUITableContainer)
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
function WndKidSchoolOperate:_AdaptationIphoneX()
    -- body
    WZLog("WndKidSchoolOperate:_AdaptationIphoneX")
    if IsIphoneX() then
        local conLeft = GetElement(self.m_root,"conLeft_WndKidSchoolOperate",WZUIContainer)
        conLeft:setRelativePosition(GlobalMethod:ccp(0.045,1))

        local conRightButtom = GetElement(self.m_root,"conRightButtom_WndKidSchoolOperate",WZUIContainer)
        conRightButtom:setRelativePosition(GlobalMethod:ccp(0.97,0.028125))
        
        local conRankList = GetElement(self.m_root,"conRankList_WndKidSchoolOperate",WZUIContainer)
        conRankList:setRelativePosition(GlobalMethod:ccp(0.95, 0.46))
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function WndKidSchoolOperate:_adaptLanguage_vn(  )
    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndKidSchoolOperate",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify1:setScale(0.8)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndKidSchoolOperate",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify2:setScale(0.8)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox2 = GetElement(self.m_root,"checkBox2_WndKidSchoolOperate",WZUICheckBox)
    local txtTransfer21 = GetElement(checkBox2,"txtTransfer1_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer21:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer21:setScale(0.8)
    txtTransfer21:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer22 = GetElement(checkBox2,"txtTransfer2_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer22:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer22:setScale(0.8)
    txtTransfer22:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox3 = GetElement(self.m_root,"checkBox3_WndKidSchoolOperate",WZUICheckBox)
    local txtTransfer31 = GetElement(checkBox3,"txtTransfer1_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer31:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer31:setScale(0.8)
    txtTransfer31:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer32 = GetElement(checkBox3,"txtTransfer2_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer32:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer32:setScale(0.8)
    txtTransfer32:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
end

function WndKidSchoolOperate:_adaptLanguage_th(  )
    local txtFriendHome = GetElement(self.m_root,"txtFriendHome_WndKidSchoolOperate",WZUILabelTTF)
    txtFriendHome:setScale(0.75)
end

function WndKidSchoolOperate:_adaptLanguage_en(  )
    local txtFriendHome = GetElement(self.m_root,"txtFriendHome_WndKidSchoolOperate",WZUILabelTTF)
    txtFriendHome:setDimensions(GlobalMethod:CCSize(70))
    txtFriendHome:setScale(0.6)

    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndKidSchoolOperate",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify1:setScale(0.8)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndKidSchoolOperate",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify2:setScale(0.8)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox2 = GetElement(self.m_root,"checkBox2_WndKidSchoolOperate",WZUICheckBox)
    local txtTransfer21 = GetElement(checkBox2,"txtTransfer1_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer21:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer21:setScale(0.8)
    txtTransfer21:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer22 = GetElement(checkBox2,"txtTransfer2_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer22:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer22:setScale(0.8)
    txtTransfer22:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox3 = GetElement(self.m_root,"checkBox3_WndKidSchoolOperate",WZUICheckBox)
    local txtTransfer31 = GetElement(checkBox3,"txtTransfer1_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer31:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer31:setScale(0.8)
    txtTransfer31:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer32 = GetElement(checkBox3,"txtTransfer2_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer32:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer32:setScale(0.8)
    txtTransfer32:setRelativePosition(GlobalMethod:ccp(0.5,0.49))

    local txtRankReward = GetElement(self.m_root,"txtRankReward_WndKidSchoolOperate",WZUILabelTTF)
    txtRankReward:setScale(0.8)
    txtRankReward:setDimensions(GlobalMethod:CCSize(120))

    local txtComfortValue = GetElement(self.m_root, "txtComfortValue_WndKidSchoolOperate", WZUILabelTTF)
    txtComfortValue:setScale(0.8)
end

function WndKidSchoolOperate:_adaptLanguage_tr(  )
    local txtFriendHome = GetElement(self.m_root,"txtFriendHome_WndKidSchoolOperate",WZUILabelTTF)
    txtFriendHome:setDimensions(GlobalMethod:CCSize(60))
    txtFriendHome:setScale(0.6)

    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndKidSchoolOperate",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify1:setScale(0.8)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndKidSchoolOperate",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify2:setScale(0.8)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox2 = GetElement(self.m_root,"checkBox2_WndKidSchoolOperate",WZUICheckBox)
    local txtTransfer21 = GetElement(checkBox2,"txtTransfer1_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer21:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer21:setScale(0.8)
    txtTransfer21:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer22 = GetElement(checkBox2,"txtTransfer2_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer22:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer22:setScale(0.8)
    txtTransfer22:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox3 = GetElement(self.m_root,"checkBox3_WndKidSchoolOperate",WZUICheckBox)
    local txtTransfer31 = GetElement(checkBox3,"txtTransfer1_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer31:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer31:setScale(0.8)
    txtTransfer31:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer32 = GetElement(checkBox3,"txtTransfer2_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer32:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer32:setScale(0.8)
    txtTransfer32:setRelativePosition(GlobalMethod:ccp(0.5,0.49))

    local txtRankReward = GetElement(self.m_root,"txtRankReward_WndKidSchoolOperate",WZUILabelTTF)
    txtRankReward:setScale(0.8)
    txtRankReward:setDimensions(GlobalMethod:CCSize(120))

    local txtComfortValue = GetElement(self.m_root, "txtComfortValue_WndKidSchoolOperate", WZUILabelTTF)
    txtComfortValue:setScale(0.8)

    local txtPlayCar = GetElement(self.m_root,"txtPlayCar_WndKidSchoolOperate",WZUILabelTTF)
    txtPlayCar:setScale(0.8)
    txtPlayCar:setDimensions(GlobalMethod:CCSize(120))
end
function WndKidSchoolOperate:_adaptLanguage_pt(  )
    local txtFriendHome = GetElement(self.m_root,"txtFriendHome_WndKidSchoolOperate",WZUILabelTTF)
    txtFriendHome:setDimensions(GlobalMethod:CCSize(70))
    txtFriendHome:setScale(0.6)

    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndKidSchoolOperate",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify1:setScale(0.8)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndKidSchoolOperate",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify2:setScale(0.8)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox2 = GetElement(self.m_root,"checkBox2_WndKidSchoolOperate",WZUICheckBox)
    local txtTransfer21 = GetElement(checkBox2,"txtTransfer1_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer21:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer21:setScale(0.8)
    txtTransfer21:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer22 = GetElement(checkBox2,"txtTransfer2_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer22:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer22:setScale(0.8)
    txtTransfer22:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox3 = GetElement(self.m_root,"checkBox3_WndKidSchoolOperate",WZUICheckBox)
    local txtTransfer31 = GetElement(checkBox3,"txtTransfer1_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer31:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer31:setScale(0.8)
    txtTransfer31:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer32 = GetElement(checkBox3,"txtTransfer2_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer32:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer32:setScale(0.8)
    txtTransfer32:setRelativePosition(GlobalMethod:ccp(0.5,0.49))

    local txtRankReward = GetElement(self.m_root,"txtRankReward_WndKidSchoolOperate",WZUILabelTTF)
    txtRankReward:setScale(0.8)
    txtRankReward:setDimensions(GlobalMethod:CCSize(120))

    GetElement(self.m_root,"txtPlayCar_WndKidSchoolOperate",WZUILabelTTF):setScale(0.8)
end

function WndKidSchoolOperate:_adaptLanguage_es(  )
    local txtFriendHome = GetElement(self.m_root,"txtFriendHome_WndKidSchoolOperate",WZUILabelTTF)
    txtFriendHome:setDimensions(GlobalMethod:CCSize(70))
    txtFriendHome:setScale(0.6)

    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndKidSchoolOperate",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify1:setScale(0.8)
    txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndKidSchoolOperate",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(100))
    txtIntensify2:setScale(0.8)
    txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox2 = GetElement(self.m_root,"checkBox2_WndKidSchoolOperate",WZUICheckBox)
    local txtTransfer21 = GetElement(checkBox2,"txtTransfer1_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer21:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer21:setScale(0.8)
    txtTransfer21:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer22 = GetElement(checkBox2,"txtTransfer2_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer22:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer22:setScale(0.8)
    txtTransfer22:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local checkBox3 = GetElement(self.m_root,"checkBox3_WndKidSchoolOperate",WZUICheckBox)
    local txtTransfer31 = GetElement(checkBox3,"txtTransfer1_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer31:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer31:setScale(0.8)
    txtTransfer31:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    local txtTransfer32 = GetElement(checkBox3,"txtTransfer2_WndKidSchoolOperate",WZUILabelTTF)
    txtTransfer32:setDimensions(GlobalMethod:CCSize(100))
    txtTransfer32:setScale(0.8)
    txtTransfer32:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    
    local txtRankReward = GetElement(self.m_root,"txtRankReward_WndKidSchoolOperate",WZUILabelTTF)
    txtRankReward:setScale(0.8)
    txtRankReward:setDimensions(GlobalMethod:CCSize(120))

    GetElement(self.m_root,"txtPlayCar_WndKidSchoolOperate",WZUILabelTTF):setScale(0.8)
    
    local txtComfortValue = GetElement(self.m_root, "txtComfortValue_WndKidSchoolOperate", WZUILabelTTF)
    txtComfortValue:setScale(0.8)
end
-------------------------------------语言适配End----------------------------------------