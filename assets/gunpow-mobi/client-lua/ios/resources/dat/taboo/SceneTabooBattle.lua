--SceneTabooBattle.lua
--@brief	SceneTabooBattle的UI模块
--@date		2017/04/21
--@note		禁忌之地场景


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneTabooBattle:onEnter(element)
    WZLog("SceneTabooBattle:onEnter",self.m_nChapterId)
	self.m_root = element
    self:addTop()
    ProtocolProcessorTaboo:regAll()
    ProtocolProcessorTaboo:send_ZONE_GetZoneInfo(self.m_nChapterId)

    -- CacheCenter:registerUpatePlayerItemObserver(self)--注册物品

    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    AdaptLanguage(self)
    -- self:_initView()

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(49)
    WZLog("WndMounts:onReturnClick two", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 28 then
        TeachGroup1:endTeachStep({49,3})
        TeachGroup1:startGroup({49,4,self.m_root})
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneTabooBattle:onExit(element)
	WZLog("SceneTabooBattle:onExit")
    g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}

    ProtocolProcessorTaboo:unregAll()
    -- CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
end

--@brief    缓存推送更新物品时调用的函数
function SceneTabooBattle:updatePlayerItemData()
    WZLog("SceneTabooBattle:updatePlayerItemData")
    if self.m_root ~= nil then
        self:_updateDiceNumView()
    end
end


--@brief	触摸函数，判断消息是否在消息框显示范围内，如果不是的话，就让消息框不显示，反之，显示
--@param #1	element:表绑定的UI节点引用
--@param #2	point:点击位置
function SceneTabooBattle:onTouchBegan(element, point)
	WZLog("SceneTabooBattle:onTouchBegan")
	if self.m_root == nil then 
		WZLog("WndFriend:onTouchBegan(element, point) self.m_root is nil ")
	end 
    local bPoint = WndItemInfo:checkPoint(point)
    if bPoint == true then
    else 
        WndItemInfo:_onCloseClick()
    end
end


--@brief 骰子按钮点击
function SceneTabooBattle:onTabooBtnClick()
    WZLog("SceneTabooBattle:onTabooBtnClick")
    --self:_showTabooBtnActoin()
    if CacheCenter:getPlayerItemCountById(60) <= 0 then
        WndBuyActivity:showBuyInterface(60)
        return
    end
    CacheCenter:changePlayerItemCountById(60,-1)
    self:_updateDiceNumView()

    self:isOpenLockedScene(false)
    ProtocolProcessorTaboo:send_ZONE_RollDice(self.m_nChapterId )
    SoundManager:playEffectSound(SoundDefine.E_S_TABOO_DICE)
    TeachGroup1:endTeachStep({49,4})
    
end

--@brief 提示按钮点击
function SceneTabooBattle:onBtnRuleClick()
    WZLog("SceneTabooBattle:onBtnRuleClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.TABOO_DESC)
end

--@brief 锁屏
function SceneTabooBattle:isOpenLockedScene(value)
    if not self.m_root then
        return
    end
    self.m_bIsInMoveAction = not value
    self:setTopGoldUpdateState(value)
    self.m_tTopHangle:setTopTouchEnable(value)
    
    GetElement(self.m_root,"conBtnTaboo_SceneTabooBattle",WZUIContainer):setTouchEnable(value)
    GetElement(self.m_root,"conBox_SceneTabooBattle",WZUIContainer):setTouchEnable(value)
end

--@brief 
function SceneTabooBattle:setTopGoldUpdateState(value)
    if self.m_tTopHangle.goldCellInfo.tcell then
        self.m_tTopHangle.goldCellInfo.tcell:setUpdateState(value)
    end
end


--@brief 宝箱领取动画显示
function SceneTabooBattle:showBoxSpineView(id)
    WZLog("SceneTabooBattle:showBoxSpineView",id)
    if not self.m_root or not SceneTabooBattle.g_currentBoxId then
        return
    end

    self.m_spineBox = GetElement(self.m_root,"spineBox_SceneTabooBattle",WZUISpine)
    local template = GDatatab_item["id_"..SceneTabooBattle.g_currentBoxId]
    local index = template.quality

    local con = GetElement(self.m_root,"conBoxSpine_SceneTabooBattle",WZUIContainer)
    con:setVisible(true)
    con:enableSchedule("updateSpine")
    self.m_spineBox:play("box"..index.."_open", false)
    SoundManager:playEffectSound(SoundDefine.E_MUSIC_ADDSTAR)
    SceneTabooBattle.g_currentBoxId = nil
end
--@brief 宝箱领取动画播放
function SceneTabooBattle:updateSpine(element,dt)
    if self.m_spineBox:isCurrentAnimationDone() then
        element:setVisible(false)
        element:disableSchedule()
        if SceneTabooBattle.g_rewardIds and SceneTabooBattle.g_nums then
            WndRewardShow:showById(SceneTabooBattle.g_rewardIds,SceneTabooBattle.g_nums)
            self:updateTopHandlerNum()
            if self.m_bExtraBoxOpen then
                self.m_bExtraBoxOpen = nil
                WndRewardShow:closeCallBack(self,self.tipCallBack)
            end

            SceneTabooBattle.g_rewardIds = nil
            SceneTabooBattle.g_nums = nil
        end
    end
    
end
--@brife 宝箱领取动画播放领取奖励界面 关闭回调(有溢出宝箱 才有回调)
function SceneTabooBattle:tipCallBack()
    GetElement(self.m_root,"conBoxReward_SceneTabooBattle",WZUIContainer):setVisible(true)
    self.m_imgBoxReward:setVisible(true)
end

--@brief 播放获得宝箱动画
function SceneTabooBattle:onBtnGetClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    GetElement(self.m_root,"conBoxReward_SceneTabooBattle",WZUIContainer):setVisible(false)

    self.m_imgBoxReward:setScale(1)
    local index = 1
    for i = 1, #self.m_tBoxList do
        local tmpData = self.m_tBoxList[i].m_tData
        if not tmpData then
            index = i
            break
        end
    end

    local sequence = WZUIActionSequence:create()
    sequence:setFinishLuaFunction("_onActionFinishBack")

    local scaleTo1 = WZUIActionScaleTo:create()
    scaleTo1:setDuration(0.2)
    scaleTo1:setScaleX(1.1)
    scaleTo1:setScaleY(1.1)

    local actionDelay = WZUIActionDelayTime:create()
    actionDelay:setDuration(0.4)

    local actionSpawn = WZUIActionSpawn:create()

    local moveTo = WZUIActionMoveToPosition:create()
    local tx,ty = GetElement(self.m_root,string.format("conBox%d_SceneTabooBattle",index),WZUIContainer):getPosition()
    moveTo:setPosition(GlobalMethod:ccp(tx,ty))
    moveTo:setDuration(0.35)

    local scaleTo2 = WZUIActionScaleTo:create()
    scaleTo2:setDuration(0.35)
    scaleTo2:setScaleX(0.48)
    scaleTo2:setScaleY(0.48)

    actionSpawn:setChildAction(moveTo)
    actionSpawn:setChildAction(scaleTo2)

    sequence:setChildAction(scaleTo1)
    sequence:setChildAction(actionDelay)
    sequence:setChildAction(actionSpawn)

    self.m_imgBoxReward:stopAllActions()
    self.m_imgBoxReward:runUIAction(sequence)

end

--@brief 刷新导航栏 货币信息
function SceneTabooBattle:updateTopHandlerNum()
    if self.m_tTopHangle and self.m_tTopHangle.goldCellInfo and self.m_tTopHangle.goldCellInfo.tcell then
        if not self.m_tTopHangle.goldCellInfo.tcell.m_bUpdateState then
            --事件处理完毕手动刷新（先开放接口刷新ui）再关闭
            SceneTabooBattle:setTopGoldUpdateState(true)
            self.m_tTopHangle.goldCellInfo.tcell:getStartInfoList()
            SceneTabooBattle:setTopGoldUpdateState(false)
        else
            self.m_tTopHangle.goldCellInfo.tcell:getStartInfoList()
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------




-------------------------------------私有方法模块Begin--------------------------------------

--@brief 初始化卡牌
function SceneTabooBattle:_initView()
    if self.m_tCardList then
        return
    end
    local template = GDatatab_forbidden_chapter["id_"..self.m_nChapterId] or GDatatab_forbidden_chapter["id_1"]

    GetElement(self.m_root,"imgBg_SceneTabooBattle",WZUIImage):setFile(template.bg)
    local dirList = template.dirList[1]
    local viewList = template.viewList[1]
    -- local dirList = {
    -- 0,2,2,2,2,2,2,2,2,
    -- 4,4,1,1,3,1,1,4,1,
    -- 1,3,1,1,4,4,4,2,3,
    -- 2,4,2,3,2,2,2,2,2
    -- }
    -- local viewList = {
    -- 1,2,3,2,2,2,3,3,2,
    -- 3,3,2,0,3,2,2,6,2,
    -- 3,5,3,2,3,4,2,2,3,
    -- 2,3,2,2,3,2,2,2,2,
    -- 2,3,2,2
    -- }
   

    self.m_tCardList = {}
    local conCard = GetElement(self.m_root,"conCard_SceneTabooBattle",WZUIContainer)
    local conBg = GetElement(self.m_root,"conBg_SceneTabooBattle",WZUIContainer)


    local bx,by = 0.049,0.891 --背景起点
    local dx = 0.112
    local dy = 0.209
    
    local fs,fy = 0.047,0.919 --起点
    local sPosIndex = template.startIndex
    local sx,sy = fs + ((sPosIndex - 1)%9) * dx, fy - math.floor((sPosIndex-1)/9) * dy
   
    --初始化路径
    local imgRotale = {180,0,270,90}
    local dirRes = {[0] = {0,0},[1] = {-1,0},[2] = {1,0},[3] = {0,1},[4] = {0,-1}} --方向对照表左,右,上,下
    
    local bgIndex = sPosIndex
    local bgIndexList = {}
    for i = 1,#dirList do

        local dirIndex = dirList[i]
        local celElement,tCell =  CellTabooCard:createElement()
        local tCoef = dirRes[dirIndex]
        local tx,ty = sx + tCoef[1] * dx,sy + tCoef[2] * dy
        celElement:setRelativePosition(GlobalMethod:ccp(tx,ty))
        conCard:addChild(celElement)
        table.insert(self.m_tCardList,tCell)

        bgIndex = bgIndex + tCoef[1] - tCoef[2]*9
        bgIndexList[bgIndex] = bgIndex
        --设置格子背景 和前进后退方向

        local imgPath = ""
        if viewList[bgIndex] ~=0 then
            imgPath = "ui/taboo/jinjiBg_"..viewList[bgIndex]..".png"--viewImgPath[viewList[bgIndex]]
        end
        tCell:setBgFile(imgPath)
        local back = 0
        if dirIndex == 1 then
            back = 2
        elseif dirIndex == 2 then
            back = 1
        elseif dirIndex == 3 then
            back = 4
        elseif dirIndex == 4 then
            back = 3
        end
        tCell:setDirData(back,dirList[i + 1])
        WZLog("bgIndex",bgIndex,i,viewList[bgIndex])

        --初始化箭头方向
        if i ~= 1 then
            local imgDir = WZUIImage:create()
            imgDir:setUseOriginSize(true)
            imgDir:setFile("ui/taboo/jinji_jiantou.png")
            imgDir:setRotation(imgRotale[dirIndex])
            local tImgX,tImgY = sx + tCoef[1] * dx/2,sy + tCoef[2] * dy/2
            imgDir:setRelativePosition(GlobalMethod:ccp(tImgX,tImgY))
            conCard:addChild(imgDir)
        end
        sx,sy = tx,ty
    end

    --初始化背景
    for i = 1,#viewList do
        -- WZLog("viewList",i,viewList[i])
        if not bgIndexList[i] and viewList[i] ~= 0 then
            local imgPath = "ui/taboo/jinjiBg_"..viewList[i]..".png"
            if imgPath then
                local tx,ty = bx + ((i - 1)%9) * dx, by - math.floor((i-1)/9) * dy
                local imgItemBg = WZUIImage:create()
                imgItemBg:setUseOriginSize(true)
                imgItemBg:setFile(imgPath)
                imgItemBg:setRelativePosition(ccp(tx,ty))
                conBg:addChild(imgItemBg)
            end
        end
    end


    self.m_tBoxList = {}

    --初始化宝箱
    for i = 1,3 do
        local celElement,tCell =  CellTabooBox:createElement()
        GetElement(self.m_root,string.format("conBox%d_SceneTabooBattle",i),WZUIContainer):addChild(celElement)
        table.insert(self.m_tBoxList,tCell)
    end

    --箱子动画
    self.m_imgBoxReward = GetElement(self.m_root,"imgBoxReward_SceneTabooBattle",WZUIImage)
    self.m_imgBoxReward:setVisible(false)
    GetElement(self.m_root,"conBoxReward_SceneTabooBattle",WZUIContainer):setVisible(false)

    --头像 
    local conStep = GetElement(self.m_root,"conStepFlag_SceneTabooBattle",WZUIContainer)
    local head = nil
    local face = nil
    local sex =  CacheCenter:getPlayerInfo().sex
    local color, bcolor = CacheCenter:getHeadAndBodyColor()
    local tEquip = CacheCenter:getEquipmentList()
    for i = 1, #tEquip do
        local nEquipId = tEquip[i]
        if nEquipId ~= nil then
            if type(nEquipId) == "table" then nEquipId = nEquipId.id end
            local tEquipData = GetItemLocalData(nEquipId)

            if tEquipData then
                local maintype = tEquipData.main_type
                local subtype = tEquipData.sub_type
                if maintype == 5 and subtype == 1 then --物品是否是脸谱
                    face = (tEquipData.id)
                elseif maintype == 5 and subtype == 0 then -- 物品是否是头部 
                    head = (tEquipData.id)
                end
            end
        end
    end
    if sex == 1 then
        head = head and head or 4906
        face = face and face or 4905
    else
        head = head and head or 4903
        face = face and face or 4902
    end
    WZLog("==============",tostring(head),tostring(face),tostring(sex),tostring(color))
    local headAnim, headObj = CellHead:show(conStep,head,face,sex,false,nil,nil,color)
    headAnim:setScale(0.9)

    -- local headAnim = CellHead:show(conStep,head,face,sex,false,nil,nil,color,"ui/city/beta/common_scale9_zhezhaoheidifx02.png", 1)
    -- headAnim:setScale(0.9)
end

--@brief 更新界面
function SceneTabooBattle:_updateView()
    WZLog("SceneTabooBattle:_updateView")
    self:_initView()
    SceneTabooBattle:isOpenLockedScene(false)

    self:_updateEventView(self.m_tData.eventIndex,self.m_tData.eventCellId)
    self:_updateBoxView(self.m_tData.boxIndex,self.m_tData.boxId,self.m_tData.boxStatus,self.m_tData.boxCountdown)
    self:_updateDiceView(self.m_tData.diceResumeCountdown)
    self:_updateStepView(true)

    -- self:_checkEvent()
end

--@brief 刷新事件
function SceneTabooBattle:_updateEventView(eventIndex,eventCellId)
    WZLog("SceneTabooBattle:_updateEventView",self.m_nCurrentStep)
    for i = 1,#self.m_tCardList do
        local tCell = self.m_tCardList[i]
        tCell:setData(nil)
    end
    for i = 1,#eventIndex do
        local cellId = eventIndex[i] + 1
        local eventId = eventCellId[i]
        local tCell = self.m_tCardList[cellId]
        tCell:setData({id = eventId})
    end
    if self.m_bReset == true then
        self.m_bReset = false
        self:_flipCard(true)
    else
        self:_flipCard(false)
    end
end

--@brief 刷新箱子状态
function SceneTabooBattle:_updateBoxView(boxIndex,boxId,boxStatus,boxCountdown)
    if #boxIndex > 1 then
        for i = 1,#boxIndex - 1 do
            for j = 1,#boxIndex - i do
                if boxIndex[j] > boxIndex[j + 1] then
                    local tmpIndex = boxIndex[j]
                    boxIndex[j] = boxIndex[j + 1]
                    boxIndex[j + 1] = tmpIndex

                    local tmpId = boxId[j]
                    boxId[j] = boxId[j + 1]
                    boxId[j + 1] = tmpId

                    local tmpState = boxStatus[j]
                    boxStatus[j] = boxStatus[j + 1]
                    boxStatus[j + 1] = tmpState
                end
            end
        end
    end
    WZLog("SceneTabooBattle:_updateBoxView-2\n",Serialize(boxIndex),Serialize(boxId),Serialize(boxStatus))

    for k = 1,3 do
        tCell = self.m_tBoxList[k]
        local isEmpty = true
        for i = 1,#boxIndex do
            WZLog("SceneTabooBattle:_updateBoxView",i,boxIndex[i])
            if k == boxIndex[i] + 1 then

                WZLog("SceneTabooBattle:_updateBoxView-two",boxIndex[i],boxStatus[i],boxCountdown)
                local data = {}
                data.boxIndex = boxIndex[i]
                data.boxId = boxId[i]
                data.boxStatus = boxStatus[i]
                data.boxCountdown = boxCountdown
                tCell:updateData(data)

                if WndTabooBoxOpen:getBoxIndex() == data.boxIndex then
                    WndTabooBoxOpen:updateData(data)
                end
                isEmpty = false
            end
        end

        if isEmpty then
            tCell:updateData(nil)
        end
        
    end
end

--@brief 刷新骰子
function SceneTabooBattle:_updateDiceView(rushTime)
    self.m_nRushTime = rushTime or 0 

    if self.m_nRushTime > 0 then
        GetElement(self.m_root,"conDiceCountDown_SceneTabooBattle",WZUIContainer):setVisible(true)
        self.m_root:enableSchedule("_updateRushTime",0)
    else
        self.m_root:disableSchedule()
        GetElement(self.m_root,"conDiceCountDown_SceneTabooBattle",WZUIContainer):setVisible(false)
    end
    --获得骰子回调 刷新状态
    if not self.m_bIsInMoveAction then
        self:_updateDiceNumView()
    end
end

--@brief 刷新骰子
function SceneTabooBattle:_updateDiceNumView()
    self:updateTopHandlerNum()
    GetElement(self.m_root,"labBtnTaboo_SceneTabooBattle",WZUILabelTTF):setText(CacheCenter:getPlayerItemCountById(60).."/"..CacheCenter:getTabooCoinMaxNum())
end

--@brief 刷新骰子时间
function SceneTabooBattle:_updateRushTime(element,dt)
    if self.m_nRushTime then
        self.m_nRushTime = self.m_nRushTime - dt
        if self.m_nRushTime > 0 then
            -- local sNextTime = LocalStrings.TABOO_DICE_RUSH .. returnToTimeFormat(math.floor(self.m_nRushTime))
            local min = math.floor(self.m_nRushTime/60)
            local sec = self.m_nRushTime - 60*min
            local sNextTime = LocalStrings.TABOO_DICE_RUSH .. string.format("%02d",min) ..":"..string.format("%02d",sec)
            GetElement(self.m_root,"labDiceCountDown_SceneTabooBattle",WZUILabelTTF):setText(sNextTime)
        else
            self.m_nRushTime = nil
            self.m_root:disableSchedule()
            GetElement(self.m_root,"conDiceCountDown_SceneTabooBattle",WZUIContainer):setVisible(false)
            ProtocolProcessorTaboo:send_ZONE_GetDiceStatus()
        end
    end
end

--@brief 翻牌
function SceneTabooBattle:_flipCard(isAction)
    if isAction then
        self.m_nFilpCount = 0
        GetElement(self.m_root,"conCard_SceneTabooBattle",WZUIContainer):enableSchedule("_flipCardLoop",0.03)
    else
        for i = 1,#self.m_tCardList do
            self.m_tCardList[i]:flipCard(true)
        end
        self:_checkEvent()
    end
end

--@brief 翻牌动画
function SceneTabooBattle:_flipCardLoop(element,dt)
    WZLog("SceneTabooBattle:_flipCardLoop",self.m_nFilpCount)
    local filpIndex = self.m_nFilpCount + 1
    if filpIndex > #self.m_tCardList then
        element:disableSchedule()
        self:_checkEvent()
        return
    end

    local tCell = self.m_tCardList[filpIndex]
    tCell:flipCard(true)
    SoundManager:playEffectSound(SoundDefine.E_S_TABOO_RESET)
    self.m_nFilpCount = filpIndex
end

--@brief 骰子动画
function SceneTabooBattle:_showTabooBtnActoin()
    GetElement(self.m_root,"btnTaboo_SceneTabooBattle",WZUIButton):setVisible(false)

    self.m_spine = GetElement(self.m_root,"spineTaboo_SceneTabooBattle",WZUISpine)
    self.m_spine:setVisible(true)
    self.m_spine:play("roll",false)

    self.m_imgSpine = GetElement(self.m_root,"imgSpineTaboo_SceneTabooBattle",WZUIImage)
    self.m_imgSpine:setVisible(false)
    self.m_nTabooRunTime = 0.5
    GetElement(self.m_root,"conSpine_SceneTabooBattle",WZUIContainer):enableSchedule("_spineTabooLoop",0)
end

--@brief 骰子动画播放
function SceneTabooBattle:_spineTabooLoop(element,dt)
    if self.m_nImgSpineDelay then
        self.m_nImgSpineDelay = self.m_nImgSpineDelay - dt
        if self.m_nImgSpineDelay < 0 then
            element:disableSchedule()

            self.m_nImgSpineDelay = nil
            self.m_imgSpine:setVisible(false)
            self.m_imgSpine = nil

            self:_updateTabooBtnView(self.m_nMoveStepNum)
            self:_moveStep()
        end
        return
    end

    self.m_nTabooRunTime = self.m_nTabooRunTime - dt 
    if self.m_spine and self.m_nTabooRunTime <= 0 then
        self.m_spine:setVisible(false)
        self.m_spine = nil

        self.m_nImgSpineDelay = 0.5
        self.m_imgSpine:setVisible(true)
        self.m_imgSpine:setFile(self:_getTabooImgPath(self.m_nMoveStepNum))
    end
end

--@brief 骰子刷新
function SceneTabooBattle:_updateTabooBtnView(index)
    GetElement(self.m_root,"btnTaboo_SceneTabooBattle",WZUIButton):setVisible(true)

    local path = self:_getTabooImgPath(index)
    GetElement(self.m_root,"btnTabooNor_SceneTabooBattle",WZUIImage):setFile(path)
    GetElement(self.m_root,"btnTabooSel_SceneTabooBattle",WZUIImage):setFile(path)
end


--@brief 骰子图片
function SceneTabooBattle:_getTabooImgPath(index)
    local path = "ui/taboo/common_icon_shaizi01.png"
    if index >= 1 and index <= 6 then
        path = string.format("ui/taboo/common_icon_shaizi0%d.png",index)
    end
    return path
end

--@brief 刷新当前位置
function SceneTabooBattle:_updateStepView(isRush)
    SoundManager:playEffectSound(SoundDefine.E_S_TABOO_MOVE)

    local conStep = GetElement(self.m_root,"conStepFlag_SceneTabooBattle",WZUIContainer)
    local tCell = self.m_tCardList[self.m_nCurrentStep]
    if tCell then
        if isRush then
            local tx,ty = tCell.m_root:getPosition()
            conStep:setAbsPosition(GlobalMethod:ccp(tx,ty))
            GetElement(self.m_root,"spineStepFlag_SceneTabooBattle",WZUISpine):setVisible(true)
        else
            local sequence = WZUIActionSequence:create()
            sequence:setFinishLuaFunction("_onMoveFinishBack")
            local moveTo = WZUIActionMoveToPosition:create()
            local tx,ty =tCell.m_root:getPosition()
            WZLog("_updateStepView",tx,ty)
            moveTo:setPosition(GlobalMethod:ccp(tx,ty))
            moveTo:setDuration(0.36)
            sequence:setChildAction(moveTo)
            conStep:stopAllActions()
            conStep:runUIAction(sequence)

            return
        end
    end
end

--@brief 移动位置结束
function SceneTabooBattle:_onMoveFinishBack(element)
    WZLog("SceneTabooBattle:_onMoveFinishBack")
    if self.m_nMoveStepNum == 0 then
        self:_checkEvent()
        GetElement(self.m_root,"spineStepFlag_SceneTabooBattle",WZUISpine):setVisible(true)
        return
    end
    self:_moveStep()
end

--@brief 移动位置
function SceneTabooBattle:_moveStep()
    GetElement(self.m_root,"spineStepFlag_SceneTabooBattle",WZUISpine):setVisible(false)
    WZLog("SceneTabooBattle:_moveStep",self.m_nCurrentStep)
    if self.m_nMoveStepNum > 0 then
        self.m_nMoveStepNum = self.m_nMoveStepNum - 1
        self.m_nCurrentStep = self.m_nCurrentStep + 1
    elseif self.m_nMoveStepNum < 0 then
        self.m_nMoveStepNum = self.m_nMoveStepNum + 1
        self.m_nCurrentStep = self.m_nCurrentStep - 1
        if self.m_nCurrentStep == 1 then
            self.m_nMoveStepNum = 0 
        end
    end

    --步伐结束 或者走到终点
    if self.m_nMoveStepNum == 0 or self:_isEndGame() then
        self.m_nMoveStepNum = 0
    end
    --刷新位置        
    self:_updateStepView()

end

--@brief 移动位置刷新
function SceneTabooBattle:_updateMoveStep(element,dt)
    self.m_nMoveStepDelay = self.m_nMoveStepDelay - dt
    if self.m_nMoveStepDelay < 0 then
        self.m_nMoveStepDelay = 0.5
        WZLog("self.m_nMoveStepNum",self.m_nMoveStepNum)
        --前进后退区分
        if self.m_nMoveStepNum > 0 then
            self.m_nMoveStepNum = self.m_nMoveStepNum - 1
            self.m_nCurrentStep = self.m_nCurrentStep + 1
        elseif self.m_nMoveStepNum < 0 then
            self.m_nMoveStepNum = self.m_nMoveStepNum + 1
            self.m_nCurrentStep = self.m_nCurrentStep - 1
        end

        local isEnd = false
        --步伐结束 或者走到终点
        if self.m_nMoveStepNum == 0 or self:_isEndGame() then
            self.m_nMoveStepNum = 0
            element:disableSchedule()
            isEnd = true
        end
        --刷新位置        
        self:_updateStepView()
    end
end

--@brief 是否走到终点
function SceneTabooBattle:_isEndGame()
    if self.m_tCardList and self.m_nCurrentStep >= #self.m_tCardList then
        return true
    end
    return false
end



--@brief 处理事件
function SceneTabooBattle:_doCellEvent(event)
    WZLog("SceneTabooBattle:_doCellEvent",Serialize(event))
    eventType = event.eventType
    if eventType == TabooEventType.Battle then
        self:_doBattle(event)
    elseif eventType == TabooEventType.Reward then
        self:_doReward(event)
    elseif eventType == TabooEventType.Box then
        self:_doBox(event)
    elseif eventType == TabooEventType.AddItem then
        self:_doAddItem(event)
    elseif eventType == TabooEventType.Advance then
        self:_doAdvance(event)
    elseif eventType == TabooEventType.Back then
        self:_doBack(event)
    elseif eventType == TabooEventType.Trans then
        self:_doTrans(event)
    elseif eventType == TabooEventType.BoxRush then
        self:_doBoxRush(event)
    else
        --随机事件
        self:_doRandom(event)
    end

end

function SceneTabooBattle:_checkEvent()
    if SceneTabooBattle.g_jsonParam and #SceneTabooBattle.g_jsonParam > 0 then
        local event = SceneTabooBattle.g_jsonParam[1]
        table.remove(SceneTabooBattle.g_jsonParam,1)
        self:_doCellEvent(event)
        return
    end
    
    self:_updateDiceNumView()

    --额外奖励
    if SceneTabooBattle.g_extraBoxId and SceneTabooBattle.g_extraBoxId > 0 then
        WndTabooBoxOpen:show({boxId = SceneTabooBattle.g_extraBoxId},2)
        WndTabooBoxOpen:setCallBack(self,self._checkEvent)
        SceneTabooBattle.g_extraBoxId = nil
        return
    end
    --重置副本
    if SceneTabooBattle.g_eventIndex then
        self.m_nCurrentStep = 1
        self.m_bReset = true
        self:_updateStepView(true)
        self:_updateEventView(SceneTabooBattle.g_eventIndex,SceneTabooBattle.g_eventCellId)
        SceneTabooBattle.g_eventIndex = nil
        SceneTabooBattle.g_eventCellId = nil
        return
    end
    SceneTabooBattle:isOpenLockedScene(true)
end

--@brief 战斗
function SceneTabooBattle:_doBattle(event)
    -- do 
    --     self:_checkEvent()
    --     return 
    -- end
    GlobalGame.g_nSingleCopyType = BattleConstants.g_tBossBattleMode.MODE_NORMAL_TABOO
    ProtocolProcessorSingleMap:regAll()
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(event.param,1)
end
--@brief 获得奖励
function SceneTabooBattle:_doReward(event)
    local ids,nums = SplitItemString(event.param)
    WndRewardShow:showById(ids,nums)
    WndRewardShow:closeCallBack(self,self._checkEvent)
    self:updateTopHandlerNum()
end
--@brief 获得箱子
function SceneTabooBattle:_doBox(event)
    SoundManager:playEffectSound(SoundDefine.E_S_USE_ITEM)
    self.m_nBoxId = event.param
    self.m_nClearBoxIndex = nil 
    if SceneTabooBattle.g_normalBoxStatus == 0 then
        --格子足够
        -- ProtocolProcessorTaboo:send_ZONE_GetBoxInfo()
        -- self:_checkEvent()
        self:_doBoxAction(true)
    elseif SceneTabooBattle.g_normalBoxStatus == 1 then
        --格子不足
        local data = nil
        --已解锁
        for i = 1, #self.m_tBoxList do
            local tmpData = self.m_tBoxList[i].m_tData
            if tmpData and tmpData.boxStatus == 3 then
                data = tmpData
                self.m_nClearBoxIndex = i
                break
            end
        end
        --解锁中
        if data == nil then
            for i = 1, #self.m_tBoxList do
                local tmpData = self.m_tBoxList[i].m_tData
                if tmpData and tmpData.boxStatus == 2 then
                    data = tmpData
                    self.m_nClearBoxIndex = i
                    break
                end
            end
        end

        --未解锁
        if data == nil then
            data = self.m_tBoxList[1].m_tData
            self.m_nClearBoxIndex = 1
        end

        if data then
            WndTabooBoxOpen:show(data,3)
            WndTabooBoxOpen:setCallBack(self,self._doBoxAction)
        else
            --容错
            self._checkEvent()
        end

    elseif SceneTabooBattle.g_normalBoxStatus == 2 then
        --格子不足自动放弃
        MsgBoxManager:showTipBox(LocalStrings.TABOO_BOX_OUT,nil,nil,nil,nil,nil,nil,nil,true)
        self:_checkEvent()
    end
end

--@brief 箱子动画
function SceneTabooBattle:_doBoxAction(isAction)
    WZLog("SceneTabooBattle:_doBoxAction",tostring(isAction),self.m_nBoxId)
    if not isAction then
        self:_checkEvent()
        return
    end
    --清理当前格子(额外宝箱)
    if self.m_nClearBoxIndex then
        self.m_tBoxList[self.m_nClearBoxIndex]:updateData(nil)
        self.m_nClearBoxIndex = nil
        GetElement(self.m_root,"conBoxReward_SceneTabooBattle",WZUIContainer):setVisible(false)
        self.m_imgBoxReward:setVisible(false)
        self.m_bExtraBoxOpen = true
    else
        GetElement(self.m_root,"conBoxReward_SceneTabooBattle",WZUIContainer):setVisible(true)
        self.m_imgBoxReward:setVisible(true)
    end
    self.m_imgBoxReward:setScale(1)
    local size = GetElement(self.m_root,"conShowAll_SceneTabooBattle",WZUIContainer):getContentSize()
    self.m_imgBoxReward:setAbsPosition(GlobalMethod:ccp(size.width/2,size.height/2))
    local template =  GDatatab_item["id_"..self.m_nBoxId]
    local imgPath = ""
    if template then
        imgPath = template.icon
    end
    self.m_imgBoxReward:setFile(imgPath)
end

--@brief 物品动画结束
function SceneTabooBattle:_onActionFinishBack(element)
    WZLog("SceneTabooBattle:_onActionFinishBack")
    self.m_imgBoxReward:setVisible(false)
    -- GetElement(self.m_root,"conBoxReward_SceneTabooBattle",WZUIContainer):setVisible(false)
    ProtocolProcessorTaboo:send_ZONE_GetBoxInfo()
    self:_checkEvent()
end

--@brief 增加道具
function SceneTabooBattle:_doAddItem(event)
    --刷新显示
    MsgBoxManager:showTipBox(string.format(LocalStrings.TABOO_EVENT_1,tonumber(event.param)),nil,nil,nil,nil,nil,nil,nil,true)
    -- ProtocolProcessorTaboo:send_ZONE_GetDiceStatus()
    self:_checkEvent()
end
--@brief 前进
function SceneTabooBattle:_doAdvance(event)
    MsgBoxManager:showTipBox(string.format(LocalStrings.TABOO_EVENT_2,tonumber(event.param)),nil,nil,nil,nil,nil,nil,nil,true)
    self.m_nMoveStepNum = event.param
    self:_moveStep()
end
--@brief 后退
function SceneTabooBattle:_doBack(event)
    MsgBoxManager:showTipBox(string.format(LocalStrings.TABOO_EVENT_3,tonumber(event.param)),nil,nil,nil,nil,nil,nil,nil,true)
    self.m_nMoveStepNum = -event.param
    self:_moveStep()
end
--@brief 传送
function SceneTabooBattle:_doTrans(event)
    MsgBoxManager:showTipBox(string.format(LocalStrings.TABOO_EVENT_4,tonumber(event.param + 1)),nil,nil,nil,nil,nil,nil,nil,true)
    self.m_nCurrentStep = event.param + 1
    self:_updateStepView(true)
    self:_checkEvent()

    -- body
end

--@brief 刷新箱子
function SceneTabooBattle:_doBoxRush(event)
    MsgBoxManager:showTipBox(LocalStrings.TABOO_EVENT_5,nil,nil,nil,nil,nil,nil,nil,true)
    ProtocolProcessorTaboo:send_ZONE_GetBoxInfo()
    self:_checkEvent()
end

--@brief 随机事件
function SceneTabooBattle:_doRandom()
    self:_checkEvent()
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function SceneTabooBattle:_adaptLanguage_en(  )
    GetElement(self.m_root,"labDiceCountDown_SceneTabooBattle",WZUILabelTTF):setScale(0.8)
end

function SceneTabooBattle:_adaptLanguage_pt(  )
    local labDice = GetElement(self.m_root,"labDiceCountDown_SceneTabooBattle",WZUILabelTTF)
    labDice:setScale(0.8)
    labDice:setDimensions(GlobalMethod:CCSize(160,0))
end

function SceneTabooBattle:_adaptLanguage_es(  )
    local labDice = GetElement(self.m_root,"labDiceCountDown_SceneTabooBattle",WZUILabelTTF)
    labDice:setScale(0.8)
    labDice:setDimensions(GlobalMethod:CCSize(160,0))
end

function SceneTabooBattle:_adaptLanguage_tr(  )
    local labDice = GetElement(self.m_root,"labDiceCountDown_SceneTabooBattle",WZUILabelTTF)
    labDice:setScale(0.8)
    labDice:setDimensions(GlobalMethod:CCSize(160,0))
end
---------------------------------------语言适配End------------------------------------------