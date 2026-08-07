--WndCityBottomBar.lua
--@brief	WndCityBottomBar
--@date		2015/2/11
--@author	莫剑峰
--@note		底部条UI


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note	在这里做场景进入前的准备工作
function WndCityBottomBar:onEnter(element)
    WZLog("WndCityBottomBar:onEnter",self.g_tMailCount)
	self.m_root = element
    AdaptLanguage(self)
    self:init()
    Protocol:reg( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkillOk, "ProtocolProcessorSceneCity:parse_PLAYER_GetPlayerSkillOk", "vivs")
    ProtocolProcessorWndSkillProp:send_PLAYER_GetPlayerSkill()

    Protocol:reg( Protocol.MAIN_PET, Protocol.PET_GetFreeTimeOK, "ProtocolProcessorSceneCity:parse_PET_GetFreeTimeOK", "vtvi")
    ProtocolProcessorScenePets:send_PET_GetFreeTime()

    Protocol:reg( Protocol.MAIN_CARD, Protocol.CARD_GetCardSetListOk, "ProtocolProcessorSceneCity:parse_CARD_GetCardSetListOk", "viviii")
    ProtocolProcessorCard:send_CARD_GetCardSetList()

    CacheCenter:registerUpatePlayerInfoObserver(self)

    if IsIphoneX() then
        GetElement(self.m_root, "conBottom_WndBottomBar", WZUIContainer):setRelativePositionLuaTo(0.97,0.025)
        GetElement(self.m_root, "conLeftUp_WndBottomBar", WZUIContainer):setRelativePositionLuaTo(0.04,0.97)
        GetElement(self.m_root, "conLeft_WndBottomBar", WZUIContainer):setRelativePositionLuaTo(0.04,0.015)
    end
end

--@brief	删除多余的资源
function WndCityBottomBar:onEnterTransitionDidFinish(element)
    
    self:_update() 

    CacheCenter:setRedState("btnBag",CacheCenter:isEquipedDecorationRedPoint())
    GlobalGame:getBtnRedPointEvent():dispatcher()

    self:updateTask()
    self.m_root:enableSchedule("loop",0)
    
    local anim = BattleAnimation:createAnimation("ui_main_mrgq", false, "city")
    local armature = anim.m_node
    armature:setName("ui_main_mrgq_SceneCity")
    armature:setUseOriginSize(true)
    armature:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    armature:setTouchEnable(false)
    armature:setAnimationName("effect")
    armature:setLoop(true)
    GetElement(self.m_root, "conBgTask_WndBottomBar", WZUIContainer):addChild(armature)
    armature:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))

    --WndCurrentChat:wndCurChatVisible(false)
    if CheckButtonOpen(ISLAND_RIGHT_RUNE_MAIN,true) then
        ProtocolProcessorSceneRune:regAll()
        ProtocolProcessorSceneRune:send_RUNE_GetRuneInfo()
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCityBottomBar:onExit(element)
    WZLog("WndCityBottomBar:onExit", tostring(g_bIsPushScene), tostring(g_bIsPopScene))
    if self.m_adapter then
        WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(self.m_adapter:getId())
        self.m_adapter = nil
    end

    CacheCenter:unregisterUpatePlayerInfoObserver(self)
	self:_unInit()
    if GlobalGame.g_tWndBottomBarObj == self then
        GlobalGame.g_tWndBottomBarObj = nil
    end
end

--@brief    是否展开
function WndCityBottomBar:setRed(red)
    self.m_bRed = red
end

--@brief    是否展开
function WndCityBottomBar:isOpen()
    local isOpen = false

    if SceneCity.m_tWndBottomBarObj and SceneCity.m_tWndBottomBarObj.m_nMoveDirection == 0 then
        isOpen = true
    end

    WZLog("WndCityBottomBar:isOpen", isOpen)
    return isOpen
end

function WndCityBottomBar:updateTask()
    self.m_tTaskRewardState, self.m_tTaskingState = PrefetchCache:getTaskStatusList()

    WZLog("WndCityBottomBar:updateTask one", Serialize(self.m_tTaskRewardState), Serialize(self.m_tTaskingState))
    if self.m_root == nil then
        return
    end

    self.m_nTime = 0
end
function WndCityBottomBar:loop(element, dt)
    if self.m_nTime == 0 then
        self.m_nTime = self.m_nTime + 0.1

        local rewardIndex = -1
        for i,v in ipairs(self.m_tTaskRewardState) do
            if v == 1 then
                rewardIndex = i
                break
            end
        end

        local taskingIndex = -1
        for i,v in ipairs(self.m_tTaskingState) do
            if v == 1 then
                taskingIndex = i
                break
            end
        end

        self.m_nRewardIndex = rewardIndex
        self.m_nTaskingIndex = taskingIndex

        --WZLog("WndCityBottomBar:loop one", self.m_nRewardIndex, self.m_nTaskingIndex, Serialize(self.m_tTaskRewardState), Serialize(self.m_tTaskingState))
        local txt = GetElement(self.m_root,"txtTask_WndBottomBar",WZUILabelTTF)
        if rewardIndex > -1 and taskingIndex > -1 then
            if self.m_nTaskShowIndex == 0 or self.m_nTaskShowIndex == 2 then
                txt:setText(LocalStrings.TASKTIP1) 
                self.m_nTaskShowIndex = 1
            else
                txt:setText(LocalStrings.TASKTIP2) 
                self.m_nTaskShowIndex = 2
            end
        elseif rewardIndex > -1 then
            txt:setText(LocalStrings.TASKTIP1) 
            self.m_nTaskShowIndex = 1
        elseif taskingIndex > -1 then
            txt:setText(LocalStrings.TASKTIP2) 
            self.m_nTaskShowIndex = 2
        else
            txt:setText(LocalStrings.TASKTIP3) 
            self.m_nTaskShowIndex = 0
        end
    else
        self.m_nTime = self.m_nTime + dt

        if self.m_nTime >= 4 then
            self.m_nTime = 0
        end
    end
end

--@param    设置当前场景
function WndCityBottomBar:setScene(scene)
    self.m_tScene = scene
end

--@param    设置卡牌红点
function WndCityBottomBar:setCardRedPoint(isRed)
    CacheCenter:setRedState("btnCard_ExtendUp",isRed,57)
    GlobalGame:getBtnRedPointEvent():dispatcher()
end

--@brief	初始化
--@note		界面前的所有初始化
function WndCityBottomBar:init()
    WZLog("WndCityBottomBar:init one")
    element = self:getVerticalBar()
    element:setRelativePosition(GlobalMethod:ccp(0.0,0.5))
    self:setSwitchState(true)
    self.m_nMoveDirection = 0
    GetElement(self.m_root,"imgSwitch_WndBottomBar",WZUIImage):setScale(1)
    GetElement(self.m_root,"imgSwitch2_WndBottomBar",WZUIImage):setScale(1.1)

    GetElement(self.m_root,"conAllExtend_WndBottomBar",WZUIContainer):setVisible(false)
end

--@brief    玩家技能
--@param    id : 玩家技能id
--@param    skillExplain : 技能描述
function WndCityBottomBar:receiveGetPlayerSkillOk(id,skillExplain)
    --WZLog("WndCityBottomBar:receiveGetPlayerSkillOk ")
    do return end
    local isSkill = nil
    local bIsLock = false
    for i,v in ipairs(id) do
        if v == -1 then
            bIsLock = true
        end
        --WZLog("WndCityBottomBar:receiveGetPlayerSkillOk zero", i, id[i], tostring(not bIsLock))
        if not bIsLock then
            if id[i] <= 0  then
                isSkill = true
                break
            end
        end
        bIsLock = false
    end

    self.m_tPlayerSkillInfo = {skillId = id ,skillExplain = skillExplain}

    if isSkill and CheckButtonOpen(ISLAND_RIGHT_ITEM,true) then
        CacheCenter:setRedState("btnItem", true)
        GlobalGame:getBtnRedPointEvent():dispatcher()
        self.m_bHavePos = true
        WZLog("WndCityBottomBar:receiveGetPlayerSkillOk one")
    else
        --CacheCenter:setRedState("btnItem", false)
        self.m_bHavePos = false
        WZLog("WndCityBottomBar:receiveGetPlayerSkillOk two")
        self.m_tPlayerSkillInfo = {skillId = id ,skillExplain = skillExplain}
        Protocol:reg(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSkillListOk, "ProtocolProcessorSceneCity:parse_PLAYER_GetSkillListOk", "vivi")
        ProtocolProcessorWndSkillProp:send_PLAYER_GetSkillList()
    end
    

    
end

--@brief  查找所有技能存放到table
function WndCityBottomBar:initSkills()
    self.m_tSkillList = {}
    for k,v in pairs(GDatatab_skill) do
        if v.skill_type == 1 then
            table.insert(self.m_tSkillList,v.id)
        end
    end
end

--@brief 展示所有的技能道具
function WndCityBottomBar:showSkillProps(itemId,expv)
    WZLog("WndCityBottomBar:showSkillProps")

    if self.m_bHavePos == true then
        return
    end
    if self.m_nUpdateLevelSkillId ~= nil then
        self.m_nCurShowSkillId = self.m_nUpdateLevelSkillId
        self.m_nUpdateLevelSkillId = nil
    end
    local skills = {}
    for i,v in ipairs(itemId) do
        local skillInfo = GDatatab_skill["id_" .. v]
        local id_group  = skillInfo.id_group
        local skillItem = {id = v,status = 2,exp = expv[i],group = id_group,equip=4,hdtj=skillInfo.hdtj,hdtjcs=skillInfo.hdtjcs,level=skillInfo.specialAttackParam,sort=skillInfo.sort}
        table.insert(skills,skillItem)
    end

    self:initSkills()

    ---[[
    for i,v in ipairs(self.m_tSkillList) do
        local isExit = false
        local skillInfo  = GDatatab_skill["id_" .. v]
        for j,k in ipairs(skills) do
            if k.id == v or skillInfo.id_group == k.group  then
                isExit = true
            end
        end
        
        if not isExit then
            local id_group = skillInfo.id_group
            if skillInfo.specialAttackParam == 1 then
                local skillItem = {id = v,status = 1 ,exp = 0,group = id_group,equip=4,hdtj=skillInfo.hdtj,hdtjcs=skillInfo.hdtjcs,level=skillInfo.specialAttackParam,sort=skillInfo.sort}
                table.insert(skills,skillItem)
            end
        end
    end
    --]]

    local equipsSkillCount = 0
    for i,v in ipairs(skills) do
        for i1,v1 in ipairs(self.m_tPlayerSkillInfo.skillId) do
            if v1==v.id then
               v.equip = 5
               equipsSkillCount = equipsSkillCount + 1
            end
        end
    end
    
    self.m_tAllSkillProps = WndSkillProp:sortSkill(equipsSkillCount,#itemId,skills)

    local isRed = false
    for i,v in ipairs(self.m_tAllSkillProps) do

        local skillTable = GDatatab_skill["id_"..v.id]
        local bisLock = v.status
        local path = skillTable.icon
        local name = skillTable.name
        local explain = skillTable.tool_desc
        local skillStats = LocalStrings.UNEQUIPPED
        local openTip = skillTable.tj_desc
        local openType  = skillTable.hdtj
        local vipLevel = skillTable.hdtjcs
        local levelIcon = skillTable.lv_icon
        
        if bisLock == 1 then
            skillStats = LocalStrings.LOCKED
        elseif v.equip == 5 then
            skillStats = LocalStrings.EQUIPPED
        end

        if skillStats == LocalStrings.LOCKED then

        elseif skillStats ==LocalStrings.EQUIPPED then

            if i == 1 and self.m_nCurShowSkillId == nil then
                bEquipped = true
            elseif v.id == self.m_nCurShowSkillId then
                bEquipped = true
            end
        end

        if self.m_nCurShowSkillId == nil and i == 1 then

        elseif self.m_nCurShowSkillId ~= nil and v.id == self.m_nCurShowSkillId then

        end
        if WndSkillProp:skillCanActivation(v.id, self.m_tAllSkillProps) then
            isRed = true 
            break
        elseif WndSkillProp:skillCanUpdate(v.id, self.m_tAllSkillProps) then
            isRed = true 
            break
        end
    end
    
    if isRed and CheckButtonOpen(ISLAND_RIGHT_ITEM,true) then
        CacheCenter:setRedState("btnItem", true)
        WZLog("WndCityBottomBar:receiveGetPlayerSkillOk three")
    else
        CacheCenter:setRedState("btnItem", false)
        WZLog("WndCityBottomBar:receiveGetPlayerSkillOk four")
    end
    GlobalGame:getBtnRedPointEvent():dispatcher()
end

--@brief   获取抽奖宠物时间成功
function WndCityBottomBar:getTime(type,time)
    WZLog("WndCityBottomBar:getTime",type[1], type[2], time[1], time[2])
    --if (time[1] <= 0 or time[2] <= 0) and CheckButtonOpen(ISLAND_RIGHT_PET,true) then
    if (time[1] <= 0 or GlobalGame.g_tRedPointList.petFetter) and CheckButtonOpen(ISLAND_RIGHT_PET,true) then
        CacheCenter:setRedState("btnPet", true)
        WZLog("WndCityBottomBar:getTime one")
    else
        CacheCenter:setRedState("btnPet", false)
        WZLog("WndCityBottomBar:getTime two")
    end
    GlobalGame:getBtnRedPointEvent():dispatcher()
end

--@brief    人物升级后更新左菜单
function WndCityBottomBar:updatePlayerInfoData()
    if self.m_root == nil then
        return
    end
    
    local bUpdateFlag = false --是否更新，仅当有新功能开放时才更新
    if CacheCenter:getPlayerInfo().level <= 99 then
        for i,v in ipairs(self.m_tBtnsInfo) do
            if v.buttonStatus3Level == CacheCenter:getPlayerInfo().level and checkbuttonChannel(v.buttonChannel) then
                bUpdateFlag = true
                break
            end
        end
    end
    if bUpdateFlag then
        self:_update()
    end
end

local btnIndex = WndBottomBarBtnIndex

local btnExtendIndex = WndBottomBarBtnExtendIndex

local btnIndexLeft =
{
    [ISLAND_LEFT_MESSAGE] = "Notice",
    [ISLAND_LEFT_MAIL] = "Mail",
    [ISLAND_LEFT_FRIEND] = "Friend",
    [ISLAND_LEFT_TEACH] = "Guide",
    [ISLAND_LEFT_LIBRARY] = "Library",
    [ISLAND_LEFT_SETTING] = "Set",
    [ISLAND_LEFT_HELPER] = "Helper",
    [ISLAND_LEFT_4399] = "4399",
    [ISLAND_LEFT_FB] = "Fb",
    [ISLAND_LEFT_BBS] = "BBS",
    [ISLAND_LEFT_GROUP] = "Group",
    [ISLAND_LEFT_SURVEY] = "Survey",
}


--@brief    更新左菜单扩展UI界面
function WndCityBottomBar:_updateExtend()
    local nTag = 0
    local offset = 0.314
    local indexNo = 0
    self.m_nBtnExtendCount = 0
    for i,v in ipairs(self.m_tBtnsInfoExtend) do
        local isOpen = SceneCity:checkIconButtonOpen(v) and checkbuttonChannel(v.buttonChannel)
        if isOpen then
            self.m_nBtnExtendCount = self.m_nBtnExtendCount + 1
        else
            indexNo = indexNo+ 1
        end
    end

    local id = 0
    for i,v in ipairs(self.m_tBtnsInfoExtend) do
        local conBtn = GetElement(self.m_root, "btn"..btnExtendIndex[v.buttonId].."_WndBottomBar", WZUIButton)
        local isOpen = SceneCity:checkIconButtonOpen(v) and checkbuttonChannel(v.buttonChannel)

        if isOpen then
            id =id + 1
            local offsetY = 0.027 + offset * (id-1)
            conBtn:setVisible(true)
            conBtn:setRelativePosition(GlobalMethod:ccp(0.619962, offsetY))
            WZLog("WndCityBottomBar:_updateExtend", i, id, tostring(v.buttonId), tostring(btnExtendIndex[v.buttonId]), offsetX, offsetY, indexNo, self.m_nBtnExtendCount)
        else
            conBtn:setVisible(false)
        end
    end
end

--@brief    更新左菜单UI界面
function WndCityBottomBar:_update()
    WZLog("WndCityBottomBar:_update zero", tostring(self.m_root))
    self:_setDefaultBtnsInfo()
    if self.m_root == nil then
        return
    end
    
    --信号
    --self:_setNetSignal()

    local nTag = 0
    local offset = 0.077
    local indexNo = 0
    self.m_nBtnCount = 0
    for i,v in ipairs(self.m_tBtnsInfo) do
        local isOpen = SceneCity:checkIconButtonOpen(v) and checkbuttonChannel(v.buttonChannel)
        if v.buttonId == ISLAND_RIGHT_SHARE then
            if IsNewHeroControl() then
                isOpen = isOpen and g_bloc_spread == "true"
            else
                isOpen = isOpen and PassportSdkManager.showHeoShare
            end
        end

        if isOpen then
            self.m_nBtnCount = self.m_nBtnCount + 1
        else
            indexNo = indexNo+ 1
        end
    end

    local id = 0
    for i,v in ipairs(self.m_tBtnsInfo) do
		WZLog("WndCityBottomBar:_update one", i, id, tostring(v.buttonId))
		if btnIndex[v.buttonId] ~= nil then

        local conBtn = GetElement(self.m_root, "btn"..btnIndex[v.buttonId].."_WndBottomBar", WZUIButton)
        local isOpen = SceneCity:checkIconButtonOpen(v) and checkbuttonChannel(v.buttonChannel)

        if v.buttonId == ISLAND_RIGHT_SHARE then
            if IsNewHeroControl() then
                isOpen = isOpen and g_bloc_spread == "true"
            else
                isOpen = isOpen and PassportSdkManager.showHeoShare
            end
        end

        if isOpen then
            id =id +1
            local offsetY = 0.963 - offset * (id-1)
            conBtn:setVisible(true)
            conBtn:setRelativePosition(GlobalMethod:ccp(offsetY, 0.066))
            WZLog("WndCityBottomBar:_update two", i, id, tostring(v.buttonId), tostring(btnIndex[v.buttonId]), offsetY, indexNo, self.m_nBtnCount)
        else
            conBtn:setVisible(false)
        end

        end
    end

--    self:_updateExtend()

    local nTag = 0
    local offset = 0.19

    local id = 0
    for i,v in ipairs(self.m_tLeftBtnsInfo) do
        local conBtn = GetElement(self.m_root, "btn"..btnIndexLeft[v.buttonId].."_WndBottomBar", WZUIButton)
        local isOpen = SceneCity:checkIconButtonOpen(v) and checkbuttonChannel(v.buttonChannel, v.buttonId)

        -- if v.buttonId == 15 then
        --     isOpen = false
        -- end

        if v.buttonId == ISLAND_LEFT_HELPER and IsNewHeroControl() then
            isOpen = isOpen and g_bloc_tactic == "true"
        end

        WZLog("WndOwnCity:_update three", v.buttonId, isOpen)
        if v.buttonId == 100 and isOpen then
            WZLog("WndOwnCity:_update one2")
            local conBtn = GetElement(SceneCity.m_tWndBottomBarObj.m_root, "btnFb_WndBottomBar", WZUIButton)
            conBtn:setVisible(true)
        elseif v.buttonId == 102 and isOpen then
            WZLog("WndOwnCity:_update one2")
            local conBtn = GetElement(SceneCity.m_tWndBottomBarObj.m_root, "btnGroup_WndBottomBar", WZUIButton)
            conBtn:setVisible(true)
        elseif conBtn and isOpen then
            conBtn:setVisible(true)
            id =id +1
            local offsetY = 0.027 + offset * (id-1)
        --    local offsetY = 0.963 - offset * (id - 1)
            conBtn:setRelativePosition(GlobalMethod:ccp(0.62, offsetY))
            WZLog("WndOwnCity:_update one", i, id, tostring(v.buttonId), tostring(btnIndexLeft[v.buttonId]), offsetY)
        elseif conBtn then
            conBtn:setVisible(false)
        end
    end
end

--@brief	移动水平条
--@note
function WndCityBottomBar:moveHorizontalBar(direction)
    WZLog("WndCityBottomBar:moveHorizontalBar one", tostring(self.m_nMoveDirection), tostring(self.m_bIsMoveHorizontalBar))
    if self.m_bIsMoveHorizontalBar ~= true then
        self.m_bIsMoveHorizontalBar = true

        local t = 0.3
        local x, y = 0.88,0.15

        if direction == 0 then
            x, y = 0.94,0.5
        else
            x, y = 2.5,0.5
        end

        --创建序列动作
        local actionSequence = WZUIActionSequence:create()
        actionSequence:setIsLoop( false )
        --创建移动动作
        local actMoveTo = WZUIActionMoveTo:create()
        actMoveTo:setDuration(t)
        actMoveTo:setMoveX(x)
        actMoveTo:setMoveY(y)
        actMoveTo:setFinishLuaFunction("endMoveHorizontalBar")
        actMoveTo:setFinishLuaTable(self)
        actionSequence:setChildAction( actMoveTo )

        --self:getHorizontalBar():runUIAction( actionSequence )
    end

end

--@brief	移动的结束回调
--@param	sender:回调元素
--@note
function WndCityBottomBar:endMoveHorizontalBar(sender)
    WZLog("WndCityBottomBar:endMoveHorizontalBar")
    self.m_bIsMoveHorizontalBar = false
end

--@brief    关闭展开栏的响应方法
function WndCityBottomBar:hideExtend(element)
    WZLog("WndCityBottomBar:hideExtend")

    GetElement(self.m_root,"conAllExtend_WndBottomBar",WZUIContainer):setVisible(false)
end

--@brief    点击任务按钮后的响应方法
function WndCityBottomBar:clickCurTask(element)
    WZLog("WndCityBottomBar:clickCurTask one", self.m_nTaskShowIndex, self.m_nRewardIndex, self.m_nTaskingIndex)
    if self.m_nTaskShowIndex > 0 then
        local index = 0
        if self.m_nTaskShowIndex == 1 then
            if self.m_nRewardIndex == 1 then
                WZLog("WndCityBottomBar:clickCurTask three 1")
                index = 0
            elseif self.m_nRewardIndex == 2 then
                WZLog("WndCityBottomBar:clickCurTask three 2")
                index = 2
            elseif self.m_nRewardIndex == 3 then
                WZLog("WndCityBottomBar:clickCurTask three 3")
                index = 1
            end
        elseif self.m_nTaskShowIndex == 2 then
            if self.m_nTaskingIndex == 1 then
                WZLog("WndCityBottomBar:clickCurTask three 4")
                index = 0
            elseif self.m_nTaskingIndex == 2 then
                WZLog("WndCityBottomBar:clickCurTask three 5")
                index = 2
            elseif self.m_nTaskingIndex == 3 then
                WZLog("WndCityBottomBar:clickCurTask three 6")
                index = 1
            end
        end
        WZLog("WndCityBottomBar:clickCurTask two", index)
        WndTask:showInterface(index)
    end
end

--@brief    点击展开按钮后的响应方法
function WndCityBottomBar:onClickMore(element)
    WZLog("WndCityBottomBar:onClickMore")

    local isTeach = TeachGroup1.ISTEACH == true and (TeachGroup1.GROUP == 8 and TeachGroup1.STEP == 9 or TeachGroup1.GROUP == 9 and TeachGroup1.STEP == 9) 

    if isTeach == true then
        return
    end
    TeachGroup1:endTeachStep({42,2},{44,2})

    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    local element = GetElement(self.m_root,"conAllExtend_WndBottomBar",WZUIContainer)
    local isVisible = element:isVisible()
    element:setVisible(not isVisible)

    local isFinish42, finishStep42 = TeachGroup1:isTeachFinish(42)
    local isFinish43, finishStep43 = TeachGroup1:isTeachFinish(43)
    local isFinish44, finishStep44 = TeachGroup1:isTeachFinish(44)

    if isFinish42 ~= true and finishStep42 >= 0 and CacheCenter:getPlayerInfo().level == 19 then
        TeachGroup1:startGroup({42,3,self.m_root})
    elseif isFinish44 ~= true and finishStep44 >= 0 and CacheCenter:getPlayerInfo().level == 30 then
        TeachGroup1:startGroup({44,3,self.m_root})
    end
end

--@brief    点击角色按钮后的响应方法
function WndCityBottomBar:onClickPlayer(element)
    WZLog("WndCityBottomBar:onClickPlayer")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

	--WndRewardShow:showById({4259},{1})
 --    local info = {playerId = 24166, playerName = "abc", playerSex = 1, headId = 4903, faceId = 4902, bodyId = 4901, wingId = 0, playerTitle="", mountsId=0, colour=1, bodyColour=0}
 --    if SceneCity.m_root then
 --        FigureSceneManager:getInstance():createOtherFigures({info}, true)
 --    end
	-- do return end

    -- do
    --     g_test1111 = true
    --     if SceneCity.m_root == nil then
    --         replaceScene(SceneCity:createElement())
    --     else
    --         WZLog("WndRewardShow:onExit four")
    --         SceneCity.m_bIsNoRelease = true
    --         replaceScene(SceneCity:createElement(true))
    --     end
    --  return end

    if CheckButtonOpen(ISLAND_RIGHT_PLAYER) then
        TeachGroup1:endTeachStep({8,3})
        WndBagMain:showBag()
    end
end

--@brief    点击修炼按钮后的响应方法
function WndCityBottomBar:onClickPractice(element)
    WZLog("WndCityBottomBar:onClickPractice")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_EXTEND_PRACTICE) then
        local wndPractice = WndPractice:createElement()
        if wndPractice ~= nil then
            WindowManager:addWindow(wndPractice, WndPractice, false)
        end
    end
end

--@brief    点击觉醒按钮后的响应方法
function WndCityBottomBar:onClickAwaken(element)
    WZLog("WndCityBottomBar:onClickAwaken")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_RIGHT_AWAKEN) then
        WndWakeup:showInterface()
    end
end

--@brief    点击幻化按钮后的响应方法
function WndCityBottomBar:onClickPhantom(element)
    WZLog("WndCityBottomBar:onClickPhantom")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_RIGHT_PHANTOM) then
        WndPhantom:showWin()
    end
end

--@brief    点击符文按钮后的响应方法
function WndCityBottomBar:onClickRune(element)
    WZLog("WndCityBottomBar:onClickRune")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and 
        (TeachGroup1.GROUP == 42 and TeachGroup1.STEP == 3
        )
    if CheckButtonOpen(ISLAND_RIGHT_RUNE_MAIN) and isTeach ~= true then
        WndBagMain:showRune()
    end
end

--@brief    点击卡牌按钮后的响应方法
function WndCityBottomBar:onClickCard(element)
    WZLog("WndCityBottomBar:onClickCard")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_EXTEND_CARD) then
        WndCard:showInterface(nil)
    end
end

--@brief    点击魅力空间按钮后的响应方法
function WndCityBottomBar:onClickCharm(element)
    WZLog("WndCityBottomBar:onClickCharm")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and (TeachGroup1.GROUP == 16 and TeachGroup1.STEP == 1 or TeachGroup1.GROUP == 8 and TeachGroup1.STEP == 3)

    if CheckButtonOpen(ISLAND_EXTEND_CHARM) and isTeach ~= true then
        local wndCharmSpace = WndCharmSpace:createElement()
        if wndCharmSpace ~= nil then
            WindowManager:addWindow(wndCharmSpace, WndCharmSpace, false)
        end
    end
end

--@brief    排行榜点击回调
function WndCityBottomBar:onClickRank(element)
    WZLog("WndCityBottomBar:onClickRank")
    TeachGroup1:endTeachStep({16,1})
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and (TeachGroup1.GROUP == 23 and TeachGroup1.STEP == 1)

    if CheckButtonOpen(ISLAND_BUILDING_RANK) and isTeach ~= true then
       local pWndRankList = WndRankList:createElement()
       if pWndRankList ~= nil then
           WindowManager:addWindow( pWndRankList , WndRankList )
       end
    end
end

--获取地理位置OK
function WndCityBottomBar:reGeocodeSearchOk(province, city, district)
    WZLog("WndCityBottomBar:reGeocodeSearchOk",tostring(province), tostring(city), tostring(district))  
end 

--@brief    点击升阶按钮后的响应方法
function WndCityBottomBar:onClickAscending(element)
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_EXTEND_ASCEND) then
        local wnd = WndAscending:createElement()
        WindowManager:addWindow(wnd, WndAscending, false)
    end
end

--@brief    点击衣橱按钮后的响应方法
function WndCityBottomBar:onClickWardrobe(element)
    WZLog("WndCityBottomBar:onClickWardrobe")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_EXTEND_WARDROBE) then
        Wndwardrobe:show()
        --self:onClickLbs()
    end
end

--@brief    点击BBS按钮后的响应方法
function WndCityBottomBar:onClickBBS(element)
    if CheckButtonOpen(ISLAND_LEFT_BBS) then
        EnterSDKBBS()
    end
end

--@brief    点击邮件按钮后的响应方法
function WndCityBottomBar:onClickMail(element)
    WndOwnCity:onClickMail(element)
end

--@brief    点击好友按钮后的响应方法
function WndCityBottomBar:onClickFriend(element)
    WndOwnCity:onClickFriend(element)
end

--@brief    点击图鉴按钮后的响应方法
function WndCityBottomBar:onClickGuide(element)
    WndOwnCity:onClickGuide(element)
end

--@brief    点击设置按钮后的响应方法
function WndCityBottomBar:onClickSet(element)
    WndOwnCity:onClickSet(element)
end

--@brief    点击助手按钮后的响应方法
function WndCityBottomBar:onClickHelper(element)
    WndOwnCity:onClickHelper(element)
end
--@brief    点击FB按钮后的响应方法
function WndCityBottomBar:onClickFb(element)
    WndOwnCity:onClickFb(element)
end

--@brief    点击GROUP按钮后的响应方法
function WndCityBottomBar:onClickGroup(element)
    WndOwnCity:onClickGroup(element)
end

--@brief    移动的结束回调
--@param    sender:回调元素
--@note
function WndCityBottomBar:endMoveVerticalBar3(sender)
    WZLog("WndCityBottomBar:endMoveVerticalBar3")
    local x, y = 1.5,0.5
    local t = 0.15

    --创建序列动作
    local actionSequence = WZUIActionSequence:create()
    actionSequence:setIsLoop( false )
    --创建移动动作
    local actMoveTo = WZUIActionMoveTo:create()
    actMoveTo:setDuration(t)
    actMoveTo:setMoveX(x)
    actMoveTo:setMoveY(y)
    actMoveTo:setFinishLuaFunction("endMoveVerticalBar4")
    actMoveTo:setFinishLuaTable(self)
    actionSequence:setChildAction( actMoveTo )

    GetElement(self.m_root,"conVertical3_WndBottomBar",WZUIContainer):runUIAction( actionSequence )
end

--@brief    移动的结束回调
--@param    sender:回调元素
--@note
function WndCityBottomBar:endMoveVerticalBar4(sender)
    WZLog("WndCityBottomBar:endMoveVerticalBar4")
    GetElement(self.m_root,"conVertical3_WndBottomBar",WZUIContainer):setVisible(true)

    local x, y = 0.0,0.5
    local t = 0.3

    --创建序列动作
    local actionSequence = WZUIActionSequence:create()
    actionSequence:setIsLoop( false )
    --创建移动动作
    local actMoveTo = WZUIActionMoveTo:create()
    actMoveTo:setDuration(t)
    actMoveTo:setMoveX(x)
    actMoveTo:setMoveY(y)
    actMoveTo:setFinishLuaFunction("endMoveVerticalBar")
    actMoveTo:setFinishLuaTable(self)
    actionSequence:setChildAction( actMoveTo )

    self:getVerticalBar():runUIAction( actionSequence )
end

--@brief	移动垂直条
--@note
function WndCityBottomBar:moveVerticalBar(direction)
    WZLog("WndCityBottomBar:moveVerticalBar one", direction, tostring(self.m_nMoveDirection), tostring(self.m_bIsMoveVerticalBar), tostring(self.m_bIsNeedMoveVerticalBar))
    --do return end
    if self.m_bIsMoveVerticalBar ~= true and self.m_bIsNeedMoveVerticalBar == true then
        self.m_bIsMoveVerticalBar = true
        self.m_nMoveDirection = direction
        local t = 0.3
        local x, y = 0,0

        if direction == 0 then
            x, y = 0.0,0.5
            WZLog("WndCityBottomBar:moveVerticalBar two", self.m_nBtnCount, y)
            --WndCurrentChat:wndCurChatVisible(false)
        else
            GetElement(self.m_root,"conAllExtend_WndBottomBar",WZUIContainer):setVisible(false)
            x, y = 1,0.5
        end

        
        if direction == 0 then
            -- GetElement(self.m_root,"conVertical3_WndBottomBar",WZUIContainer):setVisible(false)
            -- actMoveTo:setFinishLuaFunction("endMoveVerticalBar")

            self:endMoveVerticalBar3()
        else
            --创建序列动作
            local actionSequence = WZUIActionSequence:create()
            actionSequence:setIsLoop( false )
            --创建移动动作
            local actMoveTo = WZUIActionMoveTo:create()
            actMoveTo:setDuration(t)
            actMoveTo:setMoveX(x)
            actMoveTo:setMoveY(y)
            actMoveTo:setFinishLuaFunction("endMoveVerticalBar2")
            actMoveTo:setFinishLuaTable(self)
            actionSequence:setChildAction( actMoveTo )

            self:getVerticalBar():runUIAction( actionSequence )
        end
        



        t = 0.45
        if direction == 0 then
            x, y = 0.5,0.5
        else
            x, y = 0.5,-0.5
        end

        --创建序列动作
        local actionSequence = WZUIActionSequence:create()
        actionSequence:setIsLoop( false )
        --创建移动动作
        local actMoveTo = WZUIActionMoveTo:create()
        actMoveTo:setDuration(t)
        actMoveTo:setMoveX(x)
        actMoveTo:setMoveY(y)
        actionSequence:setChildAction( actMoveTo )

        GetElement(self.m_root,"conVertical2_WndBottomBar",WZUIContainer):runUIAction( actionSequence )
    end

end

--@brief	移动的结束回调
--@param	sender:回调元素
--@note
function WndCityBottomBar:endMoveVerticalBar(sender, levelUp, isTrailerAnim)
    self.m_bIsMoveVerticalBar = false

    local isFinish3, finishStep3 = TeachGroup1:isTeachFinish(3)
    local isFinish5, finishStep5 = TeachGroup1:isTeachFinish(5)
    local isFinish7, finishStep7 = TeachGroup1:isTeachFinish(7)
    local isFinish8, finishStep8 = TeachGroup1:isTeachFinish(8)
    local isFinish9, finishStep9 = TeachGroup1:isTeachFinish(9)
    local isFinish10, finishStep10 = TeachGroup1:isTeachFinish(10)
    local isFinish11, finishStep11 = TeachGroup1:isTeachFinish(11)
    local isFinish12, finishStep12 = TeachGroup1:isTeachFinish(12)
    local isFinish16, finishStep16 = TeachGroup1:isTeachFinish(16)
    local isFinish19, finishStep19 = TeachGroup1:isTeachFinish(19)
    local isFinish20, finishStep20 = TeachGroup1:isTeachFinish(20)
    local isFinish26, finishStep26 = TeachGroup1:isTeachFinish(26)
    local isFinish31, finishStep31 = TeachGroup1:isTeachFinish(31)
    local isFinish32, finishStep32 = TeachGroup1:isTeachFinish(32)
    local isFinish33, finishStep33 = TeachGroup1:isTeachFinish(33)
    local isFinish34, finishStep34 = TeachGroup1:isTeachFinish(34)
    local isFinish35, finishStep35 = TeachGroup1:isTeachFinish(35)
    local isFinish36, finishStep36 = TeachGroup1:isTeachFinish(36)
    local isFinish37, finishStep37 = TeachGroup1:isTeachFinish(37)
    local isFinish39, finishStep39 = TeachGroup1:isTeachFinish(39)
    local isFinish40, finishStep40 = TeachGroup1:isTeachFinish(40)
    local isFinish41, finishStep41 = TeachGroup1:isTeachFinish(41)
    local isFinish42, finishStep42 = TeachGroup1:isTeachFinish(42)
    local isFinish43, finishStep43 = TeachGroup1:isTeachFinish(43)
    local isFinish44, finishStep44 = TeachGroup1:isTeachFinish(44)
    WZLog("WndCityBottomBar:endMoveVerticalBar1", tostring(self.m_nMoveDirection),
        finishStep3,finishStep5,finishStep8,finishStep9,finishStep10,finishStep11,finishStep12,
        finishStep19,finishStep26,finishStep20,isFinish3,isFinish5,isFinish8,isFinish9,isFinish10,
        isFinish11,isFinish12,isFinish19,isFinish26,isFinish20, isFinish31, finishStep31)

    local isTeach = true
    local tryTeach = nil
    if isFinish44 ~= true and finishStep44 >= 0 and CacheCenter:getPlayerInfo().level == 32 then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {44,2, self.m_root})
        tryTeach = true
    elseif isFinish19 ~= true and CheckButtonOpen(28,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {19,2, self.m_root})
        tryTeach = true
    elseif isFinish43 ~= true and finishStep43 >= 0 and (CacheCenter:getPlayerInfo().level == 19 or TeachGroup1.ISTEACHMODE) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {43,2, self.m_root})
        tryTeach = true
    elseif isFinish42 ~= true and finishStep42 >= 0 and (CacheCenter:getPlayerInfo().level == 24 or TeachGroup1.ISTEACHMODE)  then
        --isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {42,2, self.m_root})
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {42,2, SceneCity.m_root})
        tryTeach = true
    elseif isFinish11 ~= true and CheckButtonOpen(43,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {11,2, self.m_root})
        tryTeach = true
    -- elseif isFinish16 ~= true and (CacheCenter:getPlayerInfo().level == 10 or TeachGroup1.ISTEACHMODE) then
    --     isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {16,1, self.m_root})
    --     tryTeach = true
    elseif isFinish10 ~= true and CheckButtonOpen(41,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {10,2, self.m_root})
        tryTeach = true
    elseif isFinish37 ~= true and CheckButtonOpen(58,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {37,2, self.m_root})
        tryTeach = true
    elseif isFinish12 ~= true and CheckButtonOpen(27,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {12,2, self.m_root})
        tryTeach = true
    elseif isFinish41 ~= true and finishStep41 > 0 and WndEquipmentLottery.m_root == nil then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {41,8, self.m_root})
        tryTeach = true
    elseif isFinish20 ~= true and finishStep20 > 0 then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {20,7, self.m_root})
        tryTeach = true
    elseif isFinish26 ~= true and CacheCenter:getPlayerInfo().level <= 10 and  (TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_7) or TeachGroup1.ISTEACHMODE) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {26,10, self.m_root})
        tryTeach = true
    elseif isFinish3 ~= true then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {3,3, self.m_root})
        tryTeach = true
    elseif isFinish5 ~= true and finishStep5 < 8 then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {5,3, self.m_root})
        tryTeach = true
    elseif isFinish5 ~= true then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {5,10, self.m_root})
        tryTeach = true
    elseif isFinish40 ~= true and TeachGroup1:isTaskTeachFinish(10206)  then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {40,2, self.m_root})
        tryTeach = true
    elseif isFinish39 ~= true and TeachGroup1:isTaskTeachFinish(10205)  then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {39,2, self.m_root})
        tryTeach = true
    elseif isFinish36 ~= true and TeachGroup1:isTaskTeachFinish(10204)  then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {36,2, self.m_root})
        tryTeach = true
    elseif isFinish35 ~= true and TeachGroup1:isTaskTeachFinish(10203)  then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {35,2, self.m_root})
        tryTeach = true
    elseif isFinish34 ~= true and TeachGroup1:isTaskTeachFinish(10202)  then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {34,2, self.m_root})
        tryTeach = true
    elseif isFinish33 ~= true and TeachGroup1:isTaskTeachFinish(10201)  then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {33,2, self.m_root})
        tryTeach = true
    elseif isFinish32 ~= true and finishStep32 > 0  then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {32,3, self.m_root})
        tryTeach = true
    elseif isFinish31 ~= true  and TeachGroup1:isTaskTeachFinish(10104)  then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {31,2, self.m_root})
        tryTeach = true
    elseif isFinish7 ~= true and finishStep7 > 0  then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {7,4, self.m_root})
        tryTeach = true
    elseif isFinish8 ~= true and TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_3) then
        if finishStep8 < 5 then
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {8,3, self.m_root})
            tryTeach = true
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {8,7, self.m_root})
            tryTeach = true
        end
    elseif isFinish9 ~= true and CheckButtonOpen(40,false) then
        if finishStep9 < 5 then
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {9,2, self.m_root})
            tryTeach = true
        else
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {9,7, self.m_root})
            tryTeach = true
        end
    end

    WZLog("WndCityBottomBar:endMoveVerticalBar3", tostring(isTeach), tostring(tryTeach))
    if isTeach == false or tryTeach == nil then
        if isEndTeach3 ~= true and finishStep3 > 0 then
            TeachGroup1:setTeachFinish(3, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-3")
        end
        if isEndTeach5 ~= true and finishStep5 > 0 then
            TeachGroup1:setTeachFinish(5, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-5")
        end
        if isEndTeach7 ~= true and finishStep7 > 0 then
            TeachGroup1:setTeachFinish(7, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-7")
        end
        if isEndTeach8 ~= true and finishStep8 > 0 then
            TeachGroup1:setTeachFinish(8, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-8")
        end
        if isEndTeach9 ~= true and finishStep9 > 0 then
            TeachGroup1:setTeachFinish(9, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-9")
        end
        if isEndTeach10 ~= true and finishStep10 > 0 then
            TeachGroup1:setTeachFinish(10, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-10")

        end
        if isEndTeach11 ~= true and finishStep11 > 0 then
            TeachGroup1:setTeachFinish(11, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-11")
        end
        if isEndTeach12 ~= true and finishStep12 > 0 then
            TeachGroup1:setTeachFinish(12, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-12")
        end
        if isEndTeach19 ~= true and finishStep19 > 0 then
            TeachGroup1:setTeachFinish(19, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-19")
        end
        if isEndTeach20 ~= true and finishStep20 > 0 then
            TeachGroup1:setTeachFinish(20, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-20")
        end
        if isEndTeach26 ~= true and finishStep26 > 0 then
            TeachGroup1:setTeachFinish(26, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-26")

        end
        if isEndTeach31 ~= true and finishStep31 > 0 then
            TeachGroup1:setTeachFinish(31, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-31")
        end
        if isEndTeach32 ~= true and finishStep32 > 0 then
            TeachGroup1:setTeachFinish(32, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-32")
        end
        if isEndTeach33 ~= true and finishStep33 > 0 then
            TeachGroup1:setTeachFinish(33, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-33")
        end
        if isEndTeach34 ~= true and finishStep34 > 0 then
            TeachGroup1:setTeachFinish(34, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-34")
        end
        if isEndTeach35 ~= true and finishStep35 > 0 then
            TeachGroup1:setTeachFinish(35, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-35")
        end
        if isEndTeach36 ~= true and finishStep36 > 0 then
            TeachGroup1:setTeachFinish(36, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-36")
        end
        if isEndTeach37 ~= true and finishStep37 > 0 then
            TeachGroup1:setTeachFinish(37, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-37")
        end
        if isEndTeach39 ~= true and finishStep39 > 0 then
            TeachGroup1:setTeachFinish(39, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-39")
        end
        if isEndTeach40 ~= true and finishStep40 > 0 then
            TeachGroup1:setTeachFinish(40, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-40")

        end
        if isEndTeach41 ~= true and finishStep41 > 0 then
            TeachGroup1:setTeachFinish(41, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-41")
        end
        if isEndTeach42 ~= true and finishStep42 > 0 then
            TeachGroup1:setTeachFinish(42, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-42")
        end
        if isEndTeach43 ~= true and finishStep43 > 0 then
            TeachGroup1:setTeachFinish(43, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-43")
        end
        if isEndTeach44 ~= true and finishStep44 > 0 then
            TeachGroup1:setTeachFinish(44, -1)
            WZLog("WndCityBottomBar:endMoveVerticalBar2-44")
        end
        WindowManager:removeTeachShelterLayer()
        TeachGroup1:removeTeach()
    end
    return isTeach
end

--@brief	移动的结束回调
--@param	sender:回调元素
--@note
function WndCityBottomBar:endMoveVerticalBar2(sender)
    WZLog("WndCityBottomBar:endMoveVerticalBar2")
    --self.m_bIsMoveVerticalBar = false
    GetElement(self.m_root,"conVertical3_WndBottomBar",WZUIContainer):setVisible(true)

    local x, y = 1.0,0.5
    local t = 0.15

    --创建序列动作
    local actionSequence = WZUIActionSequence:create()
    actionSequence:setIsLoop( false )
    --创建移动动作
    local actMoveTo = WZUIActionMoveTo:create()
    actMoveTo:setDuration(t)
    actMoveTo:setMoveX(x)
    actMoveTo:setMoveY(y)
    actMoveTo:setFinishLuaFunction("endMoveVerticalBar2_2")
    actMoveTo:setFinishLuaTable(self)
    actionSequence:setChildAction( actMoveTo )


    GetElement(self.m_root,"conVertical3_WndBottomBar",WZUIContainer):runUIAction( actionSequence )
end

--@brief    移动的结束回调
--@param    sender:回调元素
--@note
function WndCityBottomBar:endMoveVerticalBar2_2(sender, levelUp, isTrailerAnim)
    self.m_bIsMoveVerticalBar = false

end


--@brief	设置是否需要移动垂直条
--@note
function WndCityBottomBar:setNeedMoveVerticalBar(isNeed)
    WZLog("WndCityBottomBar:setNeedMoveVerticalBar one")
    self.m_bIsNeedMoveVerticalBar = isNeed
    --GetElement(self.m_root, "conBottom_WndBottomBar"):setVisible(isNeed)
end

--@brief	设置是否需要聊天按钮
--@note
function WndCityBottomBar:setNeedChat(isNeed)
    WZLog("WndCityBottomBar:setNeedChat one")
    self.m_bIsNeedChat = isNeed
    GetElement(self.m_root, "btnChat_WndBottomBar"):setVisible(isNeed)
end

--@brief	水平条
--@note		滚动条
function WndCityBottomBar:getHorizontalBar()
    WZLog("WndCityBottomBar:getHorizontalBar one")
    if self.m_root then
        return GetElement(self.m_root,"conHorizontal_WndBottomBar",WZUIContainer)
    end
end

--@brief	垂直条
--@note		滚动条
function WndCityBottomBar:getVerticalBar()
    WZLog("WndCityBottomBar:getVerticalBar one")
    if self.m_root then
        return GetElement(self.m_root,"conVertical_WndBottomBar",WZUIContainer)
    end
end

--@brief	设置开关
--@note		开关图片设置
function WndCityBottomBar:setSwitchState(state)
    --WZLog("WndCityBottomBar:setSwitchState one",tostring(state))
    if self.m_root and self.m_bIsMoveHorizontalBar ~= true and self.m_bIsMoveVerticalBar ~= true and self.m_bIsNeedMoveVerticalBar == true then
        local res = "ui/city/beta/main_icon_di09_2.png"
        if state ~= true then
            res = "ui/city/beta/main_icon_di10_2.png"
        end
        self.m_sRes = res
        GetElement(self.m_root,"imgSwitch_WndBottomBar",WZUIImage):setFile(res)
        GetElement(self.m_root,"imgSwitch2_WndBottomBar",WZUIImage):setFile(res)
        --GetElement(self.m_root,"imgSwitchOn2_WndBottomBar",WZUIImage):setVisible(not state)

        local AllBtn = GetElementWithoutAssert(self.m_root,"btnSwitch_WndBottomBar",WZUIButton)
        local m_bContainsRedPoint = self.m_bRed or CacheCenter:getRedState("btnFriend") or CacheCenter:getRedState("btnMail")
        if state ~= true then
            m_bContainsRedPoint = self.m_bRed
        else
            m_bContainsRedPoint = CacheCenter:getRedState("btnFriend") or CacheCenter:getRedState("btnMail")
        end
        WZLog("WndCityBottomBar:setSwitchState", tostring(state), tostring(m_bContainsRedPoint), tostring(CacheCenter:getRedState("btnFriend")), tostring(CacheCenter:getRedState("btnMail")))
        -- if state ~= true then
            if m_bContainsRedPoint then
                if not AllBtn:getChildByTag(89) then
                    local spr_redPoint =  CCSprite:create("ui/common/common_icon_xiaodianzhui.png")
                    AllBtn:addChild(spr_redPoint,5,89)

                    local position = ccp(45,45)
                    spr_redPoint:setPosition(position)
                end
            else 
                if  AllBtn:getChildByTag(89) then 
                    AllBtn:removeChildByTag(89,true)
                end
            end 
        -- else
        --     if  AllBtn:getChildByTag(89) then 
        --         AllBtn:removeChildByTag(89,true)
        --     end
        -- end

    end
end

--@brief	设置开关
--@note		开关图片设置
function WndCityBottomBar:getSwitchState()
    WZLog("WndCityBottomBar:getSwitchState one")
    if self.m_root then
        local file = GetElement(self.m_root,"imgSwitch_WndBottomBar",WZUIImage):getFile()
        local state = false
        if self.m_sRes == "ui/city/beta/main_icon_di09_2.png" then
            state = true
        end
        return state
    end
end

--@brief	点击聊天按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndCityBottomBar:onClickChat(element)
	WZLog("WndCityBottomBar:onClickChat")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    WndChat:showChatWindowForFightingByOrder()
end

--@brief    点击祈福按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndCityBottomBar:onClickBless(element)
    WZLog("WndCityBottomBar:onClickBless")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    TeachGroup1:endTeachStep({42,3})

    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.STEP ~= -1 and 
    (TeachGroup1.GROUP == 3 or TeachGroup1.GROUP == 5 or TeachGroup1.GROUP == 7 or TeachGroup1.GROUP == 8 or TeachGroup1.GROUP == 18
         or TeachGroup1.GROUP == 20 or TeachGroup1.GROUP == 26 or TeachGroup1.GROUP == 9 or TeachGroup1.GROUP == 31 or TeachGroup1.GROUP == 32
          or TeachGroup1.GROUP == 33 or TeachGroup1.GROUP == 34 or TeachGroup1.GROUP == 35 or TeachGroup1.GROUP == 36 or TeachGroup1.GROUP == 39
           or TeachGroup1.GROUP == 40 or TeachGroup1.GROUP == 41)
    if CheckButtonOpen(ISLAND_UP_BLESS) and isTeach ~= true then
        local wndBless = WndBless:createElement()
        if wndBless ~= nil then
            WindowManager:addWindow(wndBless,WndBless)
            return
        end
    end
end

--@brief    点击分享按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndCityBottomBar:onClickShare(element)
    WZLog("WndCityBottomBar:onClickShare")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    SceneCity:updateRedDotBuilding("share", false)
    PassportSdkManager:showHeoShare()

end

--@brief	点击背包按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndCityBottomBar:onClickBag(element)
    WZLog("WndCityBottomBar:onClickBag")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
	--师徒升级界面
	--local tData = {level=2}
	--WndMasterTip:showByType(tData,4)

    -- SceneCity:updateRedDotBuilding("help", true)
    -- do return end

    if CheckButtonOpen(ISLAND_RIGHT_BAG) then
        TeachGroup1:endTeachStep({8,3})
		WndBagRole:showWin()
    end
	--WndRewardShow:showById({1,2,3,4},{50,50,88,66})
	--WndMasterTip:showByType(tData,4)
end

--@brief	点击强化按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndCityBottomBar:onClickStrong(element)
    WZLog("WndCityBottomBar:onClickStrong")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
	--WndRewardShow:showById({3401,3401,3401,3401},{1,1,1,1})

    local isTeach = TeachGroup1.ISTEACH == true and 
        (TeachGroup1.GROUP == 5 and TeachGroup1.STEP == 3
        )

    if CheckButtonOpen(ISLAND_RIGHT_STRENGTHEN)and isTeach ~= true then
        CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_CHannel_Strengthen)
        CheckLuaLoad(Chat_CHannel_Shop)

        TeachGroup1:endTeachStep({9,2},{10,2},{11,2})
        local wndStrengthen = WndStrengthen:createElement()
        if wndStrengthen ~= nil then
            WindowManager:addWindow(wndStrengthen, WndStrengthen, false)
        end
    end
end

--@brief	点击宠物按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndCityBottomBar:onClickPet(element)
    WZLog("WndCityBottomBar:onClickPet")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    TeachGroup1:endTeachStep({12,2},{19,2})

    local isTeach = TeachGroup1.ISTEACH == true and 
        (TeachGroup1.GROUP == 44 and TeachGroup1.STEP == 3)
    if CheckButtonOpen(ISLAND_RIGHT_PET) and isTeach ~= true then
        CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_Channel_Pet)

        -- local wndPets = WndPets:createElement()
        -- if wndPets ~= nil then
        --     WindowManager:addWindow(wndPets, WndPets, false)
        -- end

        OpenPartner()
    end
end

--@brief	点击星魂按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndCityBottomBar:onClickStarSoul(element)
    WZLog("WndCityBottomBar:onClickStarSoul")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if false and FigureSceneManager:getInstance().m_tFigure ~= nil then
        FigureSceneManager:getInstance().m_tFigure:changeDisplay("", "", 1)
    end

    --if CheckButtonOpen(ISLAND_BOTTOM_SOUL) then
    --    WndStarSoul:openWndStarSoul()
    --end

    --replaceScene(WndLoveLottery:createElement())
end

--@brief	点击坐骑按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndCityBottomBar:onClickMount(element)
    WZLog("WndCityBottomBar:onClickMount")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    TeachGroup1:endTeachStep({19,2})

    local isTeach = TeachGroup1.ISTEACH == true and 
    (TeachGroup1.GROUP == 42 and TeachGroup1.STEP == 1 or 
        TeachGroup1.GROUP == 12 and TeachGroup1.STEP == 2 or 
        TeachGroup1.GROUP == 5 and TeachGroup1.STEP == 3)
	if CheckButtonOpen(ISLAND_RIGHT_MOUNT) and isTeach ~= true then
    	-- local mounts = WndMounts:createElement()
    	-- WindowManager:addWindow(mounts,WndMounts)
        OpenPartner(2)
    end
end

--@brief	点击商城按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndCityBottomBar:onClickShop(element)
    WZLog("WndCityBottomBar:onClickShop")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_BOTTOM_SHOP) then
		    local wndShop = WndShop:createElement()
			WndShop.jumpMain = nil
			WndShop.jumpSub = nil
			WindowManager:addWindow(wndShop, WndShop)
    end
end

-- --@brief	点击设置按钮后的响应方法
-- --@param	element:按钮的UI节点引用
-- --@note	在这里做相应的按钮相应事件
-- function WndCityBottomBar:onClickSet(element)
--     WZLog("WndCityBottomBar:onClickSet")
--     SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

--     if CheckButtonOpen(ISLAND_BOTTOM_SETTING) then
--         local wndSettingElement = WndSetting:createElement()
--         WindowManager:addWindow( wndSettingElement , WndSetting )
--     end
-- end

--@brief	点击公会按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndCityBottomBar:onClickGuild(element)
    WZLog("WndCityBottomBar:onClickGuild")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_BUILDING_COMMUNITY) then
        CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_Channel_Community)
        SceneCommunity:onJumpToCommunity()
    end
end

-- --@brief	点击好友按钮后的响应方法
-- --@param	element:按钮的UI节点引用
-- --@note	在这里做相应的按钮相应事件
-- function WndCityBottomBar:onClickFriend(element)
--     WZLog("WndCityBottomBar:onClickFriend")
--     SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

--     if CheckButtonOpen(ISLAND_BOTTOM_FRIEND) then
--         CheckLuaLoad(LUAFILES_BLOCK_COMMON)
--         CheckLuaLoad(Chat_Channel_Friend)
--         CheckLuaLoad(Chat_CHannel_Mail)
-- 		local friend = WndFriends:createElement()
--         WindowManager:addWindow( friend , WndFriends)        
--     end
    
-- end

--@brief	点击合成按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	    在这里做相应的按钮相应事件
function WndCityBottomBar:onClickSynthesis(element)
    WZLog("WndCityBottomBar:onClickSynthesis")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    
    WndSynthesis:showWindow()
end

--@brief	点击排位赛按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	    在这里做相应的按钮相应事件
function WndCityBottomBar:onClickQualifying(element)
    WZLog("WndCityBottomBar:onClickQualifying")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    
    SceneQualifying:showQualifying()
end

--@brief    点击任务按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndCityBottomBar:onClickTask(element)
    WZLog("WndCityBottomBar:onClickTask")

    TeachGroup1:endTeachStep({3,3},{5,10},{7,4},{8,7},{18,2},{20,7},{26,10},{9,7},{31,2},{32,3},{33,2},{34,2},{35,2},{36,2},{39,2},{40,2},{41,8})
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 42 and TeachGroup1.STEP == 1
    if CheckButtonOpen(ISLAND_RIGHT_TASK) and isTeach ~= true then
        local wndTaskElement = WndTask:createElement()
        WindowManager:addWindow(wndTaskElement, WndTask,nil,nil,nil)
    end
end

--@brief    点击物品按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndCityBottomBar:onClickItem(element)
    WZLog("WndCityBottomBar:onClickItem")
    TeachGroup1:endTeachStep({5,3},{37,2},{43,2})
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and 
        (TeachGroup1.GROUP == 19 and TeachGroup1.STEP == 2 or
        TeachGroup1.GROUP == 9 and TeachGroup1.STEP == 2 or
        TeachGroup1.GROUP == 10 and TeachGroup1.STEP == 2 or
        TeachGroup1.GROUP == 11 and TeachGroup1.STEP == 2 or
        TeachGroup1.GROUP == 37 and TeachGroup1.STEP == 2)
    if CheckButtonOpen(ISLAND_RIGHT_ITEM) and isTeach ~= true then
        WndSkillContainer:showById(1)
    end
end

--@brief	点击开关按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndCityBottomBar:onClickSwitch(element, parm1, parm2, state)
    WZLog("WndCityBottomBar:onClickSwitch one", self.m_bState, state, self:getSwitchState())
    -- 每次点击都会更新红点的状态
    if state ~= self:getSwitchState() then
        CacheCenter:updateRedPoint("right",self.m_root,nil,3)
        state = state and state or self:getSwitchState()
        WZLog("WndCityBottomBar:onClickSwitch two", tostring(not state), 1 - self.m_nMoveDirection, tostring(element), tostring(self.m_bIsMoveHorizontalBar), tostring(self.m_bIsMoveVerticalBar))
            SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
        if self.m_bIsMoveVerticalBar ~= true then
            self:setSwitchState(not state)
            WZLog("WndCityBottomBar:onClickSwitch three", tostring(state), self.m_nMoveDirection)
            self:moveVerticalBar(1 - ((not state) and 1 or 0))

        TeachGroup1:endTeachStep({3,2},{5,2},{7,3},{8,2},{9,1},{10,1},{11,1},{12,1},{18,1},{19,1},{20,6},{31,1},{32,2},{33,1},{34,1},{35,1},{36,1},{39,1},{40,1},{37,1},{46,6},{42,1},{43,1},{44,1})
        end
    end

    --WndOwnCity:updateFirstRecharge(self:getSwitchState())
end

--@brief 设置状态
function WndCityBottomBar:setState(state)
    if state then
        self:onClickSwitch(nil, nil ,nil, false)
    end
    self.m_bState = state
    GetElement(self.m_root, "btnSwitch_WndBottomBar", WZUIButton):setTouchEnable(not state)
end

--@brief    点击回收按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndCityBottomBar:onClickHuishou(element)
    WZLog("WndCityBottomBar:onClickHuishou")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and 
        (TeachGroup1.GROUP == 8 and TeachGroup1.STEP == 3
        )
    if CheckButtonOpen(ISLAND_RIGHT_HUISHOU) and isTeach ~= true then
        WndBag:showBagRecycle()
    end
end

--@brief    点击圣光按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndCityBottomBar:onClickShengguang(element)
    WZLog("WndCityBottomBar:onClickShengguang")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_EXTEND_ASCEND) then
        local wnd = WndAscending:createElement()
        WindowManager:addWindow(wnd, WndAscending, false)
    end
end

--@brief    点击召唤按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndCityBottomBar:onClickZhaohuan(element)
    WZLog("WndCityBottomBar:onClickZhaohuan")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and 
        (TeachGroup1.GROUP == 44 and TeachGroup1.STEP == 3
        )
        TeachGroup1:endTeachStep({42,2})
    if CheckButtonOpen(ISLAND_BUILDING_EQUIT_LOTTERY) and isTeach ~= true then
        local wndSummonEntrance = WndSummonEntrance:createElement()
        WindowManager:addWindow(wndSummonEntrance,WndSummonEntrance)
    end
end

--@brief    点击卡牌按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndCityBottomBar:onClickKapai(element)
    WZLog("WndCityBottomBar:onClickKapai")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    -- do 
    --     WndFootballActivity:showInterface()
    --     return
    -- end

    local isTeach = TeachGroup1.ISTEACH == true and 
        (TeachGroup1.GROUP == 12 and TeachGroup1.STEP == 2
        )
    if CheckButtonOpen(ISLAND_EXTEND_CARD) and isTeach ~= true then
        WndCard:showInterface(nil)
    end
end

--@brief    点击足迹按钮回调
function WndCityBottomBar:onClickFootMark( element )
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    --WndFootMark:showInterface()
    OpenPartner(3)
end
-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

local buildOpenList =
{
    ISLAND_BOTTOM_SHOP,
    ISLAND_BOTTOM_BAG,
    ISLAND_BOTTOM_SETTING,
	ISLAND_BOTTOM_STRENGTHEN,
}

--@brief	检查建筑物功能是否开放
--@param    nBtnId, 按钮id
--@return   #1, 是否开放
function WndCityBottomBar:_checkBuildingOpen(nBtnId)
    if self.m_tBtnsInfo then
        for i,v in pairs(self.m_tBtnsInfo) do
            WZLog(v.buttonId)
            if v.buttonId == nBtnId then
                WZLog(v.buttonId)
                local bFlag = SceneCity:ifBuildingOpen(v)
                if bFlag == false then
                    WZLog("WndOwnCity:_checkBuildingOpen", tostring(v.buttonTips))
                    MsgBoxManager:showTipBox(v.buttonTips)
                end
                return bFlag
            end
        end
    end

    if self.m_tBtnsInfoExtend then
        for i,v in pairs(self.m_tBtnsInfoExtend) do
            WZLog(v.buttonId)
            if v.buttonId == nBtnId then
                WZLog(v.buttonId)
                local bFlag = SceneCity:ifBuildingOpen(v)
                if bFlag == false then
                    WZLog("WndOwnCity:_checkBuildingOpen", tostring(v.buttonTips))
                    MsgBoxManager:showTipBox(v.buttonTips)
                end
                return bFlag
            end
        end
    end
    return true

end

--@brief    设置显示网络延迟信号
function WndCityBottomBar:_setNetSignal()
    -- body
    local conNetSignal = GetElement(self.m_root, "conNetSignal_WndBottomBar", WZUIContainer)
    CellNetSignal:showInterface(conNetSignal)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndCityBottomBar:_adaptLanguage_en(  )
    local txtTask = GetElement(self.m_root,"txtTask_WndBottomBar",WZUILabelTTF)
    txtTask:setFontSize(14)
    txtTask:setDimensions(GlobalMethod:CCSize(160,0))
    txtTask:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end

function WndCityBottomBar:_adaptLanguage_vn(  )
    local txtTask = GetElement(self.m_root,"txtTask_WndBottomBar",WZUILabelTTF)
    txtTask:setFontSize(14)
    txtTask:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end

function WndCityBottomBar:_adaptLanguage_pt(  )
    local txtTask = GetElement(self.m_root,"txtTask_WndBottomBar",WZUILabelTTF)
    txtTask:setScale(0.6)
    txtTask:setDimensions(GlobalMethod:CCSize(233))
    txtTask:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end

function WndCityBottomBar:_adaptLanguage_es(  )
    local txtTask = GetElement(self.m_root,"txtTask_WndBottomBar",WZUILabelTTF)
    txtTask:setScale(0.7)
    txtTask:setDimensions(GlobalMethod:CCSize(233))
    txtTask:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end
-------------------------------------语言适配End--------------------------------------------
