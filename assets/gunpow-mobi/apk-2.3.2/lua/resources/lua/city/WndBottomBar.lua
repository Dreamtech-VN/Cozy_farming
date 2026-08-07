--WndBottomBar.lua
--@brief	WndBottomBar的UI模块
--@date		2015/2/11
--@author	莫剑峰
--@note		底部条UI


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note	在这里做场景进入前的准备工作
function WndBottomBar:onEnter(element)
    WZLog("WndBottomBar:onEnter",self.g_tMailCount)
	self.m_root = element
    self:init()
    Protocol:reg( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkillOk, "ProtocolProcessorSceneCity:parse_PLAYER_GetPlayerSkillOk", "vivs")
    ProtocolProcessorWndSkillProp:send_PLAYER_GetPlayerSkill()

    Protocol:reg( Protocol.MAIN_PET, Protocol.PET_GetFreeTimeOK, "ProtocolProcessorSceneCity:parse_PET_GetFreeTimeOK", "vtvi")
    ProtocolProcessorScenePets:send_PET_GetFreeTime()

    Protocol:reg( Protocol.MAIN_CARD, Protocol.CARD_GetCardSetListOk, "ProtocolProcessorSceneCity:parse_CARD_GetCardSetListOk", "viviii")
    ProtocolProcessorCard:send_CARD_GetCardSetList()

    CacheCenter:registerUpatePlayerInfoObserver(self)
    self:_AdaptationIphoneX()
end

--@brief	删除多余的资源
function WndBottomBar:onEnterTransitionDidFinish(element)
    WZLog("WndBottomBar:onEnterTransitionDidFinish one")
    self:_update() 

    CacheCenter:setRedState("btnBag",CacheCenter:isEquipedDecorationRedPoint())
    GlobalGame:getBtnRedPointEvent():dispatcher()

    if CacheCenter.m_nDailyMark == 1 then
        CacheCenter:addMark("btnFriend_WndOwnCity",1,2)
    end

    --信号
    self:_setNetSignal()

    if CheckButtonOpen(ISLAND_RIGHT_RUNE_MAIN,true) then
        ProtocolProcessorSceneRune:regAll()
        ProtocolProcessorSceneRune:send_RUNE_GetRuneInfo()
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBottomBar:onExit(element)
    WZLog("WndBottomBar:onExit", tostring(g_bIsPushScene), tostring(g_bIsPopScene))
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

--@param    设置当前场景
function WndBottomBar:setScene(scene)
    self.m_tScene = scene
end

--@param    设置卡牌红点
function WndBottomBar:setCardRedPoint(isRed)
    CacheCenter:setRedState("btnCard_ExtendUp",isRed,57)
    GlobalGame:getBtnRedPointEvent():dispatcher()
end

--@brief	初始化
--@note		界面前的所有初始化
function WndBottomBar:init()
    WZLog("WndBottomBar:init one")
    element = self:getVerticalBar()
    element:setRelativePosition(GlobalMethod:ccp(0.5,1.5))
    self:setSwitchState(false)
    GetElement(self.m_root, "conVertical_WndBottomBar"):setVisible(false)

    GetElement(self.m_root,"conAllExtend_WndBottomBar",WZUIContainer):setVisible(false)
end

--@brief    玩家技能
--@param    id : 玩家技能id
--@param    skillExplain : 技能描述
function WndBottomBar:receiveGetPlayerSkillOk(id,skillExplain)
    --WZLog("WndBottomBar:receiveGetPlayerSkillOk ")

    local isSkill = nil
    local bIsLock = false
    for i,v in ipairs(id) do
        if v == -1 then
            bIsLock = true
        end
        --WZLog("WndBottomBar:receiveGetPlayerSkillOk zero", i, id[i], tostring(not bIsLock))
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
        WZLog("WndBottomBar:receiveGetPlayerSkillOk one")
    else
        --CacheCenter:setRedState("btnItem", false)
        self.m_bHavePos = false
        WZLog("WndBottomBar:receiveGetPlayerSkillOk two")
        self.m_tPlayerSkillInfo = {skillId = id ,skillExplain = skillExplain}
        Protocol:reg(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSkillListOk, "ProtocolProcessorSceneCity:parse_PLAYER_GetSkillListOk", "vivi")
        ProtocolProcessorWndSkillProp:send_PLAYER_GetSkillList()
    end
    

    
end

--@brief  查找所有技能存放到table
function WndBottomBar:initSkills()
    self.m_tSkillList = {}
    for k,v in pairs(GDatatab_skill) do
        if v.skill_type == 1 then
            table.insert(self.m_tSkillList,v.id)
        end
    end
end

--@brief 展示所有的技能道具
function WndBottomBar:showSkillProps(itemId,expv)
    WZLog("WndBottomBar:showSkillProps")

    if self.m_bHavePos == true then
        return
    end
    if self.m_nUpdateLevelSkillId ~= nil then
        self.m_nCurShowSkillId = self.m_nUpdateLevelSkillId
        self.m_nUpdateLevelSkillId = nil
    end
    local skills = {}
    local activeBornSkill = {} --激活的职业天赋技能
    for i,v in ipairs(itemId) do
        local skillInfo = GDatatab_skill["id_" .. v]
        local id_group  = skillInfo.id_group
        local skillItem = {id = v,status = 2,exp = expv[i],group = id_group,equip=4,hdtj=skillInfo.hdtj,hdtjcs=skillInfo.hdtjcs,level=skillInfo.specialAttackParam,sort=skillInfo.sort, sub_type = skillInfo.sub_type}
        table.insert(skills,skillItem)

        --职业天赋技能
        if skillInfo.sub_type >= 1001 and skillInfo.sub_type <= 1009 then 
            for k, value in pairs(GDatatab_mage_Skill) do
                if value.type == 2 and type(value.attribute) == "table" and value.attribute[1][2] == skillInfo.sub_type then
                    table.insert(activeBornSkill, value)
                end
            end
        end
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
                local skillItem = {id = v,status = 1 ,exp = 0,group = id_group,equip=4,hdtj=skillInfo.hdtj,hdtjcs=skillInfo.hdtjcs,level=skillInfo.specialAttackParam,sort=skillInfo.sort, sub_type = skillInfo.sub_type}
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

    --移除激活了职业天赋技能的相应原技能
    WZLog("KKKKKKKKKKKKKK", Serialize(activeBornSkill))
    for i = 1, #activeBornSkill do
        for j, v in ipairs(skills) do
            if v.sub_type == activeBornSkill[i].attribute[1][1] then 
                table.remove(skills, j)
                break 
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
        if CacheCenter:bContinue() and WndSkillProp:skillCanActivation(v.id, self.m_tAllSkillProps) then
            isRed = true 
            break
        elseif CacheCenter:bContinue() and WndSkillProp:skillCanUpdate(v.id, self.m_tAllSkillProps) then
            isRed = true 
            break
        end
    end
    
    if isRed and CheckButtonOpen(ISLAND_RIGHT_ITEM,true) then
        CacheCenter:setRedState("btnItem", true)
        WZLog("WndBottomBar:receiveGetPlayerSkillOk three")
    else
        CacheCenter:setRedState("btnItem", false)
        WZLog("WndBottomBar:receiveGetPlayerSkillOk four")
    end
    GlobalGame:getBtnRedPointEvent():dispatcher()
end

--@brief   获取抽奖宠物时间成功
function WndBottomBar:getTime(type,time)
    WZLog("WndBottomBar:getTime",type[1], type[2], time[1], time[2])
    --if (time[1] <= 0 or time[2] <= 0) and CheckButtonOpen(ISLAND_RIGHT_PET,true) then
    local isRed = WndBottomBar:isShowPetRed(time[1])
    if (isRed or GlobalGame.g_tRedPointList.petFetter) and CheckButtonOpen(ISLAND_RIGHT_PET,true) then
        CacheCenter:setRedState("btnPet", true)
        if isRed then 
            GlobalGame.g_tRedPointList["btnPet"] = true
            WndSummonEntrance:updateRedPoint(nil, true)
            WZLog("WndBottomBar:getTime one")
        else
            GlobalGame.g_tRedPointList["btnPet"] = flase
            WndSummonEntrance:updateRedPoint(nil, flase)
            WZLog("WndBottomBar:getTime one")
        end
    else
        CacheCenter:setRedState("btnPet", false)
        GlobalGame.g_tRedPointList["btnPet"] = nil
        WndSummonEntrance:updateRedPoint(nil, false)
        WZLog("WndBottomBar:getTime two")
    end
    GlobalGame:getBtnRedPointEvent():dispatcher()
end

--是否有小红点显示
function WndBottomBar:isShowPetRed(time)
    WZLog("WndBottomBar:isShowPetRed", time)
    if time <= 0 then
        return true
    end

    local petLotteryPrice =  CacheCenter:getGameParam().petLotteryPrice
    local tIds,tNums = SplitItemString(petLotteryPrice)
    local fragmentCount =  CacheCenter:getPlayerItemCountById(tIds[4])
    if fragmentCount >= tonumber(tNums[4]) * 10 then
        return true
    end

    local fragmentCount =  CacheCenter:getPlayerItemCountById(tIds[1])
    if fragmentCount >= tonumber(tNums[1]) * 10 then
        return true
    end
    return false
end
--@brief    人物升级后更新左菜单
function WndBottomBar:updatePlayerInfoData()
    WZLog("WndBottomBar:updatePlayerInfoData")
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

local btnExtendIndex = 
{
    [ISLAND_UP_BLESS] = "Bless",
    [ISLAND_EXTEND_PRACTICE] = "Practice",
    [ISLAND_EXTEND_CARD] = "Card",
    [ISLAND_EXTEND_LBS] = "Lbs",
    [ISLAND_EXTEND_CHARM] = "Charm",
    [ISLAND_EXTEND_WARDROBE] = "Wardrobe",
    [ISLAND_EXTEND_ASCEND] = "Ascending",
}

--@brief    更新左菜单扩展UI界面
function WndBottomBar:_updateExtend()
    local nTag = 0
    local offset = 0.46
    local offset_y = 0.13
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

    WZLog("WndBottomBar:_updateExtend0", Serialize(self.m_tBtnsInfoExtend))
    local id = 0
    for i,v in ipairs(self.m_tBtnsInfoExtend) do
        local conBtn = GetElement(self.m_root, "btn"..btnExtendIndex[v.buttonId].."_ExtendUp_WndBottomBar", WZUIButton)
        local isOpen = SceneCity:checkIconButtonOpen(v) and checkbuttonChannel(v.buttonChannel)

        if isOpen then
            id =id + 1
            local offsetX = 0.26 + offset * ((id-1) % 2)
            local offsetY = 1.12 - offset_y * math.ceil(id / 2)
            conBtn:setVisible(true)
            conBtn:setRelativePosition(GlobalMethod:ccp(offsetX, offsetY))
            WZLog("WndBottomBar:_updateExtend1", i, id, tostring(v.buttonId), tostring(btnExtendIndex[v.buttonId]), offsetX, offsetY, indexNo, self.m_nBtnExtendCount)
        else
            conBtn:setVisible(false)
            WZLog("WndBottomBar:_updateExtend2", i)
        end
    end
end

--@brief    更新左菜单UI界面
function WndBottomBar:_update()
    
    if self.m_root == nil then
        return
    end
    self:_setDefaultBtnsInfo()

    local count = 0
    for i,v in ipairs(self.m_tBtnsInfo) do
        local name = btnIndex[v.buttonId] and "btn"..btnIndex[v.buttonId].."_WndBottomBar" or v.buttonId
        local conBtn = GetElement(self.m_root, name, WZUIButton)
        local isOpen = CheckButtonShow(v.buttonId) and checkbuttonChannel(v.buttonChannel)

        if conBtn then
            if isOpen then
                count = count + 1
            end
        end
    end

    --local count = #self.m_tBtnsInfo
    local nColumnLimit = 1 --列数限制
    local nWidthLimit = 100 --宽度限制
    local row = math.ceil(count / nColumnLimit)
    local w,h = nWidthLimit,60 * row + 19 * (row +1) + 4

    self.m_nMoveTime = h / (nWidthLimit/0.1)
    self.m_nMoveTime = self.m_nMoveTime < 0.1 and 0.1 or self.m_nMoveTime

    local conSci = GetElement(self.m_root, "conSciVertical_WndBottomBar", WZUIScissorContainer)
    conSci:setAbsContentSize(GlobalMethod:CCSize(w,h))
    conSci:setContentSize(GlobalMethod:CCSize(w,h))
    conSci:setUseAbsSize(true)

    local con = GetElement(self.m_root, "conVertical_WndBottomBar", WZUIContainer)
    con:setAbsContentSize(GlobalMethod:CCSize(w,h))
    con:setContentSize(GlobalMethod:CCSize(w,h))
    con:setUseAbsSize(true)
    con:removeChildByTag(99,true)
    if self.m_nMoveDirection == 0 then
        con:setRelativePosition(ccp(0.5,0.5))
    else
        con:setRelativePosition(ccp(0.5,1.5))
    end

    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setAnchorPoint(ccp(0.5,1))
    element:setRelativePosition(ccp(0.5,1))
    element:setAbsContentSize(GlobalMethod:CCSize(w,h))
    con:addChild(element,-1,99)

    local imgNor = WZUI9Image:create()
    imgNor:setFile("ui/common/frame_xlk.png")
    element:addChild(imgNor,-1,99)

    WZLog("WndBottomBar:_update0", self.m_nMoveDirection)

    local nTag = 0
    local offset = 0.13
    local indexNo = 0
    local topY = (h-4 - 50) / (h-4)
    local intervalY = 80 / (h-4)
    self.m_nBtnCount = 0
    for i,v in ipairs(self.m_tBtnsInfo) do
        local isOpen = SceneCity:checkIconButtonOpen(v) and checkbuttonChannel(v.buttonChannel)
        if isOpen then
            self.m_nBtnCount = self.m_nBtnCount + 1
        else
            indexNo = indexNo+ 1
        end
    end

    local index = 0
    for i,v in ipairs(self.m_tBtnsInfo) do
        local name = btnIndex[v.buttonId] and "btn"..btnIndex[v.buttonId].."_WndBottomBar" or v.buttonId
        local conBtn = GetElement(self.m_root, name, WZUIButton)
        local isOpen = CheckButtonShow(v.buttonId) and checkbuttonChannel(v.buttonChannel)

        if conBtn then
            if isOpen then
                index = index + 1
                local nColumnLimit = 1
                local column = index % nColumnLimit
                local row = math.ceil(index / nColumnLimit)
                column = column == 0 and nColumnLimit or column

                local offsetX = 0.5 --0.8 - 0.3 * (column-1)
                local offsetY = topY - intervalY * (row-1)
                conBtn:setVisible(true)
                conBtn:setRelativePosition(GlobalMethod:ccp(offsetX, offsetY))
--                WZLog("WndBottomBar:_update1", i, index, column, row, topY, h, intervalY, tostring(v.buttonId), tostring(btnIndex[v.buttonId]), offsetX, offsetY)
            else
                conBtn:setVisible(false)
            end
        else
            WZLog("WndBottomBar:_update2", name)
        end
    end

    --self:_updateExtend()
end

--@brief	移动水平条
--@note
function WndBottomBar:moveHorizontalBar(direction)
    WZLog("WndBottomBar:moveHorizontalBar one", tostring(self.m_nMoveDirection), tostring(self.m_bIsMoveHorizontalBar))
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
function WndBottomBar:endMoveHorizontalBar(sender)
    WZLog("WndBottomBar:endMoveHorizontalBar")
    self.m_bIsMoveHorizontalBar = false
end

--@brief    关闭展开栏的响应方法
function WndBottomBar:hideExtend(element)
    WZLog("WndBottomBar:hideExtend", self.m_nMoveDirection)

    if self.m_nMoveDirection == 0 then
        self:onClickSwitch(nil, nil ,nil, false)
    end
end

--@brief    点击角色按钮后的响应方法
function WndBottomBar:onClickPlayer(element)
    WZLog("WndBottomBar:onClickPlayer")
    WndCityBottomBar:onClickPlayer()
end

--@brief    点击幻化按钮后的响应方法
function WndBottomBar:onClickPhantom(element)
    WZLog("WndBottomBar:onClickPhantom")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_RIGHT_PHANTOM) then
        WndPhantom:showWin()
    end
end

--@brief    点击觉醒按钮后的响应方法
function WndBottomBar:onClickAwaken(element)
    WZLog("WndBottomBar:onClickAwaken")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_RIGHT_AWAKEN) then
        WndWakeup:showInterface()
    end
end

--@brief    点击修炼按钮后的响应方法
function WndBottomBar:onClickPractice(element)
    WZLog("WndBottomBar:onClickPractice")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and 
        (TeachGroup1.GROUP == 42 and TeachGroup1.STEP == 3
        )
    if CheckButtonOpen(ISLAND_EXTEND_PRACTICE) and isTeach ~= true then
        local wndPractice = WndPractice:createElement()
        if wndPractice ~= nil then
            WindowManager:addWindow(wndPractice, WndPractice, false)
        end
    end
end

--@brief    点击符文按钮后的响应方法
function WndBottomBar:onClickRune(element)
    WZLog("WndBottomBar:onClickRune")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and 
        (TeachGroup1.GROUP == 42 and TeachGroup1.STEP == 3
        )
    if CheckButtonOpen(ISLAND_RIGHT_RUNE_MAIN) and isTeach ~= true then
        WndBagMain:showRune()
    end
end

--@brief    点击卡牌按钮后的响应方法
function WndBottomBar:onClickCard(element)
    WZLog("WndBottomBar:onClickCard")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and 
        (TeachGroup1.GROUP == 42 and TeachGroup1.STEP == 3
        )
    if CheckButtonOpen(ISLAND_EXTEND_CARD) and isTeach ~= true then
        WndCard:showInterface(nil)
    end
end

--@brief    点击魅力空间按钮后的响应方法
function WndBottomBar:onClickCharm(element)
    WZLog("WndBottomBar:onClickCharm")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    local isTeach = TeachGroup1.ISTEACH == true and 
        (TeachGroup1.GROUP == 44 and TeachGroup1.STEP == 3
        )
    if CheckButtonOpen(ISLAND_EXTEND_CHARM) and isTeach ~= true then
        local wndCharmSpace = WndCharmSpace:createElement()
        if wndCharmSpace ~= nil then
            WindowManager:addWindow(wndCharmSpace, WndCharmSpace, false)
        end
    end
end

--获取地理位置OK
function WndBottomBar:reGeocodeSearchOk(province, city, district)
    WZLog("WndBottomBar:reGeocodeSearchOk",tostring(province), tostring(city), tostring(district))  
end 

--@brief    点击升阶按钮后的响应方法
function WndBottomBar:onClickAscending(element)
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_EXTEND_ASCEND) then
        local wnd = WndAscending:createElement()
        WindowManager:addWindow(wnd, WndAscending, false)
    end
end

--@brief    点击衣橱按钮后的响应方法
function WndBottomBar:onClickWardrobe(element)
    WZLog("WndBottomBar:onClickWardrobe")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_EXTEND_WARDROBE) then
        Wndwardrobe:show()
        --self:onClickLbs()
    end
end

--@brief    点击LBS按钮后的响应方法
function WndBottomBar:onClickLbs(element)
    WZLog("WndBottomBar:onClickLbs")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if CheckButtonOpen(ISLAND_EXTEND_LBS) then
        WZLog("WndBottomBar:onClickLbs2")

    if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_IOS then
        local className = "AMapSceneController"
        local adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter(className)
        
        if adapter then
            local callback = WZAdapterCallback:create(self.callback, self)
            adapter:callMethodByName("isOpenLoc", callback, "")
            self.m_adapter = adapter
            --WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(adapter:getId())
        else
            MsgBoxManager:showConfirmBox("当前版本不支持该功能,请下载新版本", self, nil, MSGBOXLEVEL_HIGH, nil,true)
        end
    elseif PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_ANDROID then
        local m = getTotalMemory()
        WZLog("WndBottomBar:onClickLbs3", m)
        local className = "com/baiduMap/MapSceneController"
        local adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter(className)
        self.m_adapter = adapter
        if adapter == nil then
            MsgBoxManager:showConfirmBox("当前版本不支持该功能,请下载新版本", self, nil, MSGBOXLEVEL_HIGH, nil,true)
        elseif m < 1024 then
            MsgBoxManager:showConfirmBox("内存不足，无法使用该功能", self, nil, MSGBOXLEVEL_HIGH, nil,true)
        else
            ProtocolProcessorWndSpace:send_SPACE_GetSpaceInfo(CacheCenter:getPlayerInfo().id)
        end
    end
        
        -- local wndLbs = WndLbs:createElement()
        -- if wndLbs ~= nil then
        --     WindowManager:addWindow(wndLbs, WndLbs, false)
        -- end
    end
end

-- 地图
function WndBottomBar:callback(result)
    local info = json.decode(result)
    WZLog("WndBottomBar:callback", result, Serialize(info))
    if info.type == "isOpenLoc" then
        local isOpen = info.value
        ProtocolProcessorWndSpace:send_SPACE_GetSpaceInfo(CacheCenter:getPlayerInfo().id)
        if isOpen == "false" then
            MsgBoxManager:showConfirmBox("定位功能未授权，请前往设置", self, nil, MSGBOXLEVEL_HIGH, nil,true)
        else
            --ProtocolProcessorWndLbs:send_NEIGHBOR_SelfPlayerNeighborInfo()
        end

        WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(self.m_adapter:getId())
        self.m_adapter = nil
    end
end

--@brief    点击邮件按钮后的响应方法
function WndBottomBar:onClickMail(element)
    WndOwnCity:onClickMail(element)
end

--@brief    点击好友按钮后的响应方法
function WndBottomBar:onClickFriend(element)
    WndOwnCity:onClickFriend(element)
end

--@brief    点击图鉴按钮后的响应方法
function WndBottomBar:onClickGuide(element)
    WndOwnCity:onClickGuide(element)
end

--@brief    点击设置按钮后的响应方法
function WndBottomBar:onClickSet(element)
    WndOwnCity:onClickSet(element)
end

--@brief    点击助手按钮后的响应方法
function WndBottomBar:onClickHelper(element)
    WndOwnCity:onClickHelper(element)
end


--@brief	移动垂直条
--@note
function WndBottomBar:moveVerticalBar(direction)
    WZLog("WndBottomBar:moveVerticalBar one", tostring(self.m_nMoveDirection), tostring(self.m_bIsMoveVerticalBar), tostring(self.m_bIsNeedMoveVerticalBar))
    if self.m_bIsMoveVerticalBar ~= true and self.m_bIsNeedMoveVerticalBar == true then
        self.m_bIsMoveVerticalBar = true
        self.m_nMoveDirection = direction
        local t = self.m_nMoveTime
        local x, y = 0,0

        if direction == 0 then
            x, y = 0.5,0.5
            WZLog("WndBottomBar:moveVerticalBar two", y)
            GetElement(self.m_root, "conVertical_WndBottomBar"):setVisible(true)
        else
            GetElement(self.m_root,"conAllExtend_WndBottomBar",WZUIContainer):setVisible(false)
            x, y = 0.5,1.5
        end

        --创建序列动作
        local actionSequence = WZUIActionSequence:create()
        actionSequence:setIsLoop( false )
        --创建移动动作
        local actMoveTo = WZUIActionMoveTo:create()
        actMoveTo:setDuration(t)
        actMoveTo:setMoveX(x)
        actMoveTo:setMoveY(y)
        if direction == 0 then
            actMoveTo:setFinishLuaFunction("endMoveVerticalBar")
        else
            actMoveTo:setFinishLuaFunction("endMoveVerticalBar2")
        end
        actMoveTo:setFinishLuaTable(self)
        actionSequence:setChildAction( actMoveTo )

        self:getVerticalBar():runUIAction( actionSequence )
    end

end

--@brief	移动的结束回调
--@param	sender:回调元素
--@note
function WndBottomBar:endMoveVerticalBar(sender, levelUp, isTrailerAnim)
    self.m_bIsMoveVerticalBar = false

    local isFinish3, finishStep3 = TeachGroup1:isTeachFinish(3)
    local isFinish5, finishStep5 = TeachGroup1:isTeachFinish(5)
    local isFinish7, finishStep7 = TeachGroup1:isTeachFinish(7)
    local isFinish8, finishStep8 = TeachGroup1:isTeachFinish(8)
    local isFinish9, finishStep9 = TeachGroup1:isTeachFinish(9)
    local isFinish10, finishStep10 = TeachGroup1:isTeachFinish(10)
    local isFinish11, finishStep11 = TeachGroup1:isTeachFinish(11)
    local isFinish12, finishStep12 = TeachGroup1:isTeachFinish(12)
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
    WZLog("WndBottomBar:endMoveVerticalBar1", tostring(self.m_nMoveDirection),
        finishStep3,finishStep5,finishStep8,finishStep9,finishStep10,finishStep11,finishStep12,
        finishStep19,finishStep26,finishStep20,isFinish3,isFinish5,isFinish8,isFinish9,isFinish10,
        isFinish11,isFinish12,isFinish19,isFinish26,isFinish20, isFinish31, finishStep31)

    local isTeach = true
    local tryTeach = nil
    if isFinish44 ~= true and finishStep44 >= 0 and CacheCenter:getPlayerInfo().level == 17 then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {44,3, self.m_root})
        tryTeach = true
    elseif isFinish19 ~= true and CheckButtonOpen(28,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {19,2, self.m_root})
        tryTeach = true
    elseif isFinish43 ~= true and finishStep43 >= 0 and CacheCenter:getPlayerInfo().level == 23 then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {42,2, self.m_root})
        tryTeach = true
    elseif isFinish42 ~= true and finishStep42 >= 0 and CacheCenter:getPlayerInfo().level == 24 then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {43,2, self.m_root})
        tryTeach = true
    elseif isFinish11 ~= true and CheckButtonOpen(43,false) then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {11,2, self.m_root})
        tryTeach = true
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
    elseif isFinish40 ~= true and finishStep40 > 0  then
        -- isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {40,2, self.m_root})
        -- tryTeach = true
    elseif isFinish39 ~= true and finishStep39 > 0  then
        -- isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {39,2, self.m_root})
        -- tryTeach = true
    elseif isFinish36 ~= true and finishStep36 > 0  then
        -- isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {36,2, self.m_root})
        -- tryTeach = true
    elseif isFinish35 ~= true and finishStep35 > 0  then
        -- isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {35,2, self.m_root})
        -- tryTeach = true
    elseif isFinish34 ~= true and finishStep34 > 0  then
        -- isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {34,2, self.m_root})
        -- tryTeach = true
    elseif isFinish33 ~= true and finishStep33 > 0  then
        -- isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {33,2, self.m_root})
        -- tryTeach = true
    elseif isFinish32 ~= true and finishStep32 > 0  then
        -- isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {32,3, self.m_root})
        -- tryTeach = true
    elseif isFinish31 ~= true and finishStep31 > 0  then
        -- isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {31,2, self.m_root})
        -- tryTeach = true
    elseif isFinish7 ~= true and finishStep7 > 0  then
        isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {7,4, self.m_root})
        tryTeach = true
    elseif isFinish8 ~= true and TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_3) then
        if finishStep8 < 5 then
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {8,3, self.m_root})
            tryTeach = true
        end
    elseif isFinish9 ~= true and CheckButtonOpen(40,false) then
        if finishStep9 < 5 then
            isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {9,2, self.m_root})
            tryTeach = true
        -- else
        --     isTeach = TeachGroup1:startGroupLevelUp(levelUp, false, nil, isTrailerAnim, {9,5, self.m_root})
        --     tryTeach = true
        end
    end




    WZLog("WndBottomBar:endMoveVerticalBar3", tostring(isTeach), tostring(tryTeach))
    if isTeach == false or tryTeach == nil then
        if isEndTeach3 ~= true and finishStep3 > 0 then
            TeachGroup1:setTeachFinish(3, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-3")
        end
        if isEndTeach5 ~= true and finishStep5 > 0 then
            TeachGroup1:setTeachFinish(5, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-5")
        end
        if isEndTeach7 ~= true and finishStep7 > 0 then
            TeachGroup1:setTeachFinish(7, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-7")
        end
        if isEndTeach8 ~= true and finishStep8 > 0 then
            TeachGroup1:setTeachFinish(8, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-8")
        end
        if isEndTeach9 ~= true and finishStep9 > 0 then
            TeachGroup1:setTeachFinish(9, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-9")
        end
        if isEndTeach10 ~= true and finishStep10 > 0 then
            TeachGroup1:setTeachFinish(10, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-10")

        end
        if isEndTeach11 ~= true and finishStep11 > 0 then
            TeachGroup1:setTeachFinish(11, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-11")
        end
        if isEndTeach12 ~= true and finishStep12 > 0 then
            TeachGroup1:setTeachFinish(12, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-12")
        end
        if isEndTeach19 ~= true and finishStep19 > 0 then
            TeachGroup1:setTeachFinish(19, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-19")
        end
        if isEndTeach20 ~= true and finishStep20 > 0 then
            TeachGroup1:setTeachFinish(20, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-20")
        end
        if isEndTeach26 ~= true and finishStep26 > 0 then
            TeachGroup1:setTeachFinish(26, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-26")

        end
        if isEndTeach31 ~= true and finishStep31 > 0 then
            TeachGroup1:setTeachFinish(31, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-31")
        end
        if isEndTeach32 ~= true and finishStep32 > 0 then
            TeachGroup1:setTeachFinish(32, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-32")
        end
        if isEndTeach33 ~= true and finishStep33 > 0 then
            TeachGroup1:setTeachFinish(33, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-33")
        end
        if isEndTeach34 ~= true and finishStep34 > 0 then
            TeachGroup1:setTeachFinish(34, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-34")
        end
        if isEndTeach35 ~= true and finishStep35 > 0 then
            TeachGroup1:setTeachFinish(35, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-35")
        end
        if isEndTeach36 ~= true and finishStep36 > 0 then
            TeachGroup1:setTeachFinish(36, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-36")
        end
        if isEndTeach37 ~= true and finishStep37 > 0 then
            TeachGroup1:setTeachFinish(37, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-37")
        end
        if isEndTeach39 ~= true and finishStep39 > 0 then
            TeachGroup1:setTeachFinish(39, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-39")
        end
        if isEndTeach40 ~= true and finishStep40 > 0 then
            TeachGroup1:setTeachFinish(40, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-40")

        end
        if isEndTeach41 ~= true and finishStep41 > 0 then
            TeachGroup1:setTeachFinish(41, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-41")
        end
        if isEndTeach42 ~= true and finishStep42 > 0 then
            TeachGroup1:setTeachFinish(42, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-42")
        end
        if isEndTeach43 ~= true and finishStep43 > 0 then
            TeachGroup1:setTeachFinish(43, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-43")
        end
        if isEndTeach44 ~= true and finishStep44 > 0 then
            TeachGroup1:setTeachFinish(44, -1)
            WZLog("WndBottomBar:endMoveVerticalBar2-44")
        end
        WindowManager:removeTeachShelterLayer()
        TeachGroup1:removeTeach()
    end
    return isTeach
end

--@brief	移动的结束回调
--@param	sender:回调元素
--@note
function WndBottomBar:endMoveVerticalBar2(sender)
    WZLog("WndBottomBar:endMoveVerticalBar2")
    self.m_bIsMoveVerticalBar = false
    GetElement(self.m_root, "conVertical_WndBottomBar"):setVisible(false)
end

--@brief	设置是否需要移动垂直条
--@note
function WndBottomBar:setNeedMoveVerticalBar(isNeed)
    WZLog("WndBottomBar:setNeedMoveVerticalBar one")
    self.m_bIsNeedMoveVerticalBar = isNeed
    GetElement(self.m_root, "conRight_WndBottomBar"):setVisible(isNeed)
end

--@brief	设置是否需要聊天按钮
--@note
function WndBottomBar:setNeedChat(isNeed)
    WZLog("WndBottomBar:setNeedChat one")
    self.m_bIsNeedChat = isNeed
    local btnChat = GetElement(self.m_root, "btnChat_WndBottomBar")
    btnChat:setVisible(isNeed)
    
end

--@brief	水平条
--@note		滚动条
function WndBottomBar:getHorizontalBar()
    WZLog("WndBottomBar:getHorizontalBar one")
    if self.m_root then
        return GetElement(self.m_root,"conHorizontal_WndBottomBar",WZUIContainer)
    end
end

--@brief	垂直条
--@note		滚动条
function WndBottomBar:getVerticalBar()
    WZLog("WndBottomBar:getVerticalBar one")
    if self.m_root then
        return GetElement(self.m_root,"conVertical_WndBottomBar",WZUIContainer)
    end
end

--@brief    是否展开
function WndBottomBar:setRed(red)
    self.m_bRed = red
end

--@brief	设置开关
--@note		开关图片设置
function WndBottomBar:setSwitchState(state)
    WZLog("WndBottomBar:setSwitchState one",tostring(state))
    if self.m_root and self.m_bIsMoveHorizontalBar ~= true and self.m_bIsMoveVerticalBar ~= true then
        GetElement(self.m_root,"conSwitchOff_WndBottomBar",WZUIContainer):setVisible(state)
        GetElement(self.m_root,"imgSwitchOn2_WndBottomBar",WZUIImage):setVisible(not state)

        local AllBtn = GetElementWithoutAssert(self.m_root,"btnSwitch_WndBottomBar",WZUIButton)
        local m_bContainsRedPoint = self.m_bRed

        WZLog("WndCityBottomBar:setSwitchState", tostring(state), tostring(m_bContainsRedPoint))
        if state ~= true then
            if m_bContainsRedPoint then
                if not AllBtn:getChildByTag(89) then
                    local spr_redPoint =  CCSprite:create("ui/common/common_icon_xiaodianzhui.png")
                    AllBtn:addChild(spr_redPoint,5,89)

                    local position = ccp(73,55)
                    spr_redPoint:setPosition(position)
                end
            else 
                if  AllBtn:getChildByTag(89) then 
                    AllBtn:removeChildByTag(89,true)
                end
            end 
        else
            if  AllBtn:getChildByTag(89) then 
                AllBtn:removeChildByTag(89,true)
            end
        end
    end
end

--@brief	设置开关
--@note		开关图片设置
function WndBottomBar:getSwitchState()
    WZLog("WndBottomBar:getSwitchState one")
    if self.m_root then
        return GetElement(self.m_root,"conSwitchOff_WndBottomBar",WZUIContainer):isVisible()
    end
end

--@brief	点击聊天按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomBar:onClickChat(element)
	WZLog("WndBottomBar:onClickChat")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    if judgeWetherForbid() then return end 
    
    --结婚现场默认是当前频道
    if SceneWeddingChurch.m_root then
        WndChat:showChatWindowForFightingByOrder(CHANNEL_CURRENT)
    end

    WndChat:showChatWindowForFightingByOrder()
end

--@brief    点击祈福按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndBottomBar:onClickBless(element)
    WZLog("WndBottomBar:onClickBless")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    TeachGroup1:endTeachStep({42,3})

    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.STEP ~= -1 and 
    (TeachGroup1.GROUP == 3 or TeachGroup1.GROUP == 5 or TeachGroup1.GROUP == 7 or TeachGroup1.GROUP == 8 or TeachGroup1.GROUP == 18
         or TeachGroup1.GROUP == 20 or TeachGroup1.GROUP == 26 or TeachGroup1.GROUP == 9 or TeachGroup1.GROUP == 31 or TeachGroup1.GROUP == 32
          or TeachGroup1.GROUP == 33 or TeachGroup1.GROUP == 34 or TeachGroup1.GROUP == 35 or TeachGroup1.GROUP == 36 or TeachGroup1.GROUP == 39
           or TeachGroup1.GROUP == 40 or TeachGroup1.GROUP == 41 or TeachGroup1.GROUP == 44 or TeachGroup1.GROUP == 43)
    if CheckButtonOpen(ISLAND_UP_BLESS) and isTeach ~= true then
        -- local wndBless = WndBless:createElement()
        -- if wndBless ~= nil then
        --     WindowManager:addWindow(wndBless,WndBless)
        --     return
        -- end
        WndSummonEntrance:showInterface(3)
    end
end

--@brief	点击背包按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomBar:onClickBag(element)
    WZLog("WndBottomBar:onClickBag")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
	WndCityBottomBar:onClickBag()
end

--@brief	点击强化按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomBar:onClickStrong(element)
    WZLog("WndBottomBar:onClickStrong")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
	--WndRewardShow:showById({3401,3401,3401,3401},{1,1,1,1})

    if CheckButtonOpen(ISLAND_RIGHT_STRENGTHEN) then
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
function WndBottomBar:onClickPet(element)
    WZLog("WndBottomBar:onClickPet")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    TeachGroup1:endTeachStep({12,2},{19,2})
    if CheckButtonOpen(ISLAND_RIGHT_PET) then
        local index = 4
        local isMove = true
        WZLog("点击宠物乐园按钮后的响应方法2:::",GlobalGame.g_bIfInTeaching)
        if GlobalGame.g_bIfInTeaching == true then
            index = 2
            isMove = false
        end
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
function WndBottomBar:onClickStarSoul(element)
    WZLog("WndBottomBar:onClickStarSoul")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if false and FigureSceneManager:getInstance().m_tFigure ~= nil then
        FigureSceneManager:getInstance().m_tFigure:changeDisplay("", "", 1)
    end

    --if CheckButtonOpen(ISLAND_BOTTOM_SOUL) then
    --    WndStarSoul:openWndStarSoul()
    --end
end

--@brief	点击坐骑按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomBar:onClickMount(element)
    WZLog("WndBottomBar:onClickMount")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    -- TeachGroup1:endTeachStep({19,2})

    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 42 and TeachGroup1.STEP == 1
	if CheckButtonOpen(ISLAND_RIGHT_MOUNT) and isTeach ~= true then
    	-- local mounts = WndMounts:createElement()
    	-- WindowManager:addWindow(mounts,WndMounts)
        OpenPartner(2)
    end
end

--@brief	点击商城按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomBar:onClickShop(element)
    WZLog("WndBottomBar:onClickShop")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_BOTTOM_SHOP) then
        local wndShop = WndShop:createElement()
        WindowManager:addWindow(wndShop,WndShop,false)
    end
end

--@brief	点击设置按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomBar:onClickSet(element)
    WZLog("WndBottomBar:onClickSet")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_BOTTOM_SETTING) then
        local wndSettingElement = WndSetting:createElement()
        WindowManager:addWindow( wndSettingElement , WndSetting )
    end
end

--@brief	点击公会按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomBar:onClickGuild(element)
    WZLog("WndBottomBar:onClickGuild")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_BUILDING_COMMUNITY) then
        CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_Channel_Community)
        SceneCommunity:onJumpToCommunity()
    end
end

--@brief	点击合成按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	    在这里做相应的按钮相应事件
function WndBottomBar:onClickSynthesis(element)
    WZLog("WndBottomBar:onClickSynthesis")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    
    WndSynthesis:showWindow()
end

--@brief	点击排位赛按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	    在这里做相应的按钮相应事件
function WndBottomBar:onClickQualifying(element)
    WZLog("WndBottomBar:onClickQualifying")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    
    SceneQualifying:showQualifying()
end

--@brief    点击任务按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndBottomBar:onClickTask(element)
    WZLog("WndBottomBar:onClickTask")

    TeachGroup1:endTeachStep({3,3},{7,4},{18,2},{20,7},{26,10},{41,8})
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
function WndBottomBar:onClickItem(element)
    WZLog("WndBottomBar:onClickItem")
    TeachGroup1:endTeachStep({5,3},{43,2})
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_RIGHT_ITEM) then
        WndSkillContainer:showById(1)
        WndCityBottomBar:_postClickFunctionEvent()
        -- local wndskillprop = WndSkillProp:createElement()
        -- WindowManager:addWindow(wndskillprop,WndSkillProp,nil,nil,nil)
    end
end

--@brief	点击开关按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomBar:onClickSwitch(element, parm1, parm2, state)
    WZLog("WndBottomBar:onClickSwitch one", tostring(element), self.m_bState, state, self:getSwitchState())
    if self.m_bIsMatching then 
        MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
        return 
    end
    -- 每次点击都会更新红点的状态
    if state ~= self:getSwitchState() then
        CacheCenter:updateRedPoint("right",self.m_root,nil,3)
        state = state and state or self:getSwitchState()
        WZLog("WndBottomBar:onClickSwitch two", tostring(not state), 1 - self.m_nMoveDirection, tostring(element), tostring(self.m_bIsMoveHorizontalBar), tostring(self.m_bIsMoveVerticalBar))
            if element then
                SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
            end
        if self.m_bIsMoveVerticalBar ~= true then
            self:_postClickSwitchEvent()
            self:setSwitchState(not state)
            WZLog("WndBottomBar:onClickSwitch three", tostring(state), self.m_nMoveDirection)
            self:moveVerticalBar(1 - ((not state) and 1 or 0))

            TeachGroup1:endTeachStep({3,2},{5,2},{7,3},{8,2},{10,1},{11,1},{12,1},{18,1},{19,1},{20,6},{46,6},{42,1},{43,1},{44,1})
        end
    end

    --WndOwnCity:updateFirstRecharge(self:getSwitchState())
end

--@brief 设置状态
function WndBottomBar:setState(state)
    if state then
        self:onClickSwitch(nil, nil ,nil, false)
    end
    self.m_bState = state
    GetElement(self.m_root, "btnSwitch_WndBottomBar", WZUIButton):setTouchEnable(not state)
end

--@brief    设置聊天按钮大小
function WndBottomBar:setChatBtnScale(nScale, rPt)
    -- body
    local btnChat = GetElement(self.m_root, "btnChat_WndBottomBar", WZUIButton)
    if btnChat then
        btnChat:setScale(nScale)
        if rPt then
            btnChat:setRelativePosition(rPt)
        end
    end
end

--@brief    点击职业入口按钮回调
function WndBottomBar:onClickProfession(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    if CheckButtonOpen(ISLAND_RIGHT_PROFESSION) then
        WndProfession:showInterface()
    end
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
function WndBottomBar:_checkBuildingOpen(nBtnId)
    if self.m_tBtnsInfo then
        for i,v in ipairs(self.m_tBtnsInfo) do
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
        for i,v in ipairs(self.m_tBtnsInfoExtend) do
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
function WndBottomBar:_setNetSignal()
    -- body
    local conNetSignal = GetElement(self.m_root, "conNetSignal_WndBottomBar", WZUIContainer)
    CellNetSignal:showInterface(conNetSignal)
end

--@brief    设置wifi信号图标的可见与否
function WndBottomBar:setWifiSignalVisible(bVisible)
    -- body
    GetElement(self.m_root, "conNetSignal_WndBottomBar", WZUIContainer):setVisible(bVisible)
end

--适配iphoneX
function WndBottomBar:_AdaptationIphoneX()
    -- body
    WZLog("WndBottomBar:_AdaptationIphoneX")
    if IsIphoneX() then
        local conLeft = GetElement(self.m_root,"conLeft_WndBottomBar",WZUIContainer)
        conLeft:setRelativePosition(GlobalMethod:ccp(0.01,0.0040625))

        local conRight = GetElement(self.m_root,"conRight_WndBottomBar",WZUIContainer)
        conRight:setRelativePosition(GlobalMethod:ccp(0.980208,1))
    end
end

--@brief    发送点击展开导航栏事件
function WndBottomBar:_postClickSwitchEvent()
    -- body
    local level = CacheCenter:getPlayerInfo().level
    if level == 3 or level == 4 or level == 8 then 
        local eventKey = PostPlayerEvent["event_clickSwitch" .. level]
        if eventKey then 
            PostPlayerEvent:postEvent(eventKey)    
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
